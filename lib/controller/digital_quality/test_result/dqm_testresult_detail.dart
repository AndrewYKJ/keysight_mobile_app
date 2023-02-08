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

class DqmTestResultDetailScreen extends StatefulWidget {
  final int? fromWhere;
  final String? appbarTitle;
  final BoardResultSummaryByProjectDataDTO? boardResultDataDTO;
  final TestTimeDistributionDataDTO? testTimeDistributionDataDTO;
  final DqmFailureComponentDTO? failureComponentDTO;
  final WorstTestNameDTO? worstTestNameDTO;
  DqmTestResultDetailScreen(
      {Key? key,
      this.fromWhere,
      this.appbarTitle,
      this.boardResultDataDTO,
      this.testTimeDistributionDataDTO,
      this.failureComponentDTO,
      this.worstTestNameDTO})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DqmTestResultDetailScreen();
  }
}

class _DqmTestResultDetailScreen extends State<DqmTestResultDetailScreen> {
  late WebViewPlusController dqmWebViewController;
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
  bool? theme_dark = AppCache.sortFilterCacheDTO!.currentTheme;
  bool isChineseLng = false;

  String filterBy = '';
  String filterMode = '';
  bool startShowInfo = false;
  JSTestResultVolumeDataDTO jsTestResultVolumeDataDTO =
      JSTestResultVolumeDataDTO();
  late JSTestResultTestTimeDataDTO jsTestResultTestTimeDataDTO;
  List<CustomDqmSortFilterProjectsDTO> finalDispositionList = [];

  Future<BoardResultSummaryByProjectDTO> getBoardResultSummaryListByProject(
      BuildContext context) {
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
    return dqmApi.getBoardResultSummaryListByProject(
        companyId, siteId, startDate, endDate, equipments, projectId);
  }

  Future<TestTimeDistributionDTO> getTestTimeDistribution(
      BuildContext context) {
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
    return dqmApi.getTestTimeDistribution(
        companyId, siteId, startDate, endDate, equipments, projectId);
  }

