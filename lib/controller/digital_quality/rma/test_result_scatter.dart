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
import 'package:keysight_pma/controller/digital_quality/rma/test_result.dart';
import 'package:keysight_pma/dio/api/dqm.dart';
import 'package:keysight_pma/model/arguments/dqm_argument.dart';
import 'package:keysight_pma/model/dqm/anomalies.dart';
import 'package:keysight_pma/model/dqm/count.dart';
import 'package:keysight_pma/model/dqm/test_result_testname.dart';
import 'package:keysight_pma/routes/approutes.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

class TestResultScatterScreen extends StatefulWidget {
  final MeasurementAnomalyDataDTO? measurementDTO;
  final DownloadAsImage dwnImg;
  final DownloadAsPdf dwnPdf;
  final DownloadAsCsv dwnCsv;
  TestResultScatterScreen(
      {Key? key,
      this.measurementDTO,
      required this.dwnImg,
      required this.dwnPdf,
      required this.dwnCsv})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TestResultScatterScreen();
  }
}

class _TestResultScatterScreen extends State<TestResultScatterScreen> {
  TestResultTestNameDTO? testResultTestNameDTO;
  bool isLoading = true;
  double chartHeight = 350.0;
  late WebViewPlusController dqmWebViewController;
  String mSerialNumber = '';
  CompareCountDTO? compareCountDTO;
  bool? isDarkTheme = AppCache.sortFilterCacheDTO!.currentTheme;
  bool isChineseLng = false;

  Future<TestResultTestNameDTO> getTestResultByTestName(BuildContext context) {
    String companyId = widget.measurementDTO!.companyId!;
    String siteId = widget.measurementDTO!.siteId!;
    String serialNumber = widget.measurementDTO!.serialNumber!;
    String equipmentId = widget.measurementDTO!.equipmentId!;
    String projectId = widget.measurementDTO!.projectId!;
    String timestamp = widget.measurementDTO!.timestamp!;
    String startTime = widget.measurementDTO!.startDate!;
    String endTime = widget.measurementDTO!.endDate!;
    String testname = widget.measurementDTO!.testName!;
    DqmApi dqmApi = DqmApi(context);
    return dqmApi.getTestResultByTestName(companyId, siteId, serialNumber,
        equipmentId, projectId, timestamp, startTime, endTime, testname);
  }

  Future<CompareCountDTO> getCompareCount(BuildContext context) {
    String companyId = widget.measurementDTO!.companyId!;
    String siteId = widget.measurementDTO!.siteId!;
    String startDate = widget.measurementDTO!.startDate!;
    String endDate = widget.measurementDTO!.endDate!;
    List<String?> equipments = [];
    String projectId = widget.measurementDTO!.projectId!;
    String testname = widget.measurementDTO!.testName!;
    DqmApi dqmApi = DqmApi(context);
    return dqmApi.getCompareCount(
        companyId, siteId, projectId, startDate, endDate, testname, equipments);
  }

  @override
  void initState() {
    super.initState();
    Utils.setFirebaseAnalyticsCurrentScreen(
        Constants.ANALYTICS_DQM_RMA_TESTRESULT_SCATTER_SCREEN);
    AppCache.getStringValue(AppCache.LANGUAGE_CODE_PREF).then((value) {
      if (Utils.isNotEmpty(value) && value == Constants.LANGUAGE_CODE_CN) {
        this.isChineseLng = true;
      } else {
        this.isChineseLng = false;
      }
    });
    if (widget.measurementDTO != null) {
      this.mSerialNumber = widget.measurementDTO!.serialNumber!;
      callGetTestResultByTestName(context);
    }
  }

