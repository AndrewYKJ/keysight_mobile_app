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
import 'package:keysight_pma/const/utils.dart';
import 'package:keysight_pma/dio/api/dqm.dart';
import 'package:keysight_pma/model/arguments/dqm_argument.dart';
import 'package:keysight_pma/model/dqm/count.dart';
import 'package:keysight_pma/model/dqm/test_result_cpk_analog.dart';
import 'package:keysight_pma/model/dqm/test_result_cpk_pins.dart';
import 'package:keysight_pma/model/dqm/test_result_fixtures.dart';
import 'package:keysight_pma/routes/approutes.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

class DqmTestResultAnalogDetailScreen extends StatefulWidget {
  final TestResultCpkAnalogDataDTO? analogDataDTO;
  final TestResultCpkPinsShortsTestJetDataDTO? pinDataDTO;
  final TestResultCpkPinsShortsTestJetDataDTO? shortDataDTO;
  final TestResultCpkPinsShortsTestJetDataDTO? vtepDataDTO;
  final TestResultCpkPinsShortsTestJetDataDTO? funcDataDTO;
  final TestResultCpkPinsShortsTestJetDataDTO? xvtepDataDTO;
  DqmTestResultAnalogDetailScreen(
      {Key? key,
      this.analogDataDTO,
      this.pinDataDTO,
      this.shortDataDTO,
      this.vtepDataDTO,
      this.funcDataDTO,
      this.xvtepDataDTO})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DqmTestResultAnalogDetailScreen();
  }
}

