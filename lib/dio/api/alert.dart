import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:keysight_pma/const/utils.dart';
import 'package:keysight_pma/dio/dio_repo.dart';
import 'package:keysight_pma/model/alert/alert_assignee.dart';
import 'package:keysight_pma/model/alert/alert_casehistory.dart';
import 'package:keysight_pma/model/alert/alert_cpk.dart';
import 'package:keysight_pma/model/alert/alert_create_case.dart';
import 'package:keysight_pma/model/alert/alert_detail.dart';
import 'package:keysight_pma/model/alert/alert_fixture_maintenance.dart';
import 'package:keysight_pma/model/alert/alert_group.dart';
import 'package:keysight_pma/model/alert/alert_pat_anomalies.dart';
import 'package:keysight_pma/model/alert/alert_probe.dart';
import 'package:keysight_pma/model/alert/alert_recentList.dart';
import 'package:keysight_pma/model/alert/alert_review_data.dart';
import 'package:keysight_pma/model/alert/alert_statistics.dart';
import 'package:keysight_pma/model/alert/alert_testtype_category.dart';
import 'package:keysight_pma/model/customize.dart';
import 'package:keysight_pma/model/dqm/test_result_cpk.dart';
import 'package:keysight_pma/model/dqm/test_result_fixtures.dart';
import 'package:keysight_pma/model/dqm/test_result_testname.dart';

class AlertApi extends DioRepo {
  AlertApi(BuildContext context) {
    dioContext = context;
  }

  /*
    Alert Review
  */

