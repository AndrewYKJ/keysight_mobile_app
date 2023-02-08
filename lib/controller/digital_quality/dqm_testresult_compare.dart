import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:keysight_pma/cache/appcache.dart';
import 'package:keysight_pma/const/appcolors.dart';
import 'package:keysight_pma/const/appfonts.dart';
import 'package:keysight_pma/const/constants.dart';
import 'package:keysight_pma/const/download.dart';
import 'package:keysight_pma/const/utils.dart';
import 'package:keysight_pma/dio/api/dqm.dart';
import 'package:keysight_pma/model/arguments/dqm_argument.dart';
import 'package:keysight_pma/model/customize.dart';
import 'package:keysight_pma/model/dqm/anomalies.dart';
import 'package:keysight_pma/model/dqm/test_result.dart';
import 'package:keysight_pma/model/dqm/test_result_cpk.dart';
import 'package:keysight_pma/model/dqm/test_result_cpk_analog.dart';
import 'package:keysight_pma/model/dqm/test_result_cpk_pins.dart';
import 'package:keysight_pma/model/dqm/test_result_fixtures.dart';
import 'package:keysight_pma/model/js/js.dart';
import 'package:keysight_pma/routes/approutes.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

class DqmTestResultCompareScreen extends StatefulWidget {
  final TestResultCpkAnalogDataDTO? analogDataDTO;
  final TestResultCpkPinsShortsTestJetDataDTO? pinDataDTO;
  final TestResultCpkPinsShortsTestJetDataDTO? shortDataDTO;
  final TestResultCpkPinsShortsTestJetDataDTO? vtepDataDTO;
  final TestResultCpkPinsShortsTestJetDataDTO? funcDataDTO;
  final TestResultCpkPinsShortsTestJetDataDTO? xvtepDataDTO;
  final MeasurementAnomalyDataDTO? measurementDTO;
  final String? compareBy;
  DqmTestResultCompareScreen(
      {Key? key,
      this.analogDataDTO,
      this.pinDataDTO,
      this.shortDataDTO,
      this.vtepDataDTO,
      this.funcDataDTO,
      this.xvtepDataDTO,
      this.measurementDTO,
      this.compareBy})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DqmTestResultCompareScreen();
  }
}

class _DqmTestResultCompareScreen extends State<DqmTestResultCompareScreen> {
  late TestResultFixtureDTO testResultFixtureDTO;
  late TestResultCpkDTO cpkDTO;
  late TestResultCpkAnalogDTO cpkAnalogDTO;
  bool isLoading = true;
  late WebViewPlusController dqmWebViewController;
  double chartHeight = 316.0;
  Map<String?, List<dynamic>> dataMap = {};
  List<CustomDqmSortFilterItemSelectionDTO> defTestResultForList = [];
  List<String> firstTestResultForList = [];
  List<String> secondTestResultForList = [];
  List<TestResultDataDTO> testResultDataList = [];
  int index = 0;
  String selectedResult = '';
  String mTestname = '';
  bool? theme_dark = AppCache.sortFilterCacheDTO!.currentTheme;

  Future<Response> getCompareByEquipment(BuildContext context) {
    String companyId = AppCache.sortFilterCacheDTO!.preferredCompany!;
    String siteId = AppCache.sortFilterCacheDTO!.preferredSite!;
    String startDate = DateFormat("yyyy-MM-dd")
        .format(AppCache.sortFilterCacheDTO!.startDate!);
    String endDate =
        DateFormat("yyyy-MM-dd").format(AppCache.sortFilterCacheDTO!.endDate!);
    List<String?> equipments = AppCache.sortFilterCacheDTO!.defaultEquipments!
        .where((element) => element.isSelected == true)
        .map((e) => e.equipmentId)
        .toList();
    String projectId = AppCache.sortFilterCacheDTO!.defaultProjectId!;
    String testname = '';
    if (widget.analogDataDTO != null) {
      testname = widget.analogDataDTO!.testName!;
    } else if (widget.pinDataDTO != null) {
      testname = widget.pinDataDTO!.testName!;
    } else if (widget.shortDataDTO != null) {
      testname = widget.shortDataDTO!.testName!;
    } else if (widget.vtepDataDTO != null) {
      testname = widget.vtepDataDTO!.testName!;
    } else if (widget.funcDataDTO != null) {
      testname = widget.funcDataDTO!.testName!;
    } else if (widget.xvtepDataDTO != null) {
      testname = widget.xvtepDataDTO!.testName!;
    } else if (widget.measurementDTO != null) {
      testname = widget.measurementDTO!.testName!;
    }
    DqmApi dqmApi = DqmApi(context);
    return dqmApi.getCompareByEquipment(companyId, siteId, projectId, startDate,
        endDate, testname, testname, equipments);
  }

