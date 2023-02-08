import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:keysight_pma/const/utils.dart';
import 'package:keysight_pma/dio/dio_repo.dart';
import 'package:keysight_pma/model/alert/alert_probe.dart';
import 'package:keysight_pma/model/dqm/anomalies.dart';
import 'package:keysight_pma/model/dqm/anomaly_company.dart';
import 'package:keysight_pma/model/dqm/boardresult_counts.dart';
import 'package:keysight_pma/model/dqm/boardresult_summary_byproject.dart';
import 'package:keysight_pma/model/dqm/count.dart';
import 'package:keysight_pma/model/dqm/daily_board_volume.dart';
import 'package:keysight_pma/model/dqm/failure_component_by_fixture.dart';
import 'package:keysight_pma/model/dqm/histogram.dart';
import 'package:keysight_pma/model/dqm/installbase.dart';
import 'package:keysight_pma/model/dqm/rma_corelation.dart';
import 'package:keysight_pma/model/dqm/test_result.dart';
import 'package:keysight_pma/model/dqm/test_result_change_limit.dart';
import 'package:keysight_pma/model/dqm/test_result_cpk.dart';
import 'package:keysight_pma/model/dqm/test_result_cpk_analog.dart';
import 'package:keysight_pma/model/dqm/test_result_cpk_pins.dart';
import 'package:keysight_pma/model/dqm/test_result_fixtures.dart';
import 'package:keysight_pma/model/dqm/test_result_testname.dart';
import 'package:keysight_pma/model/dqm/test_time_distribution.dart';
import 'package:keysight_pma/model/dqm/test_type.dart';
import 'package:keysight_pma/model/dqm/volume_by_project.dart';
import 'package:keysight_pma/model/dqm/worst_test_by_project.dart';
import 'package:keysight_pma/model/dqm/worst_test_name.dart';
import 'package:keysight_pma/model/dqm/yield_by_site.dart';

class DqmApi extends DioRepo {
  DqmApi(BuildContext context) {
    dioContext = context;
  }

  /*
    Digital Quality Dashboard Api
  */

