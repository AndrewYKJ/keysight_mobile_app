import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:keysight_pma/cache/appcache.dart';
import 'package:keysight_pma/const/appcolors.dart';
import 'package:keysight_pma/const/appfonts.dart';
import 'package:keysight_pma/const/constants.dart';
import 'package:keysight_pma/const/download.dart';
import 'package:keysight_pma/const/utils.dart';
import 'package:keysight_pma/controller/digital_quality/rma/anomaly_tab_failure.dart';
import 'package:keysight_pma/controller/digital_quality/rma/anomaly_tab_limit.dart';
import 'package:keysight_pma/controller/digital_quality/rma/anomaly_tab_measurement.dart';
import 'package:keysight_pma/dio/api/dqm.dart';
import 'package:keysight_pma/model/dqm/anomalies.dart';
import 'package:keysight_pma/model/dqm/anomaly_company.dart';

class DqmRmaResultInfoScreen extends StatefulWidget {
  final AnomalyCompanyDataDTO? anomalyCompanyDataDTO;
  DqmRmaResultInfoScreen({Key? key, this.anomalyCompanyDataDTO})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DqmRmaResultInfoScreen();
  }
}

class _DqmRmaResultInfoScreen extends State<DqmRmaResultInfoScreen> {
  int currentTab = 0;
  bool isLoading = true;
  AnomaliesDTO? anomaliesDTO;
  List<dynamic> tabList = [];

  bool? isDarkTheme = AppCache.sortFilterCacheDTO!.currentTheme;
  Future<AnomaliesDTO> getAnomalies(BuildContext context) {
    DqmApi dqmApi = DqmApi(context);
    return dqmApi.getAnomalies(
        widget.anomalyCompanyDataDTO!.companyId!,
        widget.anomalyCompanyDataDTO!.siteId!,
        widget.anomalyCompanyDataDTO!.serialNumber!,
        widget.anomalyCompanyDataDTO!.equipmentId!,
        widget.anomalyCompanyDataDTO!.projectId!,
        widget.anomalyCompanyDataDTO!.timestamp!,
        widget.anomalyCompanyDataDTO!.startTime!,
        widget.anomalyCompanyDataDTO!.endTime!);
  }

  @override
  void initState() {
    super.initState();
    Utils.setFirebaseAnalyticsCurrentScreen(
        Constants.ANALYTICS_DQM_RMA_ANOMALIES_SCREEN);
    if (widget.anomalyCompanyDataDTO != null) {
      callGetAnomalies(context);
    }
  }

