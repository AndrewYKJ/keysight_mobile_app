import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:keysight_pma/cache/appcache.dart';
import 'package:keysight_pma/const/appcolors.dart';
import 'package:keysight_pma/const/appfonts.dart';
import 'package:keysight_pma/const/constants.dart';
import 'package:keysight_pma/const/utils.dart';
import 'package:keysight_pma/dio/api/oee.dart';
import 'package:keysight_pma/dio/api/sort_filter.dart';
import 'package:keysight_pma/model/arguments/oee_argument.dart';
import 'package:keysight_pma/model/arguments/sort_filter_argument.dart';
import 'package:keysight_pma/model/oee/oeeDowntime.dart';
import 'package:keysight_pma/model/sortAndFilter/equipment.dart';
import 'package:keysight_pma/model/sortAndFilter/projects.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

import '../../../routes/approutes.dart';

class OeeDtmScreen extends StatefulWidget {
  const OeeDtmScreen({Key? key}) : super(key: key);

  @override
  State<OeeDtmScreen> createState() => _OeeDtmScreen();
}

class _OeeDtmScreen extends State<OeeDtmScreen> {
  double columnChildWidgetHeight = 410.0;
  double chartWTNHeight = 316.0;
  double chartVOHeight = 316.0;
  bool isLoading = true;
  late WebViewPlusController summaryUtilAndNonUtil;
  late WebViewPlusController detailBreakdown;
  DownTimeMonitoringDTO2 summaryUtilAndNonUtilData = DownTimeMonitoringDTO2();
  DownTimeMonitoringDTO detailBreakdownData = DownTimeMonitoringDTO();
  String? timeLine;

  bool? theme_dark = AppCache.sortFilterCacheDTO!.currentTheme;
  Future<DownTimeMonitoringDTO2> getListOfDownTimeByCompanySiteEqAndDateRange(
      BuildContext context) {
    OeeApi oeeApi = OeeApi(context);
    return oeeApi.getListOfDownTimeByCompanySiteEqAndDateRange(
        AppCache.sortFilterCacheDTO!.preferredCompany!,
        AppCache.sortFilterCacheDTO!.preferredSite!,
        // AppCache.sortFilterCacheDTO!.defaultEquipments![0].equipmentId!,
        AppCache.sortFilterCacheDTO!.preferredEquipments!.equipmentId!,
        DateFormat("yyyy-MM-dd")
            .format(AppCache.sortFilterCacheDTO!.startDate!),
        DateFormat("yyyy-MM-dd").format(AppCache.sortFilterCacheDTO!.endDate!),
        'Date');
  }

  Future<DownTimeMonitoringDTO>
      getListOfDownTimeDetailsByCompanySiteEqAndDateRange(
          BuildContext context) {
    OeeApi oeeApi = OeeApi(context);
    return oeeApi.getListOfDownTimeDetailsByCompanySiteEqAndDateRange(
        AppCache.sortFilterCacheDTO!.preferredCompany!,
        AppCache.sortFilterCacheDTO!.preferredSite!,
        // AppCache.sortFilterCacheDTO!.defaultEquipments![0].equipmentId!,
        AppCache.sortFilterCacheDTO!.preferredEquipments!.equipmentId!,
        DateFormat("yyyy-MM-dd")
            .format(AppCache.sortFilterCacheDTO!.startDate!),
        DateFormat("yyyy-MM-dd").format(AppCache.sortFilterCacheDTO!.endDate!),
        'Date');
  }

  Future<ProjectsDTO> loadProjectList(BuildContext ctx) {
    SortFilterApi sortFilterApi = SortFilterApi(ctx);
    return sortFilterApi.loadProjectList(
        AppCache.sortFilterCacheDTO!.preferredCompany!,
        AppCache.sortFilterCacheDTO!.preferredSite!);
  }

  Future<EquipmentDTO> loadEquipments(BuildContext ctx) {
    SortFilterApi sortFilterApi = SortFilterApi(ctx);
    return sortFilterApi.loadEquipments(
        AppCache.sortFilterCacheDTO!.preferredCompany!,
        AppCache.sortFilterCacheDTO!.preferredSite!);
  }

