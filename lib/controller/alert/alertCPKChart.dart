import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:keysight_pma/const/appcolors.dart';
import 'package:keysight_pma/const/appfonts.dart';
import 'package:keysight_pma/const/constants.dart';
import 'package:keysight_pma/const/download.dart';
import 'package:keysight_pma/const/utils.dart';
import 'package:keysight_pma/dio/api/alert.dart';
import 'package:keysight_pma/model/alert/alert_cpk.dart';
import 'package:keysight_pma/model/dqm/test_result_cpk.dart';
import 'package:keysight_pma/model/js/js.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

import '../../cache/appcache.dart';

class CPKChart extends StatefulWidget {
  final String? appBarTitle;
  final AlertCpkDataDTO? alertCpkDataDTO;
  CPKChart({Key? key, this.appBarTitle, this.alertCpkDataDTO})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CPKChart();
  }
}

class _CPKChart extends State<CPKChart> {
  bool isLoading = true;
  late TestResultCpkDTO cpkDataDTO;
  double chartCpkHeight = 316.0;
  late WebViewPlusController cpkWebViewController;
  bool? theme_dark = AppCache.sortFilterCacheDTO!.currentTheme;

  Future<TestResultCpkDTO> getAlertCpkForEquipmentAndFixture(
      BuildContext context) {
    AlertApi alertApi = AlertApi(context);
    return alertApi.getAlertCpkForEquipmentAndFixture(
        widget.alertCpkDataDTO!.companyId!,
        widget.alertCpkDataDTO!.siteId!,
        widget.alertCpkDataDTO!.equipmentId!,
        widget.alertCpkDataDTO!.fixtureId!,
        widget.alertCpkDataDTO!.projectId!,
        widget.alertCpkDataDTO!.testName!,
        widget.alertCpkDataDTO!.startDate!,
        widget.alertCpkDataDTO!.endDate!);
  }

  @override
  void initState() {
    super.initState();
    Utils.setFirebaseAnalyticsCurrentScreen(
        Constants.ANALYTICS_ALERT_CPK_CHART_SCREEN);
    callGetAlertCpkForEquipmentAndFixture(context);
  }

