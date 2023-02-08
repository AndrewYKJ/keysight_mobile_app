import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:keysight_pma/cache/appcache.dart';
import 'package:keysight_pma/const/appcolors.dart';
import 'package:keysight_pma/const/appfonts.dart';
import 'package:keysight_pma/const/constants.dart';
import 'package:keysight_pma/const/utils.dart';
import 'package:keysight_pma/model/alert/alert_casehistory.dart';
import 'package:keysight_pma/model/alert/alert_detail.dart';
import 'package:keysight_pma/model/alert/alert_recentList.dart';
import 'package:keysight_pma/model/alert/alert_review_data.dart';
import 'package:keysight_pma/model/alert/alert_statistics.dart';
import 'package:keysight_pma/model/alertPreferencemodel.dart';
import 'package:keysight_pma/model/arguments/alert_routeTitle.dart';
import 'package:keysight_pma/model/arguments/dqm_argument.dart';
import 'package:keysight_pma/model/customize.dart';
import 'package:keysight_pma/model/dqm/anomaly_company.dart';
import 'package:keysight_pma/model/dqm/test_result_cpk_analog.dart';
import 'package:keysight_pma/model/dqm/test_result_cpk_pins.dart';
import 'package:keysight_pma/model/sortAndFilter/equipment.dart';
import 'package:keysight_pma/model/sortAndFilter/projects.dart';
import 'package:keysight_pma/model/updateUserPrefModel.dart';
import 'package:keysight_pma/model/user.dart';
import 'package:keysight_pma/routes/approutes.dart';

class SearchPage extends StatefulWidget {
  final List<ProjectDataDTO>? projectList;
  final List<EquipmentDataDTO>? equipmentList;
  final List<CustomDqmSortFilterProjectsDTO>? customSFProjectList;
  final List<TestResultCpkAnalogDataDTO>? analogList;
  final List<TestResultCpkPinsShortsTestJetDataDTO>? pinList;
  final List<TestResultCpkPinsShortsTestJetDataDTO>? shortsList;
  final List<TestResultCpkPinsShortsTestJetDataDTO>? vtepList;
  final List<TestResultCpkPinsShortsTestJetDataDTO>? xVtepList;
  final List<TestResultCpkPinsShortsTestJetDataDTO>? functionalList;
  final List<AnomalyCompanyDataDTO>? rmaAnomalyList;
  final List<AlertListDataDTO>? alertInfoList;
  final List<AlertStatisticsDataDTO>? preferedASList;
  final List<AlertCaseHistoryDataDTO>? caseHistoryList;
  final List<AlertDetailHistoriesDTO>? caseHistoryCommentList;
  final List<AlertRecentModel>? notificationList;
  final List<CustomerMapDataDTO>? customerMapData;
  final List<AlertPreferenceGroupDataDTO>? groupList;
  final List<SiteLoadProjectDataDTO>? siteProjectListDataDTO;
  const SearchPage(
      {Key? key,
      this.projectList,
      this.equipmentList,
      this.groupList,
      this.customSFProjectList,
      this.analogList,
      this.pinList,
      this.shortsList,
      this.vtepList,
      this.xVtepList,
      this.functionalList,
      this.rmaAnomalyList,
      this.alertInfoList,
      this.caseHistoryCommentList,
      this.preferedASList,
      this.caseHistoryList,
      this.notificationList,
      this.customerMapData,
      this.siteProjectListDataDTO})
      : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPage();
}

class _SearchPage extends State<SearchPage> {
  FocusNode _myTextFieldFocusNode = FocusNode();
  TextEditingController searchEditController = TextEditingController();
  List<ProjectDataDTO> scProjectList = [];
  List<EquipmentDataDTO> scEquipmentList = [];
  List<CustomDqmSortFilterProjectsDTO> scCustomSFProjectList = [];
  List<TestResultCpkAnalogDataDTO> scAnalogList = [];
  List<TestResultCpkPinsShortsTestJetDataDTO> scPinList = [];
  List<TestResultCpkPinsShortsTestJetDataDTO> scShortsList = [];
  List<TestResultCpkPinsShortsTestJetDataDTO> scVtepList = [];
  List<TestResultCpkPinsShortsTestJetDataDTO> scXvtepList = [];
  List<TestResultCpkPinsShortsTestJetDataDTO> scFunctionalList = [];
  List<AnomalyCompanyDataDTO> scRmaAnomalyList = [];
  List<AlertListDataDTO> scAlertInfoList = [];
  List<AlertStatisticsDataDTO> scPreferedASList = [];
  List<AlertCaseHistoryDataDTO> scCaseHistoryList = [];
  List<AlertDetailHistoriesDTO> scCaseHistoryCommentList = [];
  List<AlertRecentModel>? scNotificationList = [];
  List<CustomerMapDataDTO>? sccustomerMapData = [];
  List<SiteLoadProjectDataDTO>? scSiteProjectListDataDTO = [];

  List<AlertPreferenceGroupDataDTO>? scgroupList = [];

  bool isLoading = false;

  bool? themeDark = AppCache.sortFilterCacheDTO!.currentTheme!;

  @override
  void initState() {
    super.initState();
    Utils.setFirebaseAnalyticsCurrentScreen(
        Constants.ANALYTICS_SEARCH_DASHBOARD);
  }

  @override
  void dispose() {
    _myTextFieldFocusNode.dispose();
    searchEditController.dispose();
    super.dispose();
  }

  getTagColor(tag) {
    if (tag == 'Critical')
      return AppColors.appRedE9();
    else if (tag == 'High')
      return AppColors.appRedE9();
    else if (tag == 'Medium')
      return AppColors.appPrimaryOrange();
    else if (tag == 'Low')
      return AppColors.appPrimaryYellow();
    else if (tag == "None")
      return AppColors.appGreen60();
    else
      return Colors.transparent;
  }

  pushRoutebySender(
      BuildContext ctx, String? sender, AlertCaseHistoryDataDTO data) {
    if (sender == "DUTPatLimitRecommendation") {
      Navigator.pushNamed(context, AppRoutes.casehistoryPatRecommend,
          arguments: AlertArguments(
            appBarTitle: Utils.getTranslated(context,
                'senderPATRecommendation')!, //Utils.getTranslated(context, 'alert_information'),
            caseHistoryData: data,
          ));
    } else if (sender == "DUTLimitChangeAnomaly") {
      Navigator.pushNamed(context, AppRoutes.casehistoryLimitChangeAnomaly,
          arguments: AlertArguments(
            appBarTitle: Utils.getTranslated(context,
                'senderLimitChangeAnomaly')!, //Utils.getTranslated(context, 'alert_information'),
            caseHistoryData: data,
          ));
    } else if (sender == "ConsecutiveTestFailure") {
      AppCache.sortFilterCacheDTO!.preferredCompany = data.companyId!;
      AppCache.sortFilterCacheDTO!.preferredSite = data.siteId!;
      AppCache.sortFilterCacheDTO!.preferredProjectId = data.projectId;
      AppCache.sortFilterCacheDTO!.startDate =
          DateFormat("yyyy-MM-dd").parse(data.startDate!);
      AppCache.sortFilterCacheDTO!.endDate =
          DateFormat("yyyy-MM-dd").parse(data.endDate!);
      Navigator.pop(ctx, true);
    } else if (sender == "DUTCpkAlertAnomalies") {
      Navigator.pushNamed(context, AppRoutes.alertCPKDetails,
          arguments: AlertArguments(
            appBarTitle: Utils.getTranslated(context,
                'senderCPKInformation')!, //Utils.getTranslated(context, 'alert_information'),
            caseHistoryData: data,
          ));
    } else if (sender == "DUTDegradationAnomaly" ||
        sender == "DUTComponentAnomaly") {
      Navigator.pushNamed(context, AppRoutes.casehistoryDegradationAnomaly,
          arguments: AlertArguments(
            appBarTitle: Utils.getTranslated(context,
                'senderDegradationAnomaly')!, //Utils.getTranslated(context, 'alert_information'),
            caseHistoryData: data,
          ));
    } else if (sender == Constants.ALERT_PAT_LIMIT_ANOMALIES) {
      Navigator.pushNamed(context, AppRoutes.alertPatAnomaliesRoute,
          arguments: AlertArguments(
            caseHistoryData: data,
          ));
    } else {
      Navigator.pushNamed(context, AppRoutes.casehistoryOthers,
          arguments: AlertArguments(
            appBarTitle: Utils.getTranslated(context,
                'senderOthers')!, //Utils.getTranslated(context, 'alert_information'),
            caseHistoryData: data,
          ));
    }
  }

