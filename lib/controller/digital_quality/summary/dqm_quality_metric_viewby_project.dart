import 'dart:convert';

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
import 'package:keysight_pma/model/dqm/boardresult_counts.dart';
import 'package:keysight_pma/model/js/js.dart';
import 'package:keysight_pma/routes/approutes.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

class DqmQualityMetricViewByProjectScreen extends StatefulWidget {
  final JSMetricQualityByProjectDataDTO? dataDTO;
  final String? sumType;
  DqmQualityMetricViewByProjectScreen({Key? key, this.dataDTO, this.sumType})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DqmQualityMetricViewByProjectScreen();
  }
}

class _DqmQualityMetricViewByProjectScreen
    extends State<DqmQualityMetricViewByProjectScreen> {
  late WebViewPlusController failureController;
  late WebViewPlusController firstPassController;
  late WebViewPlusController yieldController;
  late WebViewPlusController volumeController;
  late BoardResultCountsDTO boardResultCountsDTO;

  bool isLoading = true;
  double chartFAHeight = 316.0;
  double chartFPYHeight = 316.0;
  double chartFYHeight = 316.0;
  double chartVOHeight = 316.0;
  String labelInfo = '';
  late Color labelColor;
  bool? isDarkTheme = AppCache.sortFilterCacheDTO!.currentTheme;

  Future<BoardResultCountsDTO> getBoardResultCountsForProject(
      BuildContext context) {
    DqmApi dqmApi = DqmApi(context);
    return dqmApi.getBoardResultCountsForProject(
        AppCache.sortFilterCacheDTO!.preferredCompany!,
        AppCache.sortFilterCacheDTO!.preferredSite!,
        DateFormat("yyyyMMdd").format(AppCache.sortFilterCacheDTO!.startDate!),
        DateFormat("yyyyMMdd").format(AppCache.sortFilterCacheDTO!.endDate!),
        widget.dataDTO!.projectId!);
  }

  List<String> getDaysInBetween() {
    List<String> days = [];
    for (int i = 0;
        i <=
            AppCache.sortFilterCacheDTO!.endDate!
                .difference(AppCache.sortFilterCacheDTO!.startDate!)
                .inDays;
        i++) {
      days.add(DateFormat('yyyy-MM-dd').format(
          AppCache.sortFilterCacheDTO!.startDate!.add(Duration(days: i))));
    }
    return days;
  }

  @override
  void initState() {
    super.initState();
    Utils.setFirebaseAnalyticsCurrentScreen(
        Constants.ANALYTICS_DQM_SUMMARY_DETAIL_BY_PROJECT_SCREEN);
    callGetBoardResultCountsForProject(context);
  }

  callGetBoardResultCountsForProject(BuildContext context) {
    getBoardResultCountsForProject(context).then((value) {
      this.boardResultCountsDTO = value;
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
          this.labelInfo = Utils.getTranslated(
              context, 'dqm_summary_qm_failure_appbar_title')!;
          this.labelColor = HexColor('e3032a');
        } else if (widget.sumType == Constants.SUMMARY_TYPE_FIRST_PASS) {
          this.labelInfo = Utils.getTranslated(
              context, 'dqm_summary_qm_first_pass_appbar_title')!;
          this.labelColor = HexColor('14979c');
        } else if (widget.sumType == Constants.SUMMARY_TYPE_YIELD) {
          this.labelInfo = Utils.getTranslated(
              context, 'dqm_summary_qm_yield_appbar_title')!;
          this.labelColor = HexColor('0c6540');
        }
      });
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
            widget.dataDTO!.projectId!,
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
          padding: EdgeInsets.all(16.0),
          child: !this.isLoading
              ? SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      header(context),
                      qualityMetricFailureByProjectChart(context),
                      qualityMetricFirstPassYieldByProjectChart(context),
                      qualityMetricYieldByProjectChart(context),
                      qualityMetricVolumeByProjectChart(context),
                    ],
                  ),
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

  Widget header(BuildContext ctx) {
    return Container(
      padding: EdgeInsets.fromLTRB(17.0, 11.0, 17.0, 11.0),
      decoration: BoxDecoration(
        color: isDarkTheme!
            ? AppColors.appBlackLight()
            : AppColorsLightMode.appLightGreen(),
        border: Border.all(
          color: isDarkTheme!
              ? AppColors.appBlackLight()
              : AppColorsLightMode.appTeal(),
        ),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${widget.dataDTO!.projectId}',
            style: AppFonts.robotoBold(
              15,
              color: isDarkTheme!
                  ? AppColors.appPrimaryWhite()
                  : AppColorsLightMode.appGrey(),
              decoration: TextDecoration.none,
            ),
          ),
          SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${this.labelInfo}:',
                style: AppFonts.sfproRegular(
                  16,
                  color: this.labelColor,
                  decoration: TextDecoration.none,
                ),
              ),
              SizedBox(width: 10.0),
              Text(
                widget.sumType == Constants.SUMMARY_TYPE_FAILURE
                    ? '${widget.dataDTO!.value!}'
                    : '${widget.dataDTO!.value!.toStringAsFixed(2)}',
                style: AppFonts.robotoRegular(
                  16,
                  color: isDarkTheme!
                      ? AppColors.appGreyDE()
                      : AppColorsLightMode.appGrey(),
                  decoration: TextDecoration.none,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget qualityMetricFailureByProjectChart(BuildContext ctx) {
    return Container(
      margin: EdgeInsets.only(top: 30.0),
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
                  Navigator.pushNamed(
                    ctx,
                    AppRoutes.dqmSummaryQualityMetricByEquipmentRoute,
                    arguments: DqmSummaryQmArguments(
                      dataDTO: widget.dataDTO,
                      sumType: Constants.SUMMARY_TYPE_FAILURE,
                    ),
                  );
                },
                child: Image.asset(isDarkTheme!
                    ? Constants.ASSET_IMAGES + 'next_bttn_withbg.png'
                    : Constants.ASSET_IMAGES_LIGHT + 'next_bttn_withbg.png'),
              ),
            ],
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: this.chartFAHeight,
            color: Colors.transparent,
            child: (this.boardResultCountsDTO.data != null &&
                    this.boardResultCountsDTO.data!.length > 0)
                ? WebViewPlus(
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
                          this.chartFAHeight = value;
                        });
                      });
                    },
                    javascriptChannels: [
                      JavascriptChannel(
                          name: 'DQMChannel',
                          onMessageReceived: (message) {
                            print(message.message);
                            this.failureController.webViewController.runJavascript(
                                'fetchSummaryFailureByProjectData(${jsonEncode(this.boardResultCountsDTO)}, "${DateFormat("yyyy-MM-dd").format(AppCache.sortFilterCacheDTO!.startDate!)}", "${DateFormat("yyyy-MM-dd").format(AppCache.sortFilterCacheDTO!.endDate!)}", ${jsonEncode(getDaysInBetween())})');
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
                              //KEYS_BM_DQMByProj_2022-04-01_2022-08-09#2022.08.10@00.27.34
                              String name = 'summaryFailureByProject.png';

                              final result =
                                  await ImageApi.generateSummaryImage(
                                      message.message,
                                      600,
                                      this.chartFAHeight.round(),
                                      1100,
                                      null,
                                      widget.dataDTO!.projectId,
                                      name);
                              if (result != null && result == true) {
                                setState(() {
                                  // print('################## hihi');
                                  isLoading = true;
                                });
                              }
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
                                  widget.dataDTO!.projectId,
                                  name);
                              if (result != null && result == true) {
                                setState(() {
                                  // print('################## hihi');
                                  isLoading = true;
                                });
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
    );
  }

  Widget qualityMetricFirstPassYieldByProjectChart(BuildContext ctx) {
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
                  Navigator.pushNamed(
                    ctx,
                    AppRoutes.dqmSummaryQualityMetricByEquipmentRoute,
                    arguments: DqmSummaryQmArguments(
                      dataDTO: widget.dataDTO,
                      sumType: Constants.SUMMARY_TYPE_FIRST_PASS,
                    ),
                  );
                },
                child: Image.asset(isDarkTheme!
                    ? Constants.ASSET_IMAGES + 'next_bttn_withbg.png'
                    : Constants.ASSET_IMAGES_LIGHT + 'next_bttn_withbg.png'),
              ),
            ],
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: this.chartFPYHeight,
            color: Colors.transparent,
            child: (this.boardResultCountsDTO.data != null &&
                    this.boardResultCountsDTO.data!.length > 0)
                ? WebViewPlus(
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
                                .firstPassController
                                .webViewController
                                .runJavascript(
                                    'fetchSummaryFirstPassByProjectData(${jsonEncode(this.boardResultCountsDTO)}, "${DateFormat("yyyy-MM-dd").format(AppCache.sortFilterCacheDTO!.startDate!)}", "${DateFormat("yyyy-MM-dd").format(AppCache.sortFilterCacheDTO!.endDate!)}", ${jsonEncode(getDaysInBetween())})');
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
                              String name = 'summaryFirstPassByProject.png';

                              final result =
                                  await ImageApi.generateSummaryImage(
                                      message.message,
                                      600,
                                      this.chartFAHeight.round(),
                                      1100,
                                      null,
                                      widget.dataDTO!.projectId,
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
                                  widget.dataDTO!.projectId,
                                  name);
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
    );
  }

  Widget qualityMetricYieldByProjectChart(BuildContext ctx) {
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
                  Navigator.pushNamed(
                    ctx,
                    AppRoutes.dqmSummaryQualityMetricByEquipmentRoute,
                    arguments: DqmSummaryQmArguments(
                      dataDTO: widget.dataDTO,
                      sumType: Constants.SUMMARY_TYPE_YIELD,
                    ),
                  );
                },
                child: Image.asset(isDarkTheme!
                    ? Constants.ASSET_IMAGES + 'next_bttn_withbg.png'
                    : Constants.ASSET_IMAGES_LIGHT + 'next_bttn_withbg.png'),
              ),
            ],
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: this.chartFYHeight,
            color: Colors.transparent,
            child: (this.boardResultCountsDTO.data != null &&
                    this.boardResultCountsDTO.data!.length > 0)
                ? WebViewPlus(
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
                          this.chartFYHeight = value;
                        });
                      });
                    },
                    javascriptChannels: [
                      JavascriptChannel(
                          name: 'DQMChannel',
                          onMessageReceived: (message) {
                            print(message.message);
                            this.yieldController.webViewController.runJavascript(
                                'fetchSummaryYieldByProjectData(${jsonEncode(this.boardResultCountsDTO)}, "${DateFormat("yyyy-MM-dd").format(AppCache.sortFilterCacheDTO!.startDate!)}", "${DateFormat("yyyy-MM-dd").format(AppCache.sortFilterCacheDTO!.endDate!)}", ${jsonEncode(getDaysInBetween())})');
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
                              String name = 'summaryYieldByProject.png';

                              final result =
                                  await ImageApi.generateSummaryImage(
                                      message.message,
                                      600,
                                      this.chartFAHeight.round(),
                                      1100,
                                      null,
                                      widget.dataDTO!.projectId,
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
                                  widget.dataDTO!.projectId,
                                  name);
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
    );
  }

  Widget qualityMetricVolumeByProjectChart(BuildContext ctx) {
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
          Container(
            width: MediaQuery.of(context).size.width,
            height: this.chartVOHeight,
            color: Colors.transparent,
            child: (this.boardResultCountsDTO.data != null &&
                    this.boardResultCountsDTO.data!.length > 0)
                ? WebViewPlus(
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
                          this.chartVOHeight = value;
                        });
                      });
                    },
                    javascriptChannels: [
                      JavascriptChannel(
                          name: 'DQMChannel',
                          onMessageReceived: (message) {
                            print(message.message);
                            this.volumeController.webViewController.runJavascript(
                                'fetchSummaryVolumeByProjectData(${jsonEncode(this.boardResultCountsDTO)}, "${DateFormat("yyyy-MM-dd").format(AppCache.sortFilterCacheDTO!.startDate!)}", "${DateFormat("yyyy-MM-dd").format(AppCache.sortFilterCacheDTO!.endDate!)}", ${jsonEncode(getDaysInBetween())})');
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
                              String name = 'summaryVolumeByProject.png';

                              final result =
                                  await ImageApi.generateSummaryImage(
                                      message.message,
                                      600,
                                      this.chartFAHeight.round(),
                                      1100,
                                      null,
                                      widget.dataDTO!.projectId,
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
                                  widget.dataDTO!.projectId,
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
                boardResultCountsDTO.data!.forEach((element) {
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
                    object, name, 1100, null, widget.dataDTO!.projectId);
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
}