  Future<DqmFailureComponentDTO> getListComponentFailureByFixture(
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
    return dqmApi.getListComponentFailureByFixture(
        companyId, siteId, startDate, endDate, equipments, projectId, mode);
  }

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
        Constants.ANALYTICS_DQM_TEST_RESULT_CHART_DETAIL_SCREEN);
    this.appBarTitle = widget.appbarTitle!;
    if (widget.fromWhere == Constants.TEST_RESULT_CHART_VOLUME) {
      this.filterBy = Constants.FILTER_BY_CHART_VOLUME_EQUIPMENT;
      callGetBoardResultSummaryListByProject(context);
    } else if (widget.fromWhere == Constants.TEST_RESULT_CHART_TEST_TIME) {
      this.filterBy = Constants.FILTER_BY_CHART_TEST_TIME_PASS;
      callGetTestTimeDistribution(context);
    } else if (widget.fromWhere ==
        Constants.TEST_RESULT_CHART_FINAL_DISPOSITION) {
      callGetBoardResultSummaryListByProject(context);
    } else if (widget.fromWhere ==
        Constants.TEST_RESULT_CHART_COMPONENT_FAILURE) {
      this.filterBy = Constants.FILTER_BY_CHART_TEST_TYPE_FAIL;
      this.filterMode = Constants.MODE_FAIL;
      callGetListComponentFailureByFixture(context);
    }

    AppCache.getStringValue(AppCache.LANGUAGE_CODE_PREF).then((value) {
      if (Utils.isNotEmpty(value) && value == Constants.LANGUAGE_CODE_CN) {
        this.isChineseLng = true;
      } else {
        this.isChineseLng = false;
      }
    });
  }

  callGetBoardResultSummaryListByProject(BuildContext context) async {
    await getBoardResultSummaryListByProject(context).then((value) {
      if (value.data != null) {
        this.boardResultDataDTO = value.data!;
        if (this.boardResultDataDTO.finalDispositionStruct != null &&
            this.boardResultDataDTO.finalDispositionStruct!.length > 0) {
          groupByLastStatusData(
              this.boardResultDataDTO.finalDispositionStruct!);
          groupByFirstStatusData(
              this.boardResultDataDTO.finalDispositionStruct!);
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

  callGetTestTimeDistribution(BuildContext context) async {
    await getTestTimeDistribution(context).then((value) {
      if (value.data != null) {
        this.testTimeDistributionDataDTO = value.data!;
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

  callGetListComponentFailureByFixture(BuildContext context) async {
    await getListComponentFailureByFixture(context, this.filterMode)
        .then((value) {
      this.failureComponentDTO = value;
      if (value.data != null && value.data!.length > 0) {
        groupDataByFixtureId(value.data!);
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
        if (EasyLoading.isShow) {
          EasyLoading.dismiss();
          this.dqmWebViewController.webViewController.reload();
        }
      });
    });
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
          this.dqmWebViewController.webViewController.reload();
          // this.dqmWorstTestNameWebViewController.webViewController.reload();
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
          this.dqmWebViewController.webViewController.reload();
          // this.dqmWorstTestNameWebViewController.webViewController.reload();
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
                          chart(context),
                          // chartWorstTestNames(context),
                          // footer(context),
                          displayChartInfo(context),
                        ],
                      ),
                    ),
                    // chart(context),
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
                        Constants.FILTER_BY_CHART_WORST_TESTNAME_FALSE_FAIL ||
                    arguments.filterBy ==
                        Constants.FILTER_BY_CHART_PIN_RETEST) {
                  Navigator.pushReplacementNamed(
                    ctx,
                    AppRoutes.dqmTestResultChartDetailWTNRoute,
                    arguments: DqmTestResultArguments(
                        appBarTitle: this.appBarTitle,
                        fromWhere: widget.fromWhere,
                        mode: this.filterMode,
                        filterBy: this.filterBy),
                  );
                } else {
                  EasyLoading.show(maskType: EasyLoadingMaskType.black);
                  callGetListComponentFailureByFixture(context);
                }
              } else {
                this.dqmWebViewController.webViewController.reload();
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
                  : Constants.ASSET_IMAGES + 'filter_icon.png'),
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

  Widget chart(BuildContext ctx) {
    return Container(
      width: MediaQuery.of(ctx).size.width,
      height: this.chartHeight,
      color: Colors.transparent,
      child: WebViewPlus(
        backgroundColor: Colors.transparent,
        javascriptMode: JavascriptMode.unrestricted,
        initialUrl: theme_dark!
            ? 'assets/html/highchart_dark_theme.html'
            : 'assets/html/highchart_light_theme.html',
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
            setState(() {
              this.chartHeight = value;
            });
          });
        },
        javascriptChannels: [
          JavascriptChannel(
              name: 'DQMChannel',
              onMessageReceived: (message) {
                if (widget.fromWhere == Constants.TEST_RESULT_CHART_VOLUME) {
                  this.dqmWebViewController.webViewController.runJavascript(
                      'fetchVolumeAndYieldDetailData(${jsonEncode(this.boardResultDataDTO)}, ${jsonEncode(this.filterBy)}, "${Utils.getTranslated(ctx, 'dqm_dashboard_finalyield')}", "${Utils.getTranslated(ctx, 'dqm_dashboard_firstpassyield')}", "${Utils.getTranslated(ctx, 'dqm_dashboard_fail')}", "${Utils.getTranslated(ctx, 'dqm_dashboard_retestpass')}", "${Utils.getTranslated(ctx, 'dqm_dashboard_firstpass')}", "${Utils.getTranslated(ctx, 'dqm_testresult_eq/vo')}")');
                } else if (widget.fromWhere ==
                    Constants.TEST_RESULT_CHART_TEST_TIME) {
                  this.dqmWebViewController.webViewController.runJavascript(
                      'fetchTestTimeDistributionDetailData(${jsonEncode(this.testTimeDistributionDataDTO)}, ${jsonEncode(this.filterBy)}, "${Utils.getTranslated(ctx, 'dqm_summary_testtimeanalysis')}", "${Utils.getTranslated(ctx, 'dqm_summary_outlier')}", "${Utils.getTranslated(ctx, 'chart_footer_equipment_seconds')}" )');
                } else if (widget.fromWhere ==
                    Constants.TEST_RESULT_CHART_FINAL_DISPOSITION) {
                  this.dqmWebViewController.webViewController.runJavascript(
                      'fetchFailFinalDispositionDetailData(${jsonEncode(this.boardResultDataDTO)}, ${jsonEncode(this.finalDispositionMap)}, ${jsonEncode(this.finalDispositionList)}, "${Utils.getTranslated(ctx, 'dqm_testresult_status/count')}")');
                } else if (widget.fromWhere ==
                    Constants.TEST_RESULT_CHART_COMPONENT_FAILURE) {
                  if (!(this.filterBy ==
                          Constants.FILTER_BY_CHART_WORST_TESTNAME_FAIL ||
                      this.filterBy ==
                          Constants.FILTER_BY_CHART_WORST_TESTNAME_FIRST_FAIL ||
                      this.filterBy ==
                          Constants
                              .FILTER_BY_CHART_WORST_TESTNAME_FALSE_FAIL)) {
                    this.dqmWebViewController.webViewController.runJavascript(
                        'fetchTestTypeFailureCountDetailData(${jsonEncode(this.failureComponentDTO)}, ${jsonEncode(this.testTypeFailureMap)}, ${jsonEncode(this.filterBy)}, "${Utils.getTranslated(ctx, 'dqm_testresult_fixture/test')}")');
                  }
                }
              }),
          JavascriptChannel(
              name: 'DQMClickChannel',
              onMessageReceived: (message) {
                print(message.message);
                if (widget.fromWhere == Constants.TEST_RESULT_CHART_VOLUME) {
                  setState(() {
                    this.startShowInfo = true;
                    this.jsTestResultVolumeDataDTO =
                        JSTestResultVolumeDataDTO.fromJson(
                            jsonDecode(message.message));
                  });
                } else if (widget.fromWhere ==
                    Constants.TEST_RESULT_CHART_TEST_TIME) {
                  setState(() {
                    this.startShowInfo = true;
                    this.jsTestResultTestTimeDataDTO =
                        JSTestResultTestTimeDataDTO.fromJson(
                            jsonDecode(message.message));
                  });
                } else if (widget.fromWhere ==
                    Constants.TEST_RESULT_CHART_FINAL_DISPOSITION) {
                  List<dynamic> list = jsonDecode(message.message);
                  showTestTypeTooltipsDialog(ctx, list);
                } else if (widget.fromWhere ==
                    Constants.TEST_RESULT_CHART_COMPONENT_FAILURE) {
                  JSTestTypeWorstTestNameDataDTO jsDTO =
                      JSTestTypeWorstTestNameDataDTO.fromJson(
                          jsonDecode(message.message));
                  Navigator.pushNamed(
                    ctx,
                    AppRoutes.dqmTestResultChartDetailWTNByTestTypeRoute,
                    arguments: DqmTestResultArguments(
                        testType: jsDTO.testType,
                        fixtureId: jsDTO.fixtureId,
                        mode: this.filterMode),
                  );
                }
              }),
          JavascriptChannel(
              name: 'DQMExportImageChannel',
              onMessageReceived: (message) async {
                if (Utils.isNotEmpty(message.message)) {
                  String name = '';
                  String curDate =
                      '#${DateFormat('yyyy.MM.dd').format(DateTime.now())}@${DateFormat('HH.mm.ss').format(DateTime.now())}';
                  if (widget.fromWhere == Constants.TEST_RESULT_CHART_VOLUME) {
                    //KEYS_BM_Proj_BM_VolYildByEqp_2022-04-01_2022-08-09#2022.08.10@00.59.58
                    name = Utils.getExportFilename(
                      'VolYildByEqp',
                      companyId: AppCache.sortFilterCacheDTO!.preferredCompany,
                      siteId: AppCache.sortFilterCacheDTO!.preferredSite,
                      projectId: AppCache.sortFilterCacheDTO!.defaultProjectId,
                      fromDate: DateFormat('yyyy-MM-dd')
                          .format(AppCache.sortFilterCacheDTO!.startDate!),
                      toDate: DateFormat('yyyy-MM-dd')
                          .format(AppCache.sortFilterCacheDTO!.endDate!),
                      currentDate: curDate,
                      expType: '.png',
                    );
                  } else if (widget.fromWhere ==
                      Constants.TEST_RESULT_CHART_TEST_TIME) {
                    //KEYS_BM_Proj_BM_TstTmDistbt_2022-04-01_2022-08-09#2022.08.10@01.08.57
                    name = Utils.getExportFilename(
                      'TstTmDistbt',
                      companyId: AppCache.sortFilterCacheDTO!.preferredCompany,
                      siteId: AppCache.sortFilterCacheDTO!.preferredSite,
                      projectId: AppCache.sortFilterCacheDTO!.defaultProjectId,
                      fromDate: DateFormat('yyyy-MM-dd')
                          .format(AppCache.sortFilterCacheDTO!.startDate!),
                      toDate: DateFormat('yyyy-MM-dd')
                          .format(AppCache.sortFilterCacheDTO!.endDate!),
                      currentDate: curDate,
                      expType: '.png',
                    );
                  } else if (widget.fromWhere ==
                      Constants.TEST_RESULT_CHART_FINAL_DISPOSITION) {
                    //KEYS_BM_Proj_BM_FrstFlFnlDispst_2022-04-01_2022-08-09#2022.08.10@01.10.08
                    name = Utils.getExportFilename(
                      'FrstFlFnlDispst',
                      companyId: AppCache.sortFilterCacheDTO!.preferredCompany,
                      siteId: AppCache.sortFilterCacheDTO!.preferredSite,
                      projectId: AppCache.sortFilterCacheDTO!.defaultProjectId,
                      fromDate: DateFormat('yyyy-MM-dd')
                          .format(AppCache.sortFilterCacheDTO!.startDate!),
                      toDate: DateFormat('yyyy-MM-dd')
                          .format(AppCache.sortFilterCacheDTO!.endDate!),
                      currentDate: curDate,
                      expType: '.png',
                    );
                  } else if (widget.fromWhere ==
                      Constants.TEST_RESULT_CHART_COMPONENT_FAILURE) {
                    if ((this.filterBy ==
                            Constants.FILTER_BY_CHART_WORST_TESTNAME_FAIL ||
                        this.filterBy ==
                            Constants
                                .FILTER_BY_CHART_WORST_TESTNAME_FIRST_FAIL ||
                        this.filterBy ==
                            Constants
                                .FILTER_BY_CHART_WORST_TESTNAME_FALSE_FAIL)) {
                      //KEYS_BM_Proj_BM_WstTstNm_2022-04-01_2022-08-09#2022.08.10@01.11.50
                      name = Utils.getExportFilename(
                        'WstTstNm',
                        companyId:
                            AppCache.sortFilterCacheDTO!.preferredCompany,
                        siteId: AppCache.sortFilterCacheDTO!.preferredSite,
                        projectId:
                            AppCache.sortFilterCacheDTO!.defaultProjectId,
                        fromDate: DateFormat('yyyy-MM-dd')
                            .format(AppCache.sortFilterCacheDTO!.startDate!),
                        toDate: DateFormat('yyyy-MM-dd')
                            .format(AppCache.sortFilterCacheDTO!.endDate!),
                        currentDate: curDate,
                        expType: '.png',
                      );
                    } else if (this.filterBy ==
                            Constants.FILTER_BY_CHART_TEST_TYPE_FAIL ||
                        this.filterBy ==
                            Constants.FILTER_BY_CHART_TEST_TYPE_FALSE_FAIL ||
                        this.filterBy ==
                            Constants.FILTER_BY_CHART_TEST_TYPE_FIRST_FAIL) {
                      //KEYS_BM_Proj_BM_FxtCntByTstTypFxtId_2022-04-01_2022-08-09#2022.08.10@01.11.22
                      name = Utils.getExportFilename(
                        'FxtCntByTstTypFxtId',
                        companyId:
                            AppCache.sortFilterCacheDTO!.preferredCompany,
                        siteId: AppCache.sortFilterCacheDTO!.preferredSite,
                        projectId:
                            AppCache.sortFilterCacheDTO!.defaultProjectId,
                        fromDate: DateFormat('yyyy-MM-dd')
                            .format(AppCache.sortFilterCacheDTO!.startDate!),
                        toDate: DateFormat('yyyy-MM-dd')
                            .format(AppCache.sortFilterCacheDTO!.endDate!),
                        currentDate: curDate,
                        expType: '.png',
                      );
                    } else {
                      name = Utils.getExportFilename(
                        'FxtCntByPinRtsFxtId',
                        companyId:
                            AppCache.sortFilterCacheDTO!.preferredCompany,
                        siteId: AppCache.sortFilterCacheDTO!.preferredSite,
                        projectId:
                            AppCache.sortFilterCacheDTO!.defaultProjectId,
                        fromDate: DateFormat('yyyy-MM-dd')
                            .format(AppCache.sortFilterCacheDTO!.startDate!),
                        toDate: DateFormat('yyyy-MM-dd')
                            .format(AppCache.sortFilterCacheDTO!.endDate!),
                        currentDate: curDate,
                        expType: '.png',
                      );
                    }
                  }

                  final result = await ImageApi.generateImage(
                      message.message, 600, this.chartHeight.round(), name);
                  if (result == true) {
                    setState(() {
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
                  String name = '';
                  String curDate =
                      '#${DateFormat('yyyy.MM.dd').format(DateTime.now())}@${DateFormat('HH.mm.ss').format(DateTime.now())}';
                  if (widget.fromWhere == Constants.TEST_RESULT_CHART_VOLUME) {
                    //KEYS_BM_Proj_BM_VolYildByEqp_2022-04-01_2022-08-09#2022.08.10@00.59.58
                    name = Utils.getExportFilename(
                      'VolYildByEqp',
                      companyId: AppCache.sortFilterCacheDTO!.preferredCompany,
                      siteId: AppCache.sortFilterCacheDTO!.preferredSite,
                      projectId: AppCache.sortFilterCacheDTO!.defaultProjectId,
                      fromDate: DateFormat('yyyy-MM-dd')
                          .format(AppCache.sortFilterCacheDTO!.startDate!),
                      toDate: DateFormat('yyyy-MM-dd')
                          .format(AppCache.sortFilterCacheDTO!.endDate!),
                      currentDate: curDate,
                      expType: '.pdf',
                    );
                  } else if (widget.fromWhere ==
                      Constants.TEST_RESULT_CHART_TEST_TIME) {
                    //KEYS_BM_Proj_BM_TstTmDistbt_2022-04-01_2022-08-09#2022.08.10@01.08.57
                    name = Utils.getExportFilename(
                      'TstTmDistbt',
                      companyId: AppCache.sortFilterCacheDTO!.preferredCompany,
                      siteId: AppCache.sortFilterCacheDTO!.preferredSite,
                      projectId: AppCache.sortFilterCacheDTO!.defaultProjectId,
                      fromDate: DateFormat('yyyy-MM-dd')
                          .format(AppCache.sortFilterCacheDTO!.startDate!),
                      toDate: DateFormat('yyyy-MM-dd')
                          .format(AppCache.sortFilterCacheDTO!.endDate!),
                      currentDate: curDate,
                      expType: '.pdf',
                    );
                  } else if (widget.fromWhere ==
                      Constants.TEST_RESULT_CHART_FINAL_DISPOSITION) {
                    //KEYS_BM_Proj_BM_FrstFlFnlDispst_2022-04-01_2022-08-09#2022.08.10@01.10.08
                    name = Utils.getExportFilename(
                      'FrstFlFnlDispst',
                      companyId: AppCache.sortFilterCacheDTO!.preferredCompany,
                      siteId: AppCache.sortFilterCacheDTO!.preferredSite,
                      projectId: AppCache.sortFilterCacheDTO!.defaultProjectId,
                      fromDate: DateFormat('yyyy-MM-dd')
                          .format(AppCache.sortFilterCacheDTO!.startDate!),
                      toDate: DateFormat('yyyy-MM-dd')
                          .format(AppCache.sortFilterCacheDTO!.endDate!),
                      currentDate: curDate,
                      expType: '.pdf',
                    );
                  } else if (widget.fromWhere ==
                      Constants.TEST_RESULT_CHART_COMPONENT_FAILURE) {
                    if ((this.filterBy ==
                            Constants.FILTER_BY_CHART_WORST_TESTNAME_FAIL ||
                        this.filterBy ==
                            Constants
                                .FILTER_BY_CHART_WORST_TESTNAME_FIRST_FAIL ||
                        this.filterBy ==
                            Constants
                                .FILTER_BY_CHART_WORST_TESTNAME_FALSE_FAIL)) {
                      //KEYS_BM_Proj_BM_WstTstNm_2022-04-01_2022-08-09#2022.08.10@01.11.50
                      name = Utils.getExportFilename(
                        'WstTstNm',
                        companyId:
                            AppCache.sortFilterCacheDTO!.preferredCompany,
                        siteId: AppCache.sortFilterCacheDTO!.preferredSite,
                        projectId:
                            AppCache.sortFilterCacheDTO!.defaultProjectId,
                        fromDate: DateFormat('yyyy-MM-dd')
                            .format(AppCache.sortFilterCacheDTO!.startDate!),
                        toDate: DateFormat('yyyy-MM-dd')
                            .format(AppCache.sortFilterCacheDTO!.endDate!),
                        currentDate: curDate,
                        expType: '.pdf',
                      );
                    } else if (this.filterBy ==
                            Constants.FILTER_BY_CHART_TEST_TYPE_FAIL ||
                        this.filterBy ==
                            Constants.FILTER_BY_CHART_TEST_TYPE_FALSE_FAIL ||
                        this.filterBy ==
                            Constants.FILTER_BY_CHART_TEST_TYPE_FIRST_FAIL) {
                      //KEYS_BM_Proj_BM_FxtCntByTstTypFxtId_2022-04-01_2022-08-09#2022.08.10@01.11.22
                      name = Utils.getExportFilename(
                        'FxtCntByTstTypFxtId',
                        companyId:
                            AppCache.sortFilterCacheDTO!.preferredCompany,
                        siteId: AppCache.sortFilterCacheDTO!.preferredSite,
                        projectId:
                            AppCache.sortFilterCacheDTO!.defaultProjectId,
                        fromDate: DateFormat('yyyy-MM-dd')
                            .format(AppCache.sortFilterCacheDTO!.startDate!),
                        toDate: DateFormat('yyyy-MM-dd')
                            .format(AppCache.sortFilterCacheDTO!.endDate!),
                        currentDate: curDate,
                        expType: '.pdf',
                      );
                    } else {
                      name = Utils.getExportFilename(
                        'FxtCntByPinRtsFxtId',
                        companyId:
                            AppCache.sortFilterCacheDTO!.preferredCompany,
                        siteId: AppCache.sortFilterCacheDTO!.preferredSite,
                        projectId:
                            AppCache.sortFilterCacheDTO!.defaultProjectId,
                        fromDate: DateFormat('yyyy-MM-dd')
                            .format(AppCache.sortFilterCacheDTO!.startDate!),
                        toDate: DateFormat('yyyy-MM-dd')
                            .format(AppCache.sortFilterCacheDTO!.endDate!),
                        currentDate: curDate,
                        expType: '.pdf',
                      );
                    }
                  }

                  final result = await PdfApi.generatePDF(
                      message.message, 600, this.chartHeight.round(), name,
                      isDarkTheme: this.theme_dark!,
                      isChineseLng: this.isChineseLng);
                  if (result == true) {
                    setState(() {
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

  Widget chartWorstTestNames(BuildContext ctx) {
    double mHeight = 0;
    if (this.filterBy == Constants.FILTER_BY_CHART_WORST_TESTNAME_FAIL ||
        this.filterBy == Constants.FILTER_BY_CHART_WORST_TESTNAME_FIRST_FAIL ||
        this.filterBy == Constants.FILTER_BY_CHART_WORST_TESTNAME_FALSE_FAIL) {
      mHeight = this.chartWTNHeight;
    }
    return Container(
      width: MediaQuery.of(ctx).size.width,
      height: mHeight,
      color: Colors.transparent,
      child: WebViewPlus(
        backgroundColor: Colors.transparent,
        javascriptMode: JavascriptMode.unrestricted,
        initialUrl: theme_dark!
            ? 'assets/html/highchart_dark_theme.html'
            : 'assets/html/highchart_light_theme.html',
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
                if ((this.filterBy ==
                        Constants.FILTER_BY_CHART_WORST_TESTNAME_FAIL ||
                    this.filterBy ==
                        Constants.FILTER_BY_CHART_WORST_TESTNAME_FIRST_FAIL ||
                    this.filterBy ==
                        Constants.FILTER_BY_CHART_WORST_TESTNAME_FALSE_FAIL)) {
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
        ].toSet(),
      ),
    );
  }

  Widget footer(BuildContext ctx) {
    if (widget.fromWhere == Constants.TEST_RESULT_CHART_VOLUME) {
      return Container(
        padding: EdgeInsets.all(12.0),
        child: Center(
          child: Text(
            Utils.getTranslated(ctx, 'dqm_testresult_eq/vo')!,
            style: AppFonts.robotoRegular(
              11,
              color: theme_dark!
                  ? AppColors.appGreyB1()
                  : AppColorsLightMode.appGrey77().withOpacity(0.4),
              decoration: TextDecoration.none,
            ),
          ),
        ),
      );
    } else if (widget.fromWhere == Constants.TEST_RESULT_CHART_TEST_TIME) {
      return Container(
        padding: EdgeInsets.all(12.0),
        child: Center(
          child: Text(
            Utils.getTranslated(ctx, 'dqm_testresult_eq/sec')!,
            style: AppFonts.robotoRegular(
              11,
              color: theme_dark!
                  ? AppColors.appGreyB1()
                  : AppColorsLightMode.appGrey77().withOpacity(0.4),
              decoration: TextDecoration.none,
            ),
          ),
        ),
      );
    } else if (widget.fromWhere ==
        Constants.TEST_RESULT_CHART_FINAL_DISPOSITION) {
      return Container(
        padding: EdgeInsets.all(12.0),
        child: Center(
          child: Text(
            Utils.getTranslated(ctx, 'dqm_testresult_status/count')!,
            style: AppFonts.robotoRegular(
              11,
              color: theme_dark!
                  ? AppColors.appGreyB1()
                  : AppColorsLightMode.appGrey77().withOpacity(0.4),
              decoration: TextDecoration.none,
            ),
          ),
        ),
      );
    } else if (widget.fromWhere ==
        Constants.TEST_RESULT_CHART_COMPONENT_FAILURE) {
      return Container(
        padding: EdgeInsets.all(12.0),
        child: Center(
          child: Text(
            Utils.getTranslated(ctx, 'dqm_testresult_fixture/test')!,
            style: AppFonts.robotoRegular(
              11,
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

  Widget displayChartInfo(BuildContext ctx) {
    if (widget.fromWhere == Constants.TEST_RESULT_CHART_VOLUME) {
      return chartVolumeInfo(ctx);
    } else if (widget.fromWhere == Constants.TEST_RESULT_CHART_TEST_TIME) {
      return chartTestTimeInfo(ctx);
    }
    return Container();
  }

  Widget chartVolumeInfo(BuildContext ctx) {
    if (this.startShowInfo) {
      return Container(
        width: MediaQuery.of(ctx).size.width,
        margin: EdgeInsets.all(12.0),
        padding: EdgeInsets.all(14.0),
        decoration: BoxDecoration(
          color: AppColors.appBlackLight(),
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              this.jsTestResultVolumeDataDTO.equipmentName!,
              style: AppFonts.robotoRegular(
                16,
                color: theme_dark!
                    ? AppColors.appGrey2()
                    : AppColorsLightMode.appGrey2(),
                decoration: TextDecoration.none,
              ),
            ),
            SizedBox(height: 12.0),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      Utils.getTranslated(ctx, 'dqm_testreuslt_fail')!,
                      style: AppFonts.robotoMedium(
                        14,
                        color: HexColor('e3032a'),
                        decoration: TextDecoration.none,
                      ),
                    ),
                    SizedBox(width: 10.0),
                    Text(
                      '${this.jsTestResultVolumeDataDTO.fail!.toInt()}',
                      style: AppFonts.robotoRegular(
                        16,
                        color: theme_dark!
                            ? AppColors.appGrey2()
                            : AppColorsLightMode.appGrey2(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 14.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      Utils.getTranslated(ctx, 'dqm_testreuslt_retestpass')!,
                      style: AppFonts.robotoMedium(
                        14,
                        color: HexColor('f66a01'),
                        decoration: TextDecoration.none,
                      ),
                    ),
                    SizedBox(width: 10.0),
                    Text(
                      '${this.jsTestResultVolumeDataDTO.rework!.toInt()}',
                      style: AppFonts.robotoRegular(
                        16,
                        color: theme_dark!
                            ? AppColors.appGrey2()
                            : AppColorsLightMode.appGrey2(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 14.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      Utils.getTranslated(ctx, 'dqm_testreuslt_firstpass')!,
                      style: AppFonts.robotoMedium(
                        14,
                        color: HexColor('73d329'),
                        decoration: TextDecoration.none,
                      ),
                    ),
                    SizedBox(width: 10.0),
                    Text(
                      '${this.jsTestResultVolumeDataDTO.firstPass!.toInt()}',
                      style: AppFonts.robotoRegular(
                        16,
                        color: theme_dark!
                            ? AppColors.appGrey2()
                            : AppColorsLightMode.appGrey2(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 14.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      Utils.getTranslated(
                          ctx, 'dqm_testreuslt_firstpassyield')!,
                      style: AppFonts.robotoMedium(
                        14,
                        color: HexColor('089fa7'),
                        decoration: TextDecoration.none,
                      ),
                    ),
                    SizedBox(width: 10.0),
                    Text(
                      '${this.jsTestResultVolumeDataDTO.firstPassYield}',
                      style: AppFonts.robotoRegular(
                        16,
                        color: theme_dark!
                            ? AppColors.appGrey2()
                            : AppColorsLightMode.appGrey2(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 14.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      Utils.getTranslated(ctx, 'dqm_testreuslt_finalyield')!,
                      style: AppFonts.robotoMedium(
                        14,
                        color: HexColor('17721f'),
                        decoration: TextDecoration.none,
                      ),
                    ),
                    SizedBox(width: 10.0),
                    Text(
                      '${this.jsTestResultVolumeDataDTO.finalYield}',
                      style: AppFonts.robotoRegular(
                        16,
                        color: theme_dark!
                            ? AppColors.appGrey2()
                            : AppColorsLightMode.appGrey2(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 23.0),
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {},
                child: Text(
                  Utils.getTranslated(ctx, 'view_oee_>>')!,
                  style: AppFonts.robotoMedium(
                    14,
                    color: AppColors.appBlue(),
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container();
  }

  Widget chartTestTimeInfo(BuildContext ctx) {
    if (this.startShowInfo) {
      if (this.jsTestResultTestTimeDataDTO.isClickScatter!) {
        return chartScatterTestTimeInfo(ctx);
      } else {
        return chartBoxPlotTestTimeInfo(ctx);
      }
    }
    return Container();
  }

  Widget chartBoxPlotTestTimeInfo(BuildContext ctx) {
    return Container(
      width: MediaQuery.of(ctx).size.width,
      margin: EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 12.0),
      padding: EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: AppColors.appBlackLight(),
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Utils.isNotEmpty(this.jsTestResultTestTimeDataDTO.name)
                ? 'Equipment: ${this.jsTestResultTestTimeDataDTO.name}'
                : '',
            style: AppFonts.robotoMedium(
              14,
              color: HexColor('f4d444'),
              decoration: TextDecoration.none,
            ),
          ),
          SizedBox(height: 17.0),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    Utils.getTranslated(
                        context, 'dqm_rma_cpk_dashboard_histogram_max')!,
                    style: AppFonts.robotoRegular(
                      16,
                      color: theme_dark!
                          ? AppColors.appGrey2()
                          : AppColorsLightMode.appGrey2(),
                      decoration: TextDecoration.none,
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Text(
                    '${this.jsTestResultTestTimeDataDTO.high!.toInt()}',
                    style: AppFonts.robotoRegular(
                      16,
                      color: theme_dark!
                          ? AppColors.appGrey2()
                          : AppColorsLightMode.appGrey2(),
                      decoration: TextDecoration.none,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 17.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    Utils.getTranslated(context,
                        'dqm_rma_cpk_dashboard_histogram_upperquartile')!,
                    style: AppFonts.robotoRegular(
                      16,
                      color: theme_dark!
                          ? AppColors.appGrey2()
                          : AppColorsLightMode.appGrey2(),
                      decoration: TextDecoration.none,
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Text(
                    '${this.jsTestResultTestTimeDataDTO.q3!.toInt()}',
                    style: AppFonts.robotoRegular(
                      16,
                      color: theme_dark!
                          ? AppColors.appGrey2()
                          : AppColorsLightMode.appGrey2(),
                      decoration: TextDecoration.none,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 17.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    Utils.getTranslated(
                        context, 'dqm_rma_cpk_dashboard_histogram_median')!,
                    style: AppFonts.robotoRegular(
                      16,
                      color: theme_dark!
                          ? AppColors.appGrey2()
                          : AppColorsLightMode.appGrey2(),
                      decoration: TextDecoration.none,
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Text(
                    '${this.jsTestResultTestTimeDataDTO.median!.toInt()}',
                    style: AppFonts.robotoRegular(
                      16,
                      color: theme_dark!
                          ? AppColors.appGrey2()
                          : AppColorsLightMode.appGrey2(),
                      decoration: TextDecoration.none,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 17.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    Utils.getTranslated(context,
                        'dqm_rma_cpk_dashboard_histogram_lowquartile')!,
                    style: AppFonts.robotoRegular(
                      16,
                      color: theme_dark!
                          ? AppColors.appGrey2()
                          : AppColorsLightMode.appGrey2(),
                      decoration: TextDecoration.none,
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Text(
                    '${this.jsTestResultTestTimeDataDTO.q1!.toInt()}',
                    style: AppFonts.robotoRegular(
                      16,
                      color: theme_dark!
                          ? AppColors.appGrey2()
                          : AppColorsLightMode.appGrey2(),
                      decoration: TextDecoration.none,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 17.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    Utils.getTranslated(
                        context, 'dqm_rma_cpk_dashboard_histogram_min')!,
                    style: AppFonts.robotoRegular(
                      16,
                      color: theme_dark!
                          ? AppColors.appGrey2()
                          : AppColorsLightMode.appGrey2(),
                      decoration: TextDecoration.none,
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Text(
                    '${this.jsTestResultTestTimeDataDTO.low}',
                    style: AppFonts.robotoRegular(
                      16,
                      color: theme_dark!
                          ? AppColors.appGrey2()
                          : AppColorsLightMode.appGrey2(),
                      decoration: TextDecoration.none,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget chartScatterTestTimeInfo(BuildContext ctx) {
    if (this.startShowInfo) {
      String serialNumberList = '';
      if (this.jsTestResultTestTimeDataDTO.outliers != null &&
          this.jsTestResultTestTimeDataDTO.outliers!.length > 0) {
        serialNumberList =
            this.jsTestResultTestTimeDataDTO.outliers!.join("\n\n");
      }
      return Container(
        width: MediaQuery.of(ctx).size.width,
        margin: EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 12.0),
        padding: EdgeInsets.all(14.0),
        decoration: BoxDecoration(
          color: AppColors.appBlackLight(),
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              Utils.isNotEmpty(this.jsTestResultTestTimeDataDTO.name)
                  ? 'Equipment: ${this.jsTestResultTestTimeDataDTO.name}'
                  : '',
              style: AppFonts.robotoMedium(
                14,
                color: HexColor('F56A02'),
                decoration: TextDecoration.none,
              ),
            ),
            SizedBox(height: 17.0),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      Utils.getTranslated(ctx, 'dqm_testreuslt_outlier')!,
                      style: AppFonts.robotoRegular(
                        16,
                        color: theme_dark!
                            ? AppColors.appGrey2()
                            : AppColorsLightMode.appGrey2(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                    SizedBox(width: 10.0),
                    Text(
                      '${this.jsTestResultTestTimeDataDTO.y!.toInt()}',
                      style: AppFonts.robotoRegular(
                        16,
                        color: theme_dark!
                            ? AppColors.appGrey2()
                            : AppColorsLightMode.appGrey2(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 17.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Utils.getTranslated(ctx, 'dqm_testreuslt_serialnumber')!,
                      style: AppFonts.robotoRegular(
                        16,
                        color: theme_dark!
                            ? AppColors.appGrey2()
                            : AppColorsLightMode.appGrey2(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                    SizedBox(width: 10.0),
                    Flexible(
                      child: Text(
                        serialNumberList,
                        style: AppFonts.robotoRegular(
                          16,
                          color: theme_dark!
                              ? AppColors.appGrey2()
                              : AppColorsLightMode.appGrey2(),
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      );
    }
    return Container();
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
                    .dqmWebViewController
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
                var object;
                String name = '';
                String curDate =
                    '#${DateFormat('yyyy.MM.dd').format(DateTime.now())}@${DateFormat('HH.mm.ss').format(DateTime.now())}';
                if (widget.fromWhere == Constants.TEST_RESULT_CHART_VOLUME) {
                  //KEYS_BM_Proj_BM_VolYildByEqp_2022-04-01_2022-08-09#2022.08.10@00.59.58
                  name = Utils.getExportFilename(
                    'VolYildByEqp',
                    companyId: AppCache.sortFilterCacheDTO!.preferredCompany,
                    siteId: AppCache.sortFilterCacheDTO!.preferredSite,
                    projectId: AppCache.sortFilterCacheDTO!.defaultProjectId,
                    fromDate: DateFormat('yyyy-MM-dd')
                        .format(AppCache.sortFilterCacheDTO!.startDate!),
                    toDate: DateFormat('yyyy-MM-dd')
                        .format(AppCache.sortFilterCacheDTO!.endDate!),
                    currentDate: curDate,
                    expType: '.csv',
                  );
                  object = this.boardResultDataDTO;
                } else if (widget.fromWhere ==
                    Constants.TEST_RESULT_CHART_TEST_TIME) {
                  //KEYS_BM_Proj_BM_TstTmDistbt_2022-04-01_2022-08-09#2022.08.10@01.08.57
                  name = Utils.getExportFilename(
                    'TstTmDistbt',
                    companyId: AppCache.sortFilterCacheDTO!.preferredCompany,
                    siteId: AppCache.sortFilterCacheDTO!.preferredSite,
                    projectId: AppCache.sortFilterCacheDTO!.defaultProjectId,
                    fromDate: DateFormat('yyyy-MM-dd')
                        .format(AppCache.sortFilterCacheDTO!.startDate!),
                    toDate: DateFormat('yyyy-MM-dd')
                        .format(AppCache.sortFilterCacheDTO!.endDate!),
                    currentDate: curDate,
                    expType: '.csv',
                  );
                  object = this.testTimeDistributionDataDTO;
                } else if (widget.fromWhere ==
                    Constants.TEST_RESULT_CHART_FINAL_DISPOSITION) {
                  //KEYS_BM_Proj_BM_FrstFlFnlDispst_2022-04-01_2022-08-09#2022.08.10@01.10.08
                  name = Utils.getExportFilename(
                    'FrstFlFnlDispst',
                    companyId: AppCache.sortFilterCacheDTO!.preferredCompany,
                    siteId: AppCache.sortFilterCacheDTO!.preferredSite,
                    projectId: AppCache.sortFilterCacheDTO!.defaultProjectId,
                    fromDate: DateFormat('yyyy-MM-dd')
                        .format(AppCache.sortFilterCacheDTO!.startDate!),
                    toDate: DateFormat('yyyy-MM-dd')
                        .format(AppCache.sortFilterCacheDTO!.endDate!),
                    currentDate: curDate,
                    expType: '.csv',
                  );
                  object = this.boardResultDataDTO;
                } else if (widget.fromWhere ==
                    Constants.TEST_RESULT_CHART_COMPONENT_FAILURE) {
                  if ((this.filterBy ==
                          Constants.FILTER_BY_CHART_WORST_TESTNAME_FAIL ||
                      this.filterBy ==
                          Constants.FILTER_BY_CHART_WORST_TESTNAME_FIRST_FAIL ||
                      this.filterBy ==
                          Constants
                              .FILTER_BY_CHART_WORST_TESTNAME_FALSE_FAIL)) {
                    //KEYS_BM_Proj_BM_WstTstNm_2022-04-01_2022-08-09#2022.08.10@01.11.50
                    name = Utils.getExportFilename(
                      'WstTstNm',
                      companyId: AppCache.sortFilterCacheDTO!.preferredCompany,
                      siteId: AppCache.sortFilterCacheDTO!.preferredSite,
                      projectId: AppCache.sortFilterCacheDTO!.defaultProjectId,
                      fromDate: DateFormat('yyyy-MM-dd')
                          .format(AppCache.sortFilterCacheDTO!.startDate!),
                      toDate: DateFormat('yyyy-MM-dd')
                          .format(AppCache.sortFilterCacheDTO!.endDate!),
                      currentDate: curDate,
                      expType: '.csv',
                    );
                    object = this.failureComponentDTO;
                  } else if (this.filterBy ==
                          Constants.FILTER_BY_CHART_TEST_TYPE_FAIL ||
                      this.filterBy ==
                          Constants.FILTER_BY_CHART_TEST_TYPE_FALSE_FAIL ||
                      this.filterBy ==
                          Constants.FILTER_BY_CHART_TEST_TYPE_FIRST_FAIL) {
                    //KEYS_BM_Proj_BM_FxtCntByTstTypFxtId_2022-04-01_2022-08-09#2022.08.10@01.11.22
                    name = Utils.getExportFilename(
                      'FxtCntByTstTypFxtId',
                      companyId: AppCache.sortFilterCacheDTO!.preferredCompany,
                      siteId: AppCache.sortFilterCacheDTO!.preferredSite,
                      projectId: AppCache.sortFilterCacheDTO!.defaultProjectId,
                      fromDate: DateFormat('yyyy-MM-dd')
                          .format(AppCache.sortFilterCacheDTO!.startDate!),
                      toDate: DateFormat('yyyy-MM-dd')
                          .format(AppCache.sortFilterCacheDTO!.endDate!),
                      currentDate: curDate,
                      expType: '.csv',
                    );
                    object = this.failureComponentDTO;
                  } else {
                    name = Utils.getExportFilename(
                      'FxtCntByPinRtsFxtId',
                      companyId: AppCache.sortFilterCacheDTO!.preferredCompany,
                      siteId: AppCache.sortFilterCacheDTO!.preferredSite,
                      projectId: AppCache.sortFilterCacheDTO!.defaultProjectId,
                      fromDate: DateFormat('yyyy-MM-dd')
                          .format(AppCache.sortFilterCacheDTO!.startDate!),
                      toDate: DateFormat('yyyy-MM-dd')
                          .format(AppCache.sortFilterCacheDTO!.endDate!),
                      currentDate: curDate,
                      expType: '.csv',
                    );
                    object = this.failureComponentDTO;
                  }
                }

                final result = await CSVApi.generateCSV(object, name);
                if (result == true) {
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
                    .dqmWebViewController
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
                  : AppColorsLightMode.appGrey2(),
              decoration: TextDecoration.none,
            ),
          ),
        ],
      ),
    );
  }
}
