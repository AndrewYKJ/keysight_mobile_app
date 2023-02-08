import 'package:keysight_pma/controller/admin/preferred_setting/custom.dart';
import 'package:keysight_pma/model/alert/alert_assignee.dart';
import 'package:keysight_pma/model/alert/alert_casehistory.dart';
import 'package:keysight_pma/model/alert/alert_cpk.dart';
import 'package:keysight_pma/model/alert/alert_create_case.dart';
import 'package:keysight_pma/model/alert/alert_fixture_maintenance.dart';
import 'package:keysight_pma/model/alert/alert_group.dart';
import 'package:keysight_pma/model/alert/alert_pat_anomalies.dart';
import 'package:keysight_pma/model/alert/alert_probe.dart';
import 'package:keysight_pma/model/alert/alert_recentList.dart';
import 'package:keysight_pma/model/alert/alert_review_data.dart';
import 'package:keysight_pma/model/alert/alert_statistics.dart';
import 'package:keysight_pma/model/customize.dart';
import 'package:keysight_pma/model/dqm/custom.dart';

class AlertPageTitle {
  String? title;
  PDate? alertInfo;
  List<PDate>? alertInfoList;

  AlertPageTitle({this.title, this.alertInfo, this.alertInfoList});
}

class AlertFilterArguments {
  List<CustomDqmSortFilterItemSelectionDTO>? filterAlertTypeList;
  List<CustomDqmSortFilterItemSelectionDTO>? filterAlertStatusList;

  List<CustomDqmSortFilterItemSelectionDTO>? filterProbePropertyList;
  List<CustomDqmSortFilterItemSelectionDTO>? filterAlertPriorityList;
  List<CustomDqmSortFilterItemSelectionDTO>? filterAlertWorkflowList;
  List<DqmCustomDTO>? filterType;
  List<DqmCustomDTO>? fixtureList;
  int? fromWhere;
  AlertFilterArguments(
      {this.filterAlertTypeList,
      this.filterAlertPriorityList,
      this.filterAlertWorkflowList,
      this.filterAlertStatusList,
      this.fromWhere,
      this.filterProbePropertyList,
      this.filterType,
      this.fixtureList});
}

class AlertArguments {
  List<AlertReviewStatisticsDataDTO>? alertStatisticList;
  List<AlertAccuracyDataDTO>? alertAccuracyList;
  List<AlertStatisticsDataDTO>? preferedAlertList;
  AlertListDataDTO? alertListDataDTO;
  AlertFixtureMaintenanceDataDTO? fixtureMaintenanceDataDTO;
  String? testType;
  String? appBarTitle;
  AlertCpkDataDTO? alertCpkDataDTO;
  List<CustomDqmSortFilterItemSelectionDTO>? filterItemSelectionList;
  AlertStatisticsDataDTO? alertStatisticsDataDTO;
  int? createCaseSelectionType;
  AlertAssigneeDataDTO? assigneeDataDTO;
  CustomDTO? priority;
  CustomDTO? workflow;
  CustomDTO? status;
  AlertGroupDTO? alertGroupDTO;
  num? pickedGroupId;
  String? alertRowKeys;
  int? pushFrom;
  PatRecommendDataDTO? patData;
  AlertCaseHistoryDataDTO? caseHistoryData;
  List<BulkAlertInfoDTO>? bulkAlertList;
  List<BulkAlertInfoDTO>? bulkAlertActualList;
  String? timestamp;
  String? fixtureId;
  String? equipmentId;
  String? projectId;
  String? testName;
  String? companyId;
  String? siteId;
  AlertFixtureMapDTO? probeNodeData;
  AlertRecentModel? notificationListData;
  String? alertType;
  AlertPatAnomaliesDataDTO? alertPatAnomaliesDataDTO;

  AlertArguments(
      {this.alertStatisticList,
      this.notificationListData,
      this.pushFrom,
      this.alertAccuracyList,
      this.preferedAlertList,
      this.alertListDataDTO,
      this.fixtureMaintenanceDataDTO,
      this.testType,
      this.status,
      this.probeNodeData,
      this.caseHistoryData,
      this.appBarTitle,
      this.alertCpkDataDTO,
      this.filterItemSelectionList,
      this.alertStatisticsDataDTO,
      this.createCaseSelectionType,
      this.alertGroupDTO,
      this.pickedGroupId,
      this.patData,
      this.alertRowKeys,
      this.assigneeDataDTO,
      this.priority,
      this.workflow,
      this.bulkAlertList,
      this.bulkAlertActualList,
      this.timestamp,
      this.companyId,
      this.siteId,
      this.fixtureId,
      this.equipmentId,
      this.testName,
      this.projectId,
      this.alertType,
      this.alertPatAnomaliesDataDTO});
}
