import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:keysight_pma/cache/appcache.dart';
import 'package:keysight_pma/const/appcolors.dart';
import 'package:keysight_pma/const/appfonts.dart';
import 'package:keysight_pma/const/constants.dart';
import 'package:keysight_pma/const/utils.dart';
import 'package:keysight_pma/dio/api/alert.dart';
import 'package:keysight_pma/dio/api/dqm.dart';
import 'package:keysight_pma/model/alert/alert_review_data.dart';
import 'package:keysight_pma/model/alert/alert_statistics.dart';
import 'package:keysight_pma/model/dqm/count.dart';
import 'package:keysight_pma/model/dqm/test_result_testname.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

class AlertReviewChangeLimitScreen extends StatefulWidget {
  final AlertListDataDTO? alertListDataDTO;
  final AlertStatisticsDataDTO? alertStatisticsDataDTO;
  AlertReviewChangeLimitScreen(
      {Key? key, this.alertListDataDTO, this.alertStatisticsDataDTO})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AlertReviewChangeLimitScreen();
  }
}

class _AlertReviewChangeLimitScreen
    extends State<AlertReviewChangeLimitScreen> {
  late TestResultTestNameDTO testResultChangeLimitDTO;
  bool isLoading = true;
  double chartHeight = 350.0;
  late WebViewPlusController dqmWebViewController;
  CompareCountDTO? compareCountDTO;
  bool? theme_dark = AppCache.sortFilterCacheDTO!.currentTheme;
  Future<TestResultTestNameDTO> getLimitChangeAlertByTestname(
      BuildContext context) {
    String companyId = '';
    String siteId = '';
    String equipmentId = '';
    String projectId = '';
    String timestamp = '';
    String testname = '';

    if (widget.alertListDataDTO != null) {
      companyId = widget.alertListDataDTO!.companyId!;
      siteId = widget.alertListDataDTO!.siteId!;
      equipmentId = widget.alertListDataDTO!.equipmentId!;
      projectId = widget.alertListDataDTO!.projectId!;
      timestamp = widget.alertListDataDTO!.timestamp!;
      testname = widget.alertListDataDTO!.testName!;
    } else {
      companyId = widget.alertStatisticsDataDTO!.companyId!;
      siteId = widget.alertStatisticsDataDTO!.siteId!;
      equipmentId = widget.alertStatisticsDataDTO!.equipmentId!;
      projectId = widget.alertStatisticsDataDTO!.projectId!;
      timestamp = widget.alertStatisticsDataDTO!.timestamp!;
      testname = widget.alertStatisticsDataDTO!.testName!;
    }
    AlertApi alertApi = AlertApi(context);
    return alertApi.getLimitChangeAlertByTestname(
        companyId, equipmentId, projectId, siteId, testname, timestamp);
  }

  Future<CompareCountDTO> getCompareCount(BuildContext context) {
    String companyId = '';
    String siteId = '';
    List<String> equipments = [];
    String projectId = '';
    String startDate = '';
    String endDate = '';
    String testname = '';

    if (widget.alertListDataDTO != null) {
      companyId = widget.alertListDataDTO!.companyId!;
      siteId = widget.alertListDataDTO!.siteId!;
      equipments.add(widget.alertListDataDTO!.equipmentId!);
      projectId = widget.alertListDataDTO!.projectId!;
      startDate = widget.alertListDataDTO!.startDate!;
      endDate = widget.alertListDataDTO!.endDate!;
      testname = widget.alertListDataDTO!.testName!;
    } else {
      companyId = widget.alertStatisticsDataDTO!.companyId!;
      siteId = widget.alertStatisticsDataDTO!.siteId!;
      equipments.add(widget.alertStatisticsDataDTO!.equipmentId!);
      projectId = widget.alertStatisticsDataDTO!.projectId!;
      startDate = widget.alertStatisticsDataDTO!.startDate!;
      endDate = widget.alertStatisticsDataDTO!.endDate!;
      testname = widget.alertStatisticsDataDTO!.testName!;
    }

    DqmApi dqmApi = DqmApi(context);
    return dqmApi.getCompareCount(
        companyId, siteId, projectId, startDate, endDate, testname, equipments);
  }

  @override
  void initState() {
    super.initState();
    Utils.setFirebaseAnalyticsCurrentScreen(
        Constants.ANALYTICS_ALERT_REVIEW_LIMIT_CHANGE_SCREEN);
    if (widget.alertListDataDTO != null ||
        widget.alertStatisticsDataDTO != null) {
      callGetAlertChangeLimit(context);
    }
  }

  callGetAlertChangeLimit(BuildContext context) async {
    await getLimitChangeAlertByTestname(context).then((value) {
      this.testResultChangeLimitDTO = value;
      callGetCompareCount(context);
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
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: theme_dark!
            ? AppColors.serverAppBar()
            : AppColorsLightMode.serverAppBar(),
        title: Text(
          Utils.getTranslated(context, "dqm_rma_test_result_appbar_title")!,
          style: AppFonts.robotoRegular(
            20,
            color: theme_dark!
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
            theme_dark!
                ? Constants.ASSET_IMAGES + 'back_bttn.png'
                : Constants.ASSET_IMAGES_LIGHT + 'back_bttn.png',
          ),
        ),
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
                    children: [
                      compareButton(context),
                      chart(context),
                    ],
                  ),
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
                  color: theme_dark!
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
              name: 'AlertChannel',
              onMessageReceived: (message) {
                this.dqmWebViewController.webViewController.runJavascript(
                    'fetchAlertReviewChangeLimitData(${jsonEncode(this.testResultChangeLimitDTO)},"${Utils.getTranslated(context, 'chart_legend_pass')}","${Utils.getTranslated(context, 'chart_legend_anomaly')}","${Utils.getTranslated(context, 'chart_legend_false_failure')}","${Utils.getTranslated(context, 'chart_legend_fail')}","${Utils.getTranslated(context, 'chart_legend_limit_change')}","${Utils.getTranslated(context, 'chart_legend_lower_limit')}","${Utils.getTranslated(context, 'chart_legend_upper_limit')}","${Utils.getTranslated(context, 'chart_footer_timestamp_measured')}")');
              }),
          JavascriptChannel(
              name: 'AlertClickChannel',
              onMessageReceived: (message) {
                print(message.message);
                if (Utils.isNotEmpty(message.message)) {}
              }),
        ].toSet(),
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
                  color: theme_dark!
                      ? AppColors.cupertinoBackground()
                      : AppColorsLightMode.cupertinoBackground()
                          .withOpacity(0.8),
                  child: CupertinoActionSheetAction(
                    onPressed: () {
                      Navigator.pop(popContext);
                    },
                    child: Text(
                      Utils.getTranslated(
                          context, 'compare_popup_compareby_equipment')!,
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
                )
              : Container(),
          this.compareCountDTO!.data!.numberOfFixtures!.toInt() > 1
              ? Container(
                  color: theme_dark!
                      ? AppColors.cupertinoBackground()
                      : AppColorsLightMode.cupertinoBackground()
                          .withOpacity(0.8),
                  child: CupertinoActionSheetAction(
                    onPressed: () {
                      Navigator.pop(popContext);
                    },
                    child: Text(
                      Utils.getTranslated(
                          context, 'compare_popup_compareby_fixture')!,
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
                )
              : Container(),
          (this.compareCountDTO!.data!.numberOfEquipments!.toInt() > 1 ||
                  this.compareCountDTO!.data!.numberOfFixtures!.toInt() > 1)
              ? Container(
                  color: theme_dark!
                      ? AppColors.cupertinoBackground()
                      : AppColorsLightMode.cupertinoBackground()
                          .withOpacity(0.8),
                  child: CupertinoActionSheetAction(
                    onPressed: () {
                      Navigator.pop(popContext);
                    },
                    child: Text(
                      Utils.getTranslated(context,
                          'compare_popup_compareby_equipment_fixture')!,
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
                )
              : Container(),
          this.compareCountDTO!.data!.numberOfPanels!.toInt() > 1
              ? Container(
                  color: theme_dark!
                      ? AppColors.cupertinoBackground()
                      : AppColorsLightMode.cupertinoBackground()
                          .withOpacity(0.8),
                  child: CupertinoActionSheetAction(
                    onPressed: () {
                      Navigator.pop(popContext);
                    },
                    child: Text(
                      Utils.getTranslated(
                          context, 'compare_popup_compareby_panel')!,
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
                )
              : Container(),
          this.compareCountDTO!.data!.numberOfPanels!.toInt() > 1
              ? Container(
                  color: theme_dark!
                      ? AppColors.cupertinoBackground()
                      : AppColorsLightMode.cupertinoBackground()
                          .withOpacity(0.8),
                  child: CupertinoActionSheetAction(
                    onPressed: () {
                      Navigator.pop(popContext);
                    },
                    child: Text(
                      Utils.getTranslated(
                          context, 'compare_popup_compareby_all_panel')!,
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
                )
              : Container(),
        ],
        cancelButton: Container(
          decoration: BoxDecoration(
              color: theme_dark!
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
