import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:keysight_pma/cache/appcache.dart';
import 'package:keysight_pma/const/appcolors.dart';
import 'package:keysight_pma/const/appfonts.dart';
import 'package:keysight_pma/const/constants.dart';
import 'package:keysight_pma/const/utils.dart';
import 'package:keysight_pma/dio/api/dqm.dart';
import 'package:keysight_pma/model/arguments/dqm_argument.dart';
import 'package:keysight_pma/model/arguments/sort_filter_argument.dart';
import 'package:keysight_pma/model/dqm/daily_board_volume.dart';
import 'package:keysight_pma/model/dqm/volume_by_project.dart';
import 'package:keysight_pma/model/dqm/worst_test_by_project.dart';
import 'package:keysight_pma/model/dqm/yield_by_site.dart';
import 'package:keysight_pma/routes/approutes.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

class DigitalQualityDashboardScreen extends StatefulWidget {
  final TabController? tabController;
  DigitalQualityDashboardScreen({Key? key, this.tabController})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DigitalQualityDashboardScreen();
  }
}

class _DigitalQualityDashboardScreen
    extends State<DigitalQualityDashboardScreen> {
  double chartVOHeight = 316.0;
  double chartFPYHeight = 316.0;
  double chartFPYPHeight = 316.0;
  double chartVPHeight = 316.0;
  double chartWTNHeight = 316.0;
  bool isLoading = true;
  late WebViewPlusController dqmDailyVolumeController;
  late WebViewPlusController dailyFirstPassYieldController;
  late WebViewPlusController dailyFirstPassYieldByProjectController;
  late WebViewPlusController volumeByProjectController;
  late WebViewPlusController top5WorstTestNameByProjectController;
  DailyBoardVolumeDTO dailyBoardVolumeDTO = DailyBoardVolumeDTO();
  YieldBySiteDTO yieldBySiteDTO = YieldBySiteDTO();
  VolumeByProjectDTO volumeByProjectDTO = VolumeByProjectDTO();
  WorstTestByProjectDTO worstTestByProjectDTO = WorstTestByProjectDTO();
  late Map<String?, List<YieldBySiteDataDTO>> yieldBySiteMap;
  late Map<String?, List<WorstTestByProjectDataDTO>> wtnpByProjectMap;

  List<DailyBoardVolumeDataDTO> dailyBoardVolumeDataList = [];
  List<VolumeByProjectDataDTO> volumeByProjectDataList = [];
  bool? isDarkTheme = AppCache.sortFilterCacheDTO!.currentTheme;

  Future<DailyBoardVolumeDTO> getDailyBoardVolumeBySite(BuildContext context) {
    DqmApi dqmApi = DqmApi(context);
    return dqmApi.getDailyBoardVolumeBySite(
        AppCache.sortFilterCacheDTO!.preferredCompany!,
        AppCache.sortFilterCacheDTO!.preferredSite!,
        DateFormat("yyyyMMdd").format(AppCache.sortFilterCacheDTO!.startDate!),
        DateFormat("yyyyMMdd").format(AppCache.sortFilterCacheDTO!.endDate!));
  }

  Future<YieldBySiteDTO> getYieldBySite(BuildContext context) {
    DqmApi dqmApi = DqmApi(context);
    return dqmApi.getYieldBySite(
        AppCache.sortFilterCacheDTO!.preferredCompany!,
        AppCache.sortFilterCacheDTO!.preferredSite!,
        DateFormat("yyyy-MM-dd")
            .format(AppCache.sortFilterCacheDTO!.startDate!),
        DateFormat("yyyy-MM-dd").format(AppCache.sortFilterCacheDTO!.endDate!));
  }

  Future<VolumeByProjectDTO> getVolumeByProject(BuildContext context) {
    DqmApi dqmApi = DqmApi(context);
    return dqmApi.getVolumeByProject(
        AppCache.sortFilterCacheDTO!.preferredCompany!,
        AppCache.sortFilterCacheDTO!.preferredSite!,
        DateFormat("yyyy-MM-dd")
            .format(AppCache.sortFilterCacheDTO!.startDate!),
        DateFormat("yyyy-MM-dd").format(AppCache.sortFilterCacheDTO!.endDate!));
  }

  Future<WorstTestByProjectDTO> getWorstTestByProject(BuildContext context) {
    DqmApi dqmApi = DqmApi(context);
    return dqmApi.getWorstTestByProject(
        AppCache.sortFilterCacheDTO!.preferredCompany!,
        AppCache.sortFilterCacheDTO!.preferredSite!,
        DateFormat("yyyy-MM-dd")
            .format(AppCache.sortFilterCacheDTO!.startDate!),
        DateFormat("yyyy-MM-dd").format(AppCache.sortFilterCacheDTO!.endDate!));
  }

  List<String> getDaysInBetween(DateTime startDate, DateTime endDate) {
    List<String> days = [];
    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      days.add(
          DateFormat('yyyy-MM-dd').format(startDate.add(Duration(days: i))));
    }
    return days;
  }

  void groupYieldByProjects(List<YieldBySiteDataDTO> data) {
    final groups = groupBy(data, (YieldBySiteDataDTO e) {
      return e.projectId;
    });

    this.yieldBySiteMap = groups;
  }

  void groupWorstTestNameByProjects(List<WorstTestByProjectDataDTO> data) {
    final groups = groupBy(data, (WorstTestByProjectDataDTO e) {
      return e.projectId;
    });

    this.wtnpByProjectMap = groups;
  }

  @override
  void initState() {
    super.initState();
    FirebaseAnalytics.instance
        .setCurrentScreen(screenName: Constants.ANALYTICS_DQM_DASHBOARD_SCREEN);
    FocusManager.instance.primaryFocus?.unfocus();
    callGetDailyBoardVolumeBySite(context);
  }

  callGetDailyBoardVolumeBySite(BuildContext context) async {
    await getDailyBoardVolumeBySite(context).then((value) {
      if (value.status!.statusCode == 200) {
        dailyBoardVolumeDTO = value;
        if (value.data != null && value.data!.length > 0) {
          this.dailyBoardVolumeDataList = value.data!;
          this.dailyBoardVolumeDataList.sort((a, b) {
            return a.date!.compareTo(b.date!);
          });
        }
      }
    }).catchError((error) {
      Utils.printInfo(error);
    });

    await getYieldBySite(context).then((value) {
      if (value.status!.statusCode == 200) {
        yieldBySiteDTO = value;
        if (yieldBySiteDTO.data != null && yieldBySiteDTO.data!.length > 0) {
          groupYieldByProjects(yieldBySiteDTO.data!);
        }
      }
    }).catchError((error) {
      Utils.printInfo(error);
    });

    await getVolumeByProject(context).then((value) {
      if (value.status!.statusCode == 200) {
        volumeByProjectDTO = value;
        if (value.data != null && value.data!.length > 0) {
          this.volumeByProjectDataList = value.data!;
          this.volumeByProjectDataList.sort((a, b) {
            return a.projectId!
                .toLowerCase()
                .compareTo(b.projectId!.toLowerCase());
          });
        }
      }
    }).catchError((error) {
      Utils.printInfo(error);
    });

    await getWorstTestByProject(context).then((value) {
      if (value.status!.statusCode == 200) {
        worstTestByProjectDTO = value;
        if (worstTestByProjectDTO.data != null &&
            worstTestByProjectDTO.data!.length > 0) {
          groupWorstTestNameByProjects(worstTestByProjectDTO.data!);
        }
      }
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
                        dailyVolume(context),
                        dailyFirstPassYield(context),
                        dailyFirstPassYieldByProject(context),
                        volumeByProject(context),
                        top5WorstTestNameByProject(context),
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
                            currentTab: 0,
                          ),
                        );

                        if (result != null && result as bool) {
                          setState(() {
                            isLoading = true;
                            callGetDailyBoardVolumeBySite(context);
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

  Widget dailyVolume(BuildContext ctx) {
    return GestureDetector(
      onTap: () {
        if (this.dailyBoardVolumeDataList.length > 0) {
          Navigator.pushNamed(
            ctx,
            AppRoutes.dqmDashboardChartDetailRoute,
            arguments: DqmChartDetailArguments(
              chartName:
                  Utils.getTranslated(ctx, 'dqm_dashboard_daily_volume')!,
              dailyBoardVolumeDTO: dailyBoardVolumeDTO,
              dataType: Constants.CHART_DQM_DAILY_VOLUME,
            ),
          );
        }
      },
      child: Container(
        width: MediaQuery.of(ctx).size.width,
        decoration: BoxDecoration(
            color: isDarkTheme!
                ? AppColors.appBlackLight()
                : AppColors.appPrimaryWhite(),
            border: Border.all(
              color: isDarkTheme!
                  ? AppColors.appBlackLight()
                  : AppColors.appGreyDE(),
            )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(14.0, 18.0, 14.0, 0.0),
              child: Text(
                Utils.getTranslated(ctx, 'dqm_dashboard_daily_volume')!,
                style: AppFonts.robotoRegular(
                  16,
                  color: isDarkTheme!
                      ? AppColors.appGrey2()
                      : AppColorsLightMode.appGrey(),
                  decoration: TextDecoration.none,
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: this.chartVOHeight,
              color: isDarkTheme!
                  ? AppColors.appBlackLight()
                  : AppColors.appPrimaryWhite(),
              child: (this.dailyBoardVolumeDataList.length > 0)
                  ? WebViewPlus(
                      backgroundColor: Colors.transparent,
                      javascriptMode: JavascriptMode.unrestricted,
                      initialUrl: isDarkTheme!
                          ? 'assets/html/highchart_dark_theme.html'
                          : 'assets/html/highchart_light_theme.html',
                      zoomEnabled: false,
                      onWebViewCreated: (controllerPlus) {
                        this.dqmDailyVolumeController = controllerPlus;
                      },
                      onPageFinished: (url) {
                        this.dqmDailyVolumeController.getHeight().then((value) {
                          Utils.printInfo(value);
                          setState(() {
                            this.chartVOHeight = value;
                          });
                        });
                      },
                      javascriptChannels: [
                        JavascriptChannel(
                            name: 'DQMChannel',
                            onMessageReceived: (message) {
                              print(message.message);
                              this
                                  .dqmDailyVolumeController
                                  .webViewController
                                  .runJavascript(
                                      'fetchDailyVolumeData(${jsonEncode(this.dailyBoardVolumeDataList)}, "${DateFormat("yyyy-MM-dd").format(AppCache.sortFilterCacheDTO!.startDate!)}", "${DateFormat("yyyy-MM-dd").format(AppCache.sortFilterCacheDTO!.endDate!)}", "${Utils.getTranslated(ctx, 'dqm_dashboard_fail')}", "${Utils.getTranslated(ctx, 'dqm_dashboard_retestpass')}", "${Utils.getTranslated(ctx, 'dqm_dashboard_firstpass')}")');
                            }),
                        JavascriptChannel(
                            name: 'DQMDailyVolumeChannel',
                            onMessageReceived: (message) {
                              print(message.message);
                              Navigator.pushNamed(
                                ctx,
                                AppRoutes.dqmDashboardChartDetailRoute,
                                arguments: DqmChartDetailArguments(
                                  chartName: Utils.getTranslated(
                                      ctx, 'dqm_dashboard_daily_volume')!,
                                  dailyBoardVolumeDTO: dailyBoardVolumeDTO,
                                  dataType: Constants.CHART_DQM_DAILY_VOLUME,
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
                          color: isDarkTheme!
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

  Widget dailyFirstPassYield(BuildContext ctx) {
    return GestureDetector(
      onTap: () {
        if (this.dailyBoardVolumeDataList.length > 0) {
          Navigator.pushNamed(
            ctx,
            AppRoutes.dqmDashboardChartDetailRoute,
            arguments: DqmChartDetailArguments(
              chartName: Utils.getTranslated(
                  ctx, 'dqm_dashboard_daily_first_pass_yield')!,
              dailyBoardVolumeDTO: dailyBoardVolumeDTO,
              dataType: Constants.CHART_DQM_DAILY_FIRST_PASS_YIELD,
            ),
          );
        }
      },
      child: Container(
        width: MediaQuery.of(ctx).size.width,
        decoration: BoxDecoration(
            color: isDarkTheme!
                ? AppColors.appBlackLight()
                : AppColors.appPrimaryWhite(),
            border: Border.all(
              color: isDarkTheme!
                  ? AppColors.appBlackLight()
                  : AppColors.appGreyDE(),
            )),
        margin: EdgeInsets.only(top: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(14.0, 18.0, 14.0, 0.0),
              child: Text(
                Utils.getTranslated(
                    ctx, 'dqm_dashboard_daily_first_pass_yield')!,
                style: AppFonts.robotoRegular(
                  16,
                  color: isDarkTheme!
                      ? AppColors.appGrey2()
                      : AppColorsLightMode.appGrey(),
                  decoration: TextDecoration.none,
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: this.chartFPYHeight,
              color: isDarkTheme!
                  ? AppColors.appBlackLight()
                  : AppColors.appPrimaryWhite(),
              child: (this.dailyBoardVolumeDataList.length > 0)
                  ? WebViewPlus(
                      backgroundColor: Colors.transparent,
                      javascriptMode: JavascriptMode.unrestricted,
                      initialUrl: isDarkTheme!
                          ? 'assets/html/highchart_dark_theme.html'
                          : 'assets/html/highchart_light_theme.html',
                      zoomEnabled: false,
                      onWebViewCreated: (controllerPlus) {
                        this.dailyFirstPassYieldController = controllerPlus;
                      },
                      onPageFinished: (url) {
                        this
                            .dailyFirstPassYieldController
                            .getHeight()
                            .then((value) {
                          Utils.printInfo(value);
                          setState(() {
                            this.chartFPYHeight = value;
                          });
                        });
                      },
                      javascriptChannels: [
                        JavascriptChannel(
                            name: 'DQMChannel',
                            onMessageReceived: (message) {
                              print(message.message);
                              this
                                  .dailyFirstPassYieldController
                                  .webViewController
                                  .runJavascript(
                                      'fetchDailyFirstPassYieldData(${jsonEncode(this.dailyBoardVolumeDataList)}, "${DateFormat("yyyy-MM-dd").format(AppCache.sortFilterCacheDTO!.startDate!)}", "${DateFormat("yyyy-MM-dd").format(AppCache.sortFilterCacheDTO!.endDate!)}", ${jsonEncode(getDaysInBetween(AppCache.sortFilterCacheDTO!.startDate!, AppCache.sortFilterCacheDTO!.endDate!))})');
                            }),
                        JavascriptChannel(
                            name: 'DQMDailyFirstPassChannel',
                            onMessageReceived: (message) {
                              print(message.message);
                              Navigator.pushNamed(
                                ctx,
                                AppRoutes.dqmDashboardChartDetailRoute,
                                arguments: DqmChartDetailArguments(
                                  chartName: Utils.getTranslated(ctx,
                                      'dqm_dashboard_daily_first_pass_yield')!,
                                  dailyBoardVolumeDTO: dailyBoardVolumeDTO,
                                  dataType: Constants
                                      .CHART_DQM_DAILY_FIRST_PASS_YIELD,
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
                          color: isDarkTheme!
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

  Widget dailyFirstPassYieldByProject(BuildContext ctx) {
    return GestureDetector(
      onTap: () {
        if (yieldBySiteDTO.data != null && yieldBySiteDTO.data!.length > 0) {
          Navigator.pushNamed(
            ctx,
            AppRoutes.dqmDashboardChartDetailRoute,
            arguments: DqmChartDetailArguments(
              chartName: Utils.getTranslated(
                  ctx, 'dqm_dashboard_daily_first_pass_yield_by_project')!,
              yieldBySiteDTO: this.yieldBySiteDTO,
              dataType: Constants.CHART_DQM_DAILY_FIRST_PASS_YIELD_PROJECT,
            ),
          );
        }
      },
      child: Container(
        width: MediaQuery.of(ctx).size.width,
        decoration: BoxDecoration(
            color: isDarkTheme!
                ? AppColors.appBlackLight()
                : AppColors.appPrimaryWhite(),
            border: Border.all(
              color: isDarkTheme!
                  ? AppColors.appBlackLight()
                  : AppColors.appGreyDE(),
            )),
        margin: EdgeInsets.only(top: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(14.0, 18.0, 14.0, 0.0),
              child: Text(
                Utils.getTranslated(
                    ctx, 'dqm_dashboard_daily_first_pass_yield_by_project')!,
                style: AppFonts.robotoRegular(
                  16,
                  color: isDarkTheme!
                      ? AppColors.appGrey2()
                      : AppColorsLightMode.appGrey(),
                  decoration: TextDecoration.none,
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: this.chartFPYPHeight,
              color: isDarkTheme!
                  ? AppColors.appBlackLight()
                  : AppColors.appPrimaryWhite(),
              child: (yieldBySiteDTO.data != null &&
                      yieldBySiteDTO.data!.length > 0)
                  ? WebViewPlus(
                      backgroundColor: Colors.transparent,
                      javascriptMode: JavascriptMode.unrestricted,
                      initialUrl: isDarkTheme!
                          ? 'assets/html/highchart_dark_theme.html'
                          : 'assets/html/highchart_light_theme.html',
                      zoomEnabled: false,
                      onWebViewCreated: (controllerPlus) {
                        this.dailyFirstPassYieldByProjectController =
                            controllerPlus;
                      },
                      onPageFinished: (url) {
                        this
                            .dailyFirstPassYieldByProjectController
                            .getHeight()
                            .then((value) {
                          Utils.printInfo(value);
                          setState(() {
                            this.chartFPYPHeight = value;
                          });
                        });
                      },
                      javascriptChannels: [
                        JavascriptChannel(
                            name: 'DQMChannel',
                            onMessageReceived: (message) {
                              print(message.message);
                              this
                                  .dailyFirstPassYieldByProjectController
                                  .webViewController
                                  .runJavascript(
                                      'fetchYieldProjectData(${jsonEncode(this.yieldBySiteDTO)}, "${DateFormat("yyyy-MM-dd").format(AppCache.sortFilterCacheDTO!.startDate!)}", "${DateFormat("yyyy-MM-dd").format(AppCache.sortFilterCacheDTO!.endDate!)}", ${jsonEncode(getDaysInBetween(AppCache.sortFilterCacheDTO!.startDate!, AppCache.sortFilterCacheDTO!.endDate!))}, ${jsonEncode(this.yieldBySiteMap)})');
                            }),
                        JavascriptChannel(
                            name: 'DQMFirstPassYieldByProjectChannel',
                            onMessageReceived: (message) {
                              print(message.message);
                              Navigator.pushNamed(
                                ctx,
                                AppRoutes.dqmDashboardChartDetailRoute,
                                arguments: DqmChartDetailArguments(
                                  chartName: Utils.getTranslated(ctx,
                                      'dqm_dashboard_daily_first_pass_yield_by_project')!,
                                  dailyBoardVolumeDTO: dailyBoardVolumeDTO,
                                  yieldBySiteDTO: this.yieldBySiteDTO,
                                  dataType: Constants
                                      .CHART_DQM_DAILY_FIRST_PASS_YIELD_PROJECT,
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
                          color: isDarkTheme!
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

  Widget volumeByProject(BuildContext ctx) {
    return GestureDetector(
      onTap: () async {
        if (this.volumeByProjectDataList.length > 0) {
          final naviagateResult = await Navigator.pushNamed(
            ctx,
            AppRoutes.dqmDashboardChartDetailRoute,
            arguments: DqmChartDetailArguments(
              chartName:
                  Utils.getTranslated(ctx, 'dqm_dashboard_volume_by_project')!,
              volumeByProjectDTO: this.volumeByProjectDTO,
              dataType: Constants.CHART_DQM_DASHBOARD_VOLUME_PROJECT,
            ),
          );

          if (naviagateResult != null && naviagateResult as bool) {
            if (widget.tabController != null) {
              widget.tabController!.animateTo(2);
            }
          }
        }
      },
      child: Container(
        width: MediaQuery.of(ctx).size.width,
        decoration: BoxDecoration(
            color: isDarkTheme!
                ? AppColors.appBlackLight()
                : AppColors.appPrimaryWhite(),
            border: Border.all(
              color: isDarkTheme!
                  ? AppColors.appBlackLight()
                  : AppColors.appGreyDE(),
            )),
        margin: EdgeInsets.only(top: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(14.0, 18.0, 14.0, 0.0),
              child: Text(
                Utils.getTranslated(ctx, 'dqm_dashboard_volume_by_project')!,
                style: AppFonts.robotoRegular(
                  16,
                  color: isDarkTheme!
                      ? AppColors.appGrey2()
                      : AppColorsLightMode.appGrey(),
                  decoration: TextDecoration.none,
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: this.chartVPHeight,
              color: isDarkTheme!
                  ? AppColors.appBlackLight()
                  : AppColors.appPrimaryWhite(),
              child: (this.volumeByProjectDataList.length > 0)
                  ? WebViewPlus(
                      backgroundColor: Colors.transparent,
                      javascriptMode: JavascriptMode.unrestricted,
                      initialUrl: isDarkTheme!
                          ? 'assets/html/highchart_dark_theme.html'
                          : 'assets/html/highchart_light_theme.html',
                      zoomEnabled: false,
                      onWebViewCreated: (controllerPlus) {
                        this.volumeByProjectController = controllerPlus;
                      },
                      onPageFinished: (url) {
                        this
                            .volumeByProjectController
                            .getHeight()
                            .then((value) {
                          Utils.printInfo(value);
                          setState(() {
                            this.chartVPHeight = value;
                          });
                        });
                      },
                      javascriptChannels: [
                        JavascriptChannel(
                            name: 'DQMChannel',
                            onMessageReceived: (message) {
                              print(message.message);
                              this
                                  .volumeByProjectController
                                  .webViewController
                                  .runJavascript(
                                      'fetchVolumeByProjectData(${jsonEncode(this.volumeByProjectDataList)}, ${DateFormat("yyyy-MM-dd").format(AppCache.sortFilterCacheDTO!.startDate!)}, ${DateFormat("yyyy-MM-dd").format(AppCache.sortFilterCacheDTO!.endDate!)}, "${Utils.getTranslated(ctx, 'dqm_dashboard_fail')}", "${Utils.getTranslated(ctx, 'dqm_dashboard_retestpass')}", "${Utils.getTranslated(ctx, 'dqm_dashboard_firstpass')}")');
                            }),
                        JavascriptChannel(
                            name: 'DQMVolumeByProjectChannel',
                            onMessageReceived: (message) async {
                              final naviagateResult = await Navigator.pushNamed(
                                ctx,
                                AppRoutes.dqmDashboardChartDetailRoute,
                                arguments: DqmChartDetailArguments(
                                  chartName: Utils.getTranslated(
                                      ctx, 'dqm_dashboard_volume_by_project')!,
                                  volumeByProjectDTO: this.volumeByProjectDTO,
                                  dataType: Constants
                                      .CHART_DQM_DASHBOARD_VOLUME_PROJECT,
                                ),
                              );

                              if (naviagateResult as bool) {
                                if (widget.tabController != null) {
                                  widget.tabController!.animateTo(2);
                                }
                              }
                            }),
                      ].toSet(),
                    )
                  : Center(
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
          ],
        ),
      ),
    );
  }

  Widget top5WorstTestNameByProject(BuildContext ctx) {
    return GestureDetector(
      onTap: () {
        if (worstTestByProjectDTO.data != null &&
            worstTestByProjectDTO.data!.length > 0) {
          Navigator.pushNamed(
            ctx,
            AppRoutes.dqmDashboardChartDetailRoute,
            arguments: DqmChartDetailArguments(
              chartName: Utils.getTranslated(
                  ctx, 'dqm_dashboard_top5_worst_testname_by_project')!,
              worstTestByProjectDTO: this.worstTestByProjectDTO,
              dataType: Constants.CHART_DQM_DASHBOARD_WORST_TESTNAME_PROJECT,
            ),
          );
        }
      },
      child: Container(
        width: MediaQuery.of(ctx).size.width,
        decoration: BoxDecoration(
            color: isDarkTheme!
                ? AppColors.appBlackLight()
                : AppColors.appPrimaryWhite(),
            border: Border.all(
              color: isDarkTheme!
                  ? AppColors.appBlackLight()
                  : AppColors.appGreyDE(),
            )),
        margin: EdgeInsets.only(top: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(14.0, 18.0, 14.0, 0.0),
              child: Text(
                Utils.getTranslated(
                    ctx, 'dqm_dashboard_top5_worst_testname_by_project')!,
                style: AppFonts.robotoRegular(
                  16,
                  color: isDarkTheme!
                      ? AppColors.appGrey2()
                      : AppColorsLightMode.appGrey(),
                  decoration: TextDecoration.none,
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: this.chartWTNHeight,
              color: isDarkTheme!
                  ? AppColors.appBlackLight()
                  : AppColors.appPrimaryWhite(),
              child: (worstTestByProjectDTO.data != null &&
                      worstTestByProjectDTO.data!.length > 0)
                  ? WebViewPlus(
                      backgroundColor: Colors.transparent,
                      javascriptMode: JavascriptMode.unrestricted,
                      initialUrl: isDarkTheme!
                          ? 'assets/html/highchart_dark_theme.html'
                          : 'assets/html/highchart_light_theme.html',
                      zoomEnabled: false,
                      onWebViewCreated: (controllerPlus) {
                        this.top5WorstTestNameByProjectController =
                            controllerPlus;
                      },
                      onPageFinished: (url) {
                        this
                            .top5WorstTestNameByProjectController
                            .getHeight()
                            .then((value) {
                          Utils.printInfo(value);
                          setState(() {
                            this.chartWTNHeight = value;
                          });
                        });
                      },
                      javascriptChannels: [
                        JavascriptChannel(
                            name: 'DQMChannel',
                            onMessageReceived: (message) {
                              print(message.message);
                              this
                                  .top5WorstTestNameByProjectController
                                  .webViewController
                                  .runJavascript(
                                      'fetchTop5WorstTestNamesByProjectData(${jsonEncode(this.worstTestByProjectDTO)}, ${jsonEncode(this.wtnpByProjectMap)})');
                            }),
                        JavascriptChannel(
                            name: 'DQMWTNPByProjectChannel',
                            onMessageReceived: (message) {
                              print(message.message);
                              Navigator.pushNamed(
                                ctx,
                                AppRoutes.dqmDashboardChartDetailRoute,
                                arguments: DqmChartDetailArguments(
                                  chartName: Utils.getTranslated(ctx,
                                      'dqm_dashboard_top5_worst_testname_by_project')!,
                                  worstTestByProjectDTO:
                                      this.worstTestByProjectDTO,
                                  dataType: Constants
                                      .CHART_DQM_DASHBOARD_WORST_TESTNAME_PROJECT,
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
                          color: isDarkTheme!
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
