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
import 'package:keysight_pma/model/dqm/boardresult_counts.dart';
import 'package:keysight_pma/model/dqm/worst_test_by_project.dart';
import 'package:keysight_pma/model/js/js.dart';
import 'package:keysight_pma/routes/approutes.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

class DqmQualityMetricViewByEquipmentScreen extends StatefulWidget {
  final JSMetricQualityByProjectDataDTO? dataDTO;
  final String? sumType;
  DqmQualityMetricViewByEquipmentScreen({Key? key, this.dataDTO, this.sumType})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DqmQualityMetricViewByEquipmentScreen();
  }
}

class _DqmQualityMetricViewByEquipmentScreen
    extends State<DqmQualityMetricViewByEquipmentScreen> {
  late WebViewPlusController dqmWebViewController;
  double chartHeight = 316.0;
  bool isLoading = true;
  String sortBy = Constants.SORT_BY_VOLUME;
  String filterBy = Constants.FILTER_BY_EQUIPMENT;
  String appBarTitle = '';
  late BoardResultCountsDTO boardResultCountsDTO;
  WorstTestByProjectDTO? worstTestByProjectDTO;
  List<BoardResultCountsDataDTO> boardList = [];
  List<WorstTestByProjectDataDTO> worstTestList = [];
  bool? isDarkTheme = AppCache.sortFilterCacheDTO!.currentTheme;
  bool isChineseLng = false;

  Future<BoardResultCountsDTO> getBoardResultCountsForEquipment(
      BuildContext context) {
    DqmApi dqmApi = DqmApi(context);
    return dqmApi.getBoardResultCountsForEquipment(
        AppCache.sortFilterCacheDTO!.preferredCompany!,
        AppCache.sortFilterCacheDTO!.preferredSite!,
        DateFormat("yyyy-MM-dd")
            .format(AppCache.sortFilterCacheDTO!.startDate!),
        DateFormat("yyyy-MM-dd").format(AppCache.sortFilterCacheDTO!.endDate!),
        widget.dataDTO!.projectId!);
  }

  Future<WorstTestByProjectDTO> getWorstTestResultsByProject(
      BuildContext context) {
    String companyId = AppCache.sortFilterCacheDTO!.preferredCompany!;
    String siteId = AppCache.sortFilterCacheDTO!.preferredSite!;
    String startDate =
        DateFormat("yyyyMMdd").format(AppCache.sortFilterCacheDTO!.startDate!);
    String endDate =
        DateFormat("yyyyMMdd").format(AppCache.sortFilterCacheDTO!.endDate!);
    DqmApi dqmApi = DqmApi(context);
    return dqmApi.getWorstTestResultsByProject(companyId, siteId, startDate,
        endDate, 5, 5, widget.dataDTO!.projectId!);
  }

  @override
  void initState() {
    super.initState();
    Utils.setFirebaseAnalyticsCurrentScreen(
        Constants.ANALYTICS_DQM_SUMMARY_DETAIL_BY_EQUIPMENT_SCREEN);
    AppCache.getStringValue(AppCache.LANGUAGE_CODE_PREF).then((value) {
      if (Utils.isNotEmpty(value) && value == Constants.LANGUAGE_CODE_CN) {
        this.isChineseLng = true;
      } else {
        this.isChineseLng = false;
      }
    });
    callGetDataByEquipment(context);
  }

  callGetDataByEquipment(BuildContext context) {
    getBoardResultCountsForEquipment(context).then((value) {
      this.boardResultCountsDTO = value;
      this.boardList = this.boardResultCountsDTO.data!;
      groupDataByEquipment(value.data!);
      callGetWorstTestResultsByProject(context);
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

  late Map<String?, List<BoardResultCountsDataDTO>> dataByEquipmentMap;
  List<CustomSummaryMetricSortFilterDTO> equipmentList = [];

  late Map<String?, List<WorstTestByProjectDataDTO>> dataByTestNameMap;
  List<CustomSummaryMetricSortFilterDTO> testNameList = [];
  void groupDataByEquipment(List<BoardResultCountsDataDTO> data) {
    final groups = groupBy(data, (BoardResultCountsDataDTO e) {
      return e.equipmentName;
    });

    setState(() {
      this.isLoading = false;
      this.dataByEquipmentMap = groups;
      this.dataByEquipmentMap.keys.forEach((projectId) {
        CustomSummaryMetricSortFilterDTO customDTO =
            CustomSummaryMetricSortFilterDTO(projectId, 0);
        this.equipmentList.add(customDTO);
      });
    });
  }

  void groupDataByTestName(List<WorstTestByProjectDataDTO> data) {
    final groups = groupBy(data, (WorstTestByProjectDataDTO e) {
      return e.testName;
    });

    setState(() {
      this.isLoading = false;
      this.dataByTestNameMap = groups;
      this.dataByTestNameMap.keys.forEach((projectId) {
        CustomSummaryMetricSortFilterDTO customDTO =
            CustomSummaryMetricSortFilterDTO(projectId, 0);
        this.testNameList.add(customDTO);
      });
    });
  }

  callGetWorstTestResultsByProject(BuildContext context) {
    getWorstTestResultsByProject(context).then((value) {
      this.worstTestByProjectDTO = value;
      this.worstTestList = value.data!;
      groupDataByTestName(value.data!);
      sortAndFilterData();
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
    }).whenComplete(() {
      setState(() {
        this.isLoading = false;
        if (widget.sumType == Constants.SUMMARY_TYPE_FAILURE) {
          this.appBarTitle = Utils.getTranslated(
              context, 'dqm_summary_qm_failure_equipment_appbar_title')!;
        } else if (widget.sumType == Constants.SUMMARY_TYPE_FIRST_PASS) {
          this.appBarTitle = Utils.getTranslated(
              context, 'dqm_summary_qm_first_pass_equipment_appbar_title')!;
        } else if (widget.sumType == Constants.SUMMARY_TYPE_YIELD) {
          this.appBarTitle = Utils.getTranslated(
              context, 'dqm_summary_qm_yield_equipment_appbar_title')!;
        }
      });
    });
  }

  sortAndFilterData() {
    if (this.filterBy == Constants.FILTER_BY_EQUIPMENT) {
      if (this.sortBy == Constants.SORT_BY_VOLUME) {
        if (this.boardList.length > 0) {
          this.boardList.sort((a, b) {
            if (widget.sumType == Constants.SUMMARY_TYPE_FAILURE) {
              return a.failed!.compareTo(b.failed!);
            } else if (widget.sumType == Constants.SUMMARY_TYPE_FIRST_PASS) {
              return a.firstPassYield!.compareTo(b.firstPassYield!);
            } else {
              return a.finalYield!.compareTo(b.finalYield!);
            }
          });
        }
      } else {
        if (this.boardList.length > 0) {
          this.boardList.sort((a, b) {
            return a.equipmentName!.compareTo(b.equipmentName!);
          });
        }
      }
    } else {
      if (widget.sumType == Constants.SUMMARY_TYPE_FAILURE) {
        if (this.sortBy == Constants.SORT_BY_VOLUME) {
          this.worstTestList.sort((a, b) {
            return b.failedCount!.compareTo(a.failedCount!);
          });
        } else {
          this.worstTestList.sort((a, b) {
            return a.testName!.compareTo(b.testName!);
          });
        }
      }
    }
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
            this.appBarTitle,
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
                          header(context),
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
                sortBy: this.sortBy,
                filterBy: this.filterBy,
                fromWhere: Constants.FROM_DQMS_EQUIPMENT,
                sumType: widget.sumType),
          );

          if (navigateResult != null) {
            DqmSortFilterArguments arguments =
                navigateResult as DqmSortFilterArguments;
            setState(() {
              this.sortBy = arguments.sortBy!;
              this.filterBy = arguments.filterBy!;
              sortAndFilterData();
              this.dqmWebViewController.webViewController.reload();
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
              Image.asset(isDarkTheme!
                  ? Constants.ASSET_IMAGES + 'filter_icon.png'
                  : Constants.ASSET_IMAGES_LIGHT + 'filter_icon.png'),
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

  Widget header(BuildContext ctx) {
    return Container(
      padding: EdgeInsets.fromLTRB(10.0, 27.0, 10.0, 10.0),
      child: Text(
        widget.dataDTO!.projectId!,
        style: AppFonts.robotoRegular(
          16,
          color: isDarkTheme!
              ? AppColors.appGrey2()
              : AppColorsLightMode.appGrey(),
          decoration: TextDecoration.none,
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
                      'fetchSummaryFailureByEquipmentDetailData(${jsonEncode(this.boardList)}, "${this.sortBy}", "${this.filterBy}", ${jsonEncode(this.worstTestList)})');
                } else if (widget.sumType ==
                    Constants.SUMMARY_TYPE_FIRST_PASS) {
                  this.dqmWebViewController.webViewController.runJavascript(
                      'fetchSummaryFirstPassByEquipmentDetailData(${jsonEncode(this.boardList)}, "${this.sortBy}")');
                } else if (widget.sumType == Constants.SUMMARY_TYPE_YIELD) {
                  this.dqmWebViewController.webViewController.runJavascript(
                      'fetchSummaryYieldByEquipmentDetailData(${jsonEncode(this.boardList)}, "${this.sortBy}")');
                }
              }),
          JavascriptChannel(
              name: 'DQMClickChannel',
              onMessageReceived: (message) {
                print(message.message);
                JSMetricQualityByEquipmentDataDTO dataDTO =
                    JSMetricQualityByEquipmentDataDTO.fromJson(
                        jsonDecode(message.message));
                showTooltipsDialog(ctx, dataDTO);
              }),
          JavascriptChannel(
              name: 'DQMExportImageChannel',
              onMessageReceived: (message) async {
                print(message.message);
                //KEYS_BM_DQMEqpTnm_2022-04-01_2022-08-09#2022.08.10@00.45.02
                if (Utils.isNotEmpty(message.message)) {
                  String name = '';
                  String curDate =
                      '#${DateFormat('yyyy.MM.dd').format(DateTime.now())}@${DateFormat('HH.mm.ss').format(DateTime.now())}';
                  if (widget.sumType == Constants.SUMMARY_TYPE_FAILURE ||
                      widget.sumType == Constants.SUMMARY_TYPE_FIRST_PASS ||
                      widget.sumType == Constants.SUMMARY_TYPE_YIELD) {
                    name = Utils.getExportFilename(
                      'DQMEqpTnm',
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
                      'DQMEqpTnm',
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

                var object = [];
                String name = "";
                String curDate =
                    '#${DateFormat('yyyy.MM.dd').format(DateTime.now())}@${DateFormat('HH.mm.ss').format(DateTime.now())}';

                if (widget.sumType == Constants.SUMMARY_TYPE_FAILURE) {
                  name = Utils.getExportFilename(
                    'DQMEqpTnm',
                    companyId: AppCache.sortFilterCacheDTO!.preferredCompany,
                    siteId: AppCache.sortFilterCacheDTO!.preferredSite,
                    fromDate: DateFormat('yyyy-MM-dd')
                        .format(AppCache.sortFilterCacheDTO!.startDate!),
                    toDate: DateFormat('yyyy-MM-dd')
                        .format(AppCache.sortFilterCacheDTO!.endDate!),
                    currentDate: curDate,
                    expType: '.csv',
                  );

                  if (this.filterBy == Constants.FILTER_BY_EQUIPMENT)
                    equipmentList.forEach((key) {
                      var totalFailure = key.count;
                      boardList.forEach((element) {
                        if (element.equipmentName == key.item)
                          totalFailure =
                              (totalFailure! + element.failed!) as int?;
                      });
                      object.add({
                        "equipmentName": key.item,
                        "failure": (totalFailure),
                      });
                    });
                  else {
                    testNameList.forEach((key) {
                      var totalFailure = key.count;
                      worstTestList.forEach((element) {
                        if (element.testName == key.item)
                          totalFailure = (totalFailure! + element.failedCount!);
                      });
                      object.add({
                        "equipmentName": key.item,
                        "failure": (totalFailure),
                      });
                    });
                  }
                  worstTestList.forEach((element) {
                    object.add({
                      "testName": element.testName,
                      "failure": (element.failedCount),
                    });
                  });
                } else if (widget.sumType ==
                    Constants.SUMMARY_TYPE_FIRST_PASS) {
                  name = Utils.getExportFilename(
                    'DQMEqpTnm',
                    companyId: AppCache.sortFilterCacheDTO!.preferredCompany,
                    siteId: AppCache.sortFilterCacheDTO!.preferredSite,
                    fromDate: DateFormat('yyyy-MM-dd')
                        .format(AppCache.sortFilterCacheDTO!.startDate!),
                    toDate: DateFormat('yyyy-MM-dd')
                        .format(AppCache.sortFilterCacheDTO!.endDate!),
                    currentDate: curDate,
                    expType: '.csv',
                  );
                  equipmentList.forEach((key) {
                    var totalFailure = 0.0;
                    boardList.forEach((element) {
                      if (element.equipmentName == key.item)
                        totalFailure = (totalFailure +
                            ((element.firstPass! /
                                    (element.firstPass! +
                                        element.rework! +
                                        element.failed!)) *
                                100));
                    });
                    object.add({
                      "equipmentName": key.item,
                      "failure": (totalFailure),
                    });
                  });
                } else if (widget.sumType == Constants.SUMMARY_TYPE_YIELD) {
                  name = Utils.getExportFilename(
                    'DQMEqpTnm',
                    companyId: AppCache.sortFilterCacheDTO!.preferredCompany,
                    siteId: AppCache.sortFilterCacheDTO!.preferredSite,
                    fromDate: DateFormat('yyyy-MM-dd')
                        .format(AppCache.sortFilterCacheDTO!.startDate!),
                    toDate: DateFormat('yyyy-MM-dd')
                        .format(AppCache.sortFilterCacheDTO!.endDate!),
                    currentDate: curDate,
                    expType: '.csv',
                  );
                  equipmentList.forEach((key) {
                    var totalFailure = 0.0;
                    boardList.forEach((element) {
                      if (element.equipmentName == key.item)
                        totalFailure = (totalFailure +
                            (((element.firstPass! + element.rework!) /
                                    (element.firstPass! +
                                        element.rework! +
                                        element.failed!)) *
                                100));
                    });
                    object.add({
                      "equipmentName": key.item,
                      "failure": (totalFailure),
                    });
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

  void showTooltipsDialog(
      BuildContext context, JSMetricQualityByEquipmentDataDTO qmDTO) {
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
      BuildContext ctx, JSMetricQualityByEquipmentDataDTO qmDTO) {
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
            qmDTO.equipmentName!,
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
                '${this.appBarTitle}: ',
                style: AppFonts.robotoMedium(
                  14,
                  color: HexColor('f4d444'),
                  decoration: TextDecoration.none,
                ),
              ),
              SizedBox(width: 11.0),
              Text(
                '${qmDTO.value}',
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
        ],
      ),
    );
  }
}
