import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:keysight_pma/cache/appcache.dart';
import 'package:keysight_pma/const/appcolors.dart';
import 'package:keysight_pma/const/appfonts.dart';
import 'package:keysight_pma/const/constants.dart';
import 'package:keysight_pma/const/utils.dart';
import 'package:keysight_pma/dio/api/oee.dart';
import 'package:keysight_pma/model/arguments/dqm_argument.dart';
import 'package:keysight_pma/model/arguments/oee_argument.dart';
import 'package:keysight_pma/model/arguments/sort_filter_argument.dart';
import 'package:keysight_pma/model/oee/oeeAvailability.dart';
import 'package:keysight_pma/model/oee/oeeEquipment.dart';
import 'package:keysight_pma/routes/approutes.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

class OeeDashboardScreen extends StatefulWidget {
  final TabController? tabController;
  OeeDashboardScreen({Key? key, this.tabController}) : super(key: key);

  @override
  State<OeeDashboardScreen> createState() => _OeeDashboardScreen();
}

class _OeeDashboardScreen extends State<OeeDashboardScreen> {
  double columnChildWidgetHeight = 420.0;
  double chartVOHeight = 420.0;
  double chartVO2Height = 420.0;
  double chartVO3Height = 420.0;
  double chartVO5Height = 420.0;
  double chartVO4Height = 420.0;

  double chartFPYHeight = 420.0;
  double chartFPYPHeight = 420.0;
  double chartVPHeight = 420.0;
  double chartWTNHeight = 420.0;
  bool isLoading = true;
  late WebViewPlusController dailyVolumeOutputbyEquipmentController;
  late WebViewPlusController dailyVolumeOutputbyProjectController;
  late WebViewPlusController volumeOutputbyEquipmentController;
  late WebViewPlusController volumeOutputbyProjectController;
  late WebViewPlusController getDailyUtilisationbyAllEquipmentController;
  late WebViewPlusController dailyOEEScoreController;
  OeeEquipmentDTO getDailyVolumeByEquipmentData = OeeEquipmentDTO();
  OeeEquipmentDTO getDailyOEEScore = OeeEquipmentDTO();
  OeeEquipmentDTO getDailyVolumeOutputbyProjectData = OeeEquipmentDTO();
  OeeEquipmentDTO volumeOutputbyEquipmentData = OeeEquipmentDTO();
  OeeEquipmentDTO volumeOutputbyProjectData = OeeEquipmentDTO();
  OeeAvailabilityDTO getDailyUtilisationbyAllEquipmentData =
      OeeAvailabilityDTO();

  bool? theme_dark = AppCache.sortFilterCacheDTO!.currentTheme;
  Future<OeeEquipmentDTO> getDailyCountByEquipments(BuildContext context) {
    OeeApi oeeApi = OeeApi(context);
    return oeeApi.getDailyCountByEquipments(
        AppCache.sortFilterCacheDTO!.preferredCompany!,
        AppCache.sortFilterCacheDTO!.preferredSite!,
        DateFormat("yyyyMMdd").format(AppCache.sortFilterCacheDTO!.startDate!),
        DateFormat("yyyyMMdd").format(AppCache.sortFilterCacheDTO!.endDate!));
  }

  Future<OeeEquipmentDTO> getDailyCountByProject(BuildContext context) {
    OeeApi oeeApi = OeeApi(context);
    return oeeApi.getDailyCountByProject(
        AppCache.sortFilterCacheDTO!.preferredCompany!,
        AppCache.sortFilterCacheDTO!.preferredSite!,
        DateFormat("yyyyMMdd").format(AppCache.sortFilterCacheDTO!.startDate!),
        DateFormat("yyyyMMdd").format(AppCache.sortFilterCacheDTO!.endDate!));
  }

  Future<OeeEquipmentDTO> getDailyOEEScoreByEquipments(BuildContext context) {
    OeeApi oeeApi = OeeApi(context);
    return oeeApi.getDailyOEEScoreByEquipments(
        AppCache.sortFilterCacheDTO!.preferredCompany!,
        AppCache.sortFilterCacheDTO!.preferredSite!,
        DateFormat("yyyyMMdd").format(AppCache.sortFilterCacheDTO!.startDate!),
        DateFormat("yyyyMMdd").format(AppCache.sortFilterCacheDTO!.endDate!));
  }

