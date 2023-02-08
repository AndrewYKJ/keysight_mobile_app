import 'dart:convert';

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
import 'package:keysight_pma/model/alert/alert_fixture_maintenance.dart';
import 'package:keysight_pma/model/alert/alert_pat_anomalies.dart';
import 'package:keysight_pma/model/alert/alert_recentList.dart';
import 'package:keysight_pma/model/alert/alert_review_data.dart';
import 'package:keysight_pma/model/alert/alert_statistics.dart';
import 'package:keysight_pma/model/arguments/alert_routeTitle.dart';
import 'package:keysight_pma/routes/approutes.dart';

class AlertAnnomalyDetails extends StatefulWidget {
  final AlertListDataDTO? alertListDataDTO;
  final AlertStatisticsDataDTO? alertStatisticsDataDTO;
  final AlertRecentModel? notificationData;
  final String? alertType;
  const AlertAnnomalyDetails(
      {Key? key,
      this.alertListDataDTO,
      this.notificationData,
      this.alertStatisticsDataDTO,
      this.alertType})
      : super(key: key);

  @override
  State<AlertAnnomalyDetails> createState() => _AlertAnnomalyDetailsState();
}

class _AlertAnnomalyDetailsState extends State<AlertAnnomalyDetails> {
  bool isLoading = true;
  int pageNo = 0;
  int pageSize = 10;
  late AlertFixtureMaintenanceDTO fixtureMaintenanceDTO;
  AlertPatAnomaliesDTO? alertPatAnomaliesDTO;
  bool? theme_dark = AppCache.sortFilterCacheDTO!.currentTheme;

  Future<AlertFixtureMaintenanceDTO> getFixtureMaintenance(
      BuildContext context) {
    String companyId = '';
    String siteId = '';
    String equipmentId = '';
    String fixtureId = '';
    String projectId = '';
    int timestamp = 0;
    if (widget.alertListDataDTO != null) {
      companyId = widget.alertListDataDTO!.companyId!;
      siteId = widget.alertListDataDTO!.siteId!;
      equipmentId = widget.alertListDataDTO!.equipmentId!;
      fixtureId = widget.alertListDataDTO!.fixtureId!;
      projectId = widget.alertListDataDTO!.projectId!;
      timestamp = DateFormat("yyyy-MM-ddTHH:mm:ssZ")
          .parseUTC(widget.alertListDataDTO!.timestamp!)
          .millisecondsSinceEpoch;
    } else if (widget.notificationData != null) {
      companyId = widget.notificationData!.companyId!;
      siteId = widget.notificationData!.siteId!;
      equipmentId = widget.notificationData!.equipmentId!;
      fixtureId = widget.notificationData!.fixtureId!;
      projectId = widget.notificationData!.projectId!;
      timestamp = DateFormat("yyyy-MM-ddTHH:mm:ssZ")
          .parseUTC(widget.notificationData!.timestamp!)
          .millisecondsSinceEpoch;
    } else {
      companyId = widget.alertStatisticsDataDTO!.companyId!;
      siteId = widget.alertStatisticsDataDTO!.siteId!;
      equipmentId = widget.alertStatisticsDataDTO!.equipmentId!;
      fixtureId = widget.alertStatisticsDataDTO!.fixtureId!;
      projectId = widget.alertStatisticsDataDTO!.projectId!;
      timestamp = DateFormat("yyyy-MM-ddTHH:mm:ssZ")
          .parseUTC(widget.alertStatisticsDataDTO!.timestamp!)
          .millisecondsSinceEpoch;
    }
    AlertApi alertApi = AlertApi(context);
    return alertApi.getFixtureMaintenance(
        companyId, siteId, equipmentId, fixtureId, projectId, timestamp);
  }