class _DqmTestResultAnalogDetailScreen
    extends State<DqmTestResultAnalogDetailScreen> {
  late TestResultFixtureDTO fixtureDTO = TestResultFixtureDTO();
  late WebViewPlusController cpkTestNameController;
  double chartHeight = 316.0;
  CompareCountDTO? compareCountDTO;
  String argTestname = '';
  bool? theme_dark = AppCache.sortFilterCacheDTO!.currentTheme;

  Future<TestResultFixtureDTO> getFixtures(BuildContext context) {
    String companyId = '';
    String siteId = '';
    String startDate = DateFormat("yyyy-MM-dd")
        .format(AppCache.sortFilterCacheDTO!.startDate!);
    String endDate =
        DateFormat("yyyy-MM-dd").format(AppCache.sortFilterCacheDTO!.endDate!);
    List<String?> equipments = AppCache.sortFilterCacheDTO!.defaultEquipments!
        .where((element) => element.isSelected == true)
        .map((e) => e.equipmentId)
        .toList();
    String projectId = '';
    String testname = '';
    String testType = '';
    if (widget.analogDataDTO != null) {
      companyId = widget.analogDataDTO!.companyId!;
      siteId = widget.analogDataDTO!.siteId!;
      projectId = widget.analogDataDTO!.projectId!;
      testname = widget.analogDataDTO!.testName!;
      testType = widget.analogDataDTO!.testType!;
    } else if (widget.pinDataDTO != null) {
      companyId = widget.pinDataDTO!.companyId!;
      siteId = widget.pinDataDTO!.siteId!;
      projectId = widget.pinDataDTO!.projectId!;
      testname = widget.pinDataDTO!.testName!;
      testType = widget.pinDataDTO!.testType!;
    } else if (widget.shortDataDTO != null) {
      companyId = widget.shortDataDTO!.companyId!;
      siteId = widget.shortDataDTO!.siteId!;
      projectId = widget.shortDataDTO!.projectId!;
      testname = widget.shortDataDTO!.testName!;
      testType = widget.shortDataDTO!.testType!;
    } else if (widget.vtepDataDTO != null) {
      companyId = widget.vtepDataDTO!.companyId!;
      siteId = widget.vtepDataDTO!.siteId!;
      projectId = widget.vtepDataDTO!.projectId!;
      testname = widget.vtepDataDTO!.testName!;
      testType = widget.vtepDataDTO!.testType!;
    } else if (widget.funcDataDTO != null) {
      companyId = widget.funcDataDTO!.companyId!;
      siteId = widget.funcDataDTO!.siteId!;
      projectId = widget.funcDataDTO!.projectId!;
      testname = widget.funcDataDTO!.testName!;
      testType = widget.funcDataDTO!.testType!;
    } else if (widget.xvtepDataDTO != null) {
      companyId = widget.xvtepDataDTO!.companyId!;
      siteId = widget.xvtepDataDTO!.siteId!;
      projectId = widget.xvtepDataDTO!.projectId!;
      testname = widget.xvtepDataDTO!.testName!;
      testType = widget.xvtepDataDTO!.testType!;
    }
    DqmApi dqmApi = DqmApi(context);
    return dqmApi.getFixtures(companyId, siteId, startDate, endDate, equipments,
        projectId, testname, testType);
  }

  Future<CompareCountDTO> getCompareCount(BuildContext context) {
    String companyId = '';
    String siteId = '';
    String startDate = DateFormat("yyyy-MM-dd")
        .format(AppCache.sortFilterCacheDTO!.startDate!);
    String endDate =
        DateFormat("yyyy-MM-dd").format(AppCache.sortFilterCacheDTO!.endDate!);
    List<String?> equipments = AppCache.sortFilterCacheDTO!.defaultEquipments!
        .where((element) => element.isSelected == true)
        .map((e) => e.equipmentId)
        .toList();
    String projectId = '';
    String testname = '';
    if (widget.analogDataDTO != null) {
      companyId = widget.analogDataDTO!.companyId!;
      siteId = widget.analogDataDTO!.siteId!;
      projectId = widget.analogDataDTO!.projectId!;
      testname = widget.analogDataDTO!.testName!;
    } else if (widget.pinDataDTO != null) {
      companyId = widget.pinDataDTO!.companyId!;
      siteId = widget.pinDataDTO!.siteId!;
      projectId = widget.pinDataDTO!.projectId!;
      testname = widget.pinDataDTO!.testName!;
    } else if (widget.shortDataDTO != null) {
      companyId = widget.shortDataDTO!.companyId!;
      siteId = widget.shortDataDTO!.siteId!;
      projectId = widget.shortDataDTO!.projectId!;
      testname = widget.shortDataDTO!.testName!;
    } else if (widget.vtepDataDTO != null) {
      companyId = widget.vtepDataDTO!.companyId!;
      siteId = widget.vtepDataDTO!.siteId!;
      projectId = widget.vtepDataDTO!.projectId!;
      testname = widget.vtepDataDTO!.testName!;
    } else if (widget.funcDataDTO != null) {
      companyId = widget.funcDataDTO!.companyId!;
      siteId = widget.funcDataDTO!.siteId!;
      projectId = widget.funcDataDTO!.projectId!;
      testname = widget.funcDataDTO!.testName!;
    } else if (widget.xvtepDataDTO != null) {
      companyId = widget.xvtepDataDTO!.companyId!;
      siteId = widget.xvtepDataDTO!.siteId!;
      projectId = widget.xvtepDataDTO!.projectId!;
      testname = widget.xvtepDataDTO!.testName!;
    }
    DqmApi dqmApi = DqmApi(context);
    return dqmApi.getCompareCount(
        companyId, siteId, projectId, startDate, endDate, testname, equipments);
  }

  @override
  void initState() {
    super.initState();
    if (widget.analogDataDTO != null) {
      argTestname = widget.analogDataDTO!.testName!;
    } else if (widget.pinDataDTO != null) {
      argTestname = widget.pinDataDTO!.testName!;
    } else if (widget.shortDataDTO != null) {
      argTestname = widget.shortDataDTO!.testName!;
    } else if (widget.vtepDataDTO != null) {
      argTestname = widget.vtepDataDTO!.testName!;
    } else if (widget.funcDataDTO != null) {
      argTestname = widget.funcDataDTO!.testName!;
    } else if (widget.xvtepDataDTO != null) {
      argTestname = widget.xvtepDataDTO!.testName!;
    }
    callGetFixtures(context);
  }

  callGetFixtures(BuildContext context) async {
    EasyLoading.show(maskType: EasyLoadingMaskType.black);
    await getFixtures(context).then((value) {
      if (value.status!.statusCode == 200) {
        this.fixtureDTO = value;
        callGetCompareCount(context);
      } else {
        setState(() {
          EasyLoading.dismiss();
        });
      }
    }).catchError((error) {
      Utils.printInfo(error);
      setState(() {
        EasyLoading.dismiss();
      });
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
    });
  }

  callGetCompareCount(BuildContext context) async {
    await getCompareCount(context).then((value) {
      if (value.status!.statusCode == 200) {
        this.compareCountDTO = value;
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
        EasyLoading.dismiss();
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
        centerTitle: true,
        title: Padding(
          padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
          child: Text(
            Utils.getTranslated(
                context, 'dqm_testresult_analog_detail_appbar_title')!,
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
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                analogInformationLabel(context),
                widget.analogDataDTO != null
                    ? analogInformation(context)
                    : widget.pinDataDTO != null
                        ? pinInformation(context)
                        : widget.shortDataDTO != null
                            ? shortInformation(context)
                            : widget.vtepDataDTO != null
                                ? vtepInformation(context)
                                : widget.funcDataDTO != null
                                    ? funcInformation(context)
                                    : widget.xvtepDataDTO != null
                                        ? xvtepInformation(context)
                                        : Container(),
                divider(context),
                resultsLabel(context),
                testResultName(context),
                compareButton(context),
                testResultChart(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget analogInformationLabel(BuildContext ctx) {
    return Container(
      margin: EdgeInsets.only(top: 22.0),
      child: Text(
        Utils.getTranslated(ctx, 'dqm_testresult_analog_information')!,
        style: AppFonts.robotoRegular(
          16,
          color:
              theme_dark! ? AppColors.appGrey2() : AppColorsLightMode.appGrey(),
          decoration: TextDecoration.none,
        ),
      ),
    );
  }

  Widget analogInformation(BuildContext ctx) {
    return Container(
      margin: EdgeInsets.only(top: 21.0),
      padding: EdgeInsets.fromLTRB(12.0, 16.0, 12.0, 16.0),
      decoration: BoxDecoration(
        color: theme_dark!
            ? AppColors.appBlackLight()
            : AppColorsLightMode.appGreyBA(),
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
                child: gridItem(
                    ctx,
                    Utils.getTranslated(
                        ctx, 'dqm_testresult_analog_sortby_type')!,
                    Utils.isNotEmpty(widget.analogDataDTO!.testType)
                        ? widget.analogDataDTO!.testType!
                        : '-'),
              ),
              SizedBox(width: 10.0),
              Expanded(
                child: gridItem(
                    ctx,
                    Utils.getTranslated(
                        ctx, 'dqm_testresult_analog_sortby_testname')!,
                    Utils.isNotEmpty(widget.analogDataDTO!.testName)
                        ? widget.analogDataDTO!.testName!
                        : '-'),
              ),
              SizedBox(width: 10.0),
              Expanded(
                child: gridItem(
                    ctx,
                    Utils.getTranslated(
                        ctx, 'dqm_testresult_analog_sortby_cpk')!,
                    widget.analogDataDTO!.cpk != null
                        ? '${widget.analogDataDTO!.cpk.toDouble().toStringAsFixed(2)}'
                        : '-'),
              ),
            ],
          ),
          SizedBox(height: 30.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: gridItem(
                    ctx,
                    Utils.getTranslated(
                        ctx, 'dqm_testresult_analog_sortby_nominal')!,
                    widget.analogDataDTO!.nominal != null
                        ? Utils.prefixConversion(
                            widget.analogDataDTO!.nominal, 2)
                        : '-'),
              ),
              SizedBox(width: 10.0),
              Expanded(
                child: gridItem(
                    ctx,
                    Utils.getTranslated(
                        ctx, 'dqm_testresult_analog_sortby_lower_limit')!,
                    Utils.isNotEmpty(widget.analogDataDTO!.lowerLimit)
                        ? Utils.prefixConversion(
                            widget.analogDataDTO!.lowerLimit, 2)
                        : '-'),
              ),
              SizedBox(width: 10.0),
              Expanded(
                child: gridItem(
                    ctx,
                    Utils.getTranslated(
                        ctx, 'dqm_testresult_analog_sortby_upper_limit')!,
                    Utils.isNotEmpty(widget.analogDataDTO!.upperLimit)
                        ? Utils.prefixConversion(
                            widget.analogDataDTO!.upperLimit, 2)
                        : '-'),
              ),
            ],
          ),
          SizedBox(height: 30.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: gridItem(
                    ctx,
                    Utils.getTranslated(
                        ctx, 'dqm_testresult_analog_detail_threshold')!,
                    widget.analogDataDTO!.threshold != null
                        ? Utils.prefixConversion(
                            widget.analogDataDTO!.threshold, 2)
                        : '-'),
              ),
              SizedBox(width: 10.0),
              Expanded(
                child: gridItem(
                    ctx,
                    Utils.getTranslated(
                        ctx, 'dqm_testresult_analog_detail_tolerance-')!,
                    widget.analogDataDTO!.tolerance_negative != null
                        ? Utils.prefixConversion(
                            widget.analogDataDTO!.tolerance_negative, 2)
                        : '-'),
              ),
              SizedBox(width: 10.0),
              Expanded(
                child: gridItem(
                    ctx,
                    Utils.getTranslated(
                        ctx, 'dqm_testresult_analog_detail_tolerance+')!,
                    widget.analogDataDTO!.tolerance_positive != null
                        ? Utils.prefixConversion(
                            widget.analogDataDTO!.tolerance_positive, 2)
                        : '-'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget pinInformation(BuildContext ctx) {
    return Container(
      margin: EdgeInsets.only(top: 21.0),
      padding: EdgeInsets.fromLTRB(12.0, 16.0, 12.0, 16.0),
      decoration: BoxDecoration(
        color: theme_dark!
            ? AppColors.appBlackLight()
            : AppColorsLightMode.appGreyBA(),
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
                child: gridItem(
                    ctx,
                    Utils.getTranslated(
                        ctx, 'dqm_testresult_analog_sortby_type')!,
                    Utils.isNotEmpty(widget.pinDataDTO!.testType)
                        ? widget.pinDataDTO!.testType!
                        : '-'),
              ),
              SizedBox(width: 10.0),
              Expanded(
                child: gridItem(
                    ctx,
                    Utils.getTranslated(
                        ctx, 'dqm_testresult_pins_detail_node')!,
                    Utils.isNotEmpty(widget.pinDataDTO!.testName)
                        ? widget.pinDataDTO!.testName!
                        : '-'),
              ),
              SizedBox(width: 10.0),
              Expanded(
                child: gridItem(
                    ctx,
                    Utils.getTranslated(
                        ctx, 'dqm_testresult_analog_sortby_cpk')!,
                    widget.pinDataDTO!.cpk != null
                        ? '${widget.pinDataDTO!.cpk!.toDouble().toStringAsFixed(2)}'
                        : '-'),
              ),
            ],
          ),
          SizedBox(height: 30.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: gridItem(
                    ctx,
                    Utils.getTranslated(
                        ctx, 'dqm_testresult_pins_detail_brcc')!,
                    widget.pinDataDTO!.brcc != null
                        ? '${widget.pinDataDTO!.brcc}'
                        : '-'),
              ),
              SizedBox(width: 10.0),
              Expanded(
                child: gridItem(
                    ctx,
                    Utils.getTranslated(ctx, 'dqm_testresult_minimum')!,
                    widget.pinDataDTO!.min != null
                        ? '${widget.pinDataDTO!.min}'
                        : '-'),
              ),
              SizedBox(width: 10.0),
              Expanded(
                child: gridItem(
                    ctx,
                    Utils.getTranslated(ctx, 'dqm_testresult_maximum')!,
                    widget.pinDataDTO!.max != null
                        ? '${widget.pinDataDTO!.max}'
                        : '-'),
              ),
            ],
          ),
          SizedBox(height: 30.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: gridItem(
                    ctx,
                    Utils.getTranslated(
                        ctx, 'dqm_testresult_analog_detail_threshold')!,
                    widget.pinDataDTO!.threshold != null
                        ? '${widget.pinDataDTO!.threshold}'
                        : '-'),
              ),
              SizedBox(width: 10.0),
              Expanded(
                child: gridItem(
                    ctx,
                    Utils.getTranslated(
                        ctx, 'dqm_testresult_analog_detail_tolerance-')!,
                    widget.pinDataDTO!.tolerance_negative != null
                        ? '${widget.pinDataDTO!.tolerance_negative}'
                        : '-'),
              ),
              SizedBox(width: 10.0),
              Expanded(
                child: gridItem(
                    ctx,
                    Utils.getTranslated(
                        ctx, 'dqm_testresult_analog_detail_tolerance+')!,
                    widget.pinDataDTO!.tolerance_positive != null
                        ? '${widget.pinDataDTO!.tolerance_positive}'
                        : '-'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget shortInformation(BuildContext ctx) {
    return Container(
      margin: EdgeInsets.only(top: 21.0),
      padding: EdgeInsets.fromLTRB(12.0, 16.0, 12.0, 16.0),
      decoration: BoxDecoration(
        color: theme_dark!
            ? AppColors.appBlackLight()
            : AppColorsLightMode.appGreyBA(),
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
                child: gridItem(
                    ctx,
                    Utils.getTranslated(
                        ctx, 'dqm_testresult_shorts_detail_type')!,
                    Utils.isNotEmpty(widget.shortDataDTO!.testType)
                        ? widget.shortDataDTO!.testType!.contains('|')
                            ? widget.shortDataDTO!.testType!.split('|')[1]
                            : widget.shortDataDTO!.testType!
                        : '-'),
              ),
              SizedBox(width: 10.0),
              Expanded(
                child: gridItem(
                    ctx,
                    Utils.getTranslated(
                        ctx, 'dqm_testresult_shorts_detail_source')!,
                    Utils.isNotEmpty(widget.shortDataDTO!.testName)
                        ? widget.shortDataDTO!.testName!.contains('>')
                            ? widget.shortDataDTO!.testName!.substring(
                                widget.shortDataDTO!.testName!.indexOf('>') + 1)
                            : widget.shortDataDTO!.testName!
                        : '-'),
              ),
              SizedBox(width: 10.0),
              Expanded(
                child: gridItem(
                    ctx,
                    Utils.getTranslated(
                        ctx, 'dqm_testresult_analog_sortby_cpk')!,
                    widget.shortDataDTO!.cpk != null
                        ? '${widget.shortDataDTO!.cpk!.toDouble().toStringAsFixed(2)}'
                        : '-'),
              ),
            ],
          ),
          SizedBox(height: 30.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: gridItem(
                    ctx,
                    Utils.getTranslated(
                        ctx, 'dqm_testresult_shorts_detail_destination')!,
                    Utils.isNotEmpty(widget.shortDataDTO!.destination)
                        ? '${widget.shortDataDTO!.destination}'
                        : '-'),
              ),
              SizedBox(width: 10.0),
              Expanded(
                child: gridItem(
                    ctx,
                    Utils.getTranslated(ctx, 'dqm_testresult_minimum')!,
                    widget.shortDataDTO!.min != null
                        ? '${widget.shortDataDTO!.min}'
                        : '-'),
              ),
              SizedBox(width: 10.0),
              Expanded(
                child: gridItem(
                    ctx,
                    Utils.getTranslated(ctx, 'dqm_testresult_maximum')!,
                    widget.shortDataDTO!.max != null
                        ? '${widget.shortDataDTO!.max}'
                        : '-'),
              ),
            ],
          ),
          SizedBox(height: 30.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: gridItem(
                    ctx,
                    Utils.getTranslated(
                        ctx, 'dqm_testresult_analog_detail_threshold')!,
                    widget.shortDataDTO!.threshold != null
                        ? '${widget.shortDataDTO!.threshold}'
                        : '-'),
              ),
              SizedBox(width: 10.0),
              Expanded(
                child: gridItem(
                    ctx,
                    Utils.getTranslated(
                        ctx, 'dqm_testresult_analog_detail_tolerance-')!,
                    widget.shortDataDTO!.tolerance_negative != null
                        ? '${widget.shortDataDTO!.tolerance_negative}'
                        : '-'),
              ),
              SizedBox(width: 10.0),
              Expanded(
                child: gridItem(
                    ctx,
                    Utils.getTranslated(
                        ctx, 'dqm_testresult_analog_detail_tolerance+')!,
                    widget.shortDataDTO!.tolerance_positive != null
                        ? '${widget.shortDataDTO!.tolerance_positive}'
                        : '-'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget vtepInformation(BuildContext ctx) {
    return Container(
      margin: EdgeInsets.only(top: 21.0),
      padding: EdgeInsets.fromLTRB(12.0, 16.0, 12.0, 16.0),
      decoration: BoxDecoration(
        color: theme_dark!
            ? AppColors.appBlackLight()
            : AppColorsLightMode.appGreyBA(),
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
                child: gridItem(
                    ctx,
                    Utils.getTranslated(
                        ctx, 'dqm_testresult_vtep_detail_device')!,
                    Utils.isNotEmpty(widget.vtepDataDTO!.source)
                        ? widget.vtepDataDTO!.source!
                        : '-'),
              ),
              SizedBox(width: 10.0),
              Expanded(
                child: gridItem(
                    ctx,
                    Utils.getTranslated(ctx, 'dqm_testresult_vtep_detail_pin')!,
                    Utils.isNotEmpty(widget.vtepDataDTO!.destination)
                        ? widget.vtepDataDTO!.destination!
                        : '-'),
              ),
              SizedBox(width: 10.0),
              Expanded(
                child: gridItem(
                    ctx,
                    Utils.getTranslated(
                        ctx, 'dqm_testresult_analog_sortby_cpk')!,
                    widget.vtepDataDTO!.cpk != null
                        ? '${widget.vtepDataDTO!.cpk!.toDouble().toStringAsFixed(2)}'
                        : '-'),
              ),
            ],
          ),
          SizedBox(height: 30.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: gridItem(
                    ctx,
                    Utils.getTranslated(ctx, 'dqm_testresult_vtep_mean')!,
                    Utils.isNotEmpty(widget.vtepDataDTO!.mean)
                        ? '${widget.vtepDataDTO!.mean}'
                        : '-'),
              ),
              SizedBox(width: 10.0),
              Expanded(
                child: gridItem(
                    ctx,
                    Utils.getTranslated(ctx, 'dqm_testresult_minimum')!,
                    widget.vtepDataDTO!.min != null
                        ? '${widget.vtepDataDTO!.min}'
                        : '-'),
              ),
              SizedBox(width: 10.0),
              Expanded(
                child: gridItem(
                    ctx,
                    Utils.getTranslated(ctx, 'dqm_testresult_maximum')!,
                    widget.vtepDataDTO!.max != null
                        ? '${widget.vtepDataDTO!.max}'
                        : '-'),
              ),
            ],
          ),
          SizedBox(height: 30.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: gridItem(
                    ctx,
                    Utils.getTranslated(ctx, 'dqm_testresult_std_deviation')!,
                    widget.vtepDataDTO!.stdDeviation != null
                        ? '${widget.vtepDataDTO!.stdDeviation}'
                        : '-'),
              ),
              SizedBox(width: 10.0),
              Expanded(
                child: gridItem(
                    ctx,
                    Utils.getTranslated(
                        ctx, 'dqm_testresult_analog_sortby_lower_limit')!,
                    Utils.isNotEmpty(widget.vtepDataDTO!.lowerLimit)
                        ? '${widget.vtepDataDTO!.lowerLimit}'
                        : '-'),
              ),
              SizedBox(width: 10.0),
              Expanded(
                child: gridItem(
                    ctx,
                    Utils.getTranslated(
                        ctx, 'dqm_testresult_analog_sortby_upper_limit')!,
                    Utils.isNotEmpty(widget.vtepDataDTO!.upperLimit)
                        ? '${widget.vtepDataDTO!.upperLimit}'
                        : '-'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget funcInformation(BuildContext ctx) {
    return Container(
      margin: EdgeInsets.only(top: 21.0),
      padding: EdgeInsets.fromLTRB(12.0, 16.0, 12.0, 16.0),
      decoration: BoxDecoration(
        color: theme_dark!
            ? AppColors.appBlackLight()
            : AppColorsLightMode.appGreyBA(),
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
                child: gridItem(
                    ctx,
                    Utils.getTranslated(
                        ctx, 'dqm_testresult_analog_sortby_type')!,
                    Utils.isNotEmpty(widget.funcDataDTO!.testType)
                        ? widget.funcDataDTO!.testType!
                        : '-'),
              ),
              SizedBox(width: 10.0),
              Expanded(
                child: gridItem(
                    ctx,
                    Utils.getTranslated(
                        ctx, 'dqm_testresult_analog_sortby_testname')!,
                    Utils.isNotEmpty(widget.funcDataDTO!.testName)
                        ? widget.funcDataDTO!.testName!
                        : '-'),
              ),
              SizedBox(width: 10.0),
              Expanded(
                child: gridItem(
                    ctx,
                    Utils.getTranslated(
                        ctx, 'dqm_testresult_analog_sortby_cpk')!,
                    widget.funcDataDTO!.cpk != null
                        ? '${widget.funcDataDTO!.cpk!.toDouble().toStringAsFixed(2)}'
                        : '-'),
              ),
            ],
          ),
          SizedBox(height: 30.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: gridItem(
                    ctx,
                    Utils.getTranslated(
                        ctx, 'dqm_testresult_analog_sortby_nominal')!,
                    widget.funcDataDTO!.nominal != null
                        ? '${widget.funcDataDTO!.nominal}'
                        : '-'),
              ),
              SizedBox(width: 10.0),
              Expanded(
                child: gridItem(
                    ctx,
                    Utils.getTranslated(
                        ctx, 'dqm_testresult_analog_sortby_lower_limit')!,
                    Utils.isNotEmpty(widget.funcDataDTO!.lowerLimit)
                        ? '${widget.funcDataDTO!.lowerLimit}'
                        : '-'),
              ),
              SizedBox(width: 10.0),
              Expanded(
                child: gridItem(
                    ctx,
                    Utils.getTranslated(
                        ctx, 'dqm_testresult_analog_sortby_upper_limit')!,
                    Utils.isNotEmpty(widget.funcDataDTO!.upperLimit)
                        ? '${widget.funcDataDTO!.upperLimit}'
                        : '-'),
              ),
            ],
          ),
          SizedBox(height: 30.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: gridItem(
                    ctx,
                    Utils.getTranslated(
                        ctx, 'dqm_testresult_analog_detail_threshold')!,
                    widget.funcDataDTO!.threshold != null
                        ? '${widget.funcDataDTO!.threshold}'
                        : '-'),
              ),
              SizedBox(width: 10.0),
              Expanded(
                child: gridItem(
                    ctx,
                    Utils.getTranslated(
                        ctx, 'dqm_testresult_analog_detail_tolerance-')!,
                    widget.funcDataDTO!.tolerance_negative != null
                        ? '${widget.funcDataDTO!.tolerance_negative}'
                        : '-'),
              ),
              SizedBox(width: 10.0),
              Expanded(
                child: gridItem(
                    ctx,
                    Utils.getTranslated(
                        ctx, 'dqm_testresult_analog_detail_tolerance+')!,
                    widget.funcDataDTO!.tolerance_positive != null
                        ? '${widget.funcDataDTO!.tolerance_positive}'
                        : '-'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget xvtepInformation(BuildContext ctx) {
    return Container(
      margin: EdgeInsets.only(top: 21.0),
      padding: EdgeInsets.fromLTRB(12.0, 16.0, 12.0, 16.0),
      decoration: BoxDecoration(
        color: theme_dark!
            ? AppColors.appBlackLight()
            : AppColorsLightMode.appGreyBA(),
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
                child: gridItem(
                    ctx,
                    Utils.getTranslated(ctx, 'dqm_testresult_xvtep_device')!,
                    Utils.isNotEmpty(widget.xvtepDataDTO!.source)
                        ? widget.xvtepDataDTO!.source!
                        : '-'),
              ),
              SizedBox(width: 10.0),
              Expanded(
                child: gridItem(
                    ctx,
                    Utils.getTranslated(ctx, 'dqm_testresult_xvtep_pin')!,
                    Utils.isNotEmpty(widget.xvtepDataDTO!.destination)
                        ? widget.xvtepDataDTO!.destination!
                        : '-'),
              ),
              SizedBox(width: 10.0),
              Expanded(
                child: gridItem(
                    ctx,
                    Utils.getTranslated(
                        ctx, 'dqm_testresult_analog_sortby_cpk')!,
                    widget.xvtepDataDTO!.cpk != null
                        ? '${widget.xvtepDataDTO!.cpk!.toDouble().toStringAsFixed(2)}'
                        : '-'),
              ),
            ],
          ),
          SizedBox(height: 30.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: gridItem(
                    ctx,
                    Utils.getTranslated(ctx, 'dqm_testresult_vtep_mean')!,
                    Utils.isNotEmpty(widget.xvtepDataDTO!.mean)
                        ? '${widget.xvtepDataDTO!.mean}'
                        : '-'),
              ),
              SizedBox(width: 10.0),
              Expanded(
                child: gridItem(
                    ctx,
                    Utils.getTranslated(
                        ctx, 'dqm_testresult_analog_sortby_lower_limit')!,
                    Utils.isNotEmpty(widget.xvtepDataDTO!.lowerLimit)
                        ? '${widget.xvtepDataDTO!.lowerLimit}'
                        : '-'),
              ),
              SizedBox(width: 10.0),
              Expanded(
                child: gridItem(
                    ctx,
                    Utils.getTranslated(
                        ctx, 'dqm_testresult_analog_sortby_upper_limit')!,
                    Utils.isNotEmpty(widget.xvtepDataDTO!.upperLimit)
                        ? '${widget.xvtepDataDTO!.upperLimit}'
                        : '-'),
              ),
            ],
          ),
          SizedBox(height: 30.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: gridItem(
                    ctx,
                    Utils.getTranslated(ctx, 'dqm_testresult_minimum')!,
                    widget.xvtepDataDTO!.min != null
                        ? '${widget.xvtepDataDTO!.min}'
                        : '-'),
              ),
              SizedBox(width: 10.0),
              Expanded(
                child: gridItem(
                    ctx,
                    Utils.getTranslated(ctx, 'dqm_testresult_maximum')!,
                    widget.xvtepDataDTO!.max != null
                        ? '${widget.xvtepDataDTO!.max}'
                        : '-'),
              ),
              SizedBox(width: 10.0),
              Expanded(
                child: gridItem(
                    ctx,
                    Utils.getTranslated(ctx, 'dqm_testresult_std_deviation')!,
                    widget.xvtepDataDTO!.stdDeviation != null
                        ? '${widget.xvtepDataDTO!.stdDeviation}'
                        : '-'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget gridItem(BuildContext ctx, String title, String value) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppFonts.robotoRegular(
            13,
            color: theme_dark!
                ? AppColors.appGreyB1()
                : AppColorsLightMode.appGrey77(),
            decoration: TextDecoration.none,
          ),
        ),
        SizedBox(height: 10.0),
        Text(
          value,
          style: AppFonts.robotoMedium(
            13,
            color: theme_dark!
                ? AppColors.appGreyDE()
                : AppColorsLightMode.appGrey(),
            decoration: TextDecoration.none,
          ),
        ),
      ],
    );
  }

  Widget divider(BuildContext ctx) {
    return Container(
      width: MediaQuery.of(ctx).size.width,
      height: 1.0,
      color: theme_dark!
          ? AppColors.appDividerColor()
          : AppColorsLightMode.appDividerColor(),
      margin: EdgeInsets.only(top: 20.0),
    );
  }

  Widget resultsLabel(BuildContext ctx) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Text(
        Utils.getTranslated(ctx, 'dqm_testresult_analog_detail_appbar_title')!,
        style: AppFonts.robotoBold(
          18,
          color: theme_dark!
              ? AppColors.appPrimaryWhite()
              : AppColorsLightMode.appPrimaryWhite(),
          decoration: TextDecoration.none,
        ),
      ),
    );
  }

  Widget testResultName(BuildContext ctx) {
    return Container(
      margin: EdgeInsets.only(top: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              widget.analogDataDTO != null
                  ? Utils.getTranslated(
                          ctx, 'dqm_testresult_analog_detail_testresult')! +
                      ': ${widget.analogDataDTO!.testName}'
                  : widget.pinDataDTO != null
                      ? Utils.getTranslated(
                              ctx, 'dqm_testresult_analog_detail_testresult')! +
                          ': ${widget.pinDataDTO!.testName}'
                      : widget.shortDataDTO != null
                          ? Utils.getTranslated(ctx,
                                  'dqm_testresult_analog_detail_testresult')! +
                              ': ${widget.shortDataDTO!.testName!.substring(widget.shortDataDTO!.testName!.indexOf('>') + 1)}'
                          : widget.vtepDataDTO != null
                              ? Utils.getTranslated(ctx,
                                      'dqm_testresult_analog_detail_testresult')! +
                                  ': ${widget.vtepDataDTO!.testName!}'
                              : widget.funcDataDTO != null
                                  ? Utils.getTranslated(ctx,
                                          'dqm_testresult_analog_detail_testresult')! +
                                      ': ${widget.funcDataDTO!.testName!}'
                                  : widget.xvtepDataDTO != null
                                      ? Utils.getTranslated(ctx,
                                              'dqm_testresult_analog_detail_testresult')! +
                                          ': ${widget.xvtepDataDTO!.testName!}'
                                      : '',
              style: AppFonts.robotoMedium(
                15,
                color: theme_dark!
                    ? AppColors.appGreyD3()
                    : AppColorsLightMode.appGrey(),
                decoration: TextDecoration.none,
              ),
            ),
          ),
          // SizedBox(width: 10.0),
          // InkWell(
          //   onTap: () {},
          //   child: Image.asset(theme_dark!
          // ? Constants.ASSET_IMAGES + 'search_icon.png'
          // : Constants.ASSET_IMAGES_LIGHT + 'search.png'),
          // ),
        ],
      ),
    );
  }

  Widget compareButton(BuildContext ctx) {
    if (this.compareCountDTO != null && this.compareCountDTO!.data != null) {
      if (this.compareCountDTO!.data!.numberOfEquipments!.toInt() > 1 ||
          this.compareCountDTO!.data!.numberOfFixtures!.toInt() > 1 ||
          this.compareCountDTO!.data!.numberOfPanels!.toInt() > 1) {
        return GestureDetector(
          onTap: () {
            showComparePopup(ctx);
          },
          child: Container(
            margin: EdgeInsets.only(top: 29.0),
            padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            decoration: BoxDecoration(
              color: theme_dark!
                  ? AppColors.appGrey4A()
                  : AppColorsLightMode.appTeal(),
              borderRadius: BorderRadius.circular(50.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(Constants.ASSET_IMAGES + 'compare_icon.png'),
                SizedBox(width: 8.0),
                Text(
                  Utils.getTranslated(
                      ctx, 'dqm_testresult_analog_detail_compare')!,
                  style: AppFonts.robotoRegular(
                    14,
                    color: theme_dark!
                        ? AppColors.appGrey2()
                        : AppColorsLightMode.appGrey2(),
                    decoration: TextDecoration.none,
                  ),
                ),
              ],
            ),
          ),
        );
      }
    }
    return Container();
  }

  Widget testResultChart(BuildContext ctx) {
    String testType = '';
    if (widget.analogDataDTO != null) {
      testType = widget.analogDataDTO!.testType!;
    } else if (widget.pinDataDTO != null) {
      testType = widget.pinDataDTO!.testType!;
    } else if (widget.shortDataDTO != null) {
      testType = widget.shortDataDTO!.testType!;
    } else if (widget.vtepDataDTO != null) {
      testType = widget.vtepDataDTO!.testType!;
    } else if (widget.funcDataDTO != null) {
      testType = widget.funcDataDTO!.testType!;
    } else if (widget.xvtepDataDTO != null) {
      testType = widget.xvtepDataDTO!.testType!;
    }
    return Container(
      height: this.chartHeight,
      margin: EdgeInsets.only(top: 30.0),
      color: theme_dark!
          ? AppColors.appBlackLight()
          : AppColorsLightMode.appPrimaryBlack(),
      child: this.fixtureDTO.data != null && this.fixtureDTO.data!.length > 0
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
                this.cpkTestNameController = controllerPlus;
              },
              onPageFinished: (url) {
                this.cpkTestNameController.getHeight().then((value) {
                  setState(() {
                    this.chartHeight = value;
                  });
                });
              },
              javascriptChannels: [
                JavascriptChannel(
                    name: 'DQMChannel',
                    onMessageReceived: (message) {
                      this.cpkTestNameController.webViewController.runJavascript(
                          'fetchTestResultByTestNameData(${jsonEncode(this.fixtureDTO)}, "$testType", "${Utils.getTranslated(ctx, 'chart_footer_timestamp_measured')}", "${Utils.getTranslated(ctx, 'chart_legend_pass')}", "${Utils.getTranslated(ctx, 'chart_legend_fail')}", "${Utils.getTranslated(ctx, 'chart_legend_anomaly')}", "${Utils.getTranslated(ctx, 'chart_legend_false_failure')}", "${Utils.getTranslated(ctx, 'chart_legend_threshold')}", "${Utils.getTranslated(ctx, 'chart_legend_lower_limit')}", "${Utils.getTranslated(ctx, 'chart_legend_upper_limit')}")');
                    }),
                JavascriptChannel(
                    name: 'DQMAnalogCpkTestResultChannel',
                    onMessageReceived: (message) {
                      print(message.message);
                      TestResultFixtureDataDTO fixtureDataDTO =
                          TestResultFixtureDataDTO.fromJson(
                              jsonDecode(message.message));
                      Utils.printInfo(fixtureDataDTO.measured!);
                      Navigator.pushNamed(ctx, AppRoutes.dqmCpkDashboardRoute,
                          arguments: DqmTestResultArguments(
                            analogDataDTO: widget.analogDataDTO,
                            fixtureDataDTO: fixtureDataDTO,
                            fromWhere:
                                Constants.CPK_DASHBOARD_FROM_TESTRESULT_ANALOG,
                          ));
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
    );
  }

  void showComparePopup(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext popContext) => CupertinoActionSheet(
        actions: [
          Visibility(
            visible:
                this.compareCountDTO!.data!.numberOfEquipments!.toInt() > 1,
            child: Container(
              color: theme_dark!
                  ? AppColors.cupertinoBackground()
                  : AppColorsLightMode.cupertinoBackground().withOpacity(0.8),
              child: CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pushNamed(
                      context, AppRoutes.dqmTestResultCompareRoute,
                      arguments: DqmTestResultArguments(
                          analogDataDTO: widget.analogDataDTO,
                          pinsDataDTO: widget.pinDataDTO,
                          shortsDataDTO: widget.shortDataDTO,
                          vtepDataDTO: widget.vtepDataDTO,
                          funcDataDTO: widget.funcDataDTO,
                          xvtepDataDTO: widget.xvtepDataDTO,
                          compareBy: Constants.COMPARE_BY_EQUIPMENT));
                  Navigator.pop(popContext);
                },
                child: Text(
                  Utils.getTranslated(
                      context, 'compare_popup_compareby_equipment')!,
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
          ),
          Visibility(
            visible: this.compareCountDTO!.data!.numberOfFixtures!.toInt() > 1,
            child: Container(
              color: theme_dark!
                  ? AppColors.cupertinoBackground()
                  : AppColorsLightMode.cupertinoBackground().withOpacity(0.8),
              child: CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pushNamed(
                      context, AppRoutes.dqmTestResultCompareRoute,
                      arguments: DqmTestResultArguments(
                          analogDataDTO: widget.analogDataDTO,
                          pinsDataDTO: widget.pinDataDTO,
                          shortsDataDTO: widget.shortDataDTO,
                          vtepDataDTO: widget.vtepDataDTO,
                          funcDataDTO: widget.funcDataDTO,
                          xvtepDataDTO: widget.xvtepDataDTO,
                          compareBy: Constants.COMPARE_BY_FIXTURE));
                  Navigator.pop(popContext);
                },
                child: Text(
                  Utils.getTranslated(
                      context, 'compare_popup_compareby_fixture')!,
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
          ),
          Visibility(
            visible:
                (this.compareCountDTO!.data!.numberOfEquipments!.toInt() > 1 ||
                    this.compareCountDTO!.data!.numberOfFixtures!.toInt() > 1),
            child: Container(
              color: theme_dark!
                  ? AppColors.cupertinoBackground()
                  : AppColorsLightMode.cupertinoBackground().withOpacity(0.8),
              child: CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pushNamed(
                      context, AppRoutes.dqmTestResultCompareRoute,
                      arguments: DqmTestResultArguments(
                          analogDataDTO: widget.analogDataDTO,
                          pinsDataDTO: widget.pinDataDTO,
                          shortsDataDTO: widget.shortDataDTO,
                          vtepDataDTO: widget.vtepDataDTO,
                          funcDataDTO: widget.funcDataDTO,
                          xvtepDataDTO: widget.xvtepDataDTO,
                          compareBy: Constants.COMPARE_BY_EQUIP_FIX));
                  Navigator.pop(popContext);
                },
                child: Text(
                  Utils.getTranslated(
                      context, 'compare_popup_compareby_equipment_fixture')!,
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
          ),
          Visibility(
            visible: this.compareCountDTO!.data!.numberOfPanels!.toInt() > 1,
            child: Container(
              color: theme_dark!
                  ? AppColors.cupertinoBackground()
                  : AppColorsLightMode.cupertinoBackground().withOpacity(0.8),
              child: CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pushNamed(
                      context, AppRoutes.dqmTestResultCompareRoute,
                      arguments: DqmTestResultArguments(
                          analogDataDTO: widget.analogDataDTO,
                          pinsDataDTO: widget.pinDataDTO,
                          shortsDataDTO: widget.shortDataDTO,
                          vtepDataDTO: widget.vtepDataDTO,
                          funcDataDTO: widget.funcDataDTO,
                          xvtepDataDTO: widget.xvtepDataDTO,
                          compareBy: Constants.COMPARE_BY_PANEL));
                  Navigator.pop(popContext);
                },
                child: Text(
                  Utils.getTranslated(
                      context, 'compare_popup_compareby_panel')!,
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
          ),
          Visibility(
            visible: this.compareCountDTO!.data!.numberOfPanels!.toInt() > 1,
            child: Container(
              color: theme_dark!
                  ? AppColors.cupertinoBackground()
                  : AppColorsLightMode.cupertinoBackground().withOpacity(0.8),
              child: CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pushNamed(
                      context, AppRoutes.dqmTestResultCompareRoute,
                      arguments: DqmTestResultArguments(
                          analogDataDTO: widget.analogDataDTO,
                          pinsDataDTO: widget.pinDataDTO,
                          shortsDataDTO: widget.shortDataDTO,
                          vtepDataDTO: widget.vtepDataDTO,
                          funcDataDTO: widget.funcDataDTO,
                          xvtepDataDTO: widget.xvtepDataDTO,
                          compareBy: Constants.COMPARE_BY_ALL_PANEL));
                  Navigator.pop(popContext);
                },
                child: Text(
                  Utils.getTranslated(
                      context, 'compare_popup_compareby_all_panel')!,
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
              Navigator.pop(popContext);
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
