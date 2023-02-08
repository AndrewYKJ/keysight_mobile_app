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
import 'package:keysight_pma/model/dqm/test_result_cpk.dart';
import 'package:keysight_pma/model/dqm/test_result_cpk_analog.dart';
import 'package:keysight_pma/model/dqm/test_result_fixtures.dart';
import 'package:keysight_pma/model/js/js.dart';
import 'package:keysight_pma/routes/approutes.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

class DqmTestResultInfoScreen extends StatefulWidget {
  final String? testName;
  final String? testType;
  final String? projectId;
  DqmTestResultInfoScreen(
      {Key? key, this.testName, this.testType, this.projectId})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DqmTestResultInfoScreen();
  }
}

class _DqmTestResultInfoScreen extends State<DqmTestResultInfoScreen> {
  TestResultFixtureDTO? testResultFixtureDTO;
  TestResultCpkDTO? cpkDTO;
  TestResultCpkAnalogDTO? cpkAnalogDTO;
  bool isLoading = true;
  late WebViewPlusController dqmFixtureWebViewController;
  late WebViewPlusController dqmCpkWebViewController;
  double chartFixtureHeight = 316.0;
  double chartCpkHeight = 316.0;
  bool? isDarkTheme = AppCache.sortFilterCacheDTO!.currentTheme;

  Future<TestResultFixtureDTO> getFixtures(BuildContext context) {
    String companyId = AppCache.sortFilterCacheDTO!.preferredCompany!;
    String siteId = AppCache.sortFilterCacheDTO!.preferredSite!;
    String startDate = DateFormat("yyyy-MM-dd")
        .format(AppCache.sortFilterCacheDTO!.startDate!);
    String endDate =
        DateFormat("yyyy-MM-dd").format(AppCache.sortFilterCacheDTO!.endDate!);
    String projectId = Utils.isNotEmpty(widget.projectId)
        ? widget.projectId!
        : AppCache.sortFilterCacheDTO!.defaultProjectId!;
    DqmApi dqmApi = DqmApi(context);
    return dqmApi.getFixtures(companyId, siteId, startDate, endDate, [],
        projectId, widget.testName!, widget.testType!);
  }

  Future<TestResultCpkDTO> getCpk(BuildContext context) {
    String companyId = AppCache.sortFilterCacheDTO!.preferredCompany!;
    String siteId = AppCache.sortFilterCacheDTO!.preferredSite!;
    String startDate = DateFormat("yyyy-MM-dd")
        .format(AppCache.sortFilterCacheDTO!.startDate!);
    String endDate =
        DateFormat("yyyy-MM-dd").format(AppCache.sortFilterCacheDTO!.endDate!);

    String projectId = Utils.isNotEmpty(widget.projectId)
        ? widget.projectId!
        : AppCache.sortFilterCacheDTO!.defaultProjectId!;
    DqmApi dqmApi = DqmApi(context);
    return dqmApi.getCpk(companyId, siteId, startDate, endDate, [], projectId,
        widget.testName!, widget.testType!);
  }

  Future<TestResultCpkAnalogDTO> getListAnalogCpk(BuildContext context) {
    String companyId = AppCache.sortFilterCacheDTO!.preferredCompany!;
    String siteId = AppCache.sortFilterCacheDTO!.preferredSite!;
    String startDate = DateFormat("yyyy-MM-dd")
        .format(AppCache.sortFilterCacheDTO!.startDate!);
    String endDate =
        DateFormat("yyyy-MM-dd").format(AppCache.sortFilterCacheDTO!.endDate!);
    String projectId = Utils.isNotEmpty(widget.projectId)
        ? widget.projectId!
        : AppCache.sortFilterCacheDTO!.defaultProjectId!;
    DqmApi dqmApi = DqmApi(context);
    return dqmApi.getListAnalogCpk(companyId, siteId, startDate, endDate, [],
        projectId, widget.testName!, widget.testType!);
  }

  @override
  void initState() {
    super.initState();
    Utils.setFirebaseAnalyticsCurrentScreen(
        Constants.ANALYTICS_DQM_TEST_RESULT_INFO_SCREEN);
    callGetFixtures(context);
  }

