import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:keysight_pma/cache/appcache.dart';
import 'package:keysight_pma/const/appcolors.dart';
import 'package:keysight_pma/const/appfonts.dart';
import 'package:keysight_pma/const/constants.dart';
import 'package:keysight_pma/const/download.dart';
import 'package:keysight_pma/const/utils.dart';
import 'package:keysight_pma/dio/api/dqm.dart';
import 'package:keysight_pma/model/arguments/dqm_argument.dart';
import 'package:keysight_pma/model/customize.dart';
import 'package:keysight_pma/model/dqm/boardresult_summary_byproject.dart';
import 'package:keysight_pma/model/dqm/failure_component_by_fixture.dart';
import 'package:keysight_pma/model/dqm/test_time_distribution.dart';
import 'package:keysight_pma/model/dqm/worst_test_name.dart';
import 'package:keysight_pma/model/js/js.dart';
import 'package:keysight_pma/routes/approutes.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

class DqmTestResultDetailWorstTestNameScreen extends StatefulWidget {
  final int? fromWhere;
  final String? filterMode;
  final String? appBarTitle;
  final String? filterBy;
  DqmTestResultDetailWorstTestNameScreen(
      {Key? key,
      this.fromWhere,
      this.filterMode,
      this.appBarTitle,
      this.filterBy})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DqmTestResultDetailWorstTestNameScreen();
  }
}

