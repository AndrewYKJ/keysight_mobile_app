import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:keysight_pma/cache/appcache.dart';
import 'package:keysight_pma/const/appcolors.dart';
import 'package:keysight_pma/const/appfonts.dart';
import 'package:keysight_pma/const/constants.dart';
import 'package:keysight_pma/const/download.dart';
import 'package:keysight_pma/const/utils.dart';
import 'package:keysight_pma/dio/api/dqm.dart';
import 'package:keysight_pma/model/arguments/dqm_argument.dart';
import 'package:keysight_pma/model/customize.dart';
import 'package:keysight_pma/model/dqm/yield_by_site.dart';
import 'package:keysight_pma/model/js/js.dart';
import 'package:keysight_pma/routes/approutes.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

class DqmQualityMetricDetailScreen extends StatefulWidget {
  final String? appBarTitle;
  final String? sumType;
  DqmQualityMetricDetailScreen({Key? key, this.appBarTitle, this.sumType})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DqmQualityMetricDetailScreen();
  }
}

class _DqmQualityMetricDetailScreen
    extends State<DqmQualityMetricDetailScreen> {
  late WebViewPlusController dqmWebViewController;
  late Map<String?, List<YieldBySiteDataDTO>> dataByProjectMap;
  List<CustomDqmSortFilterProjectsDTO> projectList = [];
  List<YieldBySiteDataDTO> rawDataDTO = [];
  bool isLoading = true;
  String sortBy = Constants.SORT_BY_VOLUME;
  double chartHeight = 316.0;
  bool? isDarkTheme = AppCache.sortFilterCacheDTO!.currentTheme;
  bool isChineseLng = false;

  Future<YieldBySiteDTO> getYieldBySite(BuildContext context) {
    DqmApi dqmApi = DqmApi(context);
    return dqmApi.getYieldBySite(
        AppCache.sortFilterCacheDTO!.preferredCompany!,
        AppCache.sortFilterCacheDTO!.preferredSite!,
        DateFormat("yyyy-MM-dd")
            .format(AppCache.sortFilterCacheDTO!.startDate!),
        DateFormat("yyyy-MM-dd").format(AppCache.sortFilterCacheDTO!.endDate!));
  }

  void groupDataByProjects(List<YieldBySiteDataDTO> data) {
    final groups = groupBy(data, (YieldBySiteDataDTO e) {
      return e.projectId;
    });

    setState(() {
      this.isLoading = false;
      this.dataByProjectMap = groups;
      this.dataByProjectMap.keys.forEach((projectId) {
        CustomDqmSortFilterProjectsDTO customDTO =
            CustomDqmSortFilterProjectsDTO(projectId, true);
        this.projectList.add(customDTO);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    Utils.setFirebaseAnalyticsCurrentScreen(
        Constants.ANALYTICS_DQM_SUMMARY_DETAIL_SCREEN);
    callGetDataByProject(context);

    AppCache.getStringValue(AppCache.LANGUAGE_CODE_PREF).then((value) {
      if (Utils.isNotEmpty(value) && value == Constants.LANGUAGE_CODE_CN) {
        this.isChineseLng = true;
      } else {
        this.isChineseLng = false;
      }
    });
  }

  callGetDataByProject(BuildContext context) {
    getYieldBySite(context).then((value) {
      if (value.data != null && value.data!.length > 0) {
        groupDataByProjects(value.data!);
        rawDataDTO = value.data!;
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
            widget.appBarTitle!,
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
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              showDownloadPopup(context);
            },
            child: Image.asset(
              isDarkTheme!
                  ? Constants.ASSET_IMAGES + 'download_bttn.png'
                  : Constants.ASSET_IMAGES_LIGHT + 'download_bttn.png',
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: !this.isLoading
              ? Stack(
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          chart(context),
                        ],
                      ),
                    ),
                    sortAndFilter(context),
                  ],
                )
              : Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppColors.appBlue()),
                  ),
                ),
        ),
      ),
    );
  }

  Widget sortAndFilter(BuildContext ctx) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: TextButton(
        onPressed: () async {
          final navigateResult = await Navigator.pushNamed(
            ctx,
            AppRoutes.dqmSummaryQualityMetricSortFilterRoute,
            arguments: DqmSortFilterArguments(
                projectIdList: this.projectList,
                sortBy: this.sortBy,
                fromWhere: Constants.FROM_DQMS_PROJECT),
          );

          if (navigateResult != null) {
            DqmSortFilterArguments arguments =
                navigateResult as DqmSortFilterArguments;
            this.projectList = arguments.projectIdList!;
            this.sortBy = arguments.sortBy!;
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
              Image.asset(isDarkTheme!
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
    );
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
            ? 'assets/html/highstock_dark_theme.html'
            : 'assets/html/highstock_light_theme.html',
        zoomEnabled: false,
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
                if (widget.sumType == Constants.SUMMARY_TYPE_FAILURE) {
                  this.dqmWebViewController.webViewController.runJavascript(
                      'fetchSummaryFailureDetailData(${jsonEncode(this.dataByProjectMap)}, ${jsonEncode(this.projectList)}, "${this.sortBy}")');
                } else if (widget.sumType ==
                    Constants.SUMMARY_TYPE_FIRST_PASS) {
                  this.dqmWebViewController.webViewController.runJavascript(
                      'fetchSummaryFirstPassDetailData(${jsonEncode(this.dataByProjectMap)}, ${jsonEncode(this.projectList)}, "${this.sortBy}")');
                } else if (widget.sumType == Constants.SUMMARY_TYPE_YIELD) {
                  this.dqmWebViewController.webViewController.runJavascript(
                      'fetchSummaryYieldDetailtData(${jsonEncode(this.dataByProjectMap)}, ${jsonEncode(this.projectList)}, "${this.sortBy}")');
                }
              }),
          JavascriptChannel(
              name: 'DQMClickChannel',
              onMessageReceived: (message) {
                print(message.message);
                JSMetricQualityByProjectDataDTO dataDTO =
                    JSMetricQualityByProjectDataDTO.fromJson(
                        jsonDecode(message.message));
                Navigator.pushNamed(
                  ctx,
                  AppRoutes.dqmSummaryQualityMetricByProjectRoute,
                  arguments: DqmSummaryQmArguments(
                    dataDTO: dataDTO,
                    sumType: widget.sumType,
                  ),
                );
              }),
          JavascriptChannel(
              name: 'DQMExportImageChannel',
              onMessageReceived: (message) async {
                print(message.message);
                if (Utils.isNotEmpty(message.message)) {
                  //KEYS_BM_DQMProj_2022-04-01_2022-08-09#2022.08.10@00.22.55
                  String name = '';
                  String curDate =
                      '#${DateFormat('yyyy.MM.dd').format(DateTime.now())}@${DateFormat('HH.mm.ss').format(DateTime.now())}';
                  if (widget.sumType == Constants.SUMMARY_TYPE_FAILURE ||
                      widget.sumType == Constants.SUMMARY_TYPE_FIRST_PASS ||
                      widget.sumType == Constants.SUMMARY_TYPE_YIELD) {
                    name = Utils.getExportFilename(
                      'DQMProj',
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
                  if (widget.sumType == Constants.SUMMARY_TYPE_FAILURE ||
                      widget.sumType == Constants.SUMMARY_TYPE_FIRST_PASS ||
                      widget.sumType == Constants.SUMMARY_TYPE_YIELD) {
                    name = Utils.getExportFilename(
                      'DQMProj',
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
                      var snackBar = SnackBar(
                        content: Text(
                          Utils.getTranslated(context, 'done_download_as_pdf')!,
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
        ].toSet(),
      ),
    );
  }

  void showDownloadPopup(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext downloadContext) => CupertinoActionSheet(
        actions: [
          Container(
            color: isDarkTheme!
                ? AppColors.cupertinoBackground()
                : AppColorsLightMode.cupertinoBackground().withOpacity(0.8),
            child: CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(downloadContext);
                this
                    .dqmWebViewController
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
                Navigator.pop(downloadContext);
                List<String> selectedProject = [];
                projectList.forEach((element) {
                  if (element.isSelected!) {
                    selectedProject.add(element.projectId!);
                  }
                });
                var object = [];
                String name = '';
                String curDate =
                    '#${DateFormat('yyyy.MM.dd').format(DateTime.now())}@${DateFormat('HH.mm.ss').format(DateTime.now())}';

                if (widget.sumType == Constants.SUMMARY_TYPE_FAILURE) {
                  name = Utils.getExportFilename(
                    'DQMProj',
                    companyId: AppCache.sortFilterCacheDTO!.preferredCompany,
                    siteId: AppCache.sortFilterCacheDTO!.preferredSite,
                    fromDate: DateFormat('yyyy-MM-dd')
                        .format(AppCache.sortFilterCacheDTO!.startDate!),
                    toDate: DateFormat('yyyy-MM-dd')
                        .format(AppCache.sortFilterCacheDTO!.endDate!),
                    currentDate: curDate,
                    expType: '.csv',
                  );

                  rawDataDTO.forEach((element) {
                    if (selectedProject.contains(element.projectId)) {
                      object.add({
                        "projectId": element.projectId,
                        "failure": (element.failed),
                      });
                    }
                  });
                } else if (widget.sumType ==
                    Constants.SUMMARY_TYPE_FIRST_PASS) {
                  name = Utils.getExportFilename(
                    'DQMProj',
                    companyId: AppCache.sortFilterCacheDTO!.preferredCompany,
                    siteId: AppCache.sortFilterCacheDTO!.preferredSite,
                    fromDate: DateFormat('yyyy-MM-dd')
                        .format(AppCache.sortFilterCacheDTO!.startDate!),
                    toDate: DateFormat('yyyy-MM-dd')
                        .format(AppCache.sortFilterCacheDTO!.endDate!),
                    currentDate: curDate,
                    expType: '.csv',
                  );

                  rawDataDTO.forEach((element) {
                    if (selectedProject.contains(element.projectId)) {
                      object.add({
                        "projectId": element.projectId,
                        "FirstPass": ((element.firstPass! /
                                (element.firstPass! +
                                    element.rework! +
                                    element.failed!)) *
                            100),
                      });
                    }
                  });
                } else if (widget.sumType == Constants.SUMMARY_TYPE_YIELD) {
                  name = Utils.getExportFilename(
                    'DQMProj',
                    companyId: AppCache.sortFilterCacheDTO!.preferredCompany,
                    siteId: AppCache.sortFilterCacheDTO!.preferredSite,
                    fromDate: DateFormat('yyyy-MM-dd')
                        .format(AppCache.sortFilterCacheDTO!.startDate!),
                    toDate: DateFormat('yyyy-MM-dd')
                        .format(AppCache.sortFilterCacheDTO!.endDate!),
                    currentDate: curDate,
                    expType: '.csv',
                  );

                  rawDataDTO.forEach((element) {
                    if (selectedProject.contains(element.projectId)) {
                      object.add({
                        "projectId": element.projectId,
                        "Yield": (((element.firstPass! + element.rework!) /
                                (element.firstPass! +
                                    element.rework! +
                                    element.failed!)) *
                            100),
                      });
                    }
                  });
                }
                final result = await CSVApi.generateCSV(object, name);
                if (result == true) {
                  setState(() {
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
                Navigator.pop(downloadContext);
                this
                    .dqmWebViewController
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
              Navigator.pop(downloadContext);
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