  Future<Response> getCompareByFixture(BuildContext context) {
    String companyId = AppCache.sortFilterCacheDTO!.preferredCompany!;
    String siteId = AppCache.sortFilterCacheDTO!.preferredSite!;
    String startDate = DateFormat("yyyy-MM-dd")
        .format(AppCache.sortFilterCacheDTO!.startDate!);
    String endDate =
        DateFormat("yyyy-MM-dd").format(AppCache.sortFilterCacheDTO!.endDate!);
    List<String?> equipments = AppCache.sortFilterCacheDTO!.defaultEquipments!
        .where((element) => element.isSelected == true)
        .map((e) => e.equipmentId)
        .toList();
    String projectId = AppCache.sortFilterCacheDTO!.defaultProjectId!;
    String testname = '';
    if (widget.analogDataDTO != null) {
      testname = widget.analogDataDTO!.testName!;
    } else if (widget.pinDataDTO != null) {
      testname = widget.pinDataDTO!.testName!;
    } else if (widget.shortDataDTO != null) {
      testname = widget.shortDataDTO!.testName!;
    } else if (widget.vtepDataDTO != null) {
      testname = widget.vtepDataDTO!.testName!;
    } else if (widget.funcDataDTO != null) {
      testname = widget.funcDataDTO!.testName!;
    } else if (widget.xvtepDataDTO != null) {
      testname = widget.xvtepDataDTO!.testName!;
    } else if (widget.measurementDTO != null) {
      testname = widget.measurementDTO!.testName!;
    }
    DqmApi dqmApi = DqmApi(context);
    return dqmApi.getCompareByFixture(companyId, siteId, projectId, startDate,
        endDate, testname, testname, equipments);
  }

  Future<Response> getCompareByEquipmentFixture(BuildContext context) {
    String companyId = AppCache.sortFilterCacheDTO!.preferredCompany!;
    String siteId = AppCache.sortFilterCacheDTO!.preferredSite!;
    String startDate = DateFormat("yyyy-MM-dd")
        .format(AppCache.sortFilterCacheDTO!.startDate!);
    String endDate =
        DateFormat("yyyy-MM-dd").format(AppCache.sortFilterCacheDTO!.endDate!);
    List<String?> equipments = AppCache.sortFilterCacheDTO!.defaultEquipments!
        .where((element) => element.isSelected == true)
        .map((e) => e.equipmentId)
        .toList();
    String projectId = AppCache.sortFilterCacheDTO!.defaultProjectId!;
    String testname = '';
    if (widget.analogDataDTO != null) {
      testname = widget.analogDataDTO!.testName!;
    } else if (widget.pinDataDTO != null) {
      testname = widget.pinDataDTO!.testName!;
    } else if (widget.shortDataDTO != null) {
      testname = widget.shortDataDTO!.testName!;
    } else if (widget.vtepDataDTO != null) {
      testname = widget.vtepDataDTO!.testName!;
    } else if (widget.funcDataDTO != null) {
      testname = widget.funcDataDTO!.testName!;
    } else if (widget.xvtepDataDTO != null) {
      testname = widget.xvtepDataDTO!.testName!;
    } else if (widget.measurementDTO != null) {
      testname = widget.measurementDTO!.testName!;
    }
    DqmApi dqmApi = DqmApi(context);
    return dqmApi.getCompareByEquipmentFixture(companyId, siteId, projectId,
        startDate, endDate, testname, testname, equipments);
  }