  //Result of get projects list (PMA:dqm/results/sites) dqm/dailyBoardVolumeBySite
  Future<DailyBoardVolumeDTO> getDailyBoardVolumeBySite(
      String companyId, String siteId, String fromDate, String toDate) async {
    try {
      Map<String, dynamic> params = {
        "companyId": companyId,
        "siteId": siteId,
        "fromDate": fromDate,
        "toDate": toDate
      };
      Response response =
          await mDio.get("dqm/results/sites", queryParameters: params);
      return DailyBoardVolumeDTO.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

  Future<VolumeByProjectDTO> getVolumeByProject(
      String companyId, String siteId, String fromDate, String toDate) async {
    try {
      Map<String, dynamic> params = {
        "companyId": companyId,
        "siteId": siteId,
        "fromDate": fromDate,
        "toDate": toDate
      };
      Response response =
          await mDio.get("dqm/getVolumeByProject", queryParameters: params);
      return VolumeByProjectDTO.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

  //Result of get projects list (PMA:dqm/results/projects) / (dqm/getYieldBySite)
  Future<YieldBySiteDTO> getYieldBySite(
      String companyId, String siteId, String fromDate, String toDate) async {
    try {
      Map<String, dynamic> params = {
        "companyId": companyId,
        "siteId": siteId,
        "fromDate": fromDate,
        "toDate": toDate
      };
      Response response =
          await mDio.get("dqm/results/projects", queryParameters: params);
      return YieldBySiteDTO.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

  //(PMA:dqm/testresults/worstprojects/countV2) / (dqm/worstTestByProject)
  Future<WorstTestByProjectDTO> getWorstTestByProject(
      String companyId, String siteId, String fromDate, String toDate) async {
    try {
      Map<String, dynamic> params = {
        "companyId": companyId,
        "siteId": siteId,
        "fromDate": fromDate,
        "toDate": toDate,
        "projectCount": 5,
        "limit": 5
      };
      Response response = await mDio.get(
          "dqm/testresults/worstprojects/countV2",
          queryParameters: params);
      return WorstTestByProjectDTO.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

  /*
    Digital Quality Summary Api
  */

  Future<InstallbaseNotifDTO> getInstallbaseNotifBadgeList(
      String companyId, String siteId) async {
    try {
      Map<String, dynamic> params = {"companyId": companyId, "siteId": siteId};
      Response response = await mDio.get("installbase/notificationbadge/list",
          queryParameters: params);
      return InstallbaseNotifDTO.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

  Future<BoardResultCountsDTO> getBoardResultCountsForProject(String companyId,
      String siteId, String fromDate, String toDate, String projectId) async {
    try {
      Map<String, dynamic> params = {
        "companyId": companyId,
        "siteId": siteId,
        "fromDate": fromDate,
        "toDate": toDate,
        "projectId": projectId
      };
      Response response = await mDio.get(
          "dqm/boardResult/getCountsForProject/get",
          queryParameters: params);
      return BoardResultCountsDTO.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

  Future<BoardResultCountsDTO> getBoardResultCountsForEquipment(
      String companyId,
      String siteId,
      String fromDate,
      String toDate,
      String projectId) async {
    try {
      Map<String, dynamic> params = {
        "companyId": companyId,
        "siteId": siteId,
        "fromDate": fromDate,
        "toDate": toDate,
        "projectId": projectId
      };
      Response response = await mDio.get(
          "dqm/boardResult/getCountsByEquipment/get",
          queryParameters: params);
      return BoardResultCountsDTO.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

  Future<WorstTestByProjectDTO> getWorstTestResultsByProject(
      String companyId,
      String siteId,
      String fromDate,
      String toDate,
      int limit,
      int projectCount,
      String projectId) async {
    try {
      Map<String, dynamic> params = {
        "companyId": companyId,
        "siteId": siteId,
        "fromDate": fromDate,
        "toDate": toDate,
        "limit": limit,
        "projectCount": projectCount,
        "projectId": projectId
      };
      Response response = await mDio.get("dqm/testresults/worstproject/countV2",
          queryParameters: params);
      return WorstTestByProjectDTO.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

  Future<BoardResultSummaryByProjectDTO> getBoardResultSummaryListByProject(
      String companyId,
      String siteId,
      String fromDate,
      String toDate,
      List<String?> equipments,
      String projectId) async {
    try {
      var params = {
        "companyId": companyId,
        "siteId": siteId,
        "fromDate": fromDate,
        "toDate": toDate,
        "equipments": equipments,
        "projectId": projectId
      };
      Response response =
          await mDio.post("dqm/boardResult/listsummarybyproject", data: params);
      return BoardResultSummaryByProjectDTO.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

  Future<TestTimeDistributionDTO> getTestTimeDistribution(
      String companyId,
      String siteId,
      String fromDate,
      String toDate,
      List<String?> equipments,
      String projectId) async {
    try {
      var params = {
        "companyId": companyId,
        "siteId": siteId,
        "fromDate": fromDate,
        "toDate": toDate,
        "equipments": equipments,
        "projectId": projectId
      };
      Response response =
          await mDio.post("dqm/testTimeDistributionV2", data: params);
      return TestTimeDistributionDTO.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

  //mode enum - firstTryFail, falseFailure
  Future<DqmFailureComponentDTO> getListComponentFailureByFixture(
      String companyId,
      String siteId,
      String fromDate,
      String toDate,
      List<String?> equipments,
      String projectId,
      String mode) async {
    try {
      var params = {
        "companyId": companyId,
        "siteId": siteId,
        "fromDate": fromDate,
        "toDate": toDate,
        "equipments": equipments,
        "projectId": projectId
      };

      if (Utils.isNotEmpty(mode)) {
        params['mode'] = mode;
      }
      Response response = await mDio
          .post("dqm/result/listcomponentfailurebyfixture", data: params);
      return DqmFailureComponentDTO.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

  //mode enum - fail , firstTryFail, falseFailure
  Future<WorstTestNameDTO> getWorstTestNames(
      String companyId,
      String siteId,
      String fromDate,
      String toDate,
      List<String?> equipments,
      String projectId,
      String mode) async {
    try {
      var params = {
        "companyId": companyId,
        "siteId": siteId,
        "fromDate": fromDate,
        "toDate": toDate,
        "equipments": equipments,
        "projectId": projectId,
        "mode": mode
      };
      Response response = await mDio.post("dqm/worstTestName", data: params);
      return WorstTestNameDTO.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

  Future<WorstTestNameDTO> getTestTypeWorstTestNames(
      String companyId,
      String siteId,
      String fromDate,
      String toDate,
      List<String?> equipments,
      String projectId,
      String fixtureId,
      String testType,
      String mode) async {
    try {
      var params = {
        "companyId": companyId,
        "siteId": siteId,
        "fromDate": fromDate,
        "toDate": toDate,
        "equipments": equipments,
        "projectId": projectId,
        "fixtureId": fixtureId,
        "testType": testType,
        "mode": mode
      };
      Response response = await mDio.post("dqm/worstTestName", data: params);
      return WorstTestNameDTO.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

  Future<WorstTestNameDTO> getPinRetestSummary(
      String companyId,
      String siteId,
      String fromDate,
      String toDate,
      List<String?> equipments,
      String projectId) async {
    try {
      var params = {
        "companyId": companyId,
        "siteId": siteId,
        "fromDate": fromDate,
        "toDate": toDate,
        "equipments": equipments,
        "projectId": projectId
      };
      Response response =
          await mDio.post("dqm/result/pinRetestSummary", data: params);
      return WorstTestNameDTO.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

  Future<TestResultFixtureDTO> getFixtures(
      String companyId,
      String siteId,
      String fromDate,
      String toDate,
      List<String?> equipments,
      String projectId,
      String testName,
      String testType) async {
    try {
      var params = equipments.length > 0
          ? {
              "companyId": companyId,
              "siteId": siteId,
              "fromDate": fromDate,
              "toDate": toDate,
              "equipments": equipments,
              "projectId": projectId,
              "testName": testName,
              "testType": testType
            }
          : {
              "companyId": companyId,
              "siteId": siteId,
              "fromDate": fromDate,
              "toDate": toDate,
              "projectId": projectId,
              "testName": testName,
              "testType": testType
            };

      Response response =
          await mDio.post("dut/testresults/fixtures", data: params);
      return TestResultFixtureDTO.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

  Future<TestResultCpkDTO> getCpk(
      String companyId,
      String siteId,
      String fromDate,
      String toDate,
      List<String?> equipments,
      String projectId,
      String testName,
      String testType) async {
    try {
      var params = equipments.length > 0
          ? {
              "companyId": companyId,
              "siteId": siteId,
              "fromDate": fromDate,
              "toDate": toDate,
              "equipments": equipments,
              "projectId": projectId,
              "testName": testName,
              "testType": testType
            }
          : {
              "companyId": companyId,
              "siteId": siteId,
              "fromDate": fromDate,
              "toDate": toDate,
              "projectId": projectId,
              "testName": testName,
              "testType": testType
            };

      Response response = await mDio.post("cpk/tests/cpk", data: params);
      return TestResultCpkDTO.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

  Future<TestResultCpkDTO> getCpkForEquipment(
      String companyId,
      String siteId,
      String fromDate,
      String toDate,
      List<String?> equipments,
      String projectId,
      String equipmentId,
      String testName) async {
    try {
      var params = {
        "companyId": companyId,
        "siteId": siteId,
        "fromDate": fromDate,
        "toDate": toDate,
        "equipments": equipments,
        "projectId": projectId,
        "equipmentId": equipmentId,
        "testName": testName
      };
      Response response =
          await mDio.post("cpk/tests/cpkForEquipment", data: params);
      return TestResultCpkDTO.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

  Future<TestResultCpkDTO> getCpkForFixture(
      String companyId,
      String siteId,
      String fromDate,
      String toDate,
      List<String?> equipments,
      String projectId,
      String fixtureId,
      String testName) async {
    try {
      var params = {
        "companyId": companyId,
        "siteId": siteId,
        "fromDate": fromDate,
        "toDate": toDate,
        "equipments": equipments,
        "projectId": projectId,
        "fixtureId": fixtureId,
        "testName": testName
      };
      Response response =
          await mDio.post("cpk/tests/cpkForFixture", data: params);
      return TestResultCpkDTO.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

  Future<TestResultCpkDTO> getCpkForEquipmentAndFixture(
      String companyId,
      String siteId,
      String fromDate,
      String toDate,
      List<String?> equipments,
      String projectId,
      String equipmentId,
      String fixtureId,
      String testName) async {
    try {
      var params = {
        "companyId": companyId,
        "siteId": siteId,
        "fromDate": fromDate,
        "toDate": toDate,
        "equipments": equipments,
        "projectId": projectId,
        "equipmentId": equipmentId,
        "fixtureId": fixtureId,
        "testName": testName
      };
      Response response =
          await mDio.post("cpk/tests/cpkForEquipmentAndFixture", data: params);
      return TestResultCpkDTO.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

  Future<TestResultCpkDTO> getCpkForCombinedPanel(
      String companyId,
      String siteId,
      String fromDate,
      String toDate,
      List<String?> equipments,
      String projectId,
      String testName) async {
    try {
      var params = {
        "companyId": companyId,
        "siteId": siteId,
        "fromDate": fromDate,
        "toDate": toDate,
        "equipments": equipments,
        "projectId": projectId,
        "testName": testName
      };
      Response response =
          await mDio.post("cpk/tests/cpkForCombinedPanels", data: params);
      return TestResultCpkDTO.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

  Future<TestResultCpkAnalogDTO> getListAnalogCpk(
      String companyId,
      String siteId,
      String fromDate,
      String toDate,
      List<String?> equipments,
      String projectId,
      String testName,
      String testType) async {
    try {
      var params = equipments.length > 0
          ? {
              "companyId": companyId,
              "siteId": siteId,
              "fromDate": fromDate,
              "toDate": toDate,
              "equipments": equipments,
              "projectId": projectId
            }
          : {
              "companyId": companyId,
              "siteId": siteId,
              "fromDate": fromDate,
              "toDate": toDate,
              "projectId": projectId
            };
      if (Utils.isNotEmpty(testName)) {
        params["testName"] = testName;
      }
      if (Utils.isNotEmpty(testType)) {
        params["testType"] = testType;
      }
      Response response =
          await mDio.post("dut/testresults/listAnalogCPK", data: params);
      return TestResultCpkAnalogDTO.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

  Future<TestResultCpkAnalogDTO> getListAnalogCpkCH(
    String companyId,
    String siteId,
    String fromDate,
    String toDate,
    String projectId,
  ) async {
    try {
      var params = {
        "companyId": companyId,
        "siteId": siteId,
        "fromDate": fromDate,
        "toDate": toDate,
        "projectId": projectId
      };

      Response response =
          await mDio.post("dut/testresults/listAnalogCPK", data: params);
      return TestResultCpkAnalogDTO.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

  Future<HistogramDTO> getHistogram(
      int binNum,
      String companyId,
      String siteId,
      String projectId,
      String testname,
      String currentDate,
      List<String?> equipments) async {
    try {
      var params = equipments.length > 0
          ? {
              "binNum": binNum,
              "companyId": companyId,
              "siteId": siteId,
              "projectId": projectId,
              "currentDate": currentDate,
              "equipments": equipments,
              "testName": testname
            }
          : {
              "binNum": binNum,
              "companyId": companyId,
              "siteId": siteId,
              "projectId": projectId,
              "currentDate": currentDate,
              "testName": testname
            };

      Response response = await mDio.post("cpk/histogram", data: params);
      return HistogramDTO.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

  Future<HistogramDTO> getHistogramForEquipment(
      int binNum,
      String companyId,
      String siteId,
      String projectId,
      String equipmentId,
      String testname,
      String currentDate,
      List<String?> equipments) async {
    try {
      var params = {
        "binNum": binNum,
        "companyId": companyId,
        "siteId": siteId,
        "projectId": projectId,
        "equipmentId": equipmentId,
        "currentDate": currentDate,
        "equipments": equipments,
        "testName": testname
      };

      Response response =
          await mDio.post("cpk/histogramForEquipment", data: params);
      return HistogramDTO.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

  Future<HistogramDTO> getHistogramForFixture(
      int binNum,
      String companyId,
      String siteId,
      String projectId,
      String fixtureId,
      String testname,
      String currentDate,
      List<String?> equipments) async {
    try {
      var params = {
        "binNum": binNum,
        "companyId": companyId,
        "siteId": siteId,
        "projectId": projectId,
        "fixtureId": fixtureId,
        "currentDate": currentDate,
        "equipments": equipments,
        "testName": testname
      };

      Response response =
          await mDio.post("cpk/histogramForFixture", data: params);
      return HistogramDTO.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

  Future<HistogramDTO> getHistogramForEquipmentAndFixture(
      int binNum,
      String companyId,
      String siteId,
      String projectId,
      String fixtureId,
      String equipmentId,
      String testname,
      String currentDate,
      List<String?> equipments) async {
    try {
      var params = {
        "binNum": binNum,
        "companyId": companyId,
        "siteId": siteId,
        "projectId": projectId,
        "fixtureId": fixtureId,
        "equipmentId": equipmentId,
        "currentDate": currentDate,
        "equipments": equipments,
        "testName": testname
      };

      Response response =
          await mDio.post("cpk/histogramForEquipmentAndFixture", data: params);
      return HistogramDTO.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

  Future<HistogramDTO> getHistogramForCombinedPanel(
      int binNum,
      String companyId,
      String siteId,
      String projectId,
      String testname,
      String currentDate,
      List<String?> equipments) async {
    try {
      var params = {
        "binNum": binNum,
        "companyId": companyId,
        "siteId": siteId,
        "projectId": projectId,
        "currentDate": currentDate,
        "equipments": equipments,
        "testName": testname
      };

      Response response =
          await mDio.post("cpk/histogramForCombinedPanels", data: params);
      return HistogramDTO.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

  Future<HistogramDTO> getRmaTestResultHistogram(
      int binNum,
      String companyId,
      String siteId,
      String projectId,
      String testname,
      String currentDate) async {
    try {
      var params = {
        "binNum": binNum,
        "companyId": companyId,
        "siteId": siteId,
        "projectId": projectId,
        "currentDate": currentDate,
        "testName": testname
      };

      Response response = await mDio.post("cpk/histogram", data: params);
      return HistogramDTO.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

  Future<TestTypeDTO> getTestTypeList(String companyId, String siteId,
      String projectId, String testType) async {
    try {
      var params = {
        "companyId": companyId,
        "siteId": siteId,
        "projectId": projectId,
        "testType": testType
      };

      Response response =
          await mDio.get("pinsshortvtep/listTestType", queryParameters: params);
      return TestTypeDTO.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

  Future<AnomalyCompanyDTO> getListAnomalyCompanyData(
      String companyId, String siteId, String serialNumber) async {
    try {
      var params = {
        "companyId": companyId,
        "siteId": siteId,
        "serialNumber": serialNumber
      };

      Response response = await mDio.get("dqm/rma/listAnomalyCompanyData",
          queryParameters: params);
      return AnomalyCompanyDTO.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

  Future<AnomaliesDTO> getAnomalies(
      String companyId,
      String siteId,
      String serialNumber,
      String equipmentId,
      String projectId,
      String timestamp,
      String startTime,
      String endTime) async {
    try {
      var params = {
        "companyId": companyId,
        "siteId": siteId,
        "serialNumber": serialNumber,
        "equipmentId": equipmentId,
        "projectId": projectId,
        "timestamp": timestamp,
        "startTime": startTime,
        "endTime": endTime
      };

      Response response = await mDio.post("rma/anomalies", data: params);
      return AnomaliesDTO.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

  Future<TestResultTestNameDTO> getTestResultByTestName(
      String companyId,
      String siteId,
      String serialNumber,
      String equipmentId,
      String projectId,
      String timestamp,
      String startTime,
      String endTime,
      String testname) async {
    try {
      var params = {
        "companyId": companyId,
        "siteId": siteId,
        "serialNumber": serialNumber,
        "equipmentId": equipmentId,
        "projectId": projectId,
        "timestamp": timestamp,
        "startTime": startTime,
        "endTime": endTime,
        "testName": testname
      };

      Response response =
          await mDio.post("dut/getTestResultbyTestname", data: params);
      return TestResultTestNameDTO.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

  Future<RmaCoRelationDTO> getBoardResult(
      String companyId,
      String siteId,
      String serialNumber,
      String equipmentId,
      String projectId,
      String timestamp,
      String startTime,
      String endTime,
      String firstTestname,
      String secondTestname) async {
    try {
      var params = {
        "companyId": companyId,
        "siteId": siteId,
        "serialNumber": serialNumber,
        "equipmentId": equipmentId,
        "projectId": projectId,
        "timestamp": timestamp,
        "startTime": startTime,
        "endTime": endTime,
        "firstTestName": firstTestname,
        // "firstTestNameLowerBound": 0,
        // "firstTestNameUpperBound": 0,
        // "lowerLimit": 0,
        "secondTestName": secondTestname,
        // "secondTestNameLowerBound": 0,
        // "secondTestNameUpperBound": 0,
        "testName": firstTestname,
        // "upperLimit": 0
      };

      Response response = await mDio.post("dut/boardresult", data: params);
      return RmaCoRelationDTO.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

  Future<TestResultChangeLimitDTO> getTestResultChangeLimit(
    String companyId,
    String siteId,
    String equipmentId,
    String projectId,
    String timestamp,
    String testname,
    double oldUpperLimit,
    double oldLowerLimit,
    double newUpperLimit,
    double newLowerLimit,
    String oldLimitTimestamp,
  ) async {
    try {
      var params = {
        "companyId": companyId,
        "siteId": siteId,
        "equipmentId": equipmentId,
        "projectId": projectId,
        "timestamp": timestamp,
        "testName": testname,
        "oldUpperLimit": oldUpperLimit,
        "oldLowerLimit": oldLowerLimit,
        "newUpperLimit": newUpperLimit,
        "newLowerLimit": newLowerLimit,
        "oldLimitTimestamp": oldLimitTimestamp,
      };

      Response response =
          await mDio.post("dut/listchangelimittestresult", data: params);
      return TestResultChangeLimitDTO.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

  Future<TestResultTestNameDTO> getFailureComponents(
      String companyId,
      String siteId,
      String equipmentId,
      String projectId,
      String timestamp,
      String testname,
      String startTime,
      String endTime,
      String serialNumber) async {
    try {
      var params = {
        "companyId": companyId,
        "siteId": siteId,
        "equipmentId": equipmentId,
        "projectId": projectId,
        "timestamp": timestamp,
        "testName": testname,
        "endTime": endTime,
        "serialNumber": serialNumber,
        "startTime": startTime
      };

      Response response =
          await mDio.post("rma/failureComponents", data: params);
      return TestResultTestNameDTO.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

  Future<TestResultCpkPinsShortsDTO> getTestResultCpkPinsShortsTestJet(
      String companyId,
      String siteId,
      String projectId,
      String fromDate,
      String toDate,
      String testType,
      List<String?> equipments,
      List<String?> testNames) async {
    try {
      var params = {
        "companyId": companyId,
        "siteId": siteId,
        "projectId": projectId,
        "equipments": equipments,
        "testNames": testNames,
        "fromDate": fromDate,
        "toDate": toDate
      };

      if (Utils.isNotEmpty(testType)) {
        params['testType'] = testType;
      }

      Response response = await mDio.post(
          "pinsshortvtep/listCpkOfPinShortsTestjetByTestType",
          data: params);
      return TestResultCpkPinsShortsDTO.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

  Future<TestResultCpkPinsShortsDTO> getTestResultCpkFunctional(
    String companyId,
    String siteId,
    String projectId,
    String fromDate,
    String toDate,
    List<String?> equipments,
  ) async {
    try {
      var params = {
        "companyId": companyId,
        "siteId": siteId,
        "projectId": projectId,
        "equipments": equipments,
        "fromDate": fromDate,
        "toDate": toDate
      };

      Response response =
          await mDio.post("functional/listfctcpk", data: params);
      return TestResultCpkPinsShortsDTO.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

  Future<CompareCountDTO> getCompareCount(
    String companyId,
    String siteId,
    String projectId,
    String fromDate,
    String toDate,
    String testname,
    List<String?> equipments,
  ) async {
    try {
      var params = {};

      if (equipments.length > 0) {
        params = {
          "companyId": companyId,
          "siteId": siteId,
          "projectId": projectId,
          "equipments": equipments,
          "fromDate": fromDate,
          "toDate": toDate,
          "testName": testname
        };
      } else {
        params = {
          "companyId": companyId,
          "siteId": siteId,
          "projectId": projectId,
          "fromDate": fromDate,
          "toDate": toDate,
          "testName": testname
        };
      }

      Response response =
          await mDio.post("dut/testresults/counts", data: params);
      return CompareCountDTO.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

  Future<Response> getCompareByEquipment(
    String companyId,
    String siteId,
    String projectId,
    String fromDate,
    String toDate,
    String testname,
    String testNameSuffix,
    List<String?> equipments,
  ) async {
    try {
      var params = {
        "companyId": companyId,
        "siteId": siteId,
        "projectId": projectId,
        "equipments": equipments,
        "fromDate": fromDate,
        "toDate": toDate,
        "testName": testname,
        "testNameSuffix": testNameSuffix
      };

      Response response = await mDio.get("dut/testresults/byequipment",
          queryParameters: params);
      return response;
    } catch (e) {
      throw e;
    }
  }

  Future<Response> getCompareByFixture(
    String companyId,
    String siteId,
    String projectId,
    String fromDate,
    String toDate,
    String testname,
    String testNameSuffix,
    List<String?> equipments,
  ) async {
    try {
      var params = {
        "companyId": companyId,
        "siteId": siteId,
        "projectId": projectId,
        "equipments": equipments,
        "fromDate": fromDate,
        "toDate": toDate,
        "testName": testname,
        "testNameSuffix": testNameSuffix
      };

      Response response =
          await mDio.get("dut/testresults/byfixture", queryParameters: params);
      return response;
    } catch (e) {
      throw e;
    }
  }

  Future<Response> getCompareByEquipmentFixture(
    String companyId,
    String siteId,
    String projectId,
    String fromDate,
    String toDate,
    String testname,
    String testNameSuffix,
    List<String?> equipments,
  ) async {
    try {
      var params = {
        "companyId": companyId,
        "siteId": siteId,
        "projectId": projectId,
        "equipments": equipments,
        "fromDate": fromDate,
        "toDate": toDate,
        "testName": testname,
        "testNameSuffix": testNameSuffix
      };

      Response response = await mDio.get(
          "dut/testresults/byequipmentandfixture",
          queryParameters: params);
      return response;
    } catch (e) {
      throw e;
    }
  }

  Future<Response> getCompareByPanel(
    String companyId,
    String siteId,
    String projectId,
    String fromDate,
    String toDate,
    String testname,
    String testNameSuffix,
    List<String?> equipments,
  ) async {
    try {
      var params = {
        "companyId": companyId,
        "siteId": siteId,
        "projectId": projectId,
        "equipments": equipments,
        "fromDate": fromDate,
        "toDate": toDate,
        "testName": testname,
        "testNameSuffix": testNameSuffix
      };

      Response response =
          await mDio.get("dut/testresults/bypanel", queryParameters: params);
      return response;
    } catch (e) {
      throw e;
    }
  }

  Future<TestResultDTO> getCompareByPanelCombined(
    String companyId,
    String siteId,
    String projectId,
    String fromDate,
    String toDate,
    String testname,
    String testNameSuffix,
    List<String?> equipments,
  ) async {
    try {
      var params = {
        "companyId": companyId,
        "siteId": siteId,
        "projectId": projectId,
        "equipments": equipments,
        "fromDate": fromDate,
        "toDate": toDate,
        "testName": testname,
        "testNameSuffix": testNameSuffix
      };

      Response response = await mDio.get("dut/testresults/bypanelCombined",
          queryParameters: params);
      return TestResultDTO.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

//fixture/fixtureList
  Future<FixturesList> getFixturesList(
    String companyId,
    String siteId,
    String equipmentId,
  ) async {
    try {
      var params = {
        "companyId": companyId,
        "siteId": siteId,
      };
      if (Utils.isNotEmpty(equipmentId)) {
        params['equipmentId'] = equipmentId;
      }
      Response response =
          await mDio.get("fixture/fixtureList", queryParameters: params);
      return FixturesList.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

//fixture/probeHeatMap
  Future<AlertProbeDTO> getProbeHeatMap(
    String companyId,
    String siteId,
    String fixtureId,
    String fromDate,
    String mode,
    String projectId,
    String testName,
    String toDate,
  ) async {
    try {
      var params = {
        "companyId": companyId,
        "siteId": siteId,
        "fromDate": fromDate,
        "toDate": toDate,
        "mode": mode,
        "projectId": projectId,
        "testName": testName,
      };
      if (Utils.isNotEmpty(fixtureId)) {
        params['fixtureId'] = fixtureId;
      }
      Response response = await mDio.post("fixture/probeHeatMap", data: params);
      return AlertProbeDTO.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }
}