  bool? theme_dark = AppCache.sortFilterCacheDTO!.currentTheme;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(
                    top: 18, left: 16.0, right: 16.0, bottom: 21.0),
                height: 78,
                color: theme_dark!
                    ? AppColors.serverAppBar()
                    : AppColorsLightMode.serverAppBar(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        decoration: BoxDecoration(
                            color:
                                AppColors.appSearchBarGrey().withOpacity(0.24),
                            border: Border.all(
                                color: theme_dark!
                                    ? AppColors.appSearchBarGrey()
                                        .withOpacity(0.24)
                                    : AppColors.appSearchBarGrey()
                                        .withOpacity(0.24)),
                            borderRadius: BorderRadius.circular(14)),
                        child: Focus(
                          // onFocusChange: (hasFocus) => !hasFocus
                          //     ? _myTextFieldFocusNode.requestFocus()
                          //     : null,
                          child: TextField(
                            controller: searchEditController,
                            autofocus: true,
                            focusNode: _myTextFieldFocusNode,
                            textInputAction: TextInputAction.search,
                            onChanged: (value) {
                              setState(() {
                                isLoading = true;
                              });
                            },
                            onSubmitted: (value) {
                              if (!_myTextFieldFocusNode.hasPrimaryFocus) {
                                _myTextFieldFocusNode.unfocus();
                              }

                              if (widget.projectList != null) {
                                setState(() {
                                  this.scProjectList.clear();
                                  this.scProjectList = widget.projectList!
                                      .where((element) => element.projectId!
                                          .toLowerCase()
                                          .contains(value.toLowerCase()))
                                      .toList();
                                  isLoading = false;
                                });
                              } else if (widget.equipmentList != null) {
                                setState(() {
                                  this.scEquipmentList.clear();
                                  this.scEquipmentList = widget.equipmentList!
                                      .where((element) => element.equipmentId!
                                          .toLowerCase()
                                          .contains(value.toLowerCase()))
                                      .toList();
                                  isLoading = false;
                                });
                              } else if (widget.customSFProjectList != null) {
                                setState(() {
                                  this.scCustomSFProjectList.clear();
                                  this.scCustomSFProjectList = widget
                                      .customSFProjectList!
                                      .where((element) => element.projectId!
                                          .toLowerCase()
                                          .contains(value.toLowerCase()))
                                      .toList();
                                  isLoading = false;
                                });
                              } else if (widget.analogList != null) {
                                setState(() {
                                  this.scAnalogList.clear();
                                  this.scAnalogList =
                                      widget.analogList!.where((element) {
                                    if (element.testName!
                                        .toLowerCase()
                                        .contains(value.toLowerCase())) {
                                      return true;
                                    } else if (element.testType!
                                        .toLowerCase()
                                        .contains(value.toLowerCase())) {
                                      return true;
                                    } else if (element.cpk != null &&
                                        element.cpk
                                            .toString()
                                            .toLowerCase()
                                            .contains(value.toLowerCase())) {
                                      return true;
                                    } else if (Utils.isNotEmpty(element.mean) &&
                                        element.mean!
                                            .toLowerCase()
                                            .contains(value.toLowerCase())) {
                                      return true;
                                    } else if (element.stdDeviation != null &&
                                        element.stdDeviation
                                            .toString()
                                            .toLowerCase()
                                            .contains(value.toLowerCase())) {
                                      return true;
                                    } else if (element.nominal != null &&
                                        element.nominal
                                            .toString()
                                            .toLowerCase()
                                            .contains(value.toLowerCase())) {
                                      return true;
                                    } else if (Utils.isNotEmpty(
                                            element.lowerLimit) &&
                                        element.lowerLimit!
                                            .toLowerCase()
                                            .contains(value.toLowerCase())) {
                                      return true;
                                    } else if (Utils.isNotEmpty(
                                            element.upperLimit) &&
                                        element.upperLimit!
                                            .toLowerCase()
                                            .contains(value.toLowerCase())) {
                                      return true;
                                    } else if (element.threshold != null &&
                                        element.threshold
                                            .toString()
                                            .toLowerCase()
                                            .contains(value.toLowerCase())) {
                                      return true;
                                    } else if (element.tolerance_negative !=
                                            null &&
                                        element.tolerance_negative
                                            .toString()
                                            .toLowerCase()
                                            .contains(value.toLowerCase())) {
                                      return true;
                                    } else if (element.tolerance_positive !=
                                            null &&
                                        element.tolerance_positive
                                            .toString()
                                            .toLowerCase()
                                            .contains(value.toLowerCase())) {
                                      return true;
                                    } else if (element.failureCount != null &&
                                        element.failureCount
                                            .toString()
                                            .toLowerCase()
                                            .contains(value.toLowerCase())) {
                                      return true;
                                    }

                                    return false;
                                  }).toList();
                                  isLoading = false;
                                });
                              } else if (widget.pinList != null) {
                                setState(() {
                                  this.scPinList.clear();
                                  this.scPinList =
                                      widget.pinList!.where((element) {
                                    if (element.testName!
                                        .toLowerCase()
                                        .contains(value.toLowerCase())) {
                                      return true;
                                    } else if (element.testType!
                                        .toLowerCase()
                                        .contains(value.toLowerCase())) {
                                      return true;
                                    } else if (element.cpk != null &&
                                        element.cpk
                                            .toString()
                                            .toLowerCase()
                                            .contains(value.toLowerCase())) {
                                      return true;
                                    } else if (Utils.isNotEmpty(element.mean) &&
                                        element.mean!
                                            .toLowerCase()
                                            .contains(value.toLowerCase())) {
                                      return true;
                                    } else if (element.stdDeviation != null &&
                                        element.stdDeviation
                                            .toString()
                                            .toLowerCase()
                                            .contains(value.toLowerCase())) {
                                      return true;
                                    } else if (element.min != null &&
                                        element.min!
                                            .toString()
                                            .toLowerCase()
                                            .contains(value.toLowerCase())) {
                                      return true;
                                    } else if (element.max != null &&
                                        element.max!
                                            .toString()
                                            .toLowerCase()
                                            .contains(value.toLowerCase())) {
                                      return true;
                                    } else if (element.threshold != null &&
                                        element.threshold
                                            .toString()
                                            .toLowerCase()
                                            .contains(value.toLowerCase())) {
                                      return true;
                                    } else if (element.failureCount != null &&
                                        element.failureCount
                                            .toString()
                                            .toLowerCase()
                                            .contains(value.toLowerCase())) {
                                      return true;
                                    }
                                    return false;
                                  }).toList();
                                  isLoading = false;
                                });
                              } else if (widget.shortsList != null) {
                                setState(() {
                                  this.scShortsList.clear();
                                  this.scShortsList =
                                      widget.shortsList!.where((element) {
                                    if (element.testName!
                                        .toLowerCase()
                                        .contains(value.toLowerCase())) {
                                      return true;
                                    } else if (element.testType!
                                        .toLowerCase()
                                        .contains(value.toLowerCase())) {
                                      return true;
                                    } else if (element.cpk != null &&
                                        element.cpk
                                            .toString()
                                            .toLowerCase()
                                            .contains(value.toLowerCase())) {
                                      return true;
                                    } else if (Utils.isNotEmpty(element.mean) &&
                                        element.mean!
                                            .toLowerCase()
                                            .contains(value.toLowerCase())) {
                                      return true;
                                    } else if (element.stdDeviation != null &&
                                        element.stdDeviation
                                            .toString()
                                            .toLowerCase()
                                            .contains(value.toLowerCase())) {
                                      return true;
                                    } else if (element.min != null &&
                                        element.min!
                                            .toString()
                                            .toLowerCase()
                                            .contains(value.toLowerCase())) {
                                      return true;
                                    } else if (element.max != null &&
                                        element.max!
                                            .toString()
                                            .toLowerCase()
                                            .contains(value.toLowerCase())) {
                                      return true;
                                    } else if (element.threshold != null &&
                                        element.threshold
                                            .toString()
                                            .toLowerCase()
                                            .contains(value.toLowerCase())) {
                                      return true;
                                    } else if (element.failureCount != null &&
                                        element.failureCount
                                            .toString()
                                            .toLowerCase()
                                            .contains(value.toLowerCase())) {
                                      return true;
                                    }
                                    return false;
                                  }).toList();
                                  isLoading = false;
                                });
                              } else if (widget.vtepList != null) {
                                setState(() {
                                  this.scVtepList.clear();
                                  this.scVtepList =
                                      widget.vtepList!.where((element) {
                                    if (element.testName!
                                        .toLowerCase()
                                        .contains(value.toLowerCase())) {
                                      return true;
                                    } else if (element.testType!
                                        .toLowerCase()
                                        .contains(value.toLowerCase())) {
                                      return true;
                                    } else if (element.cpk != null &&
                                        element.cpk
                                            .toString()
                                            .toLowerCase()
                                            .contains(value.toLowerCase())) {
                                      return true;
                                    } else if (Utils.isNotEmpty(element.mean) &&
                                        element.mean!
                                            .toLowerCase()
                                            .contains(value.toLowerCase())) {
                                      return true;
                                    } else if (element.stdDeviation != null &&
                                        element.stdDeviation
                                            .toString()
                                            .toLowerCase()
                                            .contains(value.toLowerCase())) {
                                      return true;
                                    } else if (element.min != null &&
                                        element.min!
                                            .toString()
                                            .toLowerCase()
                                            .contains(value.toLowerCase())) {
                                      return true;
                                    } else if (element.max != null &&
                                        element.max!
                                            .toString()
                                            .toLowerCase()
                                            .contains(value.toLowerCase())) {
                                      return true;
                                    } else if (element.threshold != null &&
                                        element.threshold
                                            .toString()
                                            .toLowerCase()
                                            .contains(value.toLowerCase())) {
                                      return true;
                                    } else if (element.failureCount != null &&
                                        element.failureCount
                                            .toString()
                                            .toLowerCase()
                                            .contains(value.toLowerCase())) {
                                      return true;
                                    }
                                    return false;
                                  }).toList();
                                  isLoading = false;
                                });
                              } else if (widget.xVtepList != null) {
                                setState(() {
                                  this.scXvtepList.clear();
                                  this.scXvtepList =
                                      widget.xVtepList!.where((element) {
                                    if (element.testName!
                                        .toLowerCase()
                                        .contains(value.toLowerCase())) {
                                      return true;
                                    } else if (element.testType!
                                        .toLowerCase()
                                        .contains(value.toLowerCase())) {
                                      return true;
                                    } else if (element.cpk != null &&
                                        element.cpk
                                            .toString()
                                            .toLowerCase()
                                            .contains(value.toLowerCase())) {
                                      return true;
                                    } else if (Utils.isNotEmpty(element.mean) &&
                                        element.mean!
                                            .toLowerCase()
                                            .contains(value.toLowerCase())) {
                                      return true;
                                    } else if (element.stdDeviation != null &&
                                        element.stdDeviation
                                            .toString()
                                            .toLowerCase()
                                            .contains(value.toLowerCase())) {
                                      return true;
                                    } else if (element.min != null &&
                                        element.min!
                                            .toString()
                                            .toLowerCase()
                                            .contains(value.toLowerCase())) {
                                      return true;
                                    } else if (element.max != null &&
                                        element.max!
                                            .toString()
                                            .toLowerCase()
                                            .contains(value.toLowerCase())) {
                                      return true;
                                    } else if (element.threshold != null &&
                                        element.threshold
                                            .toString()
                                            .toLowerCase()
                                            .contains(value.toLowerCase())) {
                                      return true;
                                    } else if (element.failureCount != null &&
                                        element.failureCount
                                            .toString()
                                            .toLowerCase()
                                            .contains(value.toLowerCase())) {
                                      return true;
                                    }
                                    return false;
                                  }).toList();
                                  isLoading = false;
                                });
                              } else if (widget.functionalList != null) {
                                setState(() {
                                  this.scFunctionalList.clear();
                                  this.scFunctionalList =
                                      widget.functionalList!.where((element) {
                                    if (element.testName!
                                        .toLowerCase()
                                        .contains(value.toLowerCase())) {
                                      return true;
                                    } else if (element.testType!
                                        .toLowerCase()
                                        .contains(value.toLowerCase())) {
                                      return true;
                                    } else if (element.cpk != null &&
                                        element.cpk
                                            .toString()
                                            .toLowerCase()
                                            .contains(value.toLowerCase())) {
                                      return true;
                                    } else if (Utils.isNotEmpty(element.mean) &&
                                        element.mean!
                                            .toLowerCase()
                                            .contains(value.toLowerCase())) {
                                      return true;
                                    } else if (element.stdDeviation != null &&
                                        element.stdDeviation
                                            .toString()
                                            .toLowerCase()
                                            .contains(value.toLowerCase())) {
                                      return true;
                                    } else if (element.min != null &&
                                        element.min!
                                            .toString()
                                            .toLowerCase()
                                            .contains(value.toLowerCase())) {
                                      return true;
                                    } else if (element.max != null &&
                                        element.max!
                                            .toString()
                                            .toLowerCase()
                                            .contains(value.toLowerCase())) {
                                      return true;
                                    } else if (element.threshold != null &&
                                        element.threshold
                                            .toString()
                                            .toLowerCase()
                                            .contains(value.toLowerCase())) {
                                      return true;
                                    } else if (element.failureCount != null &&
                                        element.failureCount
                                            .toString()
                                            .toLowerCase()
                                            .contains(value.toLowerCase())) {
                                      return true;
                                    }
                                    return false;
                                  }).toList();
                                  isLoading = false;
                                });
                              } else if (widget.rmaAnomalyList != null) {
                                setState(() {
                                  this.scRmaAnomalyList.clear();
                                  this.scRmaAnomalyList =
                                      widget.rmaAnomalyList!.where((element) {
                                    if (element.fixtureId!
                                        .toLowerCase()
                                        .contains(value.toLowerCase())) {
                                      return true;
                                    } else if (element.equipmentId!
                                        .toLowerCase()
                                        .contains(value.toLowerCase())) {
                                      return true;
                                    } else if (element.projectId!
                                        .toLowerCase()
                                        .contains(value.toLowerCase())) {
                                      return true;
                                    } else if (element.status!
                                        .toLowerCase()
                                        .contains(value.toLowerCase())) {
                                      return true;
                                    }
                                    return false;
                                  }).toList();
                                  isLoading = false;
                                });
                              } else if (widget.alertInfoList != null) {
                                setState(() {
                                  this.scAlertInfoList.clear();
                                  this.scAlertInfoList =
                                      widget.alertInfoList!.where((element) {
                                    if (Utils.isNotEmpty(element.alertIdName) &&
                                        element.alertIdName!.contains(value)) {
                                      return true;
                                    } else if (Utils.isNotEmpty(
                                            element.equipmentId) &&
                                        element.equipmentId!
                                            .toLowerCase()
                                            .contains(value.toLowerCase())) {
                                      return true;
                                    } else if (Utils.isNotEmpty(
                                            element.projectId) &&
                                        element.projectId!
                                            .toLowerCase()
                                            .contains(value.toLowerCase())) {
                                      return true;
                                    } else if (Utils.isNotEmpty(
                                            element.alertSeverity) &&
                                        element.alertSeverity!
                                            .toLowerCase()
                                            .contains(value.toLowerCase())) {
                                      return true;
                                    } else if (Utils.isNotEmpty(
                                            element.status) &&
                                        element.status!
                                            .toLowerCase()
                                            .contains(value.toLowerCase())) {
                                      return true;
                                    } else if (Utils.isNotEmpty(
                                            element.event) &&
                                        element.event!
                                            .toLowerCase()
                                            .contains(value.toLowerCase())) {
                                      return true;
                                    }
                                    return false;
                                  }).toList();
                                  isLoading = false;
                                });
                              } else if (widget.preferedASList != null) {
                                setState(() {
                                  this.scPreferedASList.clear();
                                  this.scPreferedASList =
                                      widget.preferedASList!.where((element) {
                                    if (Utils.isNotEmpty(element.alertIdName) &&
                                        element.alertIdName!.contains(value)) {
                                      return true;
                                    } else if (Utils.isNotEmpty(
                                            element.equipmentId) &&
                                        element.equipmentId!
                                            .toLowerCase()
                                            .contains(value.toLowerCase())) {
                                      return true;
                                    } else if (Utils.isNotEmpty(
                                            element.projectId) &&
                                        element.projectId!
                                            .toLowerCase()
                                            .contains(value.toLowerCase())) {
                                      return true;
                                    } else if (Utils.isNotEmpty(
                                            element.alertSeverity) &&
                                        element.alertSeverity!
                                            .toLowerCase()
                                            .contains(value.toLowerCase())) {
                                      return true;
                                    } else if (Utils.isNotEmpty(
                                            element.status) &&
                                        element.status!
                                            .toLowerCase()
                                            .contains(value.toLowerCase())) {
                                      return true;
                                    } else if (Utils.isNotEmpty(
                                            element.event) &&
                                        element.event!
                                            .toLowerCase()
                                            .contains(value.toLowerCase())) {
                                      return true;
                                    }
                                    return false;
                                  }).toList();
                                  isLoading = false;
                                });
                              } else if (widget.caseHistoryList != null) {
                                setState(() {
                                  this.scCaseHistoryList.clear();
                                  this.scCaseHistoryList =
                                      widget.caseHistoryList!.where((element) {
                                    if (Utils.isNotEmpty(element.alertIdName) &&
                                        element.alertIdName!.contains(value)) {
                                      return true;
                                    } else if (Utils.isNotEmpty(
                                            element.alertIdName) &&
                                        element.alertIdName!
                                            .toLowerCase()
                                            .contains(value.toLowerCase())) {
                                      return true;
                                    } else if (Utils.isNotEmpty(
                                            element.equipmentId) &&
                                        element.equipmentId!
                                            .toLowerCase()
                                            .contains(value.toLowerCase())) {
                                      return true;
                                    } else if (Utils.isNotEmpty(
                                            element.projectId) &&
                                        element.projectId!
                                            .toLowerCase()
                                            .contains(value.toLowerCase())) {
                                      return true;
                                    } else if (Utils.isNotEmpty(
                                            element.alertSeverity) &&
                                        element.alertSeverity!
                                            .toLowerCase()
                                            .contains(value.toLowerCase())) {
                                      return true;
                                    } else if (Utils.isNotEmpty(
                                            element.priority) &&
                                        element.priority!
                                            .toLowerCase()
                                            .contains(value.toLowerCase())) {
                                      return true;
                                    } else if (Utils.isNotEmpty(
                                            element.status) &&
                                        element.status!
                                            .toLowerCase()
                                            .contains(value.toLowerCase())) {
                                      return true;
                                    } else if (Utils.isNotEmpty(
                                            element.event) &&
                                        element.event!
                                            .toLowerCase()
                                            .contains(value.toLowerCase())) {
                                      return true;
                                    } else if (Utils.isNotEmpty(
                                            element.workFlow) &&
                                        element.workFlow!
                                            .toLowerCase()
                                            .contains(value.toLowerCase())) {
                                      return true;
                                    } else if (Utils.isNotEmpty(
                                            element.sender) &&
                                        element.sender!
                                            .toLowerCase()
                                            .contains(value.toLowerCase())) {
                                      return true;
                                    }
                                    return false;
                                  }).toList();
                                  isLoading = false;
                                });
                              } else if (widget.caseHistoryCommentList !=
                                  null) {
                                setState(() {
                                  this.scCaseHistoryCommentList.clear();
                                  this.scCaseHistoryCommentList = widget
                                      .caseHistoryCommentList!
                                      .where((element) {
                                    if (Utils.isNotEmpty(element.Id) &&
                                        element.Id!.contains(value)) {
                                      return true;
                                    } else if (Utils.isNotEmpty(
                                            element.message) &&
                                        element.message!
                                            .toLowerCase()
                                            .contains(value.toLowerCase())) {
                                      return true;
                                    } else if (Utils.isNotEmpty(
                                            element.createdByName) &&
                                        element.createdByName!
                                            .toLowerCase()
                                            .contains(value.toLowerCase())) {
                                      return true;
                                    } else if (Utils.isNotEmpty(
                                            element.dateCreated) &&
                                        element.dateCreated!
                                            .toLowerCase()
                                            .contains(value.toLowerCase())) {
                                      return true;
                                    } else if (Utils.isNotEmpty(
                                            element.historyType) &&
                                        element.historyType!
                                            .toLowerCase()
                                            .contains(value.toLowerCase())) {
                                      return true;
                                    }
                                    return false;
                                  }).toList();
                                  isLoading = false;
                                });
                              } else if (widget.notificationList != null) {
                                setState(() {
                                  this.scNotificationList!.clear();
                                  this.scNotificationList =
                                      widget.notificationList!.where((element) {
                                    if (Utils.isNotEmpty(element.alertIdName) &&
                                        element.alertIdName!.contains(value)) {
                                      return true;
                                    } else if (Utils.isNotEmpty(
                                            element.alertIdName) &&
                                        element.alertIdName!
                                            .toLowerCase()
                                            .contains(value.toLowerCase())) {
                                      return true;
                                    } else if (Utils.isNotEmpty(
                                            element.equipmentId) &&
                                        element.equipmentId!
                                            .toLowerCase()
                                            .contains(value.toLowerCase())) {
                                      return true;
                                    } else if (Utils.isNotEmpty(
                                            element.projectId) &&
                                        element.projectId!
                                            .toLowerCase()
                                            .contains(value.toLowerCase())) {
                                      return true;
                                    } else if (Utils.isNotEmpty(
                                            element.alertSeverity) &&
                                        element.alertSeverity!
                                            .toLowerCase()
                                            .contains(value.toLowerCase())) {
                                      return true;
                                    } else if (Utils.isNotEmpty(
                                            element.dateTimestamp) &&
                                        element.dateTimestamp!
                                            .toLowerCase()
                                            .contains(value.toLowerCase())) {
                                      return true;
                                    } else if (Utils.isNotEmpty(
                                            element.status) &&
                                        element.status!
                                            .toLowerCase()
                                            .contains(value.toLowerCase())) {
                                      return true;
                                    } else if (Utils.isNotEmpty(
                                            element.event) &&
                                        element.event!
                                            .toLowerCase()
                                            .contains(value.toLowerCase())) {
                                      return true;
                                    } else if (Utils.isNotEmpty(
                                            element.testName) &&
                                        element.testName!
                                            .toLowerCase()
                                            .contains(value.toLowerCase())) {
                                      return true;
                                    } else if (Utils.isNotEmpty(
                                            element.sender) &&
                                        element.sender!
                                            .toLowerCase()
                                            .contains(value.toLowerCase())) {
                                      return true;
                                    }
                                    return false;
                                  }).toList();
                                  isLoading = false;
                                });
                              } else if (widget.customerMapData != null) {
                                setState(() {
                                  this.sccustomerMapData!.clear();
                                  this.sccustomerMapData =
                                      widget.customerMapData!.where((element) {
                                    if (Utils.isNotEmpty(element.companyName) &&
                                        element.companyName!
                                            .toLowerCase()
                                            .contains(value.toLowerCase())) {
                                      return true;
                                    }
                                    if (Utils.isNotEmpty(element.siteName) &&
                                        element.siteName!
                                            .toLowerCase()
                                            .contains(value.toLowerCase())) {
                                      return true;
                                    }
                                    return false;
                                  }).toList();
                                  isLoading = false;
                                });
                              } else if (widget.groupList != null) {
                                setState(() {
                                  this.scgroupList!.clear();
                                  this.scgroupList =
                                      widget.groupList!.where((element) {
                                    if (Utils.isNotEmpty(
                                            element.groupDescription) &&
                                        element.groupDescription!
                                            .toLowerCase()
                                            .contains(value.toLowerCase())) {
                                      return true;
                                    }
                                    if (Utils.isNotEmpty(element.groupName) &&
                                        element.groupName!
                                            .toLowerCase()
                                            .contains(value.toLowerCase())) {
                                      return true;
                                    }
                                    if (Utils.isNotEmpty(
                                            element.groupOwnerName) &&
                                        element.groupOwnerName!
                                            .toLowerCase()
                                            .contains(value.toLowerCase())) {
                                      return true;
                                    }

                                    return false;
                                  }).toList();
                                  isLoading = false;
                                });
                              } else if (widget.siteProjectListDataDTO !=
                                  null) {
                                setState(() {
                                  this.scSiteProjectListDataDTO!.clear();
                                  this.scSiteProjectListDataDTO = widget
                                      .siteProjectListDataDTO!
                                      .where((element) {
                                    if (Utils.isNotEmpty(
                                            element.projectNameKey) &&
                                        element.projectNameKey!
                                            .toLowerCase()
                                            .contains(value.toLowerCase())) {
                                      return true;
                                    }
                                    if (Utils.isNotEmpty(element.projectId) &&
                                        element.projectId!
                                            .toLowerCase()
                                            .contains(value.toLowerCase())) {
                                      return true;
                                    }

                                    return false;
                                  }).toList();
                                  isLoading = false;
                                });
                              }
                            },
                            style: TextStyle(
                                color: theme_dark!
                                    ? AppColors.appGreyDE()
                                    : AppColorsLightMode.appGrey()),
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                icon: Image.asset(
                                  theme_dark!
                                      ? Constants.ASSET_IMAGES +
                                          'search_icon.png'
                                      : Constants.ASSET_IMAGES_LIGHT +
                                          'search.png',
                                  height: 24,
                                ),
                                hintText:
                                    Utils.getTranslated(context, 'search')!,
                                hintStyle:
                                    TextStyle(color: AppColors.appGreyDE())),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          Utils.getTranslated(context, 'cancel')!,
                          style: AppFonts.robotoMedium(
                            16,
                            color: theme_dark!
                                ? AppColors.appGreyB1()
                                : AppColorsLightMode.appGrey77(),
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 16.0),
              isLoading
                  ? Expanded(
                      child: Container(),
                    )
                  : Expanded(
                      child: itemListing(context),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget itemListing(BuildContext context) {
    if (widget.projectList != null) {
      int index = 0;
      return Container(
        child: ListView(
          shrinkWrap: true,
          children: this
              .scProjectList
              .map((e) => projectItem(context, e, index++))
              .toList(),
        ),
      );
    } else if (widget.equipmentList != null) {
      return Wrap(
        children:
            this.scEquipmentList.map((e) => equipmentItem(context, e)).toList(),
      );
    } else if (widget.customSFProjectList != null) {
      int index = 0;
      return Container(
        child: ListView(
          shrinkWrap: true,
          children: this
              .scCustomSFProjectList
              .map((e) => customProjectItem(context, e, index++))
              .toList(),
        ),
      );
    } else if (widget.analogList != null) {
      return Container(
        child: ListView(
          shrinkWrap: true,
          children:
              this.scAnalogList.map((e) => analogDataItem(context, e)).toList(),
        ),
      );
    } else if (widget.pinList != null) {
      return Container(
        child: ListView(
          shrinkWrap: true,
          children: this.scPinList.map((e) => pinDataItem(context, e)).toList(),
        ),
      );
    } else if (widget.shortsList != null) {
      return Container(
        child: ListView(
          shrinkWrap: true,
          children:
              this.scShortsList.map((e) => shortDataItem(context, e)).toList(),
        ),
      );
    } else if (widget.vtepList != null) {
      return Container(
        child: ListView(
          shrinkWrap: true,
          children:
              this.scVtepList.map((e) => vtepDataItem(context, e)).toList(),
        ),
      );
    } else if (widget.xVtepList != null) {
      return Container(
        child: ListView(
          shrinkWrap: true,
          children:
              this.scXvtepList.map((e) => xvtepDataItem(context, e)).toList(),
        ),
      );
    } else if (widget.functionalList != null) {
      return Container(
        child: ListView(
          shrinkWrap: true,
          children: this
              .scFunctionalList
              .map((e) => funcDataItem(context, e))
              .toList(),
        ),
      );
    } else if (widget.rmaAnomalyList != null) {
      return Container(
        child: ListView(
          shrinkWrap: true,
          children: this
              .scRmaAnomalyList
              .map((e) => rmaTestDataItem(context, e))
              .toList(),
        ),
      );
    } else if (widget.alertInfoList != null) {
      return Container(
        child: ListView(
          shrinkWrap: true,
          children:
              this.scAlertInfoList.map((e) => dataItem(context, e)).toList(),
        ),
      );
    } else if (widget.preferedASList != null) {
      return Container(
        child: ListView(
          shrinkWrap: true,
          children: this
              .scPreferedASList
              .map((e) => preferedDataItem(context, e))
              .toList(),
        ),
      );
    } else if (widget.caseHistoryList != null) {
      return Container(
        child: ListView(
          shrinkWrap: true,
          children: this
              .scCaseHistoryList
              .map((e) => caseHistoryDataItem(context, e))
              .toList(),
        ),
      );
    } else if (widget.caseHistoryCommentList != null) {
      return Container(
        child: ListView(
          shrinkWrap: true,
          children: this
              .scCaseHistoryCommentList
              .map((e) => caseHistoryCommentDataItem(context, e))
              .toList(),
        ),
      );
    } else if (widget.notificationList != null) {
      return Container(
        child: ListView(
          shrinkWrap: true,
          children: this
              .scNotificationList!
              .map((e) => notificationList(context, e))
              .toList(),
        ),
      );
    } else if (widget.customerMapData != null) {
      return Container(
        child: ListView(
          shrinkWrap: true,
          children: this
              .sccustomerMapData!
              .map((e) => preferredSiteDataItem(context, e))
              .toList(),
        ),
      );
    } else if (widget.groupList != null) {
      return Container(
        child: ListView(
          shrinkWrap: true,
          children: this
              .scgroupList!
              .map((e) => alertgroupdataItem(context, e))
              .toList(),
        ),
      );
    } else if (widget.siteProjectListDataDTO != null) {
      int index = 0;
      return Container(
        child: ListView(
          shrinkWrap: true,
          children: this
              .scSiteProjectListDataDTO!
              .map((e) => preferredSettingProjectListData(context, e, index++))
              .toList(),
        ),
      );
    }
    return Container();
  }

  Widget preferredSettingProjectListData(
      BuildContext context, SiteLoadProjectDataDTO e, int index) {
    String projectName = '';
    String versionName = '';
    if (e.projectId!.contains('<')) {
      List<String> splitedList = e.projectId!.split('<');
      setState(() {
        projectName = splitedList[0];
        versionName = splitedList[1];
      });
    } else {
      projectName = e.projectId!;
      versionName = 'Base';
    }
    return Container(
      padding: EdgeInsets.only(left: 16, right: 16),
      child: GestureDetector(
        onTap: () {
          if (e.isPreferred != true)
            Navigator.pop(context, e.projectId);
          else
            Navigator.pop(context);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsets.only(top: 23.0, bottom: 23.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      projectName + " | " + versionName,
                      style: AppFonts.robotoRegular(
                        16,
                        color: theme_dark!
                            ? AppColors.appGrey2()
                            : AppColorsLightMode.appGrey(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                  e.isPreferred!
                      ? Image.asset(
                          themeDark!
                              ? Constants.ASSET_IMAGES + 'tick_icon.png'
                              : Constants.ASSET_IMAGES_LIGHT + 'tick_icon.png',
                        )
                      : Container()
                ],
              ),
            ),
            index < (this.scSiteProjectListDataDTO!.length - 1)
                ? divider(context)
                : Container(),
          ],
        ),
      ),
    );
  }

  Widget alertgroupdataItem(
    BuildContext context,
    AlertPreferenceGroupDataDTO e,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.group_details, arguments: e);
      },
      child: Container(
        // height: 130,
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: theme_dark!
              ? AppColors.appBlackLight()
              : AppColorsLightMode.serverAppBar(),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Expanded(
                child: Row(
                  children: [
                    Text(
                      e.groupId!.toString(),
                      style: AppFonts.robotoMedium(14,
                          color: theme_dark!
                              ? AppColors.appGreyDE()
                              : AppColorsLightMode.appGrey(),
                          decoration: TextDecoration.none),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 14, right: 14),
                      child: Text(
                        '|',
                        style: AppFonts.robotoMedium(14,
                            color: theme_dark!
                                ? AppColors.appGreyDE()
                                : AppColorsLightMode.appGrey(),
                            decoration: TextDecoration.none),
                      ),
                    ),
                    Flexible(
                      child: Text(
                        e.groupName!,
                        style: AppFonts.robotoMedium(14,
                            color: theme_dark!
                                ? AppColors.appGreyDE()
                                : AppColorsLightMode.appGrey(),
                            decoration: TextDecoration.none),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              (e.groupVisibility!)
                  ? Image.asset(
                      theme_dark!
                          ? Constants.ASSET_IMAGES + 'public_icon.png'
                          : Constants.ASSET_IMAGES_LIGHT + 'public.png',
                    )
                  : Image.asset(
                      theme_dark!
                          ? Constants.ASSET_IMAGES + 'private_icon.png'
                          : Constants.ASSET_IMAGES_LIGHT + 'private.png',
                    ),
            ]),
            SizedBox(
              height: 13,
            ),
            Text(
              Utils.isNotEmpty(e.groupDescription) ? e.groupDescription! : '-',
              style: AppFonts.robotoRegular(14,
                  color: theme_dark!
                      ? AppColors.appGreyB1()
                      : AppColorsLightMode.appGrey(),
                  decoration: TextDecoration.none),
            ),
            SizedBox(
              height: 29,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(
                  theme_dark!
                      ? Constants.ASSET_IMAGES + 'member_icon.png'
                      : Constants.ASSET_IMAGES_LIGHT + 'members_icon.png',
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: Text(
                    '${e.groupUsers!.length.toString()} members',
                    style: AppFonts.robotoRegular(
                      14,
                      color: theme_dark!
                          ? AppColors.appGreyB1()
                          : AppColorsLightMode.appGrey(),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget preferredSiteDataItem(BuildContext context, CustomerMapDataDTO e) {
    String title = e.companyName! + ' | ' + e.siteName!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              Navigator.pop(context, e);
            });
          },
          child: Container(
            margin: EdgeInsets.only(left: 16),
            padding: EdgeInsets.only(top: 12, right: 20, bottom: 10),
            color: Colors.transparent,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 300,
                    child: Text(
                      title,
                      style: AppFonts.robotoRegular(16,
                          color: theme_dark!
                              ? AppColors.appGrey()
                              : AppColorsLightMode.appGrey(),
                          decoration: TextDecoration.none),
                    ),
                  ),

                  // ? Image.asset(
                  //     theme_dark!
                  //         ? Constants.ASSET_IMAGES + 'tick_icon.png'
                  //         : Constants.ASSET_IMAGES_LIGHT + 'tick_icon.png',
                  //     height: 17,
                  //   )
                  // : Text(''),
                ]),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: Divider(
            color: theme_dark!
                ? AppColors.appDividerColor()
                : AppColorsLightMode.appDividerColor(),
          ),
        ),
      ],
    );
  }

