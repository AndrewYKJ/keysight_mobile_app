import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:keysight_pma/cache/appcache.dart';
import 'package:keysight_pma/const/appcolors.dart';
import 'package:keysight_pma/const/appfonts.dart';
import 'package:keysight_pma/const/constants.dart';
import 'package:keysight_pma/const/download.dart';
import 'package:keysight_pma/const/utils.dart';
import 'package:keysight_pma/dio/api/alert.dart';
import 'package:keysight_pma/model/alert/alert_casehistory.dart';
import 'package:keysight_pma/model/alert/alert_detail.dart';
import 'package:keysight_pma/model/arguments/dqm_argument.dart';
import 'package:keysight_pma/model/arguments/search_argument.dart';
import 'package:keysight_pma/model/dqm/test_result_testname.dart';
import 'package:keysight_pma/routes/approutes.dart';
import 'package:keysight_pma/widget/expandableWidget.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

class CaseHistoryLimitChange extends StatefulWidget {
  final String title;
  final AlertCaseHistoryDataDTO data;

  const CaseHistoryLimitChange(
      {Key? key, required this.title, required this.data})
      : super(key: key);

  @override
  State<CaseHistoryLimitChange> createState() => _CaseHistoryLimitChangeState();
}

class _CaseHistoryLimitChangeState extends State<CaseHistoryLimitChange> {
  ScrollController controller = ScrollController();
  bool isLoading = true;
  bool isExpandedCard = false;
  bool isExpandedCpk = false;
  int defaultList = 6;
  int counterList = 6;
  late WebViewPlusController cpkTestNameController;
  double chartHeight = 316.0;
  bool? theme_dark = AppCache.sortFilterCacheDTO!.currentTheme;

  AlertOpenCaseDTO? openCaseData;
  TestResultTestNameDTO chartData = TestResultTestNameDTO();
  Future<AlertOpenCaseDTO> openCase(
    BuildContext ctx,
  ) {
    AlertApi alertApi = AlertApi(ctx);
    String alertRowKey = widget.data.alertRowKey!;

    return alertApi.openCase(alertRowKey);
  }

  Future<TestResultTestNameDTO> getLimitChangeAlertByTestname(
    BuildContext ctx,
  ) {
    AlertApi alertApi = AlertApi(ctx);
    String companyId = widget.data.companyId!;
    String equipmentId = widget.data.equipmentId!;
    String projectId = widget.data.projectId!;
    String siteId = widget.data.siteId!;
    String testName = widget.data.testName!;
    String timestamp = widget.data.timestamp!;

    return alertApi.getLimitChangeAlertByTestname(
        companyId, equipmentId, projectId, siteId, testName, timestamp);
  }

