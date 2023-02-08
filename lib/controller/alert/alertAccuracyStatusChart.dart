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

class AlertAccuracyStatusScreen extends StatefulWidget {
  final List<AlertAccuracyDataDTO>? alertAccuracyStatusList;
  final List<AlertStatisticsDataDTO>? preferedAlertList;
  AlertAccuracyStatusScreen(
      {Key? key, this.alertAccuracyStatusList, this.preferedAlertList})
      : super(key: key);

  @override
  State<AlertAccuracyStatusScreen> createState() =>
      _AlertAccuracyStatusScreen();
}

class _AlertAccuracyStatusScreen extends State<AlertAccuracyStatusScreen> {
  bool isGraph = true;
  double chartHeight = 316.0;
  late WebViewPlusController alertWebViewController;
  late Map<String?, List<AlertAccuracyDataDTO>> alertAccuracyMap;
  late Map<String?, List<AlertStatisticsDataDTO>> preferedAlertAccuracyMap;
  int accuracyDividerCounter = 0;
  List<CustomDTO> alertStatusList = [
    CustomDTO(displayName: "Actual", value: Constants.ALERT_ACC_ACTUAL),
    CustomDTO(displayName: "Dismiss", value: Constants.ALERT_ACC_DISMISS),
    CustomDTO(displayName: "Dispose", value: Constants.ALERT_ACC_DISPOSE),
  ];

  void groupAlertAccuracyByStatus() {
    widget.alertAccuracyStatusList!.sort((a, b) {
      return a.status!.compareTo(b.status!);
    });
    final groups =
        groupBy(widget.alertAccuracyStatusList!, (AlertAccuracyDataDTO e) {
      return e.status;
    });

    setState(() {
      this.alertAccuracyMap = groups;
    });
  }

  void groupPreferedAlertAccuracyByStatus() {
    widget.preferedAlertList!.sort((a, b) {
      return a.status!.compareTo(b.status!);
    });
    final groups =
        groupBy(widget.preferedAlertList!, (AlertStatisticsDataDTO e) {
      return e.status;
    });

    setState(() {
      this.preferedAlertAccuracyMap = groups;
    });
  }