  callGetAlertCpkForEquipmentAndFixture(BuildContext context) async {
    await getAlertCpkForEquipmentAndFixture(context).then((value) {
      if (value.status!.statusCode == 200) {
        this.cpkDataDTO = value;
      } else {
        Utils.showAlertDialog(
            context,
            Utils.getTranslated(context, 'general_alert_error_title')!,
            value.status!.statusMessage!);
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme_dark!
            ? AppColors.serverAppBar()
            : AppColorsLightMode.serverAppBar(),
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          widget.appBarTitle!,
          style: AppFonts.robotoRegular(20,
              color: theme_dark!
                  ? AppColors.appGrey()
                  : AppColorsLightMode.appGrey(),
              decoration: TextDecoration.none),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Image.asset(
              theme_dark!
                  ? Constants.ASSET_IMAGES + 'back_bttn.png'
                  : Constants.ASSET_IMAGES_LIGHT + 'back_bttn.png',
            )),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.all(16.0),
        child: this.isLoading
            ? Center(
                child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(AppColors.appBlue()),
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        Utils.getTranslated(context, 'alertDailyCPK')!,
                        style: AppFonts.robotoMedium(
                          16,
                          color: theme_dark!
                              ? AppColors.appGreyB1()
                              : AppColorsLightMode.appGrey77(),
                          decoration: TextDecoration.none,
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            showDownloadPopup(context);
                          },
                          icon: Image.asset(
                              Constants.ASSET_IMAGES + 'download_bttn.png')),
                    ],
                  ),
                  dailyCpkChart(context),
                ],
              ),
      ),
    );
  }

  Widget dailyCpkChart(BuildContext ctx) {
    return Container(
      height: this.chartCpkHeight,
      margin: EdgeInsets.only(top: 36.0),
      child: Container(
        width: MediaQuery.of(ctx).size.width,
        height: this.chartCpkHeight,
        color: Colors.transparent,
        child: (this.cpkDataDTO.data != null &&
                this.cpkDataDTO.data!.length > 0)
            ? WebViewPlus(
                backgroundColor: Colors.transparent,
                javascriptMode: JavascriptMode.unrestricted,
                initialUrl: theme_dark!
                    ? 'assets/html/alert_highchart_dark_theme.html'
                    : 'assets/html/alert_highchart_light_theme.html',
                zoomEnabled: false,
                gestureRecognizers: Set()
                  ..add(Factory<VerticalDragGestureRecognizer>(
                      () => VerticalDragGestureRecognizer()))
                  ..add(Factory<ScaleGestureRecognizer>(
                      () => ScaleGestureRecognizer())),
                onWebViewCreated: (controllerPlus) {
                  this.cpkWebViewController = controllerPlus;
                },
                onPageFinished: (url) {
                  this.cpkWebViewController.getHeight().then((value) {
                    setState(() {
                      this.chartCpkHeight = value;
                    });
                  });
                },
                javascriptChannels: [
                  JavascriptChannel(
                      name: 'AlertChannel',
                      onMessageReceived: (message) {
                        this.cpkWebViewController.webViewController.runJavascript(
                            'fetchDailyCpkDetailData(${jsonEncode(this.cpkDataDTO)}, "${widget.alertCpkDataDTO!.startDate}", "${widget.alertCpkDataDTO!.endDate}", "${Utils.getTranslated(ctx, 'chart_footer_date_cpk')}")');
                      }),
                  JavascriptChannel(
                      name: 'AlertClickChannel',
                      onMessageReceived: (message) {
                        Utils.printInfo(message.message);
                        if (Utils.isNotEmpty(message.message)) {
                          JSCpkDataDTO jsCpkDataDTO = JSCpkDataDTO.fromJson(
                              jsonDecode(message.message));
                          showTooltipsDialog(ctx, jsCpkDataDTO);
                        }
                      }),
                  JavascriptChannel(
                      name: 'DQMExportImageChannel',
                      onMessageReceived: (message) async {
                        print(message.message);
                        if (Utils.isNotEmpty(message.message)) {
                          String curDate =
                              '#${DateFormat('yyyy.MM.dd').format(DateTime.now())}@${DateFormat('HH.mm.ss').format(DateTime.now())}';

                          String name = Utils.getExportFilename(
                            'DlyCPK',
                            companyId:
                                AppCache.sortFilterCacheDTO!.preferredCompany,
                            siteId: AppCache.sortFilterCacheDTO!.preferredSite,
                            fromDate: DateFormat('yyyy-MM-dd').format(
                                AppCache.sortFilterCacheDTO!.startDate!),
                            toDate: DateFormat('yyyy-MM-dd')
                                .format(AppCache.sortFilterCacheDTO!.endDate!),
                            currentDate: curDate,
                            expType: '.png',
                          );

                          final result = await ImageApi.generateImage(
                              message.message,
                              600,
                              this.chartCpkHeight.round(),
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
                          String curDate =
                              '#${DateFormat('yyyy.MM.dd').format(DateTime.now())}@${DateFormat('HH.mm.ss').format(DateTime.now())}';

                          String name = Utils.getExportFilename(
                            'DlyCPK',
                            companyId:
                                AppCache.sortFilterCacheDTO!.preferredCompany,
                            siteId: AppCache.sortFilterCacheDTO!.preferredSite,
                            fromDate: DateFormat('yyyy-MM-dd').format(
                                AppCache.sortFilterCacheDTO!.startDate!),
                            toDate: DateFormat('yyyy-MM-dd')
                                .format(AppCache.sortFilterCacheDTO!.endDate!),
                            currentDate: curDate,
                            expType: '.pdf',
                          );

                          final result = await PdfApi.generatePDF(
                              message.message,
                              600,
                              this.chartCpkHeight.round(),
                              name);
                          if (result != null && result == true) {
                            setState(() {
                              // print('################## hihi');
                              var snackBar = SnackBar(
                                content: Text(
                                  Utils.getTranslated(
                                      context, 'done_download_as_pdf')!,
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
                    color: theme_dark!
                        ? AppColors.appGreyB1()
                        : AppColorsLightMode.appGrey77().withOpacity(0.4),
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
      ),
    );
  }

  void showTooltipsDialog(BuildContext context, JSCpkDataDTO jsDTO) {
    showDialog(
      context: context,
      builder: (tooltipsDialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: chartTooltipsInfo(context, jsDTO),
        );
      },
    );
  }

  Widget chartTooltipsInfo(BuildContext ctx, JSCpkDataDTO jsDTO) {
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
                .format(DateTime.parse(jsDTO.date!)),
            style: AppFonts.robotoRegular(
              16,
              color: theme_dark!
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
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${Utils.getTranslated(ctx, "dqm_testresult_analog_sortby_cpk")}:',
                    style: AppFonts.robotoRegular(
                      16,
                      color: HexColor('f4d745'),
                      decoration: TextDecoration.none,
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Text(
                    '${jsDTO.cpkValue!.toStringAsFixed(4)}',
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
        ],
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
                    .cpkWebViewController
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

                String curDate =
                    '#${DateFormat('yyyy.MM.dd').format(DateTime.now())}@${DateFormat('HH.mm.ss').format(DateTime.now())}';

                String name = Utils.getExportFilename(
                  'DlyCPK',
                  companyId: AppCache.sortFilterCacheDTO!.preferredCompany,
                  siteId: AppCache.sortFilterCacheDTO!.preferredSite,
                  fromDate: DateFormat('yyyy-MM-dd')
                      .format(AppCache.sortFilterCacheDTO!.startDate!),
                  toDate: DateFormat('yyyy-MM-dd')
                      .format(AppCache.sortFilterCacheDTO!.endDate!),
                  currentDate: curDate,
                  expType: '.csv',
                );

                final result = await CSVApi.generateCSV(cpkDataDTO.data!, name);
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
                    .cpkWebViewController
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
                  : AppColorsLightMode.cupertinoBackground(),
              borderRadius: BorderRadius.circular(14)),
          child: CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(downloadContext);
            },
            child: Text(
              Utils.getTranslated(context, 'cancel')!,
              style: AppFonts.robotoMedium(15,
                  color: theme_dark!
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