  callAlertCaseHistory(BuildContext context) async {
    await openCase(context).then((value) {
      if (value.status!.statusCode == 200) {
        openCaseData = value;
        print(openCaseData!.data!);
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

    await getLimitChangeAlertByTestname(context).then((value) {
      if (value.status!.statusCode == 200) {
        chartData = value;
        print(chartData.data!);
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
  void initState() {
    super.initState();
    Utils.setFirebaseAnalyticsCurrentScreen(
        Constants.ANALYTICS_ALERT_LIMIT_CHANGE_SCREEN);
    setState(() {
      controller = ScrollController();
    });
    callAlertCaseHistory(context);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var x = MediaQuery.of(context).size.height;
    print(x);
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
          widget.title,
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
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.only(top: 26),
        color: theme_dark!
            ? AppColors.appPrimaryBlack()
            : AppColorsLightMode.appPrimaryBlack(),
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(AppColors.appBlue()),
                ),
              )
            : SingleChildScrollView(
                scrollDirection: Axis.vertical,
                controller: controller,
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                child: Column(
                  children: [
                    widget.data != null
                        ? ExpandaleCardContainer(
                            collapsedChild:
                                createCollapseColumn(context, widget.data),
                            expandedChild:
                                createExpandedColumn(context, widget.data),
                            isExpanded: isExpandedCard,
                          )
                        : Container(),
                    SizedBox(
                      height: widget.data != null ? 20 : 0,
                    ),
                    //#%#(*%*&%*#@)%*@#&%)@&%#&%*&@#%)&*#@%#@&(&)#&))
                    //#%#(*%*&%*#@)%*@#&%)@&%#&%*&@#%)&*#@%#@&(&)#&))
                    Container(
                      margin: EdgeInsets.only(top: 15.0, left: 16, right: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              widget.data.testName != null
                                  ? Utils.getTranslated(context,
                                          'dqm_testresult_analog_detail_testresult')! +
                                      ': ${widget.data.testName}'
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
                            onTap: () => showDownloadPopup(context, 111),
                            child: Image.asset(
                              theme_dark!
                                  ? Constants.ASSET_IMAGES + 'download_bttn.png'
                                  : Constants.ASSET_IMAGES_LIGHT +
                                      'download_bttn.png',
                            ),
                          ),
                        ],
                      ),
                    ),
                    //#%#(*%*&%*#@)%*@#&%)@&%#&%*&@#%)&*#@%#@&(&)#&))
                    Container(
                      height: this.chartHeight,
                      margin: EdgeInsets.only(top: 30.0, left: 16, right: 16),
                      color: theme_dark!
                          ? AppColors.appPrimaryBlack()
                          : AppColorsLightMode.appPrimaryBlack(),
                      child: this.chartData.data != null &&
                              this.chartData.data!.length > 0
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
                                this.cpkTestNameController = controllerPlus;
                              },
                              onPageFinished: (url) {
                                this
                                    .cpkTestNameController
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
                                      this
                                          .cpkTestNameController
                                          .webViewController
                                          .runJavascript(
                                              'fetchCaseHistoryChangeLimitData(${jsonEncode(this.chartData)},"${Utils.getTranslated(context, 'chart_footer_timestamp_measured')}", "${Utils.getTranslated(context, 'chart_footer_timestamp_measured')}", "${Utils.getTranslated(context, 'chart_legend_pass')}", "${Utils.getTranslated(context, 'chart_legend_fail')}", "${Utils.getTranslated(context, 'chart_legend_anomaly')}", "${Utils.getTranslated(context, 'chart_legend_false_failure')}", "${Utils.getTranslated(context, 'chart_legend_lower_limit')}", "${Utils.getTranslated(context, 'chart_legend_upper_limit')}", "${Utils.getTranslated(context, 'chart_legend_limit_change')}")');
                                    }),
                                JavascriptChannel(
                                    name: 'DQMAnalogCpkTestResultChannel',
                                    onMessageReceived: (message) {
                                      print(message.message);
                                      TestResultTestNameDataDTO
                                          testNameDataDTO =
                                          TestResultTestNameDataDTO.fromJson(
                                              jsonDecode(message.message));
                                      //  Utils.printInfo(fixtureDataDTO.measured!);
                                      Navigator.pushNamed(context,
                                          AppRoutes.dqmCpkDashboardRoute,
                                          arguments: DqmTestResultArguments(
                                              testNameDataDTO: testNameDataDTO,
                                              projectId: widget.data.projectId!,
                                              startDate: widget.data.startDate,
                                              endDate: widget.data.timestamp,
                                              equipmentId:
                                                  widget.data.equipmentId));
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
                                          'TstRstLmtChg',
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
                                                this.chartHeight.round(),
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
                                          'TstRstLmtChg',
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
                                            message.message,
                                            600,
                                            this.chartHeight.round(),
                                            name);
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
                      height: 16,
                    ),
                    //#%#(*%*&%*#@)%*@#&%)@&%#&%*&@#%)&*#@%#@&(&)#&))
                    //    //#%#(*%*&%*#@)%*@#&%)@&%#&%*&@#%)&*#@%#@&(&)#&))
                    //#%#(*%*&%*#@)%*@#&%)@&%#&%*&@#%)&*#@%#@&(&)#&))
                    if (openCaseData != null)
                      SizedBox(
                        height: 40,
                      ),
                    if (openCaseData != null)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 16),
                            child: Text(
                              Utils.getTranslated(context, 'alerthistory')!,
                              style: AppFonts.robotoRegular(
                                16,
                                color: theme_dark!
                                    ? AppColors.appGrey2()
                                    : AppColorsLightMode.appGrey(),
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 20),
                                child: GestureDetector(
                                  onTap: () {
                                    if (this
                                            .openCaseData!
                                            .data!
                                            .histories!
                                            .length >
                                        0) {
                                      Navigator.pushNamed(
                                        context,
                                        AppRoutes.searchRoute,
                                        arguments: SearchArguments(
                                          caseHistoryCommentList: this
                                              .openCaseData!
                                              .data!
                                              .histories!,
                                        ),
                                      );
                                    }
                                  },
                                  child: Image.asset(theme_dark!
                                      ? Constants.ASSET_IMAGES +
                                          'search_icon.png'
                                      : Constants.ASSET_IMAGES_LIGHT +
                                          'search.png'),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 13),
                                child: GestureDetector(
                                  onTap: () async {
                                    final result = await Navigator.pushNamed(
                                        context, AppRoutes.editComment,
                                        arguments: widget.data.alertRowKey);
                                    if (result != null) {
                                      setState(() {
                                        isLoading = true;
                                      });
                                    }
                                    callAlertCaseHistory(context);
                                  },
                                  child: Image.asset(
                                    theme_dark!
                                        ? Constants.ASSET_IMAGES +
                                            'add_comment_icon.png'
                                        : Constants.ASSET_IMAGES_LIGHT +
                                            'add_comment_icon.png',
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 16),
                                child: GestureDetector(
                                  onTap: () => showDownloadPopup(context, 110),
                                  child: Image.asset(
                                    theme_dark!
                                        ? Constants.ASSET_IMAGES +
                                            'download_bttn.png'
                                        : Constants.ASSET_IMAGES_LIGHT +
                                            'download_bttn.png',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    SizedBox(
                      height: 33.5,
                    ),
                    if (openCaseData != null)
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: openCaseData!.data!.histories!
                            .map((e) => dataHistory(context, e))
                            .toList(),
                      ),
                  ],
                )),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(left: 69.5, top: 27, right: 69.5),
        height: 67,
        color: theme_dark!
            ? AppColors.appPrimaryBlack()
            : AppColorsLightMode.appPrimaryBlack(),
        child: GestureDetector(
          onTap: () async {
            final result = await Navigator.pushNamed(
                context, AppRoutes.editCase,
                arguments: openCaseData);
            if (result != null) {
              setState(() {
                isLoading = true;
              });
            }
            callAlertCaseHistory(context);
          },
          child: Container(
            height: 40,
            padding: EdgeInsets.only(top: 12),
            width: 156,
            color: AppColors.appPrimaryYellow(),
            child: Text(
              Utils.getTranslated(context, 'alertCPK_editcasedetail')!,
              style: AppFonts.robotoMedium(15,
                  color: AppColors.appPrimaryWhite(),
                  decoration: TextDecoration.none),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  Widget dataHistory(BuildContext ctx, AlertDetailHistoriesDTO e) {
    return Container(
      padding: EdgeInsets.fromLTRB(15, 14, 12, 0),
      margin: EdgeInsets.fromLTRB(16, 0, 16, 14),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: AppColors.appBlackLight()),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                e.dateCreated!,
                style: AppFonts.sfproRegular(13,
                    color: AppColors.appGreyB7(),
                    decoration: TextDecoration.none),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 14.0, right: 14),
                child: Text(
                  '|',
                  style: AppFonts.sfproRegular(13,
                      color: AppColors.appGreyB7(),
                      decoration: TextDecoration.none),
                ),
              ),
              Text(
                e.historyType!,
                style: AppFonts.sfproRegular(13,
                    color: AppColors.appGreyB7(),
                    decoration: TextDecoration.none),
              ),
            ],
          ),
          SizedBox(
            height: 9,
          ),
          Text(
            e.message!,
            style: AppFonts.robotoBold(13,
                color: theme_dark!
                    ? AppColors.appGreyDE()
                    : AppColorsLightMode.appGrey(),
                decoration: TextDecoration.none),
          ),
          SizedBox(
            height: 9,
          ),
          Text(
            e.createdByName!,
            style: AppFonts.sfproLight(13,
                color: AppColors.appGreyB7(), decoration: TextDecoration.none),
          ),
          SizedBox(
            height: 12,
          ),
        ],
      ),
    );
  }

  getTagColor(tag) {
    if (tag == 'Critical' || tag == 'critical')
      return AppColors.appRedE9();
    else if (tag == 'High' || tag == 'high')
      return AppColors.appRedE9();
    else if (tag == 'Medium' || tag == 'medium')
      return AppColors.appPrimaryOrange();
    else if (tag == 'Low' || tag == 'medium')
      return AppColors.appPrimaryYellow();
    else if (tag == "None" || tag == 'none')
      return AppColors.appGreen60();
    else
      return Colors.transparent;
  }

  void showDownloadPopup(BuildContext context, int? type) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext downloadContext) => CupertinoActionSheet(
        actions: [
          type != 110
              ? Container(
                  color: theme_dark!
                      ? AppColors.cupertinoBackground()
                      : AppColorsLightMode.cupertinoBackground()
                          .withOpacity(0.8),
                  child: CupertinoActionSheetAction(
                    onPressed: () {
                      print('################ image');

                      this
                          .cpkTestNameController
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
                )
              : Container(),
          Container(
            color: theme_dark!
                ? AppColors.cupertinoBackground()
                : AppColorsLightMode.cupertinoBackground().withOpacity(0.8),
            child: CupertinoActionSheetAction(
              onPressed: () async {
                final bool result;
                String curDate =
                    '#${DateFormat('yyyy.MM.dd').format(DateTime.now())}@${DateFormat('HH.mm.ss').format(DateTime.now())}';
                var object = [];
                var lowerlimit;
                var upperlimit;
                if (type != 110) {
                  this.chartData.data!.forEach((element) {
                    var passdata;
                    var anomalydata;
                    var failData;
                    var chglmtdata;
                    if (element.status == "Anomaly") {
                      anomalydata = element.measured;
                    } else if (element.status == "PASS" ||
                        element.status == "Pass" ||
                        element.status == "pass") {
                      passdata = element.measured;
                    } else {
                      failData = element.measured;
                    }
                    if (lowerlimit != null && upperlimit != null) {
                      if (lowerlimit != element.lowerLimit) {
                        chglmtdata = (double.parse(element.lowerLimit!) -
                                double.parse(lowerlimit))
                            .abs()
                            .toString();
                        lowerlimit = element.lowerLimit;
                      }
                      if (upperlimit != element.upperLimit) {
                        chglmtdata = (double.parse(element.upperLimit!) -
                                double.parse(lowerlimit))
                            .abs()
                            .toString();
                        upperlimit = element.upperLimit;
                      }
                    } else {
                      lowerlimit = element.lowerLimit;
                      upperlimit = element.upperLimit;
                    }
                    object.add({
                      Utils.getTranslated(context, 'csv_dateTime'):
                          element.timestamp,
                      Utils.getTranslated(context, 'csv_lwrlmt'):
                          element.lowerLimit,
                      Utils.getTranslated(context, 'csv_upprlmt'):
                          element.upperLimit,
                      Utils.getTranslated(context, 'csv_pass'): passdata,
                      Utils.getTranslated(context, 'csv_anmly'): anomalydata,
                      Utils.getTranslated(context, 'csv_falsefailure'):
                          element.isFalseFailure,
                      Utils.getTranslated(context, 'csv_fail'): failData,
                      Utils.getTranslated(context, 'csv_lmtchg'): chglmtdata,
                      Utils.getTranslated(context, 'csv_nml'): element.nominal,
                      Utils.getTranslated(context, 'csv_eq'):
                          element.equipmentName,
                      Utils.getTranslated(context, 'csv_fxtId'):
                          element.fixtureId,
                      Utils.getTranslated(context, 'csv_srlnmb'):
                          element.serialNumber,
                      Utils.getTranslated(context, 'csv_tstnm'):
                          element.testName,
                      Utils.getTranslated(context, 'csv_tsttyp'):
                          element.testType,
                      Utils.getTranslated(context, 'csv_tstunt'):
                          element.testUnit,
                      Utils.getTranslated(context, 'csv_description'):
                          element.failureMessage,
                    });
                  });
                  result = await CSVApi.generateCSV(
                    object,
                    Utils.getExportFilename(
                      'TstRstLmtChg',
                      companyId: AppCache.sortFilterCacheDTO!.preferredCompany,
                      siteId: AppCache.sortFilterCacheDTO!.preferredSite,
                      fromDate: DateFormat('yyyy-MM-dd')
                          .format(AppCache.sortFilterCacheDTO!.startDate!),
                      toDate: DateFormat('yyyy-MM-dd')
                          .format(AppCache.sortFilterCacheDTO!.endDate!),
                      currentDate: curDate,
                      expType: '.csv',
                    ),
                  );
                } else if (type == 110) {
                  var object1 = [];
                  var object2 = [];
                  var e = openCaseData!.data;
                  object1.add({
                    "Alert ID": e!.alertIdName,
                    "Message": e.event,
                    "Case ID": e.caseId,
                    "Subject": e.subject,
                    "Desciption": e.description,
                    "Assigned To": e.assignedToName,
                    "Priority": e.priority,
                    "Status": e.status,
                    "Workflow": e.workFlow,
                    "Company": e.companyName,
                    "Site": e.siteName,
                    "Equipment": e.equipmentName,
                    "Severity": e.severity,
                    "Scoring": e.alertScoring,
                    "Alert Date": e.timestamp,
                    "Created By": e.createdByName,
                    "Created Date": e.createdTimestamp,
                    "Modified By": e.modifiedByName,
                    "Modified Date": e.modifiedTimestamp,
                  });

                  openCaseData!.data!.histories!.forEach((element) {
                    object2.add({
                      "Timestamp": element.dateCreated,
                      "Type": element.historyType,
                      "Message": element.message,
                      "Updated By": element.createdByName,
                    });
                  });
                  result = await CSVApi.generateCaseHistoryCSV(
                      object1,
                      object2,
                      Utils.getExportFilename(
                        'Case',
                        currentDate: curDate,
                        expType: '.csv',
                      ));
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
          type != null
              ? Container(
                  color: theme_dark!
                      ? AppColors.cupertinoBackground()
                      : AppColorsLightMode.cupertinoBackground()
                          .withOpacity(0.8),
                  child: CupertinoActionSheetAction(
                    onPressed: () {
                      print('################ image');

                      this
                          .cpkTestNameController
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

  createExpandedColumn(BuildContext context, AlertCaseHistoryDataDTO e) {
    String createdDate = '-';
    String modifiedDate = '-';
    String alertDate = '-';
    if (e.createdTimestamp != null) {
      createdDate = DateFormat('d MMM yyy HH:mm:ss')
          .format(DateTime.parse(e.createdTimestamp!));
    }
    if (e.modifiedTimestamp != null) {
      modifiedDate = DateFormat('d MMM yyy HH:mm:ss')
          .format(DateTime.parse(e.modifiedTimestamp!));
    }
    if (e.timestamp != null) {
      alertDate =
          DateFormat('d MMM yyy HH:mm:ss').format(DateTime.parse(e.timestamp!));
    }
    return Container(
        padding: EdgeInsets.fromLTRB(18, 19, 15, 15),
        margin: EdgeInsets.fromLTRB(16, 0, 16, 12),
        color: theme_dark!
            ? AppColors.appBlackLight()
            : AppColorsLightMode.appGreyBA(),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Utils.getTranslated(context, 'alert_company')!,
                            style: AppFonts.robotoRegular(
                              13,
                              color: theme_dark!
                                  ? AppColors.appGreyB1()
                                  : AppColorsLightMode.appGrey77(),
                              decoration: TextDecoration.none,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            e.companyName!,
                            style: AppFonts.robotoMedium(
                              13,
                              color: theme_dark!
                                  ? AppColors.appPrimaryWhite()
                                  : AppColorsLightMode.appGrey(),
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 20,
                        padding: EdgeInsets.only(top: 4, left: 12, right: 12),
                        decoration: BoxDecoration(
                            color: getTagColor(e.priority!),
                            borderRadius: BorderRadius.circular(2)),
                        child: Text(
                          Utils.capitalize(e.priority!),
                          style: AppFonts.robotoMedium(
                            12,
                            color: AppColors.appPrimaryWhite(),
                            decoration: TextDecoration.none,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ]),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Utils.getTranslated(context, 'alert_site')!,
                      style: AppFonts.robotoRegular(
                        13,
                        color: theme_dark!
                            ? AppColors.appGreyB1()
                            : AppColorsLightMode.appGrey77(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      e.siteName!,
                      style: AppFonts.robotoRegular(
                        14,
                        color: theme_dark!
                            ? AppColors.appGreyDE()
                            : AppColorsLightMode.appGrey(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Utils.getTranslated(context, 'alert_createdby')!,
                      style: AppFonts.robotoRegular(
                        13,
                        color: theme_dark!
                            ? AppColors.appGreyB1()
                            : AppColorsLightMode.appGrey77(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      e.createdByName!,
                      style: AppFonts.robotoRegular(
                        14,
                        color: theme_dark!
                            ? AppColors.appGreyDE()
                            : AppColorsLightMode.appGrey(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Utils.getTranslated(context, 'alert_createdon')!,
                      style: AppFonts.robotoRegular(
                        13,
                        color: theme_dark!
                            ? AppColors.appGreyB1()
                            : AppColorsLightMode.appGrey77(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      createdDate,
                      style: AppFonts.robotoRegular(
                        14,
                        color: theme_dark!
                            ? AppColors.appGreyDE()
                            : AppColorsLightMode.appGrey(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Utils.getTranslated(context, 'alert_modifiedby')!,
                      style: AppFonts.robotoRegular(
                        13,
                        color: theme_dark!
                            ? AppColors.appGreyB1()
                            : AppColorsLightMode.appGrey77(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      e.modifiedByName != null ? e.modifiedByName! : '-',
                      style: AppFonts.robotoRegular(
                        14,
                        color: theme_dark!
                            ? AppColors.appGreyDE()
                            : AppColorsLightMode.appGrey(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Utils.getTranslated(context, 'alert_modifieddate')!,
                      style: AppFonts.robotoRegular(
                        13,
                        color: theme_dark!
                            ? AppColors.appGreyB1()
                            : AppColorsLightMode.appGrey77(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      modifiedDate,
                      style: AppFonts.robotoRegular(
                        14,
                        color: theme_dark!
                            ? AppColors.appGreyDE()
                            : AppColorsLightMode.appGrey(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Utils.getTranslated(context, 'alert_recentupdate')!,
                      style: AppFonts.robotoRegular(
                        13,
                        color: theme_dark!
                            ? AppColors.appGreyB1()
                            : AppColorsLightMode.appGrey77(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      '-',
                      style: AppFonts.robotoRegular(
                        14,
                        color: theme_dark!
                            ? AppColors.appGreyDE()
                            : AppColorsLightMode.appGrey(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Utils.getTranslated(context, 'alert_alertdate')!,
                      style: AppFonts.robotoRegular(
                        13,
                        color: theme_dark!
                            ? AppColors.appGreyB1()
                            : AppColorsLightMode.appGrey77(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      alertDate,
                      style: AppFonts.robotoRegular(
                        14,
                        color: theme_dark!
                            ? AppColors.appGreyDE()
                            : AppColorsLightMode.appGrey(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Utils.getTranslated(context, 'alert_alertid')!,
                      style: AppFonts.robotoRegular(
                        13,
                        color: theme_dark!
                            ? AppColors.appGreyB1()
                            : AppColorsLightMode.appGrey77(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      e.alertIdName!,
                      style: AppFonts.robotoRegular(
                        14,
                        color: theme_dark!
                            ? AppColors.appGreyDE()
                            : AppColorsLightMode.appGrey(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Utils.getTranslated(context, 'alert_equipment')!,
                      style: AppFonts.robotoRegular(
                        13,
                        color: theme_dark!
                            ? AppColors.appGreyB1()
                            : AppColorsLightMode.appGrey77(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      e.equipmentName != null ? e.equipmentName! : '-',
                      style: AppFonts.robotoRegular(
                        14,
                        color: theme_dark!
                            ? AppColors.appGreyDE()
                            : AppColorsLightMode.appGrey(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Utils.getTranslated(context, 'alert_subject')!,
                      style: AppFonts.robotoRegular(
                        13,
                        color: theme_dark!
                            ? AppColors.appGreyB1()
                            : AppColorsLightMode.appGrey77(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      e.subject != null ? e.subject! : '-',
                      style: AppFonts.robotoRegular(
                        14,
                        color: theme_dark!
                            ? AppColors.appGreyDE()
                            : AppColorsLightMode.appGrey(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Utils.getTranslated(context, 'alert_description')!,
                      style: AppFonts.robotoRegular(
                        13,
                        color: theme_dark!
                            ? AppColors.appGreyB1()
                            : AppColorsLightMode.appGrey77(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      e.description != null ? e.description! : 'None',
                      style: AppFonts.robotoRegular(
                        14,
                        color: theme_dark!
                            ? AppColors.appGreyDE()
                            : AppColorsLightMode.appGrey(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Utils.getTranslated(context, 'alert_assignedto')!,
                      style: AppFonts.robotoRegular(
                        13,
                        color: theme_dark!
                            ? AppColors.appGreyB1()
                            : AppColorsLightMode.appGrey77(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      e.assignedTo != null ? e.assignedTo! : '-',
                      style: AppFonts.robotoRegular(
                        14,
                        color: theme_dark!
                            ? AppColors.appGreyDE()
                            : AppColorsLightMode.appGrey(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Utils.getTranslated(context, 'alert_status')!,
                      style: AppFonts.robotoRegular(
                        13,
                        color: theme_dark!
                            ? AppColors.appGreyB1()
                            : AppColorsLightMode.appGrey77(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      e.status!,
                      style: AppFonts.robotoRegular(
                        14,
                        color: theme_dark!
                            ? AppColors.appGreyDE()
                            : AppColorsLightMode.appGrey(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Utils.getTranslated(context, 'alert_workflow')!,
                      style: AppFonts.robotoRegular(
                        13,
                        color: theme_dark!
                            ? AppColors.appGreyB1()
                            : AppColorsLightMode.appGrey77(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      e.workFlow!,
                      style: AppFonts.robotoRegular(
                        14,
                        color: theme_dark!
                            ? AppColors.appGreyDE()
                            : AppColorsLightMode.appGrey(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Utils.getTranslated(context, 'alert_message')!,
                      style: AppFonts.robotoRegular(
                        13,
                        color: theme_dark!
                            ? AppColors.appGreyB1()
                            : AppColorsLightMode.appGrey77(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      e.event!,
                      style: AppFonts.robotoRegular(
                        14,
                        color: theme_dark!
                            ? AppColors.appGreyDE()
                            : AppColorsLightMode.appGrey(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isExpandedCard = false;
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Text(
                        Utils.getTranslated(context, 'view_less_detail')!,
                        style: AppFonts.robotoMedium(
                          14,
                          color: AppColors.appBlue(),
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Image.asset(Constants.ASSET_IMAGES + 'view_less_icon.png')
                  ],
                ),
              ),
            ]));
  }

  createCollapseColumn(BuildContext context, AlertCaseHistoryDataDTO e) {
    String createdDate = '-';
    String modifiedDate = '-';
    String alertDate = '-';
    if (e.createdTimestamp != null) {
      createdDate = DateFormat('d MMM yyy HH:mm:ss')
          .format(DateTime.parse(e.createdTimestamp!));
    }
    if (e.modifiedTimestamp != null) {
      modifiedDate = DateFormat('d MMM yyy HH:mm:ss')
          .format(DateTime.parse(e.modifiedTimestamp!));
    }
    if (e.timestamp != null) {
      alertDate =
          DateFormat('d MMM yyy HH:mm:ss').format(DateTime.parse(e.timestamp!));
    }
    return Container(
        padding: EdgeInsets.fromLTRB(18, 19, 15, 15),
        margin: EdgeInsets.fromLTRB(16, 0, 16, 12),
        color: theme_dark!
            ? AppColors.appBlackLight()
            : AppColorsLightMode.appGreyBA(),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Utils.getTranslated(context, 'alert_company')!,
                            style: AppFonts.robotoRegular(
                              13,
                              color: theme_dark!
                                  ? AppColors.appGreyB1()
                                  : AppColorsLightMode.appGrey77(),
                              decoration: TextDecoration.none,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            e.companyName!,
                            style: AppFonts.robotoMedium(
                              13,
                              color: theme_dark!
                                  ? AppColors.appPrimaryWhite()
                                  : AppColorsLightMode.appGrey(),
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 20,
                        padding: EdgeInsets.only(top: 4, left: 12, right: 12),
                        decoration: BoxDecoration(
                            color: getTagColor(e.priority!),
                            borderRadius: BorderRadius.circular(2)),
                        child: Text(
                          Utils.capitalize(e.priority!),
                          style: AppFonts.robotoMedium(
                            12,
                            color: AppColors.appPrimaryWhite(),
                            decoration: TextDecoration.none,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ]),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Utils.getTranslated(context, 'alert_site')!,
                      style: AppFonts.robotoRegular(
                        13,
                        color: theme_dark!
                            ? AppColors.appGreyB1()
                            : AppColorsLightMode.appGrey77(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      e.siteName!,
                      style: AppFonts.robotoRegular(
                        14,
                        color: theme_dark!
                            ? AppColors.appGreyDE()
                            : AppColorsLightMode.appGrey(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Utils.getTranslated(context, 'alert_createdby')!,
                      style: AppFonts.robotoRegular(
                        13,
                        color: theme_dark!
                            ? AppColors.appGreyB1()
                            : AppColorsLightMode.appGrey77(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      e.createdByName!,
                      style: AppFonts.robotoRegular(
                        14,
                        color: theme_dark!
                            ? AppColors.appGreyDE()
                            : AppColorsLightMode.appGrey(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Utils.getTranslated(context, 'alert_createdon')!,
                      style: AppFonts.robotoRegular(
                        13,
                        color: theme_dark!
                            ? AppColors.appGreyB1()
                            : AppColorsLightMode.appGrey77(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      createdDate,
                      style: AppFonts.robotoRegular(
                        14,
                        color: theme_dark!
                            ? AppColors.appGreyDE()
                            : AppColorsLightMode.appGrey(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Utils.getTranslated(context, 'alert_modifiedby')!,
                      style: AppFonts.robotoRegular(
                        13,
                        color: theme_dark!
                            ? AppColors.appGreyB1()
                            : AppColorsLightMode.appGrey77(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      e.modifiedByName != null ? e.modifiedByName! : '-',
                      style: AppFonts.robotoRegular(
                        14,
                        color: theme_dark!
                            ? AppColors.appGreyDE()
                            : AppColorsLightMode.appGrey(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isExpandedCard = true;
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Text(
                        Utils.getTranslated(context, 'view_more')!,
                        style: AppFonts.robotoMedium(
                          14,
                          color: AppColors.appBlue(),
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Image.asset(Constants.ASSET_IMAGES + 'view_more_icon.png')
                  ],
                ),
              ),
            ]));
  }
}
