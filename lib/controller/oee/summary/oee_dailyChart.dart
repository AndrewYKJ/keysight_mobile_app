import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:keysight_pma/const/appcolors.dart';
import 'package:keysight_pma/const/appfonts.dart';
import 'package:keysight_pma/const/constants.dart';
import 'package:keysight_pma/const/download.dart';
import 'package:keysight_pma/const/utils.dart';
import 'package:keysight_pma/controller/admin/preferred_setting/custom.dart';
import 'package:keysight_pma/model/arguments/oee_argument.dart';
import 'package:keysight_pma/model/oee/oeeSummary.dart';
import 'package:keysight_pma/routes/approutes.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';
import '../../../cache/appcache.dart';
import '../../../const/appfonts.dart';
import '../../../dio/api/oee.dart';

class OEEDailyChart extends StatefulWidget {
  final String? chartName;
  final String selectedEquipment;
  final String selectedSite;
  final String selectedCompany;
  const OEEDailyChart(
      {Key? key,
      this.chartName,
      required this.selectedCompany,
      required this.selectedEquipment,
      required this.selectedSite})
      : super(key: key);

  @override
  State<OEEDailyChart> createState() => _OEEDailyChartState();
}

class _OEEDailyChartState extends State<OEEDailyChart> {
  bool isLoading = true;
  OeeSummaryDTO dailyEquipmentOEE = OeeSummaryDTO();
  OeeSummaryDataDTO chartData = OeeSummaryDataDTO();
  late WebViewPlusController oeeWebViewController;
  double chartHeight = 400;

  bool? theme_dark = AppCache.sortFilterCacheDTO!.currentTheme;
  Future<OeeSummaryDTO> getDailyOEEforEquipment(BuildContext context) {
    OeeApi oeeApi = OeeApi(context);
    return oeeApi.getDailyOEEforEquipment(
        widget.selectedCompany,
        widget.selectedSite,
        widget.selectedEquipment,
        DateFormat("yyyyMMdd").format(AppCache.sortFilterCacheDTO!.startDate!),
        DateFormat("yyyyMMdd").format(AppCache.sortFilterCacheDTO!.endDate!));
  }

  @override
  void initState() {
    super.initState();
    Utils.setFirebaseAnalyticsCurrentScreen(
        Constants.ANALYTICS_OEE_SUMMARY_DAILY_EQUIP_CHART_SCREEN);
    callListSiteOEE(context);
  }

