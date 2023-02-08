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

class OeeMetricDetailByProjectScreen extends StatefulWidget {
  final String appBarTitle;
  final int currentTab;
  final String selectedCompany;
  final String selectedSite;
  final String dataType;
  final String selectedEquipment;
  OeeMetricDetailByProjectScreen(
      {Key? key,
      required this.selectedCompany,
      required this.selectedSite,
      required this.appBarTitle,
      required this.selectedEquipment,
      required this.dataType,
      required this.currentTab})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _OeeMetricDetailByProjectScreen();
  }
}

class _OeeMetricDetailByProjectScreen
    extends State<OeeMetricDetailByProjectScreen> {
  late WebViewPlusController dqmWebViewController;
  late Map<String?, List<OeeSummaryDataDTO>> dataByProjectMap;
  late Map<String?, List<OeeQualityDataDTO>> dataQualityByProjectMap;
  late Map<String?, List<OeePerformanceDataDTO>> dataPerformanceByProjectMap;

  List<OeeSummaryDataDTO>? availableDataList;
  List<OeeQualityDataDTO>? qualityDataList;
  List<OeePerformanceDataDTO>? performanceDataList;
  List<CustomDqmSortFilterProjectsDTO> projectList = [];
  bool isLoading = true;
  String sortBy = Constants.SORT_BY_VOLUME;
  double chartHeight = 316.0;

  bool? theme_dark = AppCache.sortFilterCacheDTO!.currentTheme;
  OeeSummaryDTO getAvailabilityBySiteDTO = OeeSummaryDTO();
  Future<OeeSummaryDTO> getAggregatedAvailabilityByEquipment(
      BuildContext context) {
    OeeApi oeeApi = OeeApi(context);
    return oeeApi.getAggregatedUtilTimeByProject(
        widget.selectedCompany,
        widget.selectedSite,
        widget.selectedEquipment,
        DateFormat("yyyy-MM-dd")
            .format(AppCache.sortFilterCacheDTO!.startDate!),
        DateFormat("yyyy-MM-dd").format(AppCache.sortFilterCacheDTO!.endDate!));
  }

  OeePerformanceDTO getPerformanceBySiteDTO = OeePerformanceDTO();
  Future<OeePerformanceDTO> getAggregatedPerformanceByEquipment(
      BuildContext context) {
    OeeApi oeeApi = OeeApi(context);
    return oeeApi.getPerformanceByEquipmentAndProject(
        widget.selectedCompany,
        widget.selectedSite,
        widget.selectedEquipment,
        DateFormat("yyyy-MM-dd")
            .format(AppCache.sortFilterCacheDTO!.startDate!),
        DateFormat("yyyy-MM-dd").format(AppCache.sortFilterCacheDTO!.endDate!));
  }

  OeeQualityDTO getQualityBySiteDTO = OeeQualityDTO();
  Future<OeeQualityDTO> getAggregatedQualityByEquipment(BuildContext context) {
    OeeApi oeeApi = OeeApi(context);
    return oeeApi.getQualityByEquipmentAndProject(
        widget.selectedCompany,
        widget.selectedSite,
        widget.selectedEquipment,
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
    } else if (currentTab == 1) {
      final groups = groupBy(quality!, (OeeQualityDataDTO e) {
        return e.projectId;
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
        return e.projectId;
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
        Constants.ANALYTICS_OEE_SUMMARY_UTILIZATION_TIME_BY_PROJ_SCREEN);
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
          qualityDataList = value.data;
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
            child: Image.asset(theme_dark!
                ? Constants.ASSET_IMAGES + 'download_bttn.png'
                : Constants.ASSET_IMAGES_LIGHT + 'download_bttn.png'),
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
              fromWhere: Constants.FROM_DQMS_PROJECT,
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
                  this.dqmWebViewController.webViewController.runJavascript(
                      'fetchSummaryTotalUtilTimeDetail(${jsonEncode(this.dataByProjectMap)}, ${jsonEncode(this.projectList)}, "${this.sortBy}")');
                } else if (widget.currentTab == 1) {
                  this.dqmWebViewController.webViewController.runJavascript(
                      'fetchSummaryQualityFailedTimeDetail(${jsonEncode(this.dataQualityByProjectMap)}, ${jsonEncode(this.projectList)}, "${this.sortBy}")');
                } else if (widget.currentTab == 2) {
                  this.dqmWebViewController.webViewController.runJavascript(
                      'fetchSummaryRetestAndFailedTimeDetail(${jsonEncode(this.dataPerformanceByProjectMap)}, ${jsonEncode(this.projectList)}, "${this.sortBy}")');
                }
              }),
          JavascriptChannel(
              name: 'DQMClickChannel',
              onMessageReceived: (message) {
                print(message.message);
                JSMetricQualityByProjectDataDTO dataDTO =
                    JSMetricQualityByProjectDataDTO.fromJson(
                        jsonDecode(message.message));
                showTooltipsDialog(ctx, dataDTO);

                // Navigator.pushNamed(
                //   ctx,
                //   AppRoutes.oeeSummarySiteMetricbyEquipment,
                //   arguments: OeeChartDetailArguments(
                //       currentTab: widget.currentTab,
                //       selectedCompany: widget.selectedCompany,
                //       selectedSite: widget.selectedSite,
                //       selectedEquipment: dataDTO.projectId),
                // );
              }),
          JavascriptChannel(
              name: 'DQMExportImageChannel',
              onMessageReceived: (message) async {
                print(message.message);
                if (Utils.isNotEmpty(message.message)) {
                  String name = 'oeeMetricbyProject.png';

                  final result = await ImageApi.generateImage(
                      message.message, 600, this.chartHeight.round(), name);
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
                  String name = 'oeeMetricbyProject.pdf';

                  final result = await PdfApi.generatePDF(
                      message.message, 600, this.chartHeight.round(), name);
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
                String name = "oee_metric_by_Project.csv";
                if (widget.currentTab == 0) {
                  object = this.availableDataList!;
                } else if (widget.currentTab == 1) {
                  object = this.qualityDataList!;
                } else if (widget.currentTab == 2) {
                  object = this.performanceDataList!;
                }

                final result = await CSVApi.generateCSV(object, name);
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

  void showTooltipsDialog(
      BuildContext context, JSMetricQualityByProjectDataDTO qmDTO) {
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

  Widget chartTooltipsInfo(
      BuildContext ctx, JSMetricQualityByProjectDataDTO qmDTO) {
    String title = '';
    if (widget.currentTab == 0) {
      title = 'Utilization Time, Minute(s)';
    } else if (widget.currentTab == 2) {
      title = 'Retest Pass & Fail Time, Minute(s)';
    } else if (widget.currentTab == 1) {
      title = 'Retest Pass & Failure';
    }
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
            qmDTO.projectId!,
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
              Text(
                '$title: ',
                style: AppFonts.robotoMedium(
                  14,
                  color: HexColor('f4d444'),
                  decoration: TextDecoration.none,
                ),
              ),
              SizedBox(width: 11.0),
              Text(
                widget.currentTab != 1
                    ? '${qmDTO.value!.toStringAsFixed(2)}'
                    : '${qmDTO.value!.toStringAsFixed(0)}',
                style: AppFonts.robotoRegular(
                  16,
                  color: theme_dark!
                      ? AppColors.appGrey2()
                      : AppColorsLightMode.appGrey2(),
                  decoration: TextDecoration.none,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
