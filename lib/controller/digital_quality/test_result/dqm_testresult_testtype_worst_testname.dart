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
import 'package:keysight_pma/model/customize.dart';
import 'package:keysight_pma/model/dqm/boardresult_summary_byproject.dart';
import 'package:keysight_pma/model/dqm/failure_component_by_fixture.dart';
import 'package:keysight_pma/model/dqm/test_time_distribution.dart';
import 'package:keysight_pma/model/dqm/worst_test_name.dart';
import 'package:keysight_pma/model/js/js.dart';
import 'package:keysight_pma/routes/approutes.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

class DqmTestResultDetailTestTypeWorstTestNameScreen extends StatefulWidget {
  final String? fixtureId;
  final String? testType;
  final String? mode;
  DqmTestResultDetailTestTypeWorstTestNameScreen(
      {Key? key, this.fixtureId, this.testType, this.mode})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DqmTestResultDetailTestTypeWorstTestNameScreen();
  }
}

class _DqmTestResultDetailTestTypeWorstTestNameScreen
    extends State<DqmTestResultDetailTestTypeWorstTestNameScreen> {
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
  JSTestResultVolumeDataDTO jsTestResultVolumeDataDTO =
      JSTestResultVolumeDataDTO();
  late JSTestResultTestTimeDataDTO jsTestResultTestTimeDataDTO;
  List<CustomDqmSortFilterProjectsDTO> finalDispositionList = [];

  Future<WorstTestNameDTO> getWorstTestNames(BuildContext context) {
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
    return dqmApi.getTestTypeWorstTestNames(
        companyId,
        siteId,
        startDate,
        endDate,
        equipments,
        projectId,
        widget.fixtureId!,
        widget.testType!,
        widget.mode!);
  }

  @override
  void initState() {
    super.initState();
    Utils.setFirebaseAnalyticsCurrentScreen(
        Constants.ANALYTICS_DQM_TEST_RESULT_TESTTYPE_WORST_TESTNAME_SCREEN);
    callGetWorstTestNames(context);
  }

  bool? theme_dark = AppCache.sortFilterCacheDTO!.currentTheme;
  callGetWorstTestNames(BuildContext context) async {
    await getWorstTestNames(context).then((value) {
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
            widget.testType!,
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
                          'fetchTestTypeWorstTestNamesData(${jsonEncode(this.worstTestNameDTO)})');
                }
              }),
          JavascriptChannel(
              name: 'DQMClickChannel',
              onMessageReceived: (message) {
                print(message.message);
                Navigator.pushNamed(
                  ctx,
                  AppRoutes.dqmTestResultInfoRoute,
                  arguments: DqmTestResultArguments(
                    testname: message.message,
                    testType: widget.testType,
                  ),
                );
              }),
          JavascriptChannel(
              name: 'DQMExportImageChannel',
              onMessageReceived: (message) async {
                print(message.message);
                if (Utils.isNotEmpty(message.message)) {
                  String name = 'testtype_worst.png';

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
                  String name = 'testtype_worst.pdf';

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
                Navigator.pop(downloadContext);

                String name = "testtype_worst.csv";
                final result =
                    await CSVApi.generateCSV(this.worstTestNameDTO.data!, name);
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
