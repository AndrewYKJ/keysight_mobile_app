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
import 'package:keysight_pma/dio/api/oee.dart';
import 'package:keysight_pma/model/arguments/dqm_argument.dart';
import 'package:keysight_pma/model/arguments/oee_argument.dart';
import 'package:keysight_pma/model/customize.dart';
import 'package:keysight_pma/model/dqm/yield_by_site.dart';
import 'package:keysight_pma/model/js/js.dart';
import 'package:keysight_pma/model/oee/oeeSummary.dart';
import 'package:keysight_pma/model/oee/oeeSummaryPerformance.dart';
import 'package:keysight_pma/model/oee/oeeSummaryQuality.dart';
import 'package:keysight_pma/routes/approutes.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

import '../../../dio/api/oee.dart';
import '../../../model/oee/oeeSummary.dart';

class OeeMetricDetailScreen extends StatefulWidget {
  final String appBarTitle;
  final int currentTab;
  final String selectedCompany;
  final String selectedSite;
  final String dataType;
  OeeMetricDetailScreen(
      {Key? key,
      required this.selectedCompany,
      required this.selectedSite,
      required this.appBarTitle,
      required this.dataType,
      required this.currentTab})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _OeeMetricDetailScreen();
  }
}

class _OeeMetricDetailScreen extends State<OeeMetricDetailScreen> {
  late WebViewPlusController dqmWebViewController;
  late Map<String?, List<OeeSummaryDataDTO>> dataByProjectMap;
  late Map<String?, List<OeeQualityDataDTO>> dataQualityByProjectMap;
  late Map<String?, List<OeePerformanceDataDTO>> dataPerformanceByProjectMap;

  bool? theme_dark = AppCache.sortFilterCacheDTO!.currentTheme;
  List<OeeSummaryDataDTO>? availableDataList;
  List<OeeQualityDataDTO>? qualityDataList;
  List<OeePerformanceDataDTO>? performanceDataList;
  List<CustomDqmSortFilterProjectsDTO> projectList = [];
  bool isLoading = true;
  String sortBy = Constants.SORT_BY_VOLUME;
  double chartHeight = 316.0;

  OeeSummaryDTO getAvailabilityBySiteDTO = OeeSummaryDTO();
  Future<OeeSummaryDTO> getAggregatedAvailabilityByEquipment(
      BuildContext context) {
    OeeApi oeeApi = OeeApi(context);
    return oeeApi.getAggregatedAvailabilityByEquipment(
        widget.selectedCompany,
        widget.selectedSite,
        DateFormat("yyyy-MM-dd")
            .format(AppCache.sortFilterCacheDTO!.startDate!),
        DateFormat("yyyy-MM-dd").format(AppCache.sortFilterCacheDTO!.endDate!));
  }

  OeePerformanceDTO getPerformanceBySiteDTO = OeePerformanceDTO();
  Future<OeePerformanceDTO> getAggregatedPerformanceByEquipment(
      BuildContext context) {
    OeeApi oeeApi = OeeApi(context);
    return oeeApi.getAggregatedPerformanceByEquipment(
        widget.selectedCompany,
        widget.selectedSite,
        DateFormat("yyyy-MM-dd")
            .format(AppCache.sortFilterCacheDTO!.startDate!),
        DateFormat("yyyy-MM-dd").format(AppCache.sortFilterCacheDTO!.endDate!));
  }

  OeeQualityDTO getQualityBySiteDTO = OeeQualityDTO();
  Future<OeeQualityDTO> getAggregatedQualityByEquipment(BuildContext context) {
    OeeApi oeeApi = OeeApi(context);
    return oeeApi.getAggregatedQualityByEquipment(
        widget.selectedCompany,
        widget.selectedSite,
        DateFormat("yyyy-MM-dd")
            .format(AppCache.sortFilterCacheDTO!.startDate!),
        DateFormat("yyyy-MM-dd").format(AppCache.sortFilterCacheDTO!.endDate!));
  }