  Future<Response> getCompareByPanel(BuildContext context) {
    String companyId = AppCache.sortFilterCacheDTO!.preferredCompany!;
    String siteId = AppCache.sortFilterCacheDTO!.preferredSite!;
    String startDate = DateFormat("yyyy-MM-dd")
        .format(AppCache.sortFilterCacheDTO!.startDate!);
    String endDate =
        DateFormat("yyyy-MM-dd").format(AppCache.sortFilterCacheDTO!.endDate!);
    List<String?> equipments = AppCache.sortFilterCacheDTO!.defaultEquipments!
        .where((element) => element.isSelected == true)
        .map((e) => e.equipmentId)
        .toList();
    String projectId = AppCache.sortFilterCacheDTO!.defaultProjectId!;
    String testname = '';
    String testNameSuffix = '';
    if (widget.analogDataDTO != null) {
      testname = widget.analogDataDTO!.testName!;
      testNameSuffix = widget.analogDataDTO!.testName!
          .substring(0, testname.indexOf("%") + 1);
    } else if (widget.pinDataDTO != null) {
      testname = widget.pinDataDTO!.testName!;
      testNameSuffix = widget.analogDataDTO!.testName!
          .substring(0, testname.indexOf("%") + 1);
    } else if (widget.shortDataDTO != null) {
      testname = widget.shortDataDTO!.testName!;
      testNameSuffix = widget.analogDataDTO!.testName!
          .substring(0, testname.indexOf("%") + 1);
    } else if (widget.vtepDataDTO != null) {
      testname = widget.vtepDataDTO!.testName!;
      testNameSuffix = widget.analogDataDTO!.testName!
          .substring(0, testname.indexOf("%") + 1);
    } else if (widget.funcDataDTO != null) {
      testname = widget.funcDataDTO!.testName!;
      testNameSuffix = widget.analogDataDTO!.testName!
          .substring(0, testname.indexOf("%") + 1);
    } else if (widget.xvtepDataDTO != null) {
      testname = widget.xvtepDataDTO!.testName!;
      testNameSuffix = widget.analogDataDTO!.testName!
          .substring(0, testname.indexOf("%") + 1);
    } else if (widget.measurementDTO != null) {
      testname = widget.measurementDTO!.testName!;
      testNameSuffix = widget.analogDataDTO!.testName!
          .substring(0, testname.indexOf("%") + 1);
    }
    DqmApi dqmApi = DqmApi(context);
    return dqmApi.getCompareByPanel(companyId, siteId, projectId, startDate,
        endDate, testname, testNameSuffix, equipments);
  }

  Future<TestResultDTO> getCompareByPanelCombined(BuildContext context) {
    String companyId = AppCache.sortFilterCacheDTO!.preferredCompany!;
    String siteId = AppCache.sortFilterCacheDTO!.preferredSite!;
    String startDate = DateFormat("yyyy-MM-dd")
        .format(AppCache.sortFilterCacheDTO!.startDate!);
    String endDate =
        DateFormat("yyyy-MM-dd").format(AppCache.sortFilterCacheDTO!.endDate!);
    List<String?> equipments = AppCache.sortFilterCacheDTO!.defaultEquipments!
        .where((element) => element.isSelected == true)
        .map((e) => e.equipmentId)
        .toList();
    String projectId = AppCache.sortFilterCacheDTO!.defaultProjectId!;
    String testname = '';
    String testNameSuffix = '';
    if (widget.analogDataDTO != null) {
      testname = widget.analogDataDTO!.testName!;
      testNameSuffix = widget.analogDataDTO!.testName!
          .substring(0, testname.indexOf("%") + 1);
    } else if (widget.pinDataDTO != null) {
      testname = widget.pinDataDTO!.testName!;
      testNameSuffix = widget.analogDataDTO!.testName!
          .substring(0, testname.indexOf("%") + 1);
    } else if (widget.shortDataDTO != null) {
      testname = widget.shortDataDTO!.testName!;
      testNameSuffix = widget.analogDataDTO!.testName!
          .substring(0, testname.indexOf("%") + 1);
    } else if (widget.vtepDataDTO != null) {
      testname = widget.vtepDataDTO!.testName!;
      testNameSuffix = widget.analogDataDTO!.testName!
          .substring(0, testname.indexOf("%") + 1);
    } else if (widget.funcDataDTO != null) {
      testname = widget.funcDataDTO!.testName!;
      testNameSuffix = widget.analogDataDTO!.testName!
          .substring(0, testname.indexOf("%") + 1);
    } else if (widget.xvtepDataDTO != null) {
      testname = widget.xvtepDataDTO!.testName!;
      testNameSuffix = widget.analogDataDTO!.testName!
          .substring(0, testname.indexOf("%") + 1);
    } else if (widget.measurementDTO != null) {
      testname = widget.measurementDTO!.testName!;
      testNameSuffix = widget.analogDataDTO!.testName!
          .substring(0, testname.indexOf("%") + 1);
    }
    DqmApi dqmApi = DqmApi(context);
    return dqmApi.getCompareByPanelCombined(companyId, siteId, projectId,
        startDate, endDate, testname, testNameSuffix, equipments);
  }

