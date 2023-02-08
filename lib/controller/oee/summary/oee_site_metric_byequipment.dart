import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:keysight_pma/cache/appcache.dart';
import 'package:keysight_pma/const/appcolors.dart';
import 'package:keysight_pma/const/appfonts.dart';
import 'package:keysight_pma/const/constants.dart';
import 'package:keysight_pma/const/download.dart';
import 'package:keysight_pma/const/utils.dart';
import 'package:keysight_pma/model/arguments/oee_argument.dart';
import 'package:keysight_pma/model/dqm/custom.dart';
import 'package:keysight_pma/model/oee/oeeNotif.dart';
import 'package:keysight_pma/model/oee/oeeSummaryPerformance.dart';
import 'package:keysight_pma/model/oee/oeeSummaryQuality.dart';
import 'package:keysight_pma/routes/approutes.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

import '../../../dio/api/oee.dart';
import '../../../model/oee/oeeSummary.dart';

class OEESiteMetricByEquipment extends StatefulWidget {
  final int currentTab;
  final String selectedCompany;
  final String selectedSite;
  final String selectedEquipment;
  OEESiteMetricByEquipment(
      {Key? key,
      required this.currentTab,
      required this.selectedEquipment,
      required this.selectedCompany,
      required this.selectedSite})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _OEESiteMetricByEquipment();
  }
}

class _OEESiteMetricByEquipment extends State<OEESiteMetricByEquipment> {
  int currentTab = 0;

  //chart setting

  double chartheight = 316.0;
  double chartavailabletimeheight = 316.0;

  double chartutilheight = 316.0;

  double chartplannedDowntimeheight = 316.0;

  double chartavailabilityheight = 316.0;
  //available
  late WebViewPlusController utilController;
  late WebViewPlusController availableTimeController;
  late WebViewPlusController plannedDownTimeController;
  late WebViewPlusController availabilityController;
  String avalableTimeStamp = '';
  bool? theme_dark = AppCache.sortFilterCacheDTO!.currentTheme;
  List<DqmXaxisRangeDTO> oeeAxisRangeList = [
    DqmXaxisRangeDTO(
        rangeName: '1M',
        rangeValue: Constants.RANGE_1_MONTH,
        isAvailable: false,
        isSelected: false),
    DqmXaxisRangeDTO(
        rangeName: '3M',
        rangeValue: Constants.RANGE_3_MONTH,
        isAvailable: false,
        isSelected: false),
    DqmXaxisRangeDTO(
        rangeName: '6M',
        rangeValue: Constants.RANGE_6_MONTH,
        isAvailable: false,
        isSelected: false),
    DqmXaxisRangeDTO(
        rangeName: 'YTD',
        rangeValue: Constants.RANGE_YTD,
        isAvailable: true,
        isSelected: false),
    DqmXaxisRangeDTO(
        rangeName: '1Y',
        rangeValue: Constants.RANGE_1_YEAR,
        isAvailable: false,
        isSelected: false),
    DqmXaxisRangeDTO(
        rangeName: 'ALL',
        rangeValue: Constants.RANGE_ALL,
        isAvailable: true,
        isSelected: true),
  ];

  late DateTime startDate;
  late DateTime endDate;
  String title = '';
  bool isLoading = true;
  OeeInstallbaseNotifDTO oeeDUTdata = OeeInstallbaseNotifDTO();
  OeeSummaryDTO availableDTO = OeeSummaryDTO();
  Future<OeeInstallbaseNotifDTO> getInstallbasNotificationBadge(
      BuildContext context) {
    OeeApi oeeApi = OeeApi(context);
    return oeeApi.getInstallbasNotificationBadge(
      widget.selectedCompany,
      widget.selectedSite,
    );
  }

  OeeSummaryDTO getAvailabilityBySiteDTO = OeeSummaryDTO();
  Future<OeeSummaryDTO> getDailyAvailabilityForEquipment(
      BuildContext context, DateTime startDate, DateTime endDate) {
    OeeApi oeeApi = OeeApi(context);
    return oeeApi.getDailyAvailabilityForEquipment(
        widget.selectedCompany,
        widget.selectedSite,
        widget.selectedEquipment,
        DateFormat("yyyy-MM-dd").format(startDate),
        DateFormat("yyyy-MM-dd").format(endDate));
  }

  OeePerformanceDTO getPerformanceBySiteDTO = OeePerformanceDTO();
  Future<OeePerformanceDTO> getDailyPerformanceForEquipment(
      BuildContext context, DateTime startDate, DateTime endDate) {
    OeeApi oeeApi = OeeApi(context);
    return oeeApi.getDailyPerformanceForEquipment(
        widget.selectedCompany,
        widget.selectedSite,
        widget.selectedEquipment,
        DateFormat("yyyy-MM-dd").format(startDate),
        DateFormat("yyyy-MM-dd").format(endDate));
  }

  OeeQualityDTO getQualityBySiteDTO = OeeQualityDTO();
  Future<OeeQualityDTO> getDailyQualityForEquipment(
      BuildContext context, DateTime startDate, DateTime endDate) {
    OeeApi oeeApi = OeeApi(context);
    return oeeApi.getDailyQualityForEquipment(
        widget.selectedCompany,
        widget.selectedSite,
        widget.selectedEquipment,
        DateFormat("yyyy-MM-dd").format(startDate),
        DateFormat("yyyy-MM-dd").format(endDate));
  }