  Future<AlertPatAnomaliesDTO> getPatAnomalies(BuildContext context) {
    String companyId = '';
    String siteId = '';
    String equipmentId = '';
    String fixtureId = '';
    String projectId = '';
    int timestamp = 0;
    if (widget.alertListDataDTO != null) {
      companyId = widget.alertListDataDTO!.companyId!;
      siteId = widget.alertListDataDTO!.siteId!;
      equipmentId = widget.alertListDataDTO!.equipmentId!;
      fixtureId = widget.alertListDataDTO!.fixtureId!;
      projectId = widget.alertListDataDTO!.projectId!;
      timestamp = DateFormat("yyyy-MM-ddTHH:mm:ssZ")
          .parseUTC(widget.alertListDataDTO!.timestamp!)
          .millisecondsSinceEpoch;
    } else if (widget.notificationData != null) {
      companyId = widget.notificationData!.companyId!;
      siteId = widget.notificationData!.siteId!;
      equipmentId = widget.notificationData!.equipmentId!;
      fixtureId = widget.notificationData!.fixtureId!;
      projectId = widget.notificationData!.projectId!;
      timestamp = DateFormat("yyyy-MM-ddTHH:mm:ssZ")
          .parseUTC(widget.notificationData!.timestamp!)
          .millisecondsSinceEpoch;
    } else {
      companyId = widget.alertStatisticsDataDTO!.companyId!;
      siteId = widget.alertStatisticsDataDTO!.siteId!;
      equipmentId = widget.alertStatisticsDataDTO!.equipmentId!;
      fixtureId = widget.alertStatisticsDataDTO!.fixtureId!;
      projectId = widget.alertStatisticsDataDTO!.projectId!;
      timestamp = DateFormat("yyyy-MM-ddTHH:mm:ssZ")
          .parseUTC(widget.alertStatisticsDataDTO!.timestamp!)
          .millisecondsSinceEpoch;
    }

    AlertApi alertApi = AlertApi(context);

    return alertApi.getPatAnomalies(
        companyId, siteId, equipmentId, fixtureId, projectId, timestamp);
  }

  @override
  void initState() {
    super.initState();
    Utils.printInfo("#################");
    Utils.printInfo(jsonEncode(widget.alertListDataDTO));
    if (Utils.isNotEmpty(widget.alertType)) {
      if (widget.alertType == Constants.ALERT_COMPONENT_ANOMALY ||
          widget.alertType == Constants.ALERT_DEGRADATION_ANOMALY) {
        callGetFixtureMaintenance(context);
      } else if (widget.alertType == Constants.ALERT_PAT_LIMIT_ANOMALIES ||
          widget.alertType == Constants.ALERT_PAT_LIMIT_RECOMMENDATION) {
        callGetPatAnomalies(context);
      }
    } else {
      callGetFixtureMaintenance(context);
    }
  }

