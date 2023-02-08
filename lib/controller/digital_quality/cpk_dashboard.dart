import 'dart:convert';

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
import 'package:keysight_pma/model/dqm/histogram.dart';
import 'package:keysight_pma/model/dqm/test_result.dart';
import 'package:keysight_pma/model/dqm/test_result_change_limit.dart';
import 'package:keysight_pma/model/dqm/test_result_cpk.dart';
import 'package:keysight_pma/model/dqm/test_result_cpk_analog.dart';
import 'package:keysight_pma/model/dqm/test_result_fixtures.dart';
import 'package:keysight_pma/model/dqm/test_result_testname.dart';
import 'package:keysight_pma/model/js/js.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

class CpkDashboardScreen extends StatefulWidget {
  final TestResultFixtureDataDTO? fixtureDataDTO;
  final TestResultCpkAnalogDataDTO? analogCpkData;
  final TestResultTestNameDataDTO? testNameDataDTO;
  final JSLimitChangeDTO? changeLimitDTO;
  final String? projectId;
  final String? from;
  final String? equipmentId;
  final String? to;
  final int? pushFrom;
  final TestResultDataDTO? compareTestResultDataDTO;
  final String? compareBy;
  final String? fixtureId;
  CpkDashboardScreen(
      {Key? key,
      this.fixtureDataDTO,
      this.analogCpkData,
      this.testNameDataDTO,
      this.changeLimitDTO,
      this.projectId,
      this.from,
      this.to,
      this.fixtureId,
      this.pushFrom,
      this.equipmentId,
      this.compareTestResultDataDTO,
      this.compareBy})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CpkDashboardScreen();
  }
}

class _CpkDashboardScreen extends State<CpkDashboardScreen> {
  bool isViewHistogram = false;
  final editController = TextEditingController(text: "20");
  bool? theme_dark = AppCache.sortFilterCacheDTO!.currentTheme;
  bool hasText = true;
  bool isLoading = true;
  TestResultCpkDTO? testResultCpkDTO;
  late HistogramDTO histogramDTO;
  bool isAnomaly = false;
  bool isFalseFailure = false;
  bool isPass = false;
  bool isFail = false;
  bool isLimiChange = false;
  double chartCpkHeight = 316.0;
  double chartHistogramHeight = 316.0;
  late WebViewPlusController cpkWebViewController;
  late WebViewPlusController histogramWebViewController;
  late WebViewPlusController smallHistogramWebViewController;
  String curDate = '';
  String startDate = '';
  String endDate = '';
  TestResultCpkDataDTO? cpkDataDTO;

  Future<TestResultCpkDTO> getFixtureCpk(BuildContext context) {
    String companyId = '';
    String siteId = '';
    String startDate = '';
    String endDate = '';
    List<String?> equipments = [];
    String projectId = '';
    String testName = '';
    String testType = '';

    if (widget.fixtureDataDTO != null) {
      companyId = widget.fixtureDataDTO!.companyId!;
      siteId = widget.fixtureDataDTO!.siteId!;
      startDate = DateFormat("yyyy-MM-dd")
          .format(AppCache.sortFilterCacheDTO!.startDate!);
      endDate = DateFormat("yyyy-MM-dd")
          .format(AppCache.sortFilterCacheDTO!.endDate!);
      projectId = widget.fixtureDataDTO!.projectId!;
      testName = widget.fixtureDataDTO!.testName!;
      testType = widget.fixtureDataDTO!.testType!;
    } else if (widget.compareTestResultDataDTO != null) {
      companyId = widget.compareTestResultDataDTO!.companyId!;
      siteId = widget.compareTestResultDataDTO!.siteId!;
      startDate = DateFormat("yyyy-MM-dd")
          .format(AppCache.sortFilterCacheDTO!.startDate!);
      endDate = DateFormat("yyyy-MM-dd")
          .format(AppCache.sortFilterCacheDTO!.endDate!);
      projectId = widget.compareTestResultDataDTO!.projectId!;
      testName = widget.compareTestResultDataDTO!.testName!;
      testType = widget.compareTestResultDataDTO!.testType!;
    } else if (widget.testNameDataDTO != null) {
      companyId = widget.testNameDataDTO!.companyId!;
      siteId = widget.testNameDataDTO!.siteId!;
      projectId = widget.testNameDataDTO!.projectId!;
      testName = widget.testNameDataDTO!.testName!;
      testType = widget.testNameDataDTO!.testType!;
      startDate = this.startDate;
      endDate = this.endDate;
    } else if (widget.changeLimitDTO != null) {
      companyId = widget.changeLimitDTO!.changeLimitDataDTO!.companyId!;
      siteId = widget.changeLimitDTO!.changeLimitDataDTO!.siteId!;
      projectId = widget.changeLimitDTO!.changeLimitDataDTO!.projectId!;
      testName = widget.changeLimitDTO!.changeLimitDataDTO!.testName!;
      testType = widget.changeLimitDTO!.changeLimitDataDTO!.testType!;
      startDate = this.startDate;
      endDate = this.endDate;
    }

    DqmApi dqmApi = DqmApi(context);
    return dqmApi.getCpk(companyId, siteId, startDate, endDate, equipments,
        projectId, testName, testType);
  }

  Future<TestResultCpkDTO> getTestResultCpk(BuildContext context) {
    String companyId = '';
    String siteId = '';
    String projectId = '';
    String startDate = '';
    String endDate = '';
    String testname = '';
    String testType = '';

    if (widget.pushFrom != null) {
      testname = widget.fixtureDataDTO!.testName!;
    } else {
      testname = widget.testNameDataDTO!.testName!;
    }
    if (Utils.isNotEmpty(widget.projectId)) {
      projectId = widget.projectId!;
    } else {
      projectId = widget.testNameDataDTO!.projectId!;
    }

    if (Utils.isNotEmpty(widget.from)) {
      var buffer = (DateTime.parse(widget.from!).millisecondsSinceEpoch);
      startDate = DateFormat("yyyy-MM-dd")
          .format(DateTime.fromMillisecondsSinceEpoch(buffer));
    } else {
      startDate = DateFormat("yyyy-MM-dd")
          .format(DateTime.parse(widget.testNameDataDTO!.timestamp!));
    }

    if (Utils.isNotEmpty(widget.to)) {
      var buffer = (DateTime.parse(widget.to!).millisecondsSinceEpoch);
      endDate = DateFormat("yyyy-MM-dd")
          .format(DateTime.fromMillisecondsSinceEpoch(buffer));
    } else {
      endDate = DateFormat("yyyy-MM-dd")
          .format(DateTime.parse(widget.testNameDataDTO!.timestamp!));
    }

    DqmApi dqmApi = DqmApi(context);
    return dqmApi.getCpk(companyId, siteId, startDate, endDate, [], projectId,
        testname, testType);
  }

  Future<HistogramDTO> getHistogram(
      BuildContext context, String timestamp, int binNum) {
    String companyId = '';
    String siteId = '';
    String currentDate = '';
    List<String?> equipments = [];
    String projectId = '';
    String testName = '';

    if (this.cpkDataDTO != null) {
      companyId = this.cpkDataDTO!.companyId!;
      siteId = this.cpkDataDTO!.siteId!;
      currentDate = DateFormat("yyyy-MM-dd")
          .format(DateTime.parse(this.cpkDataDTO!.latestTimeStamp!));
      projectId = this.cpkDataDTO!.projectId!;
      testName = this.cpkDataDTO!.testName!;
    }

    DqmApi dqmApi = DqmApi(context);
    return dqmApi.getHistogram(binNum, companyId, siteId, projectId, testName,
        currentDate, equipments);
  }

  // Future<HistogramDTO> getRmaTestResultHistogram(
  //     BuildContext context, String timestamp, int binNum) {
  //   String companyId = AppCache.sortFilterCacheDTO!.preferredCompany!;
  //   String siteId = AppCache.sortFilterCacheDTO!.preferredSite!;
  //   String currentDate =
  //       DateFormat("yyyy-MM-dd").format(DateTime.parse(timestamp));
  //   String projectId = '';
  //   if (Utils.isNotEmpty(widget.projectId)) {
  //     projectId = widget.projectId!;
  //   } else {
  //     projectId = widget.testNameDataDTO!.projectId!;
  //   }
  //   DqmApi dqmApi = DqmApi(context);
  //   return dqmApi.getRmaTestResultHistogram(binNum, companyId, siteId,
  //       projectId, widget.testNameDataDTO!.testName!, currentDate);
  // }

  Future<TestResultCpkDTO> getCpkForEquipment(BuildContext context) {
    String companyId = widget.compareTestResultDataDTO!.companyId!;
    String siteId = widget.compareTestResultDataDTO!.siteId!;
    String startDate = DateFormat("yyyy-MM-dd")
        .format(AppCache.sortFilterCacheDTO!.startDate!);
    String endDate =
        DateFormat("yyyy-MM-dd").format(AppCache.sortFilterCacheDTO!.endDate!);
    List<String?> equipments = AppCache.sortFilterCacheDTO!.defaultEquipments!
        .map((e) => e.equipmentId)
        .toList();
    String projectId = AppCache.sortFilterCacheDTO!.defaultProjectId!;
    String equipmentId = '';
    String testName = '';
    if (widget.compareTestResultDataDTO != null) {
      equipmentId = widget.compareTestResultDataDTO!.equipmentId!;
      testName = widget.compareTestResultDataDTO!.testName!;
    }
    DqmApi dqmApi = DqmApi(context);
    return dqmApi.getCpkForEquipment(companyId, siteId, startDate, endDate,
        equipments, projectId, equipmentId, testName);
  }

  Future<TestResultCpkDTO> getCpkForFixture(BuildContext context) {
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
    String fixtureId = '';
    String testName = '';
    if (widget.compareTestResultDataDTO != null) {
      fixtureId = widget.compareTestResultDataDTO!.fixtureId!;
      testName = widget.compareTestResultDataDTO!.testName!;
    }
    DqmApi dqmApi = DqmApi(context);
    return dqmApi.getCpkForFixture(companyId, siteId, startDate, endDate,
        equipments, projectId, fixtureId, testName);
  }

  Future<TestResultCpkDTO> getCpkForEquipmentAndFixture(BuildContext context) {
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
    String equipmentId = '';
    String fixtureId = '';
    String testName = '';
    if (widget.compareTestResultDataDTO != null) {
      equipmentId = widget.compareTestResultDataDTO!.equipmentId!;
      fixtureId = widget.compareTestResultDataDTO!.fixtureId!;
      testName = widget.compareTestResultDataDTO!.testName!;
    }
    DqmApi dqmApi = DqmApi(context);
    return dqmApi.getCpkForEquipmentAndFixture(companyId, siteId, startDate,
        endDate, equipments, projectId, equipmentId, fixtureId, testName);
  }

  Future<TestResultCpkDTO> getCpkForCombinedPanel(BuildContext context) {
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
    String testName = '';
    if (widget.compareTestResultDataDTO != null) {
      testName = widget.compareTestResultDataDTO!.testName!;
    }
    DqmApi dqmApi = DqmApi(context);
    return dqmApi.getCpkForCombinedPanel(
        companyId, siteId, startDate, endDate, equipments, projectId, testName);
  }

  Future<HistogramDTO> getHistogramForEquipment(
      BuildContext context, String timestamp, int binNum) {
    String companyId = AppCache.sortFilterCacheDTO!.preferredCompany!;
    String siteId = AppCache.sortFilterCacheDTO!.preferredSite!;
    String currentDate =
        DateFormat("yyyy-MM-dd").format(DateTime.parse(timestamp));

    List<String?> equipments = AppCache.sortFilterCacheDTO!.defaultEquipments!
        .map((e) => e.equipmentId)
        .toList();
    String projectId = AppCache.sortFilterCacheDTO!.defaultProjectId!;
    String equipmentId = '';
    String testName = '';
    if (widget.compareTestResultDataDTO != null) {
      equipmentId = widget.compareTestResultDataDTO!.equipmentId!;
      testName = widget.compareTestResultDataDTO!.testName!;
    }
    DqmApi dqmApi = DqmApi(context);
    return dqmApi.getHistogramForEquipment(binNum, companyId, siteId, projectId,
        equipmentId, testName, currentDate, equipments);
  }