  @override
  void initState() {
    super.initState();
    Utils.setFirebaseAnalyticsCurrentScreen(
        Constants.ANALYTICS_ALERT_REVIEW_ACCURACY_STATUS_SCREEN);
    if (widget.alertAccuracyStatusList != null &&
        widget.alertAccuracyStatusList!.length > 0) {
      groupAlertAccuracyByStatus();
    } else if (widget.preferedAlertList != null &&
        widget.preferedAlertList!.length > 0) {
      groupPreferedAlertAccuracyByStatus();
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
                  ? (widget.alertAccuracyStatusList != null &&
                          widget.alertAccuracyStatusList!.length > 0)
                      ? chart(context)
                      : preferedChart(context)
                  : (widget.alertAccuracyStatusList != null &&
                          widget.alertAccuracyStatusList!.length > 0)
                      ? number(context)
                      : preferedNumber(context),
            ],
          ),
        ),
      ),
    );
  }

  bool? theme_dark = AppCache.sortFilterCacheDTO!.currentTheme;
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
                    'fetchAlertAccuracyStatusDetailData(${jsonEncode(this.alertAccuracyMap)},"${Utils.getTranslated(context, 'chart_legend_high')}","${Utils.getTranslated(context, 'chart_legend_medium')}","${Utils.getTranslated(context, 'chart_legend_low')}","${Utils.getTranslated(context, 'chart_legend_others')}","${Utils.getTranslated(context, 'chart_footer_alertype_count')}")');
              }),
          JavascriptChannel(
              name: 'AlertClickChannel',
              onMessageReceived: (message) {
                print(message.message);
                if (Utils.isNotEmpty(message.message)) {
                  JSAlertAccuracyStatusDTO jsAlertAccuracyStatusDTO =
                      JSAlertAccuracyStatusDTO.fromJson(
                          jsonDecode(message.message));
                  showTooltipsDialog(ctx, jsAlertAccuracyStatusDTO);
                }
              }),
          JavascriptChannel(
              name: 'DQMExportImageChannel',
              onMessageReceived: (message) async {
                print(message.message);
                if (Utils.isNotEmpty(message.message)) {
                  String name = 'alertAccuracyChart.png';

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
                    'AlrtAcrcyBySts',
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
                    'fetchPreferedAlertAccuracyStatusDetailData(${jsonEncode(this.preferedAlertAccuracyMap)},"${Utils.getTranslated(context, 'chart_legend_high')}","${Utils.getTranslated(context, 'chart_legend_medium')}","${Utils.getTranslated(context, 'chart_legend_low')}","${Utils.getTranslated(context, 'chart_legend_others')}","${Utils.getTranslated(context, 'chart_footer_alertype_count')}")');
              }),
          JavascriptChannel(
              name: 'AlertClickChannel',
              onMessageReceived: (message) {
                print(message.message);
                if (Utils.isNotEmpty(message.message)) {
                  JSAlertAccuracyStatusDTO jsAlertAccuracyStatusDTO =
                      JSAlertAccuracyStatusDTO.fromJson(
                          jsonDecode(message.message));
                  showTooltipsDialog(ctx, jsAlertAccuracyStatusDTO);
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
                    'AlrtAcrcyBySts',
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
                    'AlrtAcrcyBySts',
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
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            colorDotLabel(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: this
                  .alertAccuracyMap
                  .entries
                  .map((entry) => alertAccuracyItem(context, entry.key!,
                      entry.value, this.alertAccuracyMap.length))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget alertAccuracyItem(BuildContext ctx, String key,
      List<AlertAccuracyDataDTO> dataList, int length) {
    int highTotal = 0;
    int mediumTotal = 0;
    int lowTotal = 0;
    int otherTotal = 0;
    List<CustomDTO> totalList = [];
    dataList.forEach((element) {
      if (Utils.isNotEmpty(element.alertSeverity)) {
        if (element.alertSeverity == Constants.ALERT_HIGH) {
          highTotal = highTotal + element.alertCount!.toInt();
        } else if (element.alertSeverity == Constants.ALERT_MEDIUM) {
          mediumTotal = mediumTotal + element.alertCount!.toInt();
        } else if (element.alertSeverity == Constants.ALERT_LOW) {
          lowTotal = lowTotal + element.alertCount!.toInt();
        }
      } else {
        otherTotal = otherTotal + element.alertCount!.toInt();
      }
    });

    if (highTotal > 0) {
      totalList.add(CustomDTO(
          displayName: highTotal.toString(), value: Constants.ALERT_HIGH));
    }

    if (mediumTotal > 0) {
      totalList.add(CustomDTO(
          displayName: mediumTotal.toString(), value: Constants.ALERT_MEDIUM));
    }

    if (lowTotal > 0) {
      totalList.add(CustomDTO(
          displayName: lowTotal.toString(), value: Constants.ALERT_LOW));
    }

    if (otherTotal > 0) {
      totalList.add(CustomDTO(displayName: otherTotal.toString(), value: ""));
    }

    (accuracyDividerCounter != length)
        ? accuracyDividerCounter = accuracyDividerCounter + 1
        : accuracyDividerCounter = 1;
    return Container(
      height: 67.5,
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  width: 1,
                  color: (accuracyDividerCounter != length)
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
              alertStatusList
                  .firstWhere((element) => element.value == key)
                  .displayName!,
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
                children: totalList
                    .map((e) => alertStatusItem(
                        ctx, e.value, num.parse(e.displayName!)))
                    .toList(),
              ),
            ),
          ),
        ],
      ),
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
                .preferedAlertAccuracyMap
                .entries
                .map((entry) => preferedAlertAccuracyItem(context, entry.key!,
                    entry.value, this.preferedAlertAccuracyMap.length))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget preferedAlertAccuracyItem(BuildContext ctx, String key,
      List<AlertStatisticsDataDTO> dataList, int length) {
    int highTotal = 0;
    int mediumTotal = 0;
    int lowTotal = 0;
    int otherTotal = 0;
    List<CustomDTO> totalList = [];

    highTotal = dataList
        .where((element) =>
            Utils.isNotEmpty(element.alertSeverity) &&
            element.alertSeverity == Constants.ALERT_HIGH)
        .toList()
        .length;
    mediumTotal = dataList
        .where((element) =>
            Utils.isNotEmpty(element.alertSeverity) &&
            element.alertSeverity == Constants.ALERT_MEDIUM)
        .toList()
        .length;
    lowTotal = dataList
        .where((element) =>
            Utils.isNotEmpty(element.alertSeverity) &&
            element.alertSeverity == Constants.ALERT_LOW)
        .toList()
        .length;
    otherTotal = dataList
        .where((element) => !Utils.isNotEmpty(element.alertSeverity))
        .toList()
        .length;

    if (highTotal > 0) {
      totalList.add(CustomDTO(
          displayName: highTotal.toString(), value: Constants.ALERT_HIGH));
    }

    if (mediumTotal > 0) {
      totalList.add(CustomDTO(
          displayName: mediumTotal.toString(), value: Constants.ALERT_MEDIUM));
    }

    if (lowTotal > 0) {
      totalList.add(CustomDTO(
          displayName: lowTotal.toString(), value: Constants.ALERT_LOW));
    }

    if (otherTotal > 0) {
      totalList.add(CustomDTO(displayName: otherTotal.toString(), value: ""));
    }

    (accuracyDividerCounter != length)
        ? accuracyDividerCounter = accuracyDividerCounter + 1
        : accuracyDividerCounter = 1;
    return Container(
      height: 67.5,
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  width: 1,
                  color: (accuracyDividerCounter != length)
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
              alertStatusList
                  .firstWhere((element) => element.value == key)
                  .displayName!,
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
                children: totalList
                    .map((e) => alertStatusItem(
                        ctx, e.value, num.parse(e.displayName!)))
                    .toList(),
              ),
            ),
          ),
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

  void showTooltipsDialog(
      BuildContext context, JSAlertAccuracyStatusDTO jsDTO) {
    showDialog(
      context: context,
      builder: (tooltipsDialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: chartTooltipsInfo(tooltipsDialogContext, jsDTO),
        );
      },
    );
  }

  Widget chartTooltipsInfo(BuildContext ctx, JSAlertAccuracyStatusDTO jsDTO) {
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
            '${jsDTO.status}',
            style: AppFonts.robotoRegular(
              16,
              color: theme_dark!
                  ? AppColors.appGrey2()
                  : AppColorsLightMode.appGrey(),
              decoration: TextDecoration.none,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              (jsDTO.highTotal != null && jsDTO.highTotal!.toInt() > 0)
                  ? infoItem('High', jsDTO.highTotal!.toInt(),
                      AppColors.appAlertHigh())
                  : Container(),
              (jsDTO.medTotal != null && jsDTO.medTotal!.toInt() > 0)
                  ? infoItem('Medium', jsDTO.medTotal!.toInt(),
                      AppColors.appAlertMed())
                  : Container(),
              (jsDTO.lowTotal != null && jsDTO.lowTotal!.toInt() > 0)
                  ? infoItem(
                      'Low', jsDTO.lowTotal!.toInt(), AppColors.appAlertLow())
                  : Container(),
              (jsDTO.otherTotal != null && jsDTO.otherTotal!.toInt() > 0)
                  ? infoItem('Others', jsDTO.otherTotal!.toInt(),
                      AppColors.appPrimaryWhite())
                  : Container(),
            ],
          ),
        ],
      ),
    );
  }

  Widget infoItem(String status, int count, Color textColor) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            '$status:',
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
                  'AlrtAcrcyBySts',
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
                if (widget.alertAccuracyStatusList != null)
                  widget.alertAccuracyStatusList!.forEach((e) {
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
                    category = e.status;

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
