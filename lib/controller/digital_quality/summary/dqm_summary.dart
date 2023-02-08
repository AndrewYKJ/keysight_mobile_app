import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:keysight_pma/cache/appcache.dart';
import 'package:keysight_pma/const/appcolors.dart';
import 'package:keysight_pma/const/appfonts.dart';
import 'package:keysight_pma/const/constants.dart';
import 'package:keysight_pma/const/download.dart';
import 'package:keysight_pma/const/utils.dart';
import 'package:keysight_pma/dio/api/dqm.dart';
import 'package:keysight_pma/model/arguments/dqm_argument.dart';
import 'package:keysight_pma/model/arguments/sort_filter_argument.dart';
import 'package:keysight_pma/model/dqm/custom.dart';
import 'package:keysight_pma/model/dqm/daily_board_volume.dart';
import 'package:keysight_pma/model/dqm/installbase.dart';
import 'package:keysight_pma/model/js/js.dart';
import 'package:keysight_pma/routes/approutes.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

class DigitalQualitySummaryScreen extends StatefulWidget {
  DigitalQualitySummaryScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DigitalQualitySummaryScreen();
  }
}

class _DigitalQualitySummaryScreen extends State<DigitalQualitySummaryScreen> {
  List<DqmXaxisRangeDTO> dqmAxisRangeList = [
    DqmXaxisRangeDTO(
        rangeName: '1M',
        rangeValue: Constants.RANGE_1_MONTH,
        isAvailable: false,
        isSelected: false),
    DqmXaxisRangeDTO(
        rangeName: '3M',
        rangeValue: Constants.RANGE_3_MONTH,
        isAvailable: false,
        isSelected: false),
    DqmXaxisRangeDTO(
        rangeName: '6M',
        rangeValue: Constants.RANGE_6_MONTH,
        isAvailable: false,
        isSelected: false),
    DqmXaxisRangeDTO(
        rangeName: 'YTD',
        rangeValue: Constants.RANGE_YTD,
        isAvailable: true,
        isSelected: false),
    DqmXaxisRangeDTO(
        rangeName: '1Y',
        rangeValue: Constants.RANGE_1_YEAR,
        isAvailable: false,
        isSelected: false),
    DqmXaxisRangeDTO(
        rangeName: 'ALL',
        rangeValue: Constants.RANGE_ALL,
        isAvailable: true,
        isSelected: true),
  ];
  bool isLoading = true;
  InstallbaseNotifDataDTO? installbaseNotifDataDTO;
  DailyBoardVolumeDTO? dailyBoardVolumeDTO;
  double chartFAHeight = 316.0;
  double chartFPYHeight = 316.0;
  double chartFYHeight = 316.0;
  double chartVOHeight = 316.0;
  late WebViewPlusController failureController;
  late WebViewPlusController firstPassController;
  late WebViewPlusController yieldController;
  late WebViewPlusController volumeController;
  late DateTime startDate;
  late DateTime endDate;
  String summarySVG = '';
  bool? isDarkTheme = AppCache.sortFilterCacheDTO!.currentTheme;

  Future<InstallbaseNotifDTO> getInstallbaseNotifBadgeList(
      BuildContext context) {
    DqmApi dqmApi = DqmApi(context);
    return dqmApi.getInstallbaseNotifBadgeList(
        AppCache.sortFilterCacheDTO!.preferredCompany!,
        AppCache.sortFilterCacheDTO!.preferredSite!);
  }

  Future<DailyBoardVolumeDTO> getDailyBoardVolumeBySite(
      BuildContext context, DateTime startDate, DateTime endate) {
    DqmApi dqmApi = DqmApi(context);
    return dqmApi.getDailyBoardVolumeBySite(
        AppCache.sortFilterCacheDTO!.preferredCompany!,
        AppCache.sortFilterCacheDTO!.preferredSite!,
        DateFormat("yyyyMMdd").format(startDate),
        DateFormat("yyyyMMdd").format(endate));
  }