  @override
  void initState() {
    super.initState();
    Utils.setFirebaseAnalyticsCurrentScreen(
        Constants.ANALYTICS_DQM_TEST_RESULT_COMPARE_SCREEN);
    if (widget.analogDataDTO != null) {
      mTestname = widget.analogDataDTO!.testName!;
    } else if (widget.pinDataDTO != null) {
      mTestname = widget.pinDataDTO!.testName!;
    } else if (widget.shortDataDTO != null) {
      mTestname = widget.shortDataDTO!.testName!;
    } else if (widget.vtepDataDTO != null) {
      mTestname = widget.vtepDataDTO!.testName!;
    } else if (widget.funcDataDTO != null) {
      mTestname = widget.funcDataDTO!.testName!;
    } else if (widget.xvtepDataDTO != null) {
      mTestname = widget.xvtepDataDTO!.testName!;
    } else if (widget.measurementDTO != null) {
      mTestname = widget.measurementDTO!.testName!;
    }

    if (widget.compareBy == Constants.COMPARE_BY_EQUIPMENT) {
      callGetCompareByEquipment(context);
    } else if (widget.compareBy == Constants.COMPARE_BY_FIXTURE) {
      callGetCompareByFixture(context);
    } else if (widget.compareBy == Constants.COMPARE_BY_EQUIP_FIX) {
      callGetCompareByEquipmentFixture(context);
    } else if (widget.compareBy == Constants.COMPARE_BY_PANEL) {
      callGetCompareByPanel(context);
    } else if (widget.compareBy == Constants.COMPARE_BY_ALL_PANEL) {
      callGetCompareByPanelCombined(context);
    }
  }

  callGetCompareByEquipment(BuildContext context) async {
    await getCompareByEquipment(context).then((value) {
      if (value.data['status']['statusCode'] == 200) {
        if (value.data['data'] != null && value.data['data']['data'] != null) {
          if (value.data['data']['data'].length > 10) {
            value.data['data']['data'].forEach((key, value) {
              if (index % 2 == 0) {
                firstTestResultForList.add(key);
              } else {
                secondTestResultForList.add(key);
              }
              defTestResultForList
                  .add(CustomDqmSortFilterItemSelectionDTO(key, true));
              dataMap[key] = value;
              index++;
            });
          } else {
            value.data['data']['data'].forEach((key, value) {
              defTestResultForList
                  .add(CustomDqmSortFilterItemSelectionDTO(key, true));
              firstTestResultForList.add(key);
              dataMap[key] = value;
            });
          }

          selectedResult = firstTestResultForList[0];
          testResultDataList = dataMap[selectedResult]!
              .map((e) => TestResultDataDTO.fromJson(e))
              .toList();
        }
      } else {
        if (Utils.isNotEmpty(value.data['errorMessage'])) {
          Utils.showAlertDialog(
              context,
              Utils.getTranslated(context, 'general_alert_error_title')!,
              value.data['errorMessage']);
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
        this.isLoading = false;
      });
    });
  }

