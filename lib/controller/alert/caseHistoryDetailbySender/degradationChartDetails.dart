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
import 'package:keysight_pma/model/alert/alert_probe.dart';
import 'package:keysight_pma/model/arguments/alert_routeTitle.dart';
import 'package:keysight_pma/model/arguments/dqm_argument.dart';
import 'package:keysight_pma/model/customize.dart';
import 'package:keysight_pma/model/dqm/test_result_fixtures.dart';
import 'package:keysight_pma/model/dqm/test_result_testname.dart';
import 'package:keysight_pma/routes/approutes.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

import '../../../cache/appcache.dart';

class DegradationAnomalyCharts extends StatefulWidget {
  final String timestamp;
  final String fixtureId;
  final String equipmentId;
  final String projectId;
  final String testName;
  final String companyId;
  final String siteId;

  DegradationAnomalyCharts(
      {Key? key,
      required this.timestamp,
      required this.companyId,
      required this.siteId,
      required this.fixtureId,
      required this.equipmentId,
      required this.testName,
      required this.projectId})
      : super(key: key);

  @override
  State<DegradationAnomalyCharts> createState() =>
      _DegradationAnomalyChartsState();
}

class _DegradationAnomalyChartsState extends State<DegradationAnomalyCharts> {
  bool isLoading = true;
  AlertProbeDTO? probeDTO;
  AlertProbeDataDTO? probeDataDTO = AlertProbeDataDTO();

  TestResultTestNameDTO? anomalyDTO;
  List<TestResultTestNameDataDTO> anomalyDataDTO = [];
  List<AlertFixtureMapDTO> fixtureMaps = [];
  List<AlertFixtureMapDTO> fixtureMapsAnomaly = [];
  bool? theme_dark = AppCache.sortFilterCacheDTO!.currentTheme;

  List<CustomDqmSortFilterItemSelectionDTO> preferedPriorityList = [];
  List<AlertFixtureOutlineDataDTO> fixtureOutlineDTOs = [];
  double chartHeight = 360.0;
  double chartHeightAnomaly = 360;
  late WebViewPlusController probeChartController;

  late WebViewPlusController testResultChartController;
  TestResultFixtureDTO chartData = TestResultFixtureDTO();

  late Map<String?, List<AlertFixtureMapDTO>> preferedPriorityListMap;

