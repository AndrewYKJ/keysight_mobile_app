import 'package:keysight_pma/model/customize.dart';
import 'package:keysight_pma/model/dqm/anomalies.dart';
import 'package:keysight_pma/model/dqm/anomaly_company.dart';
import 'package:keysight_pma/model/dqm/boardresult_summary_byproject.dart';
import 'package:keysight_pma/model/dqm/daily_board_volume.dart';
import 'package:keysight_pma/model/dqm/failure_component_by_fixture.dart';
import 'package:keysight_pma/model/dqm/test_result.dart';
import 'package:keysight_pma/model/dqm/test_result_change_limit.dart';
import 'package:keysight_pma/model/dqm/test_result_cpk_analog.dart';
import 'package:keysight_pma/model/dqm/test_result_cpk_pins.dart';
import 'package:keysight_pma/model/dqm/test_result_fixtures.dart';
import 'package:keysight_pma/model/dqm/test_result_testname.dart';
import 'package:keysight_pma/model/dqm/test_time_distribution.dart';
import 'package:keysight_pma/model/dqm/volume_by_project.dart';
import 'package:keysight_pma/model/dqm/worst_test_by_project.dart';
import 'package:keysight_pma/model/dqm/worst_test_name.dart';
import 'package:keysight_pma/model/dqm/yield_by_site.dart';
import 'package:keysight_pma/model/js/js.dart';

class DqmChartDetailArguments {
  String? chartName;
  DailyBoardVolumeDTO? dailyBoardVolumeDTO;
  YieldBySiteDTO? yieldBySiteDTO;
  VolumeByProjectDTO? volumeByProjectDTO;
  WorstTestByProjectDTO? worstTestByProjectDTO;
  String? dataType;
  int? currentTab;
  DqmChartDetailArguments(
      {this.chartName,
      this.dailyBoardVolumeDTO,
      this.yieldBySiteDTO,
      this.volumeByProjectDTO,
      this.worstTestByProjectDTO,
      this.dataType,
      this.currentTab});
}

class DqmSortFilterArguments {
  List<CustomDqmSortFilterProjectsDTO>? projectIdList;
  String? sortBy;
  String? filterBy;
  int? fromWhere;
  String? sumType;

  DqmSortFilterArguments(
      {this.projectIdList,
      this.sortBy,
      this.filterBy,
      this.fromWhere,
      this.sumType});
}

class DqmSummaryQmArguments {
  String? appBarTitle;
  String? sumType;
  JSMetricQualityByProjectDataDTO? dataDTO;

  DqmSummaryQmArguments({this.appBarTitle, this.sumType, this.dataDTO});
}

class DqmTestResultArguments {
  int? fromWhere;
  String? filterBy;
  String? appBarTitle;
  List<CustomDqmSortFilterProjectsDTO>? finalDispositionList;
  List<CustomDqmSortFilterItemSelectionDTO>? itemSelectionList;
  String? mode;
  String? fixtureId;
  String? testType;
  String? testname;
  String? projectId;
  String? startDate;

  String? endDate;
  String? equipmentId;
  TestResultCpkAnalogDataDTO? analogDataDTO;
  TestResultFixtureDataDTO? fixtureDataDTO;
  TestResultTestNameDataDTO? testNameDataDTO;
  TestResultCpkPinsShortsTestJetDataDTO? pinsDataDTO;
  TestResultCpkPinsShortsTestJetDataDTO? shortsDataDTO;
  TestResultCpkPinsShortsTestJetDataDTO? vtepDataDTO;
  TestResultCpkPinsShortsTestJetDataDTO? funcDataDTO;
  TestResultCpkPinsShortsTestJetDataDTO? xvtepDataDTO;
  List<CustomDqmSortFilterItemSelectionDTO>? compareList;
  MeasurementAnomalyDataDTO? measurementDTO;
  String? compareBy;
  TestResultDataDTO? compareTestResultDataDTO;
  JSLimitChangeDTO? testResultChangeLimitDataDTO;
  BoardResultSummaryByProjectDataDTO? boardResultDataDTO;
  TestTimeDistributionDataDTO? testTimeDistributionDataDTO;
  DqmFailureComponentDTO? failureComponentDTO;
  WorstTestNameDTO? worstTestNameDTO;

  DqmTestResultArguments(
      {this.fromWhere,
      this.filterBy,
      this.equipmentId,
      this.appBarTitle,
      this.finalDispositionList,
      this.itemSelectionList,
      this.mode,
      this.fixtureId,
      this.testType,
      this.testname,
      this.projectId,
      this.startDate,
      this.endDate,
      this.analogDataDTO,
      this.fixtureDataDTO,
      this.testNameDataDTO,
      this.pinsDataDTO,
      this.shortsDataDTO,
      this.vtepDataDTO,
      this.funcDataDTO,
      this.xvtepDataDTO,
      this.compareList,
      this.measurementDTO,
      this.compareBy,
      this.compareTestResultDataDTO,
      this.testResultChangeLimitDataDTO,
      this.boardResultDataDTO,
      this.failureComponentDTO,
      this.testTimeDistributionDataDTO,
      this.worstTestNameDTO});
}

class DqmAnalogSigmaArguments {
  String? sigmaType;

  DqmAnalogSigmaArguments({this.sigmaType});
}

class DqmRmaArguments {
  AnomalyCompanyDataDTO? anomalyCompanyDataDTO;
  String? serialNumber;
  MeasurementAnomalyDataDTO? measurementDTO;
  LimitChangeAnomalyDataDTO? limitChangeDTO;
  FailureComponentDataDTO? failureDTO;
  MeasurementAnomalyDataDTO? nextMeasurementDTO;
  String? startTime;
  String? endTime;

  DqmRmaArguments(
      {this.anomalyCompanyDataDTO,
      this.serialNumber,
      this.measurementDTO,
      this.limitChangeDTO,
      this.failureDTO,
      this.nextMeasurementDTO,
      this.startTime,
      this.endTime});
}