  Future<HistogramDTO> getHistogramForFixture(
      BuildContext context, String timestamp, int binNum) {
    String companyId = AppCache.sortFilterCacheDTO!.preferredCompany!;
    String siteId = AppCache.sortFilterCacheDTO!.preferredSite!;
    String currentDate =
        DateFormat("yyyy-MM-dd").format(DateTime.parse(timestamp));

    List<String?> equipments = AppCache.sortFilterCacheDTO!.defaultEquipments!
        .map((e) => e.equipmentId)
        .toList();
    String projectId = AppCache.sortFilterCacheDTO!.defaultProjectId!;
    String fixtureId = '';
    String testName = '';
    if (widget.compareTestResultDataDTO != null) {
      fixtureId = widget.compareTestResultDataDTO!.fixtureId!;
      testName = widget.compareTestResultDataDTO!.testName!;
    }
    DqmApi dqmApi = DqmApi(context);
    return dqmApi.getHistogramForFixture(binNum, companyId, siteId, projectId,
        fixtureId, testName, currentDate, equipments);
  }

  Future<HistogramDTO> getHistogramForEquipmentAndFixture(
      BuildContext context, String timestamp, int binNum) {
    String companyId = AppCache.sortFilterCacheDTO!.preferredCompany!;
    String siteId = AppCache.sortFilterCacheDTO!.preferredSite!;
    String currentDate =
        DateFormat("yyyy-MM-dd").format(DateTime.parse(timestamp));

    List<String?> equipments = AppCache.sortFilterCacheDTO!.defaultEquipments!
        .map((e) => e.equipmentId)
        .toList();
    String projectId = AppCache.sortFilterCacheDTO!.defaultProjectId!;
    String equipmentId = '';
    String fixtureId = '';
    String testName = '';
    if (widget.compareTestResultDataDTO != null) {
      equipmentId = widget.compareTestResultDataDTO!.equipmentId!;
      fixtureId = widget.compareTestResultDataDTO!.fixtureId!;
      testName = widget.compareTestResultDataDTO!.testName!;
    }
    DqmApi dqmApi = DqmApi(context);
    return dqmApi.getHistogramForEquipmentAndFixture(binNum, companyId, siteId,
        projectId, fixtureId, equipmentId, testName, currentDate, equipments);
  }

  Future<HistogramDTO> getHistogramForCombinedPanel(
      BuildContext context, String timestamp, int binNum) {
    String companyId = AppCache.sortFilterCacheDTO!.preferredCompany!;
    String siteId = AppCache.sortFilterCacheDTO!.preferredSite!;
    String currentDate =
        DateFormat("yyyy-MM-dd").format(DateTime.parse(timestamp));

    List<String?> equipments = AppCache.sortFilterCacheDTO!.defaultEquipments!
        .map((e) => e.equipmentId)
        .toList();
    String projectId = AppCache.sortFilterCacheDTO!.defaultProjectId!;
    String testName = '';
    if (widget.compareTestResultDataDTO != null) {
      testName = widget.compareTestResultDataDTO!.testName!;
    }
    DqmApi dqmApi = DqmApi(context);
    return dqmApi.getHistogramForCombinedPanel(binNum, companyId, siteId,
        projectId, testName, currentDate, equipments);
  }