  @override
  void initState() {
    super.initState();
    Utils.setFirebaseAnalyticsCurrentScreen(
        Constants.ANALYTICS_ALERT_DEGRADATION_CHART_SCREEN);
    callAllData(context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void groupPreferredPriority() {
    final groups =
        groupBy(this.probeDataDTO!.fixtureMaps!, (AlertFixtureMapDTO e) {
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

  Future<AlertProbeDTO> getProbe(
    BuildContext ctx,
  ) {
    AlertApi alertApi = AlertApi(ctx);
    String companyId = widget.companyId;
    //String equipmentId = openCaseData.data!.equipmentId!;
    String siteId = widget.siteId;
    String equipmentId = widget.equipmentId;
    String fixtureId = widget.fixtureId;
    String projectId = widget.projectId;
    String timestamp =
        DateTime.parse(widget.timestamp).millisecondsSinceEpoch.toString();

    return alertApi.getProbe(
        companyId, siteId, equipmentId, fixtureId, projectId, timestamp);
  }

  Future<TestResultTestNameDTO> getTestResultAnomaly(
    BuildContext ctx,
  ) {
    AlertApi alertApi = AlertApi(ctx);
    String companyId = widget.companyId;
    //String equipmentId = openCaseData.data!.equipmentId!;
    String siteId = widget.siteId;
    String equipmentId = widget.equipmentId;
    String fixtureId = widget.fixtureId;
    String projectId = widget.projectId;
    String timestamp =
        DateTime.parse(widget.timestamp).millisecondsSinceEpoch.toString();
    String testName = widget.testName;

    return alertApi.getTestResultAnomaly(companyId, siteId, equipmentId,
        fixtureId, projectId, timestamp, testName);
  }

  callAllData(BuildContext context) async {
    await getProbe(context).then((value) {
      if (value.status!.statusCode == 200) {
        probeDTO = value;
        if (probeDTO!.data != null) {
          probeDataDTO = probeDTO!.data!;
          fixtureMaps = probeDataDTO!.fixtureMaps!;
          fixtureMapsAnomaly = probeDataDTO!.fixtureMapsAnomaly!;
          fixtureOutlineDTOs = probeDataDTO!.fixtureOutlineDTOs!;
          groupPreferredPriority();
        }
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
    }).whenComplete(() {});
    await getTestResultAnomaly(context).then((value) {
      if (value.status!.statusCode == 200) {
        anomalyDTO = value;
        if (anomalyDTO!.data != null) {
          anomalyDataDTO = anomalyDTO!.data!;
        }
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
    }).whenComplete(() {});

    setState(() {
      this.isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // print(widget.selectedPatData.paul);
    // print(widget.selectedPatData.pall);
    // print(widget.selectedPatData.testName);
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
          "Degradation Charts",
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
              padding: EdgeInsets.only(top: 26),
              color: theme_dark!
                  ? AppColors.appPrimaryBlack()
                  : AppColorsLightMode.appPrimaryBlack(),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    //#%#(*%*&%*#@)%*@#&%)@&%#&%*&@#%)&*#@%#@&(&)#&))
                    //#%#(*%*&%*#@)%*@#&%)@&%#&%*&@#%)&*#@%#@&(&)#&))
                    Container(
                      margin: EdgeInsets.only(top: 15.0, left: 16, right: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            Utils.getTranslated(context, 'dqm_tab_testresult')!,
                            style: AppFonts.robotoMedium(
                              15,
                              color: AppColors.appGreyD3(),
                              decoration: TextDecoration.none,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => showDownloadPopup(context, 111),
                            child: Image.asset(
                                Constants.ASSET_IMAGES + 'download_bttn.png'),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: this.chartHeightAnomaly,
                      child: this.anomalyDTO != null &&
                              this.anomalyDTO!.data!.length > 0
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
                                this.testResultChartController = controllerPlus;
                              },
                              onPageFinished: (url) {
                                this
                                    .testResultChartController
                                    .getHeight()
                                    .then((value) {
                                  setState(() {
                                    this.chartHeightAnomaly = value;
                                  });
                                });
                              },
                              javascriptChannels: [
                                JavascriptChannel(
                                    name: 'AlertChannel',
                                    onMessageReceived: (message) {
                                      print(message.message);
                                      this
                                          .testResultChartController
                                          .webViewController
                                          .runJavascript(
                                              'fetchRmaScatterData(${jsonEncode(this.anomalyDTO)}, "", "${Utils.getTranslated(context, 'chart_footer_timestamp_measured')}", "${Utils.getTranslated(context, 'chart_legend_pass')}", "${Utils.getTranslated(context, 'chart_legend_fail')}", "${Utils.getTranslated(context, 'chart_legend_anomaly')}", "${Utils.getTranslated(context, 'chart_legend_false_failure')}", "${Utils.getTranslated(context, 'chart_legend_threshold')}", "${Utils.getTranslated(context, 'chart_legend_lower_limit')}", "${Utils.getTranslated(context, 'chart_legend_upper_limit')}")');
                                    }),
                                JavascriptChannel(
                                    name: 'AlertTestResultChannel',
                                    onMessageReceived: (message) {
                                      if (Utils.isNotEmpty(message.message)) {
                                        print(message.message);
                                        TestResultTestNameDataDTO
                                            testNameDataDTO =
                                            TestResultTestNameDataDTO.fromJson(
                                                jsonDecode(message.message));
                                        //   print('asdsadsdas');
                                        Navigator.pushNamed(context,
                                            AppRoutes.dqmCpkDashboardRoute,
                                            arguments: DqmTestResultArguments(
                                                equipmentId: widget.equipmentId,
                                                projectId: widget.projectId,
                                                fixtureId: widget.fixtureId,
                                                startDate: testNameDataDTO
                                                    .timestamp
                                                    .toString(),
                                                endDate: testNameDataDTO
                                                    .timestamp
                                                    .toString(),
                                                fromWhere: 222,
                                                testNameDataDTO:
                                                    testNameDataDTO));
                                        print('asdsadsasdasdas');
                                      }
                                    }),
                                JavascriptChannel(
                                    name: 'DQMExportImageChannel',
                                    onMessageReceived: (message) async {
                                      print(message.message);
                                      if (Utils.isNotEmpty(message.message)) {
                                        String name = '';
                                        String curDate =
                                            '#${DateFormat('yyyy.MM.dd').format(DateTime.now())}@${DateFormat('HH.mm.ss').format(DateTime.now())}';

                                        name = Utils.getExportFilename(
                                          'AnmlyInfo',
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
                                                400,
                                                name);
                                        if (result != null && result == true) {
                                          setState(() {
                                            isLoading = false;
                                            // print('################## hihi');
                                            var snackBar = SnackBar(
                                              content: Text(
                                                Utils.getTranslated(context,
                                                    'done_download_as_image')!,
                                                style: AppFonts.robotoRegular(
                                                  16,
                                                  color: theme_dark!
                                                      ? AppColors.appGrey()
                                                      : AppColors.appGrey(),
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
                                        String name = '';
                                        String curDate =
                                            '#${DateFormat('yyyy.MM.dd').format(DateTime.now())}@${DateFormat('HH.mm.ss').format(DateTime.now())}';

                                        name = Utils.getExportFilename(
                                          'AnmlyInfo',
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
                                            message.message, 600, 400, name);
                                        if (result != null && result == true) {
                                          setState(() {
                                            isLoading = false;
                                            // print('################## hihi');
                                            var snackBar = SnackBar(
                                              content: Text(
                                                Utils.getTranslated(context,
                                                    'done_download_as_pdf')!,
                                                style: AppFonts.robotoRegular(
                                                  16,
                                                  color: theme_dark!
                                                      ? AppColors.appGrey()
                                                      : AppColors.appGrey(),
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
                    SizedBox(
                      height: 50,
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 15.0, left: 16, right: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            Utils.getTranslated(context, 'alertProdeFinder')!,
                            style: AppFonts.robotoMedium(
                              15,
                              color: AppColors.appGreyD3(),
                              decoration: TextDecoration.none,
                            ),
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  if (this.probeDTO!.data != null &&
                                      this.probeDTO!.data!.fixtureMaps!.length >
                                          0) {
                                    print(preferedPriorityList);
                                    final navResult = await Navigator.pushNamed(
                                        context,
                                        AppRoutes.alertReviewDataFilterRoute,
                                        arguments: AlertFilterArguments(
                                            filterProbePropertyList:
                                                this.preferedPriorityList));

                                    if (navResult != null &&
                                        navResult as bool) {
                                      List<String> selectedPriority = [];

                                      this
                                          .preferedPriorityList
                                          .forEach((element) {
                                        if (element.isSelected!) {
                                          selectedPriority.add(element.item!);
                                        }
                                      });

                                      setState(() {
                                        this.fixtureMaps = this
                                            .probeDataDTO!
                                            .fixtureMaps!
                                            .where((e) => selectedPriority
                                                .contains(e.probeProperty))
                                            .toList();
                                        this.fixtureMapsAnomaly = this
                                            .probeDataDTO!
                                            .fixtureMapsAnomaly!
                                            .where((e) => selectedPriority
                                                .contains(e.probeProperty))
                                            .toList();

                                        this
                                            .probeChartController
                                            .webViewController
                                            .reload();
                                      });
                                    }
                                  }
                                },
                                child: Image.asset(
                                    Constants.ASSET_IMAGES + 'filter_icon.png'),
                              ),
                              GestureDetector(
                                onTap: () => showDownloadPopup(context, 110),
                                child: Image.asset(theme_dark!
                                    ? Constants.ASSET_IMAGES +
                                        'download_bttn.png'
                                    : Constants.ASSET_IMAGES_LIGHT +
                                        'download_bttn.png'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    //#%#(*%*&%*#@)%*@#&%)@&%#&%*&@#%)&*#@%#@&(&)#&))
                    Container(
                      height: this.chartHeight,
                      child: this.probeDataDTO != null &&
                              this.probeDataDTO!.fixtureOutlineDTOs!.length > 0
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
                                this.probeChartController = controllerPlus;
                              },
                              onPageFinished: (url) {
                                this
                                    .probeChartController
                                    .getHeight()
                                    .then((value) {
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
                                      this
                                          .probeChartController
                                          .webViewController
                                          .runJavascript(
                                              'probeFinder(${jsonEncode(this.fixtureMaps)},${jsonEncode(this.fixtureMapsAnomaly)},${jsonEncode(this.fixtureOutlineDTOs)},${jsonEncode(widget.testName)},${jsonEncode(this.probeDataDTO!.fixtureMaps!)},"${Utils.getTranslated(context, 'chart_legend_probe')}","${Utils.getTranslated(context, 'chart_legend_anomalyprobe')}","${Utils.getTranslated(context, 'chart_legend_selectedprobe')}")');
                                    }),
                                JavascriptChannel(
                                    name: 'AlertProdeFinderChannel',
                                    onMessageReceived: (message) {
                                      print(message.message);
                                      AlertFixtureMapDTO probeNodeData =
                                          AlertFixtureMapDTO.fromJson(
                                              jsonDecode(message.message));
                                      print(' print(message.message);');
                                      Navigator.pushNamed(context,
                                          AppRoutes.probeNodeDetailScreen,
                                          arguments: AlertArguments(
                                              probeNodeData: probeNodeData,
                                              companyId: widget.companyId,
                                              siteId: widget.siteId,
                                              projectId: widget.projectId));
                                      print('message');
                                    }),
                                JavascriptChannel(
                                    name: 'DQMExportImageChannel',
                                    onMessageReceived: (message) async {
                                      print(message.message);
                                      if (Utils.isNotEmpty(message.message)) {
                                        String name = '';

                                        String curDate =
                                            '#${DateFormat('yyyy.MM.dd').format(DateTime.now())}@${DateFormat('HH.mm.ss').format(DateTime.now())}';

                                        name = Utils.getExportFilename(
                                          'PrbFndr',
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
                                                400,
                                                name);
                                        if (result != null && result == true) {
                                          setState(() {
                                            isLoading = false;
                                            // print('################## hihi');
                                            var snackBar = SnackBar(
                                              content: Text(
                                                Utils.getTranslated(context,
                                                    'done_download_as_image')!,
                                                style: AppFonts.robotoRegular(
                                                  16,
                                                  color: theme_dark!
                                                      ? AppColors.appGrey()
                                                      : AppColors.appGrey(),
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
                                        String name = '';
                                        String curDate =
                                            '#${DateFormat('yyyy.MM.dd').format(DateTime.now())}@${DateFormat('HH.mm.ss').format(DateTime.now())}';

                                        name = Utils.getExportFilename(
                                          'PrbFndr',
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
                                            message.message, 600, 400, name);
                                        if (result != null && result == true) {
                                          setState(() {
                                            isLoading = false;
                                            // print('################## hihi');
                                            var snackBar = SnackBar(
                                              content: Text(
                                                Utils.getTranslated(context,
                                                    'done_download_as_pdf')!,
                                                style: AppFonts.robotoRegular(
                                                  16,
                                                  color: theme_dark!
                                                      ? AppColors.appGrey()
                                                      : AppColors.appGrey(),
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
                    SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  void showDownloadPopup(BuildContext context, int? type) {
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
                print('################ image');

                type != 111
                    ? this
                        .probeChartController
                        .webViewController
                        .runJavascript('exportImage()')
                    : this
                        .testResultChartController
                        .webViewController
                        .runJavascript('exportImage()');
                print('################ end');
                Navigator.pop(downloadContext);
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
                final bool result;
                String name = '';
                String curDate =
                    '#${DateFormat('yyyy.MM.dd').format(DateTime.now())}@${DateFormat('HH.mm.ss').format(DateTime.now())}';

                if (type != 111) {
                  name = Utils.getExportFilename(
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
                  result =
                      await CSVApi.generateCSV(this.fixtureMapsAnomaly, name);
                } else if (type == 111) {
                  name = Utils.getExportFilename(
                    'AnmlyInfo',
                    companyId: AppCache.sortFilterCacheDTO!.preferredCompany,
                    siteId: AppCache.sortFilterCacheDTO!.preferredSite,
                    fromDate: DateFormat('yyyy-MM-dd')
                        .format(AppCache.sortFilterCacheDTO!.startDate!),
                    toDate: DateFormat('yyyy-MM-dd')
                        .format(AppCache.sortFilterCacheDTO!.endDate!),
                    currentDate: curDate,
                    expType: '.csv',
                  );
                  result = await CSVApi.generateCSV(anomalyDTO!.data!, name);
                } else {
                  result = false;
                }

                Navigator.pop(downloadContext);
                if (result != null && result == true) {
                  setState(() {
                    isLoading = false;
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
                print('################ image');

                type != 111
                    ? this
                        .probeChartController
                        .webViewController
                        .runJavascript('exportPDF()')
                    : this
                        .testResultChartController
                        .webViewController
                        .runJavascript('exportPDF()');
                print('################ end');
                Navigator.pop(downloadContext);
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
          )
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
