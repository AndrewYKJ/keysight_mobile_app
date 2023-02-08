import 'package:flutter/material.dart';
import 'package:keysight_pma/controller/about/about.dart';
import 'package:keysight_pma/controller/admin/account_info.dart';
import 'package:keysight_pma/controller/admin/alert_preference.dart';
import 'package:keysight_pma/controller/admin/alert_preference/group_UserList.dart';
import 'package:keysight_pma/controller/admin/alert_preference/group_alertList.dart';
import 'package:keysight_pma/controller/admin/alert_preference/group_details.dart';
import 'package:keysight_pma/controller/admin/alert_preference/group_parameterList.dart';
import 'package:keysight_pma/controller/admin/change_pwd.dart';
import 'package:keysight_pma/controller/admin/notification_setting.dart';
import 'package:keysight_pma/controller/admin/preferred_setting.dart';
import 'package:keysight_pma/controller/admin/preferred_setting/custom.dart';
import 'package:keysight_pma/controller/admin/preferred_setting/preferred_date.dart';
import 'package:keysight_pma/controller/admin/preferred_setting/preferred_language.dart';
import 'package:keysight_pma/controller/admin/preferred_setting/preferred_project.dart';
import 'package:keysight_pma/controller/admin/preferred_setting/preferred_site.dart';
import 'package:keysight_pma/controller/admin/preferred_setting/select_by_days.dart';
import 'package:keysight_pma/controller/alert/alertAccuracyStatusChart.dart';
import 'package:keysight_pma/controller/alert/alertAnnomalyDetectionChart.dart';
import 'package:keysight_pma/controller/alert/alertBase.dart';
import 'package:keysight_pma/controller/alert/alertCPKChart.dart';
import 'package:keysight_pma/controller/alert/alertCPKList.dart';
import 'package:keysight_pma/controller/alert/alertCaseHistoryList.dart';
import 'package:keysight_pma/controller/alert/alertReviewTab.dart';
import 'package:keysight_pma/controller/alert/alertStatisticsChart.dart';
import 'package:keysight_pma/controller/alert/alertTestResultChart.dart';
import 'package:keysight_pma/controller/alert/alert_AnnomalyDetails.dart';
import 'package:keysight_pma/controller/alert/alert_CPKDetails.dart';
import 'package:keysight_pma/controller/alert/alert_review_changelimit.dart';
import 'package:keysight_pma/controller/alert/alert_review_data_filter.dart';
import 'package:keysight_pma/controller/alert/caseHistoryDetailbySender/casehistory_consecutivetestfailure.dart';
import 'package:keysight_pma/controller/alert/caseHistoryDetailbySender/casehistory_degradationanomaly.dart';
import 'package:keysight_pma/controller/alert/caseHistoryDetailbySender/casehistory_limitchange.dart';
import 'package:keysight_pma/controller/alert/caseHistoryDetailbySender/casehistory_others.dart';
import 'package:keysight_pma/controller/alert/caseHistoryDetailbySender/casehistory_patRecommend.dart';
import 'package:keysight_pma/controller/alert/caseHistoryDetailbySender/casehistory_pat_anomalies.dart';
import 'package:keysight_pma/controller/alert/caseHistoryDetailbySender/degradationChartDetails.dart';
import 'package:keysight_pma/controller/alert/caseHistoryDetailbySender/probeFilter.dart';
import 'package:keysight_pma/controller/alert/dismiss_Case.dart';
import 'package:keysight_pma/controller/alert/dispose&create_Case.dart';
import 'package:keysight_pma/controller/alert/dispose&create_case_selection.dart';
import 'package:keysight_pma/controller/alert/edit_Case.dart';
import 'package:keysight_pma/controller/alert/edit_Comment.dart';
import 'package:keysight_pma/controller/alert/patChart.dart';
import 'package:keysight_pma/controller/alert/sort/alertSortFilter.dart';
import 'package:keysight_pma/controller/alert/sort/alert_filtering.dart';
import 'package:keysight_pma/controller/alert/sort/alert_prefered_sort_filter.dart';
import 'package:keysight_pma/controller/authentication/custom_server.dart';
import 'package:keysight_pma/controller/authentication/login.dart';
import 'package:keysight_pma/controller/authentication/server_created.dart';
import 'package:keysight_pma/controller/authentication/server_selection.dart';
import 'package:keysight_pma/controller/digital_quality/cpk_dashboard.dart';
import 'package:keysight_pma/controller/digital_quality/dashboard/dqm_dashboard_chart_detail.dart';
import 'package:keysight_pma/controller/digital_quality/dashboard/dqm_detail_sort_filter.dart';
import 'package:keysight_pma/controller/digital_quality/dashboard/dqm_detail_sort_filter_projects.dart';
import 'package:keysight_pma/controller/digital_quality/dqm_home.dart';
import 'package:keysight_pma/controller/digital_quality/dqm_testresult_compare_filter.dart';
import 'package:keysight_pma/controller/digital_quality/rma/dqm_rma_qrcode_scanner.dart';
import 'package:keysight_pma/controller/digital_quality/rma/dqm_rma_result_info.dart';
import 'package:keysight_pma/controller/digital_quality/rma/test_result.dart';
import 'package:keysight_pma/controller/digital_quality/rma/test_result_changelimit.dart';
import 'package:keysight_pma/controller/digital_quality/rma/test_result_failure_component.dart';
import 'package:keysight_pma/controller/digital_quality/summary/dqm_qm_sort_filter.dart';
import 'package:keysight_pma/controller/digital_quality/summary/dqm_quality_metric_detail.dart';
import 'package:keysight_pma/controller/digital_quality/summary/dqm_quality_metric_viewby_equipment.dart';
import 'package:keysight_pma/controller/digital_quality/summary/dqm_quality_metric_viewby_project.dart';
import 'package:keysight_pma/controller/digital_quality/test_result/dqm_testresult_analog_detail.dart';
import 'package:keysight_pma/controller/digital_quality/test_result/dqm_testresult_analog_info_filter.dart';
import 'package:keysight_pma/controller/digital_quality/dqm_testresult_compare.dart';
import 'package:keysight_pma/controller/digital_quality/test_result/dqm_testresult_cpk_filter.dart';
import 'package:keysight_pma/controller/digital_quality/test_result/dqm_testresult_detail.dart';
import 'package:keysight_pma/controller/digital_quality/test_result/dqm_testresult_detail_sort_filter.dart';
import 'package:keysight_pma/controller/digital_quality/test_result/dqm_testresult_detail_worst_testname.dart';
import 'package:keysight_pma/controller/digital_quality/test_result/dqm_testresult_info.dart';
import 'package:keysight_pma/controller/digital_quality/test_result/dqm_testresult_probe_finder.dart';
import 'package:keysight_pma/controller/digital_quality/test_result/dqm_testresult_probe_finder_filter.dart';
import 'package:keysight_pma/controller/digital_quality/test_result/dqm_testresult_testtype_worst_testname.dart';
import 'package:keysight_pma/controller/help/help.dart';
import 'package:keysight_pma/controller/home.dart';
import 'package:keysight_pma/controller/oee/dashboard/oee_dashboard_chartdetails.dart';
import 'package:keysight_pma/controller/oee/dashboard/oee_dashboard_sortandfilter.dart';
import 'package:keysight_pma/controller/oee/dashboard/oee_dashboardscreen.dart';
import 'package:keysight_pma/controller/oee/downtime_monitoring/oee_dtm_sortandfilter.dart';
import 'package:keysight_pma/controller/oee/downtime_monitoring/oee_dtmscreen.dart';
import 'package:keysight_pma/controller/oee/oee_home.dart';
import 'package:keysight_pma/controller/oee/summary/oee_availabiltyChart.dart';
import 'package:keysight_pma/controller/oee/summary/oee_dailyChart.dart';
import 'package:keysight_pma/controller/oee/summary/oee_site_all_metric.dart';
import 'package:keysight_pma/controller/oee/summary/oee_site_metric_byequipment.dart';
import 'package:keysight_pma/controller/oee/summary/oee_site_metric_byprojectdetail.dart';
import 'package:keysight_pma/controller/oee/summary/oee_site_metric_detail.dart';
import 'package:keysight_pma/controller/oee/summary/oee_summaryscreen.dart';
import 'package:keysight_pma/controller/sort_filter/equipment_list_selection.dart';
import 'package:keysight_pma/controller/sort_filter/project_list_selection.dart';
import 'package:keysight_pma/controller/sort_filter/sort_and_filter.dart';
import 'package:keysight_pma/controller/sort_filter/specific_equipment_selection.dart';
import 'package:keysight_pma/controller/splash_screen.dart';
import 'package:keysight_pma/controller/tab/homebase.dart';
import 'package:keysight_pma/model/alert/alert_casehistory.dart';
import 'package:keysight_pma/model/alertPreferencemodel.dart';
import 'package:keysight_pma/model/arguments/alert_routeTitle.dart';
import 'package:keysight_pma/model/arguments/dqm_argument.dart';
import 'package:keysight_pma/model/arguments/search_argument.dart';
import 'package:keysight_pma/model/arguments/sort_filter_argument.dart';
import 'package:keysight_pma/model/updateUserPrefModel.dart';
import 'package:keysight_pma/model/user.dart';
import 'package:keysight_pma/controller/search/search_page.dart';

