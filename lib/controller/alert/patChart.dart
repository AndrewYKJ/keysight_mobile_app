import 'dart:convert';

import 'package:collection/collection.dart';
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
import 'package:keysight_pma/model/alert/alert_casehistory.dart';
import 'package:keysight_pma/model/alert/alert_pat_anomalies.dart';
import 'package:keysight_pma/model/alert/alert_probe.dart';
import 'package:keysight_pma/model/arguments/alert_routeTitle.dart';
import 'package:keysight_pma/model/arguments/dqm_argument.dart';
import 'package:keysight_pma/model/customize.dart';
import 'package:keysight_pma/model/dqm/test_result_fixtures.dart';
import 'package:keysight_pma/routes/approutes.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

import '../../cache/appcache.dart';

class PATCharts extends StatefulWidget {
  final PatRecommendDataDTO? selectedPatData;
  final AlertPatAnomaliesDataDTO? alertPatAnomaliesDataDTO;
  PATCharts({Key? key, this.selectedPatData, this.alertPatAnomaliesDataDTO})
      : super(key: key);

  @override
  State<PATCharts> createState() => _PATChartsState();
}

class _PATChartsState extends State<PATCharts> {
  bool isLoading = true;
  double chartHeight = 316.0;
  double probeChartHeight = 316.0;
  late WebViewPlusController patChartController;
  late WebViewPlusController probeWebViewController;
  TestResultFixtureDTO? chartData;
  AlertProbeDTO? alertProbeDTO;
  List<AlertFixtureMapDTO> fixtureMaps = [];
  List<AlertFixtureMapDTO> fixtureMapsAnomaly = [];
  List<CustomDqmSortFilterItemSelectionDTO> preferedPriorityList = [];
  List<AlertFixtureOutlineDataDTO> fixtureOutlineDTOs = [];
  late Map<String?, List<AlertFixtureMapDTO>> preferedPriorityListMap;
  bool? theme_dark = AppCache.sortFilterCacheDTO!.currentTheme;

  Future<TestResultFixtureDTO> getFixtures(BuildContext ctx) {
    AlertApi alertApi = AlertApi(ctx);
    String companyId = widget.selectedPatData!.companyId!;
    //String equipmentId = openCaseData.data!.equipmentId!;
    String fromDate = DateFormat("yyyy-MM-dd").format(
        DateTime.parse(widget.selectedPatData!.startTimestampRecommend!));
    String toDate = DateFormat("yyyy-MM-dd")
        .format(DateTime.parse(widget.selectedPatData!.endTimestampRecommend!));
    String projectId = widget.selectedPatData!.projectId!;
    String siteId = widget.selectedPatData!.siteId!;
    String testName = widget.selectedPatData!.testName!;

    return alertApi.getPatFixtures(
        companyId, siteId, fromDate, toDate, projectId, testName);
  }

  Future<TestResultFixtureDTO> getPatTestResult(BuildContext context) {
    String companyId = '';
    String siteId = '';
    String equipmentId = '';
    String fixtureId = '';
    String projectId = '';
    String testName = '';
    int timestamp = 0;

    if (widget.alertPatAnomaliesDataDTO != null) {
      companyId = widget.alertPatAnomaliesDataDTO!.companyId!;
      siteId = widget.alertPatAnomaliesDataDTO!.siteId!;
      equipmentId = widget.alertPatAnomaliesDataDTO!.equipmentId!;
      fixtureId = widget.alertPatAnomaliesDataDTO!.fixtureId!;
      projectId = widget.alertPatAnomaliesDataDTO!.projectId!;
      testName = widget.alertPatAnomaliesDataDTO!.testName!;
      timestamp = DateTime.parse(widget.alertPatAnomaliesDataDTO!.timestamp!)
          .millisecondsSinceEpoch;
    }

    AlertApi alertApi = AlertApi(context);
    return alertApi.getPatTestResult(companyId, siteId, equipmentId, fixtureId,
        projectId, timestamp, testName);
  }

