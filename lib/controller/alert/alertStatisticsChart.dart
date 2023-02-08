import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:keysight_pma/cache/appcache.dart';
import 'package:keysight_pma/const/constants.dart';
import 'package:keysight_pma/const/download.dart';
import 'package:keysight_pma/const/utils.dart';
import 'package:keysight_pma/model/alert/alert_review_data.dart';
import 'package:keysight_pma/model/alert/alert_statistics.dart';
import 'package:keysight_pma/model/customize.dart';
import 'package:keysight_pma/model/js/js.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

import '../../const/appcolors.dart';
import '../../const/appfonts.dart';

class AlertStatisticChart extends StatefulWidget {
  final List<AlertReviewStatisticsDataDTO>? alertStatisticList;
  final List<AlertStatisticsDataDTO>? preferedAlertList;
  AlertStatisticChart(
      {Key? key, this.alertStatisticList, this.preferedAlertList})
      : super(key: key);

  @override
  State<AlertStatisticChart> createState() => _AlertStatisticChartState();
}

class _AlertStatisticChartState extends State<AlertStatisticChart> {
  bool isGraph = true;
  double chartHeight = 316.0;
  late WebViewPlusController alertWebViewController;
  late Map<String?, List<AlertReviewStatisticsDataDTO>> alertStatisticMap;
  late Map<String?, List<AlertStatisticsDataDTO>> preferredAlertStatisticMap;
  int statisticsDividerCounter = 0;
  bool? theme_dark = AppCache.sortFilterCacheDTO!.currentTheme;

  // List<CustomDTO> alertTypeList = [
  //   CustomDTO(
  //       displayName: "Pat Limit Recomendation",
  //       value: "DUTPatLimitRecommendation"),
  //   CustomDTO(
  //       displayName: "Limit Change Anomaly", value: "DUTLimitChangeAnomaly"),
  //   CustomDTO(
  //       displayName: "Test Coverage Changed", value: "TestCoverageChanged"),
  //   CustomDTO(
  //       displayName: "Consecutive Test Failure",
  //       value: "ConsecutiveTestFailure"),
  //   CustomDTO(displayName: "Component Anomaly", value: "DUTComponentAnomaly"),
  //   CustomDTO(displayName: "Fixture Maintenance", value: "FixtureMaintenance"),
  //   CustomDTO(
  //       displayName: "Degradation Anomaly", value: "DUTDegradationAnomaly"),
  //   CustomDTO(
  //       displayName: "Cpk Alert Anomalies", value: "DUTCpkAlertAnomalies"),
  //   CustomDTO(
  //       displayName: "Pat Limit Anomalies", value: "DUTPatLimitAnomalies"),
  //   CustomDTO(
  //       displayName: "Wip Scrap Board Alert", value: "WipScrapBoardAlert"),
  // ];

  void groupAlertStatisticByType() {
    final groups =
        groupBy(widget.alertStatisticList!, (AlertReviewStatisticsDataDTO e) {
      return e.alertType;
    });

    setState(() {
      this.alertStatisticMap = groups;
    });
  }

  void groupPreferredAlertStatisticByType() {
    final groups =
        groupBy(widget.preferedAlertList!, (AlertStatisticsDataDTO e) {
      return e.sender;
    });

    setState(() {
      this.preferredAlertStatisticMap = groups;
    });
  }

