import 'dart:convert';

import 'package:collection/collection.dart';
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
import 'package:keysight_pma/dio/api/alert.dart';
import 'package:keysight_pma/model/alert/alert_fixture_maintenance.dart';
import 'package:keysight_pma/model/alert/alert_probe.dart';
import 'package:keysight_pma/model/arguments/alert_routeTitle.dart';
import 'package:keysight_pma/model/arguments/dqm_argument.dart';
import 'package:keysight_pma/model/dqm/test_result_testname.dart';
import 'package:keysight_pma/routes/approutes.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

import '../../model/customize.dart';

class AnomalyDectectionChart extends StatefulWidget {
  final AlertFixtureMaintenanceDataDTO? fixtureMaintenanceDataDTO;
  final String? testName;
  const AnomalyDectectionChart(
      {Key? key, this.testName, this.fixtureMaintenanceDataDTO})
      : super(key: key);

  @override
  State<AnomalyDectectionChart> createState() => _AnomalyDectectionChartState();
}

class _AnomalyDectectionChartState extends State<AnomalyDectectionChart> {
  late TestResultTestNameDTO testResultAnomalyDTO;
  late AlertProbeDTO alertProbeDTO;
  AlertProbeDataDTO? probeDataDTO = AlertProbeDataDTO();
  bool isLoading = true;
  double tsChartHeight = 316.0;
  double probeChartHeight = 316.0;
  late WebViewPlusController tsWebViewController;
  late WebViewPlusController probeWebViewController;
  String startDate = '';
  String endDate = '';
  bool? theme_dark = AppCache.sortFilterCacheDTO!.currentTheme;

  List<AlertFixtureMapDTO> fixtureMaps = [];
  List<AlertFixtureMapDTO> fixtureMapsAnomaly = [];
  List<CustomDqmSortFilterItemSelectionDTO> preferedPriorityList = [];
  List<AlertFixtureOutlineDataDTO> fixtureOutlineDTOs = [];
  late Map<String?, List<AlertFixtureMapDTO>> preferedPriorityListMap;

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

  Future<TestResultTestNameDTO> getTestResultAnomaly(BuildContext context) {
    AlertApi alertApi = AlertApi(context);
    return alertApi.getTestResultAnomaly(
        widget.fixtureMaintenanceDataDTO!.companyId!,
        widget.fixtureMaintenanceDataDTO!.siteId!,
        widget.fixtureMaintenanceDataDTO!.equipmentId!,
        widget.fixtureMaintenanceDataDTO!.fixtureId!,
        widget.fixtureMaintenanceDataDTO!.projectId!,
        DateTime.parse(widget.fixtureMaintenanceDataDTO!.timestamp!)
            .millisecondsSinceEpoch
            .toString(),
        widget.fixtureMaintenanceDataDTO!.testName!);
  }

  Future<AlertProbeDTO> getProbe(BuildContext context) {
    AlertApi alertApi = AlertApi(context);
    return alertApi.getProbe(
        widget.fixtureMaintenanceDataDTO!.companyId!,
        widget.fixtureMaintenanceDataDTO!.siteId!,
        widget.fixtureMaintenanceDataDTO!.equipmentId!,
        widget.fixtureMaintenanceDataDTO!.fixtureId!,
        widget.fixtureMaintenanceDataDTO!.projectId!,
        DateTime.parse(widget.fixtureMaintenanceDataDTO!.timestamp!)
            .millisecondsSinceEpoch
            .toString());
  }

  void getStartEndDate() {
    if (this.testResultAnomalyDTO.data != null &&
        this.testResultAnomalyDTO.data!.length > 0) {
      this.testResultAnomalyDTO.data!.sort((a, b) {
        return DateTime.fromMillisecondsSinceEpoch(a.timestamp)
            .compareTo(DateTime.fromMillisecondsSinceEpoch(b.timestamp));
      });

      this.startDate = DateFormat("yyyy-MM-dd").format(
          DateTime.fromMillisecondsSinceEpoch(
              this.testResultAnomalyDTO.data![0].timestamp));
      this.endDate = DateFormat("yyyy-MM-dd").format(
          DateTime.fromMillisecondsSinceEpoch(this
              .testResultAnomalyDTO
              .data![this.testResultAnomalyDTO.data!.length - 1]
              .timestamp));
    }
  }

  @override
  void initState() {
    super.initState();
    Utils.setFirebaseAnalyticsCurrentScreen(
        Constants.ANALYTICS_ALERT_ANOMALY_DETECTION_SCREEN);
    callGetTestResultAnomaly(context);
  }