class _DqmTestResultDetailWorstTestNameScreen
    extends State<DqmTestResultDetailWorstTestNameScreen> {
  late WebViewPlusController dqmWorstTestNameWebViewController;
  double chartHeight = 350.0;
  double chartWTNHeight = 350.0;
  bool isLoading = true;
  String appBarTitle = '';
  late BoardResultSummaryByProjectDataDTO boardResultDataDTO;
  late TestTimeDistributionDataDTO testTimeDistributionDataDTO;
  late DqmFailureComponentDTO failureComponentDTO;
  late WorstTestNameDTO worstTestNameDTO;
  late Map<String?, List<FinalDispositionStructDataDTO>> finalDispositionMap;
  late Map<String?, List<DqmFailureComponentDataDTO>> testTypeFailureMap;
  String filterBy = '';
  String filterMode = '';
  bool startShowInfo = false;
  bool? theme_dark = AppCache.sortFilterCacheDTO!.currentTheme;

  JSTestResultVolumeDataDTO jsTestResultVolumeDataDTO =
      JSTestResultVolumeDataDTO();
  late JSTestResultTestTimeDataDTO jsTestResultTestTimeDataDTO;
  List<CustomDqmSortFilterProjectsDTO> finalDispositionList = [];

  // Future<BoardResultSummaryByProjectDTO> getBoardResultSummaryListByProject(
  //     BuildContext context) {
  //   String companyId = AppCache.sortFilterCacheDTO!.preferredCompany!;
  //   String siteId = AppCache.sortFilterCacheDTO!.preferredSite!;
  //   String startDate = DateFormat("yyyy-MM-dd")
  //       .format(AppCache.sortFilterCacheDTO!.startDate!);
  //   String endDate =
  //       DateFormat("yyyy-MM-dd").format(AppCache.sortFilterCacheDTO!.endDate!);
  //   List<String?> equipments = AppCache.sortFilterCacheDTO!.defaultEquipments!
  //       .map((e) => e.equipmentId)
  //       .toList();
  //   String projectId = AppCache.sortFilterCacheDTO!.defaultProjectId!;
  //   DqmApi dqmApi = DqmApi(context);
  //   return dqmApi.getBoardResultSummaryListByProject(
  //       companyId, siteId, startDate, endDate, equipments, projectId);
  // }

  // Future<TestTimeDistributionDTO> getTestTimeDistribution(
  //     BuildContext context) {
  //   String companyId = AppCache.sortFilterCacheDTO!.preferredCompany!;
  //   String siteId = AppCache.sortFilterCacheDTO!.preferredSite!;
  //   String startDate = DateFormat("yyyy-MM-dd")
  //       .format(AppCache.sortFilterCacheDTO!.startDate!);
  //   String endDate =
  //       DateFormat("yyyy-MM-dd").format(AppCache.sortFilterCacheDTO!.endDate!);
  //   List<String?> equipments = AppCache.sortFilterCacheDTO!.defaultEquipments!
  //       .map((e) => e.equipmentId)
  //       .toList();
  //   String projectId = AppCache.sortFilterCacheDTO!.defaultProjectId!;
  //   DqmApi dqmApi = DqmApi(context);
  //   return dqmApi.getTestTimeDistribution(
  //       companyId, siteId, startDate, endDate, equipments, projectId);
  // }

  // Future<DqmFailureComponentDTO> getListComponentFailureByFixture(
  //     BuildContext context, String mode) {
  //   String companyId = AppCache.sortFilterCacheDTO!.preferredCompany!;
  //   String siteId = AppCache.sortFilterCacheDTO!.preferredSite!;
  //   String startDate = DateFormat("yyyy-MM-dd")
  //       .format(AppCache.sortFilterCacheDTO!.startDate!);
  //   String endDate =
  //       DateFormat("yyyy-MM-dd").format(AppCache.sortFilterCacheDTO!.endDate!);
  //   List<String?> equipments = AppCache.sortFilterCacheDTO!.defaultEquipments!
  //       .map((e) => e.equipmentId)
  //       .toList();
  //   String projectId = AppCache.sortFilterCacheDTO!.defaultProjectId!;
  //   DqmApi dqmApi = DqmApi(context);
  //   return dqmApi.getListComponentFailureByFixture(
  //       companyId, siteId, startDate, endDate, equipments, projectId, mode);
  // }

  Future<WorstTestNameDTO> getWorstTestNames(
      BuildContext context, String mode) {
    String companyId = AppCache.sortFilterCacheDTO!.preferredCompany!;
    String siteId = AppCache.sortFilterCacheDTO!.preferredSite!;
    String startDate = DateFormat("yyyy-MM-dd")
        .format(AppCache.sortFilterCacheDTO!.startDate!);
    String endDate =
        DateFormat("yyyy-MM-dd").format(AppCache.sortFilterCacheDTO!.endDate!);
    List<String?> equipments = AppCache.sortFilterCacheDTO!.defaultEquipments!
        .map((e) => e.equipmentId)
        .toList();
    String projectId = AppCache.sortFilterCacheDTO!.defaultProjectId!;
    DqmApi dqmApi = DqmApi(context);
    return dqmApi.getWorstTestNames(
        companyId, siteId, startDate, endDate, equipments, projectId, mode);
  }

  Future<WorstTestNameDTO> getPinRetestSummary(BuildContext context) {
    String companyId = AppCache.sortFilterCacheDTO!.preferredCompany!;
    String siteId = AppCache.sortFilterCacheDTO!.preferredSite!;
    String startDate = DateFormat("yyyy-MM-dd")
        .format(AppCache.sortFilterCacheDTO!.startDate!);
    String endDate =
        DateFormat("yyyy-MM-dd").format(AppCache.sortFilterCacheDTO!.endDate!);
    List<String?> equipments = AppCache.sortFilterCacheDTO!.defaultEquipments!
        .map((e) => e.equipmentId)
        .toList();
    String projectId = AppCache.sortFilterCacheDTO!.defaultProjectId!;
    DqmApi dqmApi = DqmApi(context);
    return dqmApi.getPinRetestSummary(
        companyId, siteId, startDate, endDate, equipments, projectId);
  }

  void groupByLastStatusData(List<FinalDispositionStructDataDTO> data) {
    final groups = groupBy(data, (FinalDispositionStructDataDTO e) {
      return e.lastStatus;
    });

    setState(() {
      this.finalDispositionMap = groups;
    });
  }

  void groupByFirstStatusData(List<FinalDispositionStructDataDTO> data) {
    final groups = groupBy(data, (FinalDispositionStructDataDTO e) {
      return e.firstStatus;
    });

    setState(() {
      groups.keys.forEach((element) {
        CustomDqmSortFilterProjectsDTO customSortDTO =
            CustomDqmSortFilterProjectsDTO(element, true);
        this.finalDispositionList.add(customSortDTO);
      });
    });
  }

  void groupDataByFixtureId(List<DqmFailureComponentDataDTO> data) {
    final groups = groupBy(data, (DqmFailureComponentDataDTO e) {
      return e.fixtureId;
    });

    setState(() {
      this.testTypeFailureMap = groups;
    });
  }

  String capitalizeWords(String words) {
    final capitalizedWords = words.split(" ").map((word) {
      if (word.trim().isNotEmpty) {
        final String firstLetter = word.trim().substring(0, 1).toUpperCase();
        final String remainingLetters = word.trim().substring(1);

        return '$firstLetter$remainingLetters';
      }
      return '';
    });

    return capitalizedWords.join(" ");
  }

  @override
  void initState() {
    super.initState();
    Utils.setFirebaseAnalyticsCurrentScreen(
        Constants.ANALYTICS_DQM_TEST_RESULT_WORST_TESTNAME_SCREEN);
    this.appBarTitle = widget.appBarTitle!;
    this.filterMode = widget.filterMode!;
    this.filterBy = widget.filterBy!;
    if (widget.filterBy == Constants.FILTER_BY_CHART_PIN_RETEST) {
      callGetPinRetestSummary(context);
    } else {
      callGetWorstTestNames(context);
    }
  }

  callGetWorstTestNames(BuildContext context) async {
    await getWorstTestNames(context, this.filterMode).then((value) {
      this.worstTestNameDTO = value;
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
        if (EasyLoading.isShow) {
          EasyLoading.dismiss();
          this.dqmWorstTestNameWebViewController.webViewController.reload();
        }
      });
    });
  }

  callGetPinRetestSummary(BuildContext context) async {
    await getPinRetestSummary(context).then((value) {
      this.worstTestNameDTO = value;
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
        if (EasyLoading.isShow) {
          EasyLoading.dismiss();
          this.dqmWorstTestNameWebViewController.webViewController.reload();
        }
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
        centerTitle: true,
        title: Padding(
          padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
          child: Text(
            appBarTitle,
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
          child: !this.isLoading
              ? Stack(
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          chartWorstTestNames(context),
                        ],
                      ),
                    ),
                    emptyData(context),
                    sortAndFilter(context),
                  ],
                )
              : Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppColors.appBlue()),
                  ),
                ),
        ),
      ),
    );
  }

  Widget sortAndFilter(BuildContext ctx) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: TextButton(
        onPressed: () async {
          final navigateResult = await Navigator.pushNamed(
            ctx,
            AppRoutes.dqmTestResultChartDetailFilterRoute,
            arguments: DqmTestResultArguments(
              filterBy: this.filterBy,
              fromWhere: widget.fromWhere,
              finalDispositionList: this.finalDispositionList,
              mode: this.filterMode,
            ),
          );

          if (navigateResult != null) {
            setState(() {
              DqmTestResultArguments arguments =
                  navigateResult as DqmTestResultArguments;
              if (Utils.isNotEmpty(arguments.filterBy)) {
                this.filterBy = arguments.filterBy!;
              }

              if (Utils.isNotEmpty(arguments.appBarTitle)) {
                this.appBarTitle =
                    Utils.getTranslated(ctx, arguments.appBarTitle!)!;
              }

              if (arguments.finalDispositionList != null &&
                  arguments.finalDispositionList!.length > 0) {
                this.finalDispositionList = arguments.finalDispositionList!;
              }

              if (widget.fromWhere ==
                  Constants.TEST_RESULT_CHART_COMPONENT_FAILURE) {
                this.filterMode = arguments.mode!;
                if (arguments.filterBy ==
                        Constants.FILTER_BY_CHART_WORST_TESTNAME_FAIL ||
                    arguments.filterBy ==
                        Constants.FILTER_BY_CHART_WORST_TESTNAME_FIRST_FAIL ||
                    arguments.filterBy ==
                        Constants.FILTER_BY_CHART_WORST_TESTNAME_FALSE_FAIL) {
                  EasyLoading.show(maskType: EasyLoadingMaskType.black);
                  callGetWorstTestNames(context);
                } else if (arguments.filterBy ==
                    Constants.FILTER_BY_CHART_PIN_RETEST) {
                  EasyLoading.show(maskType: EasyLoadingMaskType.black);
                  callGetPinRetestSummary(context);
                } else {
                  Navigator.pushReplacementNamed(
                    ctx,
                    AppRoutes.dqmTestResultChartDetailRoute,
                    arguments: DqmTestResultArguments(
                      fromWhere: Constants.TEST_RESULT_CHART_COMPONENT_FAILURE,
                      appBarTitle: Utils.getTranslated(ctx,
                          'dqm_testresult_failure_count_by_test_type_fixture_id_f'),
                    ),
                  );
                }
              }
            });
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
              Image.asset(theme_dark!
                  ? Constants.ASSET_IMAGES + 'filter_icon.png'
                  : Constants.ASSET_IMAGES_LIGHT + 'filter_icon.png'),
              SizedBox(width: 10.0),
              Text(
                Utils.getTranslated(context, 'sort_and_filter')!,
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
    );
  }

  Widget chartWorstTestNames(BuildContext ctx) {
    return Container(
      width: MediaQuery.of(ctx).size.width,
      height: this.chartWTNHeight,
      color: Colors.transparent,
      child: WebViewPlus(
        backgroundColor: Colors.transparent,
        javascriptMode: JavascriptMode.unrestricted,
        initialUrl: theme_dark!
            ? 'assets/html/highstock_dark_theme.html'
            : 'assets/html/highstock_light_theme.html',
        zoomEnabled: false,
        gestureRecognizers: Set()
          ..add(Factory<VerticalDragGestureRecognizer>(
              () => VerticalDragGestureRecognizer()))
          ..add(
              Factory<ScaleGestureRecognizer>(() => ScaleGestureRecognizer())),
        onWebViewCreated: (controllerPlus) {
          this.dqmWorstTestNameWebViewController = controllerPlus;
        },
        onPageFinished: (url) {
          this.dqmWorstTestNameWebViewController.getHeight().then((value) {
            Utils.printInfo(value);
            setState(() {
              this.chartWTNHeight = value;
            });
          });
        },
        javascriptChannels: [
          JavascriptChannel(
              name: 'DQMChannel',
              onMessageReceived: (message) {
                if (this.worstTestNameDTO.data != null &&
                    this.worstTestNameDTO.data!.length > 0) {
                  this
                      .dqmWorstTestNameWebViewController
                      .webViewController
                      .runJavascript(
                          'fetchWorstTestNamesData(${jsonEncode(this.worstTestNameDTO)})');
                }
              }),
          JavascriptChannel(
              name: 'DQMWorstTestNamesClickChannel',
              onMessageReceived: (message) {
                print(message.message);
              }),
          JavascriptChannel(
              name: 'DQMExportImageChannel',
              onMessageReceived: (message) async {
                print(message.message);
                if (Utils.isNotEmpty(message.message)) {
                  String name = 'worstTestName.png';

                  final result = await ImageApi.generateImage(
                      message.message, 600, this.chartWTNHeight.round(), name);
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
                  String name = 'worstTestName.pdf';

                  final result = await PdfApi.generatePDF(
                      message.message, 600, this.chartWTNHeight.round(), name);
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

  Widget emptyData(BuildContext ctx) {
    if (this.worstTestNameDTO.data == null ||
        this.worstTestNameDTO.data!.length == 0) {
      return Container(
        height: 350,
        child: Center(
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

    return Container();
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
                Navigator.pop(popContext);
                this
                    .dqmWorstTestNameWebViewController
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
                Navigator.pop(popContext);

                String name = "worstTestName.csv";
                final result =
                    await CSVApi.generateCSV(worstTestNameDTO.data!, name);
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
                Navigator.pop(popContext);
                this
                    .dqmWorstTestNameWebViewController
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

  void showTestTypeTooltipsDialog(BuildContext context, List<dynamic> list) {
    showDialog(
      context: context,
      builder: (tooltipsDialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: chartTestTypeTooltipsInfo(context, list),
        );
      },
    );
  }

  Widget chartTestTypeTooltipsInfo(BuildContext ctx, List<dynamic> list) {
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
            capitalizeWords(
                JSFinalDistributionDataDTO.fromJson(list[0]).firstStatus!),
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
            children: list
                .map((e) =>
                    testTypeItem(ctx, JSFinalDistributionDataDTO.fromJson(e)))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget testTypeItem(BuildContext ctx, JSFinalDistributionDataDTO jsDTO) {
    return Container(
      margin: EdgeInsets.only(top: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${capitalizeWords(jsDTO.lastStatus!)}:',
            style: AppFonts.robotoRegular(
              16,
              color: HexColor(jsDTO.colorCode!.substring(0)),
              decoration: TextDecoration.none,
            ),
          ),
          SizedBox(width: 10.0),
          Text(
            '${jsDTO.count!.toInt()}',
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
}