  Future<OeeEquipmentDTO> getVolumeOutputbyEquipment(BuildContext context) {
    OeeApi oeeApi = OeeApi(context);
    return oeeApi.getDailyVolumeByEquipment(
        AppCache.sortFilterCacheDTO!.preferredCompany!,
        AppCache.sortFilterCacheDTO!.preferredSite!,
        DateFormat("yyyyMMdd").format(AppCache.sortFilterCacheDTO!.startDate!),
        DateFormat("yyyyMMdd").format(AppCache.sortFilterCacheDTO!.endDate!));
  }

  Future<OeeEquipmentDTO> getVolumeOutputbyProject(BuildContext context) {
    OeeApi oeeApi = OeeApi(context);
    return oeeApi.getDailyVolumeByProject(
        AppCache.sortFilterCacheDTO!.preferredCompany!,
        AppCache.sortFilterCacheDTO!.preferredSite!,
        DateFormat("yyyyMMdd").format(AppCache.sortFilterCacheDTO!.startDate!),
        DateFormat("yyyyMMdd").format(AppCache.sortFilterCacheDTO!.endDate!));
  }

  Future<OeeAvailabilityDTO> getDailyUtilizationByAllEquipments(
      BuildContext context) {
    OeeApi oeeApi = OeeApi(context);
    return oeeApi.getDailyUtilizationByAllEquipments(
        AppCache.sortFilterCacheDTO!.preferredCompany!,
        AppCache.sortFilterCacheDTO!.preferredSite!,
        DateFormat("yyyyMMdd").format(AppCache.sortFilterCacheDTO!.startDate!),
        DateFormat("yyyyMMdd").format(AppCache.sortFilterCacheDTO!.endDate!));
  }

  @override
  void initState() {
    super.initState();
    Utils.setFirebaseAnalyticsCurrentScreen(
        Constants.ANALYTICS_OEE_DASHBOARD_SCREEN);
    FocusManager.instance.primaryFocus?.unfocus();
    callAllData(context);
  }