  Widget notificationList(BuildContext context, AlertRecentModel e) {
    return Column(
      children: [
        GestureDetector(
          onTap: () async {
            // myMap[index]['clicked'] = true;
            if (e.sender == Constants.ALERT_COMPONENT_ANOMALY ||
                e.sender == Constants.ALERT_DEGRADATION_ANOMALY) {
              Navigator.pushNamed(
                context,
                AppRoutes.alertAnomalyInfo,
                arguments: AlertArguments(notificationListData: e),
              );
            } else if (e.sender == Constants.ALERT_CPK_ALERT_ANOMALIES) {
              Navigator.pushNamed(
                context,
                AppRoutes.alertCPKList,
                arguments: AlertArguments(notificationListData: e),
              );
            } else if (e.sender == Constants.ALERT_LIMIT_CHANGE_ANOMALY) {
              Navigator.pushNamed(
                  context, AppRoutes.alertReviewChangeLimitRoute,
                  arguments: AlertArguments(
                    notificationListData: e,
                  ));
            } else if (e.sender == Constants.ALERT_PAT_LIMIT_RECOMMENDATION) {
              Navigator.pushNamed(context, AppRoutes.casehistoryPatRecommend,
                  arguments: AlertArguments(
                    appBarTitle:
                        'PAT Recommendation', //Utils.getTranslated(context, 'alert_information'),
                    notificationListData: e,
                  ));
            }
          },
          child: Container(
            color: Colors.transparent,
            padding: const EdgeInsets.fromLTRB(0, 24, 0, 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(right: 10),
                  width: 44,
                  child: Stack(
                    children: <Widget>[
                      Image.asset(
                        themeDark!
                            ? Constants.ASSET_IMAGES + 'notification_icon.png'
                            : Constants.ASSET_IMAGES_LIGHT + 'notification.png',
                        width: 44,
                        fit: BoxFit.contain,
                      ),
                      // (myMap[index]['clicked'] == false)
                      //     ? Positioned(
                      //         left: 0,
                      //         child: Container(
                      //           padding: EdgeInsets.all(1),
                      //           decoration: new BoxDecoration(
                      //             color: AppColors.appNotificationRed(),
                      //             borderRadius: BorderRadius.circular(6),
                      //           ),
                      //           constraints: BoxConstraints(
                      //             minWidth: 12,
                      //             minHeight: 12,
                      //           ),
                      //           child: Image.asset(
                      //             Constants.ASSET_IMAGES +
                      //                 'notification_badge.png',
                      //             width: 6,
                      //             fit: BoxFit.contain,
                      //           ),
                      //         ),
                      //       )
                      //     : Text('')
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 94,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 200,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(e.sender!,
                                overflow: TextOverflow.ellipsis,
                                style: AppFonts.robotoMedium(14,
                                    color: themeDark!
                                        ? AppColors.appGreyDE()
                                        : AppColorsLightMode.appGreyDE(),
                                    decoration: TextDecoration.none)),
                            SizedBox(
                              height: 10,
                            ),
                            Text(e.event!,
                                // overflow: TextOverflow.ellipsis,
                                style: AppFonts.robotoRegular(14,
                                    color: AppColors.appGrey5B(),
                                    decoration: TextDecoration.none)),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 4),
                        height: 40,
                        width: 70,
                        child: Text(Utils.convertToAgo(e.timestamp!, true),
                            textAlign: TextAlign.right,
                            style: AppFonts.robotoRegular(12,
                                color: AppColors.appGrey5B(),
                                decoration: TextDecoration.none)),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget caseHistoryCommentDataItem(
      BuildContext ctx, AlertDetailHistoriesDTO e) {
    return Container(
      padding: EdgeInsets.fromLTRB(15, 14, 12, 0),
      margin: EdgeInsets.fromLTRB(16, 0, 16, 14),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: theme_dark!
              ? AppColors.appBlackLight()
              : AppColorsLightMode.serverAppBar()),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                e.dateCreated!,
                style: AppFonts.sfproRegular(13,
                    color: theme_dark!
                        ? AppColors.appGreyB7()
                        : AppColorsLightMode.appGrey(),
                    decoration: TextDecoration.none),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 14.0, right: 14),
                child: Text(
                  '|',
                  style: AppFonts.sfproRegular(13,
                      color: theme_dark!
                          ? AppColors.appGreyB7()
                          : AppColorsLightMode.appGrey(),
                      decoration: TextDecoration.none),
                ),
              ),
              Text(
                e.historyType!,
                style: AppFonts.sfproRegular(13,
                    color: theme_dark!
                        ? AppColors.appGreyB7()
                        : AppColorsLightMode.appGrey(),
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
                color: theme_dark!
                    ? AppColors.appGreyB7()
                    : AppColorsLightMode.appGrey(),
                decoration: TextDecoration.none),
          ),
          SizedBox(
            height: 12,
          ),
        ],
      ),
    );
  }

  Widget caseHistoryDataItem(BuildContext ctx, AlertCaseHistoryDataDTO e) {
    String startDate = '-';
    String endDate = '-';
    if (e.startDate != null) {
      startDate =
          DateFormat('d MMM yyy HH:mm:ss').format(DateTime.parse(e.startDate!));
    }
    if (e.endDate != null) {
      endDate =
          DateFormat('d MMM yyy HH:mm:ss').format(DateTime.parse(e.endDate!));
    }

    return GestureDetector(
      onTap: () {
        // e.priority == 'Critical'
        //     ? Navigator.pushNamed(context, AppRoutes.alertCPKDetails,
        //         arguments: AlertPageTitle(
        //           title: Utils.getTranslated(context, 'alert_information'),
        //         ))
        //     : null;

        pushRoutebySender(ctx, e.sender, e);
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(12, 13, 9, 12),
        margin: EdgeInsets.fromLTRB(16, 0, 16, 12),
        color: theme_dark!
            ? AppColors.appBlackLight()
            : AppColorsLightMode.appGreyBA(),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  height: 20,
                  padding: EdgeInsets.only(top: 3, right: 10, left: 10),
                  decoration: BoxDecoration(
                      color: getTagColor(e.priority!),
                      borderRadius: BorderRadius.circular(2)),
                  child: Text(
                    e.priority!,
                    style: AppFonts.robotoMedium(
                      12,
                      color: theme_dark!
                          ? AppColors.appGreyDE()
                          : AppColors.appPrimaryWhite(),
                      decoration: TextDecoration.none,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

              Container(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 171.5,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Utils.getTranslated(context, 'alert_starttime')!,
                              style: AppFonts.robotoRegular(
                                13,
                                color: theme_dark!
                                    ? AppColors.appGreyB1()
                                    : AppColorsLightMode.appGrey77(),
                                decoration: TextDecoration.none,
                              ),
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Text(
                              startDate,
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
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Utils.getTranslated(context, 'alert_endtime')!,
                            style: AppFonts.robotoRegular(
                              13,
                              color: theme_dark!
                                  ? AppColors.appGreyB1()
                                  : AppColorsLightMode.appGrey77(),
                              decoration: TextDecoration.none,
                            ),
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          Text(
                            endDate,
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
                    ]),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 171.5,
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
                              height: 6,
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
                              height: 6,
                            ),
                            Text(
                              e.workFlow != null ? e.workFlow! : '-',
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
                    ]),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                margin: EdgeInsets.only(right: 35),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Utils.getTranslated(context, 'alert_sortby_alertid')!,
                      // Utils.getTranslated(context, 'alert_subject')!,
                      style: AppFonts.robotoRegular(
                        13,
                        color: theme_dark!
                            ? AppColors.appGreyB1()
                            : AppColorsLightMode.appGrey77(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Text(
                      e.alertIdName != null ? e.alertIdName! : '-',
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
                margin: EdgeInsets.only(right: 35),
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
                      height: 6,
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
              //project
              Container(
                margin: EdgeInsets.only(right: 35),
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
                      height: 6,
                    ),
                    Text(
                      e.description != null ? e.description! : '-',
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
                        height: 6,
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
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
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
                        Utils.getTranslated(context, 'case_message')!,

                        // Utils.getTranslated(context, 'alert_assignedto')!,
                        style: AppFonts.robotoRegular(
                          13,
                          color: theme_dark!
                              ? AppColors.appGreyB1()
                              : AppColorsLightMode.appGrey77(),
                          decoration: TextDecoration.none,
                        ),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        e.event != null ? e.event! : '-',
                        style: AppFonts.robotoRegular(
                          14,
                          color: theme_dark!
                              ? AppColors.appGreyDE()
                              : AppColorsLightMode.appGrey(),
                          decoration: TextDecoration.none,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ]),
              ),
            ]),
      ),
    );
  }

  Widget projectItem(
      BuildContext context, ProjectDataDTO projectDataDTO, int index) {
    return Container(
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context, projectDataDTO.projectId);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsets.only(top: 23.0, bottom: 23.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      Utils.isNotEmpty(projectDataDTO.projectName)
                          ? '${projectDataDTO.projectName} (${projectDataDTO.projectId})'
                          : projectDataDTO.projectId!,
                      style: AppFonts.robotoRegular(
                        16,
                        color: theme_dark!
                            ? AppColors.appGrey2()
                            : AppColorsLightMode.appGrey(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            index < (this.scProjectList.length - 1)
                ? divider(context)
                : Container(),
          ],
        ),
      ),
    );
  }

  Widget equipmentItem(BuildContext ctx, EquipmentDataDTO equipmentDataDTO) {
    return GestureDetector(
      onTap: () {
        setState(() {
          Navigator.pop(context, equipmentDataDTO.equipmentId);
        });
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(12.0, 9.0, 12.0, 9.0),
        margin: EdgeInsets.only(right: 14.0, top: 14.0),
        decoration: BoxDecoration(
          color: equipmentDataDTO.isSelected!
              ? AppColors.appTeal()
              : Colors.transparent,
          border: equipmentDataDTO.isSelected!
              ? Border.all(color: Colors.transparent)
              : Border.all(color: AppColors.appTeal()),
          borderRadius: BorderRadius.circular(50.0),
        ),
        child: Text(
          equipmentDataDTO.equipmentName!,
          style: AppFonts.robotoMedium(
            14,
            color: equipmentDataDTO.isSelected!
                ? AppColors.appPrimaryWhite()
                : AppColors.appTeal(),
            decoration: TextDecoration.none,
          ),
        ),
      ),
    );
  }

  Widget customProjectItem(
      BuildContext ctx, CustomDqmSortFilterProjectsDTO customDTO, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          Navigator.pop(context, customDTO.projectId);
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 23.0, bottom: 23.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    customDTO.projectId!,
                    style: AppFonts.robotoRegular(
                      16,
                      color: theme_dark!
                          ? AppColors.appGrey2()
                          : AppColorsLightMode.appGrey(),
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
                SizedBox(width: 12.0),
                Container(
                  margin: EdgeInsets.only(right: 12.0),
                  child: customDTO.isSelected!
                      ? Image.asset(theme_dark!
                          ? Constants.ASSET_IMAGES + 'tick_icon.png'
                          : Constants.ASSET_IMAGES_LIGHT + 'tick_icon.png')
                      : Container(),
                ),
              ],
            ),
          ),
          index < (this.scCustomSFProjectList.length - 1)
              ? divider(ctx)
              : Container(),
        ],
      ),
    );
  }

  Widget analogDataItem(BuildContext ctx, TestResultCpkAnalogDataDTO dataDTO) {
    return GestureDetector(
      onTap: () async {
        Navigator.pushNamed(
          ctx,
          AppRoutes.dqmTestResultAnalogInfoDetailRoute,
          arguments: DqmTestResultArguments(analogDataDTO: dataDTO),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12.0),
        padding: EdgeInsets.fromLTRB(12.0, 13.0, 12.0, 13.0),
        decoration: BoxDecoration(
          color: (dataDTO.hasFailure!)
              ? AppColors.appRed78()
              : AppColors.appBlackLight(),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dataDTO.testType!,
                  style: AppFonts.robotoMedium(
                    13,
                    color: theme_dark!
                        ? AppColors.appGreyDE()
                        : AppColorsLightMode.appGrey(),
                    decoration: TextDecoration.none,
                  ),
                ),
                SizedBox(width: 14.0),
                Text(
                  '|',
                  style: AppFonts.robotoMedium(
                    13,
                    color: AppColors.appGreyA3(),
                    decoration: TextDecoration.none,
                  ),
                ),
                SizedBox(width: 14.0),
                Text(
                  dataDTO.testName!,
                  style: AppFonts.robotoMedium(
                    13,
                    color: theme_dark!
                        ? AppColors.appGreyDE()
                        : AppColorsLightMode.appGrey(),
                    decoration: TextDecoration.none,
                  ),
                ),
              ],
            ),
            SizedBox(height: 15.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Utils.getTranslated(
                            ctx, 'dqm_testresult_analog_sortby_cpk')!,
                        style: AppFonts.robotoRegular(
                          13,
                          color: theme_dark!
                              ? AppColors.appGreyB1()
                              : AppColorsLightMode.appGrey77(),
                          decoration: TextDecoration.none,
                        ),
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        dataDTO.cpk != null
                            ? dataDTO.cpk!.toDouble().toStringAsFixed(2)
                            : '-',
                        style: AppFonts.robotoMedium(
                          17,
                          color: theme_dark!
                              ? AppColors.appGreyDE()
                              : AppColorsLightMode.appGrey(),
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 15.0),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Utils.getTranslated(
                            ctx, 'dqm_testresult_analog_sortby_nominal')!,
                        style: AppFonts.robotoRegular(
                          13,
                          color: theme_dark!
                              ? AppColors.appGreyB1()
                              : AppColorsLightMode.appGrey77(),
                          decoration: TextDecoration.none,
                        ),
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        dataDTO.nominal != null
                            ? Utils.prefixConversion(dataDTO.nominal, 2)
                            : '-',
                        style: AppFonts.robotoMedium(
                          17,
                          color: theme_dark!
                              ? AppColors.appGreyDE()
                              : AppColorsLightMode.appGrey(),
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 15.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Utils.getTranslated(
                            ctx, 'dqm_testresult_analog_sortby_lower_limit')!,
                        style: AppFonts.robotoRegular(
                          13,
                          color: theme_dark!
                              ? AppColors.appGreyB1()
                              : AppColorsLightMode.appGrey77(),
                          decoration: TextDecoration.none,
                        ),
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        Utils.isNotEmpty(dataDTO.lowerLimit)
                            ? Utils.prefixConversion(dataDTO.lowerLimit, 2)
                            : '-',
                        style: AppFonts.robotoMedium(
                          17,
                          color: theme_dark!
                              ? AppColors.appGreyDE()
                              : AppColorsLightMode.appGrey(),
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 15.0),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Utils.getTranslated(
                            ctx, 'dqm_testresult_analog_sortby_upper_limit')!,
                        style: AppFonts.robotoRegular(
                          13,
                          color: theme_dark!
                              ? AppColors.appGreyB1()
                              : AppColorsLightMode.appGrey77(),
                          decoration: TextDecoration.none,
                        ),
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        Utils.isNotEmpty(dataDTO.upperLimit)
                            ? Utils.prefixConversion(dataDTO.upperLimit, 2)
                            : '-',
                        style: AppFonts.robotoMedium(
                          17,
                          color: theme_dark!
                              ? AppColors.appGreyDE()
                              : AppColorsLightMode.appGrey(),
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 15.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Utils.getTranslated(
                            ctx, 'dqm_testresult_analog_detail_threshold')!,
                        style: AppFonts.robotoRegular(
                          13,
                          color: theme_dark!
                              ? AppColors.appGreyB1()
                              : AppColorsLightMode.appGrey77(),
                          decoration: TextDecoration.none,
                        ),
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        dataDTO.threshold != null
                            ? Utils.prefixConversion(dataDTO.threshold, 2)
                            : '-',
                        style: AppFonts.robotoMedium(
                          17,
                          color: theme_dark!
                              ? AppColors.appGreyDE()
                              : AppColorsLightMode.appGrey(),
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget pinDataItem(
      BuildContext ctx, TestResultCpkPinsShortsTestJetDataDTO dataDTO) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          ctx,
          AppRoutes.dqmTestResultAnalogInfoDetailRoute,
          arguments: DqmTestResultArguments(pinsDataDTO: dataDTO),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12.0),
        padding: EdgeInsets.fromLTRB(12.0, 13.0, 12.0, 13.0),
        decoration: BoxDecoration(
          color: (dataDTO.hasFailure!)
              ? AppColors.appRed78()
              : AppColors.appBlackLight(),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dataDTO.testType!,
                  style: AppFonts.robotoMedium(
                    13,
                    color: theme_dark!
                        ? AppColors.appGreyDE()
                        : AppColorsLightMode.appGrey(),
                    decoration: TextDecoration.none,
                  ),
                ),
                SizedBox(width: 14.0),
                Text(
                  '|',
                  style: AppFonts.robotoMedium(
                    13,
                    color: AppColors.appGreyA3(),
                    decoration: TextDecoration.none,
                  ),
                ),
                SizedBox(width: 14.0),
                Text(
                  dataDTO.testName!,
                  style: AppFonts.robotoMedium(
                    13,
                    color: theme_dark!
                        ? AppColors.appGreyDE()
                        : AppColorsLightMode.appGrey(),
                    decoration: TextDecoration.none,
                  ),
                ),
              ],
            ),
            SizedBox(height: 15.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Utils.getTranslated(
                            ctx, 'dqm_testresult_analog_sortby_cpk')!,
                        style: AppFonts.robotoRegular(
                          13,
                          color: theme_dark!
                              ? AppColors.appGreyB1()
                              : AppColorsLightMode.appGrey77(),
                          decoration: TextDecoration.none,
                        ),
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        dataDTO.cpk != null
                            ? dataDTO.cpk!.toDouble().toStringAsFixed(2)
                            : '-',
                        style: AppFonts.robotoMedium(
                          17,
                          color: theme_dark!
                              ? AppColors.appGreyDE()
                              : AppColorsLightMode.appGrey(),
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 15.0),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Utils.getTranslated(
                            ctx, "dqm_testresult_pins_detail_brcc")!,
                        style: AppFonts.robotoRegular(
                          13,
                          color: theme_dark!
                              ? AppColors.appGreyB1()
                              : AppColorsLightMode.appGrey77(),
                          decoration: TextDecoration.none,
                        ),
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        dataDTO.brcc != null ? '${dataDTO.brcc}' : '-',
                        style: AppFonts.robotoMedium(
                          17,
                          color: theme_dark!
                              ? AppColors.appGreyDE()
                              : AppColorsLightMode.appGrey(),
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 15.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Utils.getTranslated(ctx, 'dqm_testresult_minimum')!,
                        style: AppFonts.robotoRegular(
                          13,
                          color: theme_dark!
                              ? AppColors.appGreyB1()
                              : AppColorsLightMode.appGrey77(),
                          decoration: TextDecoration.none,
                        ),
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        dataDTO.min != null ? '${dataDTO.min!}' : '-',
                        style: AppFonts.robotoMedium(
                          17,
                          color: theme_dark!
                              ? AppColors.appGreyDE()
                              : AppColorsLightMode.appGrey(),
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 15.0),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Utils.getTranslated(ctx, 'dqm_testresult_maximum')!,
                        style: AppFonts.robotoRegular(
                          13,
                          color: theme_dark!
                              ? AppColors.appGreyB1()
                              : AppColorsLightMode.appGrey77(),
                          decoration: TextDecoration.none,
                        ),
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        dataDTO.max != null ? '${dataDTO.max}' : '-',
                        style: AppFonts.robotoMedium(
                          17,
                          color: theme_dark!
                              ? AppColors.appGreyDE()
                              : AppColorsLightMode.appGrey(),
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 15.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Utils.getTranslated(
                            ctx, 'dqm_testresult_analog_detail_threshold')!,
                        style: AppFonts.robotoRegular(
                          13,
                          color: theme_dark!
                              ? AppColors.appGreyB1()
                              : AppColorsLightMode.appGrey77(),
                          decoration: TextDecoration.none,
                        ),
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        dataDTO.threshold != null
                            ? '${dataDTO.threshold}'
                            : '-',
                        style: AppFonts.robotoMedium(
                          17,
                          color: theme_dark!
                              ? AppColors.appGreyDE()
                              : AppColorsLightMode.appGrey(),
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget shortDataItem(
      BuildContext ctx, TestResultCpkPinsShortsTestJetDataDTO dataDTO) {
    String dTestType = '';
    String dTestName = '';
    if (Utils.isNotEmpty(dataDTO.testType)) {
      if (dataDTO.testType!.contains('|')) {
        List<String> splitList = dataDTO.testType!.split('|');
        dTestType = splitList[splitList.length - 1];
      } else {
        dTestType = dataDTO.testType!;
      }
    }

    if (Utils.isNotEmpty(dataDTO.testName)) {
      if (dataDTO.testName!.contains(dataDTO.testType!)) {
        List<String> splitList =
            dataDTO.testName!.split('${dataDTO.testType}>');
        dTestName = splitList[splitList.length - 1];
      } else {
        dTestName = dataDTO.testType!;
      }
    }
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          ctx,
          AppRoutes.dqmTestResultAnalogInfoDetailRoute,
          arguments: DqmTestResultArguments(shortsDataDTO: dataDTO),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12.0),
        padding: EdgeInsets.fromLTRB(12.0, 13.0, 12.0, 13.0),
        decoration: BoxDecoration(
          color: (dataDTO.hasFailure!)
              ? AppColors.appRed78()
              : AppColors.appBlackLight(),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dTestType,
                  style: AppFonts.robotoMedium(
                    13,
                    color: theme_dark!
                        ? AppColors.appGreyDE()
                        : AppColorsLightMode.appGrey(),
                    decoration: TextDecoration.none,
                  ),
                ),
                SizedBox(width: 14.0),
                Text(
                  '|',
                  style: AppFonts.robotoMedium(
                    13,
                    color: AppColors.appGreyA3(),
                    decoration: TextDecoration.none,
                  ),
                ),
                SizedBox(width: 14.0),
                Text(
                  dTestName,
                  style: AppFonts.robotoMedium(
                    13,
                    color: theme_dark!
                        ? AppColors.appGreyDE()
                        : AppColorsLightMode.appGrey(),
                    decoration: TextDecoration.none,
                  ),
                ),
              ],
            ),
            SizedBox(height: 15.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Utils.getTranslated(
                            ctx, 'dqm_testresult_analog_sortby_cpk')!,
                        style: AppFonts.robotoRegular(
                          13,
                          color: theme_dark!
                              ? AppColors.appGreyB1()
                              : AppColorsLightMode.appGrey77(),
                          decoration: TextDecoration.none,
                        ),
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        dataDTO.cpk != null
                            ? dataDTO.cpk!.toDouble().toStringAsFixed(2)
                            : '-',
                        style: AppFonts.robotoMedium(
                          17,
                          color: theme_dark!
                              ? AppColors.appGreyDE()
                              : AppColorsLightMode.appGrey(),
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 15.0),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Utils.getTranslated(
                            ctx, 'dqm_testresult_shorts_detail_destination')!,
                        style: AppFonts.robotoRegular(
                          13,
                          color: theme_dark!
                              ? AppColors.appGreyB1()
                              : AppColorsLightMode.appGrey77(),
                          decoration: TextDecoration.none,
                        ),
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        Utils.isNotEmpty(dataDTO.destination)
                            ? '${dataDTO.destination}'
                            : '-',
                        style: AppFonts.robotoMedium(
                          17,
                          color: theme_dark!
                              ? AppColors.appGreyDE()
                              : AppColorsLightMode.appGrey(),
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 15.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Utils.getTranslated(ctx, 'dqm_testresult_minimum')!,
                        style: AppFonts.robotoRegular(
                          13,
                          color: theme_dark!
                              ? AppColors.appGreyB1()
                              : AppColorsLightMode.appGrey77(),
                          decoration: TextDecoration.none,
                        ),
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        dataDTO.min != null ? dataDTO.min.toString() : '-',
                        style: AppFonts.robotoMedium(
                          17,
                          color: theme_dark!
                              ? AppColors.appGreyDE()
                              : AppColorsLightMode.appGrey(),
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 15.0),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Utils.getTranslated(ctx, 'dqm_testresult_maximum')!,
                        style: AppFonts.robotoRegular(
                          13,
                          color: theme_dark!
                              ? AppColors.appGreyB1()
                              : AppColorsLightMode.appGrey77(),
                          decoration: TextDecoration.none,
                        ),
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        dataDTO.max != null ? dataDTO.max.toString() : '-',
                        style: AppFonts.robotoMedium(
                          17,
                          color: theme_dark!
                              ? AppColors.appGreyDE()
                              : AppColorsLightMode.appGrey(),
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 15.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Utils.getTranslated(
                            ctx, 'dqm_testresult_analog_detail_threshold')!,
                        style: AppFonts.robotoRegular(
                          13,
                          color: theme_dark!
                              ? AppColors.appGreyB1()
                              : AppColorsLightMode.appGrey77(),
                          decoration: TextDecoration.none,
                        ),
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        dataDTO.threshold != null
                            ? '${dataDTO.threshold}'
                            : '-',
                        style: AppFonts.robotoMedium(
                          17,
                          color: theme_dark!
                              ? AppColors.appGreyDE()
                              : AppColorsLightMode.appGrey(),
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget vtepDataItem(
      BuildContext ctx, TestResultCpkPinsShortsTestJetDataDTO dataDTO) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          ctx,
          AppRoutes.dqmTestResultAnalogInfoDetailRoute,
          arguments: DqmTestResultArguments(vtepDataDTO: dataDTO),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12.0),
        padding: EdgeInsets.fromLTRB(12.0, 13.0, 12.0, 13.0),
        decoration: BoxDecoration(
          color: (dataDTO.hasFailure!)
              ? AppColors.appRed78()
              : AppColors.appBlackLight(),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dataDTO.testType!,
                  style: AppFonts.robotoMedium(
                    13,
                    color: theme_dark!
                        ? AppColors.appGreyDE()
                        : AppColorsLightMode.appGrey(),
                    decoration: TextDecoration.none,
                  ),
                ),
                SizedBox(width: 14.0),
                Text(
                  '|',
                  style: AppFonts.robotoMedium(
                    13,
                    color: AppColors.appGreyA3(),
                    decoration: TextDecoration.none,
                  ),
                ),
                SizedBox(width: 14.0),
                Text(
                  dataDTO.testName!.contains("|")
                      ? dataDTO.testName!.split('|')[1]
                      : '',
                  style: AppFonts.robotoMedium(
                    13,
                    color: theme_dark!
                        ? AppColors.appGreyDE()
                        : AppColorsLightMode.appGrey(),
                    decoration: TextDecoration.none,
                  ),
                ),
              ],
            ),
            SizedBox(height: 15.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Utils.getTranslated(
                            ctx, 'dqm_testresult_analog_sortby_cpk')!,
                        style: AppFonts.robotoRegular(
                          13,
                          color: theme_dark!
                              ? AppColors.appGreyB1()
                              : AppColorsLightMode.appGrey77(),
                          decoration: TextDecoration.none,
                        ),
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        dataDTO.cpk != null
                            ? dataDTO.cpk!.toDouble().toStringAsFixed(2)
                            : '-',
                        style: AppFonts.robotoMedium(
                          17,
                          color: theme_dark!
                              ? AppColors.appGreyDE()
                              : AppColorsLightMode.appGrey(),
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 15.0),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Utils.getTranslated(
                            ctx, 'dqm_testresult_vtep_detail_device')!,
                        style: AppFonts.robotoRegular(
                          13,
                          color: theme_dark!
                              ? AppColors.appGreyB1()
                              : AppColorsLightMode.appGrey77(),
                          decoration: TextDecoration.none,
                        ),
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        Utils.isNotEmpty(dataDTO.source)
                            ? '${dataDTO.source}'
                            : '-',
                        style: AppFonts.robotoMedium(
                          17,
                          color: theme_dark!
                              ? AppColors.appGreyDE()
                              : AppColorsLightMode.appGrey(),
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 15.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Utils.getTranslated(
                            ctx, 'dqm_testresult_analog_sortby_lower_limit')!,
                        style: AppFonts.robotoRegular(
                          13,
                          color: theme_dark!
                              ? AppColors.appGreyB1()
                              : AppColorsLightMode.appGrey77(),
                          decoration: TextDecoration.none,
                        ),
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        Utils.isNotEmpty(dataDTO.lowerLimit)
                            ? dataDTO.lowerLimit!
                            : '-',
                        style: AppFonts.robotoMedium(
                          17,
                          color: theme_dark!
                              ? AppColors.appGreyDE()
                              : AppColorsLightMode.appGrey(),
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 15.0),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Utils.getTranslated(
                            ctx, 'dqm_testresult_analog_sortby_upper_limit')!,
                        style: AppFonts.robotoRegular(
                          13,
                          color: theme_dark!
                              ? AppColors.appGreyB1()
                              : AppColorsLightMode.appGrey77(),
                          decoration: TextDecoration.none,
                        ),
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        Utils.isNotEmpty(dataDTO.upperLimit)
                            ? dataDTO.upperLimit!
                            : '-',
                        style: AppFonts.robotoMedium(
                          17,
                          color: theme_dark!
                              ? AppColors.appGreyDE()
                              : AppColorsLightMode.appGrey(),
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 15.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Utils.getTranslated(
                            ctx, 'dqm_testresult_vtep_detail_pin')!,
                        style: AppFonts.robotoRegular(
                          13,
                          color: theme_dark!
                              ? AppColors.appGreyB1()
                              : AppColorsLightMode.appGrey77(),
                          decoration: TextDecoration.none,
                        ),
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        Utils.isNotEmpty(dataDTO.destination)
                            ? dataDTO.destination!
                            : '-',
                        style: AppFonts.robotoMedium(
                          17,
                          color: theme_dark!
                              ? AppColors.appGreyDE()
                              : AppColorsLightMode.appGrey(),
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget xvtepDataItem(
      BuildContext ctx, TestResultCpkPinsShortsTestJetDataDTO dataDTO) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          ctx,
          AppRoutes.dqmTestResultAnalogInfoDetailRoute,
          arguments: DqmTestResultArguments(xvtepDataDTO: dataDTO),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12.0),
        padding: EdgeInsets.fromLTRB(12.0, 13.0, 12.0, 13.0),
        decoration: BoxDecoration(
          color: (dataDTO.hasFailure!)
              ? AppColors.appRed78()
              : AppColors.appBlackLight(),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Utils.isNotEmpty(dataDTO.source) ? dataDTO.source! : '-',
                  style: AppFonts.robotoMedium(
                    13,
                    color: theme_dark!
                        ? AppColors.appGreyDE()
                        : AppColorsLightMode.appGrey(),
                    decoration: TextDecoration.none,
                  ),
                ),
                SizedBox(width: 14.0),
                Text(
                  '|',
                  style: AppFonts.robotoMedium(
                    13,
                    color: AppColors.appGreyA3(),
                    decoration: TextDecoration.none,
                  ),
                ),
                SizedBox(width: 14.0),
                Text(
                  Utils.isNotEmpty(dataDTO.destination)
                      ? dataDTO.destination!
                      : '-',
                  style: AppFonts.robotoMedium(
                    13,
                    color: theme_dark!
                        ? AppColors.appGreyDE()
                        : AppColorsLightMode.appGrey(),
                    decoration: TextDecoration.none,
                  ),
                ),
              ],
            ),
            SizedBox(height: 15.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Utils.getTranslated(
                            ctx, 'dqm_testresult_analog_sortby_cpk')!,
                        style: AppFonts.robotoRegular(
                          13,
                          color: theme_dark!
                              ? AppColors.appGreyB1()
                              : AppColorsLightMode.appGrey77(),
                          decoration: TextDecoration.none,
                        ),
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        dataDTO.cpk != null
                            ? dataDTO.cpk!.toDouble().toStringAsFixed(2)
                            : '-',
                        style: AppFonts.robotoMedium(
                          17,
                          color: theme_dark!
                              ? AppColors.appGreyDE()
                              : AppColorsLightMode.appGrey(),
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 15.0),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Utils.getTranslated(ctx, 'dqm_testresult_vtep_mean')!,
                        style: AppFonts.robotoRegular(
                          13,
                          color: theme_dark!
                              ? AppColors.appGreyB1()
                              : AppColorsLightMode.appGrey77(),
                          decoration: TextDecoration.none,
                        ),
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        Utils.isNotEmpty(dataDTO.mean)
                            ? '${dataDTO.mean}'
                            : '-',
                        style: AppFonts.robotoMedium(
                          17,
                          color: theme_dark!
                              ? AppColors.appGreyDE()
                              : AppColorsLightMode.appGrey(),
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 15.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Utils.getTranslated(
                            ctx, 'dqm_testresult_analog_sortby_lower_limit')!,
                        style: AppFonts.robotoRegular(
                          13,
                          color: theme_dark!
                              ? AppColors.appGreyB1()
                              : AppColorsLightMode.appGrey77(),
                          decoration: TextDecoration.none,
                        ),
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        Utils.isNotEmpty(dataDTO.lowerLimit)
                            ? dataDTO.lowerLimit!
                            : '-',
                        style: AppFonts.robotoMedium(
                          17,
                          color: theme_dark!
                              ? AppColors.appGreyDE()
                              : AppColorsLightMode.appGrey(),
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 15.0),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Utils.getTranslated(
                            ctx, 'dqm_testresult_analog_sortby_upper_limit')!,
                        style: AppFonts.robotoRegular(
                          13,
                          color: theme_dark!
                              ? AppColors.appGreyB1()
                              : AppColorsLightMode.appGrey77(),
                          decoration: TextDecoration.none,
                        ),
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        Utils.isNotEmpty(dataDTO.upperLimit)
                            ? dataDTO.upperLimit!
                            : '-',
                        style: AppFonts.robotoMedium(
                          17,
                          color: theme_dark!
                              ? AppColors.appGreyDE()
                              : AppColorsLightMode.appGrey(),
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget funcDataItem(
      BuildContext ctx, TestResultCpkPinsShortsTestJetDataDTO dataDTO) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          ctx,
          AppRoutes.dqmTestResultAnalogInfoDetailRoute,
          arguments: DqmTestResultArguments(funcDataDTO: dataDTO),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12.0),
        padding: EdgeInsets.fromLTRB(12.0, 13.0, 12.0, 13.0),
        decoration: BoxDecoration(
          color: (dataDTO.hasFailure!)
              ? AppColors.appRed78()
              : AppColors.appBlackLight(),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dataDTO.testType!,
                  style: AppFonts.robotoMedium(
                    13,
                    color: theme_dark!
                        ? AppColors.appGreyDE()
                        : AppColorsLightMode.appGrey(),
                    decoration: TextDecoration.none,
                  ),
                ),
                SizedBox(width: 14.0),
                Text(
                  '|',
                  style: AppFonts.robotoMedium(
                    13,
                    color: AppColors.appGreyA3(),
                    decoration: TextDecoration.none,
                  ),
                ),
                SizedBox(width: 14.0),
                Flexible(
                  child: Text(
                    dataDTO.testName!,
                    style: AppFonts.robotoMedium(
                      13,
                      color: theme_dark!
                          ? AppColors.appGreyDE()
                          : AppColorsLightMode.appGrey(),
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Utils.getTranslated(
                            ctx, 'dqm_testresult_analog_sortby_cpk')!,
                        style: AppFonts.robotoRegular(
                          13,
                          color: theme_dark!
                              ? AppColors.appGreyB1()
                              : AppColorsLightMode.appGrey77(),
                          decoration: TextDecoration.none,
                        ),
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        dataDTO.cpk != null
                            ? dataDTO.cpk!.toDouble().toStringAsFixed(2)
                            : '-',
                        style: AppFonts.robotoMedium(
                          17,
                          color: theme_dark!
                              ? AppColors.appGreyDE()
                              : AppColorsLightMode.appGrey(),
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 15.0),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Utils.getTranslated(
                            ctx, 'dqm_testresult_analog_sortby_lower_limit')!,
                        style: AppFonts.robotoRegular(
                          13,
                          color: theme_dark!
                              ? AppColors.appGreyB1()
                              : AppColorsLightMode.appGrey77(),
                          decoration: TextDecoration.none,
                        ),
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        Utils.isNotEmpty(dataDTO.lowerLimit)
                            ? dataDTO.lowerLimit!
                            : '-',
                        style: AppFonts.robotoMedium(
                          17,
                          color: theme_dark!
                              ? AppColors.appGreyDE()
                              : AppColorsLightMode.appGrey(),
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 15.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Utils.getTranslated(
                            ctx, 'dqm_testresult_analog_sortby_upper_limit')!,
                        style: AppFonts.robotoRegular(
                          13,
                          color: theme_dark!
                              ? AppColors.appGreyB1()
                              : AppColorsLightMode.appGrey77(),
                          decoration: TextDecoration.none,
                        ),
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        Utils.isNotEmpty(dataDTO.upperLimit)
                            ? dataDTO.upperLimit!
                            : '-',
                        style: AppFonts.robotoMedium(
                          17,
                          color: theme_dark!
                              ? AppColors.appGreyDE()
                              : AppColorsLightMode.appGrey(),
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget rmaTestDataItem(BuildContext ctx, AnomalyCompanyDataDTO dataDTO) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(ctx, AppRoutes.dqmRmaResultInfoRoute,
            arguments: DqmRmaArguments(
              anomalyCompanyDataDTO: dataDTO,
            ));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 14.0),
        padding: EdgeInsets.fromLTRB(17.0, 15.0, 17.0, 15.0),
        decoration: BoxDecoration(
          color: AppColors.appBlackLight(),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    '${dataDTO.projectId}',
                    style: AppFonts.robotoBold(
                      15,
                      color: theme_dark!
                          ? AppColors.appGreyDE()
                          : AppColorsLightMode.appGrey(),
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(12.0, 5.0, 12.0, 5.0),
                  decoration: BoxDecoration(
                    color: (dataDTO.status!.contains("PASS") ||
                            dataDTO.status!.contains("Pass") ||
                            dataDTO.status!.contains("pass"))
                        ? AppColors.appGreen60()
                        : AppColors.appRedE9(),
                    borderRadius: BorderRadius.circular(2.0),
                  ),
                  child: (dataDTO.status!.contains("PASS") ||
                          dataDTO.status!.contains("Pass") ||
                          dataDTO.status!.contains("pass"))
                      ? Text(
                          Utils.getTranslated(ctx, 'dqm_rma_passed')!,
                          style: AppFonts.robotoMedium(
                            12,
                            color: AppColors.appPrimaryWhite(),
                            decoration: TextDecoration.none,
                          ),
                        )
                      : Text(
                          Utils.getTranslated(ctx, 'dqm_rma_failed')!,
                          style: AppFonts.robotoMedium(
                            12,
                            color: AppColors.appPrimaryWhite(),
                            decoration: TextDecoration.none,
                          ),
                        ),
                ),
              ],
            ),
            SizedBox(height: 25.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Utils.getTranslated(ctx, 'dqm_rma_sortby_start_time')!,
                        style: AppFonts.robotoRegular(
                          13,
                          color: theme_dark!
                              ? AppColors.appGreyB1()
                              : AppColorsLightMode.appGrey77(),
                          decoration: TextDecoration.none,
                        ),
                      ),
                      SizedBox(height: 7.0),
                      Text(
                        DateFormat("dd MMM yyyy HH:mm:ss")
                            .format(DateTime.parse(dataDTO.startTime!)),
                        style: AppFonts.robotoMedium(
                          13,
                          color: theme_dark!
                              ? AppColors.appGreyDE()
                              : AppColorsLightMode.appGrey(),
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10.0),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Utils.getTranslated(ctx, 'dqm_rma_sortby_end_time')!,
                        style: AppFonts.robotoRegular(
                          13,
                          color: theme_dark!
                              ? AppColors.appGreyB1()
                              : AppColorsLightMode.appGrey77(),
                          decoration: TextDecoration.none,
                        ),
                      ),
                      SizedBox(height: 7.0),
                      Text(
                        DateFormat("dd MMM yyyy HH:mm:ss")
                            .format(DateTime.parse(dataDTO.endTime!)),
                        style: AppFonts.robotoMedium(
                          13,
                          color: theme_dark!
                              ? AppColors.appGreyDE()
                              : AppColorsLightMode.appGrey(),
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget dataItem(BuildContext ctx, AlertListDataDTO dataDTO) {
    return Container(
      margin: EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () async {
                if (dataDTO.sender == Constants.ALERT_COMPONENT_ANOMALY ||
                    dataDTO.sender == Constants.ALERT_DEGRADATION_ANOMALY) {
                  final navResult = await Navigator.pushNamed(
                    context,
                    AppRoutes.alertAnomalyInfo,
                    arguments: AlertArguments(alertListDataDTO: dataDTO),
                  );
                  if (navResult != null && navResult as bool) {}
                } else if (dataDTO.sender ==
                    Constants.ALERT_CPK_ALERT_ANOMALIES) {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.alertCPKList,
                    arguments: AlertArguments(alertListDataDTO: dataDTO),
                  );
                } else if (dataDTO.sender ==
                    Constants.ALERT_LIMIT_CHANGE_ANOMALY) {
                  Navigator.pushNamed(
                      context, AppRoutes.alertReviewChangeLimitRoute,
                      arguments: AlertArguments(
                        alertListDataDTO: dataDTO,
                      ));
                } else if (dataDTO.sender ==
                        Constants.ALERT_PAT_LIMIT_ANOMALIES ||
                    dataDTO.sender ==
                        Constants.ALERT_PAT_LIMIT_RECOMMENDATION) {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.alertAnomalyInfo,
                    arguments: AlertArguments(
                        alertListDataDTO: dataDTO, alertType: dataDTO.sender),
                  );
                }
              },
              child: Container(
                padding: EdgeInsets.fromLTRB(12, 13, 9, 12),
                color: AppColors.appBlackLight(),
                width: MediaQuery.of(context).size.width - 68,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Visibility(
                        visible: Utils.isNotEmpty(dataDTO.alertSeverity),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            height: 20,
                            padding:
                                EdgeInsets.only(top: 3, right: 10, left: 10),
                            decoration: BoxDecoration(
                                color: getTagColor(dataDTO.alertSeverity),
                                borderRadius: BorderRadius.circular(2)),
                            child: Text(
                              Utils.isNotEmpty(dataDTO.alertSeverity)
                                  ? dataDTO.alertSeverity!
                                  : 'Other',
                              style: AppFonts.robotoMedium(
                                12,
                                color: Utils.isNotEmpty(dataDTO.alertSeverity)
                                    ? AppColors.appGreyDE()
                                    : AppColors.appBlackLight(),
                                decoration: TextDecoration.none,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 35),
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
                            SizedBox(height: 6),
                            Text(
                              Utils.isNotEmpty(dataDTO.alertIdName)
                                  ? dataDTO.alertIdName!
                                  : '-',
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
                      SizedBox(height: 20),
                      Container(
                        margin: EdgeInsets.only(right: 35),
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
                            SizedBox(height: 6),
                            Text(
                              Utils.isNotEmpty(dataDTO.equipmentName)
                                  ? dataDTO.equipmentName!
                                  : '-',
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
                      SizedBox(height: 20),
                      //project
                      Container(
                        margin: EdgeInsets.only(right: 35),
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
                            SizedBox(height: 6),
                            Text(
                              Utils.isNotEmpty(dataDTO.projectId)
                                  ? dataDTO.projectId!
                                  : '-',
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

                      SizedBox(height: 20),
                      //timestamp & scoring
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
                                    Utils.getTranslated(
                                        context, 'alert_timestamp')!,
                                    style: AppFonts.robotoRegular(
                                      13,
                                      color: theme_dark!
                                          ? AppColors.appGreyB1()
                                          : AppColorsLightMode.appGrey77(),
                                      decoration: TextDecoration.none,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 6,
                                  ),
                                  Text(
                                    Utils.isNotEmpty(dataDTO.timestamp)
                                        ? DateFormat("dd MMM yyyy HH:mm:ss")
                                            .format(DateTime.parse(
                                                dataDTO.timestamp!))
                                        : '-',
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
                              Container(
                                margin: EdgeInsets.only(right: 35),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      Utils.getTranslated(
                                          context, 'alert_scoring')!,
                                      style: AppFonts.robotoRegular(
                                        13,
                                        color: theme_dark!
                                            ? AppColors.appGreyB1()
                                            : AppColorsLightMode.appGrey77(),
                                        decoration: TextDecoration.none,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 6,
                                    ),
                                    Text(
                                      Utils.isNotEmpty(dataDTO.alertScoring)
                                          ? dataDTO.alertScoring!
                                          : '-',
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
                            ]),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      //alert message
                      Container(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                Utils.getTranslated(
                                    context, 'alert_information')!,
                                style: AppFonts.robotoRegular(
                                  13,
                                  color: theme_dark!
                                      ? AppColors.appGreyB1()
                                      : AppColorsLightMode.appGrey77(),
                                  decoration: TextDecoration.none,
                                ),
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              Text(
                                Utils.isNotEmpty(dataDTO.event)
                                    ? dataDTO.event!
                                    : '-',
                                style: AppFonts.robotoRegular(
                                  14,
                                  color: theme_dark!
                                      ? AppColors.appGreyDE()
                                      : AppColorsLightMode.appGrey(),
                                  decoration: TextDecoration.none,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ]),
                      ),
                    ]),
              ),
            )
          ]),
    );
  }

  Widget preferedDataItem(BuildContext ctx, AlertStatisticsDataDTO dataDTO) {
    return Container(
      margin: EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () async {
                if (dataDTO.sender == Constants.ALERT_COMPONENT_ANOMALY ||
                    dataDTO.sender == Constants.ALERT_DEGRADATION_ANOMALY) {
                  final navResult = await Navigator.pushNamed(
                    context,
                    AppRoutes.alertAnomalyInfo,
                    arguments: AlertArguments(alertStatisticsDataDTO: dataDTO),
                  );
                  if (navResult != null && navResult as bool) {
                    Navigator.pop(ctx, true);
                  }
                } else if (dataDTO.sender ==
                    Constants.ALERT_CPK_ALERT_ANOMALIES) {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.alertCPKList,
                    arguments: AlertArguments(alertStatisticsDataDTO: dataDTO),
                  );
                } else if (dataDTO.sender ==
                    Constants.ALERT_LIMIT_CHANGE_ANOMALY) {
                  Navigator.pushNamed(
                      context, AppRoutes.alertReviewChangeLimitRoute,
                      arguments: AlertArguments(
                        alertStatisticsDataDTO: dataDTO,
                      ));
                }
              },
              child: Container(
                padding: EdgeInsets.fromLTRB(12, 13, 9, 12),
                color: AppColors.appBlackLight(),
                width: MediaQuery.of(context).size.width - 68,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Visibility(
                        visible: Utils.isNotEmpty(dataDTO.alertSeverity),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            height: 20,
                            padding:
                                EdgeInsets.only(top: 3, right: 10, left: 10),
                            decoration: BoxDecoration(
                                color: getTagColor(dataDTO.alertSeverity),
                                borderRadius: BorderRadius.circular(2)),
                            child: Text(
                              Utils.isNotEmpty(dataDTO.alertSeverity)
                                  ? dataDTO.alertSeverity!
                                  : 'Other',
                              style: AppFonts.robotoMedium(
                                12,
                                color: Utils.isNotEmpty(dataDTO.alertSeverity)
                                    ? AppColors.appGreyDE()
                                    : AppColors.appBlackLight(),
                                decoration: TextDecoration.none,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 35),
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
                            SizedBox(height: 6),
                            Text(
                              Utils.isNotEmpty(dataDTO.alertIdName)
                                  ? dataDTO.alertIdName!
                                  : '-',
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
                      SizedBox(height: 20),
                      Container(
                        margin: EdgeInsets.only(right: 35),
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
                            SizedBox(height: 6),
                            Text(
                              Utils.isNotEmpty(dataDTO.equipmentName)
                                  ? dataDTO.equipmentName!
                                  : '-',
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
                      SizedBox(height: 20),
                      //project
                      Container(
                        margin: EdgeInsets.only(right: 35),
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
                            SizedBox(height: 6),
                            Text(
                              Utils.isNotEmpty(dataDTO.projectId)
                                  ? dataDTO.projectId!
                                  : '-',
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

                      SizedBox(height: 20),
                      //timestamp & scoring
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
                                    Utils.getTranslated(
                                        context, 'alert_timestamp')!,
                                    style: AppFonts.robotoRegular(
                                      13,
                                      color: theme_dark!
                                          ? AppColors.appGreyB1()
                                          : AppColorsLightMode.appGrey77(),
                                      decoration: TextDecoration.none,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 6,
                                  ),
                                  Text(
                                    Utils.isNotEmpty(dataDTO.timestamp)
                                        ? DateFormat("dd MMM yyyy HH:mm:ss")
                                            .format(DateTime.parse(
                                                dataDTO.timestamp!))
                                        : '-',
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
                              Container(
                                margin: EdgeInsets.only(right: 35),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      Utils.getTranslated(
                                          context, 'alert_scoring')!,
                                      style: AppFonts.robotoRegular(
                                        13,
                                        color: theme_dark!
                                            ? AppColors.appGreyB1()
                                            : AppColorsLightMode.appGrey77(),
                                        decoration: TextDecoration.none,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 6,
                                    ),
                                    Text(
                                      Utils.isNotEmpty(dataDTO.alertScoring)
                                          ? dataDTO.alertScoring!
                                          : '-',
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
                            ]),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      //alert message
                      Container(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                Utils.getTranslated(
                                    context, 'alert_information')!,
                                style: AppFonts.robotoRegular(
                                  13,
                                  color: theme_dark!
                                      ? AppColors.appGreyB1()
                                      : AppColorsLightMode.appGrey77(),
                                  decoration: TextDecoration.none,
                                ),
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              Text(
                                Utils.isNotEmpty(dataDTO.event)
                                    ? dataDTO.event!
                                    : '-',
                                style: AppFonts.robotoRegular(
                                  14,
                                  color: theme_dark!
                                      ? AppColors.appGreyDE()
                                      : AppColorsLightMode.appGrey(),
                                  decoration: TextDecoration.none,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ]),
                      ),
                    ]),
              ),
            )
          ]),
    );
  }

  Widget divider(BuildContext ctx) {
    return Container(
      width: MediaQuery.of(ctx).size.width,
      height: 1.0,
      color: theme_dark!
          ? AppColors.appDividerColor()
          : AppColorsLightMode.appDividerColor(),
    );
  }
}