  callGetFixtureMaintenance(BuildContext context) async {
    await getFixtureMaintenance(context).then((value) {
      if (value.status!.statusCode == 200) {
        this.fixtureMaintenanceDTO = value;
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
    var x = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme_dark!
            ? AppColors.serverAppBar()
            : AppColorsLightMode.serverAppBar(),
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          Utils.getTranslated(context, 'alert_information')!,
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
        padding: EdgeInsets.only(left: 16, right: 16),
        color: theme_dark!
            ? AppColors.appPrimaryBlack()
            : AppColorsLightMode.appPrimaryBlack(),
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
                            SizedBox(height: 25.5),
                            alertInfo(context),
                            SizedBox(height: 20),
                            Container(
                              height: 40,
                              padding: EdgeInsets.only(top: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    Utils.getTranslated(
                                        context, 'alert_annomalyinfo')!,
                                    textAlign: TextAlign.center,
                                    style: AppFonts.robotoRegular(16,
                                        color: theme_dark!
                                            ? AppColors.appGrey2()
                                            : AppColorsLightMode.appGrey(),
                                        decoration: TextDecoration.none),
                                  ),
                                  GestureDetector(
                                    onTap: () => showDownloadCsvPopup(context),
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 12),
                                      child: Image.asset(
                                          Constants.ASSET_IMAGES +
                                              'download_bttn.png'),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                            (widget.alertType ==
                                        Constants.ALERT_PAT_LIMIT_ANOMALIES ||
                                    widget.alertType ==
                                        Constants
                                            .ALERT_PAT_LIMIT_RECOMMENDATION)
                                ? patAnomalyInformation(context)
                                : anomalyInfomation(context),
                          ]),
                    ),
                  ),
                  ((widget.alertListDataDTO != null &&
                              Utils.isNotEmpty(
                                  widget.alertListDataDTO!.status) &&
                              widget.alertListDataDTO!.status ==
                                  Constants.ALERT_ACC_ACTUAL) ||
                          (widget.alertStatisticsDataDTO != null &&
                              Utils.isNotEmpty(
                                  widget.alertStatisticsDataDTO!.status) &&
                              widget.alertStatisticsDataDTO!.status ==
                                  Constants.ALERT_ACC_ACTUAL))
                      ? Container(
                          margin: EdgeInsets.only(left: 17, top: 26, right: 17),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    String allowRowKeys = '';
                                    if (widget.alertListDataDTO != null) {
                                      allowRowKeys =
                                          widget.alertListDataDTO!.alertRowKey!;
                                    } else {
                                      allowRowKeys = widget
                                          .alertStatisticsDataDTO!.alertRowKey!;
                                    }
                                    final navResult = await Navigator.pushNamed(
                                        context, AppRoutes.dismissCase,
                                        arguments: AlertArguments(
                                            alertRowKeys: allowRowKeys));

                                    if (navResult != null) {
                                      Navigator.pop(context, true);
                                    }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: AppColors.appDismissColor(),
                                            width: 2)),
                                    height: 40,
                                    width: 163,
                                    padding: EdgeInsets.only(top: 10),
                                    child: Text(
                                      Utils.getTranslated(
                                          context, 'alertDismiss')!,
                                      style: AppFonts.robotoMedium(14,
                                          color: AppColors.appDismissColor(),
                                          decoration: TextDecoration.none),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    final navResult = await Navigator.pushNamed(
                                        context, AppRoutes.disposeORcreateCase,
                                        arguments: AlertArguments(
                                            alertRowKeys: widget
                                                        .alertListDataDTO !=
                                                    null
                                                ? widget.alertListDataDTO!
                                                    .alertRowKey
                                                : widget.alertStatisticsDataDTO !=
                                                        null
                                                    ? widget
                                                        .alertStatisticsDataDTO!
                                                        .alertRowKey
                                                    : ''));
                                    if (navResult != null &&
                                        navResult as bool) {
                                      Navigator.pop(context, true);
                                    }
                                  },
                                  child: Container(
                                    color: AppColors.appPrimaryYellow(),
                                    height: 40,
                                    width: 163,
                                    padding: EdgeInsets.only(top: 10),
                                    child: Text(
                                      Utils.getTranslated(
                                          context, 'case_create')!,
                                      style: AppFonts.robotoMedium(14,
                                          color: AppColors.appPrimaryWhite(),
                                          decoration: TextDecoration.none),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                )
                              ]),
                        )
                      : Container(),
                ],
              ),
      ),
    );
  }

  Widget alertInfo(BuildContext ctx) {
    if (widget.alertListDataDTO != null) {
      return Container(
        padding: EdgeInsets.fromLTRB(14, 14, 15, 20),
        color: theme_dark!
            ? AppColors.appBlackLight()
            : AppColorsLightMode.appGreyF0(),
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
                          Utils.getTranslated(context, 'alert_timestamp')!,
                          style: AppFonts.robotoRegular(
                            13,
                            color: theme_dark!
                                ? AppColors.appGreyB1()
                                : AppColorsLightMode.appGrey77(),
                            decoration: TextDecoration.none,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          DateFormat("dd MMM yyyy, HH:mm:ss").format(
                              DateFormat("yyyy-MM-ddTHH:mm:ssZ").parseUTC(
                                  widget.alertListDataDTO!.timestamp!)),
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
                    Visibility(
                      visible: Utils.isNotEmpty(
                          widget.alertListDataDTO!.alertSeverity),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          height: 20,
                          padding: EdgeInsets.only(top: 3, right: 10, left: 10),
                          decoration: BoxDecoration(
                              color: getTagColor(
                                  widget.alertListDataDTO!.alertSeverity),
                              borderRadius: BorderRadius.circular(2)),
                          child: Text(
                            Utils.isNotEmpty(
                                    widget.alertListDataDTO!.alertSeverity)
                                ? widget.alertListDataDTO!.alertSeverity!
                                : 'Other',
                            style: AppFonts.robotoMedium(
                              12,
                              color: Utils.isNotEmpty(
                                      widget.alertListDataDTO!.alertSeverity)
                                  ? AppColors.appGreyDE()
                                  : AppColors.appBlackLight(),
                              decoration: TextDecoration.none,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
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
                        Utils.isNotEmpty(widget.alertListDataDTO!.alertIdName)
                            ? widget.alertListDataDTO!.alertIdName!
                            : '-',
                        style: AppFonts.robotoMedium(
                          13,
                          color: theme_dark!
                              ? AppColors.appPrimaryWhite()
                              : AppColorsLightMode.appGrey(),
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ]),
              ),
              SizedBox(height: 20),
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
                        Utils.isNotEmpty(widget.alertListDataDTO!.equipmentName)
                            ? widget.alertListDataDTO!.equipmentName!
                            : '-',
                        style: AppFonts.robotoMedium(
                          13,
                          color: theme_dark!
                              ? AppColors.appPrimaryWhite()
                              : AppColorsLightMode.appGrey(),
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ]),
              ),
              SizedBox(height: 20),
              Container(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Utils.getTranslated(context, 'alert_project')!,
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
                        widget.alertListDataDTO!.projectId!,
                        style: AppFonts.robotoMedium(
                          13,
                          color: theme_dark!
                              ? AppColors.appPrimaryWhite()
                              : AppColorsLightMode.appGrey(),
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ]),
              ),
              SizedBox(height: 20),
              Container(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Utils.getTranslated(context, 'alert_scoring')!,
                        style: AppFonts.robotoRegular(
                          13,
                          color: theme_dark!
                              ? AppColors.appGreyB1()
                              : AppColorsLightMode.appGrey77(),
                          decoration: TextDecoration.none,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        Utils.isNotEmpty(widget.alertListDataDTO!.alertScoring)
                            ? widget.alertListDataDTO!.alertScoring!
                            : "-",
                        style: AppFonts.robotoMedium(
                          13,
                          color: theme_dark!
                              ? AppColors.appPrimaryWhite()
                              : AppColorsLightMode.appGrey(),
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ]),
              ),
              SizedBox(height: 20),
              //scoring
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
                      SizedBox(height: 10),
                      Text(
                        widget.alertListDataDTO!.status!,
                        style: AppFonts.robotoMedium(
                          13,
                          color: theme_dark!
                              ? AppColors.appPrimaryWhite()
                              : AppColorsLightMode.appGrey(),
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ]),
              ),
              SizedBox(height: 20),
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
                      SizedBox(height: 10),
                      Text(
                        widget.alertListDataDTO!.event!,
                        style: AppFonts.robotoMedium(
                          13,
                          color: theme_dark!
                              ? AppColors.appPrimaryWhite()
                              : AppColorsLightMode.appGrey(),
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ]),
              ),
            ]),
      );
    } else if (widget.alertStatisticsDataDTO != null) {
      return Container(
        padding: EdgeInsets.fromLTRB(14, 14, 15, 20),
        color: theme_dark!
            ? AppColors.appBlackLight()
            : AppColorsLightMode.appGreyF0(),
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
                          Utils.getTranslated(context, 'alert_timestamp')!,
                          style: AppFonts.robotoRegular(
                            13,
                            color: theme_dark!
                                ? AppColors.appGreyB1()
                                : AppColorsLightMode.appGrey77(),
                            decoration: TextDecoration.none,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          DateFormat("dd MMM yyyy, HH:mm:ss").format(
                              DateFormat("yyyy-MM-ddTHH:mm:ssZ").parseUTC(
                                  widget.alertStatisticsDataDTO!.timestamp!)),
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
                    Visibility(
                      visible: Utils.isNotEmpty(
                          widget.alertStatisticsDataDTO!.alertSeverity),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          height: 20,
                          padding: EdgeInsets.only(top: 3, right: 10, left: 10),
                          decoration: BoxDecoration(
                              color: getTagColor(
                                  widget.alertStatisticsDataDTO!.alertSeverity),
                              borderRadius: BorderRadius.circular(2)),
                          child: Text(
                            Utils.isNotEmpty(widget
                                    .alertStatisticsDataDTO!.alertSeverity)
                                ? widget.alertStatisticsDataDTO!.alertSeverity!
                                : 'Other',
                            style: AppFonts.robotoMedium(
                              12,
                              color: Utils.isNotEmpty(widget
                                      .alertStatisticsDataDTO!.alertSeverity)
                                  ? AppColors.appGreyDE()
                                  : AppColors.appBlackLight(),
                              decoration: TextDecoration.none,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
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
                        Utils.isNotEmpty(
                                widget.alertStatisticsDataDTO!.alertIdName)
                            ? widget.alertStatisticsDataDTO!.alertIdName!
                            : '-',
                        style: AppFonts.robotoMedium(
                          13,
                          color: theme_dark!
                              ? AppColors.appPrimaryWhite()
                              : AppColorsLightMode.appGrey(),
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ]),
              ),
              SizedBox(height: 20),
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
                        widget.alertStatisticsDataDTO!.equipmentName!,
                        style: AppFonts.robotoMedium(
                          13,
                          color: theme_dark!
                              ? AppColors.appPrimaryWhite()
                              : AppColorsLightMode.appGrey(),
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ]),
              ),
              SizedBox(height: 20),
              Container(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Utils.getTranslated(context, 'alert_project')!,
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
                        widget.alertStatisticsDataDTO!.projectId!,
                        style: AppFonts.robotoMedium(
                          13,
                          color: theme_dark!
                              ? AppColors.appPrimaryWhite()
                              : AppColorsLightMode.appGrey(),
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ]),
              ),
              SizedBox(height: 20),
              Container(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Utils.getTranslated(context, 'alert_scoring')!,
                        style: AppFonts.robotoRegular(
                          13,
                          color: theme_dark!
                              ? AppColors.appGreyB1()
                              : AppColorsLightMode.appGrey77(),
                          decoration: TextDecoration.none,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        Utils.isNotEmpty(
                                widget.alertStatisticsDataDTO!.alertScoring)
                            ? widget.alertStatisticsDataDTO!.alertScoring!
                            : "-",
                        style: AppFonts.robotoMedium(
                          13,
                          color: theme_dark!
                              ? AppColors.appPrimaryWhite()
                              : AppColorsLightMode.appGrey(),
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ]),
              ),
              SizedBox(height: 20),
              //scoring
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
                      SizedBox(height: 10),
                      Text(
                        widget.alertStatisticsDataDTO!.status!,
                        style: AppFonts.robotoMedium(
                          13,
                          color: theme_dark!
                              ? AppColors.appPrimaryWhite()
                              : AppColorsLightMode.appGrey(),
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ]),
              ),
              SizedBox(height: 20),
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
                      SizedBox(height: 10),
                      Text(
                        widget.alertStatisticsDataDTO!.event!,
                        style: AppFonts.robotoMedium(
                          13,
                          color: theme_dark!
                              ? AppColors.appPrimaryWhite()
                              : AppColorsLightMode.appGrey(),
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ]),
              ),
            ]),
      );
    }

    return Container();
  }

  Widget anomalyInfomation(BuildContext ctx) {
    if (this.fixtureMaintenanceDTO.data != null &&
        this.fixtureMaintenanceDTO.data!.length > 0) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List<Widget>.generate(
            this.fixtureMaintenanceDTO.data!.length <
                    ((pageNo * pageSize) + pageSize)
                ? this.fixtureMaintenanceDTO.data!.length
                : ((pageNo * pageSize) + pageSize), (index) {
          return dataItem(ctx, this.fixtureMaintenanceDTO.data![index]);
        }),
      );
    }

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

  patAnomalyInformation(BuildContext ctx) {
    if (this.alertPatAnomaliesDTO != null &&
        this.alertPatAnomaliesDTO!.data!.length > 0) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List<Widget>.generate(
            this.alertPatAnomaliesDTO!.data!.length <
                    ((pageNo * pageSize) + pageSize)
                ? this.alertPatAnomaliesDTO!.data!.length
                : ((pageNo * pageSize) + pageSize), (index) {
          return patAnomaliesDataItem(
              ctx, this.alertPatAnomaliesDTO!.data![index]);
        }),
      );
    }

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

  getRoute(tag) {
    if (tag == 'Anomaly') {
      return Navigator.pushNamed(context, AppRoutes.alertADChart);
    } else
      return null;
  }

  Widget dataItem(BuildContext ctx, AlertFixtureMaintenanceDataDTO dataDTO) {
    return GestureDetector(
      onTap: () {
        // getRoute(e.tag!);
        Navigator.pushNamed(context, AppRoutes.alertADChart,
            arguments: AlertArguments(
                fixtureMaintenanceDataDTO: dataDTO,
                testName: dataDTO.testName!));
      },
      child: Container(
        height: 73,
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.only(left: 17, top: 0),
        decoration: BoxDecoration(
            color: theme_dark!
                ? AppColors.appBlackLight()
                : AppColorsLightMode.appGreyF0(),
            borderRadius: BorderRadius.circular(8)),
        child: Row(children: [
          Text(
            (Utils.isNotEmpty(dataDTO.anomalyType))
                ? dataDTO.anomalyType!
                : 'Component',
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
              color: AppColors.appGrey70(),
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
        margin: EdgeInsets.only(bottom: 12),
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
              color: AppColors.appGrey70(),
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

  void showDownloadCsvPopup(BuildContext context) {
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

                String name = "analog.csv";

                final result =
                    await CSVApi.generateCSV(fixtureMaintenanceDTO.data!, name);
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