  callGetFixtures(BuildContext context) async {
    await getFixtures(context).then((value) {
      if (value.status!.statusCode == 200) {
        this.testResultFixtureDTO = value;
        callGetCpk(context);
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
    });
  }

  callGetCpk(BuildContext context) async {
    await getCpk(context).then((value) {
      if (value.status!.statusCode == 200) {
        this.cpkDTO = value;
        callGetListAnalogCpk(context);
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
    });
  }

  callGetListAnalogCpk(BuildContext context) async {
    await getListAnalogCpk(context).then((value) {
      if (value.status!.statusCode == 200) {
        this.cpkAnalogDTO = value;
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
        backgroundColor: isDarkTheme!
            ? AppColors.serverAppBar()
            : AppColorsLightMode.serverAppBar(),
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Padding(
          padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
          child: Text(
            Utils.getTranslated(
                context, 'dqm_testresult_analog_detail_testresult')!,
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
      ),
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 21.0),
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
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            header(context),
                            fixtures(context),
                            cpkInfo(context),
                            dailyCpk(context),
                          ],
                        ),
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
      width: MediaQuery.of(ctx).size.width,
      margin: EdgeInsets.only(top: 28.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              Utils.getTranslated(ctx, 'dqm_testresult_for')! +
                  ' ${widget.testName}',
              style: AppFonts.robotoRegular(
                16,
                color: isDarkTheme!
                    ? AppColors.appGrey2()
                    : AppColorsLightMode.appGrey(),
                decoration: TextDecoration.none,
              ),
            ),
          ),
          SizedBox(width: 10.0),
          // InkWell(
          //   onTap: () {},
          //   child: Image.asset(isDarkTheme!
          //       ? Constants.ASSET_IMAGES + 'search_icon.png'
          //       : Constants.ASSET_IMAGES_LIGHT + 'search.png'),
          // ),
          // SizedBox(width: 24.0),
          (this.testResultFixtureDTO != null &&
                  this.testResultFixtureDTO!.data != null &&
                  this.testResultFixtureDTO!.data!.length > 0)
              ? InkWell(
                  onTap: () {
                    showDownloadPopup(context);
                  },
                  child: Image.asset(isDarkTheme!
                      ? Constants.ASSET_IMAGES + 'download_bttn.png'
                      : Constants.ASSET_IMAGES_LIGHT + 'download_bttn.png'),
                )
              : Container(),
        ],
      ),
    );
  }

  Widget fixtures(BuildContext ctx) {
    return Container(
      width: MediaQuery.of(ctx).size.width,
      height: this.chartFixtureHeight,
      color: Colors.transparent,
      child: (this.testResultFixtureDTO != null &&
              this.testResultFixtureDTO!.data != null &&
              this.testResultFixtureDTO!.data!.length > 0)
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
                this.dqmFixtureWebViewController = controllerPlus;
              },
              onPageFinished: (url) {
                this.dqmFixtureWebViewController.getHeight().then((value) {
                  setState(() {
                    this.chartFixtureHeight = value;
                  });
                });
              },
              javascriptChannels: [
                JavascriptChannel(
                    name: 'DQMChannel',
                    onMessageReceived: (message) {
                      this
                          .dqmFixtureWebViewController
                          .webViewController
                          .runJavascript(
                              'fetchTestResultByTestNameData(${jsonEncode(this.testResultFixtureDTO)}, "${widget.testType}", "${Utils.getTranslated(ctx, 'chart_footer_timestamp_measured')}", "${Utils.getTranslated(ctx, 'chart_legend_pass')}", "${Utils.getTranslated(ctx, 'chart_legend_fail')}", "${Utils.getTranslated(ctx, 'chart_legend_anomaly')}", "${Utils.getTranslated(ctx, 'chart_legend_false_failure')}", "${Utils.getTranslated(ctx, 'chart_legend_threshold')}", "${Utils.getTranslated(ctx, 'chart_legend_lower_limit')}", "${Utils.getTranslated(ctx, 'chart_legend_upper_limit')}")');
                    }),
                JavascriptChannel(
                    name: 'DQMAnalogCpkTestResultChannel',
                    onMessageReceived: (message) {
                      print(message.message);
                      TestResultFixtureDataDTO fixtureDataDTO =
                          TestResultFixtureDataDTO.fromJson(
                              jsonDecode(message.message));
                      Navigator.pushNamed(ctx, AppRoutes.dqmCpkDashboardRoute,
                          arguments: DqmTestResultArguments(
                            fixtureDataDTO: fixtureDataDTO,
                            fromWhere:
                                Constants.CPK_DASHBOARD_FROM_TESTRESULT_INFO,
                          ));
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

  Widget cpkInfo(BuildContext ctx) {
    return Container(
      margin: EdgeInsets.only(top: 30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(ctx).size.width,
            padding: EdgeInsets.fromLTRB(19.0, 7.0, 19.0, 7.0),
            decoration: BoxDecoration(
              color: AppColors.appGrey5C(),
              borderRadius: BorderRadius.circular(2.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    Utils.getTranslated(
                        ctx, 'dqm_testresult_analog_sortby_cpk')!,
                    style: AppFonts.robotoMedium(
                      13,
                      color: isDarkTheme!
                          ? AppColors.appGreyDE()
                          : AppColorsLightMode.appGrey(),
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
                Text(
                  this.cpkAnalogDTO != null &&
                          this.cpkAnalogDTO!.data != null &&
                          this.cpkAnalogDTO!.data!.length > 0
                      ? '${this.cpkAnalogDTO!.data![0].cpk!.toDouble()}'
                      : '-',
                  style: AppFonts.robotoMedium(
                    13,
                    color: isDarkTheme!
                        ? AppColors.appGreyDE()
                        : AppColorsLightMode.appGrey(),
                    decoration: TextDecoration.none,
                  ),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ),
          SizedBox(height: 10.0),
          Container(
            width: MediaQuery.of(ctx).size.width,
            padding: EdgeInsets.fromLTRB(19.0, 7.0, 19.0, 7.0),
            decoration: BoxDecoration(
              color: AppColors.appGrey5C(),
              borderRadius: BorderRadius.circular(2.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    Utils.getTranslated(
                        ctx, 'dqm_testresult_analog_sortby_nominal')!,
                    style: AppFonts.robotoMedium(
                      13,
                      color: isDarkTheme!
                          ? AppColors.appGreyDE()
                          : AppColorsLightMode.appGrey(),
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
                Text(
                  this.cpkAnalogDTO != null &&
                          this.cpkAnalogDTO!.data != null &&
                          this.cpkAnalogDTO!.data!.length > 0
                      ? '${this.cpkAnalogDTO!.data![0].nominal!.toDouble()}'
                      : '-',
                  style: AppFonts.robotoMedium(
                    13,
                    color: isDarkTheme!
                        ? AppColors.appGreyDE()
                        : AppColorsLightMode.appGrey(),
                    decoration: TextDecoration.none,
                  ),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ),
          SizedBox(height: 10.0),
          Container(
            width: MediaQuery.of(ctx).size.width,
            padding: EdgeInsets.fromLTRB(19.0, 7.0, 19.0, 7.0),
            decoration: BoxDecoration(
              color: AppColors.appGrey5C(),
              borderRadius: BorderRadius.circular(2.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    Utils.getTranslated(
                        ctx, 'dqm_testresult_analog_sortby_lower_limit')!,
                    style: AppFonts.robotoMedium(
                      13,
                      color: isDarkTheme!
                          ? AppColors.appGreyDE()
                          : AppColorsLightMode.appGrey(),
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
                Text(
                  this.cpkAnalogDTO != null &&
                          this.cpkAnalogDTO!.data != null &&
                          this.cpkAnalogDTO!.data!.length > 0
                      ? '${double.parse(this.cpkAnalogDTO!.data![0].lowerLimit!)}'
                      : '-',
                  style: AppFonts.robotoMedium(
                    13,
                    color: isDarkTheme!
                        ? AppColors.appGreyDE()
                        : AppColorsLightMode.appGrey(),
                    decoration: TextDecoration.none,
                  ),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ),
          SizedBox(height: 10.0),
          Container(
            width: MediaQuery.of(ctx).size.width,
            padding: EdgeInsets.fromLTRB(19.0, 7.0, 19.0, 7.0),
            decoration: BoxDecoration(
              color: AppColors.appGrey5C(),
              borderRadius: BorderRadius.circular(2.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    Utils.getTranslated(
                        ctx, 'dqm_testresult_analog_sortby_upper_limit')!,
                    style: AppFonts.robotoMedium(
                      13,
                      color: isDarkTheme!
                          ? AppColors.appGreyDE()
                          : AppColorsLightMode.appGrey(),
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
                Text(
                  this.cpkAnalogDTO != null &&
                          this.cpkAnalogDTO!.data != null &&
                          this.cpkAnalogDTO!.data!.length > 0
                      ? '${double.parse(this.cpkAnalogDTO!.data![0].upperLimit!)}'
                      : '-',
                  style: AppFonts.robotoMedium(
                    13,
                    color: isDarkTheme!
                        ? AppColors.appGreyDE()
                        : AppColorsLightMode.appGrey(),
                    decoration: TextDecoration.none,
                  ),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget dailyCpk(BuildContext ctx) {
    return Container(
      margin: EdgeInsets.only(top: 35.0),
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
                  Utils.getTranslated(ctx, 'alertDailyCPK')!,
                  style: AppFonts.robotoRegular(16,
                      color: isDarkTheme!
                          ? AppColors.appGrey2()
                          : AppColorsLightMode.appGrey(),
                      decoration: TextDecoration.none),
                ),
              ),
              InkWell(
                onTap: () {},
                child: Image.asset(isDarkTheme!
                    ? Constants.ASSET_IMAGES + 'download_bttn.png'
                    : Constants.ASSET_IMAGES_LIGHT + 'download_bttn.png'),
              ),
            ],
          ),
          Container(
            width: MediaQuery.of(ctx).size.width,
            height: this.chartCpkHeight,
            color: Colors.transparent,
            child: (this.cpkDTO != null &&
                    this.cpkDTO!.data != null &&
                    this.cpkDTO!.data!.length > 0)
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
                      this.dqmCpkWebViewController = controllerPlus;
                    },
                    onPageFinished: (url) {
                      this.dqmCpkWebViewController.getHeight().then((value) {
                        setState(() {
                          this.chartCpkHeight = value;
                        });
                      });
                    },
                    javascriptChannels: [
                      JavascriptChannel(
                          name: 'DQMChannel',
                          onMessageReceived: (message) {
                            this
                                .dqmCpkWebViewController
                                .webViewController
                                .runJavascript(
                                    'fetchDailyCpkDetailData(${jsonEncode(this.cpkDTO)}, "${DateFormat("yyyy-MM-dd").format(AppCache.sortFilterCacheDTO!.startDate!)}", "${DateFormat("yyyy-MM-dd").format(AppCache.sortFilterCacheDTO!.endDate!)}")');
                          }),
                      JavascriptChannel(
                          name: 'DQMCpkClickChannel',
                          onMessageReceived: (message) {
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
                              String name = 'testResultCPK.png';

                              final result = await ImageApi.generateImage(
                                  message.message,
                                  600,
                                  this.chartCpkHeight.round(),
                                  name);
                              if (result != null && result == true) {
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
                              String name = 'testResultCPK.pdf';

                              final result = await PdfApi.generatePDF(
                                  message.message,
                                  600,
                                  this.chartCpkHeight.round(),
                                  name);
                              if (result != null && result == true) {
                                setState(() {
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
          )
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
            color: isDarkTheme!
                ? AppColors.cupertinoBackground()
                : AppColorsLightMode.cupertinoBackground().withOpacity(0.8),
            child: CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(downloadContext);
                this
                    .dqmCpkWebViewController
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

                String name = "testResultCPK.csv";
                final result =
                    await CSVApi.generateCSV(this.cpkDTO!.data!, name);
                if (result != null && result == true) {
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
                    .dqmCpkWebViewController
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

  void showTooltipsDialog(BuildContext context, JSCpkDataDTO jsCpkDataDTO) {
    showDialog(
      context: context,
      builder: (tooltipsDialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: cpkTooltipsInfo(context, jsCpkDataDTO),
        );
      },
    );
  }

  Widget cpkTooltipsInfo(BuildContext ctx, JSCpkDataDTO jsCpkDataDTO) {
    return Container(
      padding: EdgeInsets.fromLTRB(14.0, 10.0, 14.0, 10.0),
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
            '${DateFormat("EEE, dd MMM, yyyy").format(DateTime.parse(jsCpkDataDTO.date!))}',
            style: AppFonts.robotoRegular(
              16,
              color: isDarkTheme!
                  ? AppColors.appGrey2()
                  : AppColorsLightMode.appGrey2(),
              decoration: TextDecoration.none,
            ),
          ),
          SizedBox(height: 17.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                Utils.getTranslated(
                    ctx, 'dqm_rma_cpk_dashboard_histogram_cpk')!,
                style: AppFonts.robotoMedium(
                  14,
                  color: HexColor('f4d745'),
                  decoration: TextDecoration.none,
                ),
              ),
              SizedBox(width: 10.0),
              Text(
                '${jsCpkDataDTO.cpkValue!.toStringAsFixed(4)}',
                style: AppFonts.robotoMedium(
                  14,
                  color: AppColors.appPrimaryWhite(),
                  decoration: TextDecoration.none,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