  callListSiteOEE(BuildContext context) async {
    await getDailyOEEforEquipment(context).then((value) {
      dailyEquipmentOEE = value;
      //print(listEquipmentOEE);
    }).catchError((error) {
      Utils.printInfo(error);
    });
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
        centerTitle: true,
        title: Text(
          widget.chartName!,
          style: AppFonts.robotoRegular(
            20,
            color: theme_dark!
                ? AppColors.appGrey()
                : AppColorsLightMode.appGrey(),
            decoration: TextDecoration.none,
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
      body: Container(
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
            : Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.only(bottom: 5, top: 0),
                height: this.chartHeight,
                child: (dailyEquipmentOEE.data != null &&
                        dailyEquipmentOEE.data!.length > 0)
                    ? WebViewPlus(
                        backgroundColor: Colors.transparent,
                        javascriptMode: JavascriptMode.unrestricted,
                        initialUrl: theme_dark!
                            ? 'assets/html/oee_highchart_dark_theme.html'
                            : 'assets/html/oee_highchart_light_theme.html',
                        zoomEnabled: false,
                        onWebViewCreated: (controllerPlus) {
                          this.oeeWebViewController = controllerPlus;
                        },
                        onPageFinished: (url) {
                          this.oeeWebViewController.getHeight().then((value) {
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
                                print(message.message);
                                this
                                    .oeeWebViewController
                                    .webViewController
                                    .runJavascript(
                                        'fetchEquipmentDailyOEEInfo(${jsonEncode(this.dailyEquipmentOEE)}, "${DateFormat("yyyy-MM-dd").format(AppCache.sortFilterCacheDTO!.startDate!)}", "${DateFormat("yyyy-MM-dd").format(AppCache.sortFilterCacheDTO!.endDate!)}","${Utils.getTranslated(context, 'oee_chart_availability')}","${Utils.getTranslated(context, 'oee_chart_perfornance')}","${Utils.getTranslated(context, 'oee_chart_quality')}","${Utils.getTranslated(context, 'oee_chart_oee')}","${Utils.getTranslated(context, 'oee_chart_credit_timestamp/score')}")');
                              }),
                          JavascriptChannel(
                              name: 'OEEClickChannel',
                              onMessageReceived: (message) {
                                print(message.message);
                                setState(() {
                                  chartData = OeeSummaryDataDTO.fromJson(
                                      jsonDecode(message.message));
                                  //(chartData.date);
                                });
                                showTooltipsDialog(context);
                              }),
                          JavascriptChannel(
                              name: 'DQMExportImageChannel',
                              onMessageReceived: (message) async {
                                print(message.message);
                                if (Utils.isNotEmpty(message.message)) {
                                  String name = 'oeeDailyChart.png';

                                  final result = await ImageApi.generateImage(
                                      message.message,
                                      600,
                                      this.chartHeight.round(),
                                      name);
                                  if (result != null && result == true) {
                                    setState(() {
                                      // print('################## hihi');
                                      var snackBar = SnackBar(
                                        content: Text(
                                          Utils.getTranslated(
                                              context, 'download_as_image')!,
                                          style: AppFonts.robotoRegular(
                                            16,
                                            color: theme_dark!
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
                                  String name = 'oeeDailyChart.pdf';

                                  final result = await PdfApi.generatePDF(
                                      message.message,
                                      600,
                                      this.chartHeight.round(),
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
                          Utils.getTranslated(context, 'no_data_available')!,
                          style: AppFonts.robotoRegular(
                            16,
                            color: theme_dark!
                                ? AppColors.appGreyB1()
                                : AppColorsLightMode.appGrey77()
                                    .withOpacity(0.4),
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
              ),
      ),
    );
  }

  void showTooltipsDialog(
    BuildContext ctx,
  ) {
    String date =
        DateFormat.yMMMMEEEEd().format(DateTime.parse(chartData.date!));
    showDialog(
        context: ctx,
        builder: (tooltipsDialogContext) {
          return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              elevation: 0,
              backgroundColor: Colors.transparent,
              child: Container(
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
                      date,
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
                        children: [
                          Text(
                            Utils.getTranslated(context, 'oee_availability')!,
                            style: AppFonts.robotoRegular(
                              14,
                              color: HexColor("#f5d845"),
                              decoration: TextDecoration.none,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            ':',
                            style: AppFonts.robotoRegular(
                              14,
                              color: theme_dark!
                                  ? AppColors.appGrey2()
                                  : AppColorsLightMode.appGrey2(),
                              decoration: TextDecoration.none,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            chartData.availability!.toString(),
                            style: AppFonts.robotoRegular(
                              14,
                              color: theme_dark!
                                  ? AppColors.appGrey2()
                                  : AppColorsLightMode.appGrey2(),
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ]),
                    SizedBox(height: 14),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Utils.getTranslated(context, 'oee_performance')!,
                            style: AppFonts.robotoRegular(
                              14,
                              color: HexColor("fba30a"),
                              decoration: TextDecoration.none,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            ':',
                            style: AppFonts.robotoRegular(
                              14,
                              color: theme_dark!
                                  ? AppColors.appGrey2()
                                  : AppColorsLightMode.appGrey2(),
                              decoration: TextDecoration.none,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            chartData.performance!.toString(),
                            style: AppFonts.robotoRegular(
                              14,
                              color: theme_dark!
                                  ? AppColors.appGrey2()
                                  : AppColorsLightMode.appGrey2(),
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ]),
                    SizedBox(height: 14),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Utils.getTranslated(context, 'oee_quality')!,
                            style: AppFonts.robotoRegular(
                              14,
                              color: HexColor("f37719"),
                              decoration: TextDecoration.none,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            ':',
                            style: AppFonts.robotoRegular(
                              14,
                              color: theme_dark!
                                  ? AppColors.appGrey2()
                                  : AppColorsLightMode.appGrey2(),
                              decoration: TextDecoration.none,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            chartData.quality!.toString(),
                            style: AppFonts.robotoRegular(
                              14,
                              color: theme_dark!
                                  ? AppColors.appGrey2()
                                  : AppColorsLightMode.appGrey2(),
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ]),
                    SizedBox(height: 14),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "OEE",
                            style: AppFonts.robotoRegular(
                              14,
                              color: HexColor("dc5039"),
                              decoration: TextDecoration.none,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            ':',
                            style: AppFonts.robotoRegular(
                              14,
                              color: theme_dark!
                                  ? AppColors.appGrey2()
                                  : AppColorsLightMode.appGrey2(),
                              decoration: TextDecoration.none,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            chartData.oee!.toString(),
                            style: AppFonts.robotoRegular(
                              14,
                              color: theme_dark!
                                  ? AppColors.appGrey2()
                                  : AppColorsLightMode.appGrey2(),
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ]),
                  ],
                ),
              ));
        });
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
                    .oeeWebViewController
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

                String name = "oeeDailyChart.csv";
                var object = [];
                dailyEquipmentOEE.data!.forEach((key) {
                  object.add({
                    "${Utils.getTranslated(context, 'csv_dateTime')}": key.date,
                    '${Utils.getTranslated(context, 'oee_chart_availability')}':
                        key.availability,
                    '${Utils.getTranslated(context, 'oee_chart_perfornance')}':
                        key.performance,
                    '${Utils.getTranslated(context, 'oee_chart_quality')}':
                        key.quality,
                    '${Utils.getTranslated(context, 'oee_chart_oee')}': key.oee,
                  });
                });
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
                    .oeeWebViewController
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
