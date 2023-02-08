import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
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
import 'package:keysight_pma/model/alert/alert_pat_anomalies.dart';
import 'package:keysight_pma/model/alert/alert_review_data.dart';
import 'package:keysight_pma/model/arguments/alert_routeTitle.dart';
import 'package:keysight_pma/routes/approutes.dart';
import 'package:keysight_pma/widget/expandableWidget.dart';

import '../../../model/alert/alert_recentList.dart';
import '../../../model/arguments/search_argument.dart';

class CaseHistoryPatAnomalies extends StatefulWidget {
  final AlertCaseHistoryDataDTO? alertCaseHistoryDataDTO;
  final AlertRecentModel? notificationData;
  final AlertListDataDTO? alertListDataDTO;

  const CaseHistoryPatAnomalies(
      {Key? key,
      this.notificationData,
      this.alertCaseHistoryDataDTO,
      this.alertListDataDTO})
      : super(key: key);

  @override
  State<CaseHistoryPatAnomalies> createState() => _CaseHistoryPatAnomalies();
}

class _CaseHistoryPatAnomalies extends State<CaseHistoryPatAnomalies> {
  ScrollController controller = ScrollController();
  bool isLoading = true;
  bool isExpandedCard = false;
  bool isExpandedCpk = false;
  int defaultList = 6;
  int counterList = 6;
  bool? theme_dark = AppCache.sortFilterCacheDTO!.currentTheme;
  int page = 0;
  int pageSize = 10;

  AlertPatAnomaliesDTO? alertPatAnomaliesDTO;

//  UserDataTableSource? _dtSource;
  AlertOpenCaseDTO? openCaseData;
  PatRecommendDTO? patRecommendDTO;
  List<PatRecommendDataDTO> patRecommendDataDTO = [];
  Future<PatRecommendDTO> getPatRecommendation(
    BuildContext ctx,
  ) {
    AlertApi alertApi = AlertApi(ctx);
    String companyId = '';
    String siteId = '';
    String projectId = '';
    String timestamp = '';
    if (widget.alertCaseHistoryDataDTO != null) {
      companyId = AppCache.sortFilterCacheDTO!.preferredCompany!;
      siteId = AppCache.sortFilterCacheDTO!.preferredSite!;

      projectId = AppCache.sortFilterCacheDTO!.defaultProjectId!;
      timestamp = DateTime.parse(widget.alertCaseHistoryDataDTO!.timestamp!)
          .millisecondsSinceEpoch
          .toString();
    } else if (widget.alertListDataDTO != null) {
      companyId = widget.alertListDataDTO!.companyId!;
      siteId = widget.alertListDataDTO!.siteId!;
      projectId = widget.alertListDataDTO!.projectId!;
      timestamp = DateTime.parse(widget.alertListDataDTO!.timestamp!)
          .millisecondsSinceEpoch
          .toString();
    } else {
      companyId = widget.notificationData!.companyId!;
      siteId = widget.notificationData!.siteId!;
      projectId = widget.notificationData!.projectId!;
      timestamp = DateTime.parse(widget.notificationData!.timestamp!)
          .millisecondsSinceEpoch
          .toString();
    }

    return alertApi.getPatRecommendation(
        companyId, siteId, projectId, timestamp);
  }

  Future<AlertOpenCaseDTO> openCase(
    BuildContext ctx,
  ) {
    AlertApi alertApi = AlertApi(ctx);
    String alertRowKey = '';
    if (widget.alertCaseHistoryDataDTO != null) {
      alertRowKey = widget.alertCaseHistoryDataDTO!.alertRowKey!;
    } else {
      alertRowKey = widget.notificationData!.alertRowKey!;
    }

    return alertApi.openCase(alertRowKey);
  }

  Future<AlertPatAnomaliesDTO> getPatAnomalies(BuildContext context) {
    String companyId = '';
    String siteId = '';
    String equipmentId = '';
    String fixtureId = '';
    String projectId = '';
    int timestamp = 0;

    if (widget.alertCaseHistoryDataDTO != null) {
      companyId = widget.alertCaseHistoryDataDTO!.companyId!;
      siteId = widget.alertCaseHistoryDataDTO!.siteId!;
      equipmentId = widget.alertCaseHistoryDataDTO!.equipmentId!;
      fixtureId = widget.alertCaseHistoryDataDTO!.fixtureId!;
      projectId = widget.alertCaseHistoryDataDTO!.projectId!;
      timestamp = DateTime.parse(widget.alertCaseHistoryDataDTO!.timestamp!)
          .millisecondsSinceEpoch;
    }

    AlertApi alertApi = AlertApi(context);
    return alertApi.getPatAnomalies(
        companyId, siteId, equipmentId, fixtureId, projectId, timestamp);
  }