import '../model/arguments/oee_argument.dart';

class AppRoutes {
  //others
  static const String splashScreenRoute = "splash_screen";
  static const String aboutScreenRoute = "aboutScreenRoute";
  static const String helpScreenRoute = "helpScreenRoute";
  static const String searchRoute = 'search_screen';
  //base
  static const String homebaseroute = "home_base";
  //Authendication
  static const String loginScreenRoute = "login_screen";
  static const String serverSelectionRoute = 'server_selection';
  static const String customServerRoute = 'create_custom_server';
  static const String serverCreatedRoute = 'server_created';
  //Home
  static const String homeScreenRoute = "home_screen";
  //Admin
  static const String account_info = "account_info";
  static const String alert_preference = 'alert_preference';
  static const String change_pwd = 'change_pwd';
  static const String notification_setting = 'notification_setting';
  static const String preferred_setting = 'preferred_setting';
  static const String group_details = 'group_details';
  static const String groupAlertList = 'groupAlertList';
  static const String groupUserList = 'groupUserList';
  static const String groupParameterList = 'groupParameterList';

  //PreferredSetting
  static const String preferred_project = 'preferred_project';
  static const String preferred_date = 'preferred_date';
  static const String preferred_language = 'preferred_language';
  static const String preferred_site = 'preferred_site';
  static const String select_days = 'select_days';