  callAllData(BuildContext context) async {
    await getDailyCountByEquipments(context).then((value) {
      getDailyVolumeByEquipmentData = value;
    }).catchError((error) {
      Utils.printInfo(error);
    });
    await getDailyCountByProject(context).then((value) {
      getDailyVolumeOutputbyProjectData = value;
    }).catchError((error) {
      Utils.printInfo(error);
    });
    await getDailyOEEScoreByEquipments(context).then((value) {
      getDailyOEEScore = value;
    }).catchError((error) {
      Utils.printInfo(error);
    });
    await getVolumeOutputbyEquipment(context).then((value) {
      volumeOutputbyEquipmentData = value;
    }).catchError((error) {
      Utils.printInfo(error);
    });
    await getVolumeOutputbyProject(context).then((value) {
      volumeOutputbyProjectData = value;
    }).catchError((error) {
      Utils.printInfo(error);
    });
    await getDailyUtilizationByAllEquipments(context).then((value) {
      getDailyUtilisationbyAllEquipmentData = value;
    }).catchError((error) {
      Utils.printInfo(error);
    });

    setState(() {
      isLoading = false;
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
                        dailyVolumeOutputbyEquipment(context),
                        dailyVolumeOutputbyProject(context),
                        dailyOEEScore(context),
                        volumeOutputbyEquipment(context),
                        volumeOutputbyProject(context),
                        dailyUtilisationbyAllEquipment(context),
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
                            menuType: Constants.HOME_MENU_OEE,
                            currentTab: 0,
                          ),
                        );

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
                            Image.asset(theme_dark!
                                ? Constants.ASSET_IMAGES + 'filter_icon.png'
                                : Constants.ASSET_IMAGES + 'filter_icon.png'),
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

  Widget dailyVolumeOutputbyEquipment(BuildContext ctx) {
    return GestureDetector(
      onTap: () {
        if (getDailyVolumeByEquipmentData.data != null &&
            getDailyVolumeByEquipmentData.data!.length > 0)
          Navigator.pushNamed(
            ctx,
            AppRoutes.oeeDashboardChartDetailRoute,
            arguments: OeeChartDetailArguments(
              currentTab: 1,
              chartName: Utils.getTranslated(
                  ctx, 'oee_daily_Volume_Output_by_Equipment')!,
              equipmentDTO: getDailyVolumeByEquipmentData,
              dataType: Constants.CHART_OEE_DASHBOARD_DAILY_VO_EQUIPMENT,
            ),
          );
      },
      child: Container(
        width: MediaQuery.of(ctx).size.width,
        padding: EdgeInsets.fromLTRB(14.0, 18.0, 14.0, 18.0),
        height: this.columnChildWidgetHeight + 70,
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
              Utils.getTranslated(ctx, 'oee_daily_Volume_Output_by_Equipment')!,
              style: AppFonts.robotoRegular(
                16,
                color: theme_dark!
                    ? AppColors.appGrey2()
                    : AppColorsLightMode.appGrey(),
                decoration: TextDecoration.none,
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: this.columnChildWidgetHeight,
              color: theme_dark!
                  ? AppColors.appBlackLight()
                  : AppColors.appPrimaryWhite(),
              child: (getDailyVolumeByEquipmentData.data != null &&
                      getDailyVolumeByEquipmentData.data!.length > 0)
                  ? WebViewPlus(
                      backgroundColor: Colors.transparent,
                      javascriptMode: JavascriptMode.unrestricted,
                      initialUrl: theme_dark!
                          ? 'assets/html/oee_highchart_dark_theme.html'
                          : 'assets/html/oee_highchart_light_theme.html',
                      zoomEnabled: false,
                      onWebViewCreated: (controllerPlus) {
                        this.dailyVolumeOutputbyEquipmentController =
                            controllerPlus;
                      },
                      onPageFinished: (url) {
                        this
                            .dailyVolumeOutputbyEquipmentController
                            .getHeight()
                            .then((value) {
                          Utils.printInfo(value);
                          setState(() {
                            this.columnChildWidgetHeight = value;
                          });
                        });
                      },
                      javascriptChannels: [
                        JavascriptChannel(
                            name: 'OEEChannel',
                            onMessageReceived: (message) {
                              print(message.message);
                              this
                                  .dailyVolumeOutputbyEquipmentController
                                  .webViewController
                                  .runJavascript(
                                      'fetchDailyVolumeByEquipment(${jsonEncode(this.getDailyVolumeByEquipmentData)}, "${DateFormat("yyyy-MM-dd").format(AppCache.sortFilterCacheDTO!.startDate!)}", "${DateFormat("yyyy-MM-dd").format(AppCache.sortFilterCacheDTO!.endDate!)}")');
                            }),
                        JavascriptChannel(
                            name: 'OEEDailyVolumeByEquipmentChannel',
                            onMessageReceived: (message) {
                              print(message.message);
                              Navigator.pushNamed(
                                ctx,
                                AppRoutes.oeeDashboardChartDetailRoute,
                                arguments: OeeChartDetailArguments(
                                  currentTab: 1,
                                  chartName: Utils.getTranslated(ctx,
                                      'oee_daily_Volume_Output_by_Equipment')!,
                                  equipmentDTO: getDailyVolumeByEquipmentData,
                                  dataType: Constants
                                      .CHART_OEE_DASHBOARD_DAILY_VO_EQUIPMENT,
                                ),
                              );
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

  Widget dailyVolumeOutputbyProject(BuildContext ctx) {
    return GestureDetector(
      onTap: () {
        if (getDailyVolumeOutputbyProjectData.data != null &&
            getDailyVolumeOutputbyProjectData.data!.length > 0)
          Navigator.pushNamed(
            ctx,
            AppRoutes.oeeDashboardChartDetailRoute,
            arguments: OeeChartDetailArguments(
              chartName: Utils.getTranslated(
                  ctx, 'oee_daily_Volume_Output_by_Project')!,
              equipmentDTO: getDailyVolumeOutputbyProjectData,
              dataType: Constants.CHART_OEE_DASHBOARD_DAILY_VO_PROJECT,
            ),
          );
      },
      // onTap: () async {
      //   final result = await Navigator.pushNamed(
      //     ctx,
      //     AppRoutes.oeeDashboardChartDetailRoute,
      //     arguments: OeeChartDetailArguments(
      //       chartName: Utils.getTranslated(
      //           ctx, 'oee_daily_Volume_Output_by_Equipment')!,
      //       equipmentDTO: getDailyVolumeOutputbyProjectData,
      //       dataType: Constants.CHART_OEE_DASHBOARD_DAILY_VO_PROJECT,
      //     ),
      //   );
      //   if (result != getDailyVolumeOutputbyProjectData) {
      //     setState(() {
      //       this
      //           .dailyVolumeOutputbyProjectController
      //           .webViewController
      //           .reload();
      //       getDailyVolumeOutputbyProjectData = result as OeeEquipmentDTO;
      //     });
      //   }
      // },
      //{
      //   Navigator.pushNamed(
      //     ctx,
      //     AppRoutes.oeeDashboardChartDetailRoute,
      //     arguments: OeeChartDetailArguments(
      //       chartName:
      //           Utils.getTranslated(ctx, 'oee_daily_Volume_Output_by_Project')!,
      //       equipmentDTO: getDailyVolumeByEquipmentData,
      //       dataType: Constants.CHART_OEE_DASHBOARD_DAILY_VO_PROJECT,
      //     ),
      //   );
      // },
      child: Container(
        width: MediaQuery.of(ctx).size.width,
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
              Utils.getTranslated(ctx, 'oee_daily_Volume_Output_by_Project')!,
              style: AppFonts.robotoRegular(
                16,
                color: theme_dark!
                    ? AppColors.appGrey2()
                    : AppColorsLightMode.appGrey(),
                decoration: TextDecoration.none,
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: this.chartVOHeight,
              color: theme_dark!
                  ? AppColors.appBlackLight()
                  : AppColors.appPrimaryWhite(),
              child: (getDailyVolumeOutputbyProjectData.data != null &&
                      getDailyVolumeOutputbyProjectData.data!.length > 0)
                  ? WebViewPlus(
                      backgroundColor: Colors.transparent,
                      javascriptMode: JavascriptMode.unrestricted,
                      initialUrl: theme_dark!
                          ? 'assets/html/oee_highchart_dark_theme.html'
                          : 'assets/html/oee_highchart_light_theme.html',
                      zoomEnabled: false,
                      onWebViewCreated: (controllerPlus) {
                        this.dailyVolumeOutputbyProjectController =
                            controllerPlus;
                      },
                      onPageFinished: (url) {
                        this
                            .dailyVolumeOutputbyProjectController
                            .getHeight()
                            .then((value) {
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
                                  .dailyVolumeOutputbyProjectController
                                  .webViewController
                                  .runJavascript(
                                      'fetchDailyVolumeByProject(${jsonEncode(this.getDailyVolumeOutputbyProjectData)}, "${DateFormat("yyyy-MM-dd").format(AppCache.sortFilterCacheDTO!.startDate!)}", "${DateFormat("yyyy-MM-dd").format(AppCache.sortFilterCacheDTO!.endDate!)}")');
                            }),
                        JavascriptChannel(
                            name: 'OEEDailyVolumeByProjectChannel',
                            onMessageReceived: (message) {
                              print(message.message);
                              Navigator.pushNamed(
                                ctx,
                                AppRoutes.oeeDashboardChartDetailRoute,
                                arguments: OeeChartDetailArguments(
                                  chartName: Utils.getTranslated(ctx,
                                      'oee_daily_Volume_Output_by_Equipment')!,
                                  equipmentDTO:
                                      getDailyVolumeOutputbyProjectData,
                                  dataType: Constants
                                      .CHART_OEE_DASHBOARD_DAILY_VO_PROJECT,
                                ),
                              );
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

  Widget dailyOEEScore(BuildContext ctx) {
    return GestureDetector(
      onTap: () {
        if (getDailyOEEScore.data != null && getDailyOEEScore.data!.length > 0)
          Navigator.pushNamed(
            ctx,
            AppRoutes.oeeDashboardChartDetailRoute,
            arguments: OeeChartDetailArguments(
              chartName: Utils.getTranslated(
                  ctx, 'oee_daily_Volume_Output_by_Equipment')!,
              equipmentDTO: getDailyOEEScore,
              dataType: Constants.CHART_OEE_DASHBOARD_DAILY_SCORE_EQUIPMENT,
            ),
          );
      },
      // onTap: () async {
      //   final result = await Navigator.pushNamed(
      //     ctx,
      //     AppRoutes.oeeDashboardChartDetailRoute,
      //     arguments: OeeChartDetailArguments(
      //       chartName: Utils.getTranslated(
      //           ctx, 'oee_daily_Volume_Output_by_Equipment')!,
      //       equipmentDTO: getDailyOEEScore,
      //       dataType: Constants.CHART_OEE_DASHBOARD_DAILY_SCORE_EQUIPMENT,
      //     ),
      //   );
      //   if (result != getDailyOEEScore) {
      //     setState(() {
      //       this.dailyOEEScoreController.webViewController.reload();
      //       getDailyOEEScore = result as OeeEquipmentDTO;
      //     });
      //   }
      // },
      child: Container(
        width: MediaQuery.of(ctx).size.width,
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
              Utils.getTranslated(ctx, 'oee_daily_OEE_Score')!,
              style: AppFonts.robotoRegular(
                16,
                color: theme_dark!
                    ? AppColors.appGrey2()
                    : AppColorsLightMode.appGrey(),
                decoration: TextDecoration.none,
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: this.chartVO2Height,
              color: theme_dark!
                  ? AppColors.appBlackLight()
                  : AppColors.appPrimaryWhite(),
              child: (getDailyOEEScore.data != null &&
                      getDailyOEEScore.data!.length > 0)
                  ? WebViewPlus(
                      backgroundColor: Colors.transparent,
                      javascriptMode: JavascriptMode.unrestricted,
                      initialUrl: theme_dark!
                          ? 'assets/html/oee_highchart_dark_theme.html'
                          : 'assets/html/oee_highchart_light_theme.html',
                      zoomEnabled: false,
                      onWebViewCreated: (controllerPlus) {
                        this.dailyOEEScoreController = controllerPlus;
                      },
                      onPageFinished: (url) {
                        this.dailyOEEScoreController.getHeight().then((value) {
                          Utils.printInfo(value);
                          setState(() {
                            this.chartVO2Height = value;
                          });
                        });
                      },
                      javascriptChannels: [
                        JavascriptChannel(
                            name: 'OEEChannel',
                            onMessageReceived: (message) {
                              print(message.message);
                              this
                                  .dailyOEEScoreController
                                  .webViewController
                                  .runJavascript(
                                      'fetchDailyOEEScore(${jsonEncode(this.getDailyOEEScore)}, "${DateFormat("yyyy-MM-dd").format(AppCache.sortFilterCacheDTO!.startDate!)}", "${DateFormat("yyyy-MM-dd").format(AppCache.sortFilterCacheDTO!.endDate!)}")');
                            }),
                        JavascriptChannel(
                            name: 'OEEDailyScoreOEE',
                            onMessageReceived: (message) {
                              print(message.message);
                              Navigator.pushNamed(
                                ctx,
                                AppRoutes.oeeDashboardChartDetailRoute,
                                arguments: OeeChartDetailArguments(
                                  chartName: Utils.getTranslated(
                                      ctx, 'oee_daily_OEE_Score')!,
                                  equipmentDTO: getDailyOEEScore,
                                  dataType: Constants
                                      .CHART_OEE_DASHBOARD_DAILY_SCORE_EQUIPMENT,
                                ),
                              );
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

  Widget volumeOutputbyEquipment(BuildContext ctx) {
    return GestureDetector(
      onTap: () {
        if (volumeOutputbyEquipmentData.data != null &&
            volumeOutputbyEquipmentData.data!.length > 0)
          Navigator.pushNamed(
            ctx,
            AppRoutes.oeeDashboardChartDetailRoute,
            arguments: OeeChartDetailArguments(
              chartName: Utils.getTranslated(
                  ctx, 'oee_daily_Volume_Output_by_Equipment')!,
              equipmentDTO: volumeOutputbyEquipmentData,
              dataType: Constants.CHART_OEE_DASHBOARD_VO_EQUIPMENT,
            ),
          );
      },
      // onTap: () async {
      //   final result = await Navigator.pushNamed(
      //     ctx,
      //     AppRoutes.oeeDashboardChartDetailRoute,
      //     arguments: OeeChartDetailArguments(
      //       chartName: Utils.getTranslated(
      //           ctx, 'oee_daily_Volume_Output_by_Equipment')!,
      //       equipmentDTO: volumeOutputbyEquipmentData,
      //       dataType: Constants.CHART_OEE_DASHBOARD_VO_EQUIPMENT,
      //     ),
      //   );
      //   if (result != getDailyOEEScore) {
      //     setState(() {
      //       this.volumeOutputbyEquipmentController.webViewController.reload();
      //       volumeOutputbyEquipmentData = result as OeeEquipmentDTO;
      //     });
      //   }
      // },
      child: Container(
        width: MediaQuery.of(ctx).size.width,
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
              Utils.getTranslated(ctx, 'oee_volume_Output_by_Equipment')!,
              style: AppFonts.robotoRegular(
                16,
                color: theme_dark!
                    ? AppColors.appGrey2()
                    : AppColorsLightMode.appGrey(),
                decoration: TextDecoration.none,
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: this.chartVO3Height,
              color: theme_dark!
                  ? AppColors.appBlackLight()
                  : AppColors.appPrimaryWhite(),
              child: (volumeOutputbyEquipmentData.data != null &&
                      volumeOutputbyEquipmentData.data!.length > 0)
                  ? WebViewPlus(
                      backgroundColor: Colors.transparent,
                      javascriptMode: JavascriptMode.unrestricted,
                      initialUrl: theme_dark!
                          ? 'assets/html/oee_highchart_dark_theme.html'
                          : 'assets/html/oee_highchart_light_theme.html',
                      zoomEnabled: false,
                      onWebViewCreated: (controllerPlus) {
                        this.volumeOutputbyEquipmentController = controllerPlus;
                      },
                      onPageFinished: (url) {
                        this
                            .volumeOutputbyEquipmentController
                            .getHeight()
                            .then((value) {
                          Utils.printInfo(value);
                          setState(() {
                            this.chartVO3Height = value;
                          });
                        });
                      },
                      javascriptChannels: [
                        JavascriptChannel(
                            name: 'OEEChannel',
                            onMessageReceived: (message) {
                              print(message.message);
                              this
                                  .volumeOutputbyEquipmentController
                                  .webViewController
                                  .runJavascript(
                                      'fetchVolumeByEquipmentData(${jsonEncode(this.volumeOutputbyEquipmentData)}, "${DateFormat("yyyy-MM-dd").format(AppCache.sortFilterCacheDTO!.startDate!)}", "${DateFormat("yyyy-MM-dd").format(AppCache.sortFilterCacheDTO!.endDate!)}")');
                            }),
                        JavascriptChannel(
                            name: 'OEEVolumeByEquipmentChannel',
                            onMessageReceived: (message) {
                              print(message.message);
                              Navigator.pushNamed(
                                ctx,
                                AppRoutes.oeeDashboardChartDetailRoute,
                                arguments: OeeChartDetailArguments(
                                  chartName: Utils.getTranslated(ctx,
                                      'oee_daily_Volume_Output_by_Equipment')!,
                                  equipmentDTO: volumeOutputbyEquipmentData,
                                  dataType: Constants
                                      .CHART_OEE_DASHBOARD_VO_EQUIPMENT,
                                ),
                              );
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

  Widget volumeOutputbyProject(BuildContext ctx) {
    return GestureDetector(
      onTap: () {
        if (volumeOutputbyProjectData.data != null &&
            volumeOutputbyProjectData.data!.length > 0)
          Navigator.pushNamed(
            ctx,
            AppRoutes.oeeDashboardChartDetailRoute,
            arguments: OeeChartDetailArguments(
              chartName: Utils.getTranslated(
                  ctx, 'oee_daily_Volume_Output_by_Equipment')!,
              equipmentDTO: volumeOutputbyProjectData,
              dataType: Constants.CHART_OEE_DASHBOARD_VO_PROJECT,
            ),
          );
      },
      // onTap: () async {
      //   final result = await Navigator.pushNamed(
      //     ctx,
      //     AppRoutes.oeeDashboardChartDetailRoute,
      //     arguments: OeeChartDetailArguments(
      //       chartName: Utils.getTranslated(
      //           ctx, 'oee_daily_Volume_Output_by_Equipment')!,
      //       equipmentDTO: volumeOutputbyProjectData,
      //       dataType: Constants.CHART_OEE_DASHBOARD_VO_PROJECT,
      //     ),
      //   );
      //   if (result != volumeOutputbyProjectData) {
      //     setState(() {
      //       this.volumeOutputbyProjectController.webViewController.reload();
      //       volumeOutputbyProjectData = result as OeeEquipmentDTO;
      //     });
      //   }
      // },
      child: Container(
        width: MediaQuery.of(ctx).size.width,
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
              Utils.getTranslated(ctx, 'oee_volume_Output_by_Project')!,
              style: AppFonts.robotoRegular(
                16,
                color: theme_dark!
                    ? AppColors.appGrey2()
                    : AppColorsLightMode.appGrey(),
                decoration: TextDecoration.none,
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: this.chartVO5Height,
              color: theme_dark!
                  ? AppColors.appBlackLight()
                  : AppColors.appPrimaryWhite(),
              child: (volumeOutputbyProjectData.data != null &&
                      volumeOutputbyProjectData.data!.length > 0)
                  ? WebViewPlus(
                      backgroundColor: Colors.transparent,
                      javascriptMode: JavascriptMode.unrestricted,
                      initialUrl: theme_dark!
                          ? 'assets/html/oee_highchart_dark_theme.html'
                          : 'assets/html/oee_highchart_light_theme.html',
                      zoomEnabled: false,
                      onWebViewCreated: (controllerPlus) {
                        this.volumeOutputbyProjectController = controllerPlus;
                      },
                      onPageFinished: (url) {
                        this
                            .volumeOutputbyProjectController
                            .getHeight()
                            .then((value) {
                          Utils.printInfo(value);
                          setState(() {
                            this.chartVO5Height = value;
                          });
                        });
                      },
                      javascriptChannels: [
                        JavascriptChannel(
                            name: 'OEEChannel',
                            onMessageReceived: (message) {
                              print(message.message);
                              this
                                  .volumeOutputbyProjectController
                                  .webViewController
                                  .runJavascript(
                                      'fetchVolumeByProjectData(${jsonEncode(this.volumeOutputbyProjectData)}, "${DateFormat("yyyy-MM-dd").format(AppCache.sortFilterCacheDTO!.startDate!)}", "${DateFormat("yyyy-MM-dd").format(AppCache.sortFilterCacheDTO!.endDate!)}")');
                            }),
                        JavascriptChannel(
                          name: 'OEEVolumeByProjectChannel',
                          onMessageReceived: (message) {
                            print(message.message);
                            Navigator.pushNamed(
                              ctx,
                              AppRoutes.oeeDashboardChartDetailRoute,
                              arguments: OeeChartDetailArguments(
                                chartName: Utils.getTranslated(ctx,
                                    'oee_daily_Volume_Output_by_Equipment')!,
                                equipmentDTO: volumeOutputbyProjectData,
                                dataType:
                                    Constants.CHART_OEE_DASHBOARD_VO_PROJECT,
                              ),
                            );
                          },
                        ),
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

  Widget dailyUtilisationbyAllEquipment(BuildContext ctx) {
    return GestureDetector(
      onTap: () {
        if (getDailyUtilisationbyAllEquipmentData.data != null &&
            getDailyUtilisationbyAllEquipmentData.data!.length > 0)
          Navigator.pushNamed(
            ctx,
            AppRoutes.oeeDashboardChartDetailRoute,
            arguments: OeeChartDetailArguments(
              chartName: Utils.getTranslated(
                  ctx, 'oee_daily_Utilisation_by_All_Equipment')!,
              availableDTO: getDailyUtilisationbyAllEquipmentData,
              dataType: Constants.CHART_OEE_DASHBOARD_DAILY_UTIL_ALL_EQUIPMENT,
            ),
          );
      },
      child: Container(
        width: MediaQuery.of(ctx).size.width,
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
                  ctx, 'oee_daily_Utilisation_by_All_Equipment')!,
              style: AppFonts.robotoRegular(
                16,
                color: theme_dark!
                    ? AppColors.appGrey2()
                    : AppColorsLightMode.appGrey(),
                decoration: TextDecoration.none,
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: this.chartVO4Height,
              color: theme_dark!
                  ? AppColors.appBlackLight()
                  : AppColors.appPrimaryWhite(),
              child: (getDailyVolumeByEquipmentData.data != null &&
                      getDailyVolumeByEquipmentData.data!.length > 0)
                  ? WebViewPlus(
                      backgroundColor: Colors.transparent,
                      javascriptMode: JavascriptMode.unrestricted,
                      initialUrl: theme_dark!
                          ? 'assets/html/oee_highchart_dark_theme.html'
                          : 'assets/html/oee_highchart_light_theme.html',
                      zoomEnabled: false,
                      onWebViewCreated: (controllerPlus) {
                        this.getDailyUtilisationbyAllEquipmentController =
                            controllerPlus;
                      },
                      onPageFinished: (url) {
                        this
                            .getDailyUtilisationbyAllEquipmentController
                            .getHeight()
                            .then((value) {
                          Utils.printInfo(value);
                          setState(() {
                            this.chartVO4Height = value;
                          });
                        });
                      },
                      javascriptChannels: [
                        JavascriptChannel(
                            name: 'OEEChannel',
                            onMessageReceived: (message) {
                              print(message.message);
                              this
                                  .getDailyUtilisationbyAllEquipmentController
                                  .webViewController
                                  .runJavascript(
                                      'fetchDailyUtilisationbyAllEquipment(${jsonEncode(this.getDailyUtilisationbyAllEquipmentData)}, "${DateFormat("yyyy-MM-dd").format(AppCache.sortFilterCacheDTO!.startDate!)}", "${DateFormat("yyyy-MM-dd").format(AppCache.sortFilterCacheDTO!.endDate!)}","${Utils.getTranslated(context, 'oee_available_time')}","${Utils.getTranslated(context, 'oee_ultilisation_time')}","${Utils.getTranslated(context, 'oee_downTime')}","${Utils.getTranslated(context, 'oee_legend_planneddowntime')}")');
                            }),
                        JavascriptChannel(
                            name: 'OEEDailyUtilisationbyAllEquipmentChannel',
                            onMessageReceived: (message) {
                              print(message.message);
                              Navigator.pushNamed(
                                ctx,
                                AppRoutes.oeeDashboardChartDetailRoute,
                                arguments: OeeChartDetailArguments(
                                  chartName: Utils.getTranslated(ctx,
                                      'oee_daily_Utilisation_by_All_Equipment')!,
                                  availableDTO:
                                      getDailyUtilisationbyAllEquipmentData,
                                  dataType: Constants
                                      .CHART_OEE_DASHBOARD_DAILY_UTIL_ALL_EQUIPMENT,
                                ),
                              );
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