  void groupDataByProjects(
      List<OeeSummaryDataDTO>? available,
      List<OeeQualityDataDTO>? quality,
      List<OeePerformanceDataDTO>? performance,
      int currentTab) {
    if (currentTab == 0) {
      final groups = groupBy(available!, (OeeSummaryDataDTO e) {
        return e.equipmentId;
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
    } else if (currentTab == 1) {
      final groups = groupBy(quality!, (OeeQualityDataDTO e) {
        return e.equipmentId;
      });
      setState(() {
        this.isLoading = false;
        this.dataQualityByProjectMap = groups;
        this.dataQualityByProjectMap.keys.forEach((projectId) {
          CustomDqmSortFilterProjectsDTO customDTO =
              CustomDqmSortFilterProjectsDTO(projectId, true);
          this.projectList.add(customDTO);
        });
      });
    } else if (currentTab == 2) {
      final groups = groupBy(performance!, (OeePerformanceDataDTO e) {
        return e.equipmentId;
      });
      setState(() {
        this.isLoading = false;
        this.dataPerformanceByProjectMap = groups;
        this.dataPerformanceByProjectMap.keys.forEach((projectId) {
          CustomDqmSortFilterProjectsDTO customDTO =
              CustomDqmSortFilterProjectsDTO(projectId, true);
          this.projectList.add(customDTO);
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();
    Utils.setFirebaseAnalyticsCurrentScreen(
        Constants.ANALYTICS_OEE_SUMMARY_UTILIZATION_TIME_BY_EQUIP_SCREEN);
    callGetDataByEquipment(context, widget.currentTab);
  }

  callGetDataByEquipment(BuildContext context, int currentTab) {
    if (currentTab == 0)
      getAggregatedAvailabilityByEquipment(context).then((value) {
        if (value.data != null && value.data!.length > 0) {
          availableDataList = value.data;
          groupDataByProjects(value.data!, null, null, currentTab);
        }
      }).catchError((error) {
        if (error is DioError) {
          if (error.response != null) {
            if (error.response!.data != null) {
              Utils.showAlertDialog(
                  context,
                  Utils.getTranslated(context, 'general_alert_error_title')!,
                  error.response!.data.toString());
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
    if (currentTab == 1)
      getAggregatedQualityByEquipment(context).then((value) {
        if (value.data != null && value.data!.length > 0) {
          qualityDataList = value.data!;
          groupDataByProjects(null, value.data!, null, currentTab);
        }
      }).catchError((error) {
        if (error is DioError) {
          if (error.response != null) {
            if (error.response!.data != null) {
              Utils.showAlertDialog(
                  context,
                  Utils.getTranslated(context, 'general_alert_error_title')!,
                  error.response!.data.toString());
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
    if (currentTab == 2)
      getAggregatedPerformanceByEquipment(context).then((value) {
        if (value.data != null && value.data!.length > 0) {
          performanceDataList = value.data;
          groupDataByProjects(null, null, value.data!, currentTab);
        }
      }).catchError((error) {
        if (error is DioError) {
          if (error.response != null) {
            if (error.response!.data != null) {
              Utils.showAlertDialog(
                  context,
                  Utils.getTranslated(context, 'general_alert_error_title')!,
                  error.response!.data.toString());
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
        backgroundColor: theme_dark!
            ? AppColors.serverAppBar()
            : AppColorsLightMode.serverAppBar(),
        centerTitle: true,
        title: Padding(
          padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
          child: Text(
            widget.appBarTitle,
            style: AppFonts.robotoRegular(
              20,
              color: theme_dark!
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
            theme_dark!
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
              theme_dark!
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
              fromWhere: 12345,
            ),
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
        initialUrl: theme_dark!
            ? 'assets/html/oee_highchart_dark_theme.html'
            : 'assets/html/oee_highchart_light_theme.html',
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
              name: 'OEEChannel',
              onMessageReceived: (message) {
                if (widget.currentTab == 0) {
                  if (widget.dataType == '0') {
                    this.dqmWebViewController.webViewController.runJavascript(
                        'fetchSummaryUtilTimeDetail(${jsonEncode(this.dataByProjectMap)}, ${jsonEncode(this.projectList)}, "${this.sortBy}")');
                  } else if (widget.dataType == '1') {
                    this.dqmWebViewController.webViewController.runJavascript(
                        'fetchSummaryAvailableTimeDetail(${jsonEncode(this.dataByProjectMap)}, ${jsonEncode(this.projectList)}, "${this.sortBy}")');
                  } else if (widget.dataType == '2') {
                    this.dqmWebViewController.webViewController.runJavascript(
                        'fetchSummaryPlannedDownTimeDetail(${jsonEncode(this.dataByProjectMap)}, ${jsonEncode(this.projectList)}, "${this.sortBy}")');
                  }
                } else if (widget.currentTab == 1) {
                  if (widget.dataType == '0') {
                    this.dqmWebViewController.webViewController.runJavascript(
                        'fetchSummaryQualityRetestPassFailedDetail(${jsonEncode(this.dataQualityByProjectMap)}, ${jsonEncode(this.projectList)}, "${this.sortBy}")');
                  } else if (widget.dataType == '1') {
                    this.dqmWebViewController.webViewController.runJavascript(
                        'fetchSummaryQualityFPYDetail(${jsonEncode(this.dataQualityByProjectMap)}, ${jsonEncode(this.projectList)}, "${this.sortBy}")');
                  } else if (widget.dataType == '2') {
                    this.dqmWebViewController.webViewController.runJavascript(
                        'fetchSummaryQualityYieldDetail(${jsonEncode(this.dataQualityByProjectMap)}, ${jsonEncode(this.projectList)}, "${this.sortBy}")');
                  }
                } else if (widget.currentTab == 2) {
                  if (widget.dataType == '0') {
                    this.dqmWebViewController.webViewController.runJavascript(
                        'fetchSummaryPerformanceRetestPassFailedDetail(${jsonEncode(this.dataPerformanceByProjectMap)}, ${jsonEncode(this.projectList)}, "${this.sortBy}")');
                  } else if (widget.dataType == '1') {
                    this.dqmWebViewController.webViewController.runJavascript(
                        'fetchSummaryPerformanceFirstPassDetail(${jsonEncode(this.dataPerformanceByProjectMap)}, ${jsonEncode(this.projectList)}, "${this.sortBy}")');
                  } else if (widget.dataType == '2') {
                    this.dqmWebViewController.webViewController.runJavascript(
                        'fetchSummaryPerformanceIdealCycleDetail(${jsonEncode(this.dataPerformanceByProjectMap)}, ${jsonEncode(this.projectList)}, "${this.sortBy}")');
                  }
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
                  AppRoutes.oeeSummarySiteMetricbyEquipment,
                  arguments: OeeChartDetailArguments(
                      currentTab: widget.currentTab,
                      selectedCompany: widget.selectedCompany,
                      selectedSite: widget.selectedSite,
                      selectedEquipment: dataDTO.projectId),
                );
              }),
          JavascriptChannel(
              name: 'DQMExportImageChannel',
              onMessageReceived: (message) async {
                print(message.message);
                if (Utils.isNotEmpty(message.message)) {
                  String name = 'oeeSIteMetricChart.png';

                  final result = await ImageApi.generateSummaryImage(
                      message.message,
                      600,
                      this.chartHeight.round(),
                      1200,
                      null,
                      null,
                      name);
                  if (result != null && result == true) {
                    setState(() {
                      // print('################## hihi');
                      var snackBar = SnackBar(
                        content: Text(
                          Utils.getTranslated(
                              context, 'done_download_as_image')!,
                          style: AppFonts.robotoRegular(
                            16,
                            color: theme_dark!
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
                  String name = 'oeeSIteMetricChart.pdf';

                  final result = await PdfApi.generateSummaryPDF(
                      message.message,
                      600,
                      this.chartHeight.round(),
                      1200,
                      null,
                      null,
                      name);
                  if (result != null && result == true) {
                    setState(() {
                      // print('################## hihi');
                      var snackBar = SnackBar(
                        content: Text(
                          Utils.getTranslated(context, 'done_download_as_pdf')!,
                          style: AppFonts.robotoRegular(
                            16,
                            color: theme_dark!
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
            color: theme_dark!
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
                  color: theme_dark!
                      ? AppColors.appPrimaryWhite().withOpacity(0.8)
                      : AppColorsLightMode.appGrey(),
                  decoration: TextDecoration.none,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Container(
            color: theme_dark!
                ? AppColors.cupertinoBackground()
                : AppColorsLightMode.cupertinoBackground().withOpacity(0.8),
            child: CupertinoActionSheetAction(
              onPressed: () async {
                Navigator.pop(downloadContext);
                var object = [];
                String name = "metricDetail.csv";
                if (widget.currentTab == 0) {
                  object = this.availableDataList!;
                } else if (widget.currentTab == 1) {
                  object = this.qualityDataList!;
                } else if (widget.currentTab == 2) {
                  object = this.performanceDataList!;
                }

                final result = await CSVApi.generateSummaryCSV(
                    object, name, 1200, null, null);
                if (result != null && result == true) {
                  setState(() {
                    // print('################## hihi');
                    var snackBar = SnackBar(
                      content: Text(
                        Utils.getTranslated(context, 'done_download_as_csv')!,
                        style: AppFonts.robotoRegular(
                          16,
                          color: theme_dark!
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
                  color: theme_dark!
                      ? AppColors.appPrimaryWhite().withOpacity(0.8)
                      : AppColorsLightMode.appGrey(),
                  decoration: TextDecoration.none,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Container(
            color: theme_dark!
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
                  color: theme_dark!
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
            color: theme_dark!
                ? AppColors.cupertinoBackground()
                : AppColorsLightMode.cupertinoBackground().withOpacity(0.8),
            borderRadius: BorderRadius.circular(10),
          ),
          child: CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(downloadContext);
            },
            child: Text(
              Utils.getTranslated(context, 'cancel')!,
              style: AppFonts.robotoMedium(
                15,
                color: theme_dark!
                    ? AppColors.appPrimaryWhite().withOpacity(0.8)
                    : AppColorsLightMode.appCancelBlue(),
                decoration: TextDecoration.none,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