  void textFieldOnChange() {
    setState(() {
      if (editController.text.trim().isNotEmpty) {
        hasText = true;
      } else {
        hasText = false;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    Utils.setFirebaseAnalyticsCurrentScreen(Constants.ANALYTICS_CPK_DASHBOARD);
    editController.addListener(textFieldOnChange);
    if (widget.pushFrom != null) {
      if (widget.pushFrom == Constants.CPK_DASHBOARD_FROM_TESTRESULT_INFO ||
          widget.pushFrom == Constants.CPK_DASHBOARD_FROM_TESTRESULT_ANALOG ||
          widget.pushFrom == Constants.CPK_DASHBOARD_FROM_PAT_CHART) {
        if (widget.fixtureDataDTO != null) {
          this.startDate = DateFormat("yyyy-MM-dd")
              .format(AppCache.sortFilterCacheDTO!.startDate!);
          this.endDate = DateFormat("yyyy-MM-dd")
              .format(AppCache.sortFilterCacheDTO!.endDate!);
          checkFixtureData();
          callGetCpkData(context);
        }
      }
    } else if (widget.testNameDataDTO != null) {
      if (widget.testNameDataDTO!.timestamp.runtimeType == int) {
        this.startDate = DateFormat("yyyy-MM-dd").format(
            DateTime.fromMillisecondsSinceEpoch(
                widget.testNameDataDTO!.timestamp,
                isUtc: true));
        this.endDate = DateFormat("yyyy-MM-dd").format(
            DateTime.fromMillisecondsSinceEpoch(
                widget.testNameDataDTO!.timestamp,
                isUtc: true));
      } else {
        this.startDate = DateFormat("yyyy-MM-dd")
            .format(DateTime.parse(widget.testNameDataDTO!.timestamp!));

        this.endDate = DateFormat("yyyy-MM-dd")
            .format(DateTime.parse(widget.testNameDataDTO!.timestamp!));
      }

      checkTestnameData();
      callGetCpkData(context);
    } else if (widget.changeLimitDTO != null) {
      this.startDate = DateFormat("yyyy-MM-dd").format(DateTime.parse(
          widget.changeLimitDTO!.changeLimitDataDTO!.timestamp!));

      this.endDate = DateFormat("yyyy-MM-dd").format(DateTime.parse(
          widget.changeLimitDTO!.changeLimitDataDTO!.timestamp!));

      checkTestnameData();
      callGetCpkData(context);
    } else if (widget.compareTestResultDataDTO != null) {
      this.startDate = DateFormat("yyyy-MM-dd")
          .format(AppCache.sortFilterCacheDTO!.startDate!);
      this.endDate = DateFormat("yyyy-MM-dd")
          .format(AppCache.sortFilterCacheDTO!.endDate!);
      checkTestnameData();
      if (widget.compareBy == Constants.COMPARE_BY_EQUIPMENT) {
        callGetCpkForEquipment(context);
      } else if (widget.compareBy == Constants.COMPARE_BY_FIXTURE) {
        callGetCpkForFixture(context);
      } else if (widget.compareBy == Constants.COMPARE_BY_EQUIP_FIX) {
        callGetCpkForEquipmentAndFixture(context);
      } else if (widget.compareBy == Constants.COMPARE_BY_PANEL) {
        callGetCpkData(context);
      } else if (widget.compareBy == Constants.COMPARE_BY_ALL_PANEL) {
        callGetCpkForCombinedPanel(context);
      }
    }

    // if (widget.fixtureDataDTO != null) {
    //   if (widget.pushFrom != null) {
    //     checkTestnameData();
    //     callGetTestResultCpkData(context);
    //     this.startDate =
    //         DateFormat("yyyy-MM-dd").format(DateTime.parse(widget.from!));

    //     this.endDate =
    //         DateFormat("yyyy-MM-dd").format(DateTime.parse(widget.to!));
    //   } else {
    //     this.startDate = DateFormat("yyyy-MM-dd")
    //         .format(AppCache.sortFilterCacheDTO!.startDate!);
    //     this.endDate = DateFormat("yyyy-MM-dd")
    //         .format(AppCache.sortFilterCacheDTO!.endDate!);
    //     checkFixtureData();
    //     callGetCpkData(context);
    //   }
    // } else if (widget.testNameDataDTO != null) {
    //   if (widget.testNameDataDTO!.timestamp.runtimeType == int) {
    //     this.startDate = DateFormat("yyyy-MM-dd").format(
    //         DateTime.fromMillisecondsSinceEpoch(
    //             widget.testNameDataDTO!.timestamp,
    //             isUtc: true));
    //     this.endDate = DateFormat("yyyy-MM-dd").format(
    //         DateTime.fromMillisecondsSinceEpoch(
    //             widget.testNameDataDTO!.timestamp,
    //             isUtc: true));
    //   } else {
    //     this.startDate = DateFormat("yyyy-MM-dd")
    //         .format(DateTime.parse(widget.testNameDataDTO!.timestamp!));

    //     this.endDate = DateFormat("yyyy-MM-dd")
    //         .format(DateTime.parse(widget.testNameDataDTO!.timestamp!));
    //   }

    //   checkTestnameData();
    //   callGetTestResultCpkData(context);
    // } else if (widget.compareTestResultDataDTO != null) {
    //   this.startDate = DateFormat("yyyy-MM-dd")
    //       .format(AppCache.sortFilterCacheDTO!.startDate!);
    //   this.endDate = DateFormat("yyyy-MM-dd")
    //       .format(AppCache.sortFilterCacheDTO!.endDate!);
    //   checkTestnameData();
    //   if (widget.compareBy == Constants.COMPARE_BY_EQUIPMENT) {
    //     callGetCpkForEquipment(context);
    //   } else if (widget.compareBy == Constants.COMPARE_BY_FIXTURE) {
    //     callGetCpkForFixture(context);
    //   } else if (widget.compareBy == Constants.COMPARE_BY_EQUIP_FIX) {
    //     callGetCpkForEquipmentAndFixture(context);
    //   } else if (widget.compareBy == Constants.COMPARE_BY_PANEL) {
    //     callGetCpkData(context);
    //   } else if (widget.compareBy == Constants.COMPARE_BY_ALL_PANEL) {
    //     callGetCpkForCombinedPanel(context);
    //   }
    // }
  }

  @override
  void dispose() {
    editController.dispose();
    super.dispose();
  }

  checkFixtureData() {
    if (widget.fixtureDataDTO != null) {
      if (Utils.isNotEmpty(widget.fixtureDataDTO!.status)) {
        if (widget.fixtureDataDTO!.status == "Anomaly") {
          this.isAnomaly = true;
        } else if (widget.fixtureDataDTO!.status!.contains("PASS") ||
            widget.fixtureDataDTO!.status!.contains("Pass") ||
            widget.fixtureDataDTO!.status!.contains("pass")) {
          this.isPass = true;
        } else {
          this.isFail = true;
        }
      } else if (Utils.isNotEmpty(widget.fixtureDataDTO!.isFalseFailure) &&
          widget.fixtureDataDTO!.isFalseFailure == "true") {
        this.isFalseFailure = true;
      } else if (Utils.isNotEmpty(widget.fixtureDataDTO!.isAnomaly) &&
          widget.fixtureDataDTO!.isAnomaly == "true") {
        this.isAnomaly = true;
      } else {
        this.isFail = true;
      }
    }
  }

  checkTestnameData() {
    if (widget.testNameDataDTO != null) {
      if (Utils.isNotEmpty(widget.testNameDataDTO!.status)) {
        if (widget.testNameDataDTO!.status == "Anomaly") {
          this.isAnomaly = true;
        } else if (widget.testNameDataDTO!.status!.contains("PASS") ||
            widget.testNameDataDTO!.status!.contains("Pass") ||
            widget.testNameDataDTO!.status!.contains("pass")) {
          this.isPass = true;
        } else if (Utils.isNotEmpty(widget.testNameDataDTO!.isFalseFailure) &&
            widget.testNameDataDTO!.isFalseFailure == "true") {
          this.isFalseFailure = true;
        } else if (Utils.isNotEmpty(widget.testNameDataDTO!.isAnomaly) &&
            widget.testNameDataDTO!.isAnomaly == "true") {
          this.isAnomaly = true;
        } else {
          this.isFail = true;
        }
      } else if (Utils.isNotEmpty(widget.testNameDataDTO!.isFalseFailure) &&
          widget.testNameDataDTO!.isFalseFailure == "true") {
        this.isFalseFailure = true;
      } else if (Utils.isNotEmpty(widget.testNameDataDTO!.isAnomaly) &&
          widget.testNameDataDTO!.isAnomaly == "true") {
        this.isAnomaly = true;
      } else {
        this.isFail = true;
      }
    } else if (widget.changeLimitDTO != null) {
      if (widget.changeLimitDTO!.isLimiChange!) {
        this.isLimiChange = true;
      } else {
        this.isLimiChange = false;
        if (Utils.isNotEmpty(
            widget.changeLimitDTO!.changeLimitDataDTO!.status)) {
          if (widget.changeLimitDTO!.changeLimitDataDTO!.status == "Anomaly") {
            this.isAnomaly = true;
          } else if (widget.changeLimitDTO!.changeLimitDataDTO!.status!
                  .contains("PASS") ||
              widget.changeLimitDTO!.changeLimitDataDTO!.status!
                  .contains("Pass") ||
              widget.changeLimitDTO!.changeLimitDataDTO!.status!
                  .contains("pass")) {
            this.isPass = true;
          } else if (Utils.isNotEmpty(
                  widget.changeLimitDTO!.changeLimitDataDTO!.isFalseFailure) &&
              widget.changeLimitDTO!.changeLimitDataDTO!.isFalseFailure ==
                  "true") {
            this.isFalseFailure = true;
          } else if (Utils.isNotEmpty(
                  widget.changeLimitDTO!.changeLimitDataDTO!.isAnomaly) &&
              widget.changeLimitDTO!.changeLimitDataDTO!.isAnomaly == "true") {
            this.isAnomaly = true;
          } else {
            this.isFail = true;
          }
        } else if (Utils.isNotEmpty(
                widget.changeLimitDTO!.changeLimitDataDTO!.isFalseFailure) &&
            widget.changeLimitDTO!.changeLimitDataDTO!.isFalseFailure ==
                "true") {
          this.isFalseFailure = true;
        } else if (Utils.isNotEmpty(
                widget.changeLimitDTO!.changeLimitDataDTO!.isAnomaly) &&
            widget.changeLimitDTO!.changeLimitDataDTO!.isAnomaly == "true") {
          this.isAnomaly = true;
        } else {
          this.isFail = true;
        }
      }
    } else if (widget.compareTestResultDataDTO != null) {
      if (Utils.isNotEmpty(widget.compareTestResultDataDTO!.status)) {
        if (widget.compareTestResultDataDTO!.status == "Anomaly") {
          this.isAnomaly = true;
        } else if (widget.compareTestResultDataDTO!.status!.contains("PASS") ||
            widget.compareTestResultDataDTO!.status!.contains("Pass") ||
            widget.compareTestResultDataDTO!.status!.contains("pass")) {
          this.isPass = true;
        } else if (Utils.isNotEmpty(
                widget.compareTestResultDataDTO!.isFalseFailure) &&
            widget.compareTestResultDataDTO!.isFalseFailure == "true") {
          this.isFalseFailure = true;
        } else if (Utils.isNotEmpty(
                widget.compareTestResultDataDTO!.isAnomaly) &&
            widget.compareTestResultDataDTO!.isAnomaly == "true") {
          this.isAnomaly = true;
        } else {
          this.isFail = true;
        }
      } else if (Utils.isNotEmpty(
              widget.compareTestResultDataDTO!.isFalseFailure) &&
          widget.compareTestResultDataDTO!.isFalseFailure == "true") {
        this.isFalseFailure = true;
      } else if (Utils.isNotEmpty(widget.compareTestResultDataDTO!.isAnomaly) &&
          widget.compareTestResultDataDTO!.isAnomaly == "true") {
        this.isAnomaly = true;
      } else {
        this.isFail = true;
      }
    }
  }

  callGetCpkData(BuildContext context) async {
    await getFixtureCpk(context).then((value) {
      if (value.status!.statusCode == 200) {
        this.testResultCpkDTO = value;
        Utils.printInfo(jsonEncode(value.data![0]));
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
        this.isLoading = false;
      });
    });
  }

  callGetTestResultCpkData(BuildContext context) async {
    await getTestResultCpk(context).then((value) {
      if (value.status!.statusCode == 200) {
        this.testResultCpkDTO = value;
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
        this.isLoading = false;
      });
    });
  }

  callGetHistogram(BuildContext context, String timestamp, int binNum) async {
    await getHistogram(context, timestamp, binNum).then((value) {
      this.histogramDTO = value;
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
        this.isViewHistogram = true;
        if (EasyLoading.isShow) {
          EasyLoading.dismiss();
          this.histogramWebViewController.webViewController.reload();
          this.smallHistogramWebViewController.webViewController.reload();
        }
      });
    });
  }

  // callGetRmaTestResultHistogram(
  //     BuildContext context, String timestamp, int binNum) async {
  //   await getRmaTestResultHistogram(context, timestamp, binNum).then((value) {
  //     this.histogramDTO = value;
  //   }).catchError((error) {
  //     Utils.printInfo(error);
  //     if (error is DioError) {
  //       if (error.response != null) {
  //         if (error.response!.data != null) {
  //           Utils.showAlertDialog(
  //               context,
  //               Utils.getTranslated(context, 'general_alert_error_title')!,
  //               error.response!.data['errorMessage'].toString());
  //         } else {
  //           Utils.showAlertDialog(
  //               context,
  //               Utils.getTranslated(context, 'general_alert_error_title')!,
  //               Utils.getTranslated(context, 'general_alert_error_message')!);
  //         }
  //       } else {
  //         Utils.showAlertDialog(
  //             context,
  //             Utils.getTranslated(context, 'general_alert_error_title')!,
  //             Utils.getTranslated(context, 'general_alert_error_message')!);
  //       }
  //     } else {
  //       Utils.showAlertDialog(
  //           context,
  //           Utils.getTranslated(context, 'general_alert_error_title')!,
  //           Utils.getTranslated(context, 'general_alert_error_message')!);
  //     }
  //   }).whenComplete(() {
  //     setState(() {
  //       this.isViewHistogram = true;
  //       if (EasyLoading.isShow) {
  //         EasyLoading.dismiss();
  //         this.histogramWebViewController.webViewController.reload();
  //         this.smallHistogramWebViewController.webViewController.reload();
  //       }
  //     });
  //   });
  // }

  callGetCpkForEquipment(BuildContext context) async {
    await getCpkForEquipment(context).then((value) {
      if (value.status!.statusCode == 200) {
        this.testResultCpkDTO = value;
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
        this.isLoading = false;
      });
    });
  }

  callGetCpkForFixture(BuildContext context) async {
    await getCpkForFixture(context).then((value) {
      if (value.status!.statusCode == 200) {
        this.testResultCpkDTO = value;
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
        this.isLoading = false;
      });
    });
  }

  callGetCpkForEquipmentAndFixture(BuildContext context) async {
    await getCpkForEquipmentAndFixture(context).then((value) {
      if (value.status!.statusCode == 200) {
        this.testResultCpkDTO = value;
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
        this.isLoading = false;
      });
    });
  }

  callGetCpkForCombinedPanel(BuildContext context) async {
    await getCpkForCombinedPanel(context).then((value) {
      if (value.status!.statusCode == 200) {
        this.testResultCpkDTO = value;
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
        this.isLoading = false;
      });
    });
  }

  callGetHistogramForEquipment(
      BuildContext context, String timestamp, int binNum) async {
    await getHistogramForEquipment(context, timestamp, binNum).then((value) {
      if (value.status!.statusCode == 200) {
        this.histogramDTO = value;
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
        this.isViewHistogram = true;
        if (EasyLoading.isShow) {
          EasyLoading.dismiss();
          this.histogramWebViewController.webViewController.reload();
          this.smallHistogramWebViewController.webViewController.reload();
        }
      });
    });
  }

  callGetHistogramForFixture(
      BuildContext context, String timestamp, int binNum) async {
    await getHistogramForFixture(context, timestamp, binNum).then((value) {
      if (value.status!.statusCode == 200) {
        this.histogramDTO = value;
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
        this.isViewHistogram = true;
        if (EasyLoading.isShow) {
          EasyLoading.dismiss();
          this.histogramWebViewController.webViewController.reload();
          this.smallHistogramWebViewController.webViewController.reload();
        }
      });
    });
  }

  callGetHistogramForEquipmentAndFixture(
      BuildContext context, String timestamp, int binNum) async {
    await getHistogramForEquipmentAndFixture(context, timestamp, binNum)
        .then((value) {
      if (value.status!.statusCode == 200) {
        this.histogramDTO = value;
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
        this.isViewHistogram = true;
        if (EasyLoading.isShow) {
          EasyLoading.dismiss();
          this.histogramWebViewController.webViewController.reload();
          this.smallHistogramWebViewController.webViewController.reload();
        }
      });
    });
  }

  callGetHistogramForCombinedPanel(
      BuildContext context, String timestamp, int binNum) async {
    await getHistogramForCombinedPanel(context, timestamp, binNum)
        .then((value) {
      if (value.status!.statusCode == 200) {
        this.histogramDTO = value;
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
        this.isViewHistogram = true;
        if (EasyLoading.isShow) {
          EasyLoading.dismiss();
          this.histogramWebViewController.webViewController.reload();
          this.smallHistogramWebViewController.webViewController.reload();
        }
      });
    });
  }

  calculateSkewness() {
    // const N = x.length;
    // const mean = x.reduce((i, j) => i + j) / N;
    // const norm2X = x.map(i => Math.pow(i - mean, 2));
    // const moment2 = norm2X.reduce((i, j) => i + j) / N;
    // const stddev = Math.sqrt(moment2);

    // const norm3X = x.map(i => Math.pow(i - mean, 3));
    // const moment3 = norm3X.reduce((i, j) => i + j) / N;

    // // Pearson's moment coefficient of skewness
    // const coeffSkew = moment2 === 0 ? 0 : moment3 / Math.pow(moment2, 1.5);
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
            Utils.getTranslated(context, 'dqm_rma_cpk_dashboard_appbar_title')!,
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
      ),
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.all(16.0),
          child: this.isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppColors.appBlue()),
                  ),
                )
              : GestureDetector(
                  onTap: () {
                    FocusScopeNode currentFocus = FocusScope.of(context);
                    if (!currentFocus.hasPrimaryFocus) {
                      currentFocus.unfocus();
                    }
                  },
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        cpkInfo(context),
                        dailyCpkInfo(context),
                        dailyCpkChart(context),
                        !isViewHistogram
                            ? histogramEmpty(context)
                            : Container(),
                        isViewHistogram ? histogramChart(context) : Container(),
                        isViewHistogram ? histogramInfo(context) : Container(),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Widget cpkInfo(BuildContext ctx) {
    if (widget.pushFrom != null) {
      if (widget.pushFrom == Constants.CPK_DASHBOARD_FROM_TESTRESULT_INFO ||
          widget.pushFrom == Constants.CPK_DASHBOARD_FROM_PAT_CHART) {
        if (widget.fixtureDataDTO != null) {
          return Container(
            margin: EdgeInsets.only(top: 25.0),
            padding: EdgeInsets.all(14.0),
            decoration: BoxDecoration(
              color: theme_dark!
                  ? AppColors.appBlack2C()
                  : AppColorsLightMode.appGreyBA(),
              border: Border.all(
                color: theme_dark!
                    ? AppColors.appBlackLight()
                    : AppColorsLightMode.appGreyDE(),
              ),
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat("EEEE, MMM dd, yyyy HH:mm:ss").format(
                      DateTime.parse(widget.fixtureDataDTO!.timestamp!)),
                  style: AppFonts.robotoRegular(
                    16,
                    color: theme_dark!
                        ? AppColors.appGrey2()
                        : AppColorsLightMode.appGrey(),
                    decoration: TextDecoration.none,
                  ),
                ),
                SizedBox(height: 17.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      this.isAnomaly
                          ? '${Utils.getTranslated(ctx, 'chart_legend_anomaly')}: '
                          : this.isFalseFailure
                              ? '${Utils.getTranslated(ctx, 'chart_legend_false_failure')}: '
                              : this.isPass
                                  ? '${Utils.getTranslated(ctx, 'chart_legend_pass')}: '
                                  : this.isFail
                                      ? '${Utils.getTranslated(ctx, 'chart_legend_fail')}: '
                                      : '',
                      style: AppFonts.robotoRegular(
                        16,
                        color: this.isAnomaly
                            ? HexColor('FF6BBB').withOpacity(0.5)
                            : this.isFalseFailure
                                ? HexColor('FFA07A').withOpacity(0.5)
                                : this.isPass
                                    ? HexColor('73D32C').withOpacity(0.5)
                                    : this.isFail
                                        ? HexColor('E3022A').withOpacity(0.5)
                                        : AppColors.appGrey2(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                    Text(
                      Utils.isNotEmpty(widget.fixtureDataDTO!.measured)
                          ? '${Utils.prefixConversion(widget.fixtureDataDTO!.measured, 4)}'
                          : '0',
                      style: AppFonts.robotoRegular(
                        16,
                        color: this.isAnomaly
                            ? HexColor('FF6BBB').withOpacity(0.5)
                            : this.isFalseFailure
                                ? HexColor('FFA07A').withOpacity(0.5)
                                : this.isPass
                                    ? HexColor('73D32C').withOpacity(0.5)
                                    : this.isFail
                                        ? HexColor('E3022A').withOpacity(0.5)
                                        : AppColors.appGrey2(),
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
                              ctx, 'dqm_testresult_analog_sortby_testname')! +
                          ': ',
                      style: AppFonts.robotoRegular(
                        16,
                        color: theme_dark!
                            ? AppColors.appGrey2()
                            : AppColorsLightMode.appGrey(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                    Flexible(
                      child: Text(
                        '${widget.fixtureDataDTO!.testName}',
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
                SizedBox(height: 17.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      Utils.getTranslated(ctx, 'dqm_rma_sortby_equipment')! +
                          ': ',
                      style: AppFonts.robotoRegular(
                        16,
                        color: theme_dark!
                            ? AppColors.appGrey2()
                            : AppColorsLightMode.appGrey(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                    Flexible(
                      child: Text(
                        '${widget.fixtureDataDTO!.equipmentName}',
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
                SizedBox(height: 17.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      Utils.getTranslated(
                              ctx, 'dqm_rma_cpk_dashboard_fixture_id')! +
                          ': ',
                      style: AppFonts.robotoRegular(
                        16,
                        color: theme_dark!
                            ? AppColors.appGrey2()
                            : AppColorsLightMode.appGrey(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                    Text(
                      '${widget.fixtureDataDTO!.fixtureId}',
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
                SizedBox(height: 17.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Utils.getTranslated(
                              ctx, 'dqm_rma_cpk_dashboard_serial_nulber')! +
                          ': ',
                      style: AppFonts.robotoRegular(
                        16,
                        color: theme_dark!
                            ? AppColors.appGrey2()
                            : AppColorsLightMode.appGrey(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                    Flexible(
                      child: Text(
                        '${widget.fixtureDataDTO!.serialNumber}',
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
                SizedBox(height: 17.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      Utils.getTranslated(ctx,
                              'dqm_testresult_analog_info_filterby_test_type')! +
                          ': ',
                      style: AppFonts.robotoMedium(
                        14,
                        color: theme_dark!
                            ? AppColors.appGrey2()
                            : AppColorsLightMode.appGrey(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                    Text(
                      '${widget.fixtureDataDTO!.testType}',
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
                SizedBox(height: 17.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Utils.getTranslated(
                              ctx, 'dqm_testresult_cpk_dashboard_testunit')! +
                          ': ',
                      style: AppFonts.robotoRegular(
                        16,
                        color: theme_dark!
                            ? AppColors.appGrey2()
                            : AppColorsLightMode.appGrey(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                    Text(
                      '${widget.fixtureDataDTO!.testUnit}',
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
              ],
            ),
          );
        }
      } else if (widget.pushFrom ==
          Constants.CPK_DASHBOARD_FROM_TESTRESULT_ANALOG) {
        if (widget.fixtureDataDTO != null && widget.analogCpkData != null) {
          return Container(
            margin: EdgeInsets.only(top: 25.0),
            padding: EdgeInsets.all(14.0),
            decoration: BoxDecoration(
              color: theme_dark!
                  ? AppColors.appBlack2C()
                  : AppColorsLightMode.appGreyBA(),
              border: Border.all(
                color: theme_dark!
                    ? AppColors.appBlackLight()
                    : AppColorsLightMode.appGreyDE(),
              ),
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat("EEEE, MMM dd, yyyy HH:mm:ss").format(
                      DateTime.parse(widget.fixtureDataDTO!.timestamp!)),
                  style: AppFonts.robotoRegular(
                    16,
                    color: theme_dark!
                        ? AppColors.appGrey2()
                        : AppColorsLightMode.appGrey(),
                    decoration: TextDecoration.none,
                  ),
                ),
                SizedBox(height: 17.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      this.isAnomaly
                          ? '${Utils.getTranslated(ctx, 'chart_legend_anomaly')}: '
                          : this.isFalseFailure
                              ? '${Utils.getTranslated(ctx, 'chart_legend_false_failure')}: '
                              : this.isPass
                                  ? '${Utils.getTranslated(ctx, 'chart_legend_pass')}: '
                                  : this.isFail
                                      ? '${Utils.getTranslated(ctx, 'chart_legend_fail')}: '
                                      : '',
                      style: AppFonts.robotoRegular(
                        16,
                        color: this.isAnomaly
                            ? HexColor('FF6BBB').withOpacity(0.5)
                            : this.isFalseFailure
                                ? HexColor('FFA07A').withOpacity(0.5)
                                : this.isPass
                                    ? HexColor('73D32C').withOpacity(0.5)
                                    : this.isFail
                                        ? HexColor('E3022A').withOpacity(0.5)
                                        : AppColors.appGrey2(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                    Text(
                      Utils.isNotEmpty(widget.fixtureDataDTO!.measured)
                          ? '${Utils.prefixConversion(widget.fixtureDataDTO!.measured, 4)}'
                          : '0',
                      style: AppFonts.robotoRegular(
                        16,
                        color: this.isAnomaly
                            ? HexColor('FF6BBB').withOpacity(0.5)
                            : this.isFalseFailure
                                ? HexColor('FFA07A').withOpacity(0.5)
                                : this.isPass
                                    ? HexColor('73D32C').withOpacity(0.5)
                                    : this.isFail
                                        ? HexColor('E3022A').withOpacity(0.5)
                                        : AppColors.appGrey2(),
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
                      Utils.getTranslated(
                              ctx, 'dqm_testresult_analog_sortby_testname')! +
                          ': ',
                      style: AppFonts.robotoRegular(
                        16,
                        color: theme_dark!
                            ? AppColors.appGrey2()
                            : AppColorsLightMode.appGrey(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                    Flexible(
                      child: Text(
                        '${widget.analogCpkData!.testName}',
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
                SizedBox(height: 17.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Utils.getTranslated(ctx, 'dqm_rma_sortby_equipment')! +
                          ': ',
                      style: AppFonts.robotoRegular(
                        16,
                        color: theme_dark!
                            ? AppColors.appGrey2()
                            : AppColorsLightMode.appGrey(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                    Flexible(
                      child: Text(
                        '${widget.fixtureDataDTO!.equipmentName}',
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
                SizedBox(height: 17.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Utils.getTranslated(
                              ctx, 'dqm_rma_cpk_dashboard_fixture_id')! +
                          ': ',
                      style: AppFonts.robotoRegular(
                        16,
                        color: theme_dark!
                            ? AppColors.appGrey2()
                            : AppColorsLightMode.appGrey(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                    Text(
                      '${widget.fixtureDataDTO!.fixtureId}',
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
                SizedBox(height: 17.0),
                widget.analogCpkData!.threshold != null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                Utils.getTranslated(ctx,
                                        'dqm_testresult_analog_detail_threshold')! +
                                    ': ',
                                style: AppFonts.robotoRegular(
                                  16,
                                  color: theme_dark!
                                      ? AppColors.appGrey2()
                                      : AppColorsLightMode.appGrey(),
                                  decoration: TextDecoration.none,
                                ),
                              ),
                              Flexible(
                                child: Text(
                                  '${widget.analogCpkData!.threshold}',
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
                          SizedBox(height: 17.0),
                        ],
                      )
                    : Container(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Utils.getTranslated(
                              ctx, 'dqm_rma_cpk_dashboard_serial_nulber')! +
                          ': ',
                      style: AppFonts.robotoRegular(
                        16,
                        color: theme_dark!
                            ? AppColors.appGrey2()
                            : AppColorsLightMode.appGrey(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                    Flexible(
                      child: Text(
                        '${widget.fixtureDataDTO!.serialNumber}',
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
                SizedBox(height: 17.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      Utils.getTranslated(ctx,
                              'dqm_testresult_analog_info_filterby_test_type')! +
                          ': ',
                      style: AppFonts.robotoMedium(
                        14,
                        color: theme_dark!
                            ? AppColors.appGrey2()
                            : AppColorsLightMode.appGrey(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                    Text(
                      '${widget.fixtureDataDTO!.testType}',
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
                SizedBox(height: 17.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Utils.getTranslated(
                              ctx, 'dqm_testresult_cpk_dashboard_testunit')! +
                          ': ',
                      style: AppFonts.robotoRegular(
                        16,
                        color: theme_dark!
                            ? AppColors.appGrey2()
                            : AppColorsLightMode.appGrey(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                    Text(
                      '${widget.fixtureDataDTO!.testUnit}',
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
              ],
            ),
          );
        }
      }
    } else if (widget.testNameDataDTO != null) {
      return Container(
        margin: EdgeInsets.only(top: 25.0),
        padding: EdgeInsets.all(14.0),
        decoration: BoxDecoration(
          color: theme_dark!
              ? AppColors.appBlack2C()
              : AppColors.appPrimaryWhite(),
          border: Border.all(
            color:
                theme_dark! ? AppColors.appBlackLight() : AppColors.appGreyDE(),
          ),
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              (widget.testNameDataDTO!.timestamp.runtimeType == int)
                  ? DateFormat("EEEE, MMM dd, yyyy HH:mm:ss").format(
                      DateTime.fromMillisecondsSinceEpoch(
                          widget.testNameDataDTO!.timestamp!))
                  : DateFormat("EEEE, MMM dd, yyyy HH:mm:ss").format(
                      DateTime.parse(widget.testNameDataDTO!.timestamp!)),
              style: AppFonts.robotoRegular(
                16,
                color: theme_dark!
                    ? AppColors.appGrey2()
                    : AppColorsLightMode.appGrey(),
                decoration: TextDecoration.none,
              ),
            ),
            SizedBox(height: 17.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  this.isAnomaly
                      ? '${Utils.getTranslated(ctx, 'chart_legend_anomaly')}: '
                      : this.isFalseFailure
                          ? '${Utils.getTranslated(ctx, 'chart_legend_false_failure')}: '
                          : this.isPass
                              ? '${Utils.getTranslated(ctx, 'chart_legend_pass')}: '
                              : this.isFail
                                  ? '${Utils.getTranslated(ctx, 'chart_legend_fail')}: '
                                  : '',
                  style: AppFonts.robotoRegular(
                    16,
                    color: this.isAnomaly
                        ? HexColor('FF6BBB').withOpacity(0.5)
                        : this.isFalseFailure
                            ? HexColor('FFA07A').withOpacity(0.5)
                            : this.isPass
                                ? HexColor('73D32C').withOpacity(0.5)
                                : this.isFail
                                    ? HexColor('E3022A').withOpacity(0.5)
                                    : AppColors.appGrey2(),
                    decoration: TextDecoration.none,
                  ),
                ),
                Text(
                  Utils.isNotEmpty(widget.testNameDataDTO!.measured)
                      ? '${Utils.prefixConversion(widget.testNameDataDTO!.measured, 4)}'
                      : '0',
                  style: AppFonts.robotoRegular(
                    16,
                    color: this.isAnomaly
                        ? HexColor('FF6BBB').withOpacity(0.5)
                        : this.isFalseFailure
                            ? HexColor('FFA07A').withOpacity(0.5)
                            : this.isPass
                                ? HexColor('73D32C').withOpacity(0.5)
                                : this.isFail
                                    ? HexColor('E3022A').withOpacity(0.5)
                                    : AppColors.appGrey2(),
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
                  Utils.getTranslated(
                          ctx, 'dqm_testresult_analog_sortby_testname')! +
                      ': ',
                  style: AppFonts.robotoRegular(
                    16,
                    color: theme_dark!
                        ? AppColors.appGrey2()
                        : AppColorsLightMode.appGrey(),
                    decoration: TextDecoration.none,
                  ),
                ),
                Flexible(
                  child: Text(
                    '${widget.testNameDataDTO!.testName}',
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
            SizedBox(height: 17.0),
            Utils.isNotEmpty(widget.testNameDataDTO!.equipmentName)
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Utils.getTranslated(
                                    ctx, 'dqm_rma_sortby_equipment')! +
                                ': ',
                            style: AppFonts.robotoRegular(
                              16,
                              color: theme_dark!
                                  ? AppColors.appGrey2()
                                  : AppColorsLightMode.appGrey(),
                              decoration: TextDecoration.none,
                            ),
                          ),
                          Flexible(
                            child: Text(
                              '${widget.testNameDataDTO!.equipmentName}',
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
                      SizedBox(height: 17.0),
                    ],
                  )
                : Container(),
            Visibility(
              visible: Utils.isNotEmpty(widget.testNameDataDTO!.fixtureId),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Utils.getTranslated(
                            ctx, 'dqm_rma_cpk_dashboard_fixture_id')! +
                        ': ',
                    style: AppFonts.robotoRegular(
                      16,
                      color: theme_dark!
                          ? AppColors.appGrey2()
                          : AppColorsLightMode.appGrey(),
                      decoration: TextDecoration.none,
                    ),
                  ),
                  Text(
                    '${widget.testNameDataDTO!.fixtureId}',
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
            ),
            Visibility(
              visible: Utils.isNotEmpty(widget.testNameDataDTO!.fixtureId),
              child: SizedBox(height: 17.0),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Utils.getTranslated(
                          ctx, 'dqm_rma_cpk_dashboard_serial_nulber')! +
                      ': ',
                  style: AppFonts.robotoRegular(
                    16,
                    color: theme_dark!
                        ? AppColors.appGrey2()
                        : AppColorsLightMode.appGrey(),
                    decoration: TextDecoration.none,
                  ),
                ),
                Flexible(
                  child: Text(
                    '${widget.testNameDataDTO!.serialNumber}',
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
            SizedBox(height: 17.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  Utils.getTranslated(ctx,
                          'dqm_testresult_analog_info_filterby_test_type')! +
                      ': ',
                  style: AppFonts.robotoMedium(
                    14,
                    color: theme_dark!
                        ? AppColors.appGrey2()
                        : AppColorsLightMode.appGrey(),
                    decoration: TextDecoration.none,
                  ),
                ),
                Text(
                  '${widget.testNameDataDTO!.testType}',
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
            SizedBox(height: 17.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Utils.getTranslated(
                          ctx, 'dqm_testresult_cpk_dashboard_testunit')! +
                      ': ',
                  style: AppFonts.robotoRegular(
                    16,
                    color: theme_dark!
                        ? AppColors.appGrey2()
                        : AppColorsLightMode.appGrey(),
                    decoration: TextDecoration.none,
                  ),
                ),
                Text(
                  '${widget.testNameDataDTO!.testUnit}',
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
          ],
        ),
      );
    } else if (widget.changeLimitDTO != null) {
      return Container(
        margin: EdgeInsets.only(top: 25.0),
        padding: EdgeInsets.all(14.0),
        decoration: BoxDecoration(
          color: theme_dark!
              ? AppColors.appBlack2C()
              : AppColors.appPrimaryWhite(),
          border: Border.all(
            color:
                theme_dark! ? AppColors.appBlackLight() : AppColors.appGreyDE(),
          ),
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              DateFormat("EEEE, MMM dd, yyyy HH:mm:ss").format(DateTime.parse(
                  widget.changeLimitDTO!.changeLimitDataDTO!.timestamp!)),
              style: AppFonts.robotoRegular(
                16,
                color: theme_dark!
                    ? AppColors.appGrey2()
                    : AppColorsLightMode.appGrey(),
                decoration: TextDecoration.none,
              ),
            ),
            SizedBox(height: 17.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  this.isLimiChange
                      ? '${Utils.getTranslated(ctx, 'chart_legend_limit_change')}: '
                      : this.isAnomaly
                          ? '${Utils.getTranslated(ctx, 'chart_legend_anomaly')}: '
                          : this.isFalseFailure
                              ? '${Utils.getTranslated(ctx, 'chart_legend_false_failure')}: '
                              : this.isPass
                                  ? '${Utils.getTranslated(ctx, 'chart_legend_pass')}: '
                                  : this.isFail
                                      ? '${Utils.getTranslated(ctx, 'chart_legend_fail')}: '
                                      : '',
                  style: AppFonts.robotoRegular(
                    16,
                    color: this.isLimiChange
                        ? HexColor('F5D745')
                        : this.isAnomaly
                            ? HexColor('FF6BBB').withOpacity(0.5)
                            : this.isFalseFailure
                                ? HexColor('FFA07A').withOpacity(0.5)
                                : this.isPass
                                    ? HexColor('73D32C').withOpacity(0.5)
                                    : this.isFail
                                        ? HexColor('E3022A').withOpacity(0.5)
                                        : AppColors.appGrey2(),
                    decoration: TextDecoration.none,
                  ),
                ),
                Text(
                  Utils.isNotEmpty(
                          widget.changeLimitDTO!.changeLimitDataDTO!.measured)
                      ? '${Utils.prefixConversion(widget.changeLimitDTO!.changeLimitDataDTO!.measured, 4)}'
                      : '0',
                  style: AppFonts.robotoRegular(
                    16,
                    color: this.isLimiChange
                        ? HexColor('F5D745')
                        : this.isAnomaly
                            ? HexColor('FF6BBB').withOpacity(0.5)
                            : this.isFalseFailure
                                ? HexColor('FFA07A').withOpacity(0.5)
                                : this.isPass
                                    ? HexColor('73D32C').withOpacity(0.5)
                                    : this.isFail
                                        ? HexColor('E3022A').withOpacity(0.5)
                                        : AppColors.appGrey2(),
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
                  Utils.getTranslated(
                          ctx, 'dqm_testresult_analog_sortby_testname')! +
                      ': ',
                  style: AppFonts.robotoRegular(
                    16,
                    color: theme_dark!
                        ? AppColors.appGrey2()
                        : AppColorsLightMode.appGrey(),
                    decoration: TextDecoration.none,
                  ),
                ),
                Flexible(
                  child: Text(
                    '${widget.changeLimitDTO!.changeLimitDataDTO!.testName}',
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
            SizedBox(height: 17.0),
            Utils.isNotEmpty(
                    widget.changeLimitDTO!.changeLimitDataDTO!.equipmentName)
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Utils.getTranslated(
                                    ctx, 'dqm_rma_sortby_equipment')! +
                                ': ',
                            style: AppFonts.robotoRegular(
                              16,
                              color: theme_dark!
                                  ? AppColors.appGrey2()
                                  : AppColorsLightMode.appGrey(),
                              decoration: TextDecoration.none,
                            ),
                          ),
                          Flexible(
                            child: Text(
                              '${widget.changeLimitDTO!.changeLimitDataDTO!.equipmentName}',
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
                      SizedBox(height: 17.0),
                    ],
                  )
                : Container(),
            Visibility(
              visible: Utils.isNotEmpty(
                  widget.changeLimitDTO!.changeLimitDataDTO!.fixtureId),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Utils.getTranslated(
                            ctx, 'dqm_rma_cpk_dashboard_fixture_id')! +
                        ': ',
                    style: AppFonts.robotoRegular(
                      16,
                      color: theme_dark!
                          ? AppColors.appGrey2()
                          : AppColorsLightMode.appGrey(),
                      decoration: TextDecoration.none,
                    ),
                  ),
                  Text(
                    '${widget.changeLimitDTO!.changeLimitDataDTO!.fixtureId}',
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
            ),
            Visibility(
              visible: Utils.isNotEmpty(
                  widget.changeLimitDTO!.changeLimitDataDTO!.fixtureId),
              child: SizedBox(height: 17.0),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Utils.getTranslated(
                          ctx, 'dqm_rma_cpk_dashboard_serial_nulber')! +
                      ': ',
                  style: AppFonts.robotoRegular(
                    16,
                    color: theme_dark!
                        ? AppColors.appGrey2()
                        : AppColorsLightMode.appGrey(),
                    decoration: TextDecoration.none,
                  ),
                ),
                Flexible(
                  child: Text(
                    '${widget.changeLimitDTO!.changeLimitDataDTO!.serialNumber}',
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
            SizedBox(height: 17.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  Utils.getTranslated(ctx,
                          'dqm_testresult_analog_info_filterby_test_type')! +
                      ': ',
                  style: AppFonts.robotoMedium(
                    14,
                    color: theme_dark!
                        ? AppColors.appGrey2()
                        : AppColorsLightMode.appGrey(),
                    decoration: TextDecoration.none,
                  ),
                ),
                Text(
                  '${widget.changeLimitDTO!.changeLimitDataDTO!.testType}',
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
            SizedBox(height: 17.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Utils.getTranslated(
                          ctx, 'dqm_testresult_cpk_dashboard_testunit')! +
                      ': ',
                  style: AppFonts.robotoRegular(
                    16,
                    color: theme_dark!
                        ? AppColors.appGrey2()
                        : AppColorsLightMode.appGrey(),
                    decoration: TextDecoration.none,
                  ),
                ),
                Text(
                  '${widget.changeLimitDTO!.changeLimitDataDTO!.testUnit}',
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
          ],
        ),
      );
    } else if (widget.compareTestResultDataDTO != null) {
      return Container(
        margin: EdgeInsets.only(top: 25.0),
        padding: EdgeInsets.all(14.0),
        decoration: BoxDecoration(
          color: theme_dark!
              ? AppColors.appBlack2C()
              : AppColors.appPrimaryWhite(),
          border: Border.all(
            color:
                theme_dark! ? AppColors.appBlackLight() : AppColors.appGreyDE(),
          ),
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              (Utils.isNotEmpty(widget.compareTestResultDataDTO!.timestamp))
                  ? DateFormat("EEEE, MMM dd, yyyy HH:mm:ss").format(
                      DateTime.parse(
                          widget.compareTestResultDataDTO!.timestamp!))
                  : '',
              style: AppFonts.robotoRegular(
                16,
                color: theme_dark!
                    ? AppColors.appGrey2()
                    : AppColorsLightMode.appGrey(),
                decoration: TextDecoration.none,
              ),
            ),
            SizedBox(height: 17.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  this.isAnomaly
                      ? '${Utils.getTranslated(ctx, 'chart_legend_anomaly')}: '
                      : this.isFalseFailure
                          ? '${Utils.getTranslated(ctx, 'chart_legend_false_failure')}: '
                          : this.isPass
                              ? '${Utils.getTranslated(ctx, 'chart_legend_pass')}: '
                              : this.isFail
                                  ? '${Utils.getTranslated(ctx, 'chart_legend_fail')}: '
                                  : '',
                  style: AppFonts.robotoRegular(
                    16,
                    color: this.isAnomaly
                        ? HexColor('FF6BBB').withOpacity(0.5)
                        : this.isFalseFailure
                            ? HexColor('FFA07A').withOpacity(0.5)
                            : this.isPass
                                ? HexColor('73D32C').withOpacity(0.5)
                                : this.isFail
                                    ? HexColor('E3022A').withOpacity(0.5)
                                    : AppColors.appGrey2(),
                    decoration: TextDecoration.none,
                  ),
                ),
                Text(
                  Utils.isNotEmpty(widget.compareTestResultDataDTO!.measured)
                      ? '${Utils.prefixConversion(widget.compareTestResultDataDTO!.measured, 4)}'
                      : '0',
                  style: AppFonts.robotoRegular(
                    16,
                    color: this.isAnomaly
                        ? HexColor('FF6BBB').withOpacity(0.5)
                        : this.isFalseFailure
                            ? HexColor('FFA07A').withOpacity(0.5)
                            : this.isPass
                                ? HexColor('73D32C').withOpacity(0.5)
                                : this.isFail
                                    ? HexColor('E3022A').withOpacity(0.5)
                                    : AppColors.appGrey2(),
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
                  Utils.getTranslated(
                          ctx, 'dqm_testresult_analog_sortby_testname')! +
                      ': ',
                  style: AppFonts.robotoRegular(
                    16,
                    color: theme_dark!
                        ? AppColors.appGrey2()
                        : AppColorsLightMode.appGrey(),
                    decoration: TextDecoration.none,
                  ),
                ),
                Flexible(
                  child: Text(
                    '${widget.compareTestResultDataDTO!.testName}',
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
            SizedBox(height: 17.0),
            Utils.isNotEmpty(widget.compareTestResultDataDTO!.equipmentName)
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Utils.getTranslated(
                                    ctx, 'dqm_rma_sortby_equipment')! +
                                ': ',
                            style: AppFonts.robotoRegular(
                              16,
                              color: theme_dark!
                                  ? AppColors.appGrey2()
                                  : AppColorsLightMode.appGrey(),
                              decoration: TextDecoration.none,
                            ),
                          ),
                          Flexible(
                            child: Text(
                              '${widget.compareTestResultDataDTO!.equipmentName}',
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
                      SizedBox(height: 17.0),
                    ],
                  )
                : Container(),
            Visibility(
              visible:
                  Utils.isNotEmpty(widget.compareTestResultDataDTO!.fixtureId),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Utils.getTranslated(
                            ctx, 'dqm_rma_cpk_dashboard_fixture_id')! +
                        ': ',
                    style: AppFonts.robotoRegular(
                      16,
                      color: theme_dark!
                          ? AppColors.appGrey2()
                          : AppColorsLightMode.appGrey(),
                      decoration: TextDecoration.none,
                    ),
                  ),
                  Text(
                    '${widget.compareTestResultDataDTO!.fixtureId}',
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
            ),
            Visibility(
              visible:
                  Utils.isNotEmpty(widget.compareTestResultDataDTO!.fixtureId),
              child: SizedBox(height: 17.0),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Utils.getTranslated(
                          ctx, 'dqm_rma_cpk_dashboard_serial_nulber')! +
                      ': ',
                  style: AppFonts.robotoRegular(
                    16,
                    color: theme_dark!
                        ? AppColors.appGrey2()
                        : AppColorsLightMode.appGrey(),
                    decoration: TextDecoration.none,
                  ),
                ),
                Flexible(
                  child: Text(
                    '${widget.compareTestResultDataDTO!.serialNumber}',
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
            SizedBox(height: 17.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  Utils.getTranslated(ctx,
                          'dqm_testresult_analog_info_filterby_test_type')! +
                      ': ',
                  style: AppFonts.robotoMedium(
                    14,
                    color: theme_dark!
                        ? AppColors.appGrey2()
                        : AppColorsLightMode.appGrey(),
                    decoration: TextDecoration.none,
                  ),
                ),
                Text(
                  '${widget.compareTestResultDataDTO!.testType}',
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
            SizedBox(height: 17.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Utils.getTranslated(
                          ctx, 'dqm_testresult_cpk_dashboard_testunit')! +
                      ': ',
                  style: AppFonts.robotoRegular(
                    16,
                    color: theme_dark!
                        ? AppColors.appGrey2()
                        : AppColorsLightMode.appGrey(),
                    decoration: TextDecoration.none,
                  ),
                ),
                Text(
                  '${widget.compareTestResultDataDTO!.testUnit}',
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
          ],
        ),
      );
    }

    return Container();
  }

  Widget dailyCpkInfo(BuildContext ctx) {
    String testname = '';
    if (widget.fixtureDataDTO != null) {
      testname = widget.fixtureDataDTO!.testName!;
    } else if (widget.testNameDataDTO != null) {
      testname = widget.testNameDataDTO!.testName!;
    } else if (widget.changeLimitDTO != null) {
      testname = widget.changeLimitDTO!.changeLimitDataDTO!.testName!;
    } else if (widget.compareTestResultDataDTO != null) {
      testname = widget.compareTestResultDataDTO!.testName!;
    }
    return Container(
      margin: EdgeInsets.only(top: 25.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              Utils.getTranslated(ctx, 'dqm_rma_cpk_dashboard_daily_cpk_for')! +
                  ' ($testname)',
              style: AppFonts.robotoRegular(
                16,
                color: theme_dark!
                    ? AppColors.appGrey2()
                    : AppColorsLightMode.appGrey(),
                decoration: TextDecoration.none,
              ),
            ),
          ),
          InkWell(
            onTap: () {
              showDownloadCPKPopup(ctx);
            },
            child: Image.asset(theme_dark!
                ? Constants.ASSET_IMAGES + 'download_bttn.png'
                : Constants.ASSET_IMAGES_LIGHT + 'download_bttn.png'),
          )
        ],
      ),
    );
  }

  Widget dailyCpkChart(BuildContext ctx) {
    return Container(
      height: this.chartCpkHeight,
      margin: EdgeInsets.only(top: 36.0),
      child: Container(
        width: MediaQuery.of(ctx).size.width,
        height: this.chartCpkHeight,
        color: Colors.transparent,
        child: (this.testResultCpkDTO != null &&
                this.testResultCpkDTO!.data != null &&
                this.testResultCpkDTO!.data!.length > 0)
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
                  this.cpkWebViewController = controllerPlus;
                },
                onPageFinished: (url) {
                  this.cpkWebViewController.getHeight().then((value) {
                    setState(() {
                      this.chartCpkHeight = value;
                    });
                  });
                },
                javascriptChannels: [
                  JavascriptChannel(
                      name: 'DQMChannel',
                      onMessageReceived: (message) {
                        if (widget.pushFrom != null) {
                          if (widget.pushFrom ==
                                  Constants
                                      .CPK_DASHBOARD_FROM_TESTRESULT_INFO ||
                              widget.pushFrom ==
                                  Constants
                                      .CPK_DASHBOARD_FROM_TESTRESULT_ANALOG ||
                              widget.pushFrom ==
                                  Constants.CPK_DASHBOARD_FROM_PAT_CHART) {
                            this
                                .cpkWebViewController
                                .webViewController
                                .runJavascript(
                                    'fetchDailyCpkDetailData(${jsonEncode(this.testResultCpkDTO)}, "${this.startDate}", "${this.endDate}", "${Utils.getTranslated(ctx, 'chart_footer_date_cpk')}")');
                          }
                        } else {
                          if (widget.fixtureDataDTO != null &&
                              widget.analogCpkData != null) {
                            this
                                .cpkWebViewController
                                .webViewController
                                .runJavascript(
                                    'fetchDailyCpkDetailData(${jsonEncode(this.testResultCpkDTO)}, "${this.startDate}", "${this.endDate}", "${Utils.getTranslated(ctx, 'chart_footer_date_cpk')}")');
                          } else if (widget.testNameDataDTO != null) {
                            this
                                .cpkWebViewController
                                .webViewController
                                .runJavascript(
                                    'fetchRmaTestResultCpkDetailData(${jsonEncode(this.testResultCpkDTO)}, "${this.startDate}", "${this.endDate}", "${Utils.getTranslated(ctx, 'chart_footer_date_cpk')}")');
                          } else if (widget.pushFrom != null) {
                            this
                                .cpkWebViewController
                                .webViewController
                                .runJavascript(
                                    'fetchRmaTestResultCpkDetailData(${jsonEncode(this.testResultCpkDTO)}, "${this.startDate}", "${this.endDate}", "${Utils.getTranslated(ctx, 'chart_footer_date_cpk')}")');
                          } else {
                            this
                                .cpkWebViewController
                                .webViewController
                                .runJavascript(
                                    'fetchRmaTestResultCpkDetailData(${jsonEncode(this.testResultCpkDTO)}, "${this.startDate}", "${this.endDate}", "${Utils.getTranslated(ctx, 'chart_footer_date_cpk')}")');
                          }
                        }
                      }),
                  JavascriptChannel(
                      name: 'DQMCpkClickChannel',
                      onMessageReceived: (message) {
                        if (Utils.isNotEmpty(message.message)) {
                          cpkDataDTO = TestResultCpkDataDTO.fromJson(
                              jsonDecode(message.message));
                          // JSCpkDataDTO jsCpkDataDTO = JSCpkDataDTO.fromJson(
                          //     jsonDecode(message.message));

                          this.curDate =
                              Utils.isNotEmpty(cpkDataDTO!.latestTimeStamp)
                                  ? cpkDataDTO!.latestTimeStamp!
                                  : '';
                          if (widget.compareTestResultDataDTO != null) {
                            if (widget.compareBy ==
                                Constants.COMPARE_BY_EQUIPMENT) {
                              callGetHistogramForEquipment(
                                  ctx, cpkDataDTO!.latestTimeStamp!, 20);
                            } else if (widget.compareBy ==
                                Constants.COMPARE_BY_FIXTURE) {
                              callGetHistogramForFixture(
                                  ctx, cpkDataDTO!.latestTimeStamp!, 20);
                            } else if (widget.compareBy ==
                                Constants.COMPARE_BY_EQUIP_FIX) {
                              callGetHistogramForEquipmentAndFixture(
                                  ctx, cpkDataDTO!.latestTimeStamp!, 20);
                            } else if (widget.compareBy ==
                                Constants.COMPARE_BY_PANEL) {
                              callGetHistogram(
                                  ctx, cpkDataDTO!.latestTimeStamp!, 20);
                            } else if (widget.compareBy ==
                                Constants.COMPARE_BY_ALL_PANEL) {
                              callGetHistogramForCombinedPanel(
                                  ctx, cpkDataDTO!.latestTimeStamp!, 20);
                            }
                          } else {
                            callGetHistogram(
                                ctx,
                                Utils.isNotEmpty(cpkDataDTO!.latestTimeStamp)
                                    ? cpkDataDTO!.latestTimeStamp!
                                    : '',
                                20);
                          }
                        }
                      }),
                  JavascriptChannel(
                      name: 'DQMExportImageChannel',
                      onMessageReceived: (message) async {
                        print(message.message);
                        if (Utils.isNotEmpty(message.message)) {
                          String curDate =
                              '#${DateFormat('yyyy.MM.dd').format(DateTime.now())}@${DateFormat('HH.mm.ss').format(DateTime.now())}';

                          String name = Utils.getExportFilename('DlyCPK',
                              companyId:
                                  AppCache.sortFilterCacheDTO!.preferredCompany,
                              siteId:
                                  AppCache.sortFilterCacheDTO!.preferredSite,
                              fromDate: DateFormat('yyyy-MM-dd').format(
                                  AppCache.sortFilterCacheDTO!.startDate!),
                              toDate: DateFormat('yyyy-MM-dd').format(
                                  AppCache.sortFilterCacheDTO!.endDate!),
                              currentDate: curDate,
                              expType: '.png',
                              equipmentId:
                                  this.testResultCpkDTO!.data![0].equipmentId);
                          final result = await ImageApi.generateImage(
                              message.message,
                              600,
                              this.chartCpkHeight.round(),
                              name);
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
                          String curDate =
                              '#${DateFormat('yyyy.MM.dd').format(DateTime.now())}@${DateFormat('HH.mm.ss').format(DateTime.now())}';

                          String name = Utils.getExportFilename('DlyCPK',
                              companyId:
                                  AppCache.sortFilterCacheDTO!.preferredCompany,
                              siteId:
                                  AppCache.sortFilterCacheDTO!.preferredSite,
                              fromDate: DateFormat('yyyy-MM-dd').format(
                                  AppCache.sortFilterCacheDTO!.startDate!),
                              toDate: DateFormat('yyyy-MM-dd').format(
                                  AppCache.sortFilterCacheDTO!.endDate!),
                              currentDate: curDate,
                              expType: '.pdf',
                              equipmentId:
                                  this.testResultCpkDTO!.data![0].equipmentId);

                          final result = await PdfApi.generatePDF(
                              message.message,
                              600,
                              this.chartCpkHeight.round(),
                              name);
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
      ),
    );
  }

  Widget histogramEmpty(BuildContext ctx) {
    return Container(
      width: MediaQuery.of(ctx).size.width,
      margin: EdgeInsets.only(top: 20.0),
      padding: EdgeInsets.fromLTRB(14.0, 19.0, 14.0, 19.0),
      decoration: BoxDecoration(
        color: theme_dark!
            ? AppColors.appBlackLight()
            : AppColors.appPrimaryWhite(),
        border: Border.all(
          color:
              theme_dark! ? AppColors.appBlackLight() : AppColors.appGreyDE(),
        ),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Utils.getTranslated(ctx, 'dqm_rma_cpk_dashboard_histogram')!,
            style: AppFonts.robotoRegular(
              16,
              color: theme_dark!
                  ? AppColors.appGrey2()
                  : AppColorsLightMode.appGrey(),
              decoration: TextDecoration.none,
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(35.0, 25.0, 35.0, 25.0),
            child: Text(
              Utils.getTranslated(
                  ctx, 'dqm_rma_cpk_dashboard_histogram_empty_text')!,
              style: AppFonts.robotoRegular(
                13,
                color: theme_dark!
                    ? AppColors.appGrey2()
                    : AppColorsLightMode.appGrey(),
                decoration: TextDecoration.none,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget histogramChart(BuildContext ctx) {
    return Container(
      width: MediaQuery.of(ctx).size.width,
      margin: EdgeInsets.only(top: 20.0),
      padding: EdgeInsets.fromLTRB(14.0, 19.0, 14.0, 19.0),
      decoration: BoxDecoration(
        color: theme_dark!
            ? AppColors.appBlackLight()
            : AppColors.appPrimaryWhite(),
        border: Border.all(
          color:
              theme_dark! ? AppColors.appBlackLight() : AppColors.appGreyDE(),
        ),
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
              Expanded(
                child: Text(
                  Utils.getTranslated(ctx, 'dqm_rma_cpk_dashboard_histogram')!,
                  style: AppFonts.robotoRegular(
                    16,
                    color: theme_dark!
                        ? AppColors.appGrey2()
                        : AppColorsLightMode.appGrey(),
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  showDownloadHistogramPopup(ctx);
                },
                child: Image.asset(theme_dark!
                    ? Constants.ASSET_IMAGES + 'download_bttn.png'
                    : Constants.ASSET_IMAGES_LIGHT + 'download_bttn.png'),
              ),
            ],
          ),
          Container(
            width: MediaQuery.of(ctx).size.width,
            height: this.chartHistogramHeight,
            color: Colors.transparent,
            child: (this.histogramDTO.data != null)
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
                      this.histogramWebViewController = controllerPlus;
                    },
                    onPageFinished: (url) {
                      this.histogramWebViewController.getHeight().then((value) {
                        setState(() {
                          this.chartHistogramHeight = value;
                        });
                      });
                    },
                    javascriptChannels: [
                      JavascriptChannel(
                          name: 'DQMChannel',
                          onMessageReceived: (message) {
                            this
                                .histogramWebViewController
                                .webViewController
                                .runJavascript(
                                    'fetchHistogramData(${jsonEncode(this.histogramDTO.data)}, "${Utils.getTranslated(ctx, 'chart_footer_measured_value_count')}", "${Utils.getTranslated(ctx, 'chart_legend_mean_1')}", "${Utils.getTranslated(ctx, 'chart_legend_mean_2')}", "${Utils.getTranslated(ctx, 'chart_legend_mean_3')}", "${Utils.getTranslated(ctx, 'chart_legend_mean')}", "${Utils.getTranslated(ctx, 'chart_legend_mean_4')}", "${Utils.getTranslated(ctx, 'chart_legend_mean_5')}", "${Utils.getTranslated(ctx, 'chart_legend_mean_6')}", "${Utils.getTranslated(ctx, 'chart_legend_barhistro')}")');
                          }),
                      JavascriptChannel(
                          name: 'DQMHistogramBarClickChannel',
                          onMessageReceived: (message) {
                            if (Utils.isNotEmpty(message.message)) {
                              JSHistogramDataDTO jsHistogramDataDTO =
                                  JSHistogramDataDTO.fromJson(
                                      jsonDecode(message.message));
                              showHistogramTooltipsDialog(
                                  ctx, jsHistogramDataDTO, true);
                            }
                          }),
                      JavascriptChannel(
                          name: 'DQMExportImageChannel',
                          onMessageReceived: (message) async {
                            print(message.message);
                            if (Utils.isNotEmpty(message.message)) {
                              String curDate =
                                  '#${DateFormat('yyyy.MM.dd').format(DateTime.now())}@${DateFormat('HH.mm.ss').format(DateTime.now())}';

                              String name = Utils.getExportFilename(
                                'Htgrm',
                                companyId: AppCache
                                    .sortFilterCacheDTO!.preferredCompany,
                                siteId:
                                    AppCache.sortFilterCacheDTO!.preferredSite,
                                fromDate: DateFormat('yyyy-MM-dd').format(
                                    AppCache.sortFilterCacheDTO!.startDate!),
                                toDate: DateFormat('yyyy-MM-dd').format(
                                    AppCache.sortFilterCacheDTO!.endDate!),
                                currentDate: curDate,
                                expType: '.png',
                              );

                              final result = await ImageApi.generateImage(
                                  message.message,
                                  600,
                                  this.chartHistogramHeight.round(),
                                  name);
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
                              String curDate =
                                  '#${DateFormat('yyyy.MM.dd').format(DateTime.now())}@${DateFormat('HH.mm.ss').format(DateTime.now())}';

                              String name = Utils.getExportFilename(
                                'Htgrm',
                                companyId: AppCache
                                    .sortFilterCacheDTO!.preferredCompany,
                                siteId:
                                    AppCache.sortFilterCacheDTO!.preferredSite,
                                fromDate: DateFormat('yyyy-MM-dd').format(
                                    AppCache.sortFilterCacheDTO!.startDate!),
                                toDate: DateFormat('yyyy-MM-dd').format(
                                    AppCache.sortFilterCacheDTO!.endDate!),
                                currentDate: curDate,
                                expType: '.pdf',
                              );
                              final result = await PdfApi.generatePDF(
                                  message.message,
                                  600,
                                  this.chartHistogramHeight.round(),
                                  name);
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
          ),
        ],
      ),
    );
  }

  Widget histogramInfo(BuildContext ctx) {
    return Container(
      width: MediaQuery.of(ctx).size.width,
      margin: EdgeInsets.only(top: 20.0),
      padding: EdgeInsets.fromLTRB(14.0, 19.0, 14.0, 19.0),
      decoration: BoxDecoration(
        color: theme_dark!
            ? AppColors.appBlackLight()
            : AppColors.appPrimaryWhite(),
        border: Border.all(
          color:
              theme_dark! ? AppColors.appBlackLight() : AppColors.appGreyDE(),
        ),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Utils.getTranslated(ctx, 'dqm_rma_cpk_dashboard_histogram')!,
            style: AppFonts.robotoRegular(
              16,
              color: theme_dark!
                  ? AppColors.appGrey2()
                  : AppColorsLightMode.appGrey(),
              decoration: TextDecoration.none,
            ),
          ),
          SizedBox(height: 19.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                Utils.getTranslated(
                    ctx, 'dqm_rma_cpk_dashboard_histogram_bin_count')!,
                style: AppFonts.robotoMedium(
                  14,
                  color: AppColors.appBlue(),
                  decoration: TextDecoration.none,
                ),
              ),
              SizedBox(width: 12.0),
              InkWell(
                onTap: () {},
                child: Image.asset(Constants.ASSET_IMAGES + 'bincount.png'),
              ),
            ],
          ),
          SizedBox(height: 23.0),
          Text(
            Utils.getTranslated(
                ctx, 'dqm_rma_cpk_dashboard_histogram_input_label')!,
            style: AppFonts.robotoRegular(
              14,
              color: theme_dark!
                  ? AppColors.appGrey()
                  : AppColorsLightMode.appGrey(),
              decoration: TextDecoration.none,
            ),
          ),
          histogramInfoInputField(ctx),
          histogramInfoData(ctx),
          // histogramInfoSwapChart(ctx),
          histogramInfoChart(ctx),
        ],
      ),
    );
  }

  Widget histogramInfoInputField(BuildContext ctx) {
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.appPrimaryWhite().withOpacity(0.1),
                borderRadius: BorderRadius.circular(6.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextField(
                      controller: editController,
                      minLines: null,
                      maxLines: null,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0),
                        hintText: Utils.getTranslated(
                            ctx, 'dqm_rma_cpk_dashboard_histogram_input_hint'),
                        hintStyle: AppFonts.robotoRegular(
                          14,
                          color: AppColors.appGrey9A(),
                          decoration: TextDecoration.none,
                        ),
                      ),
                      style: AppFonts.sfproMedium(
                        14,
                        color: theme_dark!
                            ? AppColors.appGrey2()
                            : AppColorsLightMode.appGrey(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                  hasText
                      ? GestureDetector(
                          onTap: () {
                            FocusScopeNode currentFocus =
                                FocusScope.of(context);
                            if (!currentFocus.hasPrimaryFocus) {
                              currentFocus.unfocus();
                            }

                            if (Utils.isNotEmpty(editController.text.trim())) {
                              int binnum =
                                  int.parse(editController.text.trim());
                              EasyLoading.show(
                                  maskType: EasyLoadingMaskType.black);
                              if (binnum >= 1 && binnum <= 250) {
                                callGetHistogram(context, this.curDate,
                                    int.parse(editController.text.trim()));
                                // if (widget.analogCpkData != null &&
                                //     widget.fixtureDataDTO != null) {
                                //   callGetHistogram(context, this.curDate,
                                //       int.parse(editController.text.trim()));
                                // } else if (widget.testNameDataDTO != null) {
                                //   callGetRmaTestResultHistogram(
                                //       context,
                                //       this.curDate,
                                //       int.parse(editController.text.trim()));
                                // }
                              } else {
                                editController.text = "250";
                                callGetHistogram(context, this.curDate, 250);
                                // if (widget.analogCpkData != null &&
                                //     widget.fixtureDataDTO != null) {
                                //   callGetHistogram(context, this.curDate, 250);
                                // } else if (widget.testNameDataDTO != null) {
                                //   callGetRmaTestResultHistogram(
                                //       context, this.curDate, 250);
                                // }
                              }
                            }
                          },
                          child: Container(
                            height: 48.0,
                            padding: EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              color: AppColors.appGreen(),
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(6.0),
                                bottomRight: Radius.circular(6.0),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  Utils.getTranslated(
                                      ctx, 'dqm_rma_action_go')!,
                                  style: AppFonts.robotoMedium(
                                    14,
                                    color: AppColors.appPrimaryWhite(),
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                                SizedBox(width: 5.0),
                                Image.asset(
                                    Constants.ASSET_IMAGES + 'go_icon.png'),
                              ],
                            ),
                          ),
                        )
                      : Container(
                          height: 48.0,
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: AppColors.appGrey95(),
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(6.0),
                              bottomRight: Radius.circular(6.0),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                Utils.getTranslated(ctx, 'dqm_rma_action_go')!,
                                style: AppFonts.robotoMedium(
                                  14,
                                  color: AppColors.appPrimaryWhite(),
                                  decoration: TextDecoration.none,
                                ),
                              ),
                              SizedBox(width: 5.0),
                              Image.asset(
                                  Constants.ASSET_IMAGES + 'go_icon.png'),
                            ],
                          ),
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget histogramInfoData(BuildContext ctx) {
    return Container(
      margin: EdgeInsets.only(top: 39.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          histogramInfoDataItem(
              ctx,
              Utils.getTranslated(
                  ctx, 'dqm_rma_cpk_dashboard_histogram_upper_limit')!,
              '${Utils.prefixConversion(this.histogramDTO.data!.upperLimit!, 4)}'),
          SizedBox(height: 12.0),
          histogramInfoDataItem(
              ctx,
              Utils.getTranslated(
                  ctx, 'dqm_rma_cpk_dashboard_histogram_lower_limit')!,
              '${Utils.prefixConversion(this.histogramDTO.data!.lowerLimit!, 4)}'),
          SizedBox(height: 12.0),
          histogramInfoDataItem(
              ctx,
              Utils.getTranslated(ctx, 'dqm_rma_cpk_dashboard_histogram_max')!,
              '${Utils.prefixConversion(this.histogramDTO.data!.max!, 4)}'),
          SizedBox(height: 12.0),
          histogramInfoDataItem(
              ctx,
              Utils.getTranslated(ctx, 'dqm_rma_cpk_dashboard_histogram_min')!,
              '${Utils.prefixConversion(this.histogramDTO.data!.min!, 4)}'),
          SizedBox(height: 12.0),
          histogramInfoDataItem(
              ctx,
              Utils.getTranslated(ctx, 'dqm_rma_cpk_dashboard_histogram_mean')!,
              '${Utils.prefixConversion(this.histogramDTO.data!.mean!, 4)}'),
          SizedBox(height: 12.0),
          histogramInfoDataItem(
              ctx,
              Utils.getTranslated(ctx, 'dqm_rma_cpk_dashboard_histogram_cpk')!,
              '${Utils.prefixConversion(this.histogramDTO.data!.cpk!, 4)}'),
          // SizedBox(height: 12.0),
          // histogramInfoDataItem(
          //     ctx,
          //     Utils.getTranslated(
          //         ctx, 'dqm_rma_cpk_dashboard_histogram_skewness')!,
          //     '1.2739'),
          SizedBox(height: 12.0),
          histogramInfoDataItem(
              ctx,
              Utils.getTranslated(
                  ctx, 'dqm_rma_cpk_dashboard_histogram_std_deviation')!,
              '${Utils.prefixConversion(this.histogramDTO.data!.stdDeviation!, 4)}'),
        ],
      ),
    );
  }

  Widget histogramInfoDataItem(
      BuildContext ctx, String dataName, String dataValue) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            dataName,
            style: AppFonts.robotoRegular(
              16,
              color: theme_dark!
                  ? AppColors.appGrey2()
                  : AppColorsLightMode.appGrey(),
              decoration: TextDecoration.none,
            ),
          ),
        ),
        SizedBox(width: 10.0),
        Expanded(
          flex: 1,
          child: Text(
            dataValue,
            style: AppFonts.robotoRegular(
              16,
              color: theme_dark!
                  ? AppColors.appGrey2()
                  : AppColorsLightMode.appGrey(),
              decoration: TextDecoration.none,
            ),
          ),
        )
      ],
    );
  }

  Widget histogramInfoSwapChart(BuildContext ctx) {
    return TextButton(
      onPressed: () {},
      child: Container(
        margin: EdgeInsets.only(top: 50),
        padding: EdgeInsets.fromLTRB(25.0, 12.0, 25.0, 12.0),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(
            color: AppColors.appPrimaryYellow(),
          ),
          borderRadius: BorderRadius.circular(2.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(Constants.ASSET_IMAGES + 'swap.png'),
            SizedBox(width: 7.0),
            Text(
              Utils.getTranslated(
                  ctx, 'dqm_rma_cpk_dashboard_histogram_swap_chart')!,
              style: AppFonts.robotoMedium(
                14,
                color: AppColors.appPrimaryYellow(),
                decoration: TextDecoration.none,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget histogramInfoChart(BuildContext ctx) {
    return Container(
      height: this.chartHistogramHeight,
      child: Container(
        width: MediaQuery.of(ctx).size.width,
        height: this.chartHistogramHeight,
        color: Colors.transparent,
        child: (this.histogramDTO.data != null)
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
                  this.smallHistogramWebViewController = controllerPlus;
                },
                onPageFinished: (url) {
                  this.histogramWebViewController.getHeight().then((value) {
                    setState(() {
                      this.chartHistogramHeight = value;
                    });
                  });
                },
                javascriptChannels: [
                  JavascriptChannel(
                      name: 'DQMChannel',
                      onMessageReceived: (message) {
                        this
                            .smallHistogramWebViewController
                            .webViewController
                            .runJavascript(
                                'fetchSmallHistogramData(${jsonEncode(this.histogramDTO.data)}, "${Utils.getTranslated(ctx, 'chart_footer_measured_value_count')}", "${Utils.getTranslated(ctx, 'chart_legend_mean_1')}", "${Utils.getTranslated(ctx, 'chart_legend_mean_2')}", "${Utils.getTranslated(ctx, 'chart_legend_mean_3')}", "${Utils.getTranslated(ctx, 'chart_legend_mean')}", "${Utils.getTranslated(ctx, 'chart_legend_mean_4')}", "${Utils.getTranslated(ctx, 'chart_legend_mean_5')}", "${Utils.getTranslated(ctx, 'chart_legend_mean_6')}", "${Utils.getTranslated(ctx, 'chart_legend_linehistro')}")');
                      }),
                  JavascriptChannel(
                      name: 'DQMSmallHistogramColumnClickChannel',
                      onMessageReceived: (message) {
                        if (Utils.isNotEmpty(message.message)) {
                          JSHistogramDataDTO jsHistogramDataDTO =
                              JSHistogramDataDTO.fromJson(
                                  jsonDecode(message.message));
                          showHistogramTooltipsDialog(
                              ctx, jsHistogramDataDTO, false);
                        }
                      }),
                  JavascriptChannel(
                      name: 'DQMSmallHistogramSplineClickChannel',
                      onMessageReceived: (message) {
                        if (Utils.isNotEmpty(message.message)) {
                          JSHistogramDataDTO jsHistogramDataDTO =
                              JSHistogramDataDTO.fromJson(
                                  jsonDecode(message.message));
                          showHistogramTooltipsDialog(
                              ctx, jsHistogramDataDTO, false);
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
      ),
    );
  }

  void showHistogramTooltipsDialog(
      BuildContext context, JSHistogramDataDTO jsHistogramDataDTO, bool isBar) {
    showDialog(
      context: context,
      builder: (tooltipsDialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: histogramTooltipsInfo(
              tooltipsDialogContext, jsHistogramDataDTO, isBar),
        );
      },
    );
  }

  Widget histogramTooltipsInfo(
      BuildContext ctx, JSHistogramDataDTO jsHistogramDataDTO, bool isBar) {
    return Container(
      padding: EdgeInsets.fromLTRB(14.0, 12.0, 14.0, 12.0),
      decoration: BoxDecoration(
        color: AppColors.applocale(),
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: jsHistogramDataDTO.binStart != null &&
              jsHistogramDataDTO.binValue != null
          ? Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${Utils.prefixConversion(jsHistogramDataDTO.binStart, 4)}',
                  style: AppFonts.robotoRegular(
                    16,
                    color: theme_dark!
                        ? AppColors.appGrey2()
                        : AppColorsLightMode.appGrey(),
                    decoration: TextDecoration.none,
                  ),
                ),
                SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      isBar
                          ? '${Utils.getTranslated(ctx, 'chart_legend_barhistro')}: '
                          : '${Utils.getTranslated(ctx, 'chart_legend_linehistro')}: ',
                      style: AppFonts.robotoMedium(
                        14,
                        color: AppColors.appGrey86(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                    SizedBox(width: 10.0),
                    Text(
                      '${jsHistogramDataDTO.binValue}',
                      style: AppFonts.robotoMedium(
                        14,
                        color: AppColors.appPrimaryWhite(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ],
            )
          : Utils.isNotEmpty(jsHistogramDataDTO.name)
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      '${jsHistogramDataDTO.name}',
                      style: AppFonts.robotoMedium(
                        14,
                        color: Utils.isNotEmpty(jsHistogramDataDTO.colorCode)
                            ? HexColor(
                                jsHistogramDataDTO.colorCode!.substring(0))
                            : AppColors.appGrey86(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                    SizedBox(width: 10.0),
                    Text(
                      '${Utils.prefixConversion(jsHistogramDataDTO.value, 4)}',
                      style: AppFonts.robotoMedium(
                        14,
                        color: AppColors.appPrimaryWhite(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                )
              : Container(),
    );
  }

  void showDownloadCPKPopup(BuildContext context) {
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
                    .cpkWebViewController
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

                String curDate =
                    '#${DateFormat('yyyy.MM.dd').format(DateTime.now())}@${DateFormat('HH.mm.ss').format(DateTime.now())}';

                String name = Utils.getExportFilename('DlyCPK',
                    companyId: AppCache.sortFilterCacheDTO!.preferredCompany,
                    siteId: AppCache.sortFilterCacheDTO!.preferredSite,
                    fromDate: DateFormat('yyyy-MM-dd')
                        .format(AppCache.sortFilterCacheDTO!.startDate!),
                    toDate: DateFormat('yyyy-MM-dd')
                        .format(AppCache.sortFilterCacheDTO!.endDate!),
                    currentDate: curDate,
                    expType: '.csv',
                    equipmentId: this.testResultCpkDTO!.data![0].equipmentId);
                final result = await CSVApi.generateCSV(
                    this.testResultCpkDTO!.data!, name);
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
                    .cpkWebViewController
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

  void showDownloadHistogramPopup(BuildContext context) {
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
                    .histogramWebViewController
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
                var data = [];
                for (int x = 0;
                    x < this.histogramDTO.data!.binList!.length;
                    x++) {
                  data.add({
                    "binList": histogramDTO.data!.binList![x] != null
                        ? histogramDTO.data!.binList![x]
                        : '',
                    "valueFrequency":
                        histogramDTO.data!.valueFrequency![x] != null
                            ? histogramDTO.data!.valueFrequency![x]
                            : ''
                  });
                }
                String curDate =
                    '#${DateFormat('yyyy.MM.dd').format(DateTime.now())}@${DateFormat('HH.mm.ss').format(DateTime.now())}';

                String name = Utils.getExportFilename(
                  'Htgrm',
                  companyId: AppCache.sortFilterCacheDTO!.preferredCompany,
                  siteId: AppCache.sortFilterCacheDTO!.preferredSite,
                  fromDate: DateFormat('yyyy-MM-dd')
                      .format(AppCache.sortFilterCacheDTO!.startDate!),
                  toDate: DateFormat('yyyy-MM-dd')
                      .format(AppCache.sortFilterCacheDTO!.endDate!),
                  currentDate: curDate,
                  expType: '.csv',
                );
                final result = await CSVApi.generateCSV(data, name);
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
                              : AppColors.appGrey2(),
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
                    .histogramWebViewController
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