  List<String> getDaysInBetween(DateTime startDate, DateTime endDate) {
    List<String> days = [];
    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      days.add(
          DateFormat('yyyy-MM-dd').format(startDate.add(Duration(days: i))));
    }
    return days;
  }

  @override
  void initState() {
    super.initState();
    Utils.setFirebaseAnalyticsCurrentScreen(
        Constants.ANALYTICS_DQM_SUMMARY_SCREEN);
    FocusManager.instance.primaryFocus?.unfocus();
    callGetData();
  }

  checkRange() {
    int yearsDifference = this.endDate.year - this.startDate.year;

    int monthsDifference = (this.endDate.year - this.startDate.year) * 12 +
        this.endDate.month -
        this.startDate.month;

    if (monthsDifference >= 1) {
      dqmAxisRangeList[0].isAvailable = true;
    } else {
      dqmAxisRangeList[0].isAvailable = false;
    }

    if (monthsDifference >= 3) {
      dqmAxisRangeList[1].isAvailable = true;
    } else {
      dqmAxisRangeList[1].isAvailable = false;
    }

    if (monthsDifference >= 6) {
      dqmAxisRangeList[2].isAvailable = true;
    } else {
      dqmAxisRangeList[2].isAvailable = false;
    }

    if (yearsDifference > 0) {
      dqmAxisRangeList[4].isAvailable = true;
    } else {
      dqmAxisRangeList[4].isAvailable = false;
    }
  }

  callGetData() async {
    await getInstallbaseNotifBadgeList(context).then((value) {
      if (value.status!.statusCode == 200) {
        if (value.data != null) {
          this.installbaseNotifDataDTO = value.data!;
          callDashboardApiFirstTime(context);
        }
      } else {
        if (Utils.isNotEmpty(value.errorMessage)) {
          Utils.showAlertDialog(
              context,
              Utils.getTranslated(context, 'general_alert_error_title')!,
              value.errorMessage!);
        } else {
          Utils.showAlertDialog(
              context,
              Utils.getTranslated(context, 'general_alert_error_title')!,
              Utils.getTranslated(context, 'general_alert_error_message')!);
        }
      }
    }).catchError((error) {
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

  callDashboardApiFirstTime(BuildContext context) async {
    await getDailyBoardVolumeBySite(
            context,
            AppCache.sortFilterCacheDTO!.startDate!,
            AppCache.sortFilterCacheDTO!.endDate!)
        .then((value) {
      if (value.status!.statusCode == 200) {
        this.dailyBoardVolumeDTO = value;
        this.startDate = AppCache.sortFilterCacheDTO!.startDate!;
        this.endDate = AppCache.sortFilterCacheDTO!.endDate!;
        checkRange();
      } else {
        if (Utils.isNotEmpty(value.errorMessage)) {
          Utils.showAlertDialog(
              context,
              Utils.getTranslated(context, 'general_alert_error_title')!,
              value.errorMessage!);
        } else {
          Utils.showAlertDialog(
              context,
              Utils.getTranslated(context, 'general_alert_error_title')!,
              Utils.getTranslated(context, 'general_alert_error_message')!);
        }
      }
    }).catchError((error) {
      Utils.printInfo(error);
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
    }).whenComplete(() {
      setState(() {
        this.isLoading = false;
      });
    });
  }

  callDashboardApi(DateTime startDate, DateTime endDate) async {
    EasyLoading.show(maskType: EasyLoadingMaskType.black);
    await getDailyBoardVolumeBySite(context, startDate, endDate).then((value) {
      if (value.status!.statusCode == 200) {
        setState(() {
          this.dailyBoardVolumeDTO = value;
          this.failureController.webViewController.reload();
          this.firstPassController.webViewController.reload();
          this.yieldController.webViewController.reload();
          this.volumeController.webViewController.reload();
        });
      } else {
        if (Utils.isNotEmpty(value.errorMessage)) {
          Utils.showAlertDialog(
              context,
              Utils.getTranslated(context, 'general_alert_error_title')!,
              value.errorMessage!);
        } else {
          Utils.showAlertDialog(
              context,
              Utils.getTranslated(context, 'general_alert_error_title')!,
              Utils.getTranslated(context, 'general_alert_error_message')!);
        }
      }
    }).catchError((error) {
      Utils.printInfo(error);
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
    }).whenComplete(() {
      EasyLoading.dismiss();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.all(16.0),
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(AppColors.appBlue()),
                ),
              )
            : Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        header(context),
                        qualityMetricRangeSelection(context),
                        qualityMetricFailureChart(context),
                        qualityMetricFirstPassYieldChart(context),
                        qualityMetricYieldChart(context),
                        qualityMetricVolumeChart(context),
                      ],
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
                            menuType: Constants.HOME_MENU_DQM,
                            currentTab: 1,
                          ),
                        );

                        if (result != null && result as bool) {
                          setState(() {
                            this.isLoading = true;
                            callGetData();
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
                            Image.asset(
                                Constants.ASSET_IMAGES + 'filter_icon.png'),
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
      ),
    );
  }

  Widget header(BuildContext ctx) {
    if (this.installbaseNotifDataDTO != null) {
      return Container(
        width: MediaQuery.of(ctx).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              Utils.getTranslated(context, 'this_week')!,
              style: AppFonts.robotoMedium(
                14,
                color: isDarkTheme!
                    ? AppColors.appPrimaryWhite()
                    : AppColorsLightMode.appGrey70(),
                decoration: TextDecoration.none,
              ),
            ),
            SizedBox(height: 17.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                headerItem(
                    ctx,
                    '${this.installbaseNotifDataDTO!.DUTComponentAnomaly}',
                    Utils.getTranslated(ctx, 'dqm_summary_component_anomaly')!,
                    AppColors.appDarkRed()),
                SizedBox(width: 20.0),
                headerItem(
                    ctx,
                    '${this.installbaseNotifDataDTO!.DUTDegradationAnomaly}',
                    Utils.getTranslated(
                        ctx, 'dqm_summary_degradation_anomaly')!,
                    AppColors.appIvoryWhite()),
              ],
            ),
            SizedBox(height: 17.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                headerItem(
                    ctx,
                    '${this.installbaseNotifDataDTO!.DUTLimitChangeAnomaly}',
                    Utils.getTranslated(ctx, 'dqm_summary_limit_change')!,
                    AppColors.appYellowLight()),
                SizedBox(width: 20.0),
                headerItem(
                    ctx,
                    '${this.installbaseNotifDataDTO!.DUTCpkAlertAnomalies}',
                    Utils.getTranslated(ctx, 'dqm_summary_low_cpk')!,
                    AppColors.appYellowLight()),
              ],
            )
          ],
        ),
      );
    }
    return Container();
  }

  Widget headerItem(
      BuildContext ctx, String value, String label, Color bgColor) {
    return Expanded(
      child: Container(
        height: 65.0,
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              value,
              style: AppFonts.robotoBold(
                23,
                color: Colors.black,
                decoration: TextDecoration.none,
              ),
            ),
            Text(
              label,
              style: AppFonts.robotoRegular(
                12,
                color: Colors.black,
                decoration: TextDecoration.none,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget qualityMetricRangeSelection(BuildContext ctx) {
    return Container(
      margin: EdgeInsets.only(top: 34.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  Utils.getTranslated(ctx, 'dqm_summary_quality_metric')!,
                  style: AppFonts.robotoRegular(
                    16,
                    color: isDarkTheme!
                        ? AppColors.appPrimaryWhite()
                        : AppColorsLightMode.appGrey(),
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  showDownloadPopup(ctx);
                },
                child: Image.asset(
                  isDarkTheme!
                      ? Constants.ASSET_IMAGES + 'download_bttn.png'
                      : Constants.ASSET_IMAGES_LIGHT + 'download_bttn.png',
                ),
              )
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 39.0),
            height: 30.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: dqmAxisRangeList.length,
              itemBuilder: (BuildContext listContext, int index) {
                return rangeItem(listContext, dqmAxisRangeList[index], index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget rangeItem(
      BuildContext ctx, DqmXaxisRangeDTO dqmXaxisRangeDTO, int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            if (dqmXaxisRangeDTO.isAvailable!) {
              int yearsDifference = AppCache.sortFilterCacheDTO!.endDate!.year -
                  AppCache.sortFilterCacheDTO!.startDate!.year;

              int monthsDifference =
                  (AppCache.sortFilterCacheDTO!.endDate!.year -
                              AppCache.sortFilterCacheDTO!.startDate!.year) *
                          12 +
                      AppCache.sortFilterCacheDTO!.endDate!.month -
                      AppCache.sortFilterCacheDTO!.startDate!.month;

              // int totalDays = AppCache.sortFilterCacheDTO!.endDate!
              //     .difference(AppCache.sortFilterCacheDTO!.startDate!)
              //     .inDays;

              dqmAxisRangeList.forEach((element) {
                element.isSelected = false;
              });

              if (dqmXaxisRangeDTO.rangeValue == Constants.RANGE_1_MONTH) {
                if (monthsDifference >= 1) {
                  dqmXaxisRangeDTO.isSelected = true;
                  this.startDate = new DateTime(
                    AppCache.sortFilterCacheDTO!.endDate!.year,
                    AppCache.sortFilterCacheDTO!.endDate!.month - 1,
                    AppCache.sortFilterCacheDTO!.endDate!.day,
                  );
                  this.endDate = AppCache.sortFilterCacheDTO!.endDate!;
                  callDashboardApi(this.startDate, this.endDate);
                }
              } else if (dqmXaxisRangeDTO.rangeValue ==
                  Constants.RANGE_3_MONTH) {
                if (monthsDifference >= 3) {
                  dqmXaxisRangeDTO.isSelected = true;
                  this.startDate = new DateTime(
                    AppCache.sortFilterCacheDTO!.endDate!.year,
                    AppCache.sortFilterCacheDTO!.endDate!.month - 2,
                    AppCache.sortFilterCacheDTO!.endDate!.day,
                  );
                  this.endDate = AppCache.sortFilterCacheDTO!.endDate!;
                  callDashboardApi(this.startDate, this.endDate);
                }
              } else if (dqmXaxisRangeDTO.rangeValue ==
                  Constants.RANGE_6_MONTH) {
                if (monthsDifference >= 6) {
                  dqmXaxisRangeDTO.isSelected = true;
                  this.startDate = new DateTime(
                    AppCache.sortFilterCacheDTO!.endDate!.year,
                    AppCache.sortFilterCacheDTO!.endDate!.month - 4,
                    AppCache.sortFilterCacheDTO!.endDate!.day,
                  );
                  this.endDate = AppCache.sortFilterCacheDTO!.endDate!;
                  callDashboardApi(this.startDate, this.endDate);
                }
              } else if (dqmXaxisRangeDTO.rangeValue == Constants.RANGE_YTD) {
                dqmXaxisRangeDTO.isSelected = true;
                this.startDate = new DateTime(
                  AppCache.sortFilterCacheDTO!.endDate!.year,
                  AppCache.sortFilterCacheDTO!.endDate!.month -
                      monthsDifference,
                  1,
                );
                this.endDate = AppCache.sortFilterCacheDTO!.endDate!;
                callDashboardApi(this.startDate, this.endDate);
              } else if (dqmXaxisRangeDTO.rangeValue ==
                  Constants.RANGE_1_YEAR) {
                if (yearsDifference > 0) {
                  dqmXaxisRangeDTO.isSelected = true;
                  this.startDate = new DateTime(
                    AppCache.sortFilterCacheDTO!.endDate!.year - 1,
                    AppCache.sortFilterCacheDTO!.endDate!.month,
                    AppCache.sortFilterCacheDTO!.endDate!.day,
                  );
                  this.endDate = AppCache.sortFilterCacheDTO!.endDate!;
                  callDashboardApi(this.startDate, this.endDate);
                }
              } else {
                dqmXaxisRangeDTO.isSelected = true;
                this.startDate = AppCache.sortFilterCacheDTO!.startDate!;
                this.endDate = AppCache.sortFilterCacheDTO!.endDate!;
                callDashboardApi(this.startDate, this.endDate);
              }
            }
          },
          child: Container(
            width: 60.0,
            padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
            decoration: BoxDecoration(
              color:
                  dqmXaxisRangeDTO.isAvailable! && dqmXaxisRangeDTO.isSelected!
                      ? AppColors.appPrimaryYellow()
                      : !dqmXaxisRangeDTO.isAvailable!
                          ? AppColors.appMediumGrey()
                          : Colors.transparent,
              border:
                  dqmXaxisRangeDTO.isAvailable! && dqmXaxisRangeDTO.isSelected!
                      ? Border.all(color: Colors.transparent)
                      : !dqmXaxisRangeDTO.isAvailable!
                          ? Border.all(color: AppColors.appMediumGrey())
                          : Border.all(color: AppColors.appMediumGrey()),
              borderRadius: BorderRadius.circular(50.0),
            ),
            child: Center(
              child: Text(
                dqmXaxisRangeDTO.rangeName!,
                style: AppFonts.sfproBold(
                  11,
                  color: dqmXaxisRangeDTO.isAvailable! &&
                          dqmXaxisRangeDTO.isSelected!
                      ? AppColors.appPrimaryWhite()
                      : isDarkTheme!
                          ? AppColors.appPrimaryWhite()
                          : AppColorsLightMode.appGrey70(),
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          ),
        ),
        index < dqmAxisRangeList.length ? SizedBox(width: 16.0) : Container(),
      ],
    );
  }

  Widget qualityMetricFailureChart(BuildContext ctx) {
    return Container(
      margin: EdgeInsets.only(top: 37.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  Utils.getTranslated(ctx, 'dqm_summary_failure')!,
                  style: AppFonts.robotoMedium(
                    14,
                    color: isDarkTheme!
                        ? AppColors.appPrimaryWhite()
                        : AppColorsLightMode.appGrey(),
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  if (dailyBoardVolumeDTO != null &&
                      dailyBoardVolumeDTO!.data != null &&
                      dailyBoardVolumeDTO!.data!.length > 0) {
                    Navigator.pushNamed(
                      ctx,
                      AppRoutes.dqmSummaryQualityMetricDetailRoute,
                      arguments: DqmSummaryQmArguments(
                        appBarTitle: Utils.getTranslated(
                            ctx, 'dqm_summary_qm_failure_appbar_title'),
                        sumType: Constants.SUMMARY_TYPE_FAILURE,
                      ),
                    );
                  }
                },
                child: Image.asset(isDarkTheme!
                    ? Constants.ASSET_IMAGES + 'next_bttn_withbg.png'
                    : Constants.ASSET_IMAGES_LIGHT + 'next_bttn_withbg.png'),
              ),
            ],
          ),
          (dailyBoardVolumeDTO != null &&
                  dailyBoardVolumeDTO!.data != null &&
                  dailyBoardVolumeDTO!.data!.length > 0)
              ? Container()
              : Container(
                  height: 350,
                  child: Center(
                    child: Text(
                      Utils.getTranslated(ctx, 'no_data_available')!,
                      style: AppFonts.robotoRegular(
                        16,
                        color: isDarkTheme!
                            ? AppColors.appGreyB1()
                            : AppColorsLightMode.appGrey77().withOpacity(0.4),
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: this.chartFAHeight,
            color: Colors.transparent,
            child: WebViewPlus(
              backgroundColor: Colors.transparent,
              javascriptMode: JavascriptMode.unrestricted,
              initialUrl: isDarkTheme!
                  ? 'assets/html/highchart_dark_theme.html'
                  : 'assets/html/highchart_light_theme.html',
              zoomEnabled: false,
              onWebViewCreated: (controllerPlus) {
                this.failureController = controllerPlus;
              },
              onPageFinished: (url) {
                this.failureController.getHeight().then((value) {
                  Utils.printInfo(value);
                  setState(() {
                    if (dailyBoardVolumeDTO != null &&
                        dailyBoardVolumeDTO!.data != null &&
                        dailyBoardVolumeDTO!.data!.length > 0) {
                      this.chartFAHeight = value;
                    } else {
                      this.chartFAHeight = 0;
                    }
                  });
                });
              },
              javascriptChannels: [
                JavascriptChannel(
                    name: 'DQMChannel',
                    onMessageReceived: (message) {
                      print(message.message);
                      if (dailyBoardVolumeDTO != null &&
                          dailyBoardVolumeDTO!.data != null &&
                          dailyBoardVolumeDTO!.data!.length > 0) {
                        this.failureController.webViewController.runJavascript(
                            'fetchSummaryFailureData(${jsonEncode(this.dailyBoardVolumeDTO)}, "${DateFormat("yyyy-MM-dd").format(this.startDate)}", "${DateFormat("yyyy-MM-dd").format(this.endDate)}", ${jsonEncode(getDaysInBetween(this.startDate, this.endDate))})');
                      }
                    }),
                JavascriptChannel(
                    name: 'DQMSumFailureChannel',
                    onMessageReceived: (message) {
                      if (Utils.isNotEmpty(message.message)) {
                        JSMetricQualityDataDTO qmDTO =
                            JSMetricQualityDataDTO.fromJson(
                                jsonDecode(message.message));
                        showTooltipsDialog(ctx, qmDTO);
                      }
                    }),
                JavascriptChannel(
                    name: 'DQMExportImageChannel',
                    onMessageReceived: (message) async {
                      print(message.message);
                      if (Utils.isNotEmpty(message.message)) {
                        //KEYS_BM_DQMBySite_2022-04-01_2022-08-09#2022.08.10@00.18.01
                        String name = 'summaryFailureByProject.png';

                        final result = await ImageApi.generateSummaryImage(
                            message.message,
                            600,
                            this.chartFAHeight.round(),
                            1100,
                            null,
                            null,
                            name);
                        if (result != null && result == true) {}
                      }
                    }),
                JavascriptChannel(
                    name: 'DQMExportPDFChannel',
                    onMessageReceived: (message) async {
                      if (Utils.isNotEmpty(message.message)) {
                        String name = 'summaryFailureByProject.pdf';

                        final result = await PdfApi.generateSummaryPDF(
                            message.message,
                            600,
                            this.chartFAHeight.round(),
                            1100,
                            null,
                            null,
                            name);
                        if (result != null && result == true) {}
                      }
                    }),
              ].toSet(),
            ),
          ),
        ],
      ),
    );
  }

  Widget qualityMetricFirstPassYieldChart(BuildContext ctx) {
    return Container(
      margin: EdgeInsets.only(top: 37.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  Utils.getTranslated(ctx, 'dqm_summary_first_pass_yield')!,
                  style: AppFonts.robotoMedium(
                    14,
                    color: isDarkTheme!
                        ? AppColors.appPrimaryWhite()
                        : AppColorsLightMode.appGrey(),
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  if (dailyBoardVolumeDTO != null &&
                      dailyBoardVolumeDTO!.data != null &&
                      dailyBoardVolumeDTO!.data!.length > 0) {
                    Navigator.pushNamed(
                      ctx,
                      AppRoutes.dqmSummaryQualityMetricDetailRoute,
                      arguments: DqmSummaryQmArguments(
                        appBarTitle: Utils.getTranslated(
                            ctx, 'dqm_summary_qm_first_pass_appbar_title'),
                        sumType: Constants.SUMMARY_TYPE_FIRST_PASS,
                      ),
                    );
                  }
                },
                child: Image.asset(isDarkTheme!
                    ? Constants.ASSET_IMAGES + 'next_bttn_withbg.png'
                    : Constants.ASSET_IMAGES_LIGHT + 'next_bttn_withbg.png'),
              ),
            ],
          ),
          (dailyBoardVolumeDTO != null &&
                  dailyBoardVolumeDTO!.data != null &&
                  dailyBoardVolumeDTO!.data!.length > 0)
              ? Container()
              : Container(
                  height: 350,
                  child: Center(
                    child: Text(
                      Utils.getTranslated(ctx, 'no_data_available')!,
                      style: AppFonts.robotoRegular(
                        16,
                        color: isDarkTheme!
                            ? AppColors.appGreyB1()
                            : AppColorsLightMode.appGrey77().withOpacity(0.4),
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: this.chartFPYHeight,
            color: Colors.transparent,
            child: WebViewPlus(
              backgroundColor: Colors.transparent,
              javascriptMode: JavascriptMode.unrestricted,
              initialUrl: isDarkTheme!
                  ? 'assets/html/highchart_dark_theme.html'
                  : 'assets/html/highchart_light_theme.html',
              zoomEnabled: false,
              onWebViewCreated: (controllerPlus) {
                this.firstPassController = controllerPlus;
              },
              onPageFinished: (url) {
                this.firstPassController.getHeight().then((value) {
                  Utils.printInfo(value);
                  setState(() {
                    if (dailyBoardVolumeDTO != null &&
                        dailyBoardVolumeDTO!.data != null &&
                        dailyBoardVolumeDTO!.data!.length > 0) {
                      this.chartFPYHeight = value;
                    } else {
                      this.chartFPYHeight = 0;
                    }
                  });
                });
              },
              javascriptChannels: [
                JavascriptChannel(
                    name: 'DQMChannel',
                    onMessageReceived: (message) {
                      print(message.message);
                      if (dailyBoardVolumeDTO != null &&
                          dailyBoardVolumeDTO!.data != null &&
                          dailyBoardVolumeDTO!.data!.length > 0) {
                        this.firstPassController.webViewController.runJavascript(
                            'fetchSummaryFirstPassYieldData(${jsonEncode(this.dailyBoardVolumeDTO)}, "${DateFormat("yyyy-MM-dd").format(this.startDate)}", "${DateFormat("yyyy-MM-dd").format(this.endDate)}", ${jsonEncode(getDaysInBetween(this.startDate, this.endDate))})');
                      }
                    }),
                JavascriptChannel(
                    name: 'DQMSumFirstPassChannel',
                    onMessageReceived: (message) {
                      if (Utils.isNotEmpty(message.message)) {
                        JSMetricQualityDataDTO qmDTO =
                            JSMetricQualityDataDTO.fromJson(
                                jsonDecode(message.message));
                        showTooltipsDialog(ctx, qmDTO);
                      }
                    }),
                JavascriptChannel(
                    name: 'DQMExportImageChannel',
                    onMessageReceived: (message) async {
                      print(message.message);
                      if (Utils.isNotEmpty(message.message)) {
                        //KEYS_BM_DQMBySite_2022-04-01_2022-08-09#2022.08.10@00.18.01
                        String name = 'summaryFirstPassByProject.png';

                        final result = await ImageApi.generateSummaryImage(
                            message.message,
                            600,
                            this.chartFAHeight.round(),
                            1100,
                            null,
                            null,
                            name);
                      }
                    }),
                JavascriptChannel(
                    name: 'DQMExportPDFChannel',
                    onMessageReceived: (message) async {
                      if (Utils.isNotEmpty(message.message)) {
                        String name = 'summaryFirstPassByProject.pdf';

                        final result = await PdfApi.generateSummaryPDF(
                            message.message,
                            600,
                            this.chartFAHeight.round(),
                            1100,
                            null,
                            null,
                            name);
                      }
                    }),
              ].toSet(),
            ),
          ),
        ],
      ),
    );
  }

  Widget qualityMetricYieldChart(BuildContext ctx) {
    return Container(
      margin: EdgeInsets.only(top: 37.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  Utils.getTranslated(ctx, 'dqm_summary_yield')!,
                  style: AppFonts.robotoMedium(
                    14,
                    color: isDarkTheme!
                        ? AppColors.appPrimaryWhite()
                        : AppColorsLightMode.appGrey(),
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  if (dailyBoardVolumeDTO != null &&
                      dailyBoardVolumeDTO!.data != null &&
                      dailyBoardVolumeDTO!.data!.length > 0) {
                    Navigator.pushNamed(
                      ctx,
                      AppRoutes.dqmSummaryQualityMetricDetailRoute,
                      arguments: DqmSummaryQmArguments(
                        appBarTitle: Utils.getTranslated(
                            ctx, 'dqm_summary_qm_yield_appbar_title'),
                        sumType: Constants.SUMMARY_TYPE_YIELD,
                      ),
                    );
                  }
                },
                child: Image.asset(
                  isDarkTheme!
                      ? Constants.ASSET_IMAGES + 'next_bttn_withbg.png'
                      : Constants.ASSET_IMAGES_LIGHT + 'next_bttn_withbg.png',
                ),
              ),
            ],
          ),
          (dailyBoardVolumeDTO != null &&
                  dailyBoardVolumeDTO!.data != null &&
                  dailyBoardVolumeDTO!.data!.length > 0)
              ? Container()
              : Container(
                  height: 350,
                  child: Center(
                    child: Text(
                      Utils.getTranslated(ctx, 'no_data_available')!,
                      style: AppFonts.robotoRegular(
                        16,
                        color: isDarkTheme!
                            ? AppColors.appGreyB1()
                            : AppColorsLightMode.appGrey77().withOpacity(0.4),
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: this.chartFYHeight,
            color: Colors.transparent,
            child: WebViewPlus(
              backgroundColor: Colors.transparent,
              javascriptMode: JavascriptMode.unrestricted,
              initialUrl: isDarkTheme!
                  ? 'assets/html/highchart_dark_theme.html'
                  : 'assets/html/highchart_light_theme.html',
              zoomEnabled: false,
              onWebViewCreated: (controllerPlus) {
                this.yieldController = controllerPlus;
              },
              onPageFinished: (url) {
                this.yieldController.getHeight().then((value) {
                  Utils.printInfo(value);
                  setState(() {
                    if (dailyBoardVolumeDTO != null &&
                        dailyBoardVolumeDTO!.data != null &&
                        dailyBoardVolumeDTO!.data!.length > 0) {
                      this.chartFYHeight = value;
                    } else {
                      this.chartFYHeight = 0;
                    }
                  });
                });
              },
              javascriptChannels: [
                JavascriptChannel(
                    name: 'DQMChannel',
                    onMessageReceived: (message) {
                      print(message.message);
                      if (dailyBoardVolumeDTO != null &&
                          dailyBoardVolumeDTO!.data != null &&
                          dailyBoardVolumeDTO!.data!.length > 0) {
                        this.yieldController.webViewController.runJavascript(
                            'fetchSummaryYieldData(${jsonEncode(this.dailyBoardVolumeDTO)}, "${DateFormat("yyyy-MM-dd").format(this.startDate)}", "${DateFormat("yyyy-MM-dd").format(this.endDate)}", ${jsonEncode(getDaysInBetween(this.startDate, this.endDate))})');
                      }
                    }),
                JavascriptChannel(
                    name: 'DQMSumYieldChannel',
                    onMessageReceived: (message) {
                      if (Utils.isNotEmpty(message.message)) {
                        JSMetricQualityDataDTO qmDTO =
                            JSMetricQualityDataDTO.fromJson(
                                jsonDecode(message.message));
                        showTooltipsDialog(ctx, qmDTO);
                      }
                    }),
                JavascriptChannel(
                    name: 'DQMExportImageChannel',
                    onMessageReceived: (message) async {
                      print(message.message);
                      if (Utils.isNotEmpty(message.message)) {
                        //KEYS_BM_DQMBySite_2022-04-01_2022-08-09#2022.08.10@00.18.01
                        String name = 'summaryYieldByProject.png';

                        final result = await ImageApi.generateSummaryImage(
                            message.message,
                            600,
                            this.chartFAHeight.round(),
                            1100,
                            null,
                            null,
                            name);
                      }
                    }),
                JavascriptChannel(
                    name: 'DQMExportPDFChannel',
                    onMessageReceived: (message) async {
                      if (Utils.isNotEmpty(message.message)) {
                        String name = 'summaryYieldByProject.pdf';

                        final result = await PdfApi.generateSummaryPDF(
                            message.message,
                            600,
                            this.chartFAHeight.round(),
                            1100,
                            null,
                            null,
                            name);
                      }
                    }),
              ].toSet(),
            ),
          ),
        ],
      ),
    );
  }

  Widget qualityMetricVolumeChart(BuildContext ctx) {
    return Container(
      margin: EdgeInsets.only(top: 37.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Utils.getTranslated(ctx, 'dqm_summary_volume')!,
            style: AppFonts.robotoMedium(
              14,
              color: isDarkTheme!
                  ? AppColors.appPrimaryWhite()
                  : AppColorsLightMode.appGrey(),
              decoration: TextDecoration.none,
            ),
          ),
          (dailyBoardVolumeDTO != null &&
                  dailyBoardVolumeDTO!.data != null &&
                  dailyBoardVolumeDTO!.data!.length > 0)
              ? Container()
              : Container(
                  height: 350,
                  child: Center(
                    child: Text(
                      Utils.getTranslated(ctx, 'no_data_available')!,
                      style: AppFonts.robotoRegular(
                        16,
                        color: isDarkTheme!
                            ? AppColors.appGreyB1()
                            : AppColorsLightMode.appGrey77().withOpacity(0.4),
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: this.chartVOHeight,
            color: Colors.transparent,
            child: WebViewPlus(
              backgroundColor: Colors.transparent,
              javascriptMode: JavascriptMode.unrestricted,
              initialUrl: isDarkTheme!
                  ? 'assets/html/highchart_dark_theme.html'
                  : 'assets/html/highchart_light_theme.html',
              zoomEnabled: false,
              onWebViewCreated: (controllerPlus) {
                this.volumeController = controllerPlus;
              },
              onPageFinished: (url) {
                this.volumeController.getHeight().then((value) {
                  Utils.printInfo(value);
                  setState(() {
                    if (dailyBoardVolumeDTO != null &&
                        dailyBoardVolumeDTO!.data != null &&
                        dailyBoardVolumeDTO!.data!.length > 0) {
                      this.chartVOHeight = value;
                    } else {
                      this.chartVOHeight = 0;
                    }
                  });
                });
              },
              javascriptChannels: [
                JavascriptChannel(
                    name: 'DQMChannel',
                    onMessageReceived: (message) {
                      print(message.message);
                      if (dailyBoardVolumeDTO != null &&
                          dailyBoardVolumeDTO!.data != null &&
                          dailyBoardVolumeDTO!.data!.length > 0) {
                        this.volumeController.webViewController.runJavascript(
                            'fetchSummaryVolumeData(${jsonEncode(this.dailyBoardVolumeDTO)}, "${DateFormat("yyyy-MM-dd").format(this.startDate)}", "${DateFormat("yyyy-MM-dd").format(this.endDate)}", ${jsonEncode(getDaysInBetween(this.startDate, this.endDate))})');
                      }
                    }),
                JavascriptChannel(
                    name: 'DQMSumVolumeChannel',
                    onMessageReceived: (message) {
                      if (Utils.isNotEmpty(message.message)) {
                        JSMetricQualityDataDTO qmDTO =
                            JSMetricQualityDataDTO.fromJson(
                                jsonDecode(message.message));
                        showTooltipsDialog(ctx, qmDTO);
                      }
                    }),
                JavascriptChannel(
                    name: 'DQMExportImageChannel',
                    onMessageReceived: (message) async {
                      print(message.message);
                      if (Utils.isNotEmpty(message.message)) {
                        //KEYS_BM_DQMBySite_2022-04-01_2022-08-09#2022.08.10@00.18.01
                        String name = 'summaryVolumeByProject.png';

                        final result = await ImageApi.generateSummaryImage(
                            message.message,
                            600,
                            this.chartFAHeight.round(),
                            1100,
                            null,
                            null,
                            name);
                        if (result != null && result == true) {
                          setState(() {
                            // print('################## hihi');
                            isLoading = false;
                            var snackBar = SnackBar(
                              content: Text(
                                Utils.getTranslated(
                                    context, 'done_download_as_image')!,
                                style: AppFonts.robotoRegular(
                                  16,
                                  color: isDarkTheme!
                                      ? AppColors.appGrey()
                                      : AppColors.appGrey(),
                                  decoration: TextDecoration.none,
                                ),
                              ),
                              backgroundColor: AppColors.appBlack0F(),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          });
                        }
                      }
                    }),
                JavascriptChannel(
                    name: 'DQMExportPDFChannel',
                    onMessageReceived: (message) async {
                      if (Utils.isNotEmpty(message.message)) {
                        String name = 'summaryVolumeByProject.pdf';

                        final result = await PdfApi.generateSummaryPDF(
                            message.message,
                            600,
                            this.chartFAHeight.round(),
                            1100,
                            null,
                            null,
                            name);
                        if (result != null && result == true) {
                          setState(() {
                            // print('################## hihi');
                            isLoading = false;
                            var snackBar = SnackBar(
                              content: Text(
                                Utils.getTranslated(
                                    context, 'done_download_as_pdf')!,
                                style: AppFonts.robotoRegular(
                                  16,
                                  color: isDarkTheme!
                                      ? AppColors.appGrey()
                                      : AppColors.appGrey(),
                                  decoration: TextDecoration.none,
                                ),
                              ),
                              backgroundColor: AppColors.appBlack0F(),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          });
                        }
                      }
                    }),
              ].toSet(),
            ),
          ),
        ],
      ),
    );
  }

  void showTooltipsDialog(BuildContext context, JSMetricQualityDataDTO qmDTO) {
    showDialog(
      context: context,
      builder: (tooltipsDialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: chartTooltipsInfo(context, qmDTO),
        );
      },
    );
  }

  Widget chartTooltipsInfo(BuildContext ctx, JSMetricQualityDataDTO qmDTO) {
    return Container(
      padding: EdgeInsets.fromLTRB(14.0, 12.0, 14.0, 12.0),
      decoration: BoxDecoration(
        color: AppColors.appBlack2C(),
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            DateFormat("EEEE, MMM dd, yyyy")
                .format(DateTime.parse(qmDTO.date!)),
            style: AppFonts.robotoMedium(
              14,
              color: AppColors.appPrimaryWhite(),
              decoration: TextDecoration.none,
            ),
          ),
          SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  '${Utils.getTranslated(ctx, 'dqm_summary_failure')}: ',
                  style: AppFonts.robotoMedium(
                    14,
                    color: HexColor('e3032a'),
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  '${qmDTO.failed}',
                  style: AppFonts.robotoRegular(
                    16,
                    color: isDarkTheme!
                        ? AppColors.appGrey2()
                        : AppColorsLightMode.appGrey2(),
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  '${Utils.getTranslated(ctx, 'dqm_summary_first_pass_yield')}:',
                  style: AppFonts.robotoMedium(
                    14,
                    color: HexColor('14979c'),
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  '${qmDTO.firstPass!.toStringAsFixed(2)}',
                  style: AppFonts.robotoRegular(
                    16,
                    color: isDarkTheme!
                        ? AppColors.appGrey2()
                        : AppColorsLightMode.appGrey2(),
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  '${Utils.getTranslated(ctx, 'dqm_summary_yield')}:',
                  style: AppFonts.robotoMedium(
                    14,
                    color: HexColor('0c6540'),
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  '${qmDTO.finalYield!.toStringAsFixed(2)}',
                  style: AppFonts.robotoRegular(
                    16,
                    color: isDarkTheme!
                        ? AppColors.appGrey2()
                        : AppColorsLightMode.appGrey2(),
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  '${Utils.getTranslated(ctx, 'dqm_summary_volume')}:',
                  style: AppFonts.robotoRegular(
                    16,
                    color: HexColor('d6ddd3'),
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  '${qmDTO.volume}',
                  style: AppFonts.robotoRegular(
                    16,
                    color: isDarkTheme!
                        ? AppColors.appGrey2()
                        : AppColorsLightMode.appGrey2(),
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void showDownloadPopup(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext popContext) => CupertinoActionSheet(
        actions: [
          Container(
            color: isDarkTheme!
                ? AppColors.cupertinoBackground()
                : AppColorsLightMode.cupertinoBackground().withOpacity(0.8),
            child: CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(popContext);
                this
                    .failureController
                    .webViewController
                    .runJavascript('exportImage()');

                this
                    .firstPassController
                    .webViewController
                    .runJavascript('exportImage()');

                this
                    .yieldController
                    .webViewController
                    .runJavascript('exportImage()');

                this
                    .volumeController
                    .webViewController
                    .runJavascript('exportImage()');
              },
              child: Text(
                Utils.getTranslated(context, 'download_as_image')!,
                style: AppFonts.robotoRegular(
                  15,
                  color: isDarkTheme!
                      ? AppColors.appPrimaryWhite().withOpacity(0.8)
                      : AppColorsLightMode.appGrey(),
                  decoration: TextDecoration.none,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Container(
            color: isDarkTheme!
                ? AppColors.cupertinoBackground()
                : AppColorsLightMode.cupertinoBackground().withOpacity(0.8),
            child: CupertinoActionSheetAction(
              onPressed: () async {
                Navigator.pop(popContext);

                var object = [];
                String name = ".csv";

                name = 'dqmSummaryFailure.csv';
                dailyBoardVolumeDTO!.data!.forEach((element) {
                  object.add({
                    "date": element.date,
                    "Failure": (element.failed),
                    "First Pass (%)": ((element.firstPass! /
                            (element.firstPass! +
                                element.rework! +
                                element.failed!)) *
                        100),
                    "Yield (%)": (((element.firstPass! + element.rework!) /
                            (element.firstPass! +
                                element.rework! +
                                element.failed!)) *
                        100),
                    "First Pass": element.firstPass,
                    "Retest": element.rework,
                  });
                });

                final result = await CSVApi.generateSummaryCSV(
                    object, name, 1100, null, null);
                if (result != null && result == true) {
                  setState(() {
                    // print('################## hihi');

                    var snackBar = SnackBar(
                      content: Text(
                        Utils.getTranslated(context, 'done_download_as_csv')!,
                        style: AppFonts.robotoRegular(
                          16,
                          color: isDarkTheme!
                              ? AppColors.appGrey()
                              : AppColors.appGrey(),
                          decoration: TextDecoration.none,
                        ),
                      ),
                      backgroundColor: AppColors.appBlack0F(),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  });
                }
              },
              child: Text(
                Utils.getTranslated(context, 'download_as_csv')!,
                style: AppFonts.robotoRegular(
                  15,
                  color: isDarkTheme!
                      ? AppColors.appPrimaryWhite().withOpacity(0.8)
                      : AppColorsLightMode.appGrey(),
                  decoration: TextDecoration.none,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Container(
            color: isDarkTheme!
                ? AppColors.cupertinoBackground()
                : AppColorsLightMode.cupertinoBackground().withOpacity(0.8),
            child: CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(popContext);
                this
                    .failureController
                    .webViewController
                    .runJavascript('exportPDF()');

                this
                    .firstPassController
                    .webViewController
                    .runJavascript('exportPDF()');

                this
                    .yieldController
                    .webViewController
                    .runJavascript('exportPDF()');

                this
                    .volumeController
                    .webViewController
                    .runJavascript('exportPDF()');
              },
              child: Text(
                Utils.getTranslated(context, 'download_as_pdf')!,
                style: AppFonts.robotoRegular(
                  15,
                  color: isDarkTheme!
                      ? AppColors.appPrimaryWhite().withOpacity(0.8)
                      : AppColorsLightMode.appGrey(),
                  decoration: TextDecoration.none,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
        cancelButton: Container(
          decoration: BoxDecoration(
              color: isDarkTheme!
                  ? AppColors.cupertinoBackground()
                  : AppColorsLightMode.cupertinoBackground(),
              borderRadius: BorderRadius.circular(14)),
          child: CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(popContext);
            },
            child: Text(
              Utils.getTranslated(context, 'cancel')!,
              style: AppFonts.robotoMedium(15,
                  color: isDarkTheme!
                      ? AppColors.appPrimaryWhite()
                      : AppColorsLightMode.appCancelBlue(),
                  decoration: TextDecoration.none),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
