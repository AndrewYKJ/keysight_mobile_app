import 'dart:convert';

import 'package:dio/dio.dart';
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
import 'package:keysight_pma/dio/api/dqm.dart';
import 'package:keysight_pma/model/arguments/dqm_argument.dart';
import 'package:keysight_pma/model/dqm/anomalies.dart';
import 'package:keysight_pma/model/dqm/test_result_change_limit.dart';
import 'package:keysight_pma/model/js/js.dart';
import 'package:keysight_pma/routes/approutes.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

class TestResultChangeLimitScreen extends StatefulWidget {
  final LimitChangeAnomalyDataDTO? limitChangeDTO;
  final String? serialNumber;
  TestResultChangeLimitScreen(
      {Key? key, this.limitChangeDTO, this.serialNumber})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TestResultChangeLimitScreen();
  }
}

class _TestResultChangeLimitScreen extends State<TestResultChangeLimitScreen> {
  TestResultChangeLimitDTO? testResultChangeLimitDTO;
  bool isLoading = true;
  double chartHeight = 316.0;
  late WebViewPlusController dqmWebViewController;
  List<TestResultChangeLimitDTO> upperLimitList = [];
  List<TestResultChangeLimitDTO> lowerLimitList = [];
  bool? isDarkTheme = AppCache.sortFilterCacheDTO!.currentTheme;
  bool isChineseLng = false;

  Future<TestResultChangeLimitDTO> getTestResultChangeLimit(
      BuildContext context) {
    String companyId = widget.limitChangeDTO!.companyId!;
    String siteId = widget.limitChangeDTO!.siteId!;
    String equipmentId = widget.limitChangeDTO!.equipmentId!;
    String projectId = widget.limitChangeDTO!.projectId!;
    String timestamp = widget.limitChangeDTO!.timestamp!;
    String testname = widget.limitChangeDTO!.testName!;
    double oldUpperLimit = widget.limitChangeDTO!.oldUpperLimit!.toDouble();
    double oldLowerLimit = widget.limitChangeDTO!.oldLowerLimit!.toDouble();
    double newUpperLimit = widget.limitChangeDTO!.newUpperLimit!.toDouble();
    double newLowerLimit = widget.limitChangeDTO!.newLowerLimit!.toDouble();
    String oldLimitTimestamp = widget.limitChangeDTO!.oldLimitTimestamp!;
    DqmApi dqmApi = DqmApi(context);
    return dqmApi.getTestResultChangeLimit(
        companyId,
        siteId,
        equipmentId,
        projectId,
        timestamp,
        testname,
        oldUpperLimit,
        oldLowerLimit,
        newUpperLimit,
        newLowerLimit,
        oldLimitTimestamp);
  }

  @override
  void initState() {
    super.initState();
    Utils.setFirebaseAnalyticsCurrentScreen(
        Constants.ANALYTICS_DQM_RMA_TESTRESULT_CHANGE_LIMIT_SCREEN);
    AppCache.getStringValue(AppCache.LANGUAGE_CODE_PREF).then((value) {
      if (Utils.isNotEmpty(value) && value == Constants.LANGUAGE_CODE_CN) {
        this.isChineseLng = true;
      } else {
        this.isChineseLng = false;
      }
    });
    if (widget.limitChangeDTO != null) {
      callGetTestResultChangeLimit(context);
    }
  }