  Future<AlertReviewDTO> getAlertReviewData(String companyId, String siteId,
      String projectId, String fromDate, String toDate) async {
    try {
      Map<String, dynamic> params = {
        "companyId": companyId,
        "siteId": siteId,
        "projectId": projectId,
        "fromDate": fromDate,
        "toDate": toDate
      };
      Response response =
          await mDio.post("alertreview/getAlertReviewData", data: params);
      return AlertReviewDTO.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

  Future<AlertCpkDTO> getAlertCpk(
      String companyId,
      String siteId,
      String projectId,
      String equipmentId,
      String fixtureId,
      String timestamp) async {
    try {
      Map<String, dynamic> params = {
        "companyId": companyId,
        "siteId": siteId,
        "projectId": projectId,
        "equipmentId": equipmentId,
        "fixtureId": fixtureId,
        "timestamp": timestamp
      };
      Response response =
          await mDio.get("cpk/tests/cpkAlert", queryParameters: params);
      return AlertCpkDTO.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

  Future<AlertTestTypeCategoryDTO> getTestTypeCategory(
      String companyId,
      String siteId,
      String projectId,
      String startDate,
      String endDate,
      String testName) async {
    try {
      Map<String, dynamic> params = {
        "companyId": companyId,
        "siteId": siteId,
        "projectId": projectId,
        "testName": testName
      };

      if (Utils.isNotEmpty(startDate)) {
        params["fromDate"] = startDate;
      }

      if (Utils.isNotEmpty(endDate)) {
        params["toDate"] = endDate;
      }
      Response response =
          await mDio.post("alertreview/testTypeCategory", data: params);
      return AlertTestTypeCategoryDTO.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

  Future<AlertStatisticsDTO> getAlertStatistics(
      String startDate, String endDate, List<num> groupId) async {
    try {
      Map<String, dynamic> params = {
        "toDate": endDate,
        "fromDate": startDate,
        "groupId": groupId,
      };
      Response response =
          await mDio.post("alertreview/retrieveAlertStatistics", data: params);
      return AlertStatisticsDTO.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

  Future<AlertGroupDTO> getAlertGroupInfo() async {
    try {
      Response response = await mDio.get("alertreview/retrieveGroupInfo");
      return AlertGroupDTO.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

  Future<AlertAssigneeDTO> getAlertAssignee(
      String companyId, String siteId) async {
    try {
      Map<String, dynamic> params = {
        "companyId": companyId,
        "siteId": siteId,
      };
      Response response =
          await mDio.get("case/getAssignee", queryParameters: params);
      return AlertAssigneeDTO.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

  Future<AlertDetailDTO> getAlertDetailInfo(String alertRowKey) async {
    try {
      Map<String, dynamic> params = {"alertRowKey": alertRowKey};
      Response response =
          await mDio.get("case/openCase", queryParameters: params);
      return AlertDetailDTO.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

  Future<AlertFixtureMaintenanceDTO> getFixtureMaintenance(
      String companyId,
      String siteId,
      String equipmentId,
      String fixtureId,
      String projectId,
      int timestamp) async {
    try {
      Map<String, dynamic> params = {
        "companyId": companyId,
        "siteId": siteId,
        "equipmentId": equipmentId,
        "fixtureId": fixtureId,
        "projectId": projectId,
        "timestamp": timestamp
      };
      Response response =
          await mDio.get("pdm/fixtureMaintenance", queryParameters: params);
      return AlertFixtureMaintenanceDTO.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

  Future<AlertProbeDTO> getProbe(
      String companyId,
      String siteId,
      String equipmentId,
      String fixtureId,
      String projectId,
      String timestamp) async {
    try {
      Map<String, dynamic> params = {
        "companyId": companyId,
        "siteId": siteId,
        "equipmentId": equipmentId,
        "fixtureId": fixtureId,
        "projectId": projectId,
        "timestamp": timestamp
      };
      Response response =
          await mDio.get("fixture/probe", queryParameters: params);
      return AlertProbeDTO.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

  Future<TestResultTestNameDTO> getTestResultAnomaly(
      String companyId,
      String siteId,
      String equipmentId,
      String fixtureId,
      String projectId,
      String timestamp,
      String testName) async {
    try {
      Map<String, dynamic> params = {
        "companyId": companyId,
        "siteId": siteId,
        "equipmentId": equipmentId,
        "fixtureId": fixtureId,
        "projectId": projectId,
        "timestamp": timestamp,
        "testName": testName
      };
      Response response =
          await mDio.get("dut/testresults/anomaly", queryParameters: params);
      return TestResultTestNameDTO.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

  Future<TestResultCpkDTO> getAlertCpkForEquipmentAndFixture(
      String companyId,
      String siteId,
      String equipmentId,
      String fixtureId,
      String projectId,
      String testName,
      String fromDate,
      String toDate) async {
    try {
      Map<String, dynamic> params = {
        "companyId": companyId,
        "siteId": siteId,
        "equipmentId": equipmentId,
        "fixtureId": fixtureId,
        "projectId": projectId,
        "testName": testName,
        "fromDate": fromDate,
        "toDate": toDate
      };
      Response response =
          await mDio.post("cpk/tests/cpkForEquipmentAndFixture", data: params);
      return TestResultCpkDTO.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

  Future<AlertCreateCaseDTO> createCase(
      String companyId,
      String siteId,
      String equipmentId,
      String fixtureId,
      String projectId,
      String testName,
      String assignedTo,
      String description,
      String priority,
      String subject,
      String timestamp,
      String workFlow,
      List<CustomDTO> testNames) async {
    try {
      Map<String, dynamic> params = {
        "actions": "DISPOSE",
        "assignedTo": assignedTo,
        "companyId": companyId,
        "description": description,
        "siteId": siteId,
        "equipmentId": equipmentId,
        "fixtureId": fixtureId,
        "projectId": projectId,
        "testName": testName,
        "priority": priority,
        "status": "Dispose",
        "subject": subject,
        "timestamp": timestamp,
        "workFlow": workFlow,
        "testNames": testNames
      };

      Response response =
          await mDio.post("pdm/fixtureMaintenance", data: params);
      return AlertCreateCaseDTO.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

  Future<AlertCreateCaseDTO> bulkCreateCase(
      String actions,
      String assignedTo,
      String description,
      String priority,
      String subject,
      String status,
      String workFlow,
      List<String> alertRowKeys) async {
    try {
      Map<String, dynamic> params = {
        "actions": actions,
        "alertRowKeys": alertRowKeys,
        "description": description,
        "priority": priority,
        "status": status,
        "subject": subject,
        "workFlow": workFlow
      };

      if (Utils.isNotEmpty(assignedTo)) {
        params['assignedTo'] = assignedTo;
      }

      Response response =
          await mDio.post("case/bulkCaseCreation", data: params);
      return AlertCreateCaseDTO.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

  Future<AlertCreateCaseDTO> bulkCasesVerification(
      String actions, List<String> alertRowKeys) async {
    try {
      Map<String, dynamic> params = {
        "actions": actions,
        "alertRowKeys": alertRowKeys
      };

      Response response =
          await mDio.post("case/bulkCasesVerification", data: params);
      return AlertCreateCaseDTO.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

  /*
    Case History
  */

  Future<AlertCaseHistoryDTO> searchCases(
      String companyId,
      String siteId,
      List<String?> equipmentIds,
      String? status,
      String? priority,
      String? workFlow,
      String toDate,
      String fromDate,
      String? dateFilter,
      String projectId) async {
    try {
      Map<String, dynamic> params = {
        "companyId": companyId,
        "siteId": siteId,
        "equipmentIds": equipmentIds,
        "status": status,
        "priority": priority,
        "workFlow": workFlow,
        "toDate": toDate,
        "fromDate": fromDate,
        "dateFilter": dateFilter,
        "projectId": projectId
      };

      Response response =
          await mDio.get("case/searchCases", queryParameters: params);
      return AlertCaseHistoryDTO.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

  Future<PatRecommendDTO> getPatRecommendation(String companyId, String siteId,
      String projectId, String timestamp) async {
    try {
      Map<String, dynamic> params = {
        "companyId": companyId,
        "siteId": siteId,
        "projectId": projectId,
        "timestamp": timestamp
      };
      Response response = await mDio.get("pdm/patAnomalies/patRecommends",
          queryParameters: params);
      return PatRecommendDTO.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

  Future<TestResultFixtureDTO> getPatFixtures(String companyId, String siteId,
      String fromDate, String toDate, String projectId, String testName) async {
    try {
      Map<String, dynamic> params = {
        "companyId": companyId,
        "siteId": siteId,
        "fromDate": fromDate,
        "toDate": toDate,
        "projectId": projectId,
        "testName": testName
      };
      Response response =
          await mDio.post("dut/testresults/fixtures", data: params);
      return TestResultFixtureDTO.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

  Future<AlertOpenCaseDTO> openCase(
    String alertRowKey,
  ) async {
    try {
      Map<String, dynamic> params = {
        "alertRowKey": alertRowKey,
      };

      Response response =
          await mDio.get("case/openCase", queryParameters: params);
      return AlertOpenCaseDTO.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

  Future<AlertOpenCaseDTO> postComment(
    String alertRowKey,
    String message,
  ) async {
    try {
      Map<String, dynamic> params = {
        "alertRowKey": alertRowKey,
        "message": message,
      };

      Response response = await mDio.post("case/createComment", data: params);
      return AlertOpenCaseDTO.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

  Future<AlertOpenCaseDTO> updateCase(
    String alertRowKey,
    String priority,
    String workFlow,
    String subject,
    String description,
    String? assignedTo,
    String status,
  ) async {
    try {
      Map<String, dynamic> params = {
        "alertRowKey": alertRowKey,
        "priority": priority,
        "workFlow": workFlow,
        "subject": subject,
        "description": description,
        "assignedTo": assignedTo,
        "status": status
      };

      Response response = await mDio.put("case/updateCase", data: params);
      return AlertOpenCaseDTO.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

  Future<TestResultTestNameDTO> getLimitChangeAlertByTestname(
    String companyId,
    String equipmentId,
    String projectId,
    String siteId,
    String testName,
    String timestamp,
  ) async {
    try {
      Map<String, dynamic> params = {
        "companyId": companyId,
        "equipmentId": equipmentId,
        "projectId": projectId,
        "siteId": siteId,
        "testName": testName,
        "timestamp": timestamp,
      };

      Response response =
          await mDio.post("dut/getLimitChangeAlertByTestname", data: params);
      return TestResultTestNameDTO.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

  Future<AlertProbeNodeDTO> getNodeDetail(
      String companyId, String siteId, String projectId, String nodeId) async {
    try {
      Map<String, dynamic> params = {
        "companyId": companyId,
        "projectId": projectId,
        "siteId": siteId,
        "nodeId": nodeId,
      };

      Response response =
          await mDio.get("fixture/fixtureNodeMap", queryParameters: params);
      return AlertProbeNodeDTO.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

  Future<AlertRecentListDTO> getRecentAlertList(
      String companyId, String siteId, String status, int limit) async {
    try {
      Map<String, dynamic> params = {
        "companyId": companyId,
        "status": status,
        "siteId": siteId,
        "limit": limit,
      };

      Response response =
          await mDio.get("alerts/listRecentAlerts", queryParameters: params);
      return AlertRecentListDTO.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

  Future<AlertUpdateStatusDTO> putAlertReadStatus({
    required String alertRowKey,
  }) async {
    try {
      Map<String, dynamic> params = {
        "alertRowKey": alertRowKey,
      };
      Response response = await mDio.put("alerts/updateReadStatusNotification",
          queryParameters: params);
      return AlertUpdateStatusDTO.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

  Future<AlertPatAnomaliesDTO> getPatAnomalies(
      String companyId,
      String siteId,
      String equipmentId,
      String fixtureId,
      String projectId,
      int timestamp) async {
    try {
      Map<String, dynamic> params = {
        "companyId": companyId,
        "siteId": siteId,
        "equipmentId": equipmentId,
        "fixtureId": fixtureId,
        "projectId": projectId,
        "timestamp": timestamp
      };
      Response response =
          await mDio.get("pdm/patAnomalies", queryParameters: params);
      return AlertPatAnomaliesDTO.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

  Future<TestResultFixtureDTO> getPatTestResult(
      String companyId,
      String siteId,
      String equipmentId,
      String fixtureId,
      String projectId,
      int timestamp,
      String testName) async {
    try {
      Map<String, dynamic> params = {
        "companyId": companyId,
        "siteId": siteId,
        "projectId": projectId,
        "equipmentId": equipmentId,
        "fixtureId": fixtureId,
        "timestamp": timestamp,
        "testName": testName
      };
      Response response = await mDio.get("pdm/patAnomalies/testResults",
          queryParameters: params);
      return TestResultFixtureDTO.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

  Future<AlertProbeDTO> getPatAnomaliesProbe(
      String companyId,
      String siteId,
      String equipmentId,
      String fixtureId,
      String projectId,
      int timestamp) async {
    try {
      Map<String, dynamic> params = {
        "companyId": companyId,
        "siteId": siteId,
        "equipmentId": equipmentId,
        "fixtureId": fixtureId,
        "projectId": projectId,
        "timestamp": timestamp
      };
      Response response =
          await mDio.get("fixture/probeWithPat", queryParameters: params);
      return AlertProbeDTO.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }
}
