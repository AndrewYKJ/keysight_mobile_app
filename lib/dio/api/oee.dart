import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:keysight_pma/dio/dio_repo.dart';
import 'package:keysight_pma/model/oee/oeeAvailability.dart';
import 'package:keysight_pma/model/oee/oeeDowntime.dart';
import 'package:keysight_pma/model/oee/oeeEquipment.dart';
import 'package:keysight_pma/model/oee/oeeNotif.dart';
import 'package:keysight_pma/model/oee/oeeSiteStatus.dart';
import 'package:keysight_pma/model/oee/oeeSummary.dart';
import 'package:keysight_pma/model/oee/oeeSummaryPercentage.dart';
import 'package:keysight_pma/model/oee/oeeSummaryPerformance.dart';
import 'package:keysight_pma/model/oee/oeeSummaryQuality.dart';

class OeeApi extends DioRepo {
  OeeApi(BuildContext context) {
    dioContext = context;
  }

  Future<OeeEquipmentDTO> getDailyVolumeByEquipment(
      String companyId, String siteId, String fromDate, String toDate) async {
    try {
      Map<String, dynamic> params = {
        "companyId": companyId,
        "siteId": siteId,
        "fromDate": fromDate,
        "toDate": toDate
      };
      Response response = await mDio.get("dut/results/equipments/counts",
          queryParameters: params);
      return OeeEquipmentDTO.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

//(/dut/results/projects/counts)
  Future<OeeEquipmentDTO> getDailyVolumeByProject(
      String companyId, String siteId, String fromDate, String toDate) async {
    try {
      Map<String, dynamic> params = {
        "companyId": companyId,
        "siteId": siteId,
        "fromDate": fromDate,
        "toDate": toDate
      };
      Response response = await mDio.get("dut/results/projects/counts",
          queryParameters: params);
      return OeeEquipmentDTO.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

//(/oee/equipments/availability)daily utilization by all equipments.
  Future<OeeAvailabilityDTO> getDailyUtilizationByAllEquipments(
      String companyId, String siteId, String fromDate, String toDate) async {
    try {
      Map<String, dynamic> params = {
        "companyId": companyId,
        "siteId": siteId,
        "fromDate": fromDate,
        "toDate": toDate
      };
      Response response = await mDio.get("oee/equipments/availability",
          queryParameters: params);
      return OeeAvailabilityDTO.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

  //daily OEE score by equipment
  Future<OeeEquipmentDTO> getDailyOEEScoreByEquipments(
      String companyId, String siteId, String fromDate, String toDate) async {
    try {
      Map<String, dynamic> params = {
        "companyId": companyId,
        "siteId": siteId,
        "fromDate": fromDate,
        "toDate": toDate
      };
      Response response =
          await mDio.get("oee/equipments", queryParameters: params);
      return OeeEquipmentDTO.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

  //get daily volume output by project
  Future<OeeEquipmentDTO> getDailyCountByProject(
      String companyId, String siteId, String fromDate, String toDate) async {
    try {
      Map<String, dynamic> params = {
        "companyId": companyId,
        "siteId": siteId,
        "fromDate": fromDate,
        "toDate": toDate
      };
      Response response = await mDio.get("dut/results/projects/dailycounts",
          queryParameters: params);
      return OeeEquipmentDTO.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

  Future<OeeEquipmentDTO> getDailyCountByEquipments(
      String companyId, String siteId, String fromDate, String toDate) async {
    try {
      Map<String, dynamic> params = {
        "companyId": companyId,
        "siteId": siteId,
        "fromDate": fromDate,
        "toDate": toDate
      };
      Response response = await mDio.get("dut/results/equipments/dailycounts",
          queryParameters: params);
      return OeeEquipmentDTO.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

//(/oee/dashboard/aggregatedOeeBySite)
  Future<OeeSummaryDTO> getAggregatedOEEbySite(
      String fromDate, String toDate) async {
    try {
      Map<String, dynamic> params = {"fromDate": fromDate, "toDate": toDate};
      Response response = await mDio.get("oee/dashboard/aggregatedOeeBySite",
          queryParameters: params);
      return OeeSummaryDTO.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

  //(/oee/dashboard/dailyOeeForSite)
  Future<OeeSummaryDTO> getDailyOEEforSite(
      String companyId, String siteId, String fromDate, String toDate) async {
    try {
      Map<String, dynamic> params = {
        "companyId": companyId,
        "siteId": siteId,
        "fromDate": fromDate,
        "toDate": toDate
      };
      Response response = await mDio.get("oee/dashboard/dailyOeeForSite",
          queryParameters: params);
      return OeeSummaryDTO.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

  //(/oee/dashboard/aggregatedOeeByEquipment)
  Future<OeeSummaryDTO> getAggregatedOEEbyEquipment(
      String companyId, String siteId, String fromDate, String toDate) async {
    try {
      Map<String, dynamic> params = {
        "companyId": companyId,
        "siteId": siteId,
        "fromDate": fromDate,
        "toDate": toDate
      };
      Response response = await mDio.get(
          "oee/dashboard/aggregatedOeeByEquipment",
          queryParameters: params);
      return OeeSummaryDTO.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

/****************************************/
  //(/oee/dashboard/dailyOeeForEquipment)
  Future<OeeSummaryDTO> getDailyOEEforEquipment(String companyId, String siteId,
      String equipmentId, String fromDate, String toDate) async {
    try {
      Map<String, dynamic> params = {
        "companyId": companyId,
        "siteId": siteId,
        "equipmentId": equipmentId,
        "fromDate": fromDate,
        "toDate": toDate
      };
      Response response = await mDio.get("oee/dashboard/dailyOeeForEquipment",
          queryParameters: params);
      return OeeSummaryDTO.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }
/****************************** */

//(/dtm/getListOfDownTimeByCompanySiteEqAndDateRange)
  Future<DownTimeMonitoringDTO2> getListOfDownTimeByCompanySiteEqAndDateRange(
      String companyId,
      String siteId,
      String equipmentId,
      String fromDate,
      String toDate,
      String groupBy) async {
    try {
      Map<String, dynamic> params = {
        "companyId": companyId,
        "siteId": siteId,
        "equipmentId": equipmentId,
        "startDate": fromDate,
        "endDate": toDate,
        "groupBy": groupBy
      };
      Response response = await mDio.get(
          "dtm/getListOfDownTimeByCompanySiteEqAndDateRange",
          queryParameters: params);

      return DownTimeMonitoringDTO2.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

  //(/dtm/getListOfDownTimeDetailsByCompanySiteEqAndDateRange)
  Future<DownTimeMonitoringDTO>
      getListOfDownTimeDetailsByCompanySiteEqAndDateRange(
          String companyId,
          String siteId,
          String equipmentId,
          String fromDate,
          String toDate,
          String groupBy) async {
    try {
      Map<String, dynamic> params = {
        "companyId": companyId,
        "siteId": siteId,
        "equipmentId": equipmentId,
        "startDate": fromDate,
        "endDate": toDate,
        "groupBy": groupBy
      };
      Response response = await mDio.get(
          "dtm/getListOfDownTimeDetailsByCompanySiteEqAndDateRange",
          queryParameters: params);
      return DownTimeMonitoringDTO.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

  //(/oee/dashboard/aggregatedAvailabilityBySite)
  Future<OeeSummaryDTO> getAggregatedAvailabilityBySite(
      String companyId, String siteId, String fromDate, String toDate) async {
    try {
      Map<String, dynamic> params = {
        "companyId": companyId,
        "siteId": siteId,
        "fromDate": fromDate,
        "toDate": toDate
      };
      Response response = await mDio.get(
          "oee/dashboard/aggregatedAvailabilityBySite",
          queryParameters: params);
      return OeeSummaryDTO.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

  Future<OeeSummaryDTO> getAggregatedAvailabilityByEquipment(
      String companyId, String siteId, String fromDate, String toDate) async {
    try {
      Map<String, dynamic> params = {
        "companyId": companyId,
        "siteId": siteId,
        "fromDate": fromDate,
        "toDate": toDate
      };
      Response response = await mDio.get(
          "oee/dashboard/aggregatedAvailabilityByEquipment",
          queryParameters: params);
      return OeeSummaryDTO.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

  Future<OeeSummaryDTO> getDailyAvailabilityForEquipment(String companyId,
      String siteId, String equipmentId, String fromDate, String toDate) async {
    try {
      Map<String, dynamic> params = {
        "companyId": companyId,
        "siteId": siteId,
        "equipmentId": equipmentId,
        "fromDate": fromDate,
        "toDate": toDate
      };
      Response response = await mDio.get(
          "oee/dashboard/dailyAvailabilityForEquipment",
          queryParameters: params);
      return OeeSummaryDTO.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

  Future<OeeSummaryDTO> getAggregatedUtilTimeByProject(String companyId,
      String siteId, String equipmentId, String fromDate, String toDate) async {
    try {
      Map<String, dynamic> params = {
        "companyId": companyId,
        "siteId": siteId,
        "equipmentId": equipmentId,
        "fromDate": fromDate,
        "toDate": toDate
      };
      Response response = await mDio.get(
          "oee/dashboard/aggregatedUtilTimeByProject",
          queryParameters: params);
      return OeeSummaryDTO.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

  //(/oee/dashboard/aggregatedPerformanceBySite)
  Future<OeePerformanceDTO> getAggregatedPerformanceBySite(
      String companyId, String siteId, String fromDate, String toDate) async {
    try {
      Map<String, dynamic> params = {
        "companyId": companyId,
        "siteId": siteId,
        "fromDate": fromDate,
        "toDate": toDate
      };
      Response response = await mDio.get(
          "oee/dashboard/aggregatedPerformanceBySite",
          queryParameters: params);
      return OeePerformanceDTO.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

  Future<OeePerformanceDTO> getAggregatedPerformanceByEquipment(
      String companyId, String siteId, String fromDate, String toDate) async {
    try {
      Map<String, dynamic> params = {
        "companyId": companyId,
        "siteId": siteId,
        "fromDate": fromDate,
        "toDate": toDate
      };
      Response response = await mDio.get(
          "oee/dashboard/aggregatedPerformanceByEquipment",
          queryParameters: params);
      return OeePerformanceDTO.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

  Future<OeePerformanceDTO> getDailyPerformanceForEquipment(String companyId,
      String siteId, String equipmentId, String fromDate, String toDate) async {
    try {
      Map<String, dynamic> params = {
        "companyId": companyId,
        "siteId": siteId,
        "equipmentId": equipmentId,
        "fromDate": fromDate,
        "toDate": toDate
      };
      Response response = await mDio.get(
          "oee/dashboard/dailyPerformanceForEquipment",
          queryParameters: params);
      return OeePerformanceDTO.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

  Future<OeePerformanceDTO> getPerformanceByEquipmentAndProject(
      String companyId,
      String siteId,
      String equipmentId,
      String fromDate,
      String toDate) async {
    try {
      Map<String, dynamic> params = {
        "companyId": companyId,
        "siteId": siteId,
        "equipmentId": equipmentId,
        "fromDate": fromDate,
        "toDate": toDate
      };
      Response response = await mDio.get(
          "oee/dashboard/performanceByEquipmentAndProject",
          queryParameters: params);
      return OeePerformanceDTO.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

  Future<OeeQualityDTO> getAggregatedQualityBySite(
      String companyId, String siteId, String fromDate, String toDate) async {
    try {
      Map<String, dynamic> params = {
        "companyId": companyId,
        "siteId": siteId,
        "fromDate": fromDate,
        "toDate": toDate
      };
      Response response = await mDio.get(
          "oee/dashboard/aggregatedQualityBySite",
          queryParameters: params);
      return OeeQualityDTO.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

  Future<OeeQualityDTO> getAggregatedQualityByEquipment(
      String companyId, String siteId, String fromDate, String toDate) async {
    try {
      Map<String, dynamic> params = {
        "companyId": companyId,
        "siteId": siteId,
        "fromDate": fromDate,
        "toDate": toDate
      };
      Response response = await mDio.get(
          "oee/dashboard/aggregatedQualityByEquipment",
          queryParameters: params);
      return OeeQualityDTO.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

  Future<OeeQualityDTO> getDailyQualityForEquipment(String companyId,
      String siteId, String equipmentId, String fromDate, String toDate) async {
    try {
      Map<String, dynamic> params = {
        "companyId": companyId,
        "siteId": siteId,
        "equipmentId": equipmentId,
        "fromDate": fromDate,
        "toDate": toDate
      };
      Response response = await mDio.get(
          "oee/dashboard/dailyQualityForEquipment",
          queryParameters: params);
      return OeeQualityDTO.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

  Future<OeeQualityDTO> getQualityByEquipmentAndProject(String companyId,
      String siteId, String equipmentId, String fromDate, String toDate) async {
    try {
      Map<String, dynamic> params = {
        "companyId": companyId,
        "siteId": siteId,
        "equipmentId": equipmentId,
        "fromDate": fromDate,
        "toDate": toDate
      };
      Response response = await mDio.get(
          "oee/dashboard/qualityByEquipmentAndProject",
          queryParameters: params);
      return OeeQualityDTO.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

//!@#$%^&*(!@#$%^&*()@#$%^&*()_)))
//!@#$%^&*(!@#$%^&*()@#$%^&*()_)))
//!@#$%^&*(!@#$%^&*()@#$%^&*()_)))
//!@#$%^&*(!@#$%^&*()@#$%^&*()_)))

  //(/admin/siteWithStatus) not found
  Future<OeeSiteStatus> getSiteWithStatus(
    String companyId,
    String siteId,
  ) async {
    try {
      Map<String, dynamic> params = {
        "companyId": companyId,
        "siteId": siteId,
      };
      Response response =
          await mDio.get("admin/siteWithStatus", queryParameters: params);
      return OeeSiteStatus.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

  //(/installbase/notificationbadge/list)
  Future<OeeInstallbaseNotifDTO> getInstallbasNotificationBadge(
    String companyId,
    String siteId,
  ) async {
    try {
      Map<String, dynamic> params = {
        "companyId": companyId,
        "siteId": siteId,
      };
      Response response = await mDio.get("installbase/notificationbadge/list",
          queryParameters: params);
      return OeeInstallbaseNotifDTO.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

  //(/oee/sites/aggregated/get)
  Future<OeeSummaryPerecentageDTO> getAggregatedSummary(
    String companyId,
    String siteId,
  ) async {
    try {
      Map<String, dynamic> params = {
        "companyId": companyId,
        "siteId": siteId,
      };
      Response response =
          await mDio.get("oee/sites/aggregated/get", queryParameters: params);
      return OeeSummaryPerecentageDTO.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

//oee summary chart details

}
