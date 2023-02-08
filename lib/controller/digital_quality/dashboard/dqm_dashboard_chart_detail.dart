import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:keysight_pma/cache/appcache.dart';
import 'package:keysight_pma/const/appcolors.dart';
import 'package:keysight_pma/const/appfonts.dart';
import 'package:keysight_pma/const/constants.dart';
import 'package:keysight_pma/const/download.dart';
import 'package:keysight_pma/const/utils.dart';
import 'package:keysight_pma/model/arguments/dqm_argument.dart';
import 'package:keysight_pma/model/customize.dart';
import 'package:keysight_pma/model/dqm/daily_board_volume.dart';
import 'package:keysight_pma/model/dqm/volume_by_project.dart';
import 'package:keysight_pma/model/dqm/worst_test_by_project.dart';
import 'package:keysight_pma/model/dqm/yield_by_site.dart';
import 'package:keysight_pma/model/js/js.dart';
import 'package:keysight_pma/routes/approutes.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

class DigitalQualityDashboardChartDetailScreen extends StatefulWidget {
  final String chartName;
  final DailyBoardVolumeDTO? dailyBoardVolumeDTO;
  final YieldBySiteDTO? yieldBySiteDTO;
  final VolumeByProjectDTO? volumeByProjectDTO;
  final WorstTestByProjectDTO? worstTestByProjectDTO;
  final String? dataType;

  DigitalQualityDashboardChartDetailScreen(
      {Key? key,
      required this.chartName,
      this.dailyBoardVolumeDTO,
      this.yieldBySiteDTO,
      this.volumeByProjectDTO,
      this.worstTestByProjectDTO,
      this.dataType})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DigitalQualityDashboardChartDetailScreen();
  }
}