  @override
  void initState() {
    super.initState();
    Utils.setFirebaseAnalyticsCurrentScreen(
        Constants.ANALYTICS_OEE_SUMMARY_AVAILABILITY_METRIC_BY_EQUIP_SCREEN);
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      currentTab = widget.currentTab;
    });
    callListSiteOEE(context);
    // callDashboardApi(AppCache.sortFilterCacheDTO!.startDate!,
    //     AppCache.sortFilterCacheDTO!.endDate!, currentTab);
  }

  List<String> getDaysInBetween(DateTime startDate, DateTime endDate) {
    List<String> days = [];
    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      days.add(
          DateFormat('yyyy-MM-dd').format(startDate.add(Duration(days: i))));
    }
    return days;
  }

  checkRange() {
    int yearsDifference = this.endDate.year - this.startDate.year;

    int monthsDifference = (this.endDate.year - this.startDate.year) * 12 +
        this.endDate.month -
        this.startDate.month;
    if (monthsDifference >= 1) {
      oeeAxisRangeList[0].isAvailable = true;
    } else {
      oeeAxisRangeList[0].isAvailable = false;
    }

    if (monthsDifference >= 3) {
      oeeAxisRangeList[1].isAvailable = true;
    } else {
      oeeAxisRangeList[1].isAvailable = false;
    }

    if (monthsDifference >= 6) {
      oeeAxisRangeList[2].isAvailable = true;
    } else {
      oeeAxisRangeList[2].isAvailable = false;
    }

    if (yearsDifference > 0) {
      oeeAxisRangeList[4].isAvailable = true;
    } else {
      oeeAxisRangeList[4].isAvailable = false;
    }
    print('checkRangeDone');
  }

  callListSiteOEE(BuildContext context) async {
    await getInstallbasNotificationBadge(context).then((value) {
      oeeDUTdata = value;
      print(oeeDUTdata);
    }).catchError((error) {
      Utils.printInfo(error);
    });

    if (currentTab == 0) {
      await getDailyAvailabilityForEquipment(
              context,
              AppCache.sortFilterCacheDTO!.startDate!,
              AppCache.sortFilterCacheDTO!.endDate!)
          .then((value) {
        getAvailabilityBySiteDTO = value;
        //print(oeeDUTdata);
      }).catchError((error) {
        Utils.printInfo(error);
      }).whenComplete(() {});
    }
    if (currentTab == 2) {
      await getDailyPerformanceForEquipment(
              context,
              AppCache.sortFilterCacheDTO!.startDate!,
              AppCache.sortFilterCacheDTO!.endDate!)
          .then((value) {
        getPerformanceBySiteDTO = value;
        //print(oeeDUTdata);
      }).catchError((error) {
        Utils.printInfo(error);
      }).whenComplete(() {});
    }
    if (currentTab == 1) {
      await getDailyQualityForEquipment(
              context,
              AppCache.sortFilterCacheDTO!.startDate!,
              AppCache.sortFilterCacheDTO!.endDate!)
          .then((value) {
        getQualityBySiteDTO = value;
        //print(oeeDUTdata);
      }).catchError((error) {
        Utils.printInfo(error);
      }).whenComplete(() {});
    }
    setState(() {
      this.isLoading = false;
      this.startDate = AppCache.sortFilterCacheDTO!.startDate!;
      this.endDate = AppCache.sortFilterCacheDTO!.endDate!;
      checkRange();
      print('@#%^&*(@#%^&*#%^&*(');
    });
  }

  callDashboardApi(DateTime startDate, DateTime endDate, int currentTab) async {
    EasyLoading.show(maskType: EasyLoadingMaskType.black);
    if (currentTab == 0) {
      await getDailyAvailabilityForEquipment(
              context,
              AppCache.sortFilterCacheDTO!.startDate!,
              AppCache.sortFilterCacheDTO!.endDate!)
          .then((value) {
        getAvailabilityBySiteDTO = value;
        //print(oeeDUTdata);
      }).catchError((error) {
        Utils.printInfo(error);
      }).whenComplete(() {
        EasyLoading.dismiss();
      });
    }
    if (currentTab == 2) {
      await getDailyPerformanceForEquipment(
              context,
              AppCache.sortFilterCacheDTO!.startDate!,
              AppCache.sortFilterCacheDTO!.endDate!)
          .then((value) {
        getPerformanceBySiteDTO = value;
        //print(oeeDUTdata);
      }).catchError((error) {
        Utils.printInfo(error);
      }).whenComplete(() {
        EasyLoading.dismiss();
      });
    }
    if (currentTab == 1) {
      await getDailyQualityForEquipment(
              context,
              AppCache.sortFilterCacheDTO!.startDate!,
              AppCache.sortFilterCacheDTO!.endDate!)
          .then((value) {
        getQualityBySiteDTO = value;
        //print(oeeDUTdata);
      }).catchError((error) {
        Utils.printInfo(error);
      }).whenComplete(() {
        EasyLoading.dismiss();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (currentTab == 0) {
      title = widget.selectedEquipment +
          Utils.getTranslated(context, 'oee_availability_metric')!;
    } else if (currentTab == 1) {
      title = widget.selectedEquipment +
          Utils.getTranslated(context, 'oee_quality_metric')!;
    } else if (currentTab == 2) {
      title = widget.selectedEquipment +
          Utils.getTranslated(context, 'oee_performance_metric')!;
    }
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Image.asset(theme_dark!
              ? Constants.ASSET_IMAGES + 'back_bttn.png'
              : Constants.ASSET_IMAGES_LIGHT + 'back_bttn.png'),
        ),
        centerTitle: true,
        title: Text(
          title,
          style: AppFonts.robotoRegular(
            20,
            color: theme_dark!
                ? AppColors.appGrey()
                : AppColorsLightMode.appGrey(),
            decoration: TextDecoration.none,
          ),
        ),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.appBlue()),
              ),
            )
          : Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    header(context),
                    siteAvailabilityMetricChart(context),
                    siteMetric(context, currentTab)
                  ],
                ),
              ),
            ),
    );
  }

  Widget siteMetric(BuildContext ctx, int tab) {
    if (tab == 0) {
      return Column(
        children: [
          ultiisationTime(ctx),
          availableTime(ctx),
          plannedDownTime(ctx),
          availability(ctx),
        ],
      );
    } else if (tab == 1) {
      return Column(
        children: [
          qualityretestpassfail(ctx),
          firstpassyield(ctx),
          yield(ctx),
          qualitymetric(ctx),
        ],
      );
    } else if (tab == 2) {
      return Column(
        children: [
          performanceretestpassfail(context),
          firstpass(context),
          idealcycle(context),
          performance(context),
        ],
      );
    }
    return Container();
  }

  Widget header(BuildContext ctx) {
    return Container(
      width: MediaQuery.of(ctx).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Utils.getTranslated(ctx, 'this_week')!,
            style: AppFonts.robotoMedium(
              14,
              color: theme_dark!
                  ? AppColors.appPrimaryWhite()
                  : AppColorsLightMode.appGrey70(),
              decoration: TextDecoration.none,
            ),
          ),
          SizedBox(height: 17.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              headerItem(
                  ctx,
                  oeeDUTdata.data!.DUTComponentAnomaly!.toString(),
                  Utils.getTranslated(ctx, 'dqm_summary_component_anomaly')!,
                  AppColors.appDarkRed()),
              SizedBox(width: 20.0),
              headerItem(
                  ctx,
                  oeeDUTdata.data!.DUTDegradationAnomaly!.toString(),
                  Utils.getTranslated(ctx, 'dqm_summary_degradation_anomaly')!,
                  AppColors.appIvoryWhite()),
            ],
          ),
          SizedBox(height: 17.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              headerItem(
                  ctx,
                  oeeDUTdata.data!.DUTLimitChangeAnomaly!.toString(),
                  Utils.getTranslated(ctx, 'dqm_summary_limit_change')!,
                  AppColors.appYellowLight()),
              SizedBox(width: 20.0),
              headerItem(
                  ctx,
                  oeeDUTdata.data!.DUTCpkAlertAnomalies!.toString(),
                  Utils.getTranslated(ctx, 'dqm_summary_low_cpk')!,
                  AppColors.appYellowLight()),
            ],
          )
        ],
      ),
    );
  }

  Widget headerItem(
      BuildContext ctx, String value, String label, Color bgColor) {
    return Expanded(
      child: Container(
        height: 65.0,
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              value,
              style: AppFonts.robotoBold(
                23,
                color: Colors.black,
                decoration: TextDecoration.none,
              ),
            ),
            Text(
              label,
              style: AppFonts.robotoRegular(
                12,
                color: Colors.black,
                decoration: TextDecoration.none,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget siteAvailabilityMetricChart(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 34.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: AppFonts.robotoRegular(
                    16,
                    color: theme_dark!
                        ? AppColors.appGrey2()
                        : AppColorsLightMode.appGrey(),
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  showDownloadPopup(context);
                },
                child: Image.asset(
                  theme_dark!
                      ? Constants.ASSET_IMAGES + 'download_bttn.png'
                      : Constants.ASSET_IMAGES_LIGHT + 'download_bttn.png',
                ),
              )
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 39.0),
            height: 30.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: oeeAxisRangeList.length,
              itemBuilder: (BuildContext context, int index) {
                return rangeItem(context, oeeAxisRangeList[index], index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget rangeItem(
      BuildContext context, DqmXaxisRangeDTO dqmXaxisRangeDTO, int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            print('here');
            oeeAxisRangeList.forEach((element) {
              element.isSelected = false;
            });
            if (dqmXaxisRangeDTO.isAvailable!) {
              int yearsDifference = AppCache.sortFilterCacheDTO!.endDate!.year -
                  AppCache.sortFilterCacheDTO!.startDate!.year;

              int monthsDifference =
                  (AppCache.sortFilterCacheDTO!.endDate!.year -
                              AppCache.sortFilterCacheDTO!.startDate!.year) *
                          12 +
                      AppCache.sortFilterCacheDTO!.endDate!.month -
                      AppCache.sortFilterCacheDTO!.startDate!.month;

              // int totalDays = AppCache.sortFilterCacheDTO!.endDate!
              //     .difference(AppCache.sortFilterCacheDTO!.startDate!)
              //     .inDays;

              if (dqmXaxisRangeDTO.rangeValue == Constants.RANGE_1_MONTH) {
                if (monthsDifference >= 1) {
                  dqmXaxisRangeDTO.isSelected = true;
                  this.startDate = new DateTime(
                    AppCache.sortFilterCacheDTO!.endDate!.year,
                    AppCache.sortFilterCacheDTO!.endDate!.month - 1,
                    AppCache.sortFilterCacheDTO!.endDate!.day,
                  );
                  this.endDate = AppCache.sortFilterCacheDTO!.endDate!;
                  callDashboardApi(
                      this.startDate, this.endDate, this.currentTab);
                }
              } else if (dqmXaxisRangeDTO.rangeValue ==
                  Constants.RANGE_3_MONTH) {
                if (monthsDifference >= 3) {
                  dqmXaxisRangeDTO.isSelected = true;
                  this.startDate = new DateTime(
                    AppCache.sortFilterCacheDTO!.endDate!.year,
                    AppCache.sortFilterCacheDTO!.endDate!.month - 2,
                    AppCache.sortFilterCacheDTO!.endDate!.day,
                  );
                  this.endDate = AppCache.sortFilterCacheDTO!.endDate!;
                  callDashboardApi(
                      this.startDate, this.endDate, this.currentTab);
                }
              } else if (dqmXaxisRangeDTO.rangeValue ==
                  Constants.RANGE_6_MONTH) {
                if (monthsDifference >= 6) {
                  dqmXaxisRangeDTO.isSelected = true;
                  this.startDate = new DateTime(
                    AppCache.sortFilterCacheDTO!.endDate!.year,
                    AppCache.sortFilterCacheDTO!.endDate!.month - 4,
                    AppCache.sortFilterCacheDTO!.endDate!.day,
                  );
                  this.endDate = AppCache.sortFilterCacheDTO!.endDate!;
                  callDashboardApi(
                      this.startDate, this.endDate, this.currentTab);
                }
              } else if (dqmXaxisRangeDTO.rangeValue == Constants.RANGE_YTD) {
                dqmXaxisRangeDTO.isSelected = true;
                this.startDate = new DateTime(
                  AppCache.sortFilterCacheDTO!.endDate!.year,
                  AppCache.sortFilterCacheDTO!.endDate!.month -
                      monthsDifference,
                  1,
                );
                this.endDate = AppCache.sortFilterCacheDTO!.endDate!;
                callDashboardApi(this.startDate, this.endDate, this.currentTab);
              } else if (dqmXaxisRangeDTO.rangeValue ==
                  Constants.RANGE_1_YEAR) {
                if (yearsDifference > 0) {
                  dqmXaxisRangeDTO.isSelected = true;
                  this.startDate = new DateTime(
                    AppCache.sortFilterCacheDTO!.endDate!.year - 1,
                    AppCache.sortFilterCacheDTO!.endDate!.month,
                    AppCache.sortFilterCacheDTO!.endDate!.day,
                  );
                  this.endDate = AppCache.sortFilterCacheDTO!.endDate!;
                  callDashboardApi(
                      this.startDate, this.endDate, this.currentTab);
                }
              } else {
                dqmXaxisRangeDTO.isSelected = true;
                this.startDate = AppCache.sortFilterCacheDTO!.startDate!;
                this.endDate = AppCache.sortFilterCacheDTO!.endDate!;
                callDashboardApi(this.startDate, this.endDate, this.currentTab);
              }
              setState(() {
                this.utilController.webViewController.reload();
                this.availableTimeController.webViewController.reload();
                this.plannedDownTimeController.webViewController.reload();
                this.availabilityController.webViewController.reload();
              });
            }
          },
          child: Container(
            width: 60.0,
            padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
            decoration: BoxDecoration(
              color:
                  dqmXaxisRangeDTO.isAvailable! && dqmXaxisRangeDTO.isSelected!
                      ? AppColors.appPrimaryYellow()
                      : !dqmXaxisRangeDTO.isAvailable!
                          ? AppColors.appMediumGrey()
                          : Colors.transparent,
              border:
                  dqmXaxisRangeDTO.isAvailable! && dqmXaxisRangeDTO.isSelected!
                      ? Border.all(color: Colors.transparent)
                      : !dqmXaxisRangeDTO.isAvailable!
                          ? Border.all(color: AppColors.appMediumGrey())
                          : Border.all(color: AppColors.appMediumGrey()),
              borderRadius: BorderRadius.circular(50.0),
            ),
            child: Center(
              child: Text(
                dqmXaxisRangeDTO.rangeName!,
                style: AppFonts.sfproBold(
                  11,
                  color: dqmXaxisRangeDTO.isAvailable! &&
                          dqmXaxisRangeDTO.isSelected!
                      ? AppColors.appPrimaryWhite()
                      : theme_dark!
                          ? AppColors.appPrimaryWhite()
                          : AppColorsLightMode.appGrey70(),
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          ),
        ),
        index < oeeAxisRangeList.length ? SizedBox(width: 16.0) : Container(),
      ],
    );
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
                    .utilController
                    .webViewController
                    .runJavascript('exportImage()');

                this
                    .availableTimeController
                    .webViewController
                    .runJavascript('exportImage()');

                this
                    .plannedDownTimeController
                    .webViewController
                    .runJavascript('exportImage()');

                this
                    .availabilityController
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

                var object = [];
                String name = ".csv";

                if (currentTab == 0) {
                  name = 'oeeSummaryAvailability.csv';
                  getAvailabilityBySiteDTO.data!.forEach((element) {
                    object.add({
                      "date": element.date,
                      "Available Time": element.availableTime,
                      "Utilization Time": (element.utilizationTime),
                      "Planned Down Time": element.plannedDownTime,
                      "Availability": element.availability,
                    });
                  });
                } else if (currentTab == 1) {
                  name = 'oeeSummaryQuality.csv';
                  getQualityBySiteDTO.data!.forEach((element) {
                    object.add({
                      "date": element.date,
                      "Failed  Count": element.failedCount,
                      "Retest Count": (element.retestCount),
                      "First Pass Yield (%)": ((element.firstPassCount!) /
                          (element.firstPassCount! +
                              element.retestCount! +
                              element.failedCount!)),
                      "Yield (%)":
                          ((element.firstPassCount! + element.retestCount!) /
                              (element.firstPassCount! +
                                  element.retestCount! +
                                  element.failedCount!)),
                      "Performance": element.quality
                    });
                  });
                } else if (currentTab == 2) {
                  name = 'oeeSummaryPerformance.csv';
                  getPerformanceBySiteDTO.data!.forEach((element) {
                    object.add({
                      "date": element.date,
                      "Fail Utilization Time": element.failUtilizationTime,
                      "Retest Utilization Time":
                          (element.retestUtilizationTime),
                      "First Pass Utilization Time":
                          element.firstPassUtilizationTime,
                      "Ideal Cycle": element.idealCycleTime,
                      "Performance": element.performance
                    });
                  });
                }

                final result = await CSVApi.generateSummaryCSV(
                    object, name, 1200, widget.selectedEquipment, null);
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
                    .utilController
                    .webViewController
                    .runJavascript('exportPDF()');

                this
                    .availableTimeController
                    .webViewController
                    .runJavascript('exportPDF()');

                this
                    .plannedDownTimeController
                    .webViewController
                    .runJavascript('exportPDF()');

                this
                    .availabilityController
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
                : AppColorsLightMode.cupertinoBackground().withOpacity(0.8),
            borderRadius: BorderRadius.circular(10),
          ),
          child: CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(downloadContext);
            },
            child: Text(
              Utils.getTranslated(context, 'cancel')!,
              style: AppFonts.robotoMedium(
                15,
                color: theme_dark!
                    ? AppColors.appPrimaryWhite().withOpacity(0.8)
                    : AppColorsLightMode.appCancelBlue(),
                decoration: TextDecoration.none,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  Widget ultiisationTime(BuildContext ctx) {
    return Container(
      margin: EdgeInsets.only(top: 37.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  Utils.getTranslated(ctx, 'oee_ultilisation_time')!,
                  style: AppFonts.robotoMedium(
                    14,
                    color: theme_dark!
                        ? AppColors.appPrimaryWhite()
                        : AppColorsLightMode.appGrey(),
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  if (getAvailabilityBySiteDTO.data != null &&
                      getAvailabilityBySiteDTO.data!.length > 0) {
                    Navigator.pushNamed(
                      ctx,
                      AppRoutes.oeeSummarySiteMetricbyProject,
                      arguments: OeeChartDetailArguments(
                          chartName: Utils.getTranslated(
                              context, 'oee_totalUtilizationTimebyProject')!,
                          dataType: '0',
                          selectedEquipment: widget.selectedEquipment,
                          selectedCompany: widget.selectedCompany,
                          selectedSite: widget.selectedSite,
                          currentTab: currentTab),
                    );
                  }
                },
                child: Image.asset(theme_dark!
                    ? Constants.ASSET_IMAGES + 'next_bttn_withbg.png'
                    : Constants.ASSET_IMAGES_LIGHT + 'next_bttn_withbg.png'),
              ),
            ],
          ),
          (getAvailabilityBySiteDTO.data != null &&
                  getAvailabilityBySiteDTO.data!.length > 0)
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  height: this.chartutilheight,
                  color: Colors.transparent,
                  child: WebViewPlus(
                    backgroundColor: Colors.transparent,
                    javascriptMode: JavascriptMode.unrestricted,
                    initialUrl: theme_dark!
                        ? 'assets/html/oee_highchart_dark_theme.html'
                        : 'assets/html/oee_highchart_light_theme.html',
                    zoomEnabled: false,
                    onWebViewCreated: (controllerPlus) {
                      this.utilController = controllerPlus;
                    },
                    onPageFinished: (url) {
                      this.utilController.getHeight().then((value) {
                        Utils.printInfo(value);
                        setState(() {
                          if (getAvailabilityBySiteDTO.data != null &&
                              getAvailabilityBySiteDTO.data!.length > 0) {
                            this.chartutilheight = value;
                          } else {
                            this.chartutilheight = 0;
                          }
                        });
                      });
                    },
                    javascriptChannels: [
                      JavascriptChannel(
                          name: 'OEEChannel',
                          onMessageReceived: (message) {
                            print(message.message);
                            if (getAvailabilityBySiteDTO.data != null &&
                                getAvailabilityBySiteDTO.data!.length > 0) {
                              this.utilController.webViewController.runJavascript(
                                  'fetchSummaryUtilTime(${jsonEncode(this.getAvailabilityBySiteDTO)}, "${DateFormat("yyyy-MM-dd").format(this.startDate)}", "${DateFormat("yyyy-MM-dd").format(this.endDate)}", ${jsonEncode(getDaysInBetween(this.startDate, this.endDate))})');
                            }
                          }),
                      JavascriptChannel(
                          name: 'OEEUtilTimeChannel',
                          onMessageReceived: (message) {
                            print(message.message);
                            setState(() {
                              avalableTimeStamp = message.message;
                            });
                            // if (Utils.isNotEmpty(message.message)) {
                            //   JSMetricQualityDataDTO qmDTO =
                            //       JSMetricQualityDataDTO.fromJson(
                            //           jsonDecode(message.message));
                            showTooltipsDialog(ctx);
                            // }
                          }),
                      JavascriptChannel(
                          name: 'DQMExportImageChannel',
                          onMessageReceived: (message) async {
                            print(message.message);
                            if (Utils.isNotEmpty(message.message)) {
                              String name = 'summaryOEEUtil.png';

                              final result =
                                  await ImageApi.generateSummaryImage(
                                      message.message,
                                      600,
                                      this.chartutilheight.round(),
                                      1200,
                                      widget.selectedEquipment,
                                      null,
                                      name);
                              if (result != null && result == true) {
                                setState(() {
                                  // print('################## hihi');
                                  isLoading = false;
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
                              String name = 'summaryOEEUtil.pdf';

                              final result = await PdfApi.generateSummaryPDF(
                                  message.message,
                                  600,
                                  this.chartutilheight.round(),
                                  1200,
                                  widget.selectedEquipment,
                                  null,
                                  name);
                              if (result != null && result == true) {
                                setState(() {
                                  // print('################## hihi');
                                  isLoading = false;
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
                  ),
                )
              : Container(
                  height: 350,
                  child: Center(
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
                ),
        ],
      ),
    );
  }

  Widget availableTime(BuildContext ctx) {
    return Container(
      margin: EdgeInsets.only(top: 37.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  Utils.getTranslated(ctx, 'oee_available_time')!,
                  style: AppFonts.robotoMedium(
                    14,
                    color: theme_dark!
                        ? AppColors.appPrimaryWhite()
                        : AppColorsLightMode.appGrey(),
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  if (getAvailabilityBySiteDTO.data != null &&
                      getAvailabilityBySiteDTO.data!.length > 0) {
                    Navigator.pushNamed(
                      ctx,
                      AppRoutes.oeeSummarySiteMetricbyProject,
                      arguments: OeeChartDetailArguments(
                          chartName: Utils.getTranslated(
                              context, 'oee_totalAvailableTimebyProject')!,
                          dataType: '1',
                          selectedEquipment: widget.selectedEquipment,
                          selectedCompany: widget.selectedCompany,
                          selectedSite: widget.selectedSite,
                          currentTab: currentTab),
                    );
                  }
                },
                child: Image.asset(theme_dark!
                    ? Constants.ASSET_IMAGES + 'next_bttn_withbg.png'
                    : Constants.ASSET_IMAGES_LIGHT + 'next_bttn_withbg.png'),
              ),
            ],
          ),
          (getAvailabilityBySiteDTO.data != null &&
                  getAvailabilityBySiteDTO.data!.length > 0)
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  height: this.chartavailabletimeheight,
                  color: Colors.transparent,
                  child: WebViewPlus(
                    backgroundColor: Colors.transparent,
                    javascriptMode: JavascriptMode.unrestricted,
                    initialUrl: theme_dark!
                        ? 'assets/html/oee_highchart_dark_theme.html'
                        : 'assets/html/oee_highchart_light_theme.html',
                    zoomEnabled: false,
                    onWebViewCreated: (controllerPlus) {
                      this.availableTimeController = controllerPlus;
                    },
                    onPageFinished: (url) {
                      this.availableTimeController.getHeight().then((value) {
                        Utils.printInfo(value);
                        setState(() {
                          if (getAvailabilityBySiteDTO.data != null &&
                              getAvailabilityBySiteDTO.data!.length > 0) {
                            this.chartavailabletimeheight = value;
                          } else {
                            this.chartavailabletimeheight = 0;
                          }
                        });
                      });
                    },
                    javascriptChannels: [
                      JavascriptChannel(
                          name: 'OEEChannel',
                          onMessageReceived: (message) {
                            print(message.message);
                            if (getAvailabilityBySiteDTO.data != null &&
                                getAvailabilityBySiteDTO.data!.length > 0) {
                              this
                                  .availableTimeController
                                  .webViewController
                                  .runJavascript(
                                      'fetchSummaryAvailableTime(${jsonEncode(this.getAvailabilityBySiteDTO)}, "${DateFormat("yyyy-MM-dd").format(this.startDate)}", "${DateFormat("yyyy-MM-dd").format(this.endDate)}", ${jsonEncode(getDaysInBetween(this.startDate, this.endDate))})');
                            }
                          }),
                      JavascriptChannel(
                          name: 'OEEAvailableTimeChannel',
                          onMessageReceived: (message) {
                            print(message.message);
                            setState(() {
                              avalableTimeStamp = message.message;
                            });
                            // if (Utils.isNotEmpty(message.message)) {
                            //   JSMetricQualityDataDTO qmDTO =
                            //       JSMetricQualityDataDTO.fromJson(
                            //           jsonDecode(message.message));
                            showTooltipsDialog(ctx);
                            // }
                          }),
                      JavascriptChannel(
                          name: 'DQMExportImageChannel',
                          onMessageReceived: (message) async {
                            print(message.message);
                            if (Utils.isNotEmpty(message.message)) {
                              String name = 'summaryOEEAvailableTime.png';

                              final result =
                                  await ImageApi.generateSummaryImage(
                                      message.message,
                                      600,
                                      this.chartavailabletimeheight.round(),
                                      1200,
                                      widget.selectedEquipment,
                                      null,
                                      name);
                              if (result != null && result == true) {
                                setState(() {
                                  // print('################## hihi');
                                  isLoading = false;
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
                              String name = 'summaryOEEAvailableTime.pdf';

                              final result = await PdfApi.generateSummaryPDF(
                                  message.message,
                                  600,
                                  this.chartavailabletimeheight.round(),
                                  1200,
                                  widget.selectedEquipment,
                                  null,
                                  name);
                              if (result != null && result == true) {
                                setState(() {
                                  // print('################## hihi');
                                  isLoading = false;
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
                  ),
                )
              : Container(
                  height: 350,
                  child: Center(
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
                ),
        ],
      ),
    );
  }

  Widget plannedDownTime(BuildContext ctx) {
    return Container(
      margin: EdgeInsets.only(top: 37.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  Utils.getTranslated(ctx, 'oee_plannedDownTime')!,
                  style: AppFonts.robotoMedium(
                    14,
                    color: theme_dark!
                        ? AppColors.appPrimaryWhite()
                        : AppColorsLightMode.appGrey(),
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  if (getAvailabilityBySiteDTO.data != null &&
                      getAvailabilityBySiteDTO.data!.length > 0) {
                    Navigator.pushNamed(
                      ctx,
                      AppRoutes.oeeSummarySiteMetricbyProject,
                      arguments: OeeChartDetailArguments(
                          chartName: Utils.getTranslated(
                              context, 'oee_totalPlannedTimebyProject')!,
                          dataType: '2',
                          selectedEquipment: widget.selectedEquipment,
                          selectedCompany: widget.selectedCompany,
                          selectedSite: widget.selectedSite,
                          currentTab: currentTab),
                    );
                  }
                },
                child: Image.asset(theme_dark!
                    ? Constants.ASSET_IMAGES + 'next_bttn_withbg.png'
                    : Constants.ASSET_IMAGES_LIGHT + 'next_bttn_withbg.png'),
              ),
            ],
          ),
          (getAvailabilityBySiteDTO.data != null &&
                  getAvailabilityBySiteDTO.data!.length > 0)
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  height: this.chartplannedDowntimeheight,
                  color: Colors.transparent,
                  child: WebViewPlus(
                    backgroundColor: Colors.transparent,
                    javascriptMode: JavascriptMode.unrestricted,
                    initialUrl: theme_dark!
                        ? 'assets/html/oee_highchart_dark_theme.html'
                        : 'assets/html/oee_highchart_light_theme.html',
                    zoomEnabled: false,
                    onWebViewCreated: (controllerPlus) {
                      this.plannedDownTimeController = controllerPlus;
                    },
                    onPageFinished: (url) {
                      this.plannedDownTimeController.getHeight().then((value) {
                        Utils.printInfo(value);
                        setState(() {
                          if (getAvailabilityBySiteDTO.data != null &&
                              getAvailabilityBySiteDTO.data!.length > 0) {
                            this.chartplannedDowntimeheight = value;
                          } else {
                            this.chartplannedDowntimeheight = 0;
                          }
                        });
                      });
                    },
                    javascriptChannels: [
                      JavascriptChannel(
                          name: 'OEEChannel',
                          onMessageReceived: (message) {
                            print(message.message);
                            if (getAvailabilityBySiteDTO.data != null &&
                                getAvailabilityBySiteDTO.data!.length > 0) {
                              this
                                  .plannedDownTimeController
                                  .webViewController
                                  .runJavascript(
                                      'fetchSummaryPlannedDownTime(${jsonEncode(this.getAvailabilityBySiteDTO)}, "${DateFormat("yyyy-MM-dd").format(this.startDate)}", "${DateFormat("yyyy-MM-dd").format(this.endDate)}", ${jsonEncode(getDaysInBetween(this.startDate, this.endDate))})');
                            }
                          }),
                      JavascriptChannel(
                          name: 'OEEPlannedDTMChannel',
                          onMessageReceived: (message) {
                            setState(() {
                              avalableTimeStamp = message.message;
                            });
                            // if (Utils.isNotEmpty(message.message)) {
                            //   JSMetricQualityDataDTO qmDTO =
                            //       JSMetricQualityDataDTO.fromJson(
                            //           jsonDecode(message.message));
                            showTooltipsDialog(ctx);
                            // }
                          }),
                      JavascriptChannel(
                          name: 'DQMExportImageChannel',
                          onMessageReceived: (message) async {
                            print(message.message);
                            if (Utils.isNotEmpty(message.message)) {
                              String name = 'summaryOEEPlannedDTM.png';

                              final result =
                                  await ImageApi.generateSummaryImage(
                                      message.message,
                                      600,
                                      this.chartavailabilityheight.round(),
                                      1200,
                                      widget.selectedEquipment,
                                      null,
                                      name);
                              if (result != null && result == true) {
                                setState(() {
                                  // print('################## hihi');
                                  isLoading = false;
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
                              String name = 'summaryOEEPlannedDTM.pdf';

                              final result = await PdfApi.generateSummaryPDF(
                                  message.message,
                                  600,
                                  this.chartavailabilityheight.round(),
                                  1200,
                                  widget.selectedEquipment,
                                  null,
                                  name);
                              if (result != null && result == true) {
                                setState(() {
                                  // print('################## hihi');
                                  isLoading = false;
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
                  ),
                )
              : Container(
                  height: 350,
                  child: Center(
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
                ),
        ],
      ),
    );
  }

  Widget availability(BuildContext ctx) {
    return Container(
      margin: EdgeInsets.only(top: 37.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  Utils.getTranslated(ctx, 'oee_availabilityGraph')!,
                  style: AppFonts.robotoMedium(
                    14,
                    color: theme_dark!
                        ? AppColors.appPrimaryWhite()
                        : AppColorsLightMode.appGrey(),
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ],
          ),
          (getAvailabilityBySiteDTO.data != null &&
                  getAvailabilityBySiteDTO.data!.length > 0)
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  height: this.chartavailabilityheight,
                  color: Colors.transparent,
                  child: WebViewPlus(
                    backgroundColor: Colors.transparent,
                    javascriptMode: JavascriptMode.unrestricted,
                    initialUrl: theme_dark!
                        ? 'assets/html/oee_highchart_dark_theme.html'
                        : 'assets/html/oee_highchart_light_theme.html',
                    zoomEnabled: false,
                    onWebViewCreated: (controllerPlus) {
                      this.availabilityController = controllerPlus;
                    },
                    onPageFinished: (url) {
                      this.availabilityController.getHeight().then((value) {
                        Utils.printInfo(value);
                        setState(() {
                          if (getAvailabilityBySiteDTO.data != null &&
                              getAvailabilityBySiteDTO.data!.length > 0) {
                            this.chartavailabilityheight = value;
                          } else {
                            this.chartavailabilityheight = 0;
                          }
                        });
                      });
                    },
                    javascriptChannels: [
                      JavascriptChannel(
                          name: 'OEEChannel',
                          onMessageReceived: (message) {
                            print(message.message);
                            if (getAvailabilityBySiteDTO.data != null &&
                                getAvailabilityBySiteDTO.data!.length > 0) {
                              this
                                  .availabilityController
                                  .webViewController
                                  .runJavascript(
                                      'fetchSummaryAvailability(${jsonEncode(this.getAvailabilityBySiteDTO)}, "${DateFormat("yyyy-MM-dd").format(this.startDate)}", "${DateFormat("yyyy-MM-dd").format(this.endDate)}", ${jsonEncode(getDaysInBetween(this.startDate, this.endDate))})');
                            }
                          }),
                      JavascriptChannel(
                          name: 'OEEAvailableTimeChannel',
                          onMessageReceived: (message) {
                            // if (Utils.isNotEmpty(message.message)) {
                            //   JSMetricQualityDataDTO qmDTO =
                            //       JSMetricQualityDataDTO.fromJson(
                            //           jsonDecode(message.message));
                            //   showTooltipsDialog(ctx, qmDTO);
                            // }
                          }),
                      JavascriptChannel(
                          name: 'DQMExportImageChannel',
                          onMessageReceived: (message) async {
                            print(message.message);
                            if (Utils.isNotEmpty(message.message)) {
                              String name = 'summaryOEEAvailability.png';

                              final result =
                                  await ImageApi.generateSummaryImage(
                                      message.message,
                                      600,
                                      this.chartavailabilityheight.round(),
                                      1200,
                                      widget.selectedEquipment,
                                      null,
                                      name);
                              if (result != null && result == true) {
                                setState(() {
                                  // print('################## hihi');
                                  isLoading = false;
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
                              String name = 'summaryOEEAvailability.pdf';

                              final result = await PdfApi.generateSummaryPDF(
                                  message.message,
                                  600,
                                  this.chartavailabilityheight.round(),
                                  1200,
                                  widget.selectedEquipment,
                                  null,
                                  name);
                              if (result != null && result == true) {
                                setState(() {
                                  // print('################## hihi');
                                  isLoading = false;
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
                  ),
                )
              : Container(
                  height: 350,
                  child: Center(
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
                ),
        ],
      ),
    );
  }

  Widget qualityretestpassfail(BuildContext ctx) {
    return Container(
      margin: EdgeInsets.only(top: 37.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  Utils.getTranslated(ctx, 'oee_retestPassFailure')!,
                  style: AppFonts.robotoMedium(
                    14,
                    color: theme_dark!
                        ? AppColors.appPrimaryWhite()
                        : AppColorsLightMode.appGrey(),
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  if (getQualityBySiteDTO.data != null &&
                      getQualityBySiteDTO.data!.length > 0) {
                    Navigator.pushNamed(
                      ctx,
                      AppRoutes.oeeSummarySiteMetricbyProject,
                      arguments: OeeChartDetailArguments(
                          chartName: Utils.getTranslated(
                              context, 'oee_retestpassfailbyProject')!,
                          dataType: '0',
                          selectedEquipment: widget.selectedEquipment,
                          selectedCompany: widget.selectedCompany,
                          selectedSite: widget.selectedSite,
                          currentTab: currentTab),
                    );
                  }
                },
                child: Image.asset(theme_dark!
                    ? Constants.ASSET_IMAGES + 'next_bttn_withbg.png'
                    : Constants.ASSET_IMAGES_LIGHT + 'next_bttn_withbg.png'),
              ),
            ],
          ),
          (getQualityBySiteDTO.data != null &&
                  getQualityBySiteDTO.data!.length > 0)
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  height: this.chartavailabletimeheight,
                  color: Colors.transparent,
                  child: WebViewPlus(
                    backgroundColor: Colors.transparent,
                    javascriptMode: JavascriptMode.unrestricted,
                    initialUrl: theme_dark!
                        ? 'assets/html/oee_highchart_dark_theme.html'
                        : 'assets/html/oee_highchart_light_theme.html',
                    zoomEnabled: false,
                    onWebViewCreated: (controllerPlus) {
                      this.utilController = controllerPlus;
                    },
                    onPageFinished: (url) {
                      this.utilController.getHeight().then((value) {
                        Utils.printInfo(value);
                        setState(() {
                          if (getQualityBySiteDTO.data != null &&
                              getQualityBySiteDTO.data!.length > 0) {
                            this.chartavailabletimeheight = value;
                          } else {
                            this.chartavailabletimeheight = 0;
                          }
                        });
                      });
                    },
                    javascriptChannels: [
                      JavascriptChannel(
                          name: 'OEEChannel',
                          onMessageReceived: (message) {
                            print(message.message);
                            if (getQualityBySiteDTO.data != null &&
                                getQualityBySiteDTO.data!.length > 0) {
                              this.utilController.webViewController.runJavascript(
                                  'fetchSummaryQualityRetestPassFailed(${jsonEncode(this.getQualityBySiteDTO)}, "${DateFormat("yyyy-MM-dd").format(this.startDate)}", "${DateFormat("yyyy-MM-dd").format(this.endDate)}", ${jsonEncode(getDaysInBetween(this.startDate, this.endDate))})');
                            }
                          }),
                      JavascriptChannel(
                          name: 'OEEQualityRetest',
                          onMessageReceived: (message) {
                            print(message.message);
                            setState(() {
                              avalableTimeStamp = message.message;
                            });
                            // if (Utils.isNotEmpty(message.message)) {
                            //   JSMetricQualityDataDTO qmDTO =
                            //       JSMetricQualityDataDTO.fromJson(
                            //           jsonDecode(message.message));
                            showTooltipsDialog(ctx);
                          }),
                      JavascriptChannel(
                          name: 'DQMExportImageChannel',
                          onMessageReceived: (message) async {
                            print(message.message);
                            if (Utils.isNotEmpty(message.message)) {
                              String name = 'summaryOEERetestPass.png';

                              final result =
                                  await ImageApi.generateSummaryImage(
                                      message.message,
                                      600,
                                      this.chartavailabletimeheight.round(),
                                      1200,
                                      widget.selectedEquipment,
                                      null,
                                      name);
                              if (result != null && result == true) {
                                setState(() {
                                  // print('################## hihi');
                                  isLoading = false;
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
                              String name = 'summaryOEERetestPass.pdf';

                              final result = await PdfApi.generateSummaryPDF(
                                  message.message,
                                  600,
                                  this.chartavailabletimeheight.round(),
                                  1200,
                                  widget.selectedEquipment,
                                  null,
                                  name);
                              if (result != null && result == true) {
                                setState(() {
                                  // print('################## hihi');
                                  isLoading = false;
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
                  ),
                )
              : Container(
                  height: 350,
                  child: Center(
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
                ),
        ],
      ),
    );
  }

  Widget firstpassyield(BuildContext ctx) {
    return Container(
      margin: EdgeInsets.only(top: 37.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  Utils.getTranslated(ctx, 'oee_firstpassyield')!,
                  style: AppFonts.robotoMedium(
                    14,
                    color: theme_dark!
                        ? AppColors.appPrimaryWhite()
                        : AppColorsLightMode.appGrey(),
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  if (getQualityBySiteDTO.data != null &&
                      getQualityBySiteDTO.data!.length > 0) {
                    Navigator.pushNamed(
                      ctx,
                      AppRoutes.oeeSummarySiteMetricbyProject,
                      arguments: OeeChartDetailArguments(
                          chartName: Utils.getTranslated(
                              ctx, 'oee_firstpassyieldbyProject')!,
                          dataType: '1',
                          selectedEquipment: widget.selectedEquipment,
                          selectedCompany: widget.selectedCompany,
                          selectedSite: widget.selectedSite,
                          currentTab: currentTab),
                    );
                  }
                },
                child: Image.asset(theme_dark!
                    ? Constants.ASSET_IMAGES + 'next_bttn_withbg.png'
                    : Constants.ASSET_IMAGES_LIGHT + 'next_bttn_withbg.png'),
              ),
            ],
          ),
          (getQualityBySiteDTO.data != null &&
                  getQualityBySiteDTO.data!.length > 0)
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  height: this.chartavailabletimeheight,
                  color: Colors.transparent,
                  child: WebViewPlus(
                    backgroundColor: Colors.transparent,
                    javascriptMode: JavascriptMode.unrestricted,
                    initialUrl: theme_dark!
                        ? 'assets/html/oee_highchart_dark_theme.html'
                        : 'assets/html/oee_highchart_light_theme.html',
                    zoomEnabled: false,
                    onWebViewCreated: (controllerPlus) {
                      this.availableTimeController = controllerPlus;
                    },
                    onPageFinished: (url) {
                      this.availableTimeController.getHeight().then((value) {
                        Utils.printInfo(value);
                        setState(() {
                          if (getQualityBySiteDTO.data != null &&
                              getQualityBySiteDTO.data!.length > 0) {
                            this.chartavailabletimeheight = value;
                          } else {
                            this.chartavailabletimeheight = 0;
                          }
                        });
                      });
                    },
                    javascriptChannels: [
                      JavascriptChannel(
                          name: 'OEEChannel',
                          onMessageReceived: (message) {
                            print(message.message);
                            if (getQualityBySiteDTO.data != null &&
                                getQualityBySiteDTO.data!.length > 0) {
                              this
                                  .availableTimeController
                                  .webViewController
                                  .runJavascript(
                                      'fetchSummaryQualityFPY(${jsonEncode(this.getQualityBySiteDTO)}, "${DateFormat("yyyy-MM-dd").format(this.startDate)}", "${DateFormat("yyyy-MM-dd").format(this.endDate)}", ${jsonEncode(getDaysInBetween(this.startDate, this.endDate))})');
                            }
                          }),
                      JavascriptChannel(
                          name: 'OEEQualityFPYChannel',
                          onMessageReceived: (message) {
                            print(message.message);
                            setState(() {
                              avalableTimeStamp = message.message;
                            });
                            // if (Utils.isNotEmpty(message.message)) {
                            //   JSMetricQualityDataDTO qmDTO =
                            //       JSMetricQualityDataDTO.fromJson(
                            //           jsonDecode(message.message));
                            showTooltipsDialog(ctx);
                          }),
                      JavascriptChannel(
                          name: 'DQMExportImageChannel',
                          onMessageReceived: (message) async {
                            print(message.message);
                            if (Utils.isNotEmpty(message.message)) {
                              String name = 'summaryOEEFirstPassYield.png';

                              final result =
                                  await ImageApi.generateSummaryImage(
                                      message.message,
                                      600,
                                      this.chartutilheight.round(),
                                      1200,
                                      widget.selectedEquipment,
                                      null,
                                      name);
                              if (result != null && result == true) {
                                setState(() {
                                  // print('################## hihi');
                                  isLoading = false;
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
                              String name = 'summaryOEEFirstPassYield.pdf';

                              final result = await PdfApi.generateSummaryPDF(
                                  message.message,
                                  600,
                                  this.chartutilheight.round(),
                                  1200,
                                  widget.selectedEquipment,
                                  null,
                                  name);
                              if (result != null && result == true) {
                                setState(() {
                                  // print('################## hihi');
                                  isLoading = false;
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
                  ),
                )
              : Container(
                  height: 350,
                  child: Center(
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
                ),
        ],
      ),
    );
  }

  Widget yield(BuildContext ctx) {
    return Container(
      margin: EdgeInsets.only(top: 37.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  Utils.getTranslated(ctx, 'oee_yield')!,
                  style: AppFonts.robotoMedium(
                    14,
                    color: theme_dark!
                        ? AppColors.appPrimaryWhite()
                        : AppColorsLightMode.appGrey(),
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  if (getQualityBySiteDTO.data != null &&
                      getQualityBySiteDTO.data!.length > 0) {
                    Navigator.pushNamed(
                      ctx,
                      AppRoutes.oeeSummarySiteMetricbyProject,
                      arguments: OeeChartDetailArguments(
                          chartName:
                              Utils.getTranslated(ctx, 'oee_yieldbyProject')!,
                          dataType: '2',
                          selectedEquipment: widget.selectedEquipment,
                          selectedCompany: widget.selectedCompany,
                          selectedSite: widget.selectedSite,
                          currentTab: currentTab),
                    );
                  }
                },
                child: Image.asset(theme_dark!
                    ? Constants.ASSET_IMAGES + 'next_bttn_withbg.png'
                    : Constants.ASSET_IMAGES_LIGHT + 'next_bttn_withbg.png'),
              ),
            ],
          ),
          (getQualityBySiteDTO.data != null &&
                  getQualityBySiteDTO.data!.length > 0)
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  height: this.chartavailabletimeheight,
                  color: Colors.transparent,
                  child: WebViewPlus(
                    backgroundColor: Colors.transparent,
                    javascriptMode: JavascriptMode.unrestricted,
                    initialUrl: theme_dark!
                        ? 'assets/html/oee_highchart_dark_theme.html'
                        : 'assets/html/oee_highchart_light_theme.html',
                    zoomEnabled: false,
                    onWebViewCreated: (controllerPlus) {
                      this.plannedDownTimeController = controllerPlus;
                    },
                    onPageFinished: (url) {
                      this.plannedDownTimeController.getHeight().then((value) {
                        Utils.printInfo(value);
                        setState(() {
                          if (getQualityBySiteDTO.data != null &&
                              getQualityBySiteDTO.data!.length > 0) {
                            this.chartavailabletimeheight = value;
                          } else {
                            this.chartavailabletimeheight = 0;
                          }
                        });
                      });
                    },
                    javascriptChannels: [
                      JavascriptChannel(
                          name: 'OEEChannel',
                          onMessageReceived: (message) {
                            print(message.message);
                            if (getQualityBySiteDTO.data != null &&
                                getQualityBySiteDTO.data!.length > 0) {
                              this
                                  .plannedDownTimeController
                                  .webViewController
                                  .runJavascript(
                                      'fetchSummaryQualityYield(${jsonEncode(this.getQualityBySiteDTO)}, "${DateFormat("yyyy-MM-dd").format(this.startDate)}", "${DateFormat("yyyy-MM-dd").format(this.endDate)}", ${jsonEncode(getDaysInBetween(this.startDate, this.endDate))})');
                            }
                          }),
                      JavascriptChannel(
                          name: 'OEEQualityYieldChannel',
                          onMessageReceived: (message) {
                            print(message.message);
                            setState(() {
                              avalableTimeStamp = message.message;
                            });
                            // if (Utils.isNotEmpty(message.message)) {
                            //   JSMetricQualityDataDTO qmDTO =
                            //       JSMetricQualityDataDTO.fromJson(
                            //           jsonDecode(message.message));
                            showTooltipsDialog(ctx);
                          }),
                      JavascriptChannel(
                          name: 'DQMExportImageChannel',
                          onMessageReceived: (message) async {
                            print(message.message);
                            if (Utils.isNotEmpty(message.message)) {
                              String name = 'summaryOEEYild.png';

                              final result =
                                  await ImageApi.generateSummaryImage(
                                      message.message,
                                      600,
                                      this.chartutilheight.round(),
                                      1200,
                                      widget.selectedEquipment,
                                      null,
                                      name);
                              if (result != null && result == true) {
                                setState(() {
                                  // print('################## hihi');
                                  isLoading = false;
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
                              String name = 'summaryOEEYield.pdf';

                              final result = await PdfApi.generateSummaryPDF(
                                  message.message,
                                  600,
                                  this.chartutilheight.round(),
                                  1200,
                                  widget.selectedEquipment,
                                  null,
                                  name);
                              if (result != null && result == true) {
                                setState(() {
                                  // print('################## hihi');
                                  isLoading = false;
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
                  ),
                )
              : Container(
                  height: 350,
                  child: Center(
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
                ),
        ],
      ),
    );
  }

  Widget qualitymetric(BuildContext ctx) {
    return Container(
      margin: EdgeInsets.only(top: 37.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  Utils.getTranslated(ctx, 'oee_qualitymetric')!,
                  style: AppFonts.robotoMedium(
                    14,
                    color: theme_dark!
                        ? AppColors.appPrimaryWhite()
                        : AppColorsLightMode.appGrey(),
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ],
          ),
          (getQualityBySiteDTO.data != null &&
                  getQualityBySiteDTO.data!.length > 0)
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  height: this.chartavailabletimeheight,
                  color: Colors.transparent,
                  child: WebViewPlus(
                    backgroundColor: Colors.transparent,
                    javascriptMode: JavascriptMode.unrestricted,
                    initialUrl: theme_dark!
                        ? 'assets/html/oee_highchart_dark_theme.html'
                        : 'assets/html/oee_highchart_light_theme.html',
                    zoomEnabled: false,
                    onWebViewCreated: (controllerPlus) {
                      this.availabilityController = controllerPlus;
                    },
                    onPageFinished: (url) {
                      this.availabilityController.getHeight().then((value) {
                        Utils.printInfo(value);
                        setState(() {
                          if (getQualityBySiteDTO.data != null &&
                              getQualityBySiteDTO.data!.length > 0) {
                            this.chartavailabletimeheight = value;
                          } else {
                            this.chartavailabletimeheight = 0;
                          }
                        });
                      });
                    },
                    javascriptChannels: [
                      JavascriptChannel(
                          name: 'OEEChannel',
                          onMessageReceived: (message) {
                            print(message.message);
                            if (getQualityBySiteDTO.data != null &&
                                getQualityBySiteDTO.data!.length > 0) {
                              this
                                  .availabilityController
                                  .webViewController
                                  .runJavascript(
                                      'fetchSummaryQualityMetric(${jsonEncode(this.getQualityBySiteDTO)}, "${DateFormat("yyyy-MM-dd").format(this.startDate)}", "${DateFormat("yyyy-MM-dd").format(this.endDate)}", ${jsonEncode(getDaysInBetween(this.startDate, this.endDate))})');
                            }
                          }),
                      JavascriptChannel(
                          name: 'OEEAvailableTimeChannel',
                          onMessageReceived: (message) {
                            // if (Utils.isNotEmpty(message.message)) {
                            //   JSMetricQualityDataDTO qmDTO =
                            //       JSMetricQualityDataDTO.fromJson(
                            //           jsonDecode(message.message));
                            //   showTooltipsDialog(ctx, qmDTO);
                            // }
                          }),
                      JavascriptChannel(
                          name: 'DQMExportImageChannel',
                          onMessageReceived: (message) async {
                            print(message.message);
                            if (Utils.isNotEmpty(message.message)) {
                              String name = 'summaryOEEQuality.png';

                              final result =
                                  await ImageApi.generateSummaryImage(
                                      message.message,
                                      600,
                                      this.chartutilheight.round(),
                                      1200,
                                      widget.selectedEquipment,
                                      null,
                                      name);
                              if (result != null && result == true) {
                                setState(() {
                                  // print('################## hihi');
                                  isLoading = false;
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
                              String name = 'summaryOEEQuality.pdf';

                              final result = await PdfApi.generateSummaryPDF(
                                  message.message,
                                  600,
                                  this.chartutilheight.round(),
                                  1200,
                                  widget.selectedEquipment,
                                  null,
                                  name);
                              if (result != null && result == true) {
                                setState(() {
                                  // print('################## hihi');
                                  isLoading = false;
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
                  ),
                )
              : Container(
                  height: 350,
                  child: Center(
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
                ),
        ],
      ),
    );
  }

  Widget performanceretestpassfail(BuildContext ctx) {
    return Container(
      margin: EdgeInsets.only(top: 37.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  Utils.getTranslated(ctx, 'oee_retestPassFailure')!,
                  style: AppFonts.robotoMedium(
                    14,
                    color: theme_dark!
                        ? AppColors.appPrimaryWhite()
                        : AppColorsLightMode.appGrey(),
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  if (getPerformanceBySiteDTO.data != null &&
                      getPerformanceBySiteDTO.data!.length > 0) {
                    Navigator.pushNamed(
                      ctx,
                      AppRoutes.oeeSummarySiteMetricbyProject,
                      arguments: OeeChartDetailArguments(
                          chartName: Utils.getTranslated(
                              ctx, 'oee_retestpassfailbyProject')!,
                          dataType: '0',
                          selectedEquipment: widget.selectedEquipment,
                          selectedCompany: widget.selectedCompany,
                          selectedSite: widget.selectedSite,
                          currentTab: currentTab),
                    );
                  }
                },
                child: Image.asset(theme_dark!
                    ? Constants.ASSET_IMAGES + 'next_bttn_withbg.png'
                    : Constants.ASSET_IMAGES_LIGHT + 'next_bttn_withbg.png'),
              ),
            ],
          ),
          (getPerformanceBySiteDTO.data != null &&
                  getPerformanceBySiteDTO.data!.length > 0)
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  height: this.chartavailabletimeheight,
                  color: Colors.transparent,
                  child: WebViewPlus(
                    backgroundColor: Colors.transparent,
                    javascriptMode: JavascriptMode.unrestricted,
                    initialUrl: theme_dark!
                        ? 'assets/html/oee_highchart_dark_theme.html'
                        : 'assets/html/oee_highchart_light_theme.html',
                    zoomEnabled: false,
                    onWebViewCreated: (controllerPlus) {
                      this.utilController = controllerPlus;
                    },
                    onPageFinished: (url) {
                      this.utilController.getHeight().then((value) {
                        Utils.printInfo(value);
                        setState(() {
                          if (getPerformanceBySiteDTO.data != null &&
                              getPerformanceBySiteDTO.data!.length > 0) {
                            this.chartavailabletimeheight = value;
                          } else {
                            this.chartavailabletimeheight = 0;
                          }
                        });
                      });
                    },
                    javascriptChannels: [
                      JavascriptChannel(
                          name: 'OEEChannel',
                          onMessageReceived: (message) {
                            print(message.message);
                            if (getPerformanceBySiteDTO.data != null &&
                                getPerformanceBySiteDTO.data!.length > 0) {
                              this.utilController.webViewController.runJavascript(
                                  'fetchSummaryPerformanceRetestPassFailed(${jsonEncode(this.getPerformanceBySiteDTO)}, "${DateFormat("yyyy-MM-dd").format(this.startDate)}", "${DateFormat("yyyy-MM-dd").format(this.endDate)}", ${jsonEncode(getDaysInBetween(this.startDate, this.endDate))})');
                            }
                          }),
                      JavascriptChannel(
                          name: 'OEEPerformanceRetestChannel',
                          onMessageReceived: (message) {
                            print(message.message);
                            setState(() {
                              avalableTimeStamp = message.message;
                            });
                            // if (Utils.isNotEmpty(message.message)) {
                            //   JSMetricQualityDataDTO qmDTO =
                            //       JSMetricQualityDataDTO.fromJson(
                            //           jsonDecode(message.message));
                            showTooltipsDialog(ctx);
                          }),
                      JavascriptChannel(
                          name: 'DQMExportImageChannel',
                          onMessageReceived: (message) async {
                            print(message.message);
                            if (Utils.isNotEmpty(message.message)) {
                              String name =
                                  'summaryOEEPerformanceRetestPass.png';

                              final result =
                                  await ImageApi.generateSummaryImage(
                                      message.message,
                                      600,
                                      this.chartutilheight.round(),
                                      1200,
                                      widget.selectedEquipment,
                                      null,
                                      name);
                              if (result != null && result == true) {
                                setState(() {
                                  // print('################## hihi');
                                  isLoading = false;
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
                              String name =
                                  'summaryOEEPerformanceRetestPass.pdf';

                              final result = await PdfApi.generateSummaryPDF(
                                  message.message,
                                  600,
                                  this.chartutilheight.round(),
                                  1200,
                                  widget.selectedEquipment,
                                  null,
                                  name);
                              if (result != null && result == true) {
                                setState(() {
                                  // print('################## hihi');
                                  isLoading = false;
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
                  ),
                )
              : Container(
                  height: 350,
                  child: Center(
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
                ),
        ],
      ),
    );
  }

  Widget firstpass(BuildContext ctx) {
    return Container(
      margin: EdgeInsets.only(top: 37.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  Utils.getTranslated(ctx, 'oee_firstpass')!,
                  style: AppFonts.robotoMedium(
                    14,
                    color: theme_dark!
                        ? AppColors.appPrimaryWhite()
                        : AppColorsLightMode.appGrey(),
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  if (getPerformanceBySiteDTO.data != null &&
                      getPerformanceBySiteDTO.data!.length > 0) {
                    Navigator.pushNamed(
                      ctx,
                      AppRoutes.oeeSummarySiteMetricbyProject,
                      arguments: OeeChartDetailArguments(
                          chartName: Utils.getTranslated(
                              ctx, 'oee_firstpassbyProject')!,
                          dataType: '1',
                          selectedEquipment: widget.selectedEquipment,
                          selectedCompany: widget.selectedCompany,
                          selectedSite: widget.selectedSite,
                          currentTab: currentTab),
                    );
                  }
                },
                child: Image.asset(theme_dark!
                    ? Constants.ASSET_IMAGES + 'next_bttn_withbg.png'
                    : Constants.ASSET_IMAGES_LIGHT + 'next_bttn_withbg.png'),
              ),
            ],
          ),
          (getPerformanceBySiteDTO.data != null &&
                  getPerformanceBySiteDTO.data!.length > 0)
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  height: this.chartavailabletimeheight,
                  color: Colors.transparent,
                  child: WebViewPlus(
                    backgroundColor: Colors.transparent,
                    javascriptMode: JavascriptMode.unrestricted,
                    initialUrl: theme_dark!
                        ? 'assets/html/oee_highchart_dark_theme.html'
                        : 'assets/html/oee_highchart_light_theme.html',
                    zoomEnabled: false,
                    onWebViewCreated: (controllerPlus) {
                      this.availableTimeController = controllerPlus;
                    },
                    onPageFinished: (url) {
                      this.availableTimeController.getHeight().then((value) {
                        Utils.printInfo(value);
                        setState(() {
                          if (getPerformanceBySiteDTO.data != null &&
                              getPerformanceBySiteDTO.data!.length > 0) {
                            this.chartavailabletimeheight = value;
                          } else {
                            this.chartavailabletimeheight = 0;
                          }
                        });
                      });
                    },
                    javascriptChannels: [
                      JavascriptChannel(
                          name: 'OEEChannel',
                          onMessageReceived: (message) {
                            print(message.message);
                            if (getPerformanceBySiteDTO.data != null &&
                                getPerformanceBySiteDTO.data!.length > 0) {
                              this
                                  .availableTimeController
                                  .webViewController
                                  .runJavascript(
                                      'fetchSummaryPerformanceFirstPass(${jsonEncode(this.getPerformanceBySiteDTO)}, "${DateFormat("yyyy-MM-dd").format(this.startDate)}", "${DateFormat("yyyy-MM-dd").format(this.endDate)}", ${jsonEncode(getDaysInBetween(this.startDate, this.endDate))})');
                            }
                          }),
                      JavascriptChannel(
                          name: 'OEEPerformanceFirstPassChannel',
                          onMessageReceived: (message) {
                            print(message.message);
                            setState(() {
                              avalableTimeStamp = message.message;
                            });
                            // if (Utils.isNotEmpty(message.message)) {
                            //   JSMetricQualityDataDTO qmDTO =
                            //       JSMetricQualityDataDTO.fromJson(
                            //           jsonDecode(message.message));
                            showTooltipsDialog(ctx);
                          }),
                      JavascriptChannel(
                          name: 'DQMExportImageChannel',
                          onMessageReceived: (message) async {
                            print(message.message);
                            if (Utils.isNotEmpty(message.message)) {
                              String name =
                                  'summaryOEEPerformanceFirstPass.png';

                              final result =
                                  await ImageApi.generateSummaryImage(
                                      message.message,
                                      600,
                                      this.chartutilheight.round(),
                                      1200,
                                      widget.selectedEquipment,
                                      null,
                                      name);
                              if (result != null && result == true) {
                                setState(() {
                                  // print('################## hihi');
                                  isLoading = false;
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
                              String name =
                                  'summaryOEEPerformanceFirstPass.pdf';

                              final result = await PdfApi.generateSummaryPDF(
                                  message.message,
                                  600,
                                  this.chartutilheight.round(),
                                  1200,
                                  widget.selectedEquipment,
                                  null,
                                  name);
                              if (result != null && result == true) {
                                setState(() {
                                  // print('################## hihi');
                                  isLoading = false;
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
                  ),
                )
              : Container(
                  height: 350,
                  child: Center(
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
                ),
        ],
      ),
    );
  }

  Widget idealcycle(BuildContext ctx) {
    return Container(
      margin: EdgeInsets.only(top: 37.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  Utils.getTranslated(ctx, 'oee_idealcycle')!,
                  style: AppFonts.robotoMedium(
                    14,
                    color: theme_dark!
                        ? AppColors.appPrimaryWhite()
                        : AppColorsLightMode.appGrey(),
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  if (getPerformanceBySiteDTO.data != null &&
                      getPerformanceBySiteDTO.data!.length > 0) {
                    Navigator.pushNamed(
                      ctx,
                      AppRoutes.oeeSummarySiteMetricbyProject,
                      arguments: OeeChartDetailArguments(
                          chartName: Utils.getTranslated(
                              ctx, 'oee_idealcyclebyProject')!,
                          dataType: '2',
                          selectedEquipment: widget.selectedEquipment,
                          selectedCompany: widget.selectedCompany,
                          selectedSite: widget.selectedSite,
                          currentTab: currentTab),
                    );
                  }
                },
                child: Image.asset(theme_dark!
                    ? Constants.ASSET_IMAGES + 'next_bttn_withbg.png'
                    : Constants.ASSET_IMAGES_LIGHT + 'next_bttn_withbg.png'),
              ),
            ],
          ),
          (getPerformanceBySiteDTO.data != null &&
                  getPerformanceBySiteDTO.data!.length > 0)
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  height: this.chartavailabletimeheight,
                  color: Colors.transparent,
                  child: WebViewPlus(
                    backgroundColor: Colors.transparent,
                    javascriptMode: JavascriptMode.unrestricted,
                    initialUrl: theme_dark!
                        ? 'assets/html/oee_highchart_dark_theme.html'
                        : 'assets/html/oee_highchart_light_theme.html',
                    zoomEnabled: false,
                    onWebViewCreated: (controllerPlus) {
                      this.plannedDownTimeController = controllerPlus;
                    },
                    onPageFinished: (url) {
                      this.plannedDownTimeController.getHeight().then((value) {
                        Utils.printInfo(value);
                        setState(() {
                          if (getPerformanceBySiteDTO.data != null &&
                              getPerformanceBySiteDTO.data!.length > 0) {
                            this.chartavailabletimeheight = value;
                          } else {
                            this.chartavailabletimeheight = 0;
                          }
                        });
                      });
                    },
                    javascriptChannels: [
                      JavascriptChannel(
                          name: 'OEEChannel',
                          onMessageReceived: (message) {
                            print(message.message);
                            if (getPerformanceBySiteDTO.data != null &&
                                getPerformanceBySiteDTO.data!.length > 0) {
                              this
                                  .plannedDownTimeController
                                  .webViewController
                                  .runJavascript(
                                      'fetchSummaryPerformanceIdealCycle(${jsonEncode(this.getPerformanceBySiteDTO)}, "${DateFormat("yyyy-MM-dd").format(this.startDate)}", "${DateFormat("yyyy-MM-dd").format(this.endDate)}", ${jsonEncode(getDaysInBetween(this.startDate, this.endDate))})');
                            }
                          }),
                      JavascriptChannel(
                          name: 'OEEPerformanceIdealChannel',
                          onMessageReceived: (message) {
                            print(message.message);
                            setState(() {
                              avalableTimeStamp = message.message;
                            });
                            // if (Utils.isNotEmpty(message.message)) {
                            //   JSMetricQualityDataDTO qmDTO =
                            //       JSMetricQualityDataDTO.fromJson(
                            //           jsonDecode(message.message));
                            showTooltipsDialog(ctx);
                          }),
                      JavascriptChannel(
                          name: 'DQMExportImageChannel',
                          onMessageReceived: (message) async {
                            print(message.message);
                            if (Utils.isNotEmpty(message.message)) {
                              String name =
                                  'summaryOEEPerformanceIdealCycle.png';

                              final result =
                                  await ImageApi.generateSummaryImage(
                                      message.message,
                                      600,
                                      this.chartutilheight.round(),
                                      1200,
                                      widget.selectedEquipment,
                                      null,
                                      name);
                              if (result != null && result == true) {
                                setState(() {
                                  // print('################## hihi');
                                  isLoading = false;
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
                              String name =
                                  'summaryOEEPerforamanceIdealCycle.pdf';

                              final result = await PdfApi.generateSummaryPDF(
                                  message.message,
                                  600,
                                  this.chartutilheight.round(),
                                  1200,
                                  widget.selectedEquipment,
                                  null,
                                  name);
                              if (result != null && result == true) {
                                setState(() {
                                  // print('################## hihi');
                                  isLoading = false;
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
                  ),
                )
              : Container(
                  height: 350,
                  child: Center(
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
                ),
        ],
      ),
    );
  }

  Widget performance(BuildContext ctx) {
    return Container(
      margin: EdgeInsets.only(top: 37.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  Utils.getTranslated(ctx, 'oee_performance')!,
                  style: AppFonts.robotoMedium(
                    14,
                    color: theme_dark!
                        ? AppColors.appPrimaryWhite()
                        : AppColorsLightMode.appGrey(),
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ],
          ),
          (getPerformanceBySiteDTO.data != null &&
                  getPerformanceBySiteDTO.data!.length > 0)
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  height: this.chartavailabletimeheight,
                  color: Colors.transparent,
                  child: WebViewPlus(
                    backgroundColor: Colors.transparent,
                    javascriptMode: JavascriptMode.unrestricted,
                    initialUrl: theme_dark!
                        ? 'assets/html/oee_highchart_dark_theme.html'
                        : 'assets/html/oee_highchart_light_theme.html',
                    zoomEnabled: false,
                    onWebViewCreated: (controllerPlus) {
                      this.availabilityController = controllerPlus;
                    },
                    onPageFinished: (url) {
                      this.availabilityController.getHeight().then((value) {
                        Utils.printInfo(value);
                        setState(() {
                          if (getPerformanceBySiteDTO.data != null &&
                              getPerformanceBySiteDTO.data!.length > 0) {
                            this.chartavailabletimeheight = value;
                          } else {
                            this.chartavailabletimeheight = 0;
                          }
                        });
                      });
                    },
                    javascriptChannels: [
                      JavascriptChannel(
                          name: 'OEEChannel',
                          onMessageReceived: (message) {
                            print(message.message);
                            if (getPerformanceBySiteDTO.data != null &&
                                getPerformanceBySiteDTO.data!.length > 0) {
                              this
                                  .availabilityController
                                  .webViewController
                                  .runJavascript(
                                      'fetchSummaryPerformanceMetric(${jsonEncode(this.getPerformanceBySiteDTO)}, "${DateFormat("yyyy-MM-dd").format(this.startDate)}", "${DateFormat("yyyy-MM-dd").format(this.endDate)}", ${jsonEncode(getDaysInBetween(this.startDate, this.endDate))})');
                            }
                          }),
                      JavascriptChannel(
                          name: 'OEEAvailabiliyChannel',
                          onMessageReceived: (message) {
                            // if (Utils.isNotEmpty(message.message)) {
                            //   JSMetricQualityDataDTO qmDTO =
                            //       JSMetricQualityDataDTO.fromJson(
                            //           jsonDecode(message.message));
                            //   showTooltipsDialog(ctx, qmDTO);
                            // }
                          }),
                      JavascriptChannel(
                          name: 'DQMExportImageChannel',
                          onMessageReceived: (message) async {
                            print(message.message);
                            if (Utils.isNotEmpty(message.message)) {
                              String name = 'summaryOEEPerformancMetric.png';

                              final result =
                                  await ImageApi.generateSummaryImage(
                                      message.message,
                                      600,
                                      this.chartutilheight.round(),
                                      1200,
                                      widget.selectedEquipment,
                                      null,
                                      name);
                              if (result != null && result == true) {
                                setState(() {
                                  // print('################## hihi');
                                  isLoading = false;
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
                              String name = 'summaryOEEPerformanceMetric.pdf';

                              final result = await PdfApi.generateSummaryPDF(
                                  message.message,
                                  600,
                                  this.chartutilheight.round(),
                                  1200,
                                  widget.selectedEquipment,
                                  null,
                                  name);
                              if (result != null && result == true) {
                                setState(() {
                                  // print('################## hihi');
                                  isLoading = false;
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
                  ),
                )
              : Container(
                  height: 350,
                  child: Center(
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
                ),
        ],
      ),
    );
  }

  void showTooltipsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (tooltipsDialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: chartTooltipsInfo(context),
        );
      },
    );
  }

  Widget chartTooltipsInfo(BuildContext ctx) {
    if (currentTab == 0) {
      var timestamp =
          DateFormat("yyyy-MM-dd").format(DateTime.parse(avalableTimeStamp));
      OeeSummaryDataDTO data = OeeSummaryDataDTO();
      getAvailabilityBySiteDTO.data!.forEach((element) {
        if (element.date == timestamp) {
          data = element;
        }
      });

      return Container(
        padding: EdgeInsets.fromLTRB(14.0, 12.0, 14.0, 12.0),
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
              DateFormat("EEEE, MMM dd, yyyy")
                  .format(DateTime.parse(data.date!)),
              style: AppFonts.robotoMedium(
                14,
                color: AppColors.appPrimaryWhite(),
                decoration: TextDecoration.none,
              ),
            ),
            SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    'Utilization Time, Minute(s) :',
                    style: AppFonts.robotoMedium(
                      14,
                      color: AppColors.appBlueLight(),
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    '${data.utilizationTime!.toStringAsFixed(2)}',
                    style: AppFonts.robotoRegular(
                      16,
                      color: theme_dark!
                          ? AppColors.appGrey2()
                          : AppColorsLightMode.appGrey2(),
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    'Available Time, Minute(s) :',
                    style: AppFonts.robotoMedium(
                      14,
                      color: AppColors.appGreen60(),
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    '${data.availableTime!.toStringAsFixed(2)}',
                    style: AppFonts.robotoRegular(
                      16,
                      color: theme_dark!
                          ? AppColors.appGrey2()
                          : AppColorsLightMode.appGrey2(),
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    'Planned Down Time, Minute(s) :',
                    style: AppFonts.robotoMedium(
                      14,
                      color: AppColors.appPrimaryOrange(),
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    '${data.plannedDownTime!.toStringAsFixed(2)}',
                    style: AppFonts.robotoRegular(
                      16,
                      color: theme_dark!
                          ? AppColors.appGrey2()
                          : AppColorsLightMode.appGrey2(),
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    'Down Time, Minute(s) :',
                    style: AppFonts.robotoRegular(
                      16,
                      color: AppColors.appRedE9(),
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    '${data.downTime!.toStringAsFixed(2)}',
                    style: AppFonts.robotoRegular(
                      16,
                      color: theme_dark!
                          ? AppColors.appGrey2()
                          : AppColorsLightMode.appGrey2(),
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    'Availability (%)',
                    style: AppFonts.robotoRegular(
                      16,
                      color: AppColors.appLightGreen(),
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    '${data.availability!.toStringAsFixed(2)}',
                    style: AppFonts.robotoRegular(
                      16,
                      color: theme_dark!
                          ? AppColors.appGrey2()
                          : AppColorsLightMode.appGrey2(),
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    } else if (currentTab == 1) {
      var timestamp =
          DateFormat("yyyy-MM-dd").format(DateTime.parse(avalableTimeStamp));
      OeeQualityDataDTO data = OeeQualityDataDTO();
      getQualityBySiteDTO.data!.forEach((element) {
        if (element.date == timestamp) {
          data = element;
        }
      });
      var fpy = ((data.firstPassCount!) /
              (data.firstPassCount! + data.retestCount! + data.failedCount!)) *
          100;
      var fy = ((data.firstPassCount! + data.retestCount!) /
              (data.firstPassCount! + data.retestCount! + data.failedCount!)) *
          100;

      return Container(
        padding: EdgeInsets.fromLTRB(14.0, 12.0, 14.0, 12.0),
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
              DateFormat("EEEE, MMM dd, yyyy")
                  .format(DateTime.parse(data.date!)),
              style: AppFonts.robotoMedium(
                14,
                color: AppColors.appPrimaryWhite(),
                decoration: TextDecoration.none,
              ),
            ),
            SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    Utils.getTranslated(context, 'oee_summary_metric_failed')!,
                    style: AppFonts.robotoMedium(
                      14,
                      color: AppColors.appRedE9(),
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    '${data.failedCount!.toStringAsFixed(2)}',
                    style: AppFonts.robotoRegular(
                      16,
                      color: theme_dark!
                          ? AppColors.appGrey2()
                          : AppColorsLightMode.appGrey2(),
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    Utils.getTranslated(
                        context, 'oee_summary_metric_retestpass')!,
                    style: AppFonts.robotoMedium(
                      14,
                      color: AppColors.appPrimaryOrange(),
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    '${data.retestCount!.toStringAsFixed(2)}',
                    style: AppFonts.robotoRegular(
                      16,
                      color: theme_dark!
                          ? AppColors.appGrey2()
                          : AppColorsLightMode.appGrey2(),
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    Utils.getTranslated(context, 'oee_summary_metric_fpy')!,
                    style: AppFonts.robotoMedium(
                      14,
                      color: AppColors.appGreyBlue(),
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    '${fpy.toStringAsFixed(2)}',
                    style: AppFonts.robotoRegular(
                      16,
                      color: theme_dark!
                          ? AppColors.appGrey2()
                          : AppColorsLightMode.appGrey2(),
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    Utils.getTranslated(context, 'oee_summary_metric_yield')!,
                    style: AppFonts.robotoRegular(
                      16,
                      color: AppColors.appGreen60(),
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    '${fy.toStringAsFixed(2)}',
                    style: AppFonts.robotoRegular(
                      16,
                      color: theme_dark!
                          ? AppColors.appGrey2()
                          : AppColorsLightMode.appGrey2(),
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    Utils.getTranslated(
                        context, 'oee_summary_metric_qualitymetric')!,
                    style: AppFonts.robotoRegular(
                      16,
                      color: AppColors.appLightGreen(),
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    '${data.quality!.toStringAsFixed(2)}',
                    style: AppFonts.robotoRegular(
                      16,
                      color: AppColors.appLightGreen(),
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    } else if (currentTab == 2) {
      var timestamp =
          DateFormat("yyyy-MM-dd").format(DateTime.parse(avalableTimeStamp));
      OeePerformanceDataDTO data = OeePerformanceDataDTO();
      getPerformanceBySiteDTO.data!.forEach((element) {
        if (element.date == timestamp) {
          data = element;
        }
      });

      return Container(
        padding: EdgeInsets.fromLTRB(14.0, 12.0, 14.0, 12.0),
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
              DateFormat("EEEE, MMM dd, yyyy")
                  .format(DateTime.parse(data.date!)),
              style: AppFonts.robotoMedium(
                14,
                color: AppColors.appPrimaryWhite(),
                decoration: TextDecoration.none,
              ),
            ),
            SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    Utils.getTranslated(
                        context, 'oee_summary_metric_failedmins')!,
                    style: AppFonts.robotoMedium(
                      14,
                      color: AppColors.appRedE9(),
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    '${data.failUtilizationTime!.toStringAsFixed(2)}',
                    style: AppFonts.robotoRegular(
                      16,
                      color: theme_dark!
                          ? AppColors.appGrey2()
                          : AppColorsLightMode.appGrey2(),
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    Utils.getTranslated(
                        context, 'oee_summary_metric_retestpassmins')!,
                    style: AppFonts.robotoMedium(
                      14,
                      color: AppColors.appPrimaryOrange(),
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    '${data.retestUtilizationTime!.toStringAsFixed(2)}',
                    style: AppFonts.robotoRegular(
                      16,
                      color: theme_dark!
                          ? AppColors.appGrey2()
                          : AppColorsLightMode.appGrey2(),
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    Utils.getTranslated(context, 'oee_summary_metric_fpmins')!,
                    style: AppFonts.robotoMedium(
                      14,
                      color: AppColors.appGreen60(),
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    '${data.firstPassUtilizationTime!.toStringAsFixed(2)}',
                    style: AppFonts.robotoRegular(
                      16,
                      color: theme_dark!
                          ? AppColors.appGrey2()
                          : AppColorsLightMode.appGrey2(),
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    Utils.getTranslated(
                        context, 'oee_summary_metric_idealcycle')!,
                    style: AppFonts.robotoRegular(
                      16,
                      color: AppColors.appGreyBlue(),
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    '${data.idealCycleTime!.toStringAsFixed(2)}',
                    style: AppFonts.robotoRegular(
                      16,
                      color: theme_dark!
                          ? AppColors.appGrey2()
                          : AppColorsLightMode.appGrey2(),
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    Utils.getTranslated(
                        context, 'oee_summary_metric_performance')!,
                    style: AppFonts.robotoRegular(
                      16,
                      color: AppColors.appLightGreen(),
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    '${data.performance!.toStringAsFixed(2)}',
                    style: AppFonts.robotoRegular(
                      16,
                      color: AppColors.appLightGreen(),
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }
    return Container();
  }
}