  callGetTestResultAnomaly(BuildContext context) async {
    await getTestResultAnomaly(context).then((value) {
      if (value.status!.statusCode == 200) {
        this.testResultAnomalyDTO = value;
        getStartEndDate();
        callGetProbe(context);
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
    });
  }

  callGetProbe(BuildContext context) async {
    await getProbe(context).then((value) {
      if (value.status!.statusCode == 200) {
        this.alertProbeDTO = value;
        if (alertProbeDTO.data != null) {
          probeDataDTO = alertProbeDTO.data!;
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
          Utils.getTranslated(context, 'alertAnnomalyDetection')!,
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
                    SizedBox(height: 23),
                    Container(
                      padding: EdgeInsets.only(left: 16, right: 26),
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      Utils.getTranslated(
                                          context, 'alert_testResult')!,
                                      style: AppFonts.robotoMedium(
                                        16,
                                        color: theme_dark!
                                            ? AppColors.appGreyB1()
                                            : AppColorsLightMode.appGrey77(),
                                        decoration: TextDecoration.none,
                                      ),
                                    ),
                                    Text(
                                      this.testResultAnomalyDTO.data != null &&
                                              this
                                                      .testResultAnomalyDTO
                                                      .data!
                                                      .length >
                                                  0
                                          ? '(${this.testResultAnomalyDTO.data![0].testType}, ${this.testResultAnomalyDTO.data![0].testUnit})'
                                          : '',
                                      style: AppFonts.robotoMedium(
                                        16,
                                        color: theme_dark!
                                            ? AppColors.appGreyB1()
                                            : AppColorsLightMode.appGrey77(),
                                        decoration: TextDecoration.none,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, AppRoutes.searchRoute);
                                      },
                                      child: Image.asset(
                                        Constants.ASSET_IMAGES +
                                            'search_icon.png',
                                      )),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      showDownloadPFPopup(context);
                                    },
                                    child: Image.asset(Constants.ASSET_IMAGES +
                                        'download_bttn.png'),
                                  )
                                ],
                              ),
                            ],
                          ),
                          testResultChart(context),
                        ],
                      ),
                    ),
                    SizedBox(height: 57),
                    Container(
                      padding: EdgeInsets.only(left: 16, right: 26),
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //Chart Title
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                Utils.getTranslated(
                                    context, 'alertProdeFinder')!,
                                style: AppFonts.robotoMedium(
                                  16,
                                  color: theme_dark!
                                      ? AppColors.appGreyB1()
                                      : AppColorsLightMode.appGrey77(),
                                  decoration: TextDecoration.none,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      if (this.alertProbeDTO.data != null &&
                                          this
                                                  .alertProbeDTO
                                                  .data!
                                                  .fixtureMaps!
                                                  .length >
                                              0) {
                                        print(preferedPriorityList);
                                        final navResult =
                                            await Navigator.pushNamed(
                                                context,
                                                AppRoutes
                                                    .alertReviewDataFilterRoute,
                                                arguments: AlertFilterArguments(
                                                    filterProbePropertyList: this
                                                        .preferedPriorityList));

                                        if (navResult != null &&
                                            navResult as bool) {
                                          List<String> selectedPriority = [];

                                          this
                                              .preferedPriorityList
                                              .forEach((element) {
                                            if (element.isSelected!) {
                                              selectedPriority
                                                  .add(element.item!);
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
                                                .probeWebViewController
                                                .webViewController
                                                .reload();
                                          });
                                        }
                                      }
                                    },
                                    child: Image.asset(Constants.ASSET_IMAGES +
                                        'filter_icon.png'),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      showDownloadTsPopup(context);
                                    },
                                    child: Image.asset(Constants.ASSET_IMAGES +
                                        'download_bttn.png'),
                                  )
                                ],
                              ),
                            ],
                          ),
                          //Chart here
                          Container(
                            height: this.probeChartHeight,
                            child: this.probeDataDTO != null &&
                                    this
                                            .probeDataDTO!
                                            .fixtureOutlineDTOs!
                                            .length >
                                        0
                                ? WebViewPlus(
                                    backgroundColor: Colors.transparent,
                                    javascriptMode: JavascriptMode.unrestricted,
                                    initialUrl: theme_dark!
                                        ? 'assets/html/alert_highchart_dark_theme.html'
                                        : 'assets/html/alert_highchart_light_theme.html',
                                    zoomEnabled: true,
                                    gestureRecognizers: Set()
                                      ..add(Factory<
                                              VerticalDragGestureRecognizer>(
                                          () =>
                                              VerticalDragGestureRecognizer()))
                                      ..add(Factory<ScaleGestureRecognizer>(
                                          () => ScaleGestureRecognizer())),
                                    onWebViewCreated: (controllerPlus) {
                                      this.probeWebViewController =
                                          controllerPlus;
                                    },
                                    onPageFinished: (url) {
                                      this
                                          .probeWebViewController
                                          .getHeight()
                                          .then((value) {
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
                                                    'probeFinder(${jsonEncode(this.fixtureMaps)},${jsonEncode(this.fixtureMapsAnomaly)},${jsonEncode(this.fixtureOutlineDTOs)},${jsonEncode(widget.testName)},${jsonEncode(this.probeDataDTO!.fixtureMaps!)},"${Utils.getTranslated(context, 'chart_legend_probe')}","${Utils.getTranslated(context, 'chart_legend_anomalyprobe')}","${Utils.getTranslated(context, 'chart_legend_selectedprobe')}")');
                                          }),
                                      JavascriptChannel(
                                          name: 'AlertProdeFinderChannel',
                                          onMessageReceived: (message) {
                                            print(message.message);
                                            AlertFixtureMapDTO probeNodeData =
                                                AlertFixtureMapDTO.fromJson(
                                                    jsonDecode(
                                                        message.message));
                                            print(' print(message.message);');
                                            Navigator.pushNamed(context,
                                                AppRoutes.probeNodeDetailScreen,
                                                arguments: AlertArguments(
                                                    probeNodeData:
                                                        probeNodeData,
                                                    companyId: widget
                                                        .fixtureMaintenanceDataDTO!
                                                        .companyId,
                                                    siteId: widget
                                                        .fixtureMaintenanceDataDTO!
                                                        .siteId,
                                                    projectId: widget
                                                        .fixtureMaintenanceDataDTO!
                                                        .projectId));

                                            print('message');
                                          }),
                                      JavascriptChannel(
                                          name: 'DQMExportImageChannel',
                                          onMessageReceived: (message) async {
                                            print(message.message);
                                            if (Utils.isNotEmpty(
                                                message.message)) {
                                              String name =
                                                  'anomalyProdeChart.png';
                                              String curDate =
                                                  '#${DateFormat('yyyy.MM.dd').format(DateTime.now())}@${DateFormat('HH.mm.ss').format(DateTime.now())}';
                                              name = Utils.getExportFilename(
                                                'PrbFndr',
                                                companyId: AppCache
                                                    .sortFilterCacheDTO!
                                                    .preferredCompany,
                                                siteId: AppCache
                                                    .sortFilterCacheDTO!
                                                    .preferredSite,
                                                fromDate:
                                                    DateFormat('yyyy-MM-dd')
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
                                              if (result != null &&
                                                  result == true) {
                                                setState(() {
                                                  // print('################## hihi');
                                                  var snackBar = SnackBar(
                                                    content: Text(
                                                      Utils.getTranslated(
                                                          context,
                                                          'done_download_as_image')!,
                                                      style: AppFonts
                                                          .robotoRegular(
                                                        16,
                                                        color:
                                                            AppColors.appGrey(),
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
                                            if (Utils.isNotEmpty(
                                                message.message)) {
                                              String name = '';

                                              String curDate =
                                                  '#${DateFormat('yyyy.MM.dd').format(DateTime.now())}@${DateFormat('HH.mm.ss').format(DateTime.now())}';
                                              name = Utils.getExportFilename(
                                                'PrbFndr',
                                                companyId: AppCache
                                                    .sortFilterCacheDTO!
                                                    .preferredCompany,
                                                siteId: AppCache
                                                    .sortFilterCacheDTO!
                                                    .preferredSite,
                                                fromDate:
                                                    DateFormat('yyyy-MM-dd')
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

                                              final result =
                                                  await PdfApi.generatePDF(
                                                      message.message,
                                                      600,
                                                      500,
                                                      name);
                                              if (result != null &&
                                                  result == true) {
                                                setState(() {
                                                  // print('################## hihi');
                                                  var snackBar = SnackBar(
                                                    content: Text(
                                                      Utils.getTranslated(
                                                          context,
                                                          'done_download_as_pdf')!,
                                                      style: AppFonts
                                                          .robotoRegular(
                                                        16,
                                                        color:
                                                            AppColors.appGrey(),
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
                  ],
                ),
              ),
      ),
    );
  }

  Widget testResultChart(BuildContext ctx) {
    return Container(
      width: MediaQuery.of(ctx).size.width,
      height: this.tsChartHeight,
      color: Colors.transparent,
      child: this.testResultAnomalyDTO.data != null &&
              this.testResultAnomalyDTO.data!.length > 0
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
                this.tsWebViewController = controllerPlus;
              },
              onPageFinished: (url) {
                this.tsWebViewController.getHeight().then((value) {
                  Utils.printInfo(value);
                  setState(() {
                    this.tsChartHeight = value;
                  });
                });
              },
              javascriptChannels: [
                JavascriptChannel(
                    name: 'AlertChannel',
                    onMessageReceived: (message) {
                      print(message.message);
                      this.tsWebViewController.webViewController.runJavascript(
                          'fetchTestResultByTestNameData(${jsonEncode(this.testResultAnomalyDTO)}, "${widget.fixtureMaintenanceDataDTO!.testType}", "${Utils.getTranslated(ctx, 'chart_footer_timestamp_measured')}", "${Utils.getTranslated(ctx, 'chart_legend_pass')}", "${Utils.getTranslated(ctx, 'chart_legend_fail')}", "${Utils.getTranslated(ctx, 'chart_legend_anomaly')}", "${Utils.getTranslated(ctx, 'chart_legend_false_failure')}", "${Utils.getTranslated(ctx, 'chart_legend_threshold')}", "${Utils.getTranslated(ctx, 'chart_legend_lower_limit')}", "${Utils.getTranslated(ctx, 'chart_legend_upper_limit')}")');
                    }),
                JavascriptChannel(
                    name: 'AlertClickChannel',
                    onMessageReceived: (message) {
                      if (Utils.isNotEmpty(message.message)) {
                        TestResultTestNameDataDTO testNameDataDTO =
                            TestResultTestNameDataDTO.fromJson(
                                jsonDecode(message.message));
                        Navigator.pushNamed(ctx, AppRoutes.dqmCpkDashboardRoute,
                            arguments: DqmTestResultArguments(
                                testNameDataDTO: testNameDataDTO,
                                projectId:
                                    widget.fixtureMaintenanceDataDTO!.projectId,
                                startDate: this.startDate,
                                endDate: this.endDate));
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
                          'TstRstTstNm',
                          companyId:
                              AppCache.sortFilterCacheDTO!.preferredCompany,
                          siteId: AppCache.sortFilterCacheDTO!.preferredSite,
                          fromDate: DateFormat('yyyy-MM-dd')
                              .format(AppCache.sortFilterCacheDTO!.startDate!),
                          toDate: DateFormat('yyyy-MM-dd')
                              .format(AppCache.sortFilterCacheDTO!.endDate!),
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
                        String name = '';

                        String curDate =
                            '#${DateFormat('yyyy.MM.dd').format(DateTime.now())}@${DateFormat('HH.mm.ss').format(DateTime.now())}';
                        name = Utils.getExportFilename(
                          'TstRstTstNm',
                          companyId:
                              AppCache.sortFilterCacheDTO!.preferredCompany,
                          siteId: AppCache.sortFilterCacheDTO!.preferredSite,
                          fromDate: DateFormat('yyyy-MM-dd')
                              .format(AppCache.sortFilterCacheDTO!.startDate!),
                          toDate: DateFormat('yyyy-MM-dd')
                              .format(AppCache.sortFilterCacheDTO!.endDate!),
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
    );
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
                    .tsWebViewController
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

                String name = '';

                String curDate =
                    '#${DateFormat('yyyy.MM.dd').format(DateTime.now())}@${DateFormat('HH.mm.ss').format(DateTime.now())}';
                name = Utils.getExportFilename(
                  'TstRstAnmly',
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
                    await CSVApi.generateCSV(testResultAnomalyDTO.data!, name);
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
                    .tsWebViewController
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
                ? AppColors.cupertinoBackground()
                : AppColorsLightMode.cupertinoBackground().withOpacity(0.8),
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
                ? AppColors.cupertinoBackground()
                : AppColorsLightMode.cupertinoBackground().withOpacity(0.8),
            child: CupertinoActionSheetAction(
              onPressed: () async {
                Navigator.pop(downloadContext);

                String name = '';
                var object = [];
                String curDate =
                    '#${DateFormat('yyyy.MM.dd').format(DateTime.now())}@${DateFormat('HH.mm.ss').format(DateTime.now())}';
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
                fixtureMaps.forEach((element) {
                  object.add({
                    "X": element.x,
                    "Y": element.y,
                    Utils.getTranslated(context, 'probe_finder_nodeName')!:
                        element.node,
                    Utils.getTranslated(context, 'csv_count')!: element.value
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
