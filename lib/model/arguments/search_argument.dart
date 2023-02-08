import 'package:keysight_pma/model/alert/alert_casehistory.dart';
import 'package:keysight_pma/model/alert/alert_detail.dart';
import 'package:keysight_pma/model/alert/alert_recentList.dart';
import 'package:keysight_pma/model/alert/alert_review_data.dart';
import 'package:keysight_pma/model/alert/alert_statistics.dart';
import 'package:keysight_pma/model/alertPreferencemodel.dart';
import 'package:keysight_pma/model/customize.dart';
import 'package:keysight_pma/model/dqm/anomaly_company.dart';
import 'package:keysight_pma/model/dqm/test_result_cpk_analog.dart';
import 'package:keysight_pma/model/dqm/test_result_cpk_pins.dart';
import 'package:keysight_pma/model/sortAndFilter/equipment.dart';
import 'package:keysight_pma/model/sortAndFilter/projects.dart';
import 'package:keysight_pma/model/updateUserPrefModel.dart';
import 'package:keysight_pma/model/user.dart';

class SearchArguments {
  List<ProjectDataDTO>? projectList;
  List<EquipmentDataDTO>? equipMentList;
  List<CustomDqmSortFilterProjectsDTO>? customSFProjectList;
  List<TestResultCpkAnalogDataDTO>? analogList;
  List<TestResultCpkPinsShortsTestJetDataDTO>? pinsList;
  List<TestResultCpkPinsShortsTestJetDataDTO>? shortsList;
  List<TestResultCpkPinsShortsTestJetDataDTO>? vtepList;
  List<TestResultCpkPinsShortsTestJetDataDTO>? xVtepList;
  List<TestResultCpkPinsShortsTestJetDataDTO>? functionalList;
  List<AnomalyCompanyDataDTO>? rmaAnomalyInfoList;
  List<AlertListDataDTO>? alertInfoList;
  List<AlertStatisticsDataDTO>? preferedASList;
  List<AlertCaseHistoryDataDTO>? caseHistoryList;
  List<AlertDetailHistoriesDTO>? caseHistoryCommentList;
  List<AlertRecentModel>? notificationList;
  List<CustomerMapDataDTO>? customerMapData;
  List<AlertPreferenceGroupDataDTO>? groupList;
  List<SiteLoadProjectDataDTO>? siteProjectListDataDTO;
  SearchArguments(
      {this.projectList,
      this.equipMentList,
      this.groupList,
      this.customSFProjectList,
      this.analogList,
      this.pinsList,
      this.shortsList,
      this.vtepList,
      this.xVtepList,
      this.functionalList,
      this.rmaAnomalyInfoList,
      this.alertInfoList,
      this.preferedASList,
      this.caseHistoryList,
      this.caseHistoryCommentList,
      this.notificationList,
      this.customerMapData,
      this.siteProjectListDataDTO});
}
