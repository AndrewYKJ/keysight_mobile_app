class Constants {
  static const bool isDebug = false;
  static const String ASSET_IMAGES = "assets/images/";
  static const String ASSET_IMAGES_LIGHT = "assets/imagesLightMode/";
  static const String ENGLISH = 'en';
  static const String CHINESE = "zh";

  static const String LANGUAGE_CODE_EN = "EN";
  static const String LANGUAGE_CODE_CN = "CN";

  static const String PLATFORM_ANDROID = "ANDROID";
  static const String PLATFORM_IOS = "IOS";

  static const bool IS_SUPPORT_GOOGLE = true;

  //Umeng Credential
  static const String UMENG_ANDROID_APP_KEY = "";
  static const String UMENG_IOS_APP_KEY = "";
  static const String UMENG_CHANNEL = "keysight";

  //Keycloak Login Credential
  //Staging
  static const String STG_DOMAIN = "";
  static const String STG_LOGIN_CLIENT_ID = "";
  static const String STG_LOGIN_CLIENT_SECRET = "";
  static const String STG_REDIRECT_URI = "";

  //Developement
  static const String DEV_DOMAIN = "";
  static const String DEV_CLIENT_ID = "";
  static const String DEV_LOGIN_CLIENT_SECRET = "";

  //PMA New Server (No need VPN)
  static const String PMA_DOMAIN = "";
  static const String PMA_CLIENT_ID = "";
  static const String PMA_LOGIN_CLIENT_SECRET = "";

  //Auth Basic Config
  static const String AUTH_ENDPOINT = "";
  static const String AUTH_TOKEN_ENDPOINT = "n";
  static const String AUTH_LOGOUT_ENDPOINT = "";
  static const String AUTH_DISCOVERY_URL = "";

  //Login Credential (Can change on here for dev/staging/production)
  static const String AUTH_CLIENT_ID = PMA_CLIENT_ID;
  static const String AUTH_CLIENT_SECRET = PMA_LOGIN_CLIENT_SECRET;
  static const String AUTH_REDIRECT_URI = STG_REDIRECT_URI;
  static const String AUTH_MAIN_DISCOVERY_URL =
      PMA_DOMAIN + "/" + AUTH_DISCOVERY_URL;

  //Home Menu Type
  static const String HOME_MENU_DQM = "HOME_DQM";
  static const String HOME_MENU_OEE = "HOME_OEE";
  static const String HOME_MENU_ALERT = "HOME_ALERT";

  //Preferred Days
  static const String PREFERRED_DAYS_TODAY = "today";
  static const String PREFERRED_DAYS_YESTERDAY = "yesterday";
  static const String PREFERRED_DAYS_WEEK = "week";
  static const String PREFERRED_DAYS_MONTH = "month";

  //Sort by Ascending / Descending
  static const String SORT_ASCENDING = "ascending";
  static const String SORT_DESCENDING = "descending";

  //Display Chart In Detail Screen by Unit Code
  static const String CHART_DQM_DAILY_VOLUME = "DQM_DV";
  static const String CHART_DQM_DAILY_FIRST_PASS_YIELD = "DQM_DFPY";
  static const String CHART_DQM_DAILY_FIRST_PASS_YIELD_PROJECT = "DQM_DFPY_P";
  static const String CHART_DQM_DASHBOARD_VOLUME_PROJECT = "DQM_V_P";
  static const String CHART_DQM_DASHBOARD_WORST_TESTNAME_PROJECT = "DQM_WTN_P";
  static const String CHART_OEE_DASHBOARD_DAILY_UTIL_ALL_EQUIPMENT =
      "OEE_D_UAE";
  static const String CHART_OEE_DASHBOARD_DAILY_VO_EQUIPMENT = "OEE_D_DVOE";
  static const String CHART_OEE_DASHBOARD_DAILY_VO_PROJECT = "OEE_D_DVOP";
  static const String CHART_OEE_DASHBOARD_DAILY_SCORE_EQUIPMENT = "OEE_D_DSE";
  static const String CHART_OEE_DASHBOARD_VO_EQUIPMENT = "OEE_D_VOE";
  static const String CHART_OEE_DASHBOARD_VO_PROJECT = "OEE_D_VOP";
  static const String CHART_OEE_DTM_SUMMARY = "OEE_DTM_SMMY";
  static const String CHART_OEE_DTM_DETAILBREAKDOWN = "OEE_DTM_DBD";
  //DQM Summary Range Code
  static const String RANGE_1_MONTH = "1M";
  static const String RANGE_3_MONTH = "3M";
  static const String RANGE_6_MONTH = "6M";
  static const String RANGE_YTD = "YTD";
  static const String RANGE_1_YEAR = "1Y";
  static const String RANGE_ALL = "ALL";

  //DQM Summary Type
  static const String SUMMARY_TYPE_FAILURE = "SUM_FAILURE";
  static const String SUMMARY_TYPE_FIRST_PASS = "SUM_FIRST_PASS";
  static const String SUMMARY_TYPE_YIELD = "SUM_YIELD";

  //DQM Summary Chart Sort/Filter By
  static const String SORT_BY_VOLUME = "VOLUME";
  static const String SORT_BY_PROJECT = "PROJECT";
  static const String SORT_BY_EQUIPMENT = "EQUIPMENT";
  static const String SORT_BY_TESTNAME = "TESTNAME";
  static const String FILTER_BY_EQUIPMENT = "FILTER_BY_EQUIPMENT";
  static const String FILTER_BY_TESTNAME = "FILTER_BY_TESTNAME";
  static const int FROM_DQMS_PROJECT = 2001;
  static const int FROM_DQMS_EQUIPMENT = 2002;

  //DQM Test Result From Which Chart
  static const int TEST_RESULT_CHART_VOLUME = 1001;
  static const int TEST_RESULT_CHART_TEST_TIME = 1002;
  static const int TEST_RESULT_CHART_FINAL_DISPOSITION = 1003;
  static const int TEST_RESULT_CHART_COMPONENT_FAILURE = 1004;

  //DQM Test Result Filter By
  static const String FILTER_BY_CHART_VOLUME_EQUIPMENT = "EQUIPMENT";
  static const String FILTER_BY_CHART_VOLUME_EQUIPMENT_FIXTURE =
      "EQUIPMENT_FIXTURE";
  static const String FILTER_BY_CHART_TEST_TIME_PASS = "TESTTIME_PASS";
  static const String FILTER_BY_CHART_TEST_TIME_FAIL = "TESTTIME_FAIL";
  static const String FILTER_BY_CHART_TEST_TYPE_FAIL = "TESTTYPE_FAIL";
  static const String FILTER_BY_CHART_TEST_TYPE_FIRST_FAIL =
      "TESTTYPE_FIRST_FAIL";
  static const String FILTER_BY_CHART_TEST_TYPE_FALSE_FAIL =
      "TESTTYPE_FALSE_FAIL";
  static const String FILTER_BY_CHART_PIN_RETEST = "PIN_RETEST";
  static const String FILTER_BY_CHART_WORST_TESTNAME_FAIL =
      "WORST_TESTNAME_FAIL";
  static const String FILTER_BY_CHART_WORST_TESTNAME_FIRST_FAIL =
      "WORST_TESTNAME_FIRST_FAIL";
  static const String FILTER_BY_CHART_WORST_TESTNAME_FALSE_FAIL =
      "WORST_TESTNAME_FALSE_FAIL";

  // DQM Test Result Failure Count by Test Type & Fixture ID Mode
  static const String MODE_FAIL = "fail";
  static const String MODE_FIRST_FAIL = "firstTryFail";
  static const String MODE_FALSE_FAIL = "falseFailure";

  //DQM Test Result Analog sort by
  static const int SORT_BY_INDICATOR = 1001;
  static const int SORT_BY_TYPE = 1002;
  static const int SORT_BY_TEST_NAME = 1003;
  static const int SORT_BY_CPK = 1004;
  static const int SORT_BY_NOMINAL = 1005;
  static const int SORT_BY_LOWER_LIMIT = 1006;
  static const int SORT_BY_UPPER_LIMIT = 1007;
  static const int SORT_BY_DESTINATION = 1008;
  static const int SORT_BY_MIN = 1009;
  static const int SORT_BY_MAX = 1010;
  static const int SORT_BY_DEVICE = 1011;
  static const int SORT_BY_PIN = 1012;
  static const int SORT_BY_SOURCE = 1013;

  //HistoryCase sort by
  static const int SORT_BY_ID = 1001;
  static const int SORT_BY_EQ = 1002;
  static const int SORT_BY_AssignedTo = 1003;
  static const int SORT_BY_STATUS = 1004;
  static const int SORT_BY_PRIORITY = 1005;
  static const int SORT_BY_WORKFLOW = 1006;
  static const int SORT_BY_SUBJECT = 1007;
  static const int SORT_BY_DESCRIPTION = 1008;
  static const int SORT_BY_MESSAGE = 1009;
  static const int SORT_BY_CREATEDBY = 1010;
  static const int SORT_BY_CREATEDON = 1011;
  static const int SORT_BY_MODIFIEDBY = 1012;
  static const int SORT_BY_MODIFIEDDATE = 1013;
  static const int SORT_BY_ALERTDATE = 1014;
  static const int SORT_BY_COMPANY = 1015;
  static const int SORT_BY_SITE = 1016;
  static const int SORT_BY_AVAILABLE = 1017;
  static const int SORT_BY_PERFORMANCE = 1018;
  static const int SORT_BY_QUALITY = 1019;
  static const int SORT_BY_OEE = 1020;

  //DQM Test Result Analog Sigma Filter
  static const String SIGMA_ALL = "ALL";
  static const String SIGMA_6 = "SIGMA_6";
  static const String SIGMA_5 = "SIGMA_5";
  static const String SIGMA_4 = "SIGMA_4";
  static const String SIGMA_3 = "SIGMA_3";

  //DQM RMA Filter Selection
  static const int RMA_SORT_BY_START_TIME = 1001;
  static const int RMA_SORT_BY_END_TIME = 1002;
  static const int RMA_SORT_BY_FIXTURE = 1003;
  static const int RMA_SORT_BY_EQUIPMENT = 1004;
  static const int RMA_SORT_BY_STATUS = 1005;

  //Alert Status
  static const String ALERT_HIGH = "High";
  static const String ALERT_MEDIUM = "Medium";
  static const String ALERT_LOW = "Low";

  //Alert Type
  static const String ALERT_TEST_COVERAGE_CHANGED = "TestCoverageChanged";
  static const String ALERT_PAT_LIMIT_RECOMMENDATION =
      "DUTPatLimitRecommendation";
  static const String ALERT_LIMIT_CHANGE_ANOMALY = "DUTLimitChangeAnomaly";
  static const String ALERT_CONSECUTIVE_TEST_FAILURE = "ConsecutiveTestFailure";
  static const String ALERT_COMPONENT_ANOMALY = "DUTComponentAnomaly";
  static const String ALERT_FIXTURE_MAINTENANCE = "FixtureMaintenance";
  static const String ALERT_DEGRADATION_ANOMALY = "DUTDegradationAnomaly";
  static const String ALERT_CPK_ALERT_ANOMALIES = "DUTCpkAlertAnomalies";
  static const String ALERT_PAT_LIMIT_ANOMALIES = "DUTPatLimitAnomalies";
  static const String ALERT_WIP_SCRAP_BOARD_ALERT = "WipScrapBoardAlert";

  //Alert Accuracy Status
  static const String ALERT_ACC_ACTUAL = "Actual";
  static const String ALERT_ACC_DISMISS = "Dismiss";
  static const String ALERT_ACC_DISPOSE = "Dispose";

  //Alert Sort By
  static const int ALERT_SORT_BY_TIMESTAMP = 3001;
  static const int ALERT_SORT_BY_ALERT_ID = 3002;
  static const int ALERT_SORT_BY_EQUIPMENT = 3003;
  static const int ALERT_SORT_BY_PROJECT = 3004;
  static const int ALERT_SORT_BY_SEVERITY = 3005;
  static const int ALERT_SORT_BY_SCORING = 3006;
  static const int ALERT_SORT_BY_STATUS = 3007;

  //Alert Create Case Selection
  static const int ASIGNED_TO = 1001;
  static const int PRIORITY = 1002;
  static const int WORKFLOw = 1003;
  static const int STATUS = 1004;

  //CPK Dashboard Push From
  static const int CPK_DASHBOARD_FROM_TESTRESULT_INFO = 4001;
  static const int CPK_DASHBOARD_FROM_ALERT_ANOMALY_DE = 4002;
  static const int CPK_DASHBOARD_FROM_PAT_CHART = 4003;
  static const int CPK_DASHBOARD_FROM_CASE_HISTORY_LIMITCHANGE = 4004;
  static const int CPK_DASHBOARD_FROM_DEGRATION_CHART_DETAIL = 4005;
  static const int CPK_DASHBOARD_FROM_TESTRESULT_COMPARE = 4006;
  static const int CPK_DASHBOARD_FROM_TESTRESULT_CORELATION = 4007;
  static const int CPK_DASHBOARD_FROM_TESTRESULT_FAILURE_COMPONENT = 4008;
  static const int CPK_DASHBOARD_FROM_TESTRESULT_SCATTER = 4009;
  static const int CPK_DASHBOARD_FROM_TESTRESULT_ANALOG = 4010;

  //Download Type
  static const String DOWNLOAD_AS_IMAGE = "DOWNLOAD_AS_IMAGE";
  static const String DOWNLOAD_AS_PDF = "DOWNLOAD_AS_PDF";
  static const String DOWNLOAD_AS_CSV = "DOWNLOAD_AS_CSV";

  //Test Result Compare By
  static const String COMPARE_BY_EQUIPMENT = "COMPARE_BY_EQUIPMENT";
  static const String COMPARE_BY_FIXTURE = "COMPARE_BY_FIXTURE";
  static const String COMPARE_BY_EQUIP_FIX = "COMPARE_BY_EQUIP_FIX";
  static const String COMPARE_BY_PANEL = "COMPARE_BY_PANEL";
  static const String COMPARE_BY_ALL_PANEL = "COMPARE_BY_ALL_PANEL";

  //Analytics
  static const String ANALYTICS_SPLASH_SCREEN = "SPLASH_SCREEN";
  static const String ANALYTICS_LOGIN_SCREEN = "LOGIN_SCREEN";
  static const String ANALYTICS_CUSTOM_SERVER_SCREEN = "CUSTOM_SERVER_SCREEN";
  static const String ANALYTICS_CUSTOM_SERVER_SELECTION_SCREEN =
      "CUSTOM_SERVER_SELECTION_SCREEN";
  static const String ANALYTICS_CUSTOM_SERVER_SUCCESS_SCREEN =
      "CUSTOM_SERVER_SUCCESS_SCREEN";
  static const String ANALYTICS_MAIN_SCREEN = "MAIN_SCREEN";
  static const String ANALYTICS_HOME_SCREEN = "HOME_SCREEN";
  static const String ANALYTICS_NOTIFICATION_SCREEN = "NOTIFICATION_SCREEN";
  static const String ANALYTICS_ADMIN_SCREEN = "ADMIN_SCREEN";
  static const String ANALYTICS_ABOUT_SCREEN = "ABOUT_SCREEN";
  static const String ANALYTICS_HELP_SCREEN = "HELP_SCREEN";
  static const String ANALYTICS_SEARCH_DASHBOARD = "SEARCH_SCREEN";
  static const String ANALYTICS_CPK_DASHBOARD = "CPK_DASHBOARD_SCREEN";
  static const String ANALYTICS_SORT_FILTER_SCREEN = "SORT_FILTER_SCREEN";
  static const String ANALYTICS_EQUIPMENT_LIST_SELECTION_SCREEN =
      "EQUIPMENT_LIST_SELECTION_SCREEN";
  static const String ANALYTICS_PROJECT_LIST_SELECTION_SCREEN =
      "PROJECT_LIST_SELECTION_SCREEN";
  static const String ANALYTICS_EQUIPMENT_LIST_SINGLE_SELECTION_SCREEN =
      "EQUIPMENT_LIST_SINGLE_SELECTION_SCREEN";

  //Analytic Digital Quality
  static const String ANALYTICS_DQM_DASHBOARD_SCREEN =
      "DIGITAL_QUALITY_DASHBOARD_SCREEN";
  static const String ANALYTICS_DQM_DASHBOARD_DETAIL_SCREEN =
      "DIGITAL_QUALITY_DASHBOARD_DETAIL_SCREEN";
  static const String ANALYTICS_DQM_RMA_SCREEN = "DIGITAL_QUALITY_RMA_SCREEN";
  static const String ANALYTICS_DQM_RMA_ANOMALIES_SCREEN =
      "DIGITAL_QUALITY_RMA_ANOMALIES_SCREEN";
  static const String ANALYTICS_DQM_RMA_MEASUREMENT_SCREEN =
      "DIGITAL_QUALITY_RMA_MEASUREMENT_SCREEN";
  static const String ANALYTICS_DQM_RMA_TESTRESULT_SCATTER_SCREEN =
      "DIGITAL_QUALITY_RMA_TESTRESULT_SCATTER_SCREEN";
  static const String ANALYTICS_DQM_RMA_TESTRESULT_CORELATION_SCREEN =
      "DIGITAL_QUALITY_RMA_TESTRESULT_CORELATION_SCREEN";
  static const String ANALYTICS_DQM_RMA_TESTRESULT_CHANGE_LIMIT_SCREEN =
      "DIGITAL_QUALITY_RMA_TESTRESULT_CHANGE_LIMIT_SCREEN";
  static const String ANALYTICS_DQM_RMA_TESTRESULT_FAILURE_COMP_SCREEN =
      "DIGITAL_QUALITY_RMA_TESTRESULT_FAILURE_COMPONENT_SCREEN";
  static const String ANALYTICS_DQM_RMA_QRCODE_SCANNER_SCREEN =
      "DIGITAL_QUALITY_RMA_QRCODE_SCANNER_SCREEN";
  static const String ANALYTICS_DQM_SUMMARY_SCREEN =
      "DIGITAL_QUALITY_SUMMARY_SCREEN";
  static const String ANALYTICS_DQM_SUMMARY_FILTER_SCREEN =
      "DIGITAL_QUALITY_SUMMARY_FILTER_SCREEN";
  static const String ANALYTICS_DQM_SUMMARY_DETAIL_SCREEN =
      "DIGITAL_QUALITY_SUMMARY_DETAIL_SCREEN";
  static const String ANALYTICS_DQM_SUMMARY_DETAIL_BY_EQUIPMENT_SCREEN =
      "DIGITAL_QUALITY_SUMMARY_DETAIL_BY_EQUIPMENT_SCREEN";
  static const String ANALYTICS_DQM_SUMMARY_DETAIL_BY_PROJECT_SCREEN =
      "DIGITAL_QUALITY_SUMMARY_DETAIL_BY_PROJECT_SCREEN";
  static const String ANALYTICS_DQM_TEST_RESULT_SCREEN =
      "DIGITAL_QUALITY_TEST_RESULT_SCREEN";
  static const String ANALYTICS_DQM_TEST_RESULT_INFO_SCREEN =
      "DIGITAL_QUALITY_TEST_RESULT_INFO_SCREEN";
  static const String ANALYTICS_DQM_TEST_RESULT_SUMMARY_SCREEN =
      "DIGITAL_QUALITY_TEST_RESULT_SUMMARY_SCREEN";
  static const String ANALYTICS_DQM_TEST_RESULT_ANALOG_SCREEN =
      "DIGITAL_QUALITY_TEST_RESULT_ANALOG_SCREEN";
  static const String ANALYTICS_DQM_TEST_RESULT_FUNCTIONAL_SCREEN =
      "DIGITAL_QUALITY_TEST_RESULT_FUNCTIONAL_SCREEN";
  static const String ANALYTICS_DQM_TEST_RESULT_PINS_SCREEN =
      "DIGITAL_QUALITY_TEST_RESULT_PINS_SCREEN";
  static const String ANALYTICS_DQM_TEST_RESULT_SHORTS_SCREEN =
      "DIGITAL_QUALITY_TEST_RESULT_SHORTS_SCREEN";
  static const String ANALYTICS_DQM_TEST_RESULT_VTEP_SCREEN =
      "DIGITAL_QUALITY_TEST_RESULT_VTEP_SCREEN";
  static const String ANALYTICS_DQM_TEST_RESULT_XVTEP_SCREEN =
      "DIGITAL_QUALITY_TEST_RESULT_XVTEP_SCREEN";
  static const String ANALYTICS_DQM_TEST_RESULT_PROBE_HEATMAP_SCREEN =
      "DIGITAL_QUALITY_TEST_RESULT_PROBE_HEATMAP_SCREEN";
  static const String ANALYTICS_DQM_TEST_RESULT_PROBE_HEATMAP_FILTER_SCREEN =
      "DIGITAL_QUALITY_TEST_RESULT_PROBE_HEATMAP_FILTER_SCREEN";
  static const String ANALYTICS_DQM_TEST_RESULT_WORST_TESTNAME_SCREEN =
      "DIGITAL_QUALITY_TEST_RESULT_WORST_TESTNAME_SCREEN";
  static const String ANALYTICS_DQM_TEST_RESULT_WORST_TESTNAME_FILTER_SCREEN =
      "DIGITAL_QUALITY_TEST_RESULT_WORST_TESTNAME_FILTER_SCREEN";
  static const String ANALYTICS_DQM_TEST_RESULT_CHART_DETAIL_SCREEN =
      "DIGITAL_QUALITY_TEST_RESULT_CHART_DETAIL_SCREEN";
  static const String ANALYTICS_DQM_TEST_RESULT_SIGMA_FILTER_SCREEN =
      "DIGITAL_QUALITY_TEST_RESULT_SIGMA_FILTER_SCREEN";
  static const String ANALYTICS_DQM_TEST_RESULT_FILTER_SCREEN =
      "DIGITAL_QUALITY_TEST_RESULT_FILTER_SCREEN";
  static const String ANALYTICS_DQM_TEST_RESULT_TESTTYPE_WORST_TESTNAME_SCREEN =
      "DIGITAL_QUALITY_TEST_RESULT_TEST_TYPE_WORST_TESTNAME_SCREEN";
  static const String ANALYTICS_DQM_TEST_RESULT_COMPARE_SCREEN =
      "DIGITAL_QUALITY_TEST_RESULT_COMPARE_SCREEN";
  static const String ANALYTICS_DQM_TEST_RESULT_COMPARE_FILTER_SCREEN =
      "DIGITAL_QUALITY_TEST_RESULT_COMPARE_FILTER_SCREEN";

  //Analytic OEE
  static const String ANALYTICS_OEE_SCREEN = "OEE_SCREEN";
  static const String ANALYTICS_OEE_DASHBOARD_SCREEN = "OEE_DASHBOARD_SCREEN";
  static const String ANALYTICS_OEE_DASHBOARD_CHART_DETAIL_SCREEN =
      "OEE_DASHBOARD_CHART_DETAIL_SCREEN";
  static const String ANALYTICS_OEE_DASHBOARD_FILTER_SCREEN =
      "OEE_DASHBOARD_FILTER_SCREEN";
  static const String ANALYTICS_OEE_DOWNTIME_MONITOR_SCREEN =
      "OEE_DOWNTIME_MONITORING_SCREEN";
  static const String ANALYTICS_OEE_DOWNTIME_MONITOR_CHART_DETAIL_SCREEN =
      "OEE_DOWNTIME_MONITORING_CHART_DETAIL_SCREEN";
  static const String ANALYTICS_OEE_DOWNTIME_MONITOR_FILTER_SCREEN =
      "OEE_DOWNTIME_MONITORING_FILTER_SCREEN";
  static const String ANALYTICS_OEE_SUMMARY_SCREEN = "OEE_SUMMARY_SCREEN";
  static const String ANALYTICS_OEE_SUMMARY_SITE_INFO_SCREEN =
      "OEE_SUMMARY_SITE_INFORMATION_SCREEN";
  static const String ANALYTICS_OEE_SUMMARY_DAILY_EQUIP_CHART_SCREEN =
      "OEE_SUMMARY_DAILY_EQUIPMENT_CHART_SCREEN";
  static const String ANALYTICS_OEE_SUMMARY_SITE_AVAILABILITY_SCREEN =
      "OEE_SUMMARY_SITE_AVAILABILITY_SCREEN";
  static const String ANALYTICS_OEE_SUMMARY_UTILIZATION_TIME_BY_EQUIP_SCREEN =
      "OEE_SUMMARY_UTILIZATION_TIME_BY_EQUIPMENT_SCREEN";
  static const String
      ANALYTICS_OEE_SUMMARY_AVAILABILITY_METRIC_BY_EQUIP_SCREEN =
      "OEE_SUMMARY_AVAILABILITY_METRIC_BY_EQUIPMENT_SCREEN";
  static const String ANALYTICS_OEE_SUMMARY_UTILIZATION_TIME_BY_PROJ_SCREEN =
      "OEE_SUMMARY_UTILIZATION_TIME_BY_PROJECT_SCREEN";

  //Analytics Alert
  static const String ANALYTICS_ALERT_SCREEN = "ALERT_SCREEN";
  static const String ANALYTICS_ALERT_REVIEW_SCREEN = "ALERT_REVIEW_SCREEN";
  static const String ANALYTICS_ALERT_CASE_HISTORY_SCREEN =
      "ALERT_CASE_HISTORY_SCREEN";
  static const String ANALYTICS_ALERT_REVIEW_FILTER_SCREEN =
      "ALERT_REVIEW_FILTER_SCREEN";
  static const String ANALYTICS_ALERT_REVIEW_PREFERRED_SCREEN =
      "ALERT_REVIEW_PREFERRED_SCREEN";
  static const String ANALYTICS_ALERT_REVIEW_STATISTICS_SCREEN =
      "ALERT_REVIEW_STATISTICS_SCREEN";
  static const String ANALYTICS_ALERT_REVIEW_ACCURACY_STATUS_SCREEN =
      "ALERT_REVIEW_ACCURACY_STATUS_SCREEN";
  static const String ANALYTICS_ALERT_REVIEW_SORT_FILTER_SCREEN =
      "ALERT_REVIEW_SORT_FILTER_SCREEN";
  static const String ANALYTICS_ALERT_PAT_ANOMALIY_SCREEN =
      "ALERT_REVIEW_PAT_ANOMALY_SCREEN";
  static const String ANALYTICS_ALERT_GIVE_COMMENT_SCREEN =
      "ALERT_CASE_HISTORY_GIVE_COMMENT_SCREEN";
  static const String
      ANALYTICS_ALERT_STATUS_PRIORITY_WORKFLOW_SELECTION_SCREEN =
      "ALERT_REVIEW_STATUS_PRIORITY_WORKFLOW_SELECTION_SCREEN";
  static const String ANALYTICS_ALERT_DISMISS_CASE_SCREEN =
      "ALERT_REVIEW_DISMISS_CASE_SCREEN";
  static const String ANALYTICS_ALERT_CREATE_EDIT_CASE_SCREEN =
      "ALERT_REVIEW_CREATE_EDIT_CASE_SCREEN";
  static const String ANALYTICS_ALERT_DISPOSE_CASE_SCREEN =
      "ALERT_REVIEW_DISPOSE_CASE_SCREEN";
  static const String ANALYTICS_ALERT_REVIEW_PREFERED_FILTER_SCREEN =
      "ALERT_REVIEW_PREFERED_FILTER_SCREEN";
  static const String ANALYTICS_ALERT_FILTER_SCREEN = "ALERT_FILTER_SCREEN";
  static const String ANALYTICS_ALERT_CPK_CHART_SCREEN =
      "ALERT_CPK_CHART_SCREEN";
  static const String ANALYTICS_ALERT_CPK_LIST_SCREEN = "ALERT_CPK_LIST_SCREEN";
  static const String ANALYTICS_ALERT_REVIEW_LIMIT_CHANGE_SCREEN =
      "ALERT_REVIEW_LIMIT_CHANGE_SCREEN";
  static const String ANALYTICS_ALERT_PROBE_FINDER_FILTER_SCREEN =
      "ALERT_REVIEW_PROBE_FINDER_FILTER_SCREEN";
  static const String ANALYTICS_ALERT_CONSECUTIVE_TEST_FAILURE_SCREEN =
      "ALERT_CONSECUTIVE_TEST_FAILURE_SCREEN";
  static const String ANALYTICS_ALERT_DEGRATION_ANOMALY_SCREEN =
      "ALERT_DEGRATION_ANOMALY_SCREEN";
  static const String ANALYTICS_ALERT_LIMIT_CHANGE_SCREEN =
      "ALERT_LIMIT_CHANGE_SCREEN";
  static const String ANALYTICS_ALERT_PAT_ANOMALIES_SCREEN =
      "ALERT_PAT_ANOMALIES_SCREEN";
  static const String ANALYTICS_ALERT_PAT_RECOMMENDATION_SCREEN =
      "ALERT_PAT_RECOMMENDATION_SCREEN";
  static const String ANALYTICS_ALERT_DEGRADATION_CHART_SCREEN =
      "ALERT_DEGRADATION_CHART_SCREEN";
  static const String ANALYTICS_ALERT_DETAIL_SCREEN = "ALERT_DETAIL_SCREEN";
  static const String ANALYTICS_ALERT_ANOMALY_DETECTION_SCREEN =
      "ALERT_ANOMALY_DETECTION_SCREEN";
  static const String ANALYTICS_ALERT_REVIEW_CPK_LIST_SCREEN =
      "ALERT_REVIEW_CPK_LIST_SCREEN";

  //Anality Admin
  static const String ANALYTICS_ADMIN_ACCOUNT_INFO_SCREEN =
      "ADMIN_ACCOUNT_INFO_SCREEN";
  static const String ANALYTICS_ADMIN_PREFERRED_SETTING_SCREEN =
      "ADMIN_PREFERRED_SETTING_SCREEN";
  static const String ANALYTICS_ADMIN_PREFERRED_DATE_SCREEN =
      "ADMIN_PREFERRED_DATE_SCREEN";
  static const String ANALYTICS_ADMIN_PREFERRED_LANG_SCREEN =
      "ADMIN_PREFERRED_LANGUAGE_SCREEN";
  static const String ANALYTICS_ADMIN_PREFERRED_COMP_SITE_SCREEN =
      "ADMIN_PREFERRED_COMPANY_SITE_SCREEN";
  static const String ANALYTICS_ADMIN_PREFERRED_PROJ_VER_SCREEN =
      "ADMIN_PREFERRED_PROJECT_VERSION_SCREEN";
  static const String ANALYTICS_ADMIN_PREFERRED_DAY_SELECTION_SCREEN =
      "ADMIN_PREFERRED_DAY_SELECTION_SCREEN";
  static const String ANALYTICS_ADMIN_ALERT_PREFERENCE_SCREEN =
      "ADMIN_ALERT_PREFERENCE_SCREEN";
  static const String ANALYTICS_ADMIN_ALERT_PREFERENCE_GROUP_INFO_SCREEN =
      "ADMIN_ALERT_PREFERENCE_GROUP_INFO_SCREEN";
  static const String
      ANALYTICS_ADMIN_ALERT_PREFERENCE_GROUP_ALERT_LIST_INFO_SCREEN =
      "ADMIN_ALERT_PREFERENCE_GROUP_ALERT_LIST_INFO_SCREEN";
  static const String
      ANALYTICS_ADMIN_ALERT_PREFERENCE_GROUP_USER_LIST_INFO_SCREEN =
      "ADMIN_ALERT_PREFERENCE_GROUP_USER_LIST_INFO_SCREEN";
  static const String
      ANALYTICS_ADMIN_ALERT_PREFERENCE_GROUP_PARAMETER_LIST_INFO_SCREEN =
      "ADMIN_ALERT_PREFERENCE_GROUP_PARAMETER_LIST_INFO_SCREEN";
}
