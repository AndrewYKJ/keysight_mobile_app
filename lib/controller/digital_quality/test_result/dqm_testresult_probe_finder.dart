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
import 'package:keysight_pma/dio/api/dqm.dart';
import 'package:keysight_pma/model/alert/alert_probe.dart';
import 'package:keysight_pma/model/arguments/alert_routeTitle.dart';
import 'package:keysight_pma/model/customize.dart';
import 'package:keysight_pma/model/dqm/custom.dart';
import 'package:keysight_pma/model/dqm/test_result_fixtures.dart';
import 'package:keysight_pma/routes/approutes.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

class DigitalQualityTestResultProbeFinderScreen extends StatefulWidget {
  DigitalQualityTestResultProbeFinderScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DigitalQualityTestResultProbeFinderScreen();
  }
}

class _DigitalQualityTestResultProbeFinderScreen
    extends State<DigitalQualityTestResultProbeFinderScreen> {
  bool isLoading = true;
  AlertProbeDTO? probeDTO;
  AlertProbeDataDTO? probeDataDTO = AlertProbeDataDTO();
  List<AlertFixtureMapDTO> fixtureMaps = [];
  List<AlertFixtureOutlineDataDTO> fixtureOutlineDTOs = [];
  List<CustomDqmSortFilterItemSelectionDTO> preferedViewList = [];
  List<List<dynamic>> heatmap = [];
  String modeType = '';
  List<CustomDqmSortFilterItemSelectionDTO> preferredFixturesIDList = [];
  double chartHeight = 500.0;
  late WebViewPlusController probeChartController;
  late Map<String?, List<AlertFixtureMapDTO>> preferedViewListMap;
  FixturesList? fixturesListDTO;
  List<DqmCustomDTO> filterType = [
    DqmCustomDTO(
        customDataName: 'Failure',
        customDataValue: 'analogFail',
        customDataIsSelected: true),
    DqmCustomDTO(
        customDataName: 'CPK',
        customDataValue: 'analogCPK',
        customDataIsSelected: false),
  ];
  List<DqmCustomDTO> fixturesList = [
    DqmCustomDTO(
        customDataName: 'All', customDataValue: '', customDataIsSelected: true),
  ];

  void groupPreferredPriority() {
    final groups =
        groupBy(this.probeDataDTO!.fixtureMaps!, (AlertFixtureMapDTO e) {
      return e.probeProperty;
    });

    setState(() {
      this.preferedViewListMap = groups;
      preferedViewList.clear();
      this.preferedViewListMap.keys.forEach((element) {
        CustomDqmSortFilterItemSelectionDTO itemDTO =
            CustomDqmSortFilterItemSelectionDTO(element, true);
        preferedViewList.add(itemDTO);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    Utils.setFirebaseAnalyticsCurrentScreen(
        Constants.ANALYTICS_DQM_TEST_RESULT_PROBE_HEATMAP_SCREEN);
    callAllData(context);
    setState(() {
      modeType = filterType
          .firstWhere((element) => element.customDataIsSelected!)
          .customDataValue!;
    });
  }

  Future<AlertProbeDTO> getProbe(
    BuildContext ctx,
  ) {
    DqmApi dqmApi = DqmApi(ctx);
    String companyId = AppCache.sortFilterCacheDTO!.preferredCompany!;
    //String equipmentId = openCaseData.data!.equipmentId!;
    String siteId = AppCache.sortFilterCacheDTO!.preferredSite!;
    String projectId = AppCache.sortFilterCacheDTO!.defaultProjectId!;
    String fromDate = DateFormat("yyyy-MM-dd")
        .format(AppCache.sortFilterCacheDTO!.startDate!);
    String toDate =
        DateFormat("yyyy-MM-dd").format(AppCache.sortFilterCacheDTO!.endDate!);
    String mode = filterType
        .firstWhere((element) => element.customDataIsSelected!)
        .customDataValue!;
    String testName = 'Analog';
    String fixtureId = fixturesList
        .firstWhere((element) => element.customDataIsSelected!)
        .customDataValue!;

    return dqmApi.getProbeHeatMap(companyId, siteId, fixtureId, fromDate, mode,
        projectId, testName, toDate);
  }

  Future<FixturesList> getFixturesList(
    BuildContext ctx,
  ) {
    DqmApi dqmApi = DqmApi(ctx);
    String companyId = AppCache.sortFilterCacheDTO!.preferredCompany!;
    //String equipmentId = openCaseData.data!.equipmentId!;
    String siteId = AppCache.sortFilterCacheDTO!.preferredSite!;
    String equipmentId = '';

    return dqmApi.getFixturesList(companyId, siteId, equipmentId);
  }

  callAllData(BuildContext context) async {
    await getProbe(context).then((value) {
      if (value.status!.statusCode == 200) {
        probeDTO = value;
        if (probeDTO!.data != null) {
          probeDataDTO = probeDTO!.data!;
          fixtureMaps = probeDataDTO!.fixtureMaps!;
          fixtureOutlineDTOs = probeDataDTO!.fixtureOutlineDTOs!;
          groupPreferredPriority();

          callFixtureList(context);
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
  }

  callFixtureList(BuildContext context) async {
    await getFixturesList(context).then((value) {
      if (value.status!.statusCode == 200) {
        fixturesListDTO = value;
        if (fixturesListDTO!.data != null) {
          fixturesList.clear();
          fixturesList = [
            DqmCustomDTO(
                customDataName: 'All',
                customDataValue: '',
                customDataIsSelected: true),
          ];
          fixturesListDTO!.data!.forEach((element) {
            DqmCustomDTO itemDTO = DqmCustomDTO(
                customDataName: element,
                customDataValue: element,
                customDataIsSelected: false);
            fixturesList.add(itemDTO);
          });
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

  callNewData(BuildContext context) async {
    await getProbe(context).then((value) {
      if (value.status!.statusCode == 200) {
        probeDTO = value;
        if (probeDTO!.data != null) {
          probeDataDTO = probeDTO!.data!;
          fixtureMaps = probeDataDTO!.fixtureMaps!;
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
    setState(() {
      isLoading = false;
    });
  }

  bool? theme_dark = AppCache.sortFilterCacheDTO!.currentTheme;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme_dark!
            ? AppColors.serverAppBar()
            : AppColorsLightMode.serverAppBar(),
        centerTitle: true,
        title: Padding(
          padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
          child: Text(
            Utils.getTranslated(
                context, 'dqm_testresult_probe_finder_appbar_title')!,
            style: AppFonts.robotoRegular(
              20,
              color: theme_dark!
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
            theme_dark!
                ? Constants.ASSET_IMAGES + 'back_bttn.png'
                : Constants.ASSET_IMAGES_LIGHT + 'back_bttn.png',
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
      body: SafeArea(
        child: Container(
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
              : Stack(
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          probeFinderLabelText(context),
                          Container(
                            height: this.chartHeight,
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
                                        ? 'assets/html/highchart_dark_theme.html'
                                        : 'assets/html/highchart_light_theme.html',
                                    zoomEnabled: true,
                                    gestureRecognizers: Set()
                                      ..add(Factory<
                                              VerticalDragGestureRecognizer>(
                                          () =>
                                              VerticalDragGestureRecognizer()))
                                      ..add(Factory<ScaleGestureRecognizer>(
                                          () => ScaleGestureRecognizer())),
                                    onWebViewCreated: (controllerPlus) {
                                      this.probeChartController =
                                          controllerPlus;
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
                                          name: 'DQMChannel',
                                          onMessageReceived: (message) {
                                            print(message.message);
                                            this
                                                .probeChartController
                                                .webViewController
                                                .runJavascript(
                                                    'probeFinder(${jsonEncode(this.fixtureMaps)},${jsonEncode(this.fixtureOutlineDTOs)},${jsonEncode(this.probeDataDTO!.fixtureMaps!)},${jsonEncode(this.modeType)})');
                                          }),
                                      JavascriptChannel(
                                          name: 'DQMProdeFinderChannel',
                                          onMessageReceived: (message) {
                                            print(message.message);
                                            AlertFixtureMapDTO probeNodeData =
                                                AlertFixtureMapDTO.fromJson(
                                                    jsonDecode(
                                                        message.message));
                                            //  print(' print(message.message);');
                                            Navigator.pushNamed(context,
                                                AppRoutes.probeNodeDetailScreen,
                                                arguments: AlertArguments(
                                                    probeNodeData:
                                                        probeNodeData,
                                                    companyId: AppCache
                                                        .sortFilterCacheDTO!
                                                        .preferredCompany,
                                                    siteId: AppCache
                                                        .sortFilterCacheDTO!
                                                        .preferredSite,
                                                    projectId: AppCache
                                                        .sortFilterCacheDTO!
                                                        .defaultProjectId!));
                                            //  print('message');
                                          }),
                                      JavascriptChannel(
                                          name: 'DQMExportImageChannel',
                                          onMessageReceived: (message) async {
                                            if (Utils.isNotEmpty(
                                                message.message)) {
                                              String name = 'probeHeatMap.png';
                                              String curDate =
                                                  '#${DateFormat('yyyy.MM.dd').format(DateTime.now())}@${DateFormat('HH.mm.ss').format(DateTime.now())}';

                                              name = Utils.getExportFilename(
                                                'PrbHtMp',
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
                                                      this.chartHeight.round(),
                                                      name);
                                              if (result != null &&
                                                  result == true) {
                                                setState(() {
                                                  var snackBar = SnackBar(
                                                    content: Text(
                                                      Utils.getTranslated(
                                                          context,
                                                          'done_download_as_image')!,
                                                      style: AppFonts
                                                          .robotoRegular(
                                                        16,
                                                        color: theme_dark!
                                                            ? AppColors
                                                                .appGrey()
                                                            : AppColors
                                                                .appGrey(),
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
                                              String name = 'probeHeatMap.pdf';
                                              String curDate =
                                                  '#${DateFormat('yyyy.MM.dd').format(DateTime.now())}@${DateFormat('HH.mm.ss').format(DateTime.now())}';

                                              name = Utils.getExportFilename(
                                                'PrbHtMp',
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
                                                  await PdfApi.generatePDF(
                                                      message.message,
                                                      600,
                                                      this.chartHeight.round(),
                                                      name);
                                              if (result != null &&
                                                  result == true) {
                                                setState(() {
                                                  var snackBar = SnackBar(
                                                    content: Text(
                                                      Utils.getTranslated(
                                                          context,
                                                          'done_download_as_pdf')!,
                                                      style: AppFonts
                                                          .robotoRegular(
                                                        16,
                                                        color: theme_dark!
                                                            ? AppColors
                                                                .appGrey()
                                                            : AppColors
                                                                .appGrey(),
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
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: TextButton(
                        onPressed: () async {
                          if (this.probeDTO!.data != null &&
                              this.probeDTO!.data!.fixtureMaps!.length > 0) {
                            final navResult = await Navigator.pushNamed(context,
                                AppRoutes.dqmTestResultProbeFinderFilterRoute,
                                arguments: AlertFilterArguments(
                                    filterType: this.filterType,
                                    fixtureList: this.fixturesList));

                            if (navResult != null && navResult as bool) {
                              setState(() {
                                // this.fixtureMaps = this
                                //     .probeDataDTO!
                                //     .fixtureMaps!
                                //     .where((e) => selectedPriority
                                //         .contains(e.probeProperty))
                                //     .toList();
                                isLoading = true;
                                callNewData(context);
                                modeType = filterType
                                    .firstWhere((element) =>
                                        element.customDataIsSelected!)
                                    .customDataValue!;

                                this
                                    .probeChartController
                                    .webViewController
                                    .reload();
                              });
                            }
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50.0),
                            color: AppColors.appTeal(),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                  Constants.ASSET_IMAGES + 'filter_icon.png'),
                              SizedBox(width: 10.0),
                              Text(
                                Utils.getTranslated(
                                    context, 'sort_and_filter')!,
                                style: AppFonts.robotoMedium(
                                  14,
                                  color: AppColors.appPrimaryWhite(),
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget probeFinderLabelText(BuildContext ctx) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          margin: EdgeInsets.only(top: 22.0),
          child: Text(
            modeType == 'analogFail'
                ? Utils.getTranslated(
                    ctx, 'dqm_testresult_probe_finder_label_title_Failure')!
                : Utils.getTranslated(
                    ctx, 'dqm_testresult_probe_finder_label_title_CPK')!,
            style: AppFonts.robotoRegular(
              16,
              color: theme_dark!
                  ? AppColors.appGrey2()
                  : AppColorsLightMode.appGrey(),
              decoration: TextDecoration.none,
            ),
          ),
        ),
        GestureDetector(
          onTap: () async {
            if (this.probeDTO!.data != null &&
                this.probeDTO!.data!.fixtureMaps!.length > 0) {
              final navResult = await Navigator.pushNamed(
                  context, AppRoutes.alertReviewDataFilterRoute,
                  arguments: AlertFilterArguments(
                      filterProbePropertyList: this.preferedViewList));

              if (navResult != null && navResult as bool) {
                List<String> selectedPriority = [];

                this.preferedViewList.forEach((element) {
                  if (element.isSelected!) {
                    selectedPriority.add(element.item!);
                  }
                });

                setState(() {
                  this.fixtureMaps = this
                      .probeDataDTO!
                      .fixtureMaps!
                      .where((e) => selectedPriority.contains(e.probeProperty))
                      .toList();
                  this.probeChartController.webViewController.reload();
                });
              }
            }
          },
          child: Container(
              margin: EdgeInsets.only(top: 22.0),
              child: Image.asset(theme_dark!
                  ? Constants.ASSET_IMAGES + 'filter_icon.png'
                  : Constants.ASSET_IMAGES_LIGHT + 'filter_icon.png')),
        ),
      ],
    );
  }

  void showDownloadPopup(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext popContext) => CupertinoActionSheet(
        actions: [
          Container(
            color: theme_dark!
                ? AppColors.cupertinoBackground()
                : AppColorsLightMode.cupertinoBackground().withOpacity(0.8),
            child: CupertinoActionSheetAction(
              onPressed: () {
                print('################ start');

                this
                    .probeChartController
                    .webViewController
                    .runJavascript('exportImage()');
                print('################ end');
                Navigator.pop(popContext);
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
                var object = [];
                String curDate =
                    '#${DateFormat('yyyy.MM.dd').format(DateTime.now())}@${DateFormat('HH.mm.ss').format(DateTime.now())}';
                name = Utils.getExportFilename(
                  'PrbHtMp',
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
                result = await CSVApi.generateCSV(object, name);
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
                Navigator.pop(popContext);
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
                Navigator.pop(popContext);
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