  callGetCompareByFixture(BuildContext context) async {
    await getCompareByFixture(context).then((value) {
      if (value.data['status']['statusCode'] == 200) {
        if (value.data['data'] != null && value.data['data']['data'] != null) {
          if (value.data['data']['data'].length > 10) {
            value.data['data']['data'].forEach((key, value) {
              if (index % 2 == 0) {
                firstTestResultForList.add(key);
              } else {
                secondTestResultForList.add(key);
              }
              defTestResultForList
                  .add(CustomDqmSortFilterItemSelectionDTO(key, true));
              dataMap[key] = value;
              index++;
            });
          } else {
            value.data['data']['data'].forEach((key, value) {
              defTestResultForList
                  .add(CustomDqmSortFilterItemSelectionDTO(key, true));
              firstTestResultForList.add(key);
              dataMap[key] = value;
            });
          }

          selectedResult = firstTestResultForList[0];
          testResultDataList = dataMap[selectedResult]!
              .map((e) => TestResultDataDTO.fromJson(e))
              .toList();
        }
      } else {
        if (Utils.isNotEmpty(value.data['errorMessage'])) {
          Utils.showAlertDialog(
              context,
              Utils.getTranslated(context, 'general_alert_error_title')!,
              value.data['errorMessage']);
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
        this.isLoading = false;
      });
    });
  }

  callGetCompareByEquipmentFixture(BuildContext context) async {
    await getCompareByEquipmentFixture(context).then((value) {
      if (value.data['status']['statusCode'] == 200) {
        if (value.data['data'] != null && value.data['data']['data'] != null) {
          if (value.data['data']['data'].length > 10) {
            value.data['data']['data'].forEach((key, value) {
              if (index % 2 == 0) {
                firstTestResultForList.add(key);
              } else {
                secondTestResultForList.add(key);
              }
              defTestResultForList
                  .add(CustomDqmSortFilterItemSelectionDTO(key, true));
              dataMap[key] = value;
              index++;
            });
          } else {
            value.data['data']['data'].forEach((key, value) {
              defTestResultForList
                  .add(CustomDqmSortFilterItemSelectionDTO(key, true));
              firstTestResultForList.add(key);
              dataMap[key] = value;
            });
          }

          selectedResult = firstTestResultForList[0];
          testResultDataList = dataMap[selectedResult]!
              .map((e) => TestResultDataDTO.fromJson(e))
              .toList();
        }
      } else {
        if (Utils.isNotEmpty(value.data['errorMessage'])) {
          Utils.showAlertDialog(
              context,
              Utils.getTranslated(context, 'general_alert_error_title')!,
              value.data['errorMessage']);
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
        this.isLoading = false;
      });
    });
  }

  callGetCompareByPanel(BuildContext context) async {
    await getCompareByPanel(context).then((value) {
      if (value.data['status']['statusCode'] == 200) {
        if (value.data['data'] != null && value.data['data']['data'] != null) {
          if (value.data['data']['data'].length > 10) {
            value.data['data']['data'].forEach((key, value) {
              if (index % 2 == 0) {
                firstTestResultForList.add(key);
              } else {
                secondTestResultForList.add(key);
              }
              defTestResultForList
                  .add(CustomDqmSortFilterItemSelectionDTO(key, true));
              dataMap[key] = value;
              index++;
            });
          } else {
            value.data['data']['data'].forEach((key, value) {
              defTestResultForList
                  .add(CustomDqmSortFilterItemSelectionDTO(key, true));
              firstTestResultForList.add(key);
              dataMap[key] = value;
            });
          }

          selectedResult = firstTestResultForList[0];
          testResultDataList = dataMap[selectedResult]!
              .map((e) => TestResultDataDTO.fromJson(e))
              .toList();
        }
      } else {
        if (Utils.isNotEmpty(value.data['errorMessage'])) {
          Utils.showAlertDialog(
              context,
              Utils.getTranslated(context, 'general_alert_error_title')!,
              value.data['errorMessage']);
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
        this.isLoading = false;
      });
    });
  }