  //Overall Equipment Effectiveness
  static const String oeeHomeBase = 'oeeHomeBase';
  static const String oeeDashboardScreen = 'oeeDashboardScreen';
  static const String oeeSummaryScreen = 'oeeSummaryScreen';
  static const String oeeDowntimeScreen = 'oeeDowntimeScreen';
  static const String oeeDashboardChartDetailRoute =
      'oeeDashboardChartDetailRoute';
  static const String oeeSummaryAvailabiltyChart = 'oeeSummaryAvailabiltyChart';
  static const String oeeSummarySiteAvailabiltyMetric =
      'oeeSummarySiteAvailabiltyMetric';
  static const String oeeSummarySiteQualityMetric =
      'oeeSummarySiteQualityMetric';
  static const String oeeSummarySitePerformanceMetric =
      'oeeSummarySitePerformanceMetric';
  static const String oeeSummaryDailyChart = 'oeeSummaryDailyChart';
  static const String oeeAvailablilityDetailPage = "oeeAvailabilityDetailPage";
  static const String oeeQualityDetailPage = "oeeQualityDetailPage";
  static const String oeePerformanceDetailPage = "oeePerformanceDetailPage";
  static const String oeeChartDetail = 'oeeChartDetail';
  static const String oeeDtmSortAndFilter = 'oeeDtmSortAndFilter';
  static const String oeeDashboardSortAndFilter = 'oeeDashboardSortAndFilter';
  static const String oeeSummarySiteMetricDetail = 'oeeSummarySiteMetricDetail';
  static const String oeeSummarySiteMetricbyEquipment =
      'oeeSummarySiteMetricbyEquipment';
  static const String oeeSummarySiteMetricbyProject =
      'oeeSummarySiteMetricbyProject';
  //Digital Quality
  static const String dqmScreenRoute = "dqm_screen";
  static const String dqmRmaQrcodeScanRoute = "dqm_qrcode_scan_screen";
  static const String dqmRmaResultInfoRoute = "dqm_rma_result_info_screen";
  static const String dqmRmaTestResultRoute = "dqm_rma_test_result_screen";
  static const String dqmCpkDashboardRoute = "dqm_cpk_dashboard_screen";
  static const String dqmRmaTestResultChangeLimitRoute =
      "dqm_rma_testresult_change_limit_screen";
  static const String dqmRmaTestResultFailureRoute =
      "dqm_rma_testresult_failure_screen";
  static const String dqmDashboardChartDetailRoute =
      "dqm_dashboard_chart_detail_screen";
  static const String dqmDashboardDetailSortFilterRoute =
      "dqm_dashboard_detail_sort_filter_screen";
  static const String dqmDashboardDetailSortFilterProjectsRoute =
      "dqm_dashboard_detail_sort_filter_projects_screen";
  static const String dqmSummaryQualityMetricDetailRoute =
      "dqm_sum_qm_detail_screen";
  static const String dqmSummaryQualityMetricSortFilterRoute =
      "dqm_sum_qm_sort_filter_screen";
  static const String dqmSummaryQualityMetricByProjectRoute =
      "dqm_sum_qm_project_screen";
  static const String dqmSummaryQualityMetricByEquipmentRoute =
      "dqm_sum_qm_equipment_screen";
  static const String dqmTestResultProbeFinderRoute =
      "dqm_testresult_probe_finder_screen";
  static const String dqmTestResultProbeFinderFilterRoute =
      "dqm_testresult_probe_finder_filter_screen";
  static const String dqmTestResultAnalogInfoFilterRoute =
      "dqm_testresult_analog_info_filter_screen";
  static const String dqmTestResultAnalogCpkFilterRoute =
      "dqm_testresult_analog_cpk_filter_screen";
  static const String dqmTestResultAnalogInfoDetailRoute =
      "dqm_testresult_analog_info_detail_screen";
  static const String dqmTestResultChartDetailRoute =
      "dqm_testresult_chart_detail_screen";
  static const String dqmTestResultChartDetailFilterRoute =
      "dqm_testresult_chart_detail_filter_screen";
  static const String dqmTestResultChartDetailWTNRoute =
      "dqm_testresult_chart_detail_wtn_screen";
  static const String dqmTestResultChartDetailWTNByTestTypeRoute =
      "dqm_testresult_chart_detail_wtn_bytesttype_screen";
  static const String dqmTestResultInfoRoute = "dqm_testresult_info_screen";
  static const String dqmTestResultCompareRoute =
      "dqm_testresult_compare_screen";
  static const String dqmTestResultCompareFilterRoute =
      "dqm_testresult_compare_filter_screen";

  //Sort And Filter
  static const String sortAndFilterRoute = "sort_filter_screen";
  static const String sortAndFilterProjectRoute = "sort_filter_project_screen";
  static const String sortAndFilterEquipmentRoute =
      "sort_filter_equipment_screen";
  static const String sortAndFilterSingleEquipmentRoute =
      "sort_filter_single_equipment_screen";

  //Alert/Notification
  static const String alertAnomalyInfo = "alert_Anomaly_info_screen";
  static const String alertBase = "alertBase";
  static const String alertReview = "alertReview";
  static const String alertCaseHistroyList = "alertCaseHistroyList";
  static const String disposeORcreateCase = "disposeORcreateCase";
  static const String dismissCase = "dismissCase";
  static const String editCase = "editCase";
  static const String editComment = "editComment";
  static const String alertCPKDetails = "alertCPKDetails";
  static const String patCharts = 'patCharts';
  static const String degradationCharts = 'degradationCharts';
  static const String probeNodeDetailScreen = 'probeNodeDetailScreen';
  static const String casehistoryPatRecommend = 'casehistoryPatRecommend';
  static const String casehistoryLimitChangeAnomaly =
      'casehistoryLimitChangeAnomaly';
  static const String casehistoryConsecutiveTestFailure =
      'casehistoryConsecutiveTestFailure';

  static const String casehistoryOthers = 'casehistoryOthers';

  static const String casehistoryDegradationAnomaly =
      'casehistoryDegradationAnomaly';
  static const String alertTestResult = "alertTetResult";
  static const String alertCPKList = "alertCPKList";
  static const String alertStatisticsChart = 'alertStatisticsChart';
  static const String alertCPKChart = 'alertCPKChart';
  static const String alertADChart = 'alertADChart';
  static const String alertSort = 'alertSort';
  static const String alertReviewDataFilterRoute = "alert_review_filter_screen";
  static const String alertAccuracyStatusRoute = "alert_accuracy_status_screen";
  static const String alertFilterRoute = "alert_filter_screen";
  static const String alertCreateCaseSelectionRoute =
      "alert_create_case_selection_screen";
  static const String alertPreferedSortFilterRoute =
      "alert_prefered_sort_filter_screen";
  static const String alertReviewChangeLimitRoute =
      "alert_review_change_limit_screen";
  static const String alertPatAnomaliesRoute = "alert_pat_anomalies_screen";