  callGetTestResultChangeLimit(BuildContext context) async {
    await getTestResultChangeLimit(context).then((value) {
      if (value.status!.statusCode == 200) {
        this.testResultChangeLimitDTO = value;
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
    }).whenComplete(() {
      setState(() {
        this.isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: isDarkTheme!
            ? AppColors.serverAppBar()
            : AppColorsLightMode.serverAppBar(),
        title: Text(
          Utils.getTranslated(context, "dqm_rma_test_result_appbar_title")!,
          style: AppFonts.robotoRegular(
            20,
            color: isDarkTheme!
                ? AppColors.appGrey()
                : AppColorsLightMode.appGrey(),
            decoration: TextDecoration.none,
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
              ))
        ],
      ),
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
          child: this.isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppColors.appBlue()),
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [chart(context)],
                  ),
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
      child: (this.testResultChangeLimitDTO != null &&
              this.testResultChangeLimitDTO!.data != null &&
              testResultChangeLimitDTO!.data!.length > 0)
          ? WebViewPlus(
              backgroundColor: Colors.transparent,
              javascriptMode: JavascriptMode.unrestricted,
              initialUrl: isDarkTheme!
                  ? 'assets/html/highchart_dark_theme.html'
                  : 'assets/html/highchart_light_theme.html',
              zoomEnabled: false,
              gestureRecognizers: Set()
                ..add(Factory<VerticalDragGestureRecognizer>(
                    () => VerticalDragGestureRecognizer()))
                ..add(Factory<ScaleGestureRecognizer>(
                    () => ScaleGestureRecognizer())),
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
                      this.dqmWebViewController.webViewController.runJavascript(
                          'fetchRmaChangeLimitData(${jsonEncode(this.testResultChangeLimitDTO)}, "${widget.serialNumber}", "${Utils.getTranslated(ctx, 'chart_footer_timestamp_measured')}", "${Utils.getTranslated(ctx, 'chart_legend_pass')}", "${Utils.getTranslated(ctx, 'chart_legend_fail')}", "${Utils.getTranslated(ctx, 'chart_legend_anomaly')}", "${Utils.getTranslated(ctx, 'chart_legend_false_failure')}", "${Utils.getTranslated(ctx, 'chart_legend_lower_limit')}", "${Utils.getTranslated(ctx, 'chart_legend_upper_limit')}", "${Utils.getTranslated(ctx, 'chart_legend_limit_change')}")');
                    }),
                JavascriptChannel(
                    name: 'DQMRmaClickChannel',
                    onMessageReceived: (message) {
                      print(message.message);
                      if (Utils.isNotEmpty(message.message)) {
                        JSLimitChangeDTO jsLimitChangeDTO =
                            JSLimitChangeDTO.fromJson(
                                jsonDecode(message.message));
                        Navigator.pushNamed(ctx, AppRoutes.dqmCpkDashboardRoute,
                            arguments: DqmTestResultArguments(
                                testResultChangeLimitDataDTO:
                                    jsLimitChangeDTO));
                      }
                    }),
                JavascriptChannel(
                    name: 'DQMExportImageChannel',
                    onMessageReceived: (message) async {
                      print(message.message);
                      if (Utils.isNotEmpty(message.message)) {
                        //KEYS_BM_BrdRst#2022.08.10@23.39.08
                        String name = '';
                        String curDate =
                            '#${DateFormat('yyyy.MM.dd').format(DateTime.now())}@${DateFormat('HH.mm.ss').format(DateTime.now())}';
                        name = Utils.getExportFilename(
                          'BrdRst',
                          companyId:
                              AppCache.sortFilterCacheDTO!.preferredCompany,
                          siteId: AppCache.sortFilterCacheDTO!.preferredSite,
                          currentDate: curDate,
                          expType: '.png',
                        );
                        final result = await ImageApi.generateImage(
                            message.message,
                            600,
                            this.chartHeight.round(),
                            name);
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
                                      : AppColorsLightMode.appGrey(),
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
                        String name = '';
                        String curDate =
                            '#${DateFormat('yyyy.MM.dd').format(DateTime.now())}@${DateFormat('HH.mm.ss').format(DateTime.now())}';
                        name = Utils.getExportFilename(
                          'BrdRst',
                          companyId:
                              AppCache.sortFilterCacheDTO!.preferredCompany,
                          siteId: AppCache.sortFilterCacheDTO!.preferredSite,
                          currentDate: curDate,
                          expType: '.pdf',
                        );
                        final result = await PdfApi.generatePDF(message.message,
                            600, this.chartHeight.round(), name,
                            isDarkTheme: this.isDarkTheme!,
                            isChineseLng: this.isChineseLng);
                        if (result == true) {
                          setState(() {
                            isLoading = false;
                            var snackBar = SnackBar(
                              content: Text(
                                Utils.getTranslated(
                                    context, 'done_download_as_pdf')!,
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
                //KEYS_BM_BrdRst#2022.08.11@00.18.21
                String curDate =
                    '#${DateFormat('yyyy.MM.dd').format(DateTime.now())}@${DateFormat('HH.mm.ss').format(DateTime.now())}';
                String filename = Utils.getExportFilename(
                  'BrdRst',
                  companyId: AppCache.sortFilterCacheDTO!.preferredCompany,
                  siteId: AppCache.sortFilterCacheDTO!.preferredSite,
                  currentDate: curDate,
                  expType: '.csv',
                );
                bool result = await CSVApi.generateCSV(
                    this.testResultChangeLimitDTO!.data!, filename);
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
}