  callGetAnomalies(BuildContext context) async {
    await getAnomalies(context).then((value) {
      if (value.status!.statusCode == 200) {
        this.anomaliesDTO = value;
        setTabBar();
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

  setTabBar() {
    if (this.anomaliesDTO != null && this.anomaliesDTO!.data != null) {
      this.tabList.clear();
      if (this.anomaliesDTO!.data!.measurementAnomaly != null &&
          this.anomaliesDTO!.data!.measurementAnomaly!.length > 0) {
        this.tabList.add({
          "name": "dqm_rma_result_info_anomaly_tab_measurement",
          "type": "measurement",
          "size": this.anomaliesDTO!.data!.measurementAnomaly!.length
        });
      }

      if (this.anomaliesDTO!.data!.limitChangeAnomaly != null &&
          this.anomaliesDTO!.data!.limitChangeAnomaly!.length > 0) {
        this.tabList.add({
          "name": "dqm_rma_result_info_anomaly_tab_limit_change",
          "type": "limit",
          "size": this.anomaliesDTO!.data!.limitChangeAnomaly!.length
        });
      }

      if (this.anomaliesDTO!.data!.failureComponents != null &&
          this.anomaliesDTO!.data!.failureComponents!.length > 0) {
        this.tabList.add({
          "name": "dqm_rma_result_info_anomaly_tab_failure",
          "type": "failure",
          "size": this.anomaliesDTO!.data!.failureComponents!.length
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDarkTheme!
            ? AppColors.serverAppBar()
            : AppColorsLightMode.serverAppBar(),
        centerTitle: true,
        title: Padding(
          padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
          child: Text(
            Utils.getTranslated(context, 'dqm_rma_result_info_appbar_title')!,
            style: AppFonts.robotoRegular(
              20,
              color: isDarkTheme!
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
            isDarkTheme!
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
          child: this.isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppColors.appBlue()),
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      testHistoryLabel(context),
                      testHistoryData(context),
                      divider(context),
                      anomalyInformationLabel(context),
                      anomalyTabBar(context),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget testHistoryLabel(BuildContext ctx) {
    return Container(
      margin: EdgeInsets.only(top: 20.0),
      child: Text(
        Utils.getTranslated(ctx, 'dqm_rma_result_info_test_history')!,
        style: AppFonts.robotoBold(
          18,
          color: isDarkTheme!
              ? AppColors.appPrimaryWhite()
              : AppColorsLightMode.appGrey(),
          decoration: TextDecoration.none,
        ),
      ),
    );
  }

  Widget testHistoryData(BuildContext ctx) {
    return Container(
      margin: EdgeInsets.only(top: 18.0),
      padding: EdgeInsets.fromLTRB(18.0, 14.0, 18.0, 14.0),
      decoration: BoxDecoration(
        color: isDarkTheme!
            ? AppColors.appBlackLight()
            : AppColorsLightMode.appGreyBA(),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                testHistorynfo(
                    context,
                    Utils.getTranslated(
                        ctx, 'dqm_rma_result_info_test_history_starttime')!,
                    '${DateFormat('dd MMM yyyy HH:mm:ss').format(DateTime.parse(widget.anomalyCompanyDataDTO!.startTime!))}'),
                SizedBox(height: 20.0),
                testHistorynfo(
                    context,
                    Utils.getTranslated(
                        ctx, 'dqm_rma_result_info_test_history_endtime')!,
                    '${DateFormat('dd MMM yyyy HH:mm:ss').format(DateTime.parse(widget.anomalyCompanyDataDTO!.endTime!))}'),
                SizedBox(height: 20.0),
                testHistorynfo(
                    context,
                    Utils.getTranslated(
                        ctx, 'dqm_rma_result_info_test_history_fixture')!,
                    '${widget.anomalyCompanyDataDTO!.fixtureId}'),
                SizedBox(height: 20.0),
                testHistorynfo(
                    context,
                    Utils.getTranslated(
                        ctx, 'dqm_rma_result_info_test_history_equipment')!,
                    '${widget.anomalyCompanyDataDTO!.equipmentName}'),
                SizedBox(height: 20.0),
                testHistorynfo(
                    context,
                    Utils.getTranslated(
                        ctx, 'dqm_rma_result_info_test_history_project')!,
                    '${widget.anomalyCompanyDataDTO!.projectId}'),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 10.0),
            padding: EdgeInsets.fromLTRB(14.0, 2.0, 14.0, 2.0),
            decoration: BoxDecoration(
              color: (widget.anomalyCompanyDataDTO!.status!.contains("PASS") ||
                      widget.anomalyCompanyDataDTO!.status!.contains("Pass") ||
                      widget.anomalyCompanyDataDTO!.status!.contains("pass"))
                  ? AppColors.appGreen60()
                  : AppColors.appRedE9(),
              borderRadius: BorderRadius.circular(2.0),
            ),
            child: (widget.anomalyCompanyDataDTO!.status!.contains("PASS") ||
                    widget.anomalyCompanyDataDTO!.status!.contains("Pass") ||
                    widget.anomalyCompanyDataDTO!.status!.contains("pass"))
                ? Text(
                    Utils.getTranslated(ctx, 'dqm_rma_passed')!,
                    style: AppFonts.robotoMedium(
                      12,
                      color: AppColors.appPrimaryWhite(),
                      decoration: TextDecoration.none,
                    ),
                  )
                : Text(
                    Utils.getTranslated(ctx, 'dqm_rma_failed')!,
                    style: AppFonts.robotoMedium(
                      12,
                      color: AppColors.appPrimaryWhite(),
                      decoration: TextDecoration.none,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget testHistorynfo(BuildContext ctx, String label, String value) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppFonts.robotoRegular(
            13,
            color: isDarkTheme!
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
            color: isDarkTheme!
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
      height: 1.0,
      margin: EdgeInsets.only(top: 20.0),
      color: isDarkTheme!
          ? AppColors.appDividerColor()
          : AppColorsLightMode.appDividerColor(),
    );
  }

  Widget anomalyInformationLabel(BuildContext ctx) {
    return Container(
      margin: EdgeInsets.only(top: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              Utils.getTranslated(ctx, 'dqm_rma_result_info_anomaly_info')!,
              style: AppFonts.robotoBold(
                18,
                color: isDarkTheme!
                    ? AppColors.appGreyB1()
                    : AppColorsLightMode.appGrey(),
                decoration: TextDecoration.none,
              ),
            ),
          ),
          InkWell(
            onTap: () {
              showDownloadPopup(ctx);
            },
            child: Image.asset(isDarkTheme!
                ? Constants.ASSET_IMAGES + 'download_bttn.png'
                : Constants.ASSET_IMAGES_LIGHT + 'download_bttn.png'),
          )
        ],
      ),
    );
  }

  Widget anomalyTabBar(BuildContext ctx) {
    if (this.tabList.length > 0) {
      return DefaultTabController(
        length: this.tabList.length,
        child: Builder(builder: (BuildContext tabContext) {
          final TabController tabController =
              DefaultTabController.of(tabContext)!;
          tabController.addListener(() {
            if (tabController.indexIsChanging) {
              setState(() {
                this.currentTab = tabController.index;
                Utils.printInfo(this.currentTab);
              });
            }
          });
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 25.0),
                child: TabBar(
                  indicatorColor: AppColors.appBlue(),
                  labelColor: AppColors.appBlue(),
                  labelStyle: AppFonts.robotoMedium(14),
                  unselectedLabelColor: isDarkTheme!
                      ? AppColors.appPrimaryWhite()
                      : AppColorsLightMode.appGrey(),
                  unselectedLabelStyle: AppFonts.robotoMedium(14),
                  tabs: this
                      .tabList
                      .map(
                        (e) => Tab(
                          text: Utils.getTranslated(ctx, e['name'])!,
                        ),
                      )
                      .toList(),
                ),
              ),
              SizedBox(height: 28.0),
              Container(
                height: (this.tabList[this.currentTab]['size'] * 60)
                            .toDouble() !=
                        0
                    ? (this.tabList[this.currentTab]['size'] * 60).toDouble()
                    : 300, //(this.tabList[this.currentTab]['size'] * 60).toDouble(),
                child: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  children: this
                      .tabList
                      .map((e) => e['type'] == "measurement"
                          ? AnomalyTabMeasurementScreen(
                              measurementAnomaly:
                                  this.anomaliesDTO!.data!.measurementAnomaly!,
                            )
                          : e['type'] == "limit"
                              ? AnomalyTabChangeLimitScreen(
                                  limitChangeAnomaly: this
                                      .anomaliesDTO!
                                      .data!
                                      .limitChangeAnomaly!,
                                  serialNumber: widget
                                      .anomalyCompanyDataDTO!.serialNumber,
                                )
                              : e['type'] == "failure"
                                  ? AnomalyTabFailureScreen(
                                      failureComponents: this
                                          .anomaliesDTO!
                                          .data!
                                          .failureComponents!,
                                      startTime: widget
                                          .anomalyCompanyDataDTO!.startTime,
                                      endTime:
                                          widget.anomalyCompanyDataDTO!.endTime,
                                      serialNumber: widget
                                          .anomalyCompanyDataDTO!.serialNumber,
                                    )
                                  : Container())
                      .toList(),
                ),
              ),
            ],
          );
        }),
      );
    }
    return Container();
  }

  void showDownloadPopup(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext popContext) => CupertinoActionSheet(
        actions: [
          Container(
            color: isDarkTheme!
                ? AppColors.cupertinoBackground()
                : AppColorsLightMode.cupertinoBackground().withOpacity(0.8),
            child: CupertinoActionSheetAction(
              onPressed: () async {
                Navigator.pop(popContext);
                //Anomaly Information_2022-08-10
                String curDate =
                    '${DateFormat('yyyy.MM.dd').format(DateTime.now())}';
                String name = Utils.getExportFilename(
                  'Anomaly Information',
                  currentDate: curDate,
                  expType: '.csv',
                );
                final result = await CSVApi.generateCSV(
                    anomaliesDTO!.data!.failureComponents!, name);
                if (result == true) {
                  setState(() {
                    var snackBar = SnackBar(
                      content: Text(
                        Utils.getTranslated(context, 'done_download_as_csv')!,
                        style: AppFonts.robotoRegular(
                          16,
                          color: isDarkTheme!
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
                  color: isDarkTheme!
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
              color: isDarkTheme!
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
                  color: isDarkTheme!
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