  callGetCompareByPanelCombined(BuildContext context) async {
    await getCompareByPanelCombined(context).then((value) {
      if (value.status!.statusCode == 200) {
        if (value.data != null && value.data!.length > 0) {
          testResultDataList = value.data!;
        }
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
        this.isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme_dark!
            ? AppColors.serverAppBar()
            : AppColorsLightMode.serverAppBar(),
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Padding(
          padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
          child: Text(
            Utils.getTranslated(
                context, 'dqm_testresult_analog_detail_testresult')!,
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
          padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 21.0),
          child: this.isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppColors.appBlue()),
                  ),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            header(context),
                            infoLabel(context),
                            testResultChart(context),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget header(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
              visible: this.firstTestResultForList.length > 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: this
                    .firstTestResultForList
                    .map((e) => testResultForItem(context, e))
                    .toList(),
              ),
            ),
            Visibility(
              visible: this.secondTestResultForList.length > 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: this
                    .secondTestResultForList
                    .map((e) => testResultForItem(context, e))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget testResultForItem(BuildContext ctx, String name) {
    return GestureDetector(
      onTap: () {
        setState(() {
          this.selectedResult = name;
          this.testResultDataList = this
              .dataMap[this.selectedResult]!
              .map((e) => TestResultDataDTO.fromJson(e))
              .toList();
          this.dqmWebViewController.webViewController.reload();
        });
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(12.0, 9.0, 12.0, 9.0),
        margin: EdgeInsets.only(right: 14.0, top: 14.0),
        decoration: BoxDecoration(
          color: this.selectedResult == name
              ? AppColors.appTeal()
              : Colors.transparent,
          border: this.selectedResult == name
              ? Border.all(color: Colors.transparent)
              : Border.all(color: AppColors.appMediumGrey()),
          borderRadius: BorderRadius.circular(50.0),
        ),
        child: Text(
          name,
          style: AppFonts.robotoMedium(
            14,
            color: this.selectedResult == name
                ? AppColors.appPrimaryWhite()
                : AppColors.appMediumGrey(),
            decoration: TextDecoration.none,
          ),
        ),
      ),
    );
  }

  Widget infoLabel(BuildContext ctx) {
    String selectedResult =
        Utils.isNotEmpty(this.selectedResult) ? '(${this.selectedResult})' : '';
    return Container(
      margin: EdgeInsets.only(top: 25.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              "${Utils.getTranslated(ctx, 'dqm_testresult_for')} ${this.mTestname} $selectedResult",
              style: AppFonts.robotoRegular(16,
                  color: theme_dark!
                      ? AppColors.appGrey2()
                      : AppColorsLightMode.appGrey(),
                  decoration: TextDecoration.none),
            ),
          ),
          Visibility(
            visible: this.defTestResultForList.length > 0,
            child: GestureDetector(
              onTap: () async {
                if (this.defTestResultForList.length > 0) {
                  final navResult = await Navigator.pushNamed(
                    context,
                    AppRoutes.dqmTestResultCompareFilterRoute,
                    arguments: DqmTestResultArguments(
                      compareList: this.defTestResultForList,
                      compareBy: widget.compareBy,
                    ),
                  );

                  if (navResult != null) {
                    List<String?> retList = navResult as List<String?>;

                    setState(() {
                      if (retList.length > 10) {
                        this.firstTestResultForList.clear();
                        this.secondTestResultForList.clear();
                        for (int i = 0; i < retList.length; i++) {
                          if (i % 2 == 0) {
                            this.firstTestResultForList.add(retList[i]!);
                          } else {
                            this.secondTestResultForList.add(retList[i]!);
                          }
                        }
                      } else {
                        this.firstTestResultForList.clear();
                        retList.forEach((element) {
                          this.firstTestResultForList.add(element!);
                        });
                      }

                      this.selectedResult = retList[0]!;
                      this.testResultDataList = this
                          .dataMap[this.selectedResult]!
                          .map((e) => TestResultDataDTO.fromJson(e))
                          .toList();
                      this.dqmWebViewController.webViewController.reload();
                    });
                  }
                }
              },
              child: Image.asset(theme_dark!
                  ? Constants.ASSET_IMAGES + 'filter_icon.png'
                  : Constants.ASSET_IMAGES_LIGHT + 'filter_icon.png'),
            ),
          ),
          SizedBox(width: 16.0),
          GestureDetector(
            onTap: () {},
            child: Image.asset(theme_dark!
                ? Constants.ASSET_IMAGES + 'search_icon.png'
                : Constants.ASSET_IMAGES_LIGHT + 'search.png'),
          ),
          SizedBox(width: 16.0),
          GestureDetector(
            onTap: () {
              showDownloadPopup(context);
            },
            child: Image.asset(theme_dark!
                ? Constants.ASSET_IMAGES + 'download_bttn.png'
                : Constants.ASSET_IMAGES_LIGHT + 'download_bttn.png'),
          ),
        ],
      ),
    );
  }