  @override
  void initState() {
    super.initState();
    // if (AppCache.sortFilterCacheDTO!.dtmPreferredRange != null) {
    //   setState(() {
    //     timeLine = AppCache.sortFilterCacheDTO!.dtmPreferredRange;
    //   });
    // } else {
    //   AppCache.sortFilterCacheDTO!.dtmPreferredRange = 'Date';
    //   timeLine = 'Date';
    // }
    Utils.setFirebaseAnalyticsCurrentScreen(
        Constants.ANALYTICS_OEE_DOWNTIME_MONITOR_SCREEN);
    if (AppCache.sortFilterCacheDTO!.preferredEquipments == null) {
      callLoadEquipments(context);
    }
    if (AppCache.sortFilterCacheDTO != null &&
        Utils.isNotEmpty(AppCache.sortFilterCacheDTO!.preferredProjectId)) {
      if (AppCache.sortFilterCacheDTO!.preferredProjectId!.contains('<')) {
        List<String> splitedList =
            AppCache.sortFilterCacheDTO!.preferredProjectId!.split('<');
        AppCache.sortFilterCacheDTO!.defaultProjectId = splitedList[0];
        AppCache.sortFilterCacheDTO!.displayProjectName = splitedList[0];
        if (Utils.isNotEmpty(splitedList[1])) {
          AppCache.sortFilterCacheDTO!.defaultVersion = splitedList[1];
        } else {
          AppCache.sortFilterCacheDTO!.defaultVersion = 'Base';
        }
      }
      callAllData(context);
    } else {
      if (Utils.isNotEmpty(AppCache.sortFilterCacheDTO!.defaultProjectId)) {
        if (AppCache.sortFilterCacheDTO!.defaultEquipments == null ||
            AppCache.sortFilterCacheDTO!.defaultEquipments!.length == 0) {
          callLoadEquipments(context);
        } else if (AppCache.sortFilterCacheDTO!.preferredEquipments == null) {
          AppCache.sortFilterCacheDTO!.preferredEquipments =
              AppCache.sortFilterCacheDTO!.defaultEquipments![0];
        } else {
          callAllData(context);
        }
      } else {
        callLoadProjectList(context);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  callLoadProjectList(BuildContext context) async {
    await loadProjectList(context).then((value) {
      if (value.data != null && value.data!.length > 0) {
        AppCache.sortFilterCacheDTO!.defaultProjectId =
            value.data![0].projectId!;
        AppCache.sortFilterCacheDTO!.defaultVersion = 'Base';
        if (Utils.isNotEmpty(value.data![0].projectName)) {
          AppCache.sortFilterCacheDTO!.displayProjectName =
              '${value.data![0].projectName} (${value.data![0].projectId})';
        } else {
          AppCache.sortFilterCacheDTO!.displayProjectName =
              value.data![0].projectId!;
        }
      }
      if (AppCache.sortFilterCacheDTO!.defaultEquipments == null ||
          AppCache.sortFilterCacheDTO!.defaultEquipments!.length == 0) {
        callLoadEquipments(context);
      } else {
        callAllData(context);
      }
    }).catchError((error) {
      setState(() {
        this.isLoading = false;
      });
      if (error is DioError) {
        if (error.response != null) {
          if (error.response!.data != null) {
            Utils.showAlertDialog(
                context,
                Utils.getTranslated(context, 'general_alert_error_title')!,
                error.response!.data['errorMessage'].toString());
          } else {
            Utils.showAlertDialog(
                context,
                Utils.getTranslated(context, 'general_alert_error_title')!,
                Utils.getTranslated(context, 'general_alert_error_message')!);
          }
        } else {
          Utils.showAlertDialog(
              context,
              Utils.getTranslated(context, 'general_alert_error_title')!,
              Utils.getTranslated(context, 'general_alert_error_message')!);
        }
      } else {
        Utils.showAlertDialog(
            context,
            Utils.getTranslated(context, 'general_alert_error_title')!,
            Utils.getTranslated(context, 'general_alert_error_message')!);
      }
    });
  }

  callLoadEquipments(BuildContext context) async {
    await loadEquipments(context).then((value) {
      if (value.data != null && value.data!.length > 0) {
        AppCache.sortFilterCacheDTO!.defaultEquipments = [];

        value.data!.forEach((element) {
          EquipmentDataDTO equipmentDataDTO = EquipmentDataDTO(
              equipmentId: element.equipmentId,
              equipmentName: element.equipmentName,
              isSelected: true);
          AppCache.sortFilterCacheDTO!.defaultEquipments!.add(equipmentDataDTO);
        });
        setState(() {
          AppCache.sortFilterCacheDTO!.preferredEquipments =
              AppCache.sortFilterCacheDTO!.defaultEquipments![0];
        });
      }
      callAllData(context);
    }).catchError((error) {
      Utils.printInfo(error);
      setState(() {
        this.isLoading = false;
      });
      if (error is DioError) {
        if (error.response != null) {
          if (error.response!.data != null) {
            Utils.showAlertDialog(
                context,
                Utils.getTranslated(context, 'general_alert_error_title')!,
                error.response!.data['errorMessage'].toString());
          } else {
            Utils.showAlertDialog(
                context,
                Utils.getTranslated(context, 'general_alert_error_title')!,
                Utils.getTranslated(context, 'general_alert_error_message')!);
          }
        } else {
          Utils.showAlertDialog(
              context,
              Utils.getTranslated(context, 'general_alert_error_title')!,
              Utils.getTranslated(context, 'general_alert_error_message')!);
        }
      } else {
        Utils.showAlertDialog(
            context,
            Utils.getTranslated(context, 'general_alert_error_title')!,
            Utils.getTranslated(context, 'general_alert_error_message')!);
      }
    });
  }

  callAllData(BuildContext context) async {
    await getListOfDownTimeByCompanySiteEqAndDateRange(context).then((value) {
      summaryUtilAndNonUtilData = value;

      // print(AppCache.sortFilterCacheDTO!.defaultEquipments![0].equipmentId!);
      //  print(summaryUtilAndNonUtilData.data![0]);
    }).catchError((error) {
      Utils.printInfo(error);
    });
    await getListOfDownTimeDetailsByCompanySiteEqAndDateRange(context)
        .then((value) {
      detailBreakdownData = value;
      // print(AppCache.sortFilterCacheDTO!.defaultEquipments![0].equipmentId!);
      //  print(summaryUtilAndNonUtilData.data![0]);
    }).catchError((error) {
      Utils.printInfo(error);
    });
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    //  print(detailBreakdownData.data![1]![1].status);
    return SafeArea(
      child: Stack(
        children: [
          isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppColors.appBlue()),
                  ),
                )
              : Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  padding: EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        summaryforUtilandNonUtil(context),
                        detailBreakdownforscedulesNonUtilTime(context),
                      ],
                    ),
                  ),
                ),
          Align(
            alignment: Alignment.bottomCenter,
            child: TextButton(
              onPressed: () async {
                final result = await Navigator.pushNamed(
                  context,
                  AppRoutes.sortAndFilterRoute,
                  arguments: SortFilterArguments(
                    menuType: Constants.HOME_MENU_OEE,
                    currentTab: 2,
                  ),
                );
                print('return Data');
                print(result);
                if (result != null && result as bool) {
                  setState(() {
                    isLoading = true;
                    callAllData(context);
                  });
                }
              },
              child: Container(
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50.0),
                  color: AppColors.appTeal(),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(Constants.ASSET_IMAGES + 'filter_icon.png'),
                    SizedBox(width: 10.0),
                    Text(
                      Utils.getTranslated(context, 'sort_and_filter')!,
                      style: AppFonts.robotoMedium(
                        14,
                        color: AppColors.appPrimaryWhite(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget summaryforUtilandNonUtil(BuildContext ctx) {
    // print('ere');
    // print(summaryUtilAndNonUtilData
    //     .data!['2022-05-06']!.unscheduledUtilizationTime);
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          ctx,
          AppRoutes.oeeDashboardChartDetailRoute,
          arguments: OeeChartDetailArguments(
            chartName:
                Utils.getTranslated(ctx, 'oee_summary_for_util_and_non_util')!,
            summaryUtilAndNonUtilData: summaryUtilAndNonUtilData,
            dataType: Constants.CHART_OEE_DTM_SUMMARY,
          ),
        );
        // if (result != null) {
        //   setState(() {
        //     this.summaryUtilAndNonUtil.webViewController.reload();
        //     this.detailBreakdown.webViewController.reload();
        //     isLoading = true;
        //     timeLine = AppCache.sortFilterCacheDTO!.dtmPreferredRange;
        //     callAllData(context);
        //   });
        // }
      },
      child: Container(
        width: MediaQuery.of(ctx).size.width,
        height: 471,
        padding: EdgeInsets.fromLTRB(14.0, 18.0, 14.0, 18.0),
        decoration: BoxDecoration(
            color: theme_dark!
                ? AppColors.appBlackLight()
                : AppColors.appPrimaryWhite(),
            border: Border.all(
              color: theme_dark!
                  ? AppColors.appBlackLight()
                  : AppColors.appGreyDE(),
            )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              Utils.getTranslated(ctx, 'oee_summary_for_util_and_non_util')!,
              style: AppFonts.sfproMedium(
                14,
                color: theme_dark!
                    ? AppColors.appGrey2()
                    : AppColorsLightMode.appGrey(),
                decoration: TextDecoration.none,
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: columnChildWidgetHeight,
              color: theme_dark!
                  ? AppColors.appBlackLight()
                  : AppColors.appPrimaryWhite(),
              child: (summaryUtilAndNonUtilData.data != null &&
                      summaryUtilAndNonUtilData.data!.length > 0)
                  ? WebViewPlus(
                      backgroundColor: Colors.transparent,
                      javascriptMode: JavascriptMode.unrestricted,
                      initialUrl: theme_dark!
                          ? 'assets/html/oee_highchart_dark_theme.html'
                          : 'assets/html/oee_highchart_light_theme.html',
                      zoomEnabled: false,
                      onWebViewCreated: (controllerPlus) {
                        this.summaryUtilAndNonUtil = controllerPlus;
                      },
                      onPageFinished: (url) {
                        this.summaryUtilAndNonUtil.getHeight().then((value) {
                          Utils.printInfo(value);
                          setState(() {
                            this.chartVOHeight = value;
                          });
                        });
                      },
                      javascriptChannels: [
                        JavascriptChannel(
                            name: 'OEEChannel',
                            onMessageReceived: (message) {
                              print(message.message);
                              this
                                  .summaryUtilAndNonUtil
                                  .webViewController
                                  .runJavascript(
                                      'fetchSummaryUtilAndNonUtil(${jsonEncode(summaryUtilAndNonUtilData)}, "${DateFormat("yyyy-MM-dd").format(AppCache.sortFilterCacheDTO!.startDate!)}", "${DateFormat("yyyy-MM-dd").format(AppCache.sortFilterCacheDTO!.endDate!)}","Date","${Utils.getTranslated(context, 'oee_sceduledNonUtil')}","${Utils.getTranslated(context, 'oee_sceduledUtil')}","${Utils.getTranslated(context, 'oee_unsceduledNonUtil')}")');
                            }),
                        JavascriptChannel(
                            name: 'OEESummaryUtilAndNonUtil',
                            onMessageReceived: (message) {
                              print(message.message);
                              Navigator.pushNamed(
                                ctx,
                                AppRoutes.oeeDashboardChartDetailRoute,
                                arguments: OeeChartDetailArguments(
                                  chartName: Utils.getTranslated(ctx,
                                      'oee_summary_for_util_and_non_util')!,
                                  summaryUtilAndNonUtilData:
                                      summaryUtilAndNonUtilData,
                                  dataType: Constants.CHART_OEE_DTM_SUMMARY,
                                ),
                              );
                              // if (result != null) {
                              //   setState(() {
                              //     this
                              //         .summaryUtilAndNonUtil
                              //         .webViewController
                              //         .reload();
                              //     this
                              //         .detailBreakdown
                              //         .webViewController
                              //         .reload();
                              //     isLoading = true;
                              //     timeLine = AppCache
                              //         .sortFilterCacheDTO!.dtmPreferredRange;
                              //     callAllData(context);
                              //   });
                              // }
                            }),
                      ].toSet(),
                    )
                  : Center(
                      child: Text(
                        Utils.getTranslated(ctx, 'no_data_available')!,
                        style: AppFonts.robotoRegular(
                          16,
                          color: theme_dark!
                              ? AppColors.appGreyB1()
                              : AppColorsLightMode.appGrey77().withOpacity(0.4),
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget detailBreakdownforscedulesNonUtilTime(BuildContext ctx) {
    // print('ere');
    // print(detailBreakdownData.data!['2022-05-06']![1].status);
    // detailBreakdownData.data!.keys.forEach((key) {
    //   print(key);
    // });
    // for (var x in detailBreakdownData.data!['2022-05-06']!) {
    //   print(x.status);
    // }
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          ctx,
          AppRoutes.oeeDashboardChartDetailRoute,
          arguments: OeeChartDetailArguments(
            chartName: Utils.getTranslated(
                ctx, 'oee_detail_breakdown_for_schedules_non_util_time')!,
            detailBreakdownData: detailBreakdownData,
            dataType: Constants.CHART_OEE_DTM_DETAILBREAKDOWN,
          ),
        );
        // if (result != null) {
        //   setState(() {
        //     this.summaryUtilAndNonUtil.webViewController.reload();
        //     this.detailBreakdown.webViewController.reload();
        //     isLoading = true;
        //     timeLine = AppCache.sortFilterCacheDTO!.dtmPreferredRange;
        //     callAllData(context);
        //   });
        // }
      },
      child: Container(
        width: MediaQuery.of(ctx).size.width,
        height: 471,
        decoration: BoxDecoration(
            color: theme_dark!
                ? AppColors.appBlackLight()
                : AppColors.appPrimaryWhite(),
            border: Border.all(
              color: theme_dark!
                  ? AppColors.appBlackLight()
                  : AppColors.appGreyDE(),
            )),
        margin: EdgeInsets.only(top: 16.0),
        padding: EdgeInsets.fromLTRB(14.0, 18.0, 14.0, 18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              Utils.getTranslated(
                  ctx, 'oee_detail_breakdown_for_schedules_non_util_time')!,
              style: AppFonts.sfproMedium(
                14,
                color: theme_dark!
                    ? AppColors.appGrey2()
                    : AppColorsLightMode.appGrey(),
                decoration: TextDecoration.none,
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: columnChildWidgetHeight,
              color: theme_dark!
                  ? AppColors.appBlackLight()
                  : AppColors.appPrimaryWhite(),
              child: (detailBreakdownData.data != null &&
                      detailBreakdownData.data!.length > 0)
                  ? WebViewPlus(
                      backgroundColor: Colors.transparent,
                      javascriptMode: JavascriptMode.unrestricted,
                      initialUrl: theme_dark!
                          ? 'assets/html/oee_highchart_dark_theme.html'
                          : 'assets/html/oee_highchart_light_theme.html',
                      zoomEnabled: false,
                      onWebViewCreated: (controllerPlus) {
                        this.detailBreakdown = controllerPlus;
                      },
                      onPageFinished: (url) {
                        this.detailBreakdown.getHeight().then((value) {
                          Utils.printInfo(value);
                          setState(() {
                            this.chartVOHeight = value;
                          });
                        });
                      },
                      javascriptChannels: [
                        JavascriptChannel(
                            name: 'OEEChannel',
                            onMessageReceived: (message) {
                              print(message.message);
                              this.detailBreakdown.webViewController.runJavascript(
                                  'fetchdetailBreakdownforscedulesNonUtilTime(${jsonEncode(this.detailBreakdownData)}, "${DateFormat("yyyy-MM-dd").format(AppCache.sortFilterCacheDTO!.startDate!)}", "${DateFormat("yyyy-MM-dd").format(AppCache.sortFilterCacheDTO!.endDate!)}","Date","${Utils.getTranslated(context, 'csv_DIAGNOSTIC_MAINTENANCE')}","${Utils.getTranslated(context, 'csv_IDLE')}","${Utils.getTranslated(context, 'csv_LOST_HEARTBEAT')}","${Utils.getTranslated(context, 'csv_FIXTURE_CHANGE')}","${Utils.getTranslated(context, 'csv_SYSTEM_TILT')}")');
                            }),
                        JavascriptChannel(
                            name: 'OEEDetailBreakdown',
                            onMessageReceived: (message) {
                              print(message.message);
                              Navigator.pushNamed(
                                ctx,
                                AppRoutes.oeeDashboardChartDetailRoute,
                                arguments: OeeChartDetailArguments(
                                  chartName: Utils.getTranslated(ctx,
                                      'oee_detail_breakdown_for_schedules_non_util_time')!,
                                  detailBreakdownData: detailBreakdownData,
                                  dataType:
                                      Constants.CHART_OEE_DTM_DETAILBREAKDOWN,
                                ),
                              );
                              // if (result != null) {
                              //   setState(() {
                              //     this
                              //         .summaryUtilAndNonUtil
                              //         .webViewController
                              //         .reload();
                              //     this
                              //         .detailBreakdown
                              //         .webViewController
                              //         .reload();
                              //     isLoading = true;
                              //     timeLine = AppCache
                              //         .sortFilterCacheDTO!.dtmPreferredRange;
                              //     callAllData(context);
                              //   });
                              // }
                            }),
                      ].toSet(),
                    )
                  : Center(
                      child: Text(
                        Utils.getTranslated(ctx, 'no_data_available')!,
                        style: AppFonts.robotoRegular(
                          16,
                          color: theme_dark!
                              ? AppColors.appGreyB1()
                              : AppColorsLightMode.appGrey77().withOpacity(0.4),
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