class _DigitalQualityDashboardChartDetailScreen
    extends State<DigitalQualityDashboardChartDetailScreen> {
  late WebViewPlusController dqmWebViewController;
  double chartHeight = 350;
  bool isFinalYield = false;
  bool isLoading = false;
  late Map<String?, List<YieldBySiteDataDTO>> yieldBySiteMap;
  late Map<String?, List<WorstTestByProjectDataDTO>> wtnpByProjectMap;
  late JSWorstTestNameByProjectDTO jsWorstTestNameByProjectDTO =
      JSWorstTestNameByProjectDTO();
  List<CustomDqmSortFilterProjectsDTO> projectList = [];
  bool? isDarkTheme = AppCache.sortFilterCacheDTO!.currentTheme;
  bool isChineseLng = false;

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

    setState(() {
      this.yieldBySiteMap = groups;
      this.yieldBySiteMap.keys.forEach((projectId) {
        CustomDqmSortFilterProjectsDTO customDTO =
            CustomDqmSortFilterProjectsDTO(projectId, true);
        this.projectList.add(customDTO);
      });
    });
  }

  void groupWorstTestNameByProjects(List<WorstTestByProjectDataDTO> data) {
    final groups = groupBy(data, (WorstTestByProjectDataDTO e) {
      return e.projectId;
    });

    setState(() {
      this.wtnpByProjectMap = groups;
      this.wtnpByProjectMap.keys.forEach((projectId) {
        CustomDqmSortFilterProjectsDTO customDTO =
            CustomDqmSortFilterProjectsDTO(projectId, true);
        this.projectList.add(customDTO);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    FirebaseAnalytics.instance.setCurrentScreen(
        screenName: Constants.ANALYTICS_DQM_DASHBOARD_DETAIL_SCREEN);
    if (widget.yieldBySiteDTO != null) {
      groupYieldByProjects(widget.yieldBySiteDTO!.data!);
    }

    if (widget.volumeByProjectDTO != null) {
      widget.volumeByProjectDTO!.data!.forEach((data) {
        CustomDqmSortFilterProjectsDTO customDTO =
            CustomDqmSortFilterProjectsDTO(data.projectId, true);
        this.projectList.add(customDTO);
      });
    }

    if (widget.worstTestByProjectDTO != null) {
      groupWorstTestNameByProjects(widget.worstTestByProjectDTO!.data!);
    }

    AppCache.getStringValue(AppCache.LANGUAGE_CODE_PREF).then((value) {
      if (Utils.isNotEmpty(value) && value == Constants.LANGUAGE_CODE_CN) {
        this.isChineseLng = true;
      } else {
        this.isChineseLng = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDarkTheme!
            ? AppColors.serverAppBar()
            : AppColorsLightMode.serverAppBar(),
        centerTitle: true,
        title: Padding(
          padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
          child: Text(
            widget.chartName,
            style: AppFonts.robotoRegular(
              20,
              color: isDarkTheme!
                  ? AppColors.appGrey()
                  : AppColorsLightMode.appGrey(),
              decoration: TextDecoration.none,
            ),
          ),
        ),
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Image.asset(
              isDarkTheme!
                  ? Constants.ASSET_IMAGES + 'back_bttn.png'
                  : Constants.ASSET_IMAGES_LIGHT + 'back_bttn.png',
            )),
        actions: [
          GestureDetector(
              onTap: () {
                showDownloadPopup(context);
              },
              child: Image.asset(
                isDarkTheme!
                    ? Constants.ASSET_IMAGES + 'download_bttn.png'
                    : Constants.ASSET_IMAGES_LIGHT + 'download_bttn.png',
              ))
        ],
      ),
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
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
                          chart(context),
                          chartInfo(context),
                        ],
                      ),
                    ),
                    sortAndFilter(context),
                  ],
                ),
        ),
      ),
    );
  }

  Widget sortAndFilter(BuildContext ctx) {
    if (widget.dataType == Constants.CHART_DQM_DAILY_FIRST_PASS_YIELD_PROJECT ||
        widget.dataType == Constants.CHART_DQM_DASHBOARD_VOLUME_PROJECT ||
        widget.dataType ==
            Constants.CHART_DQM_DASHBOARD_WORST_TESTNAME_PROJECT) {
      return Align(
        alignment: Alignment.bottomCenter,
        child: TextButton(
          onPressed: () async {
            final result = await Navigator.pushNamed(
              context,
              AppRoutes.dqmDashboardDetailSortFilterRoute,
              arguments: DqmSortFilterArguments(
                projectIdList: this.projectList,
              ),
            );

            if (result != null) {
              this.projectList = result as List<CustomDqmSortFilterProjectsDTO>;
              this.dqmWebViewController.webViewController.reload();
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
      );
    }

    return Container();
  }

  Widget header(BuildContext ctx) {
    if (widget.dataType == Constants.CHART_DQM_DAILY_FIRST_PASS_YIELD ||
        widget.dataType == Constants.CHART_DQM_DAILY_FIRST_PASS_YIELD_PROJECT) {
      return Container(
        width: MediaQuery.of(ctx).size.width,
        margin: EdgeInsets.fromLTRB(49.0, 18.0, 49.0, 18.0),
        decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(
              color: AppColors.appGrey70(),
            ),
            borderRadius: BorderRadius.circular(5.0)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    this.isFinalYield = !this.isFinalYield;
                    this.dqmWebViewController.webViewController.reload();
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(11.0),
                  decoration: BoxDecoration(
                    color: !isFinalYield
                        ? AppColors.appTeal()
                        : Colors.transparent,
                  ),
                  child: Text(
                    Utils.getTranslated(ctx, 'home_summary_fpy')!,
                    style: AppFonts.robotoBold(
                      12,
                      color: !isFinalYield
                          ? AppColors.appPrimaryWhite()
                          : AppColors.appGrey70(),
                      decoration: TextDecoration.none,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    isFinalYield = !isFinalYield;
                    this.dqmWebViewController.webViewController.reload();
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(11.0),
                  decoration: BoxDecoration(
                    color:
                        isFinalYield ? AppColors.appTeal() : Colors.transparent,
                  ),
                  child: Text(
                    Utils.getTranslated(ctx, 'home_summary_fy')!,
                    style: AppFonts.robotoBold(
                      12,
                      color: isFinalYield
                          ? AppColors.appPrimaryWhite()
                          : AppColors.appGrey70(),
                      decoration: TextDecoration.none,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container();
  }

  Widget chart(BuildContext ctx) {
    return Container(
      width: MediaQuery.of(ctx).size.width,
      height: this.chartHeight,
      color: Colors.transparent,
      child: WebViewPlus(
        backgroundColor: Colors.transparent,
        javascriptMode: JavascriptMode.unrestricted,
        initialUrl: isDarkTheme!
            ? 'assets/html/highchart_dark_theme.html'
            : 'assets/html/highchart_light_theme.html',
        zoomEnabled: false,
        gestureRecognizers: Set()
          ..add(Factory<VerticalDragGestureRecognizer>(
              () => VerticalDragGestureRecognizer()))
          ..add(
              Factory<ScaleGestureRecognizer>(() => ScaleGestureRecognizer())),
        onWebViewCreated: (controllerPlus) {
          this.dqmWebViewController = controllerPlus;
        },
        onPageFinished: (url) {
          this.dqmWebViewController.getHeight().then((value) {
            Utils.printInfo(value);
            setState(() {
              this.chartHeight = value;
            });
          });
        },
        javascriptChannels: [
          JavascriptChannel(
              name: 'DQMChannel',
              onMessageReceived: (message) {
                print(message.message);
                if (widget.dataType == Constants.CHART_DQM_DAILY_VOLUME) {
                  this.dqmWebViewController.webViewController.runJavascript(
                      'fetchDailyVolumeDetailData(${jsonEncode(widget.dailyBoardVolumeDTO)}, "${DateFormat("yyyy-MM-dd").format(AppCache.sortFilterCacheDTO!.startDate!)}", "${DateFormat("yyyy-MM-dd").format(AppCache.sortFilterCacheDTO!.endDate!)}", "${Utils.getTranslated(ctx, 'dqm_dashboard_fail')}", "${Utils.getTranslated(ctx, 'dqm_dashboard_retestpass')}", "${Utils.getTranslated(ctx, 'dqm_dashboard_firstpass')}", "${Utils.getTranslated(ctx, 'chart_footer_date_unique_board_count')}")');
                } else if (widget.dataType ==
                    Constants.CHART_DQM_DAILY_FIRST_PASS_YIELD) {
                  if (isFinalYield) {
                    this.dqmWebViewController.webViewController.runJavascript(
                        'fetchFirstPassFinalYieldDetailData(${jsonEncode(widget.dailyBoardVolumeDTO)}, "${DateFormat("yyyy-MM-dd").format(AppCache.sortFilterCacheDTO!.startDate!)}", "${DateFormat("yyyy-MM-dd").format(AppCache.sortFilterCacheDTO!.endDate!)}", ${jsonEncode(getDaysInBetween(AppCache.sortFilterCacheDTO!.startDate!, AppCache.sortFilterCacheDTO!.endDate!))}, "${Utils.getTranslated(ctx, 'chart_footer_date_yield')!}")');
                  } else {
                    this.dqmWebViewController.webViewController.runJavascript(
                        'fetchFirstPassYieldDetailData(${jsonEncode(widget.dailyBoardVolumeDTO)}, "${DateFormat("yyyy-MM-dd").format(AppCache.sortFilterCacheDTO!.startDate!)}", "${DateFormat("yyyy-MM-dd").format(AppCache.sortFilterCacheDTO!.endDate!)}", ${jsonEncode(getDaysInBetween(AppCache.sortFilterCacheDTO!.startDate!, AppCache.sortFilterCacheDTO!.endDate!))}, "${Utils.getTranslated(ctx, 'chart_footer_date_yield')}")');
                  }
                } else if (widget.dataType ==
                    Constants.CHART_DQM_DAILY_FIRST_PASS_YIELD_PROJECT) {
                  if (isFinalYield) {
                    this.dqmWebViewController.webViewController.runJavascript(
                        'fetchFinalYieldByProjectDetailData(${jsonEncode(widget.yieldBySiteDTO)}, "${DateFormat("yyyy-MM-dd").format(AppCache.sortFilterCacheDTO!.startDate!)}", "${DateFormat("yyyy-MM-dd").format(AppCache.sortFilterCacheDTO!.endDate!)}", ${jsonEncode(getDaysInBetween(AppCache.sortFilterCacheDTO!.startDate!, AppCache.sortFilterCacheDTO!.endDate!))}, ${jsonEncode(this.yieldBySiteMap)}, ${jsonEncode(this.projectList)}, "${Utils.getTranslated(ctx, 'chart_footer_date_yield')!}")');
                  } else {
                    this.dqmWebViewController.webViewController.runJavascript(
                        'fetchFirstPassYieldByProjectDetailData(${jsonEncode(widget.yieldBySiteDTO)}, "${DateFormat("yyyy-MM-dd").format(AppCache.sortFilterCacheDTO!.startDate!)}", "${DateFormat("yyyy-MM-dd").format(AppCache.sortFilterCacheDTO!.endDate!)}", ${jsonEncode(getDaysInBetween(AppCache.sortFilterCacheDTO!.startDate!, AppCache.sortFilterCacheDTO!.endDate!))}, ${jsonEncode(this.yieldBySiteMap)}, ${jsonEncode(this.projectList)}, "${Utils.getTranslated(ctx, 'chart_footer_date_yield')!}")');
                  }
                } else if (widget.dataType ==
                    Constants.CHART_DQM_DASHBOARD_VOLUME_PROJECT) {
                  this.dqmWebViewController.webViewController.runJavascript(
                      'fetchVolumeByProjectDetailData(${jsonEncode(widget.volumeByProjectDTO)}, ${jsonEncode(this.projectList)}, "${Utils.getTranslated(ctx, 'dqm_dashboard_fail')}", "${Utils.getTranslated(ctx, 'dqm_dashboard_retestpass')}", "${Utils.getTranslated(ctx, 'dqm_dashboard_firstpass')}", "${Utils.getTranslated(ctx, 'chart_footer_project_unique_board_count')}")');
                } else if (widget.dataType ==
                    Constants.CHART_DQM_DASHBOARD_WORST_TESTNAME_PROJECT) {
                  this.dqmWebViewController.webViewController.runJavascript(
                      'fetchTop5WorstTestNamesByProjectDetailData(${jsonEncode(widget.worstTestByProjectDTO)}, ${jsonEncode(this.wtnpByProjectMap)}, ${jsonEncode(this.projectList)}, "${Utils.getTranslated(ctx, 'chart_footer_project_count')}")');
                }
              }),
          JavascriptChannel(
              name: 'DQMClickChannel',
              onMessageReceived: (message) {
                if (Utils.isNotEmpty(message.message)) {
                  if (widget.dataType == Constants.CHART_DQM_DAILY_VOLUME) {
                    JSDailyBoardVolumeDataDTO dailyBoardVolumeDataDTO =
                        JSDailyBoardVolumeDataDTO.fromJson(
                            jsonDecode(message.message));
                    showTooltipsDialog(ctx, dailyBoardVolumeDataDTO);
                  } else if (widget.dataType ==
                      Constants.CHART_DQM_DAILY_FIRST_PASS_YIELD) {
                    JSFirstPassYieldDataDTO jsFirstPassYieldDataDTO =
                        JSFirstPassYieldDataDTO.fromJson(
                            jsonDecode(message.message));
                    showYieldTooltipsDialog(ctx, jsFirstPassYieldDataDTO);
                  } else if (widget.dataType ==
                      Constants.CHART_DQM_DAILY_FIRST_PASS_YIELD_PROJECT) {
                    JSYieldDataByProjectDTO jsYieldDataByProjectDTO =
                        JSYieldDataByProjectDTO.fromJson(
                            jsonDecode(message.message));
                    showYieldByProjectTooltipsDialog(
                        ctx, jsYieldDataByProjectDTO);
                  } else if (widget.dataType ==
                      Constants.CHART_DQM_DASHBOARD_VOLUME_PROJECT) {
                    if (message.message.contains('<')) {
                      List<String> splitedList = message.message.split('<');
                      AppCache.sortFilterCacheDTO!.defaultProjectId =
                          splitedList[0];
                      AppCache.sortFilterCacheDTO!.displayProjectName =
                          splitedList[0];
                      if (Utils.isNotEmpty(splitedList[1])) {
                        AppCache.sortFilterCacheDTO!.defaultVersion =
                            splitedList[1];
                      } else {
                        AppCache.sortFilterCacheDTO!.defaultVersion = 'Base';
                      }
                    } else {
                      AppCache.sortFilterCacheDTO!.defaultProjectId =
                          message.message;
                      AppCache.sortFilterCacheDTO!.displayProjectName =
                          message.message;
                      AppCache.sortFilterCacheDTO!.defaultVersion = 'Base';
                    }
                    Navigator.pop(ctx, true);
                  } else if (widget.dataType ==
                      Constants.CHART_DQM_DASHBOARD_WORST_TESTNAME_PROJECT) {
                    setState(() {
                      jsWorstTestNameByProjectDTO =
                          JSWorstTestNameByProjectDTO.fromJson(
                              jsonDecode(message.message));
                    });
                  }
                }
              }),
          JavascriptChannel(
              name: 'DQMExportImageChannel',
              onMessageReceived: (message) async {
                print(message.message);
                if (Utils.isNotEmpty(message.message)) {
                  String name = '';
                  String curDate =
                      '#${DateFormat('yyyy.MM.dd').format(DateTime.now())}@${DateFormat('HH.mm.ss').format(DateTime.now())}';
                  if (widget.dataType == Constants.CHART_DQM_DAILY_VOLUME) {
                    //KEYS_BM_DlyVol_2022-04-01_2022-08-09#2022.08.09@22.04.16
                    name = Utils.getExportFilename(
                      'DlyVol',
                      companyId: AppCache.sortFilterCacheDTO!.preferredCompany,
                      siteId: AppCache.sortFilterCacheDTO!.preferredSite,
                      fromDate: DateFormat('yyyy-MM-dd')
                          .format(AppCache.sortFilterCacheDTO!.startDate!),
                      toDate: DateFormat('yyyy-MM-dd')
                          .format(AppCache.sortFilterCacheDTO!.endDate!),
                      currentDate: curDate,
                      expType: '.png',
                    );
                  } else if (widget.dataType ==
                      Constants.CHART_DQM_DAILY_FIRST_PASS_YIELD) {
                    if (isFinalYield) {
                      //KEYS_BM_DlyFnlYild_2022-04-01_2022-08-09#2022.08.09@22.07.34
                      name = Utils.getExportFilename(
                        'DlyFnlYild',
                        companyId:
                            AppCache.sortFilterCacheDTO!.preferredCompany,
                        siteId: AppCache.sortFilterCacheDTO!.preferredSite,
                        fromDate: DateFormat('yyyy-MM-dd')
                            .format(AppCache.sortFilterCacheDTO!.startDate!),
                        toDate: DateFormat('yyyy-MM-dd')
                            .format(AppCache.sortFilterCacheDTO!.endDate!),
                        currentDate: curDate,
                        expType: '.png',
                      );
                    } else {
                      //KEYS_BM_DlyFrstPsYild_2022-04-01_2022-08-09#2022.08.09@22.05.44
                      name = Utils.getExportFilename(
                        'DlyFrstPsYild',
                        companyId:
                            AppCache.sortFilterCacheDTO!.preferredCompany,
                        siteId: AppCache.sortFilterCacheDTO!.preferredSite,
                        fromDate: DateFormat('yyyy-MM-dd')
                            .format(AppCache.sortFilterCacheDTO!.startDate!),
                        toDate: DateFormat('yyyy-MM-dd')
                            .format(AppCache.sortFilterCacheDTO!.endDate!),
                        currentDate: curDate,
                        expType: '.png',
                      );
                    }
                  } else if (widget.dataType ==
                      Constants.CHART_DQM_DAILY_FIRST_PASS_YIELD_PROJECT) {
                    if (isFinalYield) {
                      //KEYS_BM_DlyFnlYildProj_2022-04-01_2022-08-09#2022.08.09@22.07.55
                      name = Utils.getExportFilename(
                        'DlyFnlYildProj',
                        companyId:
                            AppCache.sortFilterCacheDTO!.preferredCompany,
                        siteId: AppCache.sortFilterCacheDTO!.preferredSite,
                        fromDate: DateFormat('yyyy-MM-dd')
                            .format(AppCache.sortFilterCacheDTO!.startDate!),
                        toDate: DateFormat('yyyy-MM-dd')
                            .format(AppCache.sortFilterCacheDTO!.endDate!),
                        currentDate: curDate,
                        expType: '.png',
                      );
                    } else {
                      //Daily_First_Pass_Yield_Project#2022.08.09@22.05.47
                      name = Utils.getExportFilename(
                        'Daily_First_Pass_Yield_Project',
                        currentDate: curDate,
                        expType: '.png',
                      );
                    }
                  } else if (widget.dataType ==
                      Constants.CHART_DQM_DASHBOARD_VOLUME_PROJECT) {
                    //KEYS_BM_VolProj_2022-04-01_2022-08-09#2022.08.09@22.05.52
                    name = Utils.getExportFilename(
                      'VolProj',
                      companyId: AppCache.sortFilterCacheDTO!.preferredCompany,
                      siteId: AppCache.sortFilterCacheDTO!.preferredSite,
                      fromDate: DateFormat('yyyy-MM-dd')
                          .format(AppCache.sortFilterCacheDTO!.startDate!),
                      toDate: DateFormat('yyyy-MM-dd')
                          .format(AppCache.sortFilterCacheDTO!.endDate!),
                      currentDate: curDate,
                      expType: '.png',
                    );
                  } else if (widget.dataType ==
                      Constants.CHART_DQM_DASHBOARD_WORST_TESTNAME_PROJECT) {
                    //KEYS_BM_WstTstNm_2022-04-01_2022-08-09#2022.08.09@22.05.55
                    name = Utils.getExportFilename(
                      'WstTstNm',
                      companyId: AppCache.sortFilterCacheDTO!.preferredCompany,
                      siteId: AppCache.sortFilterCacheDTO!.preferredSite,
                      fromDate: DateFormat('yyyy-MM-dd')
                          .format(AppCache.sortFilterCacheDTO!.startDate!),
                      toDate: DateFormat('yyyy-MM-dd')
                          .format(AppCache.sortFilterCacheDTO!.endDate!),
                      currentDate: curDate,
                      expType: '.png',
                    );
                  }
                  final result = await ImageApi.generateImage(
                      message.message, 600, this.chartHeight.round(), name);
                  if (result == true) {
                    setState(() {
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
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    });
                  }
                }
              }),
          JavascriptChannel(
              name: 'DQMExportPDFChannel',
              onMessageReceived: (message) async {
                if (Utils.isNotEmpty(message.message)) {
                  String name = '';
                  String curDate =
                      '#${DateFormat('yyyy.MM.dd').format(DateTime.now())}@${DateFormat('HH.mm.ss').format(DateTime.now())}';
                  if (widget.dataType == Constants.CHART_DQM_DAILY_VOLUME) {
                    name = Utils.getExportFilename(
                      'DlyVol',
                      companyId: AppCache.sortFilterCacheDTO!.preferredCompany,
                      siteId: AppCache.sortFilterCacheDTO!.preferredSite,
                      fromDate: DateFormat('yyyy-MM-dd')
                          .format(AppCache.sortFilterCacheDTO!.startDate!),
                      toDate: DateFormat('yyyy-MM-dd')
                          .format(AppCache.sortFilterCacheDTO!.endDate!),
                      currentDate: curDate,
                      expType: '.pdf',
                    );
                  } else if (widget.dataType ==
                      Constants.CHART_DQM_DAILY_FIRST_PASS_YIELD) {
                    if (isFinalYield) {
                      name = Utils.getExportFilename(
                        'DlyFnlYild',
                        companyId:
                            AppCache.sortFilterCacheDTO!.preferredCompany,
                        siteId: AppCache.sortFilterCacheDTO!.preferredSite,
                        fromDate: DateFormat('yyyy-MM-dd')
                            .format(AppCache.sortFilterCacheDTO!.startDate!),
                        toDate: DateFormat('yyyy-MM-dd')
                            .format(AppCache.sortFilterCacheDTO!.endDate!),
                        currentDate: curDate,
                        expType: '.pdf',
                      );
                    } else {
                      name = Utils.getExportFilename(
                        'DlyFrstPsYild',
                        companyId:
                            AppCache.sortFilterCacheDTO!.preferredCompany,
                        siteId: AppCache.sortFilterCacheDTO!.preferredSite,
                        fromDate: DateFormat('yyyy-MM-dd')
                            .format(AppCache.sortFilterCacheDTO!.startDate!),
                        toDate: DateFormat('yyyy-MM-dd')
                            .format(AppCache.sortFilterCacheDTO!.endDate!),
                        currentDate: curDate,
                        expType: '.pdf',
                      );
                    }
                  } else if (widget.dataType ==
                      Constants.CHART_DQM_DAILY_FIRST_PASS_YIELD_PROJECT) {
                    if (isFinalYield) {
                      name = Utils.getExportFilename(
                        'DlyFnlYildProj',
                        companyId:
                            AppCache.sortFilterCacheDTO!.preferredCompany,
                        siteId: AppCache.sortFilterCacheDTO!.preferredSite,
                        fromDate: DateFormat('yyyy-MM-dd')
                            .format(AppCache.sortFilterCacheDTO!.startDate!),
                        toDate: DateFormat('yyyy-MM-dd')
                            .format(AppCache.sortFilterCacheDTO!.endDate!),
                        currentDate: curDate,
                        expType: '.pdf',
                      );
                    } else {
                      name = Utils.getExportFilename(
                        'Daily_First_Pass_Yield_Project',
                        currentDate: curDate,
                        expType: '.pdf',
                      );
                    }
                  } else if (widget.dataType ==
                      Constants.CHART_DQM_DASHBOARD_VOLUME_PROJECT) {
                    name = Utils.getExportFilename(
                      'VolProj',
                      companyId: AppCache.sortFilterCacheDTO!.preferredCompany,
                      siteId: AppCache.sortFilterCacheDTO!.preferredSite,
                      fromDate: DateFormat('yyyy-MM-dd')
                          .format(AppCache.sortFilterCacheDTO!.startDate!),
                      toDate: DateFormat('yyyy-MM-dd')
                          .format(AppCache.sortFilterCacheDTO!.endDate!),
                      currentDate: curDate,
                      expType: '.pdf',
                    );
                  } else if (widget.dataType ==
                      Constants.CHART_DQM_DASHBOARD_WORST_TESTNAME_PROJECT) {
                    name = Utils.getExportFilename(
                      'WstTstNm',
                      companyId: AppCache.sortFilterCacheDTO!.preferredCompany,
                      siteId: AppCache.sortFilterCacheDTO!.preferredSite,
                      fromDate: DateFormat('yyyy-MM-dd')
                          .format(AppCache.sortFilterCacheDTO!.startDate!),
                      toDate: DateFormat('yyyy-MM-dd')
                          .format(AppCache.sortFilterCacheDTO!.endDate!),
                      currentDate: curDate,
                      expType: '.pdf',
                    );
                  }
                  final result = await PdfApi.generatePDF(
                      message.message, 600, this.chartHeight.round(), name,
                      isDarkTheme: this.isDarkTheme!,
                      isChineseLng: this.isChineseLng);
                  if (result == true) {
                    setState(() {
                      isLoading = false;
                      var snackBar = SnackBar(
                        content: Text(
                          Utils.getTranslated(context, 'done_download_as_pdf')!,
                          style: AppFonts.robotoRegular(
                            16,
                            color: isDarkTheme!
                                ? AppColors.appGrey()
                                : AppColorsLightMode.appGrey(),
                            decoration: TextDecoration.none,
                          ),
                        ),
                        backgroundColor: AppColors.appBlack0F(),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    });
                  }
                }
              }),
        ].toSet(),
      ),
    );
  }

  Widget footer(BuildContext ctx) {
    if (widget.dataType == Constants.CHART_DQM_DAILY_VOLUME) {
      return Container(
        padding: EdgeInsets.all(12.0),
        child: Center(
          child: Text(
            'Date/Unique Board Count',
            style: AppFonts.robotoRegular(
              11,
              color: isDarkTheme!
                  ? AppColors.appGreyB1()
                  : AppColorsLightMode.appGrey77().withOpacity(0.4),
              decoration: TextDecoration.none,
            ),
          ),
        ),
      );
    } else if (widget.dataType == Constants.CHART_DQM_DAILY_FIRST_PASS_YIELD ||
        widget.dataType == Constants.CHART_DQM_DAILY_FIRST_PASS_YIELD_PROJECT) {
      return Container(
        padding: EdgeInsets.all(12.0),
        child: Center(
          child: Text(
            'Date/Yield (%)',
            style: AppFonts.robotoRegular(
              11,
              color: isDarkTheme!
                  ? AppColors.appGreyB1()
                  : AppColorsLightMode.appGrey77().withOpacity(0.4),
              decoration: TextDecoration.none,
            ),
          ),
        ),
      );
    } else if (widget.dataType ==
        Constants.CHART_DQM_DASHBOARD_VOLUME_PROJECT) {
      return Container(
        padding: EdgeInsets.all(12.0),
        child: Center(
          child: Text(
            'Project/Unique Board Count',
            style: AppFonts.robotoRegular(
              11,
              color: isDarkTheme!
                  ? AppColors.appGreyB1()
                  : AppColorsLightMode.appGrey77().withOpacity(0.4),
              decoration: TextDecoration.none,
            ),
          ),
        ),
      );
    } else if (widget.dataType ==
        Constants.CHART_DQM_DASHBOARD_WORST_TESTNAME_PROJECT) {
      return Container(
        padding: EdgeInsets.all(12.0),
        child: Center(
          child: Text(
            'Project/Count',
            style: AppFonts.robotoRegular(
              11,
              color: isDarkTheme!
                  ? AppColors.appGreyB1()
                  : AppColorsLightMode.appGrey77().withOpacity(0.4),
              decoration: TextDecoration.none,
            ),
          ),
        ),
      );
    }

    return Container();
  }

  Widget chartInfo(BuildContext ctx) {
    if (jsWorstTestNameByProjectDTO.data != null &&
        jsWorstTestNameByProjectDTO.data!.length > 0) {
      return Container(
        width: MediaQuery.of(ctx).size.width,
        margin: EdgeInsets.all(12.0),
        padding: EdgeInsets.all(14.0),
        decoration: BoxDecoration(
          color: AppColors.appBlackLight(),
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              jsWorstTestNameByProjectDTO.projectName!,
              style: AppFonts.robotoMedium(
                14,
                color: AppColors.appPrimaryWhite(),
                decoration: TextDecoration.none,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: jsWorstTestNameByProjectDTO.data!
                  .map((e) => worstTestNameItem(ctx, e))
                  .toList(),
            ),
          ],
        ),
      );
    }

    return Container();
  }

  Widget worstTestNameItem(
      BuildContext ctx, JSWorstTestNameByProjectDataDTO dataDTO) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          ctx,
          AppRoutes.dqmTestResultInfoRoute,
          arguments: DqmTestResultArguments(
            testname: dataDTO.testname,
            testType: dataDTO.testtype,
            projectId: dataDTO.projectId,
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(top: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 2,
              child: Text(
                '${dataDTO.testname!}: ',
                style: AppFonts.robotoMedium(
                  14,
                  color: HexColor(dataDTO.colorCode!.substring(0)),
                  decoration: TextDecoration.none,
                ),
              ),
            ),
            SizedBox(width: 12.0),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Text(
                      dataDTO.failedCount.toString(),
                      style: AppFonts.robotoMedium(
                        16,
                        color: isDarkTheme!
                            ? AppColors.appGrey2()
                            : AppColorsLightMode.appGrey2(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                  SizedBox(width: 20.0),
                  Image.asset(Constants.ASSET_IMAGES + 'next_bttn.png'),
                  SizedBox(width: 20.0),
                ],
              ),
            ),
          ],
        ),
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
                this
                    .dqmWebViewController
                    .webViewController
                    .runJavascript('exportImage()');
                Navigator.pop(popContext);
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
                final bool result;
                String curDate =
                    '#${DateFormat('yyyy.MM.dd').format(DateTime.now())}@${DateFormat('HH.mm.ss').format(DateTime.now())}';
                if (widget.dataType == Constants.CHART_DQM_DAILY_VOLUME) {
                  String filename = Utils.getExportFilename(
                    'DlyVol',
                    companyId: AppCache.sortFilterCacheDTO!.preferredCompany,
                    siteId: AppCache.sortFilterCacheDTO!.preferredSite,
                    fromDate: DateFormat('yyyy-MM-dd')
                        .format(AppCache.sortFilterCacheDTO!.startDate!),
                    toDate: DateFormat('yyyy-MM-dd')
                        .format(AppCache.sortFilterCacheDTO!.endDate!),
                    currentDate: curDate,
                    expType: '.csv',
                  );

                  result = await CSVApi.generateCSV(
                      widget.dailyBoardVolumeDTO!.data!, filename);
                } else if (widget.dataType ==
                    Constants.CHART_DQM_DAILY_FIRST_PASS_YIELD) {
                  if (isFinalYield) {
                    String filename = Utils.getExportFilename(
                      'DlyFnlYild',
                      companyId: AppCache.sortFilterCacheDTO!.preferredCompany,
                      siteId: AppCache.sortFilterCacheDTO!.preferredSite,
                      fromDate: DateFormat('yyyy-MM-dd')
                          .format(AppCache.sortFilterCacheDTO!.startDate!),
                      toDate: DateFormat('yyyy-MM-dd')
                          .format(AppCache.sortFilterCacheDTO!.endDate!),
                      currentDate: curDate,
                      expType: '.csv',
                    );
                    result = await CSVApi.generateCSV(
                        widget.dailyBoardVolumeDTO!.data!, filename);
                  } else {
                    String filename = Utils.getExportFilename(
                      'DlyFrstPsYild',
                      companyId: AppCache.sortFilterCacheDTO!.preferredCompany,
                      siteId: AppCache.sortFilterCacheDTO!.preferredSite,
                      fromDate: DateFormat('yyyy-MM-dd')
                          .format(AppCache.sortFilterCacheDTO!.startDate!),
                      toDate: DateFormat('yyyy-MM-dd')
                          .format(AppCache.sortFilterCacheDTO!.endDate!),
                      currentDate: curDate,
                      expType: '.csv',
                    );
                    result = await CSVApi.generateCSV(
                        widget.dailyBoardVolumeDTO!.data!, filename);
                  }
                } else if (widget.dataType ==
                    Constants.CHART_DQM_DAILY_FIRST_PASS_YIELD_PROJECT) {
                  if (isFinalYield) {
                    String filename = Utils.getExportFilename('DlyFnlYildProj',
                        companyId:
                            AppCache.sortFilterCacheDTO!.preferredCompany,
                        siteId: AppCache.sortFilterCacheDTO!.preferredSite,
                        fromDate: DateFormat('yyyy-MM-dd')
                            .format(AppCache.sortFilterCacheDTO!.startDate!),
                        toDate: DateFormat('yyyy-MM-dd')
                            .format(AppCache.sortFilterCacheDTO!.endDate!),
                        currentDate: curDate,
                        expType: '.csv');

                    result = await CSVApi.generateCSV(
                        widget.yieldBySiteDTO!.data!, filename);
                  } else {
                    String filename = Utils.getExportFilename(
                      'Daily_First_Pass_Yield_Project',
                      currentDate: curDate,
                      expType: '.csv',
                    );

                    result = await CSVApi.generateCSV(
                        widget.yieldBySiteDTO!.data!, filename);
                  }
                } else if (widget.dataType ==
                    Constants.CHART_DQM_DASHBOARD_VOLUME_PROJECT) {
                  String filename = Utils.getExportFilename(
                    'VolProj',
                    companyId: AppCache.sortFilterCacheDTO!.preferredCompany,
                    siteId: AppCache.sortFilterCacheDTO!.preferredSite,
                    fromDate: DateFormat('yyyy-MM-dd')
                        .format(AppCache.sortFilterCacheDTO!.startDate!),
                    toDate: DateFormat('yyyy-MM-dd')
                        .format(AppCache.sortFilterCacheDTO!.endDate!),
                    currentDate: curDate,
                    expType: '.csv',
                  );

                  result = await CSVApi.generateCSV(
                      widget.volumeByProjectDTO!.data!, filename);
                } else if (widget.dataType ==
                    Constants.CHART_DQM_DASHBOARD_WORST_TESTNAME_PROJECT) {
                  String filename = Utils.getExportFilename(
                    'WstTstNm',
                    companyId: AppCache.sortFilterCacheDTO!.preferredCompany,
                    siteId: AppCache.sortFilterCacheDTO!.preferredSite,
                    fromDate: DateFormat('yyyy-MM-dd')
                        .format(AppCache.sortFilterCacheDTO!.startDate!),
                    toDate: DateFormat('yyyy-MM-dd')
                        .format(AppCache.sortFilterCacheDTO!.endDate!),
                    currentDate: curDate,
                    expType: '.csv',
                  );

                  result = await CSVApi.generateCSV(
                      widget.worstTestByProjectDTO!.data!, filename);
                } else {
                  result = false;
                }

                Navigator.pop(popContext);
                if (result == true) {
                  setState(() {
                    isLoading = false;
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
                this
                    .dqmWebViewController
                    .webViewController
                    .runJavascript('exportPDF()');
                Navigator.pop(popContext);
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

  void showTooltipsDialog(BuildContext context,
      JSDailyBoardVolumeDataDTO jsDailyBoardVolumeDataDTO) {
    showDialog(
      context: context,
      builder: (tooltipsDialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: chartTooltipsInfo(
              tooltipsDialogContext, jsDailyBoardVolumeDataDTO),
        );
      },
    );
  }

  void showYieldTooltipsDialog(
      BuildContext context, JSFirstPassYieldDataDTO jsFirstPassYieldDataDTO) {
    showDialog(
      context: context,
      builder: (tooltipsDialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: chartYieldTooltipsInfo(
              tooltipsDialogContext, jsFirstPassYieldDataDTO),
        );
      },
    );
  }

  void showYieldByProjectTooltipsDialog(
      BuildContext context, JSYieldDataByProjectDTO jsYieldDataByProjectDTO) {
    showDialog(
      context: context,
      builder: (tooltipsDialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: chartYieldByProjectTooltipsInfo(
              tooltipsDialogContext, jsYieldDataByProjectDTO),
        );
      },
    );
  }

  Widget chartTooltipsInfo(
      BuildContext ctx, JSDailyBoardVolumeDataDTO jsDailyBoardVolumeDataDTO) {
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
                .format(DateTime.parse(jsDailyBoardVolumeDataDTO.date!)),
            style: AppFonts.robotoRegular(
              16,
              color: isDarkTheme!
                  ? AppColors.appGrey2()
                  : AppColorsLightMode.appGrey2(),
              decoration: TextDecoration.none,
            ),
          ),
          SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: HexColor('e3032a'),
                      ),
                    ),
                    SizedBox(width: 10.0),
                    Text(
                      jsDailyBoardVolumeDataDTO.failed.toString(),
                      style: AppFonts.robotoRegular(
                        16,
                        color: isDarkTheme!
                            ? AppColors.appGrey2()
                            : AppColorsLightMode.appGrey2(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: HexColor('f66a01'),
                      ),
                    ),
                    SizedBox(width: 10.0),
                    Text(
                      jsDailyBoardVolumeDataDTO.rework.toString(),
                      style: AppFonts.robotoRegular(
                        16,
                        color: isDarkTheme!
                            ? AppColors.appGrey2()
                            : AppColorsLightMode.appGrey2(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: HexColor('73d329'),
                      ),
                    ),
                    SizedBox(width: 10.0),
                    Text(
                      jsDailyBoardVolumeDataDTO.firstPass.toString(),
                      style: AppFonts.robotoRegular(
                        16,
                        color: isDarkTheme!
                            ? AppColors.appGrey2()
                            : AppColorsLightMode.appGrey2(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget chartYieldTooltipsInfo(
      BuildContext ctx, JSFirstPassYieldDataDTO jsFirstPassYieldDataDTO) {
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
                .format(DateTime.parse(jsFirstPassYieldDataDTO.date!)),
            style: AppFonts.robotoRegular(
              16,
              color: isDarkTheme!
                  ? AppColors.appGrey2()
                  : AppColorsLightMode.appGrey2(),
              decoration: TextDecoration.none,
            ),
          ),
          SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      isFinalYield
                          ? Utils.getTranslated(
                              ctx, 'dqm_testreuslt_finalyield')!
                          : Utils.getTranslated(
                              ctx, 'dqm_testreuslt_firstpassyield')!,
                      style: AppFonts.robotoMedium(
                        14,
                        color: HexColor('73d329'),
                        decoration: TextDecoration.none,
                      ),
                    ),
                    SizedBox(width: 10.0),
                    Text(
                      jsFirstPassYieldDataDTO.firstPassYield!
                          .toStringAsFixed(2),
                      style: AppFonts.robotoRegular(
                        16,
                        color: isDarkTheme!
                            ? AppColors.appGrey2()
                            : AppColorsLightMode.appGrey2(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget chartYieldByProjectTooltipsInfo(
      BuildContext ctx, JSYieldDataByProjectDTO jsYieldDataByProjectDTO) {
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
                .format(DateTime.parse(jsYieldDataByProjectDTO.date!)),
            style: AppFonts.robotoRegular(
              16,
              color: isDarkTheme!
                  ? AppColors.appGrey2()
                  : AppColorsLightMode.appGrey2(),
              decoration: TextDecoration.none,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: jsYieldDataByProjectDTO.data!
                .map((e) => chartYieldByProjectItem(ctx, e))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget chartYieldByProjectItem(
      BuildContext ctx, JSYieldDataByProjectDataDTO dataDTO) {
    return Container(
      margin: EdgeInsets.only(top: 14.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${dataDTO.projectName!}: ',
                  style: AppFonts.robotoMedium(
                    14,
                    color: HexColor(dataDTO.colorCode!.substring(0)),
                    decoration: TextDecoration.none,
                  ),
                ),
                SizedBox(width: 10.0),
                Text(
                  dataDTO.yieldValue!.toString(),
                  style: AppFonts.robotoRegular(
                    16,
                    color: isDarkTheme!
                        ? AppColors.appGrey2()
                        : AppColorsLightMode.appGrey2(),
                    decoration: TextDecoration.none,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