  Future<AlertProbeDTO> getProbe(BuildContext context) {
    String companyId = '';
    String siteId = '';
    String equipmentId = '';
    String fixtureId = '';
    String projectId = '';
    int timestamp = 0;

    if (widget.alertPatAnomaliesDataDTO != null) {
      companyId = widget.alertPatAnomaliesDataDTO!.companyId!;
      siteId = widget.alertPatAnomaliesDataDTO!.siteId!;
      equipmentId = widget.alertPatAnomaliesDataDTO!.equipmentId!;
      fixtureId = widget.alertPatAnomaliesDataDTO!.fixtureId!;
      projectId = widget.alertPatAnomaliesDataDTO!.projectId!;
      timestamp = DateTime.parse(widget.alertPatAnomaliesDataDTO!.timestamp!)
          .millisecondsSinceEpoch;
    }

    AlertApi alertApi = AlertApi(context);
    return alertApi.getPatAnomaliesProbe(
        companyId, siteId, equipmentId, fixtureId, projectId, timestamp);
  }

  void groupPreferredPriority() {
    final groups =
        groupBy(this.alertProbeDTO!.data!.fixtureMaps!, (AlertFixtureMapDTO e) {
      return e.probeProperty;
    });

    setState(() {
      this.preferedPriorityListMap = groups;
      preferedPriorityList.clear();
      this.preferedPriorityListMap.keys.forEach((element) {
        CustomDqmSortFilterItemSelectionDTO itemDTO =
            CustomDqmSortFilterItemSelectionDTO(element, true);
        preferedPriorityList.add(itemDTO);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    Utils.setFirebaseAnalyticsCurrentScreen(
        Constants.ANALYTICS_ALERT_PAT_ANOMALIY_SCREEN);
    if (widget.alertPatAnomaliesDataDTO != null) {
      callGetPatTestResult(context);
    } else {
      callPatData(context);
    }
  }

  callPatData(BuildContext context) async {
    await getFixtures(context).then((value) {
      if (value.status!.statusCode == 200) {
        chartData = value;
        print(chartData!.data!);
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

  callGetPatTestResult(BuildContext context) async {
    await getPatTestResult(context).then((value) {
      if (value.status!.statusCode == 200) {
        this.chartData = value;
        callGetProbe(context);
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
    });
  }

  callGetProbe(BuildContext context) async {
    await getProbe(context).then((value) {
      if (value.status!.statusCode == 200) {
        this.alertProbeDTO = value;
        if (this.alertProbeDTO!.data != null) {
          fixtureMaps = this.alertProbeDTO!.data!.fixtureMaps!;
          fixtureMapsAnomaly = this.alertProbeDTO!.data!.fixtureMapsAnomaly!;
          fixtureOutlineDTOs = this.alertProbeDTO!.data!.fixtureOutlineDTOs!;
          groupPreferredPriority();
        }
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
        flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
              theme_dark!
                  ? AppColors.serverAppBar()
                  : AppColorsLightMode.serverAppBar(),
              theme_dark!
                  ? AppColors.serverAppBar()
                  : AppColorsLightMode.serverAppBar(),
            ]))),
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          Utils.getTranslated(context, 'PAT_DASHBOARD')!,
          style: AppFonts.robotoRegular(20,
              color: theme_dark!
                  ? AppColors.appGrey()
                  : AppColorsLightMode.appGrey(),
              decoration: TextDecoration.none),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Image.asset(
              theme_dark!
                  ? Constants.ASSET_IMAGES + 'back_bttn.png'
                  : Constants.ASSET_IMAGES_LIGHT + 'back_bttn.png',
            )),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.appBlue()),
              ),
            )
          : Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.only(top: 26, bottom: 26),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 15.0, left: 16, right: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              widget.selectedPatData != null
                                  ? Utils.isNotEmpty(
                                          widget.selectedPatData!.testName)
                                      ? Utils.getTranslated(context,
                                              'dqm_testresult_analog_detail_testresult')! +
                                          ': ${widget.selectedPatData!.testName}'
                                      : ''
                                  : widget.alertPatAnomaliesDataDTO != null
                                      ? Utils.isNotEmpty(widget
                                              .alertPatAnomaliesDataDTO!
                                              .testName!)
                                          ? '${Utils.getTranslated(context, 'dqm_testresult_analog_detail_testresult')}: ${widget.alertPatAnomaliesDataDTO!.testName!}'
                                          : ''
                                      : '',
                              style: AppFonts.robotoMedium(
                                15,
                                color: theme_dark!
                                    ? AppColors.appGreyD3()
                                    : AppColorsLightMode.appGrey(),
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ),
                          SizedBox(width: 10.0),
                          GestureDetector(
                            onTap: () {
                              showDownloadTsPopup(context);
                            },
                            child: Image.asset(theme_dark!
                                ? Constants.ASSET_IMAGES + 'download_bttn.png'
                                : Constants.ASSET_IMAGES_LIGHT +
                                    'download_bttn.png'),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: this.chartHeight,
                      margin: EdgeInsets.only(top: 30.0, left: 16, right: 16),
                      color: theme_dark!
                          ? AppColors.appBlackLight()
                          : AppColorsLightMode.appPrimaryBlack(),
                      child: this.chartData != null &&
                              this.chartData!.data != null &&
                              this.chartData!.data!.length > 0
                          ? WebViewPlus(
                              backgroundColor: Colors.transparent,
                              javascriptMode: JavascriptMode.unrestricted,
                              initialUrl: theme_dark!
                                  ? 'assets/html/highchart_dark_theme.html'
                                  : 'assets/html/highchart_light_theme.html',
                              zoomEnabled: false,
                              gestureRecognizers: Set()
                                ..add(Factory<VerticalDragGestureRecognizer>(
                                    () => VerticalDragGestureRecognizer()))
                                ..add(Factory<ScaleGestureRecognizer>(
                                    () => ScaleGestureRecognizer())),
                              onWebViewCreated: (controllerPlus) {
                                this.patChartController = controllerPlus;
                              },
                              onPageFinished: (url) {
                                this
                                    .patChartController
                                    .getHeight()
                                    .then((value) {
                                  setState(() {
                                    this.chartHeight = value;
                                  });
                                });
                              },
                              javascriptChannels: [
                                JavascriptChannel(
                                    name: 'DQMChannel',
                                    onMessageReceived: (message) {
                                      String lower = '';
                                      String upper = '';
                                      if (widget.selectedPatData != null) {
                                        lower = widget.selectedPatData!.pall!;
                                        upper = widget.selectedPatData!.paul!;
                                      } else if (widget
                                              .alertPatAnomaliesDataDTO !=
                                          null) {
                                        lower = widget.alertPatAnomaliesDataDTO!
                                            .patlowerLimit!;
                                        upper = widget.alertPatAnomaliesDataDTO!
                                            .patupperLimit!;
                                      }
                                      this
                                          .patChartController
                                          .webViewController
                                          .runJavascript(
                                              'fetchPATChartData(${jsonEncode(this.chartData)},${(lower)},${(upper)},"${Utils.getTranslated(context, 'chart_footer_timestamp_measured')}","${Utils.getTranslated(context, 'chart_legend_pass')}","${Utils.getTranslated(context, 'chart_legend_fail')}","${Utils.getTranslated(context, 'chart_legend_anomaly')}","${Utils.getTranslated(context, 'chart_legend_false_failure')}","${Utils.getTranslated(context, 'chart_legend_limit')}","${Utils.getTranslated(context, 'chart_legend_PAT')}")');
                                    }),
                                JavascriptChannel(
                                    name: 'DQMAnalogCpkTestResultChannel',
                                    onMessageReceived: (message) {
                                      print(message.message);
                                      TestResultFixtureDataDTO testNameDataDTO =
                                          TestResultFixtureDataDTO.fromJson(
                                              jsonDecode(message.message));
                                      Navigator.pushNamed(context,
                                          AppRoutes.dqmCpkDashboardRoute,
                                          arguments: DqmTestResultArguments(
                                              fixtureDataDTO: testNameDataDTO,
                                              fromWhere: Constants
                                                  .CPK_DASHBOARD_FROM_PAT_CHART));
                                      // Navigator.pushNamed(context,
                                      //     AppRoutes.dqmCpkDashboardRoute,
                                      //     arguments: DqmTestResultArguments(
                                      //         fixtureDataDTO: testNameDataDTO,
                                      //         projectId: widget
                                      //             .selectedPatData!.projectId!,
                                      //         startDate: widget.selectedPatData!
                                      //             .startTimestampRecommend,
                                      //         endDate: widget.selectedPatData!
                                      //             .endTimestampRecommend,
                                      //         fromWhere: 5));
                                    }),
                                JavascriptChannel(
                                    name: 'DQMExportImageChannel',
                                    onMessageReceived: (message) async {
                                      print(message.message);
                                      if (Utils.isNotEmpty(message.message)) {
                                        String curDate =
                                            '#${DateFormat('yyyy.MM.dd').format(DateTime.now())}@${DateFormat('HH.mm.ss').format(DateTime.now())}';

                                        String name = Utils.getExportFilename(
                                          'PATTstRst',
                                          companyId: AppCache
                                              .sortFilterCacheDTO!
                                              .preferredCompany,
                                          siteId: AppCache.sortFilterCacheDTO!
                                              .preferredSite,
                                          fromDate: DateFormat('yyyy-MM-dd')
                                              .format(AppCache
                                                  .sortFilterCacheDTO!
                                                  .startDate!),
                                          toDate: DateFormat('yyyy-MM-dd')
                                              .format(AppCache
                                                  .sortFilterCacheDTO!
                                                  .endDate!),
                                          currentDate: curDate,
                                          expType: '.png',
                                        );
                                        final result =
                                            await ImageApi.generateImage(
                                                message.message,
                                                600,
                                                500,
                                                name);
                                        if (result != null && result == true) {
                                          setState(() {
                                            // print('################## hihi');
                                            var snackBar = SnackBar(
                                              content: Text(
                                                Utils.getTranslated(context,
                                                    'done_download_as_image')!,
                                                style: AppFonts.robotoRegular(
                                                  16,
                                                  color: AppColors.appGrey(),
                                                  decoration:
                                                      TextDecoration.none,
                                                ),
                                              ),
                                              backgroundColor:
                                                  AppColors.appBlack0F(),
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
                                          'PATTstRst',
                                          companyId: AppCache
                                              .sortFilterCacheDTO!
                                              .preferredCompany,
                                          siteId: AppCache.sortFilterCacheDTO!
                                              .preferredSite,
                                          fromDate: DateFormat('yyyy-MM-dd')
                                              .format(AppCache
                                                  .sortFilterCacheDTO!
                                                  .startDate!),
                                          toDate: DateFormat('yyyy-MM-dd')
                                              .format(AppCache
                                                  .sortFilterCacheDTO!
                                                  .endDate!),
                                          currentDate: curDate,
                                          expType: '.pdf',
                                        );

                                        final result = await PdfApi.generatePDF(
                                            message.message, 600, 500, name);
                                        if (result != null && result == true) {
                                          setState(() {
                                            // print('################## hihi');
                                            var snackBar = SnackBar(
                                              content: Text(
                                                Utils.getTranslated(context,
                                                    'done_download_as_pdf')!,
                                                style: AppFonts.robotoRegular(
                                                  16,
                                                  color: AppColors.appGrey(),
                                                  decoration:
                                                      TextDecoration.none,
                                                ),
                                              ),
                                              backgroundColor:
                                                  AppColors.appBlack0F(),
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
                                Utils.getTranslated(
                                    context, 'no_data_available')!,
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
                    SizedBox(height: 16.0),
                    Container(
                      margin: EdgeInsets.only(top: 20, left: 16, right: 16),
                      child: probeFinderChart(context),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget probeFinderChart(BuildContext context) {
    if (widget.alertPatAnomaliesDataDTO != null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  Utils.getTranslated(context, 'alertProdeFinder')!,
                  style: AppFonts.robotoMedium(
                    16,
                    color: theme_dark!
                        ? AppColors.appGreyB1()
                        : AppColorsLightMode.appGrey77(),
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
              SizedBox(width: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () async {
                      if (this.alertProbeDTO != null &&
                          this.alertProbeDTO!.data != null &&
                          this.alertProbeDTO!.data!.fixtureMaps!.length > 0) {
                        final navResult = await Navigator.pushNamed(
                            context, AppRoutes.alertReviewDataFilterRoute,
                            arguments: AlertFilterArguments(
                                filterProbePropertyList:
                                    this.preferedPriorityList));

                        if (navResult != null && navResult as bool) {
                          List<String> selectedPriority = [];

                          this.preferedPriorityList.forEach((element) {
                            if (element.isSelected!) {
                              selectedPriority.add(element.item!);
                            }
                          });

                          setState(() {
                            this.fixtureMaps = this
                                .alertProbeDTO!
                                .data!
                                .fixtureMaps!
                                .where((e) =>
                                    selectedPriority.contains(e.probeProperty))
                                .toList();
                            this.fixtureMapsAnomaly = this
                                .alertProbeDTO!
                                .data!
                                .fixtureMapsAnomaly!
                                .where((e) =>
                                    selectedPriority.contains(e.probeProperty))
                                .toList();

                            this
                                .probeWebViewController
                                .webViewController
                                .reload();
                          });
                        }
                      }
                    },
                    child: Image.asset(theme_dark!
                        ? Constants.ASSET_IMAGES + 'filter_icon.png'
                        : Constants.ASSET_IMAGES_LIGHT + 'filter_icon.png'),
                  ),
                  SizedBox(width: 20.0),
                  GestureDetector(
                    onTap: () {
                      showDownloadPFPopup(context);
                    },
                    child: Image.asset(theme_dark!
                        ? Constants.ASSET_IMAGES + 'download_bttn.png'
                        : Constants.ASSET_IMAGES_LIGHT + 'download_bttn.png'),
                  )
                ],
              ),
            ],
          ),
          SizedBox(height: 16.0),
          Container(
            height: this.probeChartHeight,
            child: this.alertProbeDTO != null &&
                    this.alertProbeDTO!.data!.fixtureOutlineDTOs!.length > 0
                ? WebViewPlus(
                    backgroundColor: Colors.transparent,
                    javascriptMode: JavascriptMode.unrestricted,
                    initialUrl: theme_dark!
                        ? 'assets/html/alert_highchart_dark_theme.html'
                        : 'assets/html/alert_highchart_light_theme.html',
                    zoomEnabled: true,
                    gestureRecognizers: Set()
                      ..add(Factory<VerticalDragGestureRecognizer>(
                          () => VerticalDragGestureRecognizer()))
                      ..add(Factory<ScaleGestureRecognizer>(
                          () => ScaleGestureRecognizer())),
                    onWebViewCreated: (controllerPlus) {
                      this.probeWebViewController = controllerPlus;
                    },
                    onPageFinished: (url) {
                      this.probeWebViewController.getHeight().then((value) {
                        setState(() {
                          this.probeChartHeight = value;
                        });
                      });
                    },
                    javascriptChannels: [
                      JavascriptChannel(
                          name: 'AlertChannel',
                          onMessageReceived: (message) {
                            print(message.message);
                            this
                                .probeWebViewController
                                .webViewController
                                .runJavascript(
                                    'probeFinder(${jsonEncode(this.fixtureMaps)},${jsonEncode(this.fixtureMapsAnomaly)},${jsonEncode(this.alertProbeDTO!.data!.fixtureOutlineDTOs)},${jsonEncode(widget.alertPatAnomaliesDataDTO!.testName)},${jsonEncode(this.alertProbeDTO!.data!.fixtureMaps!)},"${Utils.getTranslated(context, 'chart_legend_probe')}","${Utils.getTranslated(context, 'chart_legend_anomalyprobe')}","${Utils.getTranslated(context, 'chart_legend_selectedprobe')}")');
                          }),
                      JavascriptChannel(
                          name: 'AlertProdeFinderChannel',
                          onMessageReceived: (message) {
                            print(message.message);
                            AlertFixtureMapDTO probeNodeData =
                                AlertFixtureMapDTO.fromJson(
                                    jsonDecode(message.message));
                            Navigator.pushNamed(
                                context, AppRoutes.probeNodeDetailScreen,
                                arguments: AlertArguments(
                                    probeNodeData: probeNodeData,
                                    companyId: widget
                                        .alertPatAnomaliesDataDTO!.companyId,
                                    siteId:
                                        widget.alertPatAnomaliesDataDTO!.siteId,
                                    projectId: widget
                                        .alertPatAnomaliesDataDTO!.projectId));
                          }),
                      JavascriptChannel(
                          name: 'DQMExportImageChannel',
                          onMessageReceived: (message) async {
                            print(message.message);
                            if (Utils.isNotEmpty(message.message)) {
                              String curDate =
                                  '#${DateFormat('yyyy.MM.dd').format(DateTime.now())}@${DateFormat('HH.mm.ss').format(DateTime.now())}';

                              String name = Utils.getExportFilename(
                                'PrbFndr',
                                companyId: AppCache
                                    .sortFilterCacheDTO!.preferredCompany,
                                siteId:
                                    AppCache.sortFilterCacheDTO!.preferredSite,
                                fromDate: DateFormat('yyyy-MM-dd').format(
                                    AppCache.sortFilterCacheDTO!.startDate!),
                                toDate: DateFormat('yyyy-MM-dd').format(
                                    AppCache.sortFilterCacheDTO!.endDate!),
                                currentDate: curDate,
                                expType: '.png',
                              );

                              final result = await ImageApi.generateImage(
                                  message.message, 600, 500, name);
                              if (result != null && result == true) {
                                setState(() {
                                  // print('################## hihi');
                                  var snackBar = SnackBar(
                                    content: Text(
                                      Utils.getTranslated(
                                          context, 'done_download_as_image')!,
                                      style: AppFonts.robotoRegular(
                                        16,
                                        color: AppColors.appGrey(),
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
                                'PrbFndr',
                                companyId: AppCache
                                    .sortFilterCacheDTO!.preferredCompany,
                                siteId:
                                    AppCache.sortFilterCacheDTO!.preferredSite,
                                fromDate: DateFormat('yyyy-MM-dd').format(
                                    AppCache.sortFilterCacheDTO!.startDate!),
                                toDate: DateFormat('yyyy-MM-dd').format(
                                    AppCache.sortFilterCacheDTO!.endDate!),
                                currentDate: curDate,
                                expType: '.pdf',
                              );

                              final result = await PdfApi.generatePDF(
                                  message.message, 600, 500, name);
                              if (result != null && result == true) {
                                setState(() {
                                  // print('################## hihi');
                                  var snackBar = SnackBar(
                                    content: Text(
                                      Utils.getTranslated(
                                          context, 'done_download_as_pdf')!,
                                      style: AppFonts.robotoRegular(
                                        16,
                                        color: AppColors.appGrey(),
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
                        color: AppColors.appGreyB1().withOpacity(0.4),
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
          ),
        ],
      );
    }
    return Container();
  }

  void showDownloadTsPopup(BuildContext context) {
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
                    .patChartController
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
                  'PATTstRst',
                  companyId: AppCache.sortFilterCacheDTO!.preferredCompany,
                  siteId: AppCache.sortFilterCacheDTO!.preferredSite,
                  fromDate: DateFormat('yyyy-MM-dd')
                      .format(AppCache.sortFilterCacheDTO!.startDate!),
                  toDate: DateFormat('yyyy-MM-dd')
                      .format(AppCache.sortFilterCacheDTO!.endDate!),
                  currentDate: curDate,
                  expType: '.csv',
                );
                final result =
                    await CSVApi.generateCSV(this.chartData!.data!, name);
                if (result) {
                  setState(() {
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
                    .patChartController
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

  void showDownloadPFPopup(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext downloadContext) => CupertinoActionSheet(
        actions: [
          Container(
            color: theme_dark!
                ? AppColors.cupertinoBackground().withOpacity(0.2)
                : AppColorsLightMode.cupertinoBackground(),
            child: CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(downloadContext);
                this
                    .probeWebViewController
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
                ? AppColors.cupertinoBackground().withOpacity(0.2)
                : AppColorsLightMode.cupertinoBackground(),
            child: CupertinoActionSheetAction(
              onPressed: () async {
                Navigator.pop(downloadContext);

                String curDate =
                    '#${DateFormat('yyyy.MM.dd').format(DateTime.now())}@${DateFormat('HH.mm.ss').format(DateTime.now())}';

                String name = Utils.getExportFilename(
                  'PrbFndr',
                  companyId: AppCache.sortFilterCacheDTO!.preferredCompany,
                  siteId: AppCache.sortFilterCacheDTO!.preferredSite,
                  fromDate: DateFormat('yyyy-MM-dd')
                      .format(AppCache.sortFilterCacheDTO!.startDate!),
                  toDate: DateFormat('yyyy-MM-dd')
                      .format(AppCache.sortFilterCacheDTO!.endDate!),
                  currentDate: curDate,
                  expType: '.csv',
                );

                final result = await CSVApi.generateCSV(
                    this.alertProbeDTO!.data!.fixtureMapsAnomaly!, name);
                if (result == true) {
                  setState(() {
                    // print('################## hihi');
                    var snackBar = SnackBar(
                      content: Text(
                        Utils.getTranslated(context, 'done_download_as_csv')!,
                        style: AppFonts.robotoRegular(
                          16,
                          color: AppColors.appGrey(),
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
                ? AppColors.cupertinoBackground().withOpacity(0.2)
                : AppColorsLightMode.cupertinoBackground(),
            child: CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(downloadContext);
                this
                    .probeWebViewController
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
                ? AppColors.appBlack28()
                : AppColorsLightMode.cupertinoBackground(),
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
                    ? AppColors.appPrimaryWhite()
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