  @override
  void initState() {
    super.initState();
    Utils.setFirebaseAnalyticsCurrentScreen(
        Constants.ANALYTICS_ALERT_REVIEW_STATISTICS_SCREEN);
    if (widget.alertStatisticList != null &&
        widget.alertStatisticList!.length > 0) {
      groupAlertStatisticByType();
    } else if (widget.preferedAlertList != null &&
        widget.preferedAlertList!.length > 0) {
      groupPreferredAlertStatisticByType();
    }
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
          Utils.getTranslated(context, 'alert_statistics')!,
          style: AppFonts.robotoRegular(20,
              color: theme_dark!
                  ? AppColors.appGrey()
                  : AppColorsLightMode.appGrey(),
              decoration: TextDecoration.none),
        ),
        actions: [
          IconButton(
              onPressed: () {
                showDownloadPopup(context);
              },
              icon: Image.asset(theme_dark!
                  ? Constants.ASSET_IMAGES + 'download_bttn.png'
                  : Constants.ASSET_IMAGES_LIGHT + 'download_bttn.png')),
        ],
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
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: 276,
                      height: 38,
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 2,
                              color: AppColors.appAlertButtonBorder()),
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isGraph = true;
                          });
                        },
                        child: Container(
                          width: 138,
                          height: 38,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  bottomLeft: Radius.circular(8)),
                              color: isGraph
                                  ? AppColors.appTeal()
                                  : Colors.transparent),
                          child: Center(
                            child: Text(
                              Utils.getTranslated(context, 'graph')!,
                              style: AppFonts.robotoBold(
                                12,
                                color: isGraph
                                    ? AppColors.appPrimaryWhite()
                                    : AppColors.appAlertButtonBorder(),
                                decoration: TextDecoration.none,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isGraph = false;
                          });
                        },
                        child: Container(
                          width: 138,
                          height: 38,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(8),
                                  bottomRight: Radius.circular(8)),
                              color: !isGraph
                                  ? AppColors.appTeal()
                                  : Colors.transparent),
                          child: Center(
                            child: Text(
                              Utils.getTranslated(context, 'number')!,
                              style: AppFonts.robotoBold(
                                12,
                                color: !isGraph
                                    ? AppColors.appPrimaryWhite()
                                    : AppColors.appAlertButtonBorder(),
                                decoration: TextDecoration.none,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // SizedBox(height: 34),
              this.isGraph
                  ? (widget.alertStatisticList != null &&
                          widget.alertStatisticList!.length > 0)
                      ? chart(context)
                      : preferedChart(context)
                  : (widget.alertStatisticList != null &&
                          widget.alertStatisticList!.length > 0)
                      ? number(context)
                      : preferedNumber(context),
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
            ? 'assets/html/alert_highchart_dark_theme.html'
            : 'assets/html/alert_highchart_light_theme.html',
        zoomEnabled: false,
        gestureRecognizers: Set()
          ..add(Factory<VerticalDragGestureRecognizer>(
              () => VerticalDragGestureRecognizer()))
          ..add(
              Factory<ScaleGestureRecognizer>(() => ScaleGestureRecognizer())),
        onWebViewCreated: (controllerPlus) {
          this.alertWebViewController = controllerPlus;
        },
        onPageFinished: (url) {
          this.alertWebViewController.getHeight().then((value) {
            Utils.printInfo(value);
            setState(() {
              this.chartHeight = value;
            });
          });
        },
        javascriptChannels: [
          JavascriptChannel(
              name: 'AlertChannel',
              onMessageReceived: (message) {
                print(message.message);
                this.alertWebViewController.webViewController.runJavascript(
                    'fetchAlertStatisticsDetailData(${jsonEncode(widget.alertStatisticList)},"${Utils.getTranslated(context, 'chart_legend_high')}","${Utils.getTranslated(context, 'chart_legend_medium')}","${Utils.getTranslated(context, 'chart_legend_low')}","${Utils.getTranslated(context, 'chart_legend_others')}","${Utils.getTranslated(context, 'chart_footer_alertype_count')}")');
              }),
          JavascriptChannel(
              name: 'AlertClickChannel',
              onMessageReceived: (message) {
                print(message.message);
                if (Utils.isNotEmpty(message.message)) {
                  List<AlertReviewStatisticsDataDTO> dataList =
                      this.alertStatisticMap[message.message]!;
                  if (dataList.length > 0) {
                    showTooltipsDialog(
                        context, message.message, dataList, null);
                  }
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
                    'Top5AlrtStst',
                    companyId: AppCache.sortFilterCacheDTO!.preferredCompany,
                    siteId: AppCache.sortFilterCacheDTO!.preferredSite,
                    fromDate: DateFormat('yyyy-MM-dd')
                        .format(AppCache.sortFilterCacheDTO!.startDate!),
                    toDate: DateFormat('yyyy-MM-dd')
                        .format(AppCache.sortFilterCacheDTO!.endDate!),
                    currentDate: curDate,
                    expType: '.png',
                  );

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
                  String curDate =
                      '#${DateFormat('yyyy.MM.dd').format(DateTime.now())}@${DateFormat('HH.mm.ss').format(DateTime.now())}';

                  String name = Utils.getExportFilename(
                    'Top5AlrtStst',
                    companyId: AppCache.sortFilterCacheDTO!.preferredCompany,
                    siteId: AppCache.sortFilterCacheDTO!.preferredSite,
                    fromDate: DateFormat('yyyy-MM-dd')
                        .format(AppCache.sortFilterCacheDTO!.startDate!),
                    toDate: DateFormat('yyyy-MM-dd')
                        .format(AppCache.sortFilterCacheDTO!.endDate!),
                    currentDate: curDate,
                    expType: '.pdf',
                  );

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

  Widget preferedChart(BuildContext ctx) {
    return Container(
      width: MediaQuery.of(ctx).size.width,
      height: this.chartHeight,
      color: Colors.transparent,
      child: WebViewPlus(
        backgroundColor: Colors.transparent,
        javascriptMode: JavascriptMode.unrestricted,
        initialUrl: theme_dark!
            ? 'assets/html/alert_highchart_dark_theme.html'
            : 'assets/html/alert_highchart_light_theme.html',
        zoomEnabled: false,
        gestureRecognizers: Set()
          ..add(Factory<VerticalDragGestureRecognizer>(
              () => VerticalDragGestureRecognizer()))
          ..add(
              Factory<ScaleGestureRecognizer>(() => ScaleGestureRecognizer())),
        onWebViewCreated: (controllerPlus) {
          this.alertWebViewController = controllerPlus;
        },
        onPageFinished: (url) {
          this.alertWebViewController.getHeight().then((value) {
            Utils.printInfo(value);
            setState(() {
              this.chartHeight = value;
            });
          });
        },
        javascriptChannels: [
          JavascriptChannel(
              name: 'AlertChannel',
              onMessageReceived: (message) {
                print(message.message);
                this.alertWebViewController.webViewController.runJavascript(
                    'fetchPreferedAlertStatisticsDetailData(${jsonEncode(this.preferredAlertStatisticMap)},"${Utils.getTranslated(context, 'chart_legend_high')}","${Utils.getTranslated(context, 'chart_legend_medium')}","${Utils.getTranslated(context, 'chart_legend_low')}","${Utils.getTranslated(context, 'chart_legend_others')}","${Utils.getTranslated(context, 'chart_footer_alertype_count')}")');
              }),
          JavascriptChannel(
              name: 'AlertClickChannel',
              onMessageReceived: (message) {
                print(message.message);
                if (Utils.isNotEmpty(message.message)) {
                  JSAlertAccuracyStatusDTO jsDTO =
                      JSAlertAccuracyStatusDTO.fromJson(
                          jsonDecode(message.message));
                  showTooltipsDialog(context, message.message, null, jsDTO);
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
                    'Top5AlrtStst',
                    companyId: AppCache.sortFilterCacheDTO!.preferredCompany,
                    siteId: AppCache.sortFilterCacheDTO!.preferredSite,
                    fromDate: DateFormat('yyyy-MM-dd')
                        .format(AppCache.sortFilterCacheDTO!.startDate!),
                    toDate: DateFormat('yyyy-MM-dd')
                        .format(AppCache.sortFilterCacheDTO!.endDate!),
                    currentDate: curDate,
                    expType: '.png',
                  );

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
                  String curDate =
                      '#${DateFormat('yyyy.MM.dd').format(DateTime.now())}@${DateFormat('HH.mm.ss').format(DateTime.now())}';

                  String name = Utils.getExportFilename(
                    'Top5AlrtStst',
                    companyId: AppCache.sortFilterCacheDTO!.preferredCompany,
                    siteId: AppCache.sortFilterCacheDTO!.preferredSite,
                    fromDate: DateFormat('yyyy-MM-dd')
                        .format(AppCache.sortFilterCacheDTO!.startDate!),
                    toDate: DateFormat('yyyy-MM-dd')
                        .format(AppCache.sortFilterCacheDTO!.endDate!),
                    currentDate: curDate,
                    expType: '.pdf',
                  );
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

  Widget number(BuildContext ctx) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          colorDotLabel(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: this
                .alertStatisticMap
                .entries
                .map((entry) => alertStaticsItem(ctx, entry.key!, entry.value,
                    this.alertStatisticMap.length))
                .toList(),
          )
        ],
      ),
    );
  }

  Widget colorDotLabel() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      height: 43,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(top: 4, right: 10),
              height: 10,
              width: 10,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: AppColors.appAlertHigh()),
            ),
            Text(
              Utils.getTranslated(context, 'colordot_high')!,
              style: AppFonts.robotoMedium(
                13,
                color: theme_dark!
                    ? AppColors.appGreyDE()
                    : AppColorsLightMode.appGrey(),
                decoration: TextDecoration.none,
              ),
            ),
            SizedBox(width: 20),
            Container(
              margin: EdgeInsets.only(top: 4, right: 10),
              height: 10,
              width: 10,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: AppColors.appAlertMed()),
            ),
            Text(
              Utils.getTranslated(context, 'colordot_medium')!,
              style: AppFonts.robotoMedium(
                13,
                color: theme_dark!
                    ? AppColors.appGreyDE()
                    : AppColorsLightMode.appGrey(),
                decoration: TextDecoration.none,
              ),
            ),
            SizedBox(width: 20),
            Container(
              margin: EdgeInsets.only(top: 4, right: 10),
              height: 10,
              width: 10,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: AppColors.appAlertLow()),
            ),
            Text(
              Utils.getTranslated(context, 'colordot_low')!,
              style: AppFonts.robotoMedium(
                13,
                color: theme_dark!
                    ? AppColors.appGreyDE()
                    : AppColorsLightMode.appGrey(),
                decoration: TextDecoration.none,
              ),
            ),
            SizedBox(width: 20),
            Container(
              margin: EdgeInsets.only(top: 4, right: 10),
              height: 10,
              width: 10,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: AppColors.appPrimaryWhite()),
            ),
            Text(
              Utils.getTranslated(context, 'colordot_other')!,
              style: AppFonts.robotoMedium(
                13,
                color: theme_dark!
                    ? AppColors.appGreyDE()
                    : AppColorsLightMode.appGrey(),
                decoration: TextDecoration.none,
              ),
            ),
          ]),
    );
  }

  Widget alertStaticsItem(BuildContext ctx, String key,
      List<AlertReviewStatisticsDataDTO> dataList, int length) {
    (statisticsDividerCounter != length)
        ? statisticsDividerCounter = statisticsDividerCounter + 1
        : statisticsDividerCounter = 1;
    return Container(
      height: 67.5,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: (statisticsDividerCounter != length)
                ? theme_dark!
                    ? AppColors.appDividerColor()
                    : AppColorsLightMode.appDividerColor()
                : Colors.transparent,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 100,
            child: Text(
              Utils.ammendSentences(key),
              style: AppFonts.sfproRegular(
                13,
                color: theme_dark!
                    ? AppColors.appGreyB1()
                    : AppColorsLightMode.appGrey77(),
                decoration: TextDecoration.none,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          SizedBox(width: 30.0),
          Expanded(
            child: Container(
              child: Wrap(
                children: dataList
                    .map((e) =>
                        alertStatusItem(ctx, e.alertSeverity, e.alertCount!))
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget preferedNumber(BuildContext ctx) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          colorDotLabel(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: this
                .preferredAlertStatisticMap
                .entries
                .map((entry) => preferedAlertStaticsItem(ctx, entry.key!,
                    entry.value, this.preferredAlertStatisticMap.length))
                .toList(),
          )
        ],
      ),
    );
  }

  Widget preferedAlertStaticsItem(BuildContext ctx, String key,
      List<AlertStatisticsDataDTO> dataList, int length) {
    (statisticsDividerCounter != length)
        ? statisticsDividerCounter = statisticsDividerCounter + 1
        : statisticsDividerCounter = 1;

    num? highCount;
    num? medCount;
    num? lowCount;
    num? otherCount;
    if (dataList.length > 0) {
      highCount = dataList
          .where((element) => element.alertSeverity == Constants.ALERT_HIGH)
          .toList()
          .length;
      medCount = dataList
          .where((element) => element.alertSeverity == Constants.ALERT_MEDIUM)
          .toList()
          .length;
      lowCount = dataList
          .where((element) => element.alertSeverity == Constants.ALERT_LOW)
          .toList()
          .length;
      otherCount = dataList
          .where((element) => !Utils.isNotEmpty(element.alertSeverity))
          .toList()
          .length;
    }

    return Container(
      height: 67.5,
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  width: 1,
                  color: (statisticsDividerCounter != length)
                      ? theme_dark!
                          ? AppColors.appDividerColor()
                          : AppColorsLightMode.appDividerColor()
                      : Colors.transparent))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 100,
            child: Text(
              Utils.ammendSentences(key),
              style: AppFonts.sfproRegular(
                13,
                color: theme_dark!
                    ? AppColors.appGreyB1()
                    : AppColorsLightMode.appGrey77(),
                decoration: TextDecoration.none,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          SizedBox(width: 30.0),
          Expanded(
            child: Container(
              child: Wrap(
                children: [
                  (highCount != null && highCount.toInt() > 0)
                      ? preferedAlertStatusItem(ctx, "High", highCount)
                      : Container(),
                  (medCount != null && medCount.toInt() > 0)
                      ? preferedAlertStatusItem(ctx, "Medium", medCount)
                      : Container(),
                  (lowCount != null && lowCount.toInt() > 0)
                      ? preferedAlertStatusItem(ctx, "Low", lowCount)
                      : Container(),
                  (otherCount != null && otherCount.toInt() > 0)
                      ? preferedAlertStatusItem(ctx, "Others", otherCount)
                      : Container(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget preferedAlertStatusItem(BuildContext ctx, String? status, num? count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 10,
          width: 10,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: status == Constants.ALERT_HIGH
                  ? AppColors.appAlertHigh()
                  : status == Constants.ALERT_MEDIUM
                      ? AppColors.appAlertMed()
                      : status == Constants.ALERT_LOW
                          ? AppColors.appAlertLow()
                          : AppColors.appPrimaryWhite()),
        ),
        SizedBox(width: 10.0),
        Text(
          '${count!.toInt()}',
          style: AppFonts.robotoMedium(
            13,
            color: theme_dark!
                ? AppColors.appGreyDE()
                : AppColorsLightMode.appGrey(),
            decoration: TextDecoration.none,
          ),
        ),
        SizedBox(width: 16.0),
      ],
    );
  }

  Widget alertStatusItem(BuildContext ctx, String? status, num count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 10,
          width: 10,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: status == Constants.ALERT_HIGH
                  ? AppColors.appAlertHigh()
                  : status == Constants.ALERT_MEDIUM
                      ? AppColors.appAlertMed()
                      : status == Constants.ALERT_LOW
                          ? AppColors.appAlertLow()
                          : AppColors.appPrimaryWhite()),
        ),
        SizedBox(width: 10.0),
        Text(
          '${count.toInt()}',
          style: AppFonts.robotoMedium(
            13,
            color: theme_dark!
                ? AppColors.appGreyDE()
                : AppColorsLightMode.appGrey(),
            decoration: TextDecoration.none,
          ),
        ),
        SizedBox(width: 16.0),
      ],
    );
  }

  void showTooltipsDialog(
      BuildContext context,
      String alertType,
      List<AlertReviewStatisticsDataDTO>? dataList,
      JSAlertAccuracyStatusDTO? jsDTO) {
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
              tooltipsDialogContext, alertType, dataList, jsDTO),
        );
      },
    );
  }

  Widget chartTooltipsInfo(
      BuildContext ctx,
      String alertType,
      List<AlertReviewStatisticsDataDTO>? dataList,
      JSAlertAccuracyStatusDTO? jsDTO) {
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
            dataList != null && dataList.length > 0
                ? Utils.ammendSentences(alertType)
                : Utils.ammendSentences(jsDTO!.status!),
            style: AppFonts.robotoRegular(
              16,
              color: theme_dark!
                  ? AppColors.appGrey2()
                  : AppColorsLightMode.appGrey2(),
              decoration: TextDecoration.none,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: dataList != null && dataList.length > 0
                ? dataList.map((e) => infoItem(e)).toList()
                : [
                    (jsDTO != null &&
                            jsDTO.highTotal != null &&
                            jsDTO.highTotal!.toInt() > 0)
                        ? preferedInfoItem('High', jsDTO.highTotal!.toInt(),
                            AppColors.appAlertHigh())
                        : Container(),
                    (jsDTO != null &&
                            jsDTO.medTotal != null &&
                            jsDTO.medTotal!.toInt() > 0)
                        ? preferedInfoItem('Medium', jsDTO.medTotal!.toInt(),
                            AppColors.appAlertMed())
                        : Container(),
                    (jsDTO != null &&
                            jsDTO.lowTotal != null &&
                            jsDTO.lowTotal!.toInt() > 0)
                        ? preferedInfoItem('Low', jsDTO.lowTotal!.toInt(),
                            AppColors.appAlertLow())
                        : Container(),
                    (jsDTO != null &&
                            jsDTO.otherTotal != null &&
                            jsDTO.otherTotal!.toInt() > 0)
                        ? preferedInfoItem('Others', jsDTO.otherTotal!.toInt(),
                            AppColors.appPrimaryWhite())
                        : Container(),
                  ],
          ),
        ],
      ),
    );
  }

  Widget infoItem(AlertReviewStatisticsDataDTO dataDTO) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            Utils.isNotEmpty(dataDTO.alertSeverity)
                ? '${dataDTO.alertSeverity!}:'
                : "Others:",
            style: AppFonts.robotoRegular(
              16,
              color: Utils.isNotEmpty(dataDTO.alertSeverity)
                  ? (dataDTO.alertSeverity == Constants.ALERT_HIGH)
                      ? AppColors.appAlertHigh()
                      : (dataDTO.alertSeverity == Constants.ALERT_MEDIUM)
                          ? AppColors.appAlertMed()
                          : (dataDTO.alertSeverity == Constants.ALERT_LOW)
                              ? AppColors.appAlertLow()
                              : AppColors.appGrey2()
                  : AppColors.appPrimaryWhite(),
              decoration: TextDecoration.none,
            ),
          ),
          SizedBox(width: 10.0),
          Text(
            '${dataDTO.alertCount}',
            style: AppFonts.robotoRegular(
              16,
              color: theme_dark!
                  ? AppColors.appGrey2()
                  : AppColorsLightMode.appGrey(),
              decoration: TextDecoration.none,
            ),
          ),
        ],
      ),
    );
  }

  Widget preferedInfoItem(String type, int count, Color textColor) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            '$type:',
            style: AppFonts.robotoRegular(
              16,
              color: textColor,
              decoration: TextDecoration.none,
            ),
          ),
          SizedBox(width: 10.0),
          Text(
            '$count',
            style: AppFonts.robotoRegular(
              16,
              color: theme_dark!
                  ? AppColors.appGrey2()
                  : AppColorsLightMode.appGrey(),
              decoration: TextDecoration.none,
            ),
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
                    .alertWebViewController
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
                  'Top5AlrtStst',
                  companyId: AppCache.sortFilterCacheDTO!.preferredCompany,
                  siteId: AppCache.sortFilterCacheDTO!.preferredSite,
                  fromDate: DateFormat('yyyy-MM-dd')
                      .format(AppCache.sortFilterCacheDTO!.startDate!),
                  toDate: DateFormat('yyyy-MM-dd')
                      .format(AppCache.sortFilterCacheDTO!.endDate!),
                  currentDate: curDate,
                  expType: '.csv',
                );

                var object = [];
                if (widget.alertStatisticList != null)
                  widget.alertStatisticList!.forEach((e) {
                    var high;
                    var low;
                    var medium;
                    var others;
                    var category;
                    if (e.alertSeverity!.contains("High")) {
                      high = e.alertCount!;
                    } else if (e.alertSeverity!.contains("Medium")) {
                      medium = e.alertCount!;
                    } else if (e.alertSeverity!.contains("Low")) {
                      low = e.alertCount!;
                    } else {
                      others = e.alertCount!;
                    }
                    category = Utils.ammendSentences(e.alertType!);

                    object.add({
                      "category": category,
                      Utils.getTranslated(context, 'csv_high')!: high,
                      Utils.getTranslated(context, 'csv_medium')!: medium,
                      Utils.getTranslated(context, 'csv_low')!: low,
                      Utils.getTranslated(context, 'csv_others')!: others,
                    });
                  });
                else
                  widget.preferedAlertList!.forEach((e) {
                    var high = 0;
                    var low = 0;
                    var medium = 0;
                    var others = 0;
                    var category;
                    if (e.severity!.contains("High")) {
                      high++;
                    } else if (e.severity!.contains("Medium")) {
                      medium++;
                    } else if (e.severity!.contains("Low")) {
                      low++;
                    } else {
                      others++;
                    }
                    category = e.status;

                    object.add({
                      "category": category,
                      Utils.getTranslated(context, 'csv_high')!: high,
                      Utils.getTranslated(context, 'csv_medium')!: medium,
                      Utils.getTranslated(context, 'csv_low')!: low,
                      Utils.getTranslated(context, 'csv_others')!: others,
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
                    .alertWebViewController
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