  Widget testResultChart(BuildContext ctx) {
    return Container(
        margin: EdgeInsets.only(top: 35.0),
        child: Container(
          width: MediaQuery.of(ctx).size.width,
          height: this.chartHeight,
          color: Colors.transparent,
          child: (this.testResultDataList.length > 0)
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
                    this.dqmWebViewController = controllerPlus;
                  },
                  onPageFinished: (url) {
                    this.dqmWebViewController.getHeight().then((value) {
                      setState(() {
                        this.chartHeight = value;
                      });
                    });
                  },
                  javascriptChannels: [
                    JavascriptChannel(
                        name: 'DQMChannel',
                        onMessageReceived: (message) {
                          this.dqmWebViewController.webViewController.runJavascript(
                              'fetchComparationTestResultData(${jsonEncode(this.testResultDataList)})');
                        }),
                    JavascriptChannel(
                        name: 'DQMResultClickChannel',
                        onMessageReceived: (message) {
                          if (Utils.isNotEmpty(message.message)) {
                            Utils.printInfo(message.message);
                            TestResultDataDTO testResultDataDTO =
                                TestResultDataDTO.fromJson(
                                    jsonDecode(message.message));
                            Navigator.pushNamed(
                                ctx, AppRoutes.dqmCpkDashboardRoute,
                                arguments: DqmTestResultArguments(
                                    compareTestResultDataDTO: testResultDataDTO,
                                    compareBy: widget.compareBy));
                          }
                        }),
                    JavascriptChannel(
                        name: 'DQMExportImageChannel',
                        onMessageReceived: (message) async {
                          print(message.message);
                          if (Utils.isNotEmpty(message.message)) {
                            String name = 'testresult.png';

                            final result = await ImageApi.generateImage(
                                message.message,
                                600,
                                this.chartHeight.round(),
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
                            String name = 'testresult.pdf';

                            final result = await PdfApi.generatePDF(
                                message.message,
                                600,
                                this.chartHeight.round(),
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
        ));
  }

  void showDownloadPopup(BuildContext context) {
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
                    .dqmWebViewController
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

                String name = "accuracystatuschart.csv";
                final result =
                    await CSVApi.generateCSV(testResultDataList, name);
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
                    .dqmWebViewController
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

  void showTooltipsDialog(BuildContext context, JSCpkDataDTO jsCpkDataDTO) {
    showDialog(
      context: context,
      builder: (tooltipsDialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: cpkTooltipsInfo(context, jsCpkDataDTO),
        );
      },
    );
  }

  Widget cpkTooltipsInfo(BuildContext ctx, JSCpkDataDTO jsCpkDataDTO) {
    return Container(
      padding: EdgeInsets.fromLTRB(14.0, 10.0, 14.0, 10.0),
      decoration: BoxDecoration(
        color: AppColors.appBlack2C(),
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${DateFormat("EEE, dd MMM, yyyy").format(DateTime.parse(jsCpkDataDTO.date!))}',
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
                Utils.getTranslated(
                    ctx, 'dqm_rma_cpk_dashboard_histogram_cpk')!,
                style: AppFonts.robotoMedium(
                  14,
                  color: HexColor('f4d745'),
                  decoration: TextDecoration.none,
                ),
              ),
              SizedBox(width: 10.0),
              Text(
                '${jsCpkDataDTO.cpkValue!.toStringAsFixed(4)}',
                style: AppFonts.robotoMedium(
                  14,
                  color: AppColors.appPrimaryWhite(),
                  decoration: TextDecoration.none,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