  callGetTestResultByTestName(BuildContext context) async {
    await getTestResultByTestName(context).then((value) {
      if (value.status!.statusCode == 200) {
        this.testResultTestNameDTO = value;
        callGetCompareCount(context);
      } else {
        setState(() {
          this.isLoading = false;
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
        });
      }
    }).catchError((error) {
      setState(() {
        this.isLoading = false;
      });
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

  callGetCompareCount(BuildContext context) async {
    await getCompareCount(context).then((value) {
      if (value.status!.statusCode == 200) {
        this.compareCountDTO = value;
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

  @override
  Widget build(BuildContext context) {
    widget.dwnImg.call(context, downloadAsImage);
    widget.dwnPdf.call(context, downloadAsPdf);
    widget.dwnCsv.call(context, downloadAsCsv);
    return SafeArea(
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
                  children: [compareButton(context), chart(context)],
                ),
              ),
      ),
    );
  }

  Widget compareButton(BuildContext ctx) {
    if (this.compareCountDTO != null &&
        this.compareCountDTO!.data != null &&
        (this.compareCountDTO!.data!.numberOfEquipments!.toInt() > 1 ||
            this.compareCountDTO!.data!.numberOfFixtures!.toInt() > 1 ||
            this.compareCountDTO!.data!.numberOfPanels!.toInt() > 1)) {
      return GestureDetector(
        onTap: () {
          showComparePopup(ctx);
        },
        child: Container(
          margin: EdgeInsets.only(top: 30.0),
          padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          decoration: BoxDecoration(
            color: AppColors.appGrey4A(),
            borderRadius: BorderRadius.circular(50.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(Constants.ASSET_IMAGES + 'compare_icon.png'),
              SizedBox(width: 8.0),
              Text(
                Utils.getTranslated(
                    ctx, 'dqm_testresult_analog_detail_compare')!,
                style: AppFonts.robotoRegular(
                  14,
                  color: isDarkTheme!
                      ? AppColors.appGrey2()
                      : AppColorsLightMode.appGrey(),
                  decoration: TextDecoration.none,
                ),
              ),
            ],
          ),
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
      child: (this.testResultTestNameDTO != null &&
              this.testResultTestNameDTO!.data != null &&
              this.testResultTestNameDTO!.data!.length > 0)
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
                          'fetchRmaScatterData(${jsonEncode(this.testResultTestNameDTO)}, "${this.mSerialNumber}", "${Utils.getTranslated(ctx, 'chart_footer_timestamp_measured')}", "${Utils.getTranslated(ctx, 'chart_legend_pass')}", "${Utils.getTranslated(ctx, 'chart_legend_fail')}", "${Utils.getTranslated(ctx, 'chart_legend_anomaly')}", "${Utils.getTranslated(ctx, 'chart_legend_false_failure')}", "${Utils.getTranslated(ctx, 'chart_legend_threshold')}", "${Utils.getTranslated(ctx, 'chart_legend_lower_limit')}", "${Utils.getTranslated(ctx, 'chart_legend_upper_limit')}")');
                    }),
                JavascriptChannel(
                    name: 'DQMClickChannel',
                    onMessageReceived: (message) {
                      print(message.message);
                      if (Utils.isNotEmpty(message.message)) {
                        TestResultTestNameDataDTO testNameDataDTO =
                            TestResultTestNameDataDTO.fromJson(
                                jsonDecode(message.message));
                        Navigator.pushNamed(ctx, AppRoutes.dqmCpkDashboardRoute,
                            arguments: DqmTestResultArguments(
                                testNameDataDTO: testNameDataDTO));
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

  void showComparePopup(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext popContext) => CupertinoActionSheet(
        actions: [
          this.compareCountDTO!.data!.numberOfEquipments!.toInt() > 1
              ? Container(
                  color: isDarkTheme!
                      ? AppColors.cupertinoBackground()
                      : AppColorsLightMode.cupertinoBackground()
                          .withOpacity(0.8),
                  child: CupertinoActionSheetAction(
                    onPressed: () {
                      Navigator.pushNamed(
                          context, AppRoutes.dqmTestResultCompareRoute,
                          arguments: DqmTestResultArguments(
                              measurementDTO: widget.measurementDTO,
                              compareBy: Constants.COMPARE_BY_EQUIPMENT));

                      Navigator.pop(popContext);
                    },
                    child: Text(
                      Utils.getTranslated(
                          context, 'compare_popup_compareby_equipment')!,
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
                )
              : Container(),
          this.compareCountDTO!.data!.numberOfFixtures!.toInt() > 1
              ? Container(
                  color: isDarkTheme!
                      ? AppColors.cupertinoBackground()
                      : AppColorsLightMode.cupertinoBackground()
                          .withOpacity(0.8),
                  child: CupertinoActionSheetAction(
                    onPressed: () {
                      Navigator.pushNamed(
                          context, AppRoutes.dqmTestResultCompareRoute,
                          arguments: DqmTestResultArguments(
                              measurementDTO: widget.measurementDTO,
                              compareBy: Constants.COMPARE_BY_FIXTURE));
                      Navigator.pop(popContext);
                    },
                    child: Text(
                      Utils.getTranslated(
                          context, 'compare_popup_compareby_fixture')!,
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
                )
              : Container(),
          (this.compareCountDTO!.data!.numberOfEquipments!.toInt() > 1 ||
                  this.compareCountDTO!.data!.numberOfFixtures!.toInt() > 1)
              ? Container(
                  color: isDarkTheme!
                      ? AppColors.cupertinoBackground()
                      : AppColorsLightMode.cupertinoBackground()
                          .withOpacity(0.8),
                  child: CupertinoActionSheetAction(
                    onPressed: () {
                      Navigator.pushNamed(
                          context, AppRoutes.dqmTestResultCompareRoute,
                          arguments: DqmTestResultArguments(
                              measurementDTO: widget.measurementDTO,
                              compareBy: Constants.COMPARE_BY_EQUIP_FIX));
                      Navigator.pop(popContext);
                    },
                    child: Text(
                      Utils.getTranslated(context,
                          'compare_popup_compareby_equipment_fixture')!,
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
                )
              : Container(),
          this.compareCountDTO!.data!.numberOfPanels!.toInt() > 1
              ? Container(
                  color: isDarkTheme!
                      ? AppColors.cupertinoBackground()
                      : AppColorsLightMode.cupertinoBackground()
                          .withOpacity(0.8),
                  child: CupertinoActionSheetAction(
                    onPressed: () {
                      Navigator.pushNamed(
                          context, AppRoutes.dqmTestResultCompareRoute,
                          arguments: DqmTestResultArguments(
                              measurementDTO: widget.measurementDTO,
                              compareBy: Constants.COMPARE_BY_PANEL));
                      Navigator.pop(popContext);
                    },
                    child: Text(
                      Utils.getTranslated(
                          context, 'compare_popup_compareby_panel')!,
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
                )
              : Container(),
          this.compareCountDTO!.data!.numberOfPanels!.toInt() > 1
              ? Container(
                  color: isDarkTheme!
                      ? AppColors.cupertinoBackground()
                      : AppColorsLightMode.cupertinoBackground()
                          .withOpacity(0.8),
                  child: CupertinoActionSheetAction(
                    onPressed: () {
                      Navigator.pushNamed(
                          context, AppRoutes.dqmTestResultCompareRoute,
                          arguments: DqmTestResultArguments(
                              measurementDTO: widget.measurementDTO,
                              compareBy: Constants.COMPARE_BY_ALL_PANEL));
                      Navigator.pop(popContext);
                    },
                    child: Text(
                      Utils.getTranslated(
                          context, 'compare_popup_compareby_all_panel')!,
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
                )
              : Container(),
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

  void downloadAsImage() {
    this.dqmWebViewController.webViewController.runJavascript('exportImage()');
  }

  void downloadAsPdf() {
    this.dqmWebViewController.webViewController.runJavascript('exportPDF()');
  }

  Future<void> downloadAsCsv() async {
    //KEYS_BM_BrdRst#2022.08.10@23.39.08
    String curDate =
        '#${DateFormat('yyyy.MM.dd').format(DateTime.now())}@${DateFormat('HH.mm.ss').format(DateTime.now())}';
    String filename = Utils.getExportFilename(
      'BrdRst',
      companyId: AppCache.sortFilterCacheDTO!.preferredCompany,
      siteId: AppCache.sortFilterCacheDTO!.preferredSite,
      currentDate: curDate,
      expType: '.csv',
    );

    bool result =
        await CSVApi.generateCSV(this.testResultTestNameDTO!.data!, filename);

    if (result == true) {
      setState(() {
        isLoading = false;
        var snackBar = SnackBar(
          content: Text(
            Utils.getTranslated(context, 'done_download_as_csv')!,
            style: AppFonts.robotoRegular(
              16,
              color: isDarkTheme! ? AppColors.appGrey() : AppColors.appGrey(),
              decoration: TextDecoration.none,
            ),
          ),
          backgroundColor: AppColors.appBlack0F(),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
    }
  }
}