  static Route<dynamic> generatedRoute(RouteSettings settings) {
    switch (settings.name) {
      //others
      case splashScreenRoute:
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case aboutScreenRoute:
        return MaterialPageRoute(builder: (_) => AboutPage());
      case helpScreenRoute:
        return MaterialPageRoute(builder: (_) => HelpPage());

      case searchRoute:
        SearchArguments arguments = settings.arguments as SearchArguments;
        return MaterialPageRoute(
            builder: (_) => SearchPage(
                  projectList: arguments.projectList,
                  equipmentList: arguments.equipMentList,
                  customSFProjectList: arguments.customSFProjectList,
                  analogList: arguments.analogList,
                  pinList: arguments.pinsList,
                  shortsList: arguments.shortsList,
                  vtepList: arguments.vtepList,
                  xVtepList: arguments.xVtepList,
                  functionalList: arguments.functionalList,
                  rmaAnomalyList: arguments.rmaAnomalyInfoList,
                  alertInfoList: arguments.alertInfoList,
                  preferedASList: arguments.preferedASList,
                  caseHistoryList: arguments.caseHistoryList,
                  notificationList: arguments.notificationList,
                  customerMapData: arguments.customerMapData,
                  groupList: arguments.groupList,
                  siteProjectListDataDTO: arguments.siteProjectListDataDTO,
                ));

      //alert/notification
      case alertSort:
        SortFilterArguments arguments =
            settings.arguments as SortFilterArguments;
        return MaterialPageRoute(
          builder: (_) => AlertSortAndFilterScreen(
            menuType: arguments.menuType,
            currentTab: arguments.currentTab,
          ),
        );
      case alertBase:
        return MaterialPageRoute(builder: (_) => AlertBase());
      case alertAnomalyInfo:
        AlertArguments arguments = settings.arguments as AlertArguments;
        return MaterialPageRoute(
            builder: (_) => AlertAnnomalyDetails(
                  alertListDataDTO: arguments.alertListDataDTO,
                  alertStatisticsDataDTO: arguments.alertStatisticsDataDTO,
                  notificationData: arguments.notificationListData,
                  alertType: arguments.alertType,
                ));
      case oeeDashboardScreen:
      case alertReview:
        return MaterialPageRoute(builder: (_) => AlertReview());
      case alertCaseHistroyList:
        return MaterialPageRoute(builder: (_) => AlertCaseHistoryList());
      case disposeORcreateCase:
        AlertArguments arguments = settings.arguments as AlertArguments;
        return MaterialPageRoute(
            builder: (_) => DisposeCreateCase(
                  alertRowKeys: arguments.alertRowKeys,
                  bulkAlertList: arguments.bulkAlertList,
                  bulkAlertActualList: arguments.bulkAlertActualList,
                ));
      case dismissCase:
        AlertArguments arguments = settings.arguments as AlertArguments;
        return MaterialPageRoute(
            builder: (_) => DismissCase(
                  alertRowKeys: arguments.alertRowKeys,
                  bulkAlertList: arguments.bulkAlertList,
                  bulkAlertActualList: arguments.bulkAlertActualList,
                ));
      case editCase:
        AlertOpenCaseDTO arguments = settings.arguments as AlertOpenCaseDTO;
        return MaterialPageRoute(builder: (_) => EditCase(data: arguments));
      case editComment:
        String arguments = settings.arguments as String;
        return MaterialPageRoute(
            builder: (_) => EditComment(
                  alertRowKey: arguments,
                ));
      case alertCPKDetails:
        AlertArguments arguments = settings.arguments as AlertArguments;
        return MaterialPageRoute(
            builder: (_) => AlertCPKDetails(
                title: arguments.appBarTitle!,
                data: arguments.caseHistoryData!));
      case alertTestResult:
        return MaterialPageRoute(builder: (_) => AlertTestResult());
      case alertCPKList:
        AlertArguments arguments = settings.arguments as AlertArguments;
        return MaterialPageRoute(
            builder: (_) => AlertCPKList(
                  alertListDataDTO: arguments.alertListDataDTO,
                  alertStatisticsDataDTO: arguments.alertStatisticsDataDTO,
                ));
      case alertStatisticsChart:
        AlertArguments arguments = settings.arguments as AlertArguments;
        return MaterialPageRoute(
            builder: (_) => AlertStatisticChart(
                  alertStatisticList: arguments.alertStatisticList,
                  preferedAlertList: arguments.preferedAlertList,
                ));
      case alertAccuracyStatusRoute:
        AlertArguments arguments = settings.arguments as AlertArguments;
        return MaterialPageRoute(
            builder: (_) => AlertAccuracyStatusScreen(
                  alertAccuracyStatusList: arguments.alertAccuracyList,
                  preferedAlertList: arguments.preferedAlertList,
                ));
      case alertCPKChart:
        AlertArguments arguments = settings.arguments as AlertArguments;
        return MaterialPageRoute(
            builder: (_) => CPKChart(
                  appBarTitle: arguments.appBarTitle!,
                  alertCpkDataDTO: arguments.alertCpkDataDTO,
                ));
      case alertADChart:
        AlertArguments arguments = settings.arguments as AlertArguments;
        return MaterialPageRoute(
            builder: (_) => AnomalyDectectionChart(
                  fixtureMaintenanceDataDTO:
                      arguments.fixtureMaintenanceDataDTO,
                  testName: arguments.testName,
                ));
      case alertReviewDataFilterRoute:
        AlertFilterArguments arguments =
            settings.arguments as AlertFilterArguments;
        return MaterialPageRoute(
            builder: (_) => AlertReviewDataInfoFilterScreen(
                  filterAlertTypeList: arguments.filterAlertTypeList,
                  filterAlertStatusList: arguments.filterAlertStatusList,
                  filterAlertPriority: arguments.filterAlertPriorityList,
                  filterProbePropertyList: arguments.filterProbePropertyList,
                  filterAlertWorkflow: arguments.filterAlertWorkflowList,
                  fromWhere: arguments.fromWhere,
                ));
      case alertFilterRoute:
        AlertArguments arguments = settings.arguments as AlertArguments;
        return MaterialPageRoute(
            builder: (_) => AlertFilterScreen(
                  filterTestTypeList: arguments.filterItemSelectionList,
                ));
      case alertCreateCaseSelectionRoute:
        AlertArguments arguments = settings.arguments as AlertArguments;
        return MaterialPageRoute(
            builder: (_) => DisposeCreateCaseSelectionScreen(
                  selectionType: arguments.createCaseSelectionType,
                  assigneeDataDTO: arguments.assigneeDataDTO,
                  priority: arguments.priority,
                  workflow: arguments.workflow,
                  status: arguments.status,
                ));
      case alertPreferedSortFilterRoute:
        AlertArguments arguments = settings.arguments as AlertArguments;
        return MaterialPageRoute(
            builder: (_) => AlertPreferedSortFilterScreen(
                  alertGroupDTO: arguments.alertGroupDTO,
                  pickedGroupId: arguments.pickedGroupId,
                ));
      case alertReviewChangeLimitRoute:
        AlertArguments arguments = settings.arguments as AlertArguments;
        return MaterialPageRoute(
            builder: (_) => AlertReviewChangeLimitScreen(
                  alertListDataDTO: arguments.alertListDataDTO,
                  alertStatisticsDataDTO: arguments.alertStatisticsDataDTO,
                ));
      case casehistoryPatRecommend:
        AlertArguments arguments = settings.arguments as AlertArguments;
        return MaterialPageRoute(
            builder: (_) => CaseHistoryPATRecommend(
                  title: arguments.appBarTitle!,
                  data: arguments.caseHistoryData,
                  alertListDataDTO: arguments.alertListDataDTO,
                  notificationData: arguments.notificationListData,
                ));
      case casehistoryConsecutiveTestFailure:
        AlertArguments arguments = settings.arguments as AlertArguments;
        return MaterialPageRoute(
            builder: (_) => CaseHistoryConsecutiveTestFailure(
                title: arguments.appBarTitle!,
                data: arguments.caseHistoryData!));
      case casehistoryLimitChangeAnomaly:
        AlertArguments arguments = settings.arguments as AlertArguments;
        return MaterialPageRoute(
            builder: (_) => CaseHistoryLimitChange(
                title: arguments.appBarTitle!,
                data: arguments.caseHistoryData!));
      case casehistoryOthers:
        AlertArguments arguments = settings.arguments as AlertArguments;
        return MaterialPageRoute(
            builder: (_) => CaseHistoryOthers(
                title: arguments.appBarTitle!,
                data: arguments.caseHistoryData!));
      case casehistoryDegradationAnomaly:
        AlertArguments arguments = settings.arguments as AlertArguments;
        return MaterialPageRoute(
            builder: (_) => CaseHistoryDegradationAnomaly(
                title: arguments.appBarTitle!,
                data: arguments.caseHistoryData!));
      case patCharts:
        AlertArguments arguments = settings.arguments as AlertArguments;
        return MaterialPageRoute(
            builder: (_) => PATCharts(
                  selectedPatData: arguments.patData,
                  alertPatAnomaliesDataDTO: arguments.alertPatAnomaliesDataDTO,
                ));
      case degradationCharts:
        AlertArguments arguments = settings.arguments as AlertArguments;
        return MaterialPageRoute(
            builder: (_) => DegradationAnomalyCharts(
                  timestamp: arguments.timestamp!,
                  fixtureId: arguments.fixtureId!,
                  testName: arguments.testName!,
                  equipmentId: arguments.equipmentId!,
                  projectId: arguments.projectId!,
                  siteId: arguments.siteId!,
                  companyId: arguments.companyId!,
                ));
      case probeNodeDetailScreen:
        AlertArguments arguments = settings.arguments as AlertArguments;
        return MaterialPageRoute(
            builder: (_) => ProbeNodeDetailScreen(
                nodeData: arguments.probeNodeData,
                companyId: arguments.companyId,
                siteId: arguments.siteId,
                projectId: arguments.projectId));
      case alertPatAnomaliesRoute:
        AlertArguments arguments = settings.arguments as AlertArguments;
        return MaterialPageRoute(
          builder: (_) => CaseHistoryPatAnomalies(
            alertCaseHistoryDataDTO: arguments.caseHistoryData,
          ),
        );
      //homebase
      case homebaseroute:
        return MaterialPageRoute(builder: (_) => HomeBase());

      //admin
      case account_info:
        return MaterialPageRoute(builder: (_) => AccountInfo());
      case alert_preference:
        UserDTO arguments = settings.arguments as UserDTO;
        return MaterialPageRoute(
            builder: (_) => AlertPreference(
                  user_info: arguments.data,
                ));
      case change_pwd:
        return MaterialPageRoute(builder: (_) => Change_pwd());
      case notification_setting:
        UserDTO arguments = settings.arguments as UserDTO;
        return MaterialPageRoute(
            builder: (_) => NotificationSettings(
                  user_info: arguments.data,
                ));

      case preferred_setting:
        UserDTO arguments = settings.arguments as UserDTO;
        return MaterialPageRoute(
            builder: (_) => PreferredSettings(
                  user_info: arguments.data,
                ));
      case group_details:
        AlertPreferenceGroupDataDTO arguments =
            settings.arguments as AlertPreferenceGroupDataDTO;
        return MaterialPageRoute(
            builder: (_) => GroupPage(groupDetailsData: arguments));
      case groupAlertList:
        AlertPreferenceGroupDataDTO arguments =
            settings.arguments as AlertPreferenceGroupDataDTO;
        return MaterialPageRoute(
            builder: (_) => GroupAlertList(
                  alertPrefAlertList: arguments.alertPrefAlertList,
                ));
      case groupUserList:
        AlertPreferenceGroupDataDTO arguments =
            settings.arguments as AlertPreferenceGroupDataDTO;
        return MaterialPageRoute(
            builder: (_) => GroupUserList(
                  groupUsers: arguments.groupUsers,
                ));
      case groupParameterList:
        AlertPreferenceGroupDataDTO arguments =
            settings.arguments as AlertPreferenceGroupDataDTO;
        return MaterialPageRoute(
            builder: (_) => GroupParameterList(
                  alertInfo: arguments.groupParametersDisplay,
                ));
      //preferred setting
      case preferred_date:
        String arguments = settings.arguments as String;
        return MaterialPageRoute(
            builder: (_) => PreferredDate(
                  preferred_date: arguments,
                ));
      case preferred_language:
        String arguments = settings.arguments as String;
        return MaterialPageRoute(
            builder: (_) => PreferredLanguagePage(
                  language: arguments,
                ));
      case preferred_project:
        UpdateLoadProject? agruments = settings.arguments as UpdateLoadProject?;
        return MaterialPageRoute(
            builder: (_) => PreferredProject(
                  projectList: agruments,
                ));
      case preferred_site:
        PDate arguments = settings.arguments as PDate;
        return MaterialPageRoute(
            builder: (_) => PreferredSite(
                  preferredSite: arguments.rangeValue!,
                  preferredCompany: arguments.rangeName!,
                ));
      case select_days:
        return MaterialPageRoute(builder: (_) => SelectByDays());

      //Authentication route
      case serverCreatedRoute:
        return MaterialPageRoute(builder: (_) => ServerCreated());
      case serverSelectionRoute:
        return MaterialPageRoute(builder: (_) => ServerSelection());
      case customServerRoute:
        return MaterialPageRoute(builder: (_) => CustomServer());
      case loginScreenRoute:
        return MaterialPageRoute(builder: (_) => LoginScreen());

      //home tab
      case homeScreenRoute:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case dqmScreenRoute:
        DqmChartDetailArguments arguments = DqmChartDetailArguments();
        return MaterialPageRoute(
            builder: (_) => DigitalQualityHomeScreen(
                  currentTab: arguments.currentTab,
                ));

      //Overall Equipment Effectiveness
      case oeeHomeBase:
        OeeChartDetailArguments arguments =
            settings.arguments as OeeChartDetailArguments;
        return MaterialPageRoute(
            builder: (_) => OeeBase(
                  currentTab: arguments.currentTab!,
                ));
      case oeeDashboardScreen:
        return MaterialPageRoute(builder: (_) => OeeDashboardScreen());
      case oeeSummaryScreen:
        return MaterialPageRoute(builder: (_) => OeeSummaryScreen());
      case oeeDowntimeScreen:
        return MaterialPageRoute(builder: (_) => OeeDtmScreen());
      case oeeDashboardChartDetailRoute:
        OeeChartDetailArguments arguments =
            settings.arguments as OeeChartDetailArguments;
        return MaterialPageRoute(
            builder: (_) => OEEDashboardChartDetails(
                  chartName: arguments.chartName!,
                  dataType: arguments.dataType!,
                  oeeAvailabilityDTO: arguments.availableDTO,
                  oeeEquipmentDTO: arguments.equipmentDTO,
                  summaryUtilAndNonUtilData:
                      arguments.summaryUtilAndNonUtilData,
                  detailBreakdownData: arguments.detailBreakdownData,
                ));
      case oeeSummaryAvailabiltyChart:
        OeeChartDetailArguments arguments =
            settings.arguments as OeeChartDetailArguments;
        return MaterialPageRoute(
            builder: (_) => OEEAvailabiltyChart(
                selectedCompany: arguments.selectedCompany!,
                selectedSite: arguments.selectedSite!));
      case oeeSummaryDailyChart:
        OeeChartDetailArguments arguments =
            settings.arguments as OeeChartDetailArguments;
        return MaterialPageRoute(
            builder: (_) => OEEDailyChart(
                chartName: arguments.chartName!,
                selectedCompany: arguments.selectedCompany!,
                selectedSite: arguments.selectedSite!,
                selectedEquipment: arguments.selectedEquipment!));
      case oeeSummarySiteAvailabiltyMetric:
        OeeChartDetailArguments arguments =
            settings.arguments as OeeChartDetailArguments;
        return MaterialPageRoute(
            builder: (_) => OEESiteAvailabiltyMetric(
                  currentTab: arguments.currentTab!,
                  selectedCompany: arguments.selectedCompany!,
                  selectedSite: arguments.selectedSite!,
                ));
      //                 static const String oeeSummarySiteMetricDetail = 'oeeSummarySiteMetricDetail';
      case oeeSummarySiteMetricDetail:
        OeeChartDetailArguments arguments =
            settings.arguments as OeeChartDetailArguments;
        return MaterialPageRoute(
            builder: (_) => OeeMetricDetailScreen(
                currentTab: arguments.currentTab!,
                selectedCompany: arguments.selectedCompany!,
                selectedSite: arguments.selectedSite!,
                appBarTitle: arguments.chartName!,
                dataType: arguments.dataType!));
      // static const String oeeSummarySiteMetricbyEquipment =
      //     'oeeSummarySiteMetricbyEquipment';
      case oeeSummarySiteMetricbyEquipment:
        OeeChartDetailArguments arguments =
            settings.arguments as OeeChartDetailArguments;
        return MaterialPageRoute(
            builder: (_) => OEESiteMetricByEquipment(
                currentTab: arguments.currentTab!,
                selectedCompany: arguments.selectedCompany!,
                selectedSite: arguments.selectedSite!,
                selectedEquipment: arguments.selectedEquipment!));
      // static const String oeeSummarySiteMetricbyProject =
      //     'oeeSummarySiteMetricbyProject';
      case oeeSummarySiteMetricbyProject:
        OeeChartDetailArguments arguments =
            settings.arguments as OeeChartDetailArguments;
        return MaterialPageRoute(
            builder: (_) => OeeMetricDetailByProjectScreen(
                currentTab: arguments.currentTab!,
                selectedCompany: arguments.selectedCompany!,
                selectedEquipment: arguments.selectedEquipment!,
                selectedSite: arguments.selectedSite!,
                appBarTitle: arguments.chartName!,
                dataType: arguments.dataType!));

      case oeeDtmSortAndFilter:
        return MaterialPageRoute(builder: (_) => DTMSortAndFilterScreen());
      case oeeDashboardSortAndFilter:
        OeeChartDetailArguments arguments =
            settings.arguments as OeeChartDetailArguments;
        return MaterialPageRoute(
            builder: (_) => OeeDashboardSortAndFilterScreen(
                  dataType: arguments.dataType!,
                  equipmentDTO: arguments.equipmentDTO,
                  selectedEquipmentList: arguments.selectedEquipmentList,
                ));
      // case oeeSummarySiteQualityMetric:
      //   return MaterialPageRoute(builder: (_) => OEESiteQualityMetric());
      // case oeeSummarySitePerformanceMetric:
      //   return MaterialPageRoute(builder: (_) => OEESitePerformanceMetric());

      //Digital Quality Dashborard
      case dqmDashboardChartDetailRoute:
        DqmChartDetailArguments arguments =
            settings.arguments as DqmChartDetailArguments;
        return MaterialPageRoute(
            builder: (_) => DigitalQualityDashboardChartDetailScreen(
                  chartName: arguments.chartName!,
                  dailyBoardVolumeDTO: arguments.dailyBoardVolumeDTO,
                  yieldBySiteDTO: arguments.yieldBySiteDTO,
                  volumeByProjectDTO: arguments.volumeByProjectDTO,
                  worstTestByProjectDTO: arguments.worstTestByProjectDTO,
                  dataType: arguments.dataType,
                ));
      case dqmDashboardDetailSortFilterRoute:
        DqmSortFilterArguments arguments =
            settings.arguments as DqmSortFilterArguments;
        return MaterialPageRoute(
          builder: (_) => DqmDetailSortAndFilterScreen(
            projectIdList: arguments.projectIdList,
          ),
        );
      case dqmDashboardDetailSortFilterProjectsRoute:
        DqmSortFilterArguments arguments =
            settings.arguments as DqmSortFilterArguments;
        return MaterialPageRoute(
          builder: (_) => DqmDetailSortAndFilterProjectsScreen(
            projectIdList: arguments.projectIdList,
          ),
        );

      //Digital Quality Summary
      case dqmSummaryQualityMetricDetailRoute:
        DqmSummaryQmArguments arguments =
            settings.arguments as DqmSummaryQmArguments;
        return MaterialPageRoute(
          builder: (_) => DqmQualityMetricDetailScreen(
            appBarTitle: arguments.appBarTitle,
            sumType: arguments.sumType,
          ),
        );
      case dqmSummaryQualityMetricSortFilterRoute:
        DqmSortFilterArguments arguments =
            settings.arguments as DqmSortFilterArguments;
        return MaterialPageRoute(
          builder: (_) => DqmQualityMetricSortAndFilterScreen(
            sortBy: arguments.sortBy,
            projectIdList: arguments.projectIdList,
            filterBy: arguments.filterBy,
            fromWhere: arguments.fromWhere,
            sumType: arguments.sumType,
          ),
        );
      case dqmSummaryQualityMetricByProjectRoute:
        DqmSummaryQmArguments arguments =
            settings.arguments as DqmSummaryQmArguments;
        return MaterialPageRoute(
          builder: (_) => DqmQualityMetricViewByProjectScreen(
            dataDTO: arguments.dataDTO,
            sumType: arguments.sumType,
          ),
        );
      case dqmSummaryQualityMetricByEquipmentRoute:
        DqmSummaryQmArguments arguments =
            settings.arguments as DqmSummaryQmArguments;
        return MaterialPageRoute(
          builder: (_) => DqmQualityMetricViewByEquipmentScreen(
            dataDTO: arguments.dataDTO,
            sumType: arguments.sumType,
          ),
        );

      //Digital Quality Test Result
      case dqmTestResultProbeFinderRoute:
        return MaterialPageRoute(
            builder: (_) => DigitalQualityTestResultProbeFinderScreen());
      case dqmTestResultProbeFinderFilterRoute:
        AlertFilterArguments arguments =
            settings.arguments as AlertFilterArguments;
        return MaterialPageRoute(
            builder: (_) => DqmTestResultProbeFinderFilterScreen(
                filterType: arguments.filterType,
                fixturesList: arguments.fixtureList));

      case dqmTestResultAnalogInfoFilterRoute:
        DqmTestResultArguments arguments =
            settings.arguments as DqmTestResultArguments;
        return MaterialPageRoute(
            builder: (_) => DqmTestResultAnalogInfoFilterScreen(
                  filterTestTypeList: arguments.itemSelectionList,
                ));
      case dqmTestResultAnalogCpkFilterRoute:
        DqmAnalogSigmaArguments arguments =
            settings.arguments as DqmAnalogSigmaArguments;
        return MaterialPageRoute(
            builder: (_) => DqmTestResultCpkFilterScreen(
                  sigmaType: arguments.sigmaType,
                ));
      case dqmTestResultAnalogInfoDetailRoute:
        DqmTestResultArguments arguments =
            settings.arguments as DqmTestResultArguments;
        return MaterialPageRoute(
            builder: (_) => DqmTestResultAnalogDetailScreen(
                  analogDataDTO: arguments.analogDataDTO,
                  pinDataDTO: arguments.pinsDataDTO,
                  shortDataDTO: arguments.shortsDataDTO,
                  vtepDataDTO: arguments.vtepDataDTO,
                  funcDataDTO: arguments.funcDataDTO,
                  xvtepDataDTO: arguments.xvtepDataDTO,
                ));
      case dqmTestResultChartDetailRoute:
        DqmTestResultArguments arguments =
            settings.arguments as DqmTestResultArguments;
        return MaterialPageRoute(
            builder: (_) => DqmTestResultDetailScreen(
                  fromWhere: arguments.fromWhere,
                  appbarTitle: arguments.appBarTitle,
                ));
      case dqmTestResultChartDetailFilterRoute:
        DqmTestResultArguments arguments =
            settings.arguments as DqmTestResultArguments;
        return MaterialPageRoute(
            builder: (_) => DqmTestResultDetailSortAndFilterScreen(
                  fromWhere: arguments.fromWhere,
                  filterBy: arguments.filterBy,
                  finalDispositionList: arguments.finalDispositionList,
                  mode: arguments.mode,
                ));
      case dqmTestResultChartDetailWTNRoute:
        DqmTestResultArguments arguments =
            settings.arguments as DqmTestResultArguments;
        return MaterialPageRoute(
            builder: (_) => DqmTestResultDetailWorstTestNameScreen(
                  fromWhere: arguments.fromWhere,
                  appBarTitle: arguments.appBarTitle,
                  filterMode: arguments.mode,
                  filterBy: arguments.filterBy,
                ));
      case dqmTestResultChartDetailWTNByTestTypeRoute:
        DqmTestResultArguments arguments =
            settings.arguments as DqmTestResultArguments;
        return MaterialPageRoute(
            builder: (_) => DqmTestResultDetailTestTypeWorstTestNameScreen(
                  fixtureId: arguments.fixtureId,
                  testType: arguments.testType,
                  mode: arguments.mode,
                ));
      case dqmTestResultInfoRoute:
        DqmTestResultArguments arguments =
            settings.arguments as DqmTestResultArguments;
        return MaterialPageRoute(
            builder: (_) => DqmTestResultInfoScreen(
                  testName: arguments.testname,
                  testType: arguments.testType,
                  projectId: arguments.projectId,
                ));
      case dqmTestResultCompareRoute:
        DqmTestResultArguments arguments =
            settings.arguments as DqmTestResultArguments;
        return MaterialPageRoute(
          builder: (_) => DqmTestResultCompareScreen(
            analogDataDTO: arguments.analogDataDTO,
            pinDataDTO: arguments.pinsDataDTO,
            shortDataDTO: arguments.shortsDataDTO,
            vtepDataDTO: arguments.vtepDataDTO,
            funcDataDTO: arguments.funcDataDTO,
            xvtepDataDTO: arguments.xvtepDataDTO,
            compareBy: arguments.compareBy,
            measurementDTO: arguments.measurementDTO,
          ),
        );
      case dqmTestResultCompareFilterRoute:
        DqmTestResultArguments arguments =
            settings.arguments as DqmTestResultArguments;
        return MaterialPageRoute(
            builder: (_) => DqmTestResultCompareFilterScreen(
                  filterTestResultList: arguments.compareList,
                  compareBy: arguments.compareBy,
                ));

      //Digital Quality RMA
      case dqmRmaQrcodeScanRoute:
        return MaterialPageRoute(
            builder: (_) => DigitalQualityRmaQrCodeScanScreen());
      case dqmRmaResultInfoRoute:
        DqmRmaArguments arguments = settings.arguments as DqmRmaArguments;
        return MaterialPageRoute(
            builder: (_) => DqmRmaResultInfoScreen(
                  anomalyCompanyDataDTO: arguments.anomalyCompanyDataDTO,
                ));
      case dqmRmaTestResultRoute:
        DqmRmaArguments arguments = settings.arguments as DqmRmaArguments;
        return MaterialPageRoute(
            builder: (_) => DqmRmaTestResultScreen(
                  measurementDTO: arguments.measurementDTO,
                  nextMeasurementDTO: arguments.nextMeasurementDTO,
                ));
      case dqmRmaTestResultChangeLimitRoute:
        DqmRmaArguments arguments = settings.arguments as DqmRmaArguments;
        return MaterialPageRoute(
            builder: (_) => TestResultChangeLimitScreen(
                  limitChangeDTO: arguments.limitChangeDTO,
                  serialNumber: arguments.serialNumber,
                ));
      case dqmRmaTestResultFailureRoute:
        DqmRmaArguments arguments = settings.arguments as DqmRmaArguments;
        return MaterialPageRoute(
            builder: (_) => TestResultFailureComponentScreen(
                  failureComponentDTO: arguments.failureDTO,
                  startTime: arguments.startTime,
                  endTime: arguments.endTime,
                  serialNumber: arguments.serialNumber,
                ));

      //Dqm Cpk Dashboard
      case dqmCpkDashboardRoute:
        DqmTestResultArguments arguments =
            settings.arguments as DqmTestResultArguments;
        return MaterialPageRoute(
          builder: (_) => CpkDashboardScreen(
            fixtureId: arguments.fixtureId,
            pushFrom: arguments.fromWhere,
            equipmentId: arguments.equipmentId,
            fixtureDataDTO: arguments.fixtureDataDTO,
            analogCpkData: arguments.analogDataDTO,
            testNameDataDTO: arguments.testNameDataDTO,
            projectId: arguments.projectId,
            from: arguments.startDate,
            to: arguments.endDate,
            compareBy: arguments.compareBy,
            compareTestResultDataDTO: arguments.compareTestResultDataDTO,
            changeLimitDTO: arguments.testResultChangeLimitDataDTO,
          ),
        );

      //Sort And Filter
      case sortAndFilterRoute:
        SortFilterArguments arguments =
            settings.arguments as SortFilterArguments;
        return MaterialPageRoute(
          builder: (_) => SortAndFilterScreen(
            menuType: arguments.menuType,
            currentTab: arguments.currentTab,
          ),
        );
      case sortAndFilterProjectRoute:
        return MaterialPageRoute(
            builder: (_) => SortAndFilterProjectListScreen());
      case sortAndFilterEquipmentRoute:
        return MaterialPageRoute(
            builder: (_) => SortAndFilterEquipmentListScreen());

      case sortAndFilterSingleEquipmentRoute:
        return MaterialPageRoute(
            builder: (_) => SortAndFilterSingleEquipmentScreen());
      default:
        return MaterialPageRoute(builder: (_) => LoginScreen());
    }
  }
}