  callAlertCaseHistory(BuildContext context) async {
    await getPatRecommendation(context).then((value) {
      if (value.status!.statusCode == 200) {
        patRecommendDTO = value;
        patRecommendDataDTO = patRecommendDTO!.data!;
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

    setState(() {
      this.isLoading = false;
      // _dtSource = UserDataTableSource(
      //     userData: patRecommendDTO!.data!,
      //     onRowSelect: (int index) {
      //       print(index);
      //     },
      //     ctx: context);
    });
  }

  @override
  void initState() {
    super.initState();
    Utils.setFirebaseAnalyticsCurrentScreen(
        Constants.ANALYTICS_ALERT_PAT_ANOMALIES_SCREEN);
    setState(() {
      controller = ScrollController();
    });
    callGetPatAnomalies(context);
    // callAlertCaseHistory(context);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  callGetPatAnomalies(BuildContext context) async {
    await getPatAnomalies(context).then((value) {
      if (value.status!.statusCode == 200) {
        this.alertPatAnomaliesDTO = value;
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
        isLoading = false;
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
          Utils.getTranslated(context, 'alert_pat_anomalies_appbar_title')!,
          style: AppFonts.robotoRegular(
            20,
            color: theme_dark!
                ? AppColors.appGrey()
                : AppColorsLightMode.appGrey(),
            decoration: TextDecoration.none,
          ),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Image.asset(theme_dark!
                ? Constants.ASSET_IMAGES + 'back_bttn.png'
                : Constants.ASSET_IMAGES_LIGHT + 'back_bttn.png')),
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
                child: Column(
                  children: [
                    widget.alertCaseHistoryDataDTO != null
                        ? ExpandaleCardContainer(
                            collapsedChild: createCollapseColumn(
                                context, widget.alertCaseHistoryDataDTO!),
                            expandedChild: createExpandedColumn(
                                context, widget.alertCaseHistoryDataDTO!),
                            isExpanded: isExpandedCard,
                          )
                        : Container(),
                    SizedBox(
                      height: widget.alertCaseHistoryDataDTO != null ? 20 : 0,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 16),
                          child: Text(
                            Utils.getTranslated(
                                context, 'alert_pat_anomalies_label')!,
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
                              padding: const EdgeInsets.only(right: 16),
                              child: GestureDetector(
                                onTap: () => showDownloadPopup(context),
                                child: Image.asset(theme_dark!
                                    ? Constants.ASSET_IMAGES +
                                        'download_bttn.png'
                                    : Constants.ASSET_IMAGES_LIGHT +
                                        'download_bttn.png'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 16.0),
                    patAnomaliesInfo(context),
                    if (openCaseData != null &&
                        widget.alertCaseHistoryDataDTO != null)
                      SizedBox(
                        height: 40,
                      ),
                    if (openCaseData != null &&
                        widget.alertCaseHistoryDataDTO != null)
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
                                        arguments: widget
                                                    .alertCaseHistoryDataDTO!
                                                    .alertRowKey !=
                                                null
                                            ? widget.alertCaseHistoryDataDTO!
                                                .alertRowKey
                                            : widget
                                                .notificationData!.alertRowKey);
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
                                  onTap: () => showDownloadCsvPopup(context),
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
                color: AppColors.appGreyDE(), decoration: TextDecoration.none),
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

  void showDownloadCsvPopup(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext csvContext) => CupertinoActionSheet(
        actions: [
          Container(
            color: theme_dark!
                ? AppColors.cupertinoBackground()
                : AppColorsLightMode.cupertinoBackground().withOpacity(0.8),
            child: CupertinoActionSheetAction(
              onPressed: () async {
                Navigator.pop(csvContext);
                String curDate =
                    '#${DateFormat('yyyy.MM.dd').format(DateTime.now())}@${DateFormat('HH.mm.ss').format(DateTime.now())}';

                String name = "";
                name = Utils.getExportFilename(
                  'Case',
                  currentDate: curDate,
                  expType: '.csv',
                );

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
                final result = await CSVApi.generateCaseHistoryCSV(
                    object1,
                    object2,
                    Utils.getExportFilename(
                      'Case',
                      currentDate: curDate,
                      expType: '.csv',
                    ));
                if (result != null && result == true) {
                  setState(() {
                    isLoading = false;
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
                      : AppColors.appGrey(),
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
              Navigator.pop(csvContext);
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
              onPressed: () async {
                Navigator.pop(downloadContext);

                String name = "patRecommedationList.csv";
                String curDate =
                    '#${DateFormat('yyyy.MM.dd').format(DateTime.now())}@${DateFormat('HH.mm.ss').format(DateTime.now())}';

                name = Utils.getExportFilename(
                  'PAT Recommendation Information',
                  fromDate: DateFormat('yyyy-MM-dd')
                      .format(AppCache.sortFilterCacheDTO!.startDate!),
                  toDate: DateFormat('yyyy-MM-dd')
                      .format(AppCache.sortFilterCacheDTO!.endDate!),
                  currentDate: curDate,
                  expType: '.csv',
                );
                final result =
                    await CSVApi.generateCSV(patRecommendDataDTO, name);
                if (result != null && result == true) {
                  setState(() {
                    isLoading = false;
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

  Widget patAnomaliesInfo(BuildContext ctx) {
    if (this.alertPatAnomaliesDTO != null &&
        this.alertPatAnomaliesDTO!.data != null &&
        this.alertPatAnomaliesDTO!.data!.length > 0) {
      return Container(
        margin: EdgeInsets.only(top: 30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List<Widget>.generate(
                this.alertPatAnomaliesDTO!.data!.length <
                        ((page * pageSize) + pageSize)
                    ? this.alertPatAnomaliesDTO!.data!.length
                    : ((page * pageSize) + pageSize),
                (index) {
                  return patAnomaliesDataItem(
                      context, alertPatAnomaliesDTO!.data![index]);
                },
              ),
            ),
            SizedBox(height: 10.0),
            this.alertPatAnomaliesDTO!.data!.length >
                    ((page * pageSize) + pageSize)
                ? GestureDetector(
                    onTap: () {
                      setState(() {
                        this.page += 1;
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          Utils.getTranslated(context, 'view_more')!,
                          style: AppFonts.robotoMedium(
                            14,
                            color: AppColors.appBlue(),
                            decoration: TextDecoration.none,
                          ),
                        ),
                        SizedBox(width: 10.0),
                        Image.asset(
                            Constants.ASSET_IMAGES + 'view_more_icon.png'),
                      ],
                    ),
                  )
                : Container(),
          ],
        ),
      );
    }

    return Container();
  }

  Widget patAnomaliesDataItem(
      BuildContext ctx, AlertPatAnomaliesDataDTO dataDTO) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.patCharts,
          arguments: AlertArguments(alertPatAnomaliesDataDTO: dataDTO),
        );
      },
      child: Container(
        height: 73,
        margin: EdgeInsets.only(bottom: 12, left: 16, right: 16),
        padding: EdgeInsets.only(left: 17, top: 0),
        decoration: BoxDecoration(
            color: theme_dark!
                ? AppColors.appBlackLight()
                : AppColorsLightMode.appGreyF0(),
            borderRadius: BorderRadius.circular(8)),
        child: Row(children: [
          Text(
            (Utils.isNotEmpty(dataDTO.testType)) ? dataDTO.testType! : '',
            style: AppFonts.robotoBold(
              14,
              color: theme_dark!
                  ? AppColors.appGreyDE()
                  : AppColorsLightMode.appGrey(),
              decoration: TextDecoration.none,
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 14, right: 14, bottom: 27, top: 27),
            child: VerticalDivider(
              color: theme_dark!
                  ? AppColors.appGrey70()
                  : AppColorsLightMode.appGrey(),
            ),
          ),
          Text(
            dataDTO.testName!,
            style: AppFonts.robotoBold(
              14,
              color: theme_dark!
                  ? AppColors.appGreyDE()
                  : AppColorsLightMode.appGrey(),
              decoration: TextDecoration.none,
            ),
          )
        ]),
      ),
    );
  }
}


// typedef OnRowSelect = void Function(int index);

// class UserDataTableSource extends DataTableSource {
//   List<PatRecommendDataDTO>? userData;
//   BuildContext? ctx;
//   UserDataTableSource({this.userData, this.onRowSelect, this.ctx})
//       : _userData = userData!;

//   final List<PatRecommendDataDTO> _userData;
//   final OnRowSelect? onRowSelect;

//   @override
//   DataRow? getRow(int index) {
//     assert(index >= 0);

//     if (index >= _userData.length) {
//       return null;
//     }
//     PatRecommendDataDTO _user = _userData[index];

//     return DataRow.byIndex(
//       onSelectChanged: (bool? empty) {
//         print(index);
//       },
//       index: index, // DONT MISS THIS
//       cells: <DataCell>[
//         DataCell(Text('${_user.testName}')),
//         DataCell(Text('${_user.lowerLimit}')),
//         DataCell(Text('${_user.upperLimit}')),
//         DataCell(Text('${_user.pall}')),
//         DataCell(Text('${_user.paul}'))
//       ],
//     );
//   }

//   @override
//   bool get isRowCountApproximate => false;

//   @override
//   int get rowCount => _userData.length;

//   @override
//   int get selectedRowCount => 0;

//   /*
//    *
//    * Sorts this list according to the order specified by the [compare] function.
//     The [compare] function must act as a [Comparator].
//     List<String> numbers = ['two', 'three', 'four'];
// // Sort from shortest to longest.
//     numbers.sort((a, b) => a.length.compareTo(b.length));
//     print(numbers);  // [two, four, three]
//     The default List implementations use [Comparable.compare] if [compare] is omitted.
//     List<int> nums = [13, 2, -11];
//     nums.sort();
//     print(nums);  // [-11, 2, 13] 
//    */

// }
