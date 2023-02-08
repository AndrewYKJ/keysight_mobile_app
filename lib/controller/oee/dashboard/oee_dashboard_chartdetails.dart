import 'dart:convert';

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
import 'package:keysight_pma/dio/api/oee.dart';
import 'package:keysight_pma/model/arguments/oee_argument.dart';
import 'package:keysight_pma/model/js/oee_js.dart';
import 'package:keysight_pma/model/oee/oeeAvailability.dart';
import 'package:keysight_pma/model/oee/oeeDowntime.dart';
import 'package:keysight_pma/model/oee/oeeEquipment.dart';
import 'package:keysight_pma/model/sortAndFilter/equipment.dart';
import 'package:keysight_pma/routes/approutes.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

class OEEDashboardChartDetails extends StatefulWidget {
  final String chartName;
  final OeeAvailabilityDTO? oeeAvailabilityDTO;
  final OeeEquipmentDTO? oeeEquipmentDTO;
  final DownTimeMonitoringDTO2? summaryUtilAndNonUtilData;
  final DownTimeMonitoringDTO? detailBreakdownData;
  final String dataType;
  OEEDashboardChartDetails(
      {Key? key,
      required this.chartName,
      this.oeeAvailabilityDTO,
      this.oeeEquipmentDTO,
      required this.dataType,
      this.summaryUtilAndNonUtilData,
      this.detailBreakdownData})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _OEEDashboardChartDetails();
  }
}

class _OEEDashboardChartDetails extends State<OEEDashboardChartDetails> {
  bool isLoading = true;
  late WebViewPlusController oeeWebViewController;
  OeeAvailabilityDTO? dailyUTILDialogDTO;
  OeeChartReturnDTO? chartReturnVOPDTO;
  OeeChartVOEReturnDTO? chartReturnVOEDTO;
  DownTimeMonitoringDTO2? summaryUtilAndNonUtilData2;
  DownTimeMonitoringDTO? detailBreakdownData2;
  OeeAvailabilityDTO? oeeAvailabilityDTO;
  OeeEquipmentDTO? oeeEquipmentDTO_rawData;
  List<EquipmentDataDTO>? selectedEquipmentList = [];
  OeeEquipmentDTO? oeeEquipmentDTO = OeeEquipmentDTO();
  DownTimeMonitoringDTO2? summaryUtilAndNonUtilData;
  DownTimeMonitoringDTO? detailBreakdownData;
  String? dtmKey;
  String? utilKey;
  double chartHeight = 350;
  bool showModal = false;
  String? dtmCredit;

  bool? theme_dark = AppCache.sortFilterCacheDTO!.currentTheme;
  Future<DownTimeMonitoringDTO2> getListOfDownTimeByCompanySiteEqAndDateRange(
      BuildContext context) {
    OeeApi oeeApi = OeeApi(context);
    return oeeApi.getListOfDownTimeByCompanySiteEqAndDateRange(
        AppCache.sortFilterCacheDTO!.preferredCompany!,
        AppCache.sortFilterCacheDTO!.preferredSite!,
        // AppCache.sortFilterCacheDTO!.defaultEquipments![0].equipmentId!,
        AppCache.sortFilterCacheDTO!.preferredEquipments!.equipmentId!,
        DateFormat("yyyy-MM-dd")
            .format(AppCache.sortFilterCacheDTO!.startDate!),
        DateFormat("yyyy-MM-dd").format(AppCache.sortFilterCacheDTO!.endDate!),
        AppCache.sortFilterCacheDTO!.dtmPreferredRange!);
  }

  Future<DownTimeMonitoringDTO>
      getListOfDownTimeDetailsByCompanySiteEqAndDateRange(
          BuildContext context) {
    OeeApi oeeApi = OeeApi(context);
    return oeeApi.getListOfDownTimeDetailsByCompanySiteEqAndDateRange(
        AppCache.sortFilterCacheDTO!.preferredCompany!,
        AppCache.sortFilterCacheDTO!.preferredSite!,
        // AppCache.sortFilterCacheDTO!.defaultEquipments![0].equipmentId!,
        AppCache.sortFilterCacheDTO!.preferredEquipments!.equipmentId!,
        DateFormat("yyyy-MM-dd")
            .format(AppCache.sortFilterCacheDTO!.startDate!),
        DateFormat("yyyy-MM-dd").format(AppCache.sortFilterCacheDTO!.endDate!),
        AppCache.sortFilterCacheDTO!.dtmPreferredRange!);
  }

  Future<OeeEquipmentDTO> getDailyCountByEquipments(BuildContext context) {
    OeeApi oeeApi = OeeApi(context);
    return oeeApi.getDailyCountByEquipments(
        AppCache.sortFilterCacheDTO!.preferredCompany!,
        AppCache.sortFilterCacheDTO!.preferredSite!,
        DateFormat("yyyyMMdd").format(AppCache.sortFilterCacheDTO!.startDate!),
        DateFormat("yyyyMMdd").format(AppCache.sortFilterCacheDTO!.endDate!));
  }

  Future<OeeEquipmentDTO> getDailyCountByProject(BuildContext context) {
    OeeApi oeeApi = OeeApi(context);
    return oeeApi.getDailyCountByProject(
        AppCache.sortFilterCacheDTO!.preferredCompany!,
        AppCache.sortFilterCacheDTO!.preferredSite!,
        DateFormat("yyyyMMdd").format(AppCache.sortFilterCacheDTO!.startDate!),
        DateFormat("yyyyMMdd").format(AppCache.sortFilterCacheDTO!.endDate!));
  }

  Future<OeeEquipmentDTO> getDailyOEEScoreByEquipments(BuildContext context) {
    OeeApi oeeApi = OeeApi(context);
    return oeeApi.getDailyOEEScoreByEquipments(
        AppCache.sortFilterCacheDTO!.preferredCompany!,
        AppCache.sortFilterCacheDTO!.preferredSite!,
        DateFormat("yyyyMMdd").format(AppCache.sortFilterCacheDTO!.startDate!),
        DateFormat("yyyyMMdd").format(AppCache.sortFilterCacheDTO!.endDate!));
  }

  Future<OeeEquipmentDTO> getVolumeOutputbyEquipment(BuildContext context) {
    OeeApi oeeApi = OeeApi(context);
    return oeeApi.getDailyVolumeByEquipment(
        AppCache.sortFilterCacheDTO!.preferredCompany!,
        AppCache.sortFilterCacheDTO!.preferredSite!,
        DateFormat("yyyyMMdd").format(AppCache.sortFilterCacheDTO!.startDate!),
        DateFormat("yyyyMMdd").format(AppCache.sortFilterCacheDTO!.endDate!));
  }

  Future<OeeEquipmentDTO> getVolumeOutputbyProject(BuildContext context) {
    OeeApi oeeApi = OeeApi(context);
    return oeeApi.getDailyVolumeByProject(
        AppCache.sortFilterCacheDTO!.preferredCompany!,
        AppCache.sortFilterCacheDTO!.preferredSite!,
        DateFormat("yyyyMMdd").format(AppCache.sortFilterCacheDTO!.startDate!),
        DateFormat("yyyyMMdd").format(AppCache.sortFilterCacheDTO!.endDate!));
  }

  @override
  void initState() {
    super.initState();
    Utils.setFirebaseAnalyticsCurrentScreen(
        Constants.ANALYTICS_OEE_DASHBOARD_CHART_DETAIL_SCREEN);

    if (AppCache.sortFilterCacheDTO!.dtmPreferredRange == null) {
      AppCache.sortFilterCacheDTO!.dtmPreferredRange = 'Date';
    }

    callAllData(context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  getcreditName(BuildContext context) async {
    setState(() {
      if (AppCache.sortFilterCacheDTO!.dtmPreferredRange == "Date" ||
          AppCache.sortFilterCacheDTO!.dtmPreferredRange == null) {
        dtmCredit = Utils.getTranslated(context, 'oee_credit_dateminus')!;
      } else if (AppCache.sortFilterCacheDTO!.dtmPreferredRange == "Week") {
        dtmCredit = Utils.getTranslated(context, 'oee_credit_weekminus')!;
      } else if (AppCache.sortFilterCacheDTO!.dtmPreferredRange == "Month") {
        dtmCredit = Utils.getTranslated(context, 'oee_credit_monthminus')!;
      } else {
        dtmCredit = Utils.getTranslated(context, 'oee_credit_shiftminus')!;
      }
    });
  }

  callAllData(BuildContext context) async {
    if (widget.dataType == Constants.CHART_OEE_DASHBOARD_DAILY_VO_EQUIPMENT) {
      await getDailyCountByEquipments(context).then((value) {
        oeeEquipmentDTO_rawData = value;
        if (oeeEquipmentDTO_rawData != null) {
          oeeEquipmentDTO_rawData!.data!.forEach((element) {
            bool exists = selectedEquipmentList!
                .any((x) => x.equipmentId == element.equipmentName);
            if (!exists) {
              EquipmentDataDTO data = EquipmentDataDTO(
                  equipmentId: element.equipmentName, isSelected: true);
              //  print(element.equipmentName);
              selectedEquipmentList!.add(data);
            }
          });
          print('done');
        }
      }).catchError((error) {
        Utils.printInfo(error);
      });
      setState(() {
        isLoading = false;
        // print('test');
      });
    }
    if (widget.dataType == Constants.CHART_OEE_DASHBOARD_VO_EQUIPMENT) {
      await getVolumeOutputbyEquipment(context).then((value) {
        oeeEquipmentDTO_rawData = value;
        if (oeeEquipmentDTO_rawData != null) {
          oeeEquipmentDTO_rawData!.data!.forEach((element) {
            bool exists = selectedEquipmentList!
                .any((x) => x.equipmentId == element.equipmentName);
            if (!exists) {
              EquipmentDataDTO data = EquipmentDataDTO(
                  equipmentId: element.equipmentName, isSelected: true);
              //  print(element.equipmentName);
              selectedEquipmentList!.add(data);
            }
          });
          print('done');
        }
      }).catchError((error) {
        Utils.printInfo(error);
      });
      setState(() {
        isLoading = false;
        // print('test');
      });
    }
    if (widget.dataType ==
        Constants.CHART_OEE_DASHBOARD_DAILY_SCORE_EQUIPMENT) {
      await getDailyOEEScoreByEquipments(context).then((value) {
        oeeEquipmentDTO_rawData = value;
        if (oeeEquipmentDTO_rawData != null) {
          oeeEquipmentDTO_rawData!.data!.forEach((element) {
            bool exists = selectedEquipmentList!
                .any((x) => x.equipmentId == element.equipmentName);
            if (!exists) {
              EquipmentDataDTO data = EquipmentDataDTO(
                  equipmentId: element.equipmentName, isSelected: true);
              //  print(element.equipmentName);
              selectedEquipmentList!.add(data);
            }
          });
          print('done');
        }
      }).catchError((error) {
        Utils.printInfo(error);
      });
      setState(() {
        isLoading = false;
        // print('test');
      });
    }
    if (widget.dataType == Constants.CHART_OEE_DASHBOARD_DAILY_VO_PROJECT) {
      await getDailyCountByProject(context).then((value) {
        oeeEquipmentDTO_rawData = value;
        if (oeeEquipmentDTO_rawData != null) {
          oeeEquipmentDTO_rawData!.data!.forEach((element) {
            bool exists = selectedEquipmentList!
                .any((x) => x.equipmentId == element.projectId);
            if (!exists) {
              EquipmentDataDTO data = EquipmentDataDTO(
                  equipmentId: element.projectId, isSelected: true);
              //  print(element.equipmentName);
              selectedEquipmentList!.add(data);
              print(selectedEquipmentList![0].equipmentId);
            }
          });
          print('done');
        }
      }).catchError((error) {
        Utils.printInfo(error);
      });
      setState(() {
        isLoading = false;
        // print('test');
      });
    }
    if (widget.dataType == Constants.CHART_OEE_DASHBOARD_VO_PROJECT) {
      await getVolumeOutputbyProject(context).then((value) {
        oeeEquipmentDTO_rawData = value;

        if (oeeEquipmentDTO_rawData != null) {
          oeeEquipmentDTO_rawData!.data!.forEach((element) {
            bool exists = selectedEquipmentList!
                .any((x) => x.equipmentId == element.projectId);
            if (!exists) {
              EquipmentDataDTO data = EquipmentDataDTO(
                  equipmentId: element.projectId, isSelected: true);
              //  print(element.equipmentName);
              selectedEquipmentList!.add(data);
              print(selectedEquipmentList![0].equipmentId);
            }
          });
          print('done');
        }
      }).catchError((error) {
        Utils.printInfo(error);
      });
      setState(() {
        isLoading = false;
        // print('test');
      });
    }
    if (widget.dataType ==
        Constants.CHART_OEE_DASHBOARD_DAILY_UTIL_ALL_EQUIPMENT) {
      setState(() {
        isLoading = false;
        oeeAvailabilityDTO = widget.oeeAvailabilityDTO;
      });
    }
    if (widget.dataType == Constants.CHART_OEE_DTM_SUMMARY) {
      await getListOfDownTimeByCompanySiteEqAndDateRange(context).then((value) {
        summaryUtilAndNonUtilData = value;
      }).catchError((error) {
        Utils.printInfo(error);
      });
      setState(() {
        isLoading = false;
        // print('test');
      });
    }
    if (widget.dataType == Constants.CHART_OEE_DTM_DETAILBREAKDOWN) {
      await getListOfDownTimeDetailsByCompanySiteEqAndDateRange(context)
          .then((value) {
        detailBreakdownData = value;
        // print(AppCache.sortFilterCacheDTO!.defaultEquipments![0].equipmentId!);
        //  print(summaryUtilAndNonUtilData.data![0]);
      }).catchError((error) {
        Utils.printInfo(error);
      });
      setState(() {
        isLoading = false;
      });
    }
  }

  void showTooltipsDialog(
    BuildContext context,
    OeeAvailabilityDTO? dialogDTO,
  ) {
    showDialog(
        context: context,
        builder: (tooltipsDialogContext) {
          if (widget.dataType ==
              Constants.CHART_OEE_DASHBOARD_DAILY_UTIL_ALL_EQUIPMENT) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              elevation: 0,
              backgroundColor: Colors.transparent,
              child: chartTooltipsInfo(tooltipsDialogContext, dialogDTO),
            );
          } else if (widget.dataType ==
              Constants.CHART_OEE_DASHBOARD_VO_PROJECT) {
            return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                elevation: 0,
                backgroundColor: Colors.transparent,
                child: chartVObyProjectInfo(context, chartReturnVOPDTO));
          } else if (widget.dataType ==
              Constants.CHART_OEE_DASHBOARD_VO_EQUIPMENT) {
            return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                elevation: 0,
                backgroundColor: Colors.transparent,
                child: chartVObyEquipmentInfo(context, chartReturnVOEDTO));
          } else {
            return Container();
          }
        });
  }

  void showSummaryTooltipsDialog(
    BuildContext context,
  ) {
    if (AppCache.sortFilterCacheDTO!.dtmPreferredRange == 'Date') {
      DateTime time =
          DateTime.fromMicrosecondsSinceEpoch(int.parse(dtmKey!) * 1000);

      String date = DateFormat.yMMMMEEEEd().format(time);
      String key = DateFormat("yyyy-MM-dd").format(time);
      DownTimeMonitoringDataDTO data = summaryUtilAndNonUtilData!.data![key]!;
      showDialog(
          context: context,
          builder: (tooltipsDialogContext) {
            return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                elevation: 0,
                backgroundColor: Colors.transparent,
                child: Container(
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
                        date != null ? date : 'test',
                        style: AppFonts.robotoRegular(
                          16,
                          color: theme_dark!
                              ? AppColors.appGrey2()
                              : AppColorsLightMode.appGrey2(),
                          decoration: TextDecoration.none,
                        ),
                      ),
                      SizedBox(height: 16),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Utils.getTranslated(
                                  context, 'oee_sceduledNonUtil')!,
                              style: AppFonts.robotoRegular(
                                14,
                                color: HexColor("E30329"),
                                decoration: TextDecoration.none,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              ':',
                              style: AppFonts.robotoRegular(
                                14,
                                color: theme_dark!
                                    ? AppColors.appGrey2()
                                    : AppColorsLightMode.appGrey2(),
                                decoration: TextDecoration.none,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              data.scheduledNonUtilizationTime!
                                  .toStringAsFixed(2),
                              style: AppFonts.robotoRegular(
                                14,
                                color: theme_dark!
                                    ? AppColors.appGrey2()
                                    : AppColorsLightMode.appGrey2(),
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ]),
                      SizedBox(height: 14),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Utils.getTranslated(context, 'oee_sceduledUtil')!,
                              style: AppFonts.robotoRegular(
                                14,
                                color: HexColor("72D12C"),
                                decoration: TextDecoration.none,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              ':',
                              style: AppFonts.robotoRegular(
                                14,
                                color: theme_dark!
                                    ? AppColors.appGrey2()
                                    : AppColorsLightMode.appGrey2(),
                                decoration: TextDecoration.none,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              data.scheduledUtilizationTime!.toStringAsFixed(2),
                              style: AppFonts.robotoRegular(
                                14,
                                color: theme_dark!
                                    ? AppColors.appGrey2()
                                    : AppColorsLightMode.appGrey2(),
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ]),
                      SizedBox(height: 14),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Utils.getTranslated(
                                  context, 'oee_unsceduledNonUtil')!,
                              style: AppFonts.robotoRegular(
                                14,
                                color: HexColor("D5B51D"),
                                decoration: TextDecoration.none,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              ':',
                              style: AppFonts.robotoRegular(
                                14,
                                color: theme_dark!
                                    ? AppColors.appGrey2()
                                    : AppColorsLightMode.appGrey2(),
                                decoration: TextDecoration.none,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              data.unscheduledUtilizationTime!
                                  .toStringAsFixed(2),
                              style: AppFonts.robotoRegular(
                                14,
                                color: theme_dark!
                                    ? AppColors.appGrey2()
                                    : AppColorsLightMode.appGrey2(),
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ]),
                    ],
                  ),
                ));
          });
    } else {
      DownTimeMonitoringDataDTO data =
          summaryUtilAndNonUtilData!.data![dtmKey]!;
      String key = dtmKey!;

      showDialog(
          context: context,
          builder: (tooltipsDialogContext) {
            return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                elevation: 0,
                backgroundColor: Colors.transparent,
                child: Container(
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
                        key,
                        style: AppFonts.robotoRegular(
                          16,
                          color: theme_dark!
                              ? AppColors.appGrey2()
                              : AppColorsLightMode.appGrey2(),
                          decoration: TextDecoration.none,
                        ),
                      ),
                      SizedBox(height: 16),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Utils.getTranslated(
                                  context, 'oee_sceduledNonUtil')!,
                              style: AppFonts.robotoRegular(
                                14,
                                color: HexColor("E30329"),
                                decoration: TextDecoration.none,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              ':',
                              style: AppFonts.robotoRegular(
                                14,
                                color: theme_dark!
                                    ? AppColors.appGrey2()
                                    : AppColorsLightMode.appGrey2(),
                                decoration: TextDecoration.none,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              data.scheduledNonUtilizationTime!
                                  .toStringAsFixed(2),
                              style: AppFonts.robotoRegular(
                                14,
                                color: theme_dark!
                                    ? AppColors.appGrey2()
                                    : AppColorsLightMode.appGrey2(),
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ]),
                      SizedBox(height: 16),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Utils.getTranslated(context, 'oee_sceduledUtil')!,
                              style: AppFonts.robotoRegular(
                                14,
                                color: HexColor("72D12C"),
                                decoration: TextDecoration.none,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              ':',
                              style: AppFonts.robotoRegular(
                                14,
                                color: theme_dark!
                                    ? AppColors.appGrey2()
                                    : AppColorsLightMode.appGrey2(),
                                decoration: TextDecoration.none,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              data.scheduledUtilizationTime!.toStringAsFixed(2),
                              style: AppFonts.robotoRegular(
                                14,
                                color: theme_dark!
                                    ? AppColors.appGrey2()
                                    : AppColorsLightMode.appGrey2(),
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ]),
                      SizedBox(height: 16),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Utils.getTranslated(
                                  context, 'oee_unsceduledNonUtil')!,
                              style: AppFonts.robotoRegular(
                                14,
                                color: HexColor("D5B51D"),
                                decoration: TextDecoration.none,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              ':',
                              style: AppFonts.robotoRegular(
                                14,
                                color: theme_dark!
                                    ? AppColors.appGrey2()
                                    : AppColorsLightMode.appGrey2(),
                                decoration: TextDecoration.none,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              data.unscheduledUtilizationTime!
                                  .toStringAsFixed(2),
                              style: AppFonts.robotoRegular(
                                14,
                                color: theme_dark!
                                    ? AppColors.appGrey2()
                                    : AppColorsLightMode.appGrey2(),
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ]),
                    ],
                  ),
                ));
          });
    }
    //print(data);
  }

  Widget chartVObyEquipmentInfo(BuildContext ctx, OeeChartVOEReturnDTO? data) {
    List<String> g = [];
    if (!data!.color!.contains('#')) {
      String x = data.color!.replaceAll('rgb(', '');
      x = x.replaceAll(')', '');

      g = x.split(",");
      //print(g);
    }
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
            data.equipmentName!,
            style: AppFonts.robotoRegular(
              16,
              color: theme_dark!
                  ? AppColors.appGrey2()
                  : AppColorsLightMode.appGrey2(),
              decoration: TextDecoration.none,
            ),
          ),
          SizedBox(height: 14),
          Container(
            // padding: EdgeInsets.fromLTRB(14.0, 12.0, 14.0, 12.0),
            decoration: BoxDecoration(
              color: AppColors.appBlack2C(),
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Row(children: [
              Text(
                Utils.getTranslated(ctx, 'oee_count')!,
                style: AppFonts.robotoRegular(
                  14,
                  color: data.color!.contains('#')
                      ? HexColor(data.color!)
                      : Color.fromRGBO(
                          int.parse(g[0]), int.parse(g[1]), int.parse(g[2]), 1),
                  decoration: TextDecoration.none,
                ),
              ),
              Text(
                ':',
                style: AppFonts.robotoRegular(
                  14,
                  color: theme_dark!
                      ? AppColors.appGrey2()
                      : AppColorsLightMode.appGrey2(),
                  decoration: TextDecoration.none,
                ),
              ),
              Text(
                data.count!.toString(),
                style: AppFonts.robotoRegular(
                  14,
                  color: theme_dark!
                      ? AppColors.appGrey2()
                      : AppColorsLightMode.appGrey2(),
                  decoration: TextDecoration.none,
                ),
              ),
            ]),
          )
        ],
      ),
    );
  }

  Widget chartVObyProjectInfo(BuildContext ctx, OeeChartReturnDTO? x) {
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
            x!.id!,
            style: AppFonts.robotoRegular(
              16,
              color: theme_dark!
                  ? AppColors.appGrey2()
                  : AppColorsLightMode.appGrey2(),
              decoration: TextDecoration.none,
            ),
          ),
          SizedBox(height: 14),
          Wrap(
            children: x.data!.map((e) => companyDataItem(ctx, e)).toList(),
          )
        ],
      ),
    );
  }

  Widget companyDataItem(BuildContext ctx, OeeChartReturnDataDTO? data) {
    List<String> g = [];
    if (!data!.color!.contains('#')) {
      String x = data.color!.replaceAll('rgb(', '');
      x = x.replaceAll(')', '');

      g = x.split(",");
      //print(g);
    }

    return Container(
      // padding: EdgeInsets.fromLTRB(14.0, 12.0, 14.0, 12.0),
      decoration: BoxDecoration(
        color: AppColors.appBlack2C(),
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Row(children: [
        Text(
          data.equipmentName != null ? data.equipmentName! : '',
          style: AppFonts.robotoRegular(
            14,
            color: data.color!.contains('#')
                ? HexColor(data.color!)
                : Color.fromRGBO(
                    int.parse(g[0]), int.parse(g[1]), int.parse(g[2]), 1),
            decoration: TextDecoration.none,
          ),
        ),
        Text(
          ':',
          style: AppFonts.robotoRegular(
            14,
            color: theme_dark!
                ? AppColors.appGrey2()
                : AppColorsLightMode.appGrey2(),
            decoration: TextDecoration.none,
          ),
        ),
        Text(
          data.count != null ? data.count!.toString() : '',
          style: AppFonts.robotoRegular(
            14,
            color: theme_dark!
                ? AppColors.appGrey2()
                : AppColorsLightMode.appGrey2(),
            decoration: TextDecoration.none,
          ),
        ),
      ]),
    );
  }

  Widget chartTooltipsInfo(
      BuildContext ctx, OeeAvailabilityDTO? jsDailyBoardVolumeDataDTO) {
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
            DateFormat("EEEE, MMM dd, yyyy").format(
                DateTime.parse(jsDailyBoardVolumeDataDTO!.data![0].date!)),
            style: AppFonts.robotoRegular(
              16,
              color: theme_dark!
                  ? AppColors.appGrey2()
                  : AppColorsLightMode.appGrey2(),
              decoration: TextDecoration.none,
            ),
          ),
          SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      Utils.getTranslated(context, 'oee_available_time')!,
                      style: AppFonts.robotoMedium(
                        14,
                        color: HexColor('73d329'),
                        decoration: TextDecoration.none,
                      ),
                    ),
                    SizedBox(width: 10.0),
                    Text(
                      jsDailyBoardVolumeDataDTO.data![0].availableTime!
                          .toString(),
                      style: AppFonts.robotoRegular(
                        16,
                        color: theme_dark!
                            ? AppColors.appGrey2()
                            : AppColorsLightMode.appGrey2(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      Utils.getTranslated(context, 'oee_ultilisation_time')!,
                      style: AppFonts.robotoMedium(
                        14,
                        color: HexColor('73d329'),
                        decoration: TextDecoration.none,
                      ),
                    ),
                    SizedBox(width: 10.0),
                    Text(
                      jsDailyBoardVolumeDataDTO.data![0].utilizationTime!
                          .toString(),
                      style: AppFonts.robotoRegular(
                        16,
                        color: theme_dark!
                            ? AppColors.appGrey2()
                            : AppColorsLightMode.appGrey2(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      Utils.getTranslated(context, 'oee_plannedDownTime')!,
                      style: AppFonts.robotoMedium(
                        14,
                        color: HexColor('73d329'),
                        decoration: TextDecoration.none,
                      ),
                    ),
                    SizedBox(width: 10.0),
                    Text(
                      jsDailyBoardVolumeDataDTO.data![0].plannedDownTime!
                          .toString(),
                      style: AppFonts.robotoRegular(
                        16,
                        color: theme_dark!
                            ? AppColors.appGrey2()
                            : AppColorsLightMode.appGrey2(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      Utils.getTranslated(context, 'oee_downTime')!,
                      style: AppFonts.robotoMedium(
                        14,
                        color: HexColor('73d329'),
                        decoration: TextDecoration.none,
                      ),
                    ),
                    SizedBox(width: 10.0),
                    Text(
                      jsDailyBoardVolumeDataDTO.data![0].downTime!.toString(),
                      style: AppFonts.robotoRegular(
                        16,
                        color: theme_dark!
                            ? AppColors.appGrey2()
                            : AppColorsLightMode.appGrey2(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
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
            widget.chartName,
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
            // if (widget.dataType ==
            //         Constants.CHART_OEE_DASHBOARD_DAILY_VO_EQUIPMENT ||
            //     widget.dataType ==
            //         Constants.CHART_OEE_DASHBOARD_DAILY_SCORE_EQUIPMENT ||
            //     widget.dataType == Constants.CHART_OEE_DASHBOARD_VO_EQUIPMENT ||
            //     widget.dataType ==
            //         Constants.CHART_OEE_DASHBOARD_DAILY_VO_PROJECT ||
            //     widget.dataType == Constants.CHART_OEE_DASHBOARD_VO_PROJECT) {
            //   Navigator.pop(context, oeeEquipmentDTO);
            // } else
            Navigator.pop(context);
          },
          child: Image.asset(
            theme_dark!
                ? Constants.ASSET_IMAGES + 'back_bttn.png'
                : Constants.ASSET_IMAGES_LIGHT + 'back_bttn.png',
          ),
        ),
        actions: [
          GestureDetector(
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
      body: SafeArea(
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(AppColors.appBlue()),
                ),
              )
            : Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: [
                          chart(context),
                          chartInfo(context),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: widget.dataType !=
                              Constants
                                  .CHART_OEE_DASHBOARD_DAILY_UTIL_ALL_EQUIPMENT
                          ? true
                          : false,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: TextButton(
                          onPressed: () async {
                            if (widget.dataType ==
                                    Constants.CHART_OEE_DTM_DETAILBREAKDOWN ||
                                widget.dataType ==
                                    Constants.CHART_OEE_DTM_SUMMARY) {
                              final result = await Navigator.pushNamed(
                                  context, AppRoutes.oeeDtmSortAndFilter);
                              if (result != null) {
                                setState(() {
                                  if (AppCache.sortFilterCacheDTO!
                                          .dtmPreferredRange ==
                                      "Date") {
                                    dtmCredit = Utils.getTranslated(
                                        context, 'oee_credit_dateminus')!;
                                  } else if (AppCache.sortFilterCacheDTO!
                                          .dtmPreferredRange ==
                                      "Week") {
                                    dtmCredit = Utils.getTranslated(
                                        context, 'oee_credit_weekminus')!;
                                  } else if (AppCache.sortFilterCacheDTO!
                                          .dtmPreferredRange ==
                                      "Month") {
                                    dtmCredit = Utils.getTranslated(
                                        context, 'oee_credit_monthminus')!;
                                  } else {
                                    dtmCredit = Utils.getTranslated(
                                        context, 'oee_credit_shiftminus')!;
                                  }
                                  print(dtmCredit);
                                  showModal = false;
                                  this
                                      .oeeWebViewController
                                      .webViewController
                                      .reload();
                                  isLoading = true;
                                });
                                callAllData(context);
                              }
                            } else if (widget.dataType ==
                                Constants
                                    .CHART_OEE_DASHBOARD_DAILY_VO_EQUIPMENT) {
                              final result = await Navigator.pushNamed(
                                  context, AppRoutes.oeeDashboardSortAndFilter,
                                  arguments: OeeChartDetailArguments(
                                    chartName: '',
                                    selectedEquipmentList:
                                        selectedEquipmentList,
                                    dataType: Constants
                                        .CHART_OEE_DASHBOARD_DAILY_VO_EQUIPMENT,
                                  ));
                              if (result != null) {
                                List<String> selectedEquipment = [];

                                this.selectedEquipmentList!.forEach((element) {
                                  if (element.isSelected!) {
                                    selectedEquipment.add(element.equipmentId!);
                                  }
                                });

                                setState(() {
                                  oeeEquipmentDTO!.data = this
                                      .oeeEquipmentDTO_rawData!
                                      .data!
                                      .where((e) => selectedEquipment
                                          .contains(e.equipmentName))
                                      .toList();
                                  this
                                      .oeeWebViewController
                                      .webViewController
                                      .reload();
                                  showModal = false;
                                });
                              }
                            } else if (widget.dataType ==
                                Constants
                                    .CHART_OEE_DASHBOARD_DAILY_SCORE_EQUIPMENT) {
                              final result = await Navigator.pushNamed(
                                  context, AppRoutes.oeeDashboardSortAndFilter,
                                  arguments: OeeChartDetailArguments(
                                      chartName: '',
                                      selectedEquipmentList:
                                          selectedEquipmentList,
                                      dataType: Constants
                                          .CHART_OEE_DASHBOARD_DAILY_SCORE_EQUIPMENT,
                                      equipmentDTO: oeeEquipmentDTO_rawData));
                              if (result != null) {
                                List<String> selectedEquipment = [];

                                this.selectedEquipmentList!.forEach((element) {
                                  if (element.isSelected!) {
                                    selectedEquipment.add(element.equipmentId!);
                                  }
                                });

                                setState(() {
                                  oeeEquipmentDTO!.data = this
                                      .oeeEquipmentDTO_rawData!
                                      .data!
                                      .where((e) => selectedEquipment
                                          .contains(e.equipmentName))
                                      .toList();
                                  this
                                      .oeeWebViewController
                                      .webViewController
                                      .reload();
                                  showModal = false;
                                });
                              }
                            } else if (widget.dataType ==
                                Constants.CHART_OEE_DASHBOARD_VO_EQUIPMENT) {
                              final result = await Navigator.pushNamed(
                                  context, AppRoutes.oeeDashboardSortAndFilter,
                                  arguments: OeeChartDetailArguments(
                                      chartName: '',
                                      selectedEquipmentList:
                                          selectedEquipmentList,
                                      dataType: Constants
                                          .CHART_OEE_DASHBOARD_VO_EQUIPMENT,
                                      equipmentDTO: oeeEquipmentDTO_rawData));
                              if (result != null) {
                                List<String> selectedEquipment = [];

                                this.selectedEquipmentList!.forEach((element) {
                                  if (element.isSelected!) {
                                    selectedEquipment.add(element.equipmentId!);
                                  }
                                });

                                setState(() {
                                  oeeEquipmentDTO!.data = this
                                      .oeeEquipmentDTO_rawData!
                                      .data!
                                      .where((e) => selectedEquipment
                                          .contains(e.equipmentName))
                                      .toList();
                                  this
                                      .oeeWebViewController
                                      .webViewController
                                      .reload();
                                  showModal = false;
                                });
                              }
                            } else if (widget.dataType ==
                                Constants.CHART_OEE_DASHBOARD_VO_PROJECT) {
                              final result = await Navigator.pushNamed(
                                  context, AppRoutes.oeeDashboardSortAndFilter,
                                  arguments: OeeChartDetailArguments(
                                      chartName: '',
                                      selectedEquipmentList:
                                          selectedEquipmentList,
                                      dataType: Constants
                                          .CHART_OEE_DASHBOARD_VO_PROJECT,
                                      equipmentDTO: oeeEquipmentDTO));
                              if (result != null) {
                                List<String> selectedEquipment = [];

                                this.selectedEquipmentList!.forEach((element) {
                                  if (element.isSelected!) {
                                    selectedEquipment.add(element.equipmentId!);
                                  }
                                });

                                setState(() {
                                  oeeEquipmentDTO!.data = this
                                      .oeeEquipmentDTO_rawData!
                                      .data!
                                      .where((e) => selectedEquipment
                                          .contains(e.projectId))
                                      .toList();
                                  this
                                      .oeeWebViewController
                                      .webViewController
                                      .reload();
                                  showModal = false;
                                });
                              }
                            } else if (widget.dataType ==
                                Constants
                                    .CHART_OEE_DASHBOARD_DAILY_VO_PROJECT) {
                              final result = await Navigator.pushNamed(
                                  context, AppRoutes.oeeDashboardSortAndFilter,
                                  arguments: OeeChartDetailArguments(
                                      chartName: '',
                                      selectedEquipmentList:
                                          selectedEquipmentList,
                                      dataType: Constants
                                          .CHART_OEE_DASHBOARD_DAILY_VO_PROJECT,
                                      equipmentDTO: oeeEquipmentDTO));
                              if (result != null) {
                                List<String> selectedEquipment = [];

                                this.selectedEquipmentList!.forEach((element) {
                                  if (element.isSelected!) {
                                    selectedEquipment.add(element.equipmentId!);
                                  }
                                });

                                setState(() {
                                  oeeEquipmentDTO!.data = this
                                      .oeeEquipmentDTO_rawData!
                                      .data!
                                      .where((e) => selectedEquipment
                                          .contains(e.projectId))
                                      .toList();
                                  this
                                      .oeeWebViewController
                                      .webViewController
                                      .reload();
                                  showModal = false;
                                });
                              }
                            }
                            // Navigator.pushNamed(
                            //    context, AppRoutes.sortAndFilterRoute);
                          },
                          child: Container(
                            padding: EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50.0),
                              color: AppColors.appTeal(),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                    Constants.ASSET_IMAGES + 'filter_icon.png'),
                                SizedBox(width: 10.0),
                                Text(
                                  Utils.getTranslated(
                                      context, 'sort_and_filter')!,
                                  style: AppFonts.robotoMedium(
                                    14,
                                    color: AppColors.appPrimaryWhite(),
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                                /* Container(
                              margin: EdgeInsets.only(left: 10.0),
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: AppColors.appRed(),
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                '2',
                                style: AppFonts.robotoMedium(
                                  14,
                                  color: AppColors.appPrimaryWhite(),
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            )*/
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget chart(BuildContext ctx) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: this.chartHeight,
      margin: EdgeInsets.only(bottom: 10),
      color: Colors.transparent,
      child: ((widget.oeeAvailabilityDTO?.data != null &&
                  widget.oeeAvailabilityDTO?.data?.length != 0) ||
              (widget.oeeEquipmentDTO?.data != null &&
                  widget.oeeEquipmentDTO?.data?.length != 0) ||
              (widget.summaryUtilAndNonUtilData?.data != null &&
                  widget.summaryUtilAndNonUtilData?.data?.length != 0) ||
              (widget.detailBreakdownData?.data != null &&
                  widget.detailBreakdownData?.data?.length != 0))
          ? WebViewPlus(
              backgroundColor: Colors.transparent,
              javascriptMode: JavascriptMode.unrestricted,
              initialUrl: theme_dark!
                  ? 'assets/html/oee_highchart_dark_theme.html'
                  : 'assets/html/oee_highchart_light_theme.html',
              zoomEnabled: false,
              gestureRecognizers: Set()
                ..add(Factory<VerticalDragGestureRecognizer>(
                    () => VerticalDragGestureRecognizer()))
                ..add(Factory<ScaleGestureRecognizer>(
                    () => ScaleGestureRecognizer())),
              onWebViewCreated: (controllerPlus) {
                this.oeeWebViewController = controllerPlus;
              },
              onPageFinished: (url) {
                this.oeeWebViewController.getHeight().then((value) {
                  Utils.printInfo(value);
                  setState(() {
                    this.chartHeight = value;
                  });
                });
              },
              javascriptChannels: [
                JavascriptChannel(
                    name: 'OEEChannel',
                    onMessageReceived: (message) {
                      print(message.message);
                      if (widget.dataType ==
                          Constants
                              .CHART_OEE_DASHBOARD_DAILY_UTIL_ALL_EQUIPMENT) {
                        this.oeeWebViewController.webViewController.runJavascript(
                            'fetchDailyUtilisationbyAllEquipmentDetail(${jsonEncode(this.oeeAvailabilityDTO)}, "${DateFormat("yyyy-MM-dd").format(AppCache.sortFilterCacheDTO!.startDate!)}", "${DateFormat("yyyy-MM-dd").format(AppCache.sortFilterCacheDTO!.endDate!)}","${Utils.getTranslated(context, 'oee_available_time')}","${Utils.getTranslated(context, 'oee_ultilisation_time')}","${Utils.getTranslated(context, 'oee_downTime')}","${Utils.getTranslated(context, 'oee_legend_planneddowntime')}","${Utils.getTranslated(context, 'oee_credit_dateminus')}")');
                      } else if (widget.dataType ==
                          Constants.CHART_OEE_DASHBOARD_VO_PROJECT) {
                        this.oeeWebViewController.webViewController.runJavascript(
                            'fetchVolumeByProjectDataDetail(${jsonEncode((oeeEquipmentDTO!.data != null) ? oeeEquipmentDTO : oeeEquipmentDTO_rawData)}, "${DateFormat("yyyy-MM-dd").format(AppCache.sortFilterCacheDTO!.startDate!)}", "${DateFormat("yyyy-MM-dd").format(AppCache.sortFilterCacheDTO!.endDate!)}","${Utils.getTranslated(context, 'oee_credit_projectcount')}")');
                      } else if (widget.dataType ==
                          Constants.CHART_OEE_DASHBOARD_VO_EQUIPMENT) {
                        this.oeeWebViewController.webViewController.runJavascript(
                            'fetchVolumeByEquipmentDataDetail(${jsonEncode((oeeEquipmentDTO!.data != null) ? oeeEquipmentDTO : oeeEquipmentDTO_rawData)}, "${DateFormat("yyyy-MM-dd").format(AppCache.sortFilterCacheDTO!.startDate!)}", "${DateFormat("yyyy-MM-dd").format(AppCache.sortFilterCacheDTO!.endDate!)}","${Utils.getTranslated(context, 'oee_credit_equipmentcount')}")');
                      } else if (widget.dataType ==
                          Constants.CHART_OEE_DASHBOARD_DAILY_VO_EQUIPMENT) {
                        this.oeeWebViewController.webViewController.runJavascript(
                            'fetchDailyVolumeByEquipmentDetail(${jsonEncode((oeeEquipmentDTO!.data != null) ? oeeEquipmentDTO : oeeEquipmentDTO_rawData)}, "${DateFormat("yyyy-MM-dd").format(AppCache.sortFilterCacheDTO!.startDate!)}", "${DateFormat("yyyy-MM-dd").format(AppCache.sortFilterCacheDTO!.endDate!)}","${Utils.getTranslated(context, 'oee_credit_dateeqcount')}")');
                      } else if (widget.dataType ==
                          Constants.CHART_OEE_DASHBOARD_DAILY_VO_PROJECT) {
                        this.oeeWebViewController.webViewController.runJavascript(
                            'fetchDailyVolumeByProjectDetail(${jsonEncode((oeeEquipmentDTO!.data != null) ? oeeEquipmentDTO : oeeEquipmentDTO_rawData)}, "${DateFormat("yyyy-MM-dd").format(AppCache.sortFilterCacheDTO!.startDate!)}", "${DateFormat("yyyy-MM-dd").format(AppCache.sortFilterCacheDTO!.endDate!)}","${Utils.getTranslated(context, 'oee_credit_dateprojcount')}")');
                      } else if (widget.dataType ==
                          Constants.CHART_OEE_DASHBOARD_DAILY_SCORE_EQUIPMENT) {
                        this.oeeWebViewController.webViewController.runJavascript(
                            'fetchDailyOEEScoreDetail(${jsonEncode((oeeEquipmentDTO!.data != null) ? oeeEquipmentDTO : oeeEquipmentDTO_rawData)}, "${DateFormat("yyyy-MM-dd").format(AppCache.sortFilterCacheDTO!.startDate!)}", "${DateFormat("yyyy-MM-dd").format(AppCache.sortFilterCacheDTO!.endDate!)}","${Utils.getTranslated(context, 'oee_credit_dateOEEscore')}")');
                      } else if (widget.dataType ==
                          Constants.CHART_OEE_DTM_SUMMARY) {
                        getcreditName(context);
                        this.oeeWebViewController.webViewController.runJavascript(
                            'fetchSummaryUtilAndNonUtilDetail(${jsonEncode(summaryUtilAndNonUtilData)}, "${DateFormat("yyyy-MM-dd").format(AppCache.sortFilterCacheDTO!.startDate!)}", "${DateFormat("yyyy-MM-dd").format(AppCache.sortFilterCacheDTO!.endDate!)}","${AppCache.sortFilterCacheDTO!.dtmPreferredRange}","$dtmCredit","${Utils.getTranslated(context, 'oee_sceduledNonUtil')}","${Utils.getTranslated(context, 'oee_sceduledUtil')}","${Utils.getTranslated(context, 'oee_unsceduledNonUtil')}")');
                      } else if (widget.dataType ==
                          Constants.CHART_OEE_DTM_DETAILBREAKDOWN) {
                        // print('hihi');
                        getcreditName(context);
                        this.oeeWebViewController.webViewController.runJavascript(
                            'fetchdetailBreakdownforscedulesNonUtilTimeData(${jsonEncode(detailBreakdownData)}, "${DateFormat("yyyy-MM-dd").format(AppCache.sortFilterCacheDTO!.startDate!)}", "${DateFormat("yyyy-MM-dd").format(AppCache.sortFilterCacheDTO!.endDate!)}","${AppCache.sortFilterCacheDTO!.dtmPreferredRange}","$dtmCredit","${Utils.getTranslated(context, 'csv_DIAGNOSTIC_MAINTENANCE')}","${Utils.getTranslated(context, 'csv_IDLE')}","${Utils.getTranslated(context, 'csv_LOST_HEARTBEAT')}","${Utils.getTranslated(context, 'csv_FIXTURE_CHANGE')}","${Utils.getTranslated(context, 'csv_SYSTEM_TILT')}")');
                        //   print('hihi');
                      }
                    }),
                JavascriptChannel(
                    name: 'OEEClickChannel',
                    onMessageReceived: (message) {
                      print(message.message);
                      if (widget.dataType ==
                          Constants
                              .CHART_OEE_DASHBOARD_DAILY_UTIL_ALL_EQUIPMENT) {
                        // dailyUTILDialogDTO = OeeAvailabilityDTO.fromJson(
                        //   jsonDecode(message.message));
                        setState(() {
                          utilKey = message.message;
                          showModal = true;
                        });

                        // showTooltipsDialog(ctx, dailyUTILDialogDTO!);
                      } else if (widget.dataType ==
                          Constants.CHART_OEE_DASHBOARD_VO_PROJECT) {
                        setState(() {
                          chartReturnVOPDTO = OeeChartReturnDTO.fromJson(
                              jsonDecode(message.message));
                        });
                        showTooltipsDialog(ctx, null);
                      } else if (widget.dataType ==
                          Constants.CHART_OEE_DASHBOARD_VO_EQUIPMENT) {
                        setState(() {
                          print('chartReturnVOEDTsssO');
                          chartReturnVOEDTO = OeeChartVOEReturnDTO.fromJson(
                              jsonDecode(message.message));
                          print('chartReturnVOEDTO');
                        });
                        showTooltipsDialog(ctx, null);
                      } else if (widget.dataType ==
                          Constants.CHART_OEE_DASHBOARD_DAILY_VO_EQUIPMENT) {
                        setState(() {
                          chartReturnVOPDTO = OeeChartReturnDTO.fromJson(
                              jsonDecode(message.message));
                          showModal = true;
                        });
                      } else if (widget.dataType ==
                          Constants.CHART_OEE_DASHBOARD_DAILY_VO_PROJECT) {
                        setState(() {
                          chartReturnVOPDTO = OeeChartReturnDTO.fromJson(
                              jsonDecode(message.message));
                          showModal = true;
                        });
                      } else if (widget.dataType ==
                          Constants.CHART_OEE_DASHBOARD_DAILY_SCORE_EQUIPMENT) {
                        setState(() {
                          chartReturnVOPDTO = OeeChartReturnDTO.fromJson(
                              jsonDecode(message.message));
                          print('chartReturnVOPDTO');
                          showModal = true;
                        });
                      } else if (widget.dataType ==
                          Constants.CHART_OEE_DTM_SUMMARY) {
                        setState(() {
                          dtmKey = message.message;
                          print('summary');
                        });
                        showSummaryTooltipsDialog(ctx);
                      } else if (widget.dataType ==
                          Constants.CHART_OEE_DTM_DETAILBREAKDOWN) {
                        setState(() {
                          dtmKey = message.message;
                          print('detailbreakdown');
                          //print(dtmKey);
                          showModal = true;
                        });
                      }
                    }),
                JavascriptChannel(
                    name: 'DQMExportImageChannel',
                    onMessageReceived: (message) async {
                      print(message.message);
                      if (Utils.isNotEmpty(message.message)) {
                        String name = '';
                        String curDate =
                            '#${DateFormat('yyyy.MM.dd').format(DateTime.now())}@${DateFormat('HH.mm.ss').format(DateTime.now())}';

                        if (widget.dataType ==
                            Constants
                                .CHART_OEE_DASHBOARD_DAILY_UTIL_ALL_EQUIPMENT) {
                          name = Utils.getExportFilename(
                            'DlyUtiEqp',
                            companyId:
                                AppCache.sortFilterCacheDTO!.preferredCompany,
                            siteId: AppCache.sortFilterCacheDTO!.preferredSite,
                            fromDate: DateFormat('yyyy-MM-dd').format(
                                AppCache.sortFilterCacheDTO!.startDate!),
                            toDate: DateFormat('yyyy-MM-dd')
                                .format(AppCache.sortFilterCacheDTO!.endDate!),
                            currentDate: curDate,
                            expType: '.png',
                          );
                        } else if (widget.dataType ==
                            Constants.CHART_OEE_DASHBOARD_VO_PROJECT) {
                          name = Utils.getExportFilename(
                            'VolOtptProj',
                            companyId:
                                AppCache.sortFilterCacheDTO!.preferredCompany,
                            siteId: AppCache.sortFilterCacheDTO!.preferredSite,
                            fromDate: DateFormat('yyyy-MM-dd').format(
                                AppCache.sortFilterCacheDTO!.startDate!),
                            toDate: DateFormat('yyyy-MM-dd')
                                .format(AppCache.sortFilterCacheDTO!.endDate!),
                            currentDate: curDate,
                            expType: '.png',
                          );
                        } else if (widget.dataType ==
                            Constants.CHART_OEE_DASHBOARD_VO_EQUIPMENT) {
                          name = Utils.getExportFilename(
                            'VolOtptEqp',
                            companyId:
                                AppCache.sortFilterCacheDTO!.preferredCompany,
                            siteId: AppCache.sortFilterCacheDTO!.preferredSite,
                            fromDate: DateFormat('yyyy-MM-dd').format(
                                AppCache.sortFilterCacheDTO!.startDate!),
                            toDate: DateFormat('yyyy-MM-dd')
                                .format(AppCache.sortFilterCacheDTO!.endDate!),
                            currentDate: curDate,
                            expType: '.png',
                          );
                        } else if (widget.dataType ==
                            Constants.CHART_OEE_DASHBOARD_DAILY_VO_EQUIPMENT) {
                          name = Utils.getExportFilename(
                            'DlyVolOtptEqp',
                            companyId:
                                AppCache.sortFilterCacheDTO!.preferredCompany,
                            siteId: AppCache.sortFilterCacheDTO!.preferredSite,
                            fromDate: DateFormat('yyyy-MM-dd').format(
                                AppCache.sortFilterCacheDTO!.startDate!),
                            toDate: DateFormat('yyyy-MM-dd')
                                .format(AppCache.sortFilterCacheDTO!.endDate!),
                            currentDate: curDate,
                            expType: '.png',
                          );
                        } else if (widget.dataType ==
                            Constants.CHART_OEE_DASHBOARD_DAILY_VO_PROJECT) {
                          name = Utils.getExportFilename(
                            'DlyVolOtptProj',
                            companyId:
                                AppCache.sortFilterCacheDTO!.preferredCompany,
                            siteId: AppCache.sortFilterCacheDTO!.preferredSite,
                            fromDate: DateFormat('yyyy-MM-dd').format(
                                AppCache.sortFilterCacheDTO!.startDate!),
                            toDate: DateFormat('yyyy-MM-dd')
                                .format(AppCache.sortFilterCacheDTO!.endDate!),
                            currentDate: curDate,
                            expType: '.png',
                          );
                        } else if (widget.dataType ==
                            Constants
                                .CHART_OEE_DASHBOARD_DAILY_SCORE_EQUIPMENT) {
                          name = Utils.getExportFilename(
                            'DlyOEEEqp',
                            companyId:
                                AppCache.sortFilterCacheDTO!.preferredCompany,
                            siteId: AppCache.sortFilterCacheDTO!.preferredSite,
                            fromDate: DateFormat('yyyy-MM-dd').format(
                                AppCache.sortFilterCacheDTO!.startDate!),
                            toDate: DateFormat('yyyy-MM-dd')
                                .format(AppCache.sortFilterCacheDTO!.endDate!),
                            currentDate: curDate,
                            expType: '.png',
                          );
                        } else if (widget.dataType ==
                            Constants.CHART_OEE_DTM_SUMMARY) {
                          name = Utils.getExportFilename(
                            'SmmyUtiAndNonUti',
                            companyId:
                                AppCache.sortFilterCacheDTO!.preferredCompany,
                            siteId: AppCache.sortFilterCacheDTO!.preferredSite,
                            fromDate: DateFormat('yyyy-MM-dd').format(
                                AppCache.sortFilterCacheDTO!.startDate!),
                            toDate: DateFormat('yyyy-MM-dd')
                                .format(AppCache.sortFilterCacheDTO!.endDate!),
                            currentDate: curDate,
                            expType: '.png',
                          );
                        } else if (widget.dataType ==
                            Constants.CHART_OEE_DTM_DETAILBREAKDOWN) {
                          name = Utils.getExportFilename(
                            'SmmyDetailBrkdwn',
                            companyId:
                                AppCache.sortFilterCacheDTO!.preferredCompany,
                            siteId: AppCache.sortFilterCacheDTO!.preferredSite,
                            fromDate: DateFormat('yyyy-MM-dd').format(
                                AppCache.sortFilterCacheDTO!.startDate!),
                            toDate: DateFormat('yyyy-MM-dd')
                                .format(AppCache.sortFilterCacheDTO!.endDate!),
                            currentDate: curDate,
                            expType: '.png',
                          );
                        }

                        final result = await ImageApi.generateImage(
                            message.message,
                            600,
                            this.chartHeight.round(),
                            name);
                        if (result != null && result == true) {
                          setState(() {
                            isLoading = false;
                            // print('################## hihi');
                            var snackBar = SnackBar(
                              content: Text(
                                Utils.getTranslated(
                                    context, 'done_download_as_image')!,
                                style: AppFonts.robotoRegular(
                                  16,
                                  color: theme_dark!
                                      ? AppColors.appGrey2()
                                      : AppColors.appGrey2(),
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
                        String name = '';
                        String curDate =
                            '#${DateFormat('yyyy.MM.dd').format(DateTime.now())}@${DateFormat('HH.mm.ss').format(DateTime.now())}';

                        if (widget.dataType ==
                            Constants
                                .CHART_OEE_DASHBOARD_DAILY_UTIL_ALL_EQUIPMENT) {
                          name = Utils.getExportFilename(
                            'DlyUtiEqp',
                            companyId:
                                AppCache.sortFilterCacheDTO!.preferredCompany,
                            siteId: AppCache.sortFilterCacheDTO!.preferredSite,
                            fromDate: DateFormat('yyyy-MM-dd').format(
                                AppCache.sortFilterCacheDTO!.startDate!),
                            toDate: DateFormat('yyyy-MM-dd')
                                .format(AppCache.sortFilterCacheDTO!.endDate!),
                            currentDate: curDate,
                            expType: '.pdf',
                          );
                        } else if (widget.dataType ==
                            Constants.CHART_OEE_DASHBOARD_VO_PROJECT) {
                          name = Utils.getExportFilename(
                            'VolOtptProj',
                            companyId:
                                AppCache.sortFilterCacheDTO!.preferredCompany,
                            siteId: AppCache.sortFilterCacheDTO!.preferredSite,
                            fromDate: DateFormat('yyyy-MM-dd').format(
                                AppCache.sortFilterCacheDTO!.startDate!),
                            toDate: DateFormat('yyyy-MM-dd')
                                .format(AppCache.sortFilterCacheDTO!.endDate!),
                            currentDate: curDate,
                            expType: '.pdf',
                          );
                        } else if (widget.dataType ==
                            Constants.CHART_OEE_DASHBOARD_VO_EQUIPMENT) {
                          name = Utils.getExportFilename(
                            'VolOtptEqp',
                            companyId:
                                AppCache.sortFilterCacheDTO!.preferredCompany,
                            siteId: AppCache.sortFilterCacheDTO!.preferredSite,
                            fromDate: DateFormat('yyyy-MM-dd').format(
                                AppCache.sortFilterCacheDTO!.startDate!),
                            toDate: DateFormat('yyyy-MM-dd')
                                .format(AppCache.sortFilterCacheDTO!.endDate!),
                            currentDate: curDate,
                            expType: '.pdf',
                          );
                        } else if (widget.dataType ==
                            Constants.CHART_OEE_DASHBOARD_DAILY_VO_EQUIPMENT) {
                          name = Utils.getExportFilename(
                            'DlyVolOtptEqp',
                            companyId:
                                AppCache.sortFilterCacheDTO!.preferredCompany,
                            siteId: AppCache.sortFilterCacheDTO!.preferredSite,
                            fromDate: DateFormat('yyyy-MM-dd').format(
                                AppCache.sortFilterCacheDTO!.startDate!),
                            toDate: DateFormat('yyyy-MM-dd')
                                .format(AppCache.sortFilterCacheDTO!.endDate!),
                            currentDate: curDate,
                            expType: '.pdf',
                          );
                        } else if (widget.dataType ==
                            Constants.CHART_OEE_DASHBOARD_DAILY_VO_PROJECT) {
                          name = Utils.getExportFilename(
                            'DlyVolOtptProj',
                            companyId:
                                AppCache.sortFilterCacheDTO!.preferredCompany,
                            siteId: AppCache.sortFilterCacheDTO!.preferredSite,
                            fromDate: DateFormat('yyyy-MM-dd').format(
                                AppCache.sortFilterCacheDTO!.startDate!),
                            toDate: DateFormat('yyyy-MM-dd')
                                .format(AppCache.sortFilterCacheDTO!.endDate!),
                            currentDate: curDate,
                            expType: '.pdf',
                          );
                        } else if (widget.dataType ==
                            Constants
                                .CHART_OEE_DASHBOARD_DAILY_SCORE_EQUIPMENT) {
                          name = Utils.getExportFilename(
                            'DlyOEEEqp',
                            companyId:
                                AppCache.sortFilterCacheDTO!.preferredCompany,
                            siteId: AppCache.sortFilterCacheDTO!.preferredSite,
                            fromDate: DateFormat('yyyy-MM-dd').format(
                                AppCache.sortFilterCacheDTO!.startDate!),
                            toDate: DateFormat('yyyy-MM-dd')
                                .format(AppCache.sortFilterCacheDTO!.endDate!),
                            currentDate: curDate,
                            expType: '.pdf',
                          );
                        } else if (widget.dataType ==
                            Constants.CHART_OEE_DTM_SUMMARY) {
                          name = Utils.getExportFilename(
                            'SmmyUtiAndNonUti',
                            companyId:
                                AppCache.sortFilterCacheDTO!.preferredCompany,
                            siteId: AppCache.sortFilterCacheDTO!.preferredSite,
                            fromDate: DateFormat('yyyy-MM-dd').format(
                                AppCache.sortFilterCacheDTO!.startDate!),
                            toDate: DateFormat('yyyy-MM-dd')
                                .format(AppCache.sortFilterCacheDTO!.endDate!),
                            currentDate: curDate,
                            expType: '.pdf',
                          );
                        } else if (widget.dataType ==
                            Constants.CHART_OEE_DTM_DETAILBREAKDOWN) {
                          name = Utils.getExportFilename(
                            'SmmyDetailBrkdwn',
                            companyId:
                                AppCache.sortFilterCacheDTO!.preferredCompany,
                            siteId: AppCache.sortFilterCacheDTO!.preferredSite,
                            fromDate: DateFormat('yyyy-MM-dd').format(
                                AppCache.sortFilterCacheDTO!.startDate!),
                            toDate: DateFormat('yyyy-MM-dd')
                                .format(AppCache.sortFilterCacheDTO!.endDate!),
                            currentDate: curDate,
                            expType: '.pdf',
                          );
                        }
                        final result = await PdfApi.generatePDF(message.message,
                            600, this.chartHeight.round(), name);
                        if (result != null && result == true) {
                          setState(() {
                            isLoading = false;
                            // print('################## hihi');
                            var snackBar = SnackBar(
                              content: Text(
                                Utils.getTranslated(
                                    context, 'done_download_as_pdf')!,
                                style: AppFonts.robotoRegular(
                                  16,
                                  color: theme_dark!
                                      ? AppColors.appGrey2()
                                      : AppColors.appGrey2(),
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
    );
  }

  Widget chartInfo(BuildContext ctx) {
    if (chartReturnVOPDTO != null && showModal) {
      DateTime time = DateTime.fromMicrosecondsSinceEpoch(
          int.parse(chartReturnVOPDTO!.id!) * 1000);

      String date = DateFormat.yMMMMEEEEd().format(time);
      return Container(
        width: MediaQuery.of(ctx).size.width,
        margin: EdgeInsets.all(12.0),
        padding: EdgeInsets.all(14.0),
        decoration: BoxDecoration(
          color: AppColors.appBlackLight(),
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              date,
              style: AppFonts.robotoMedium(
                14,
                color: theme_dark!
                    ? AppColors.appGrey2()
                    : AppColorsLightMode.appGrey2(),
                decoration: TextDecoration.none,
              ),
            ),
            Wrap(
              children: chartReturnVOPDTO!.data!
                  .map((e) => listItem(ctx, e))
                  .toList(),
            ),
          ],
        ),
      );
    } else if (dtmKey != null && showModal) {
      if (AppCache.sortFilterCacheDTO!.dtmPreferredRange == 'Date') {
        DateTime time =
            DateTime.fromMicrosecondsSinceEpoch(int.parse(dtmKey!) * 1000);

        String date = DateFormat.yMMMMEEEEd().format(time);
        String key = DateFormat("yyyy-MM-dd").format(time);
        return Container(
          width: MediaQuery.of(ctx).size.width,
          margin: EdgeInsets.all(12.0),
          padding: EdgeInsets.all(14.0),
          decoration: BoxDecoration(
            color: AppColors.appBlackLight(),
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                date,
                style: AppFonts.robotoMedium(
                  14,
                  color: theme_dark!
                      ? AppColors.appGrey2()
                      : AppColorsLightMode.appGrey2(),
                  decoration: TextDecoration.none,
                ),
              ),
              Wrap(
                children: detailBreakdownData!.data![key]!
                    .map((e) => dtmList(ctx, e))
                    .toList(),
              ),
            ],
          ),
        );
      } else {
        return Container(
          width: MediaQuery.of(ctx).size.width,
          margin: EdgeInsets.all(12.0),
          padding: EdgeInsets.all(14.0),
          decoration: BoxDecoration(
            color: AppColors.appBlackLight(),
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                dtmKey!,
                style: AppFonts.robotoMedium(
                  14,
                  color: theme_dark!
                      ? AppColors.appGrey2()
                      : AppColorsLightMode.appGrey2(),
                  decoration: TextDecoration.none,
                ),
              ),
              Wrap(
                children: detailBreakdownData!.data![dtmKey]!
                    .map((e) => dtmList(ctx, e))
                    .toList(),
              ),
            ],
          ),
        );
      }
    } else if (utilKey != null && showModal) {
      DateTime time = DateTime.parse(utilKey!);
      //DateTime.fromMicrosecondsSinceEpoch(int.parse(utilKey!) * 1000);
      OeeAvailabilityDataDTO? displayData;
      String date = DateFormat.yMMMMEEEEd().format(time);
      String key = DateFormat("yyyy-MM-dd").format(time);
      oeeAvailabilityDTO!.data!.forEach((element) {
        if (element.date == key) {
          OeeAvailabilityDataDTO data = OeeAvailabilityDataDTO(
              availableTime: element.availableTime,
              utilizationTime: element.utilizationTime,
              plannedDownTime: element.plannedDownTime,
              downTime: element.downTime);
          setState(() {
            displayData = data;
          });
        }
      });
      return Container(
        width: MediaQuery.of(ctx).size.width,
        margin: EdgeInsets.all(12.0),
        padding: EdgeInsets.all(14.0),
        decoration: BoxDecoration(
          color: AppColors.appBlackLight(),
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              date,
              style: AppFonts.robotoMedium(
                14,
                color: theme_dark!
                    ? AppColors.appGrey2()
                    : AppColorsLightMode.appGrey2(),
                decoration: TextDecoration.none,
              ),
            ),
            Container(
              // color: Colors.green,
              width: (MediaQuery.of(ctx).size.width),
              padding: EdgeInsets.fromLTRB(0, 10.0, 10.0, 0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Utils.getTranslated(context, 'oee_available_time')!,
                      style: AppFonts.robotoRegular(
                        14,
                        color: HexColor("#72D12C"),
                        decoration: TextDecoration.none,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      ':',
                      style: AppFonts.robotoRegular(
                        14,
                        color: theme_dark!
                            ? AppColors.appGrey2()
                            : AppColorsLightMode.appGrey2(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      displayData!.availableTime.toString(),
                      style: AppFonts.robotoRegular(
                        14,
                        color: theme_dark!
                            ? AppColors.appGrey2()
                            : AppColorsLightMode.appGrey2(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ]),
            ),
            Container(
              // color: Colors.green,
              width: (MediaQuery.of(ctx).size.width),
              padding: EdgeInsets.fromLTRB(0, 10.0, 10.0, 0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Utils.getTranslated(context, 'oee_ultilisation_time')!,
                      style: AppFonts.robotoRegular(
                        14,
                        color: HexColor("#25DBD9"),
                        decoration: TextDecoration.none,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      ':',
                      style: AppFonts.robotoRegular(
                        14,
                        color: theme_dark!
                            ? AppColors.appGrey2()
                            : AppColorsLightMode.appGrey2(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      displayData!.utilizationTime.toString(),
                      style: AppFonts.robotoRegular(
                        14,
                        color: theme_dark!
                            ? AppColors.appGrey2()
                            : AppColorsLightMode.appGrey2(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ]),
            ),
            Container(
              // color: Colors.green,
              width: (MediaQuery.of(ctx).size.width),
              padding: EdgeInsets.fromLTRB(0, 10.0, 10.0, 0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Utils.getTranslated(context, 'oee_plannedDownTime')!,
                      style: AppFonts.robotoRegular(
                        14,
                        color: HexColor("#F56A02"),
                        decoration: TextDecoration.none,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      ':',
                      style: AppFonts.robotoRegular(
                        14,
                        color: theme_dark!
                            ? AppColors.appGrey2()
                            : AppColorsLightMode.appGrey2(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      displayData!.plannedDownTime.toString(),
                      style: AppFonts.robotoRegular(
                        14,
                        color: theme_dark!
                            ? AppColors.appGrey2()
                            : AppColorsLightMode.appGrey2(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ]),
            ),
            Container(
              // color: Colors.green,
              width: (MediaQuery.of(ctx).size.width),
              padding: EdgeInsets.fromLTRB(0, 10.0, 10.0, 0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Utils.getTranslated(context, 'oee_downTime')!,
                      style: AppFonts.robotoRegular(
                        14,
                        color: HexColor("#E30329"),
                        decoration: TextDecoration.none,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      ':',
                      style: AppFonts.robotoRegular(
                        14,
                        color: theme_dark!
                            ? AppColors.appGrey2()
                            : AppColorsLightMode.appGrey2(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      displayData!.downTime.toString(),
                      style: AppFonts.robotoRegular(
                        14,
                        color: theme_dark!
                            ? AppColors.appGrey2()
                            : AppColorsLightMode.appGrey2(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ]),
            ),
          ],
        ),
      );
    }

    return Container();
  }

  Widget dtmList(BuildContext ctx, DownTimeMonitoringDataDTO data) {
    String color = '';
    String name = '';
    if (data.status == 'diagnostic maintenance') {
      color = theme_dark! ? '#f5d845' : "#00b8dd";
      name = Utils.getTranslated(context, 'csv_DIAGNOSTIC_MAINTENANCE')!;
    } else if (data.status == 'idle') {
      color = theme_dark! ? "#fba30a" : "#481e70";
      name = Utils.getTranslated(context, 'csv_IDLE')!;
    } else if (data.status == 'lost heartbeat') {
      color = theme_dark! ? "#f37719" : "#5ec961";
      name = Utils.getTranslated(context, 'csv_LOST_HEARTBEAT')!;
    } else if (data.status == 'fixture change') {
      color = theme_dark! ? "#dc5039" : "#fba30a";
      name = Utils.getTranslated(context, 'csv_FIXTURE_CHANGE')!;
    } else if (data.status == 'system tilt') {
      color = theme_dark! ? "#bb3754" : "#c088fc";
      name = Utils.getTranslated(context, 'csv_SYSTEM_TILT')!;
    }
    return Container(
      // color: Colors.green,
      width: (MediaQuery.of(ctx).size.width),
      padding: EdgeInsets.fromLTRB(0, 10.0, 10.0, 0),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: AppFonts.robotoRegular(
                14,
                color: HexColor(color),
                decoration: TextDecoration.none,
              ),
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              ':',
              style: AppFonts.robotoRegular(
                14,
                color: theme_dark!
                    ? AppColors.appGrey2()
                    : AppColorsLightMode.appGrey2(),
                decoration: TextDecoration.none,
              ),
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              data.statusTime!.toStringAsFixed(2),
              style: AppFonts.robotoRegular(
                14,
                color: theme_dark!
                    ? AppColors.appGrey2()
                    : AppColorsLightMode.appGrey2(),
                decoration: TextDecoration.none,
              ),
            ),
          ]),
    );
  }

  Widget listItem(BuildContext ctx, OeeChartReturnDataDTO data) {
    List<String> g = [];
    if (!data.color!.contains('#')) {
      String x = '';
      if (data.color!.contains('rgb')) {
        x = data.color!.replaceAll('rgb(', '');
      }
      if (data.color!.contains('RBG')) {
        x = data.color!.replaceAll('RGB(', '');
      }

      x = x.replaceAll(')', '');
      g = x.split(",");
      //print(g);
    }
    return Container(
      // color: Colors.green,
      width: (MediaQuery.of(ctx).size.width * 0.4),
      padding: EdgeInsets.fromLTRB(0, 10.0, 10.0, 0),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data.equipmentName != null ? data.equipmentName! : '',
              style: AppFonts.robotoRegular(
                14,
                color: data.color!.contains('#')
                    ? HexColor(data.color!)
                    : Color.fromRGBO(
                        int.parse(g[0]), int.parse(g[1]), int.parse(g[2]), 1),
                decoration: TextDecoration.none,
              ),
            ),
            Text(
              ':',
              style: AppFonts.robotoRegular(
                14,
                color: theme_dark!
                    ? AppColors.appGrey2()
                    : AppColorsLightMode.appGrey2(),
                decoration: TextDecoration.none,
              ),
            ),
            Text(
              widget.dataType ==
                      Constants.CHART_OEE_DASHBOARD_DAILY_SCORE_EQUIPMENT
                  ? data.oee != null
                      ? data.oee!
                      : ''
                  : data.count != null
                      ? data.count!.toString()
                      : '',
              style: AppFonts.robotoRegular(
                14,
                color: theme_dark!
                    ? AppColors.appGrey2()
                    : AppColorsLightMode.appGrey2(),
                decoration: TextDecoration.none,
              ),
            ),
          ]),
    );
  }

  void showDownloadPopup(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext popContext) => CupertinoActionSheet(
        actions: [
          Container(
            color: theme_dark!
                ? AppColors.cupertinoBackground()
                : AppColorsLightMode.cupertinoBackground().withOpacity(0.8),
            child: CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(popContext);
                this
                    .oeeWebViewController
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
                bool? result;
                String name = '';
                String curDate =
                    '#${DateFormat('yyyy.MM.dd').format(DateTime.now())}@${DateFormat('HH.mm.ss').format(DateTime.now())}';

                if (widget.dataType ==
                    Constants.CHART_OEE_DASHBOARD_DAILY_UTIL_ALL_EQUIPMENT) {
                  name = Utils.getExportFilename(
                    'DlyUtiEqp',
                    companyId: AppCache.sortFilterCacheDTO!.preferredCompany,
                    siteId: AppCache.sortFilterCacheDTO!.preferredSite,
                    fromDate: DateFormat('yyyy-MM-dd')
                        .format(AppCache.sortFilterCacheDTO!.startDate!),
                    toDate: DateFormat('yyyy-MM-dd')
                        .format(AppCache.sortFilterCacheDTO!.endDate!),
                    currentDate: curDate,
                    expType: '.csv',
                  );
                  var object = [];
                  oeeAvailabilityDTO!.data!.forEach((element) {
                    object.add({
                      "${Utils.getTranslated(context, "csv_dateTime")}":
                          element.date,
                      "${Utils.getTranslated(context, "oee_available_time")}":
                          element.availableTime,
                      "${Utils.getTranslated(context, "oee_ultilisation_time")}":
                          element.utilizationTime,
                      "${Utils.getTranslated(context, "oee_legend_planneddowntime")}":
                          element.plannedDownTime,
                      "${Utils.getTranslated(context, "oee_downTime")}":
                          element.downTime,
                    });
                  });

                  result = await CSVApi.generateCSV(object, name);
                } else if (widget.dataType ==
                    Constants.CHART_OEE_DASHBOARD_VO_PROJECT) {
                  name = Utils.getExportFilename(
                    'VolOtptProj',
                    companyId: AppCache.sortFilterCacheDTO!.preferredCompany,
                    siteId: AppCache.sortFilterCacheDTO!.preferredSite,
                    fromDate: DateFormat('yyyy-MM-dd')
                        .format(AppCache.sortFilterCacheDTO!.startDate!),
                    toDate: DateFormat('yyyy-MM-dd')
                        .format(AppCache.sortFilterCacheDTO!.endDate!),
                    currentDate: curDate,
                    expType: '.csv',
                  );
                  var object = [];
                  if (oeeEquipmentDTO!.data != null) {
                    oeeEquipmentDTO!.data!.forEach((element) {
                      object.add({
                        "${Utils.getTranslated(context, "csv_dateTime")}":
                            element.date,
                        "${Utils.getTranslated(context, "csv_project_id")}":
                            element.projectId,
                        "${Utils.getTranslated(context, "csv_count")}":
                            element.count,
                      });
                    });
                  } else {
                    oeeEquipmentDTO_rawData!.data!.forEach((element) {
                      object.add({
                        "${Utils.getTranslated(context, "csv_dateTime")}":
                            element.date,
                        "${Utils.getTranslated(context, "csv_project_id")}":
                            element.projectId,
                        "${Utils.getTranslated(context, "csv_count")}":
                            element.count,
                      });
                    });
                  }

                  result = await CSVApi.generateCSV(object, name);
                } else if (widget.dataType ==
                    Constants.CHART_OEE_DASHBOARD_VO_EQUIPMENT) {
                  name = Utils.getExportFilename(
                    'VolOtptEqp',
                    companyId: AppCache.sortFilterCacheDTO!.preferredCompany,
                    siteId: AppCache.sortFilterCacheDTO!.preferredSite,
                    fromDate: DateFormat('yyyy-MM-dd')
                        .format(AppCache.sortFilterCacheDTO!.startDate!),
                    toDate: DateFormat('yyyy-MM-dd')
                        .format(AppCache.sortFilterCacheDTO!.endDate!),
                    currentDate: curDate,
                    expType: '.csv',
                  );
                  var object = [];
                  if (oeeEquipmentDTO!.data != null) {
                    oeeEquipmentDTO!.data!.forEach((element) {
                      object.add({
                        "${Utils.getTranslated(context, "csv_dateTime")}":
                            element.date,
                        "${Utils.getTranslated(context, "csv_equipment_name")}":
                            element.equipmentName,
                        "${Utils.getTranslated(context, "csv_count")}":
                            element.count,
                      });
                    });
                  } else {
                    oeeEquipmentDTO_rawData!.data!.forEach((element) {
                      object.add({
                        "${Utils.getTranslated(context, "csv_dateTime")}":
                            element.date,
                        "${Utils.getTranslated(context, "csv_equipment_name")}":
                            element.equipmentName,
                        "${Utils.getTranslated(context, "csv_count")}":
                            element.count,
                      });
                    });
                  }

                  result = await CSVApi.generateCSV(object, name);
                } else if (widget.dataType ==
                    Constants.CHART_OEE_DASHBOARD_DAILY_VO_EQUIPMENT) {
                  name = Utils.getExportFilename(
                    'DlyVolOtptEqp',
                    companyId: AppCache.sortFilterCacheDTO!.preferredCompany,
                    siteId: AppCache.sortFilterCacheDTO!.preferredSite,
                    fromDate: DateFormat('yyyy-MM-dd')
                        .format(AppCache.sortFilterCacheDTO!.startDate!),
                    toDate: DateFormat('yyyy-MM-dd')
                        .format(AppCache.sortFilterCacheDTO!.endDate!),
                    currentDate: curDate,
                    expType: '.csv',
                  );
                  var object = [];
                  List<OeeEquipmentDataDTO> listEq = [];
                  var listDate = [];
                  List<OeeEquipmentDataDTO> buffer = [];

                  if (oeeEquipmentDTO!.data != null) {
                    oeeEquipmentDTO!.data!.forEach((element) {
                      if (!listDate.contains(element.date)) {
                        listDate.add(element.date);
                      }
                      // if (!listEq.contains(element.equipmentName)) {
                      //   listEq.add(element.equipmentName);
                      // }
                    });
                    for (var x = 0; x < listDate.length; x++) {
                      listEq.clear();
                      buffer.clear();
                      buffer = oeeEquipmentDTO!.data!
                          .where((element) => element.date == listDate[x])
                          .toList();
                      listEq.add(OeeEquipmentDataDTO(
                          equipmentName:
                              "${Utils.getTranslated(context, "csv_dateTime")}",
                          date: listDate[x]));
                      buffer.forEach((data) {
                        listEq.add(OeeEquipmentDataDTO(
                            equipmentName: data.equipmentName,
                            date: data.count.toString()));
                      });
                      var map2 = {};

                      listEq.forEach((customer) =>
                          map2[customer.equipmentName] = customer.date);

                      object.add(map2);
                    }
                  } else {
                    oeeEquipmentDTO_rawData!.data!.forEach((element) {
                      if (!listDate.contains(element.date)) {
                        listDate.add(element.date);
                      }
                      // if (!listEq.contains(element.equipmentName)) {
                      //   listEq.add(element.equipmentName);
                      // }
                    });
                    for (var x = 0; x < listDate.length; x++) {
                      listEq.clear();
                      buffer.clear();
                      buffer = oeeEquipmentDTO_rawData!.data!
                          .where((element) => element.date == listDate[x])
                          .toList();
                      listEq.add(OeeEquipmentDataDTO(
                          equipmentName:
                              "${Utils.getTranslated(context, "csv_dateTime")}",
                          date: listDate[x]));
                      buffer.forEach((data) {
                        listEq.add(OeeEquipmentDataDTO(
                            equipmentName: data.equipmentName,
                            date: data.count.toString()));
                      });
                      var map2 = {};

                      listEq.forEach((customer) =>
                          map2[customer.equipmentName] = customer.date);

                      object.add(map2);
                    }
                  }
                  print(object);
                  result = await CSVApi.generateCSV(object, name);
                } else if (widget.dataType ==
                    Constants.CHART_OEE_DASHBOARD_DAILY_VO_PROJECT) {
                  name = Utils.getExportFilename(
                    'DlyVolOtptProj',
                    companyId: AppCache.sortFilterCacheDTO!.preferredCompany,
                    siteId: AppCache.sortFilterCacheDTO!.preferredSite,
                    fromDate: DateFormat('yyyy-MM-dd')
                        .format(AppCache.sortFilterCacheDTO!.startDate!),
                    toDate: DateFormat('yyyy-MM-dd')
                        .format(AppCache.sortFilterCacheDTO!.endDate!),
                    currentDate: curDate,
                    expType: '.csv',
                  );
                  var object = [];
                  List<OeeEquipmentDataDTO> listEq = [];
                  var listDate = [];
                  var objectKey = [];
                  List<OeeEquipmentDataDTO> buffer = [];
                  if (oeeEquipmentDTO!.data != null) {
                    oeeEquipmentDTO!.data!.forEach((element) {
                      if (!listDate.contains(element.date)) {
                        listDate.add(element.date);
                      }
                      if (objectKey.length == 0) {
                        objectKey
                            .add(Utils.getTranslated(context, "csv_dateTime"));
                      } else if (!objectKey.contains(element.projectId)) {
                        objectKey.add(element.projectId);
                      }
                    });
                    listDate.sort((a, b) {
                      return a.compareTo(b);
                    });
                    for (var x = 0; x < listDate.length; x++) {
                      listEq.clear();
                      buffer.clear();
                      buffer = oeeEquipmentDTO!.data!
                          .where((element) => element.date == listDate[x])
                          .toList();
                      listEq.add(OeeEquipmentDataDTO(
                          equipmentName:
                              "${Utils.getTranslated(context, "csv_dateTime")}",
                          date: listDate[x]));
                      buffer.forEach((data) {
                        listEq.add(OeeEquipmentDataDTO(
                            equipmentName: data.projectId,
                            date: data.count.toString()));
                      });
                      var map2 = {};

                      listEq.forEach((customer) =>
                          map2[customer.equipmentName] = customer.date);

                      object.add(map2);
                    }
                  } else {
                    oeeEquipmentDTO_rawData!.data!.forEach((element) {
                      if (!listDate.contains(element.date)) {
                        listDate.add(element.date);
                      }
                      if (objectKey.length == 0) {
                        objectKey
                            .add(Utils.getTranslated(context, "csv_dateTime"));
                      } else if (!objectKey.contains(element.projectId)) {
                        objectKey.add(element.projectId);
                      }
                    });
                    listDate.sort((a, b) {
                      return a.compareTo(b);
                    });
                    for (var x = 0; x < listDate.length; x++) {
                      listEq.clear();
                      buffer.clear();
                      buffer = oeeEquipmentDTO_rawData!.data!
                          .where((element) => element.date == listDate[x])
                          .toList();
                      listEq.add(OeeEquipmentDataDTO(
                          equipmentName:
                              "${Utils.getTranslated(context, "csv_dateTime")}",
                          date: listDate[x]));
                      buffer.forEach((data) {
                        listEq.add(OeeEquipmentDataDTO(
                            equipmentName: data.projectId,
                            date: data.count.toString()));
                      });

                      var map2 = {};

                      listEq.forEach((customer) =>
                          map2[customer.equipmentName] = customer.date);

                      object.add(map2);
                    }
                  }

                  // print(objectKey);
                  result =
                      await CSVApi.generateCSVwithKey(object, name, objectKey);
                } else if (widget.dataType ==
                    Constants.CHART_OEE_DASHBOARD_DAILY_SCORE_EQUIPMENT) {
                  name = Utils.getExportFilename(
                    'DlyOEEEqp',
                    companyId: AppCache.sortFilterCacheDTO!.preferredCompany,
                    siteId: AppCache.sortFilterCacheDTO!.preferredSite,
                    fromDate: DateFormat('yyyy-MM-dd')
                        .format(AppCache.sortFilterCacheDTO!.startDate!),
                    toDate: DateFormat('yyyy-MM-dd')
                        .format(AppCache.sortFilterCacheDTO!.endDate!),
                    currentDate: curDate,
                    expType: '.csv',
                  );
                  var object = [];
                  List<OeeEquipmentDataDTO> listEq = [];
                  var listDate = [];
                  List<OeeEquipmentDataDTO> buffer = [];
                  if (oeeEquipmentDTO!.data != null) {
                    oeeEquipmentDTO!.data!.forEach((element) {
                      if (!listDate.contains(element.date)) {
                        listDate.add(element.date);
                      }
                      // if (!listEq.contains(element.equipmentName)) {
                      //   listEq.add(element.equipmentName);
                      // }
                    });
                    for (var x = 0; x < listDate.length; x++) {
                      listEq.clear();
                      buffer.clear();
                      buffer = oeeEquipmentDTO!.data!
                          .where((element) => element.date == listDate[x])
                          .toList();
                      listEq.add(OeeEquipmentDataDTO(
                          equipmentName:
                              "${Utils.getTranslated(context, "csv_dateTime")}",
                          date: listDate[x]));
                      buffer.forEach((data) {
                        listEq.add(OeeEquipmentDataDTO(
                            equipmentName: data.equipmentName,
                            date: data.oee.toString()));
                      });
                      var map2 = {};

                      listEq.forEach((customer) =>
                          map2[customer.equipmentName] = customer.date);

                      object.add(map2);
                    }
                  } else {
                    oeeEquipmentDTO_rawData!.data!.forEach((element) {
                      if (!listDate.contains(element.date)) {
                        listDate.add(element.date);
                      }
                      // if (!listEq.contains(element.equipmentName)) {
                      //   listEq.add(element.equipmentName);
                      // }
                    });
                    for (var x = 0; x < listDate.length; x++) {
                      listEq.clear();
                      buffer.clear();
                      buffer = oeeEquipmentDTO_rawData!.data!
                          .where((element) => element.date == listDate[x])
                          .toList();
                      listEq.add(OeeEquipmentDataDTO(
                          equipmentName:
                              "${Utils.getTranslated(context, "csv_dateTime")}",
                          date: listDate[x]));
                      buffer.forEach((data) {
                        listEq.add(OeeEquipmentDataDTO(
                            equipmentName: data.equipmentName,
                            date: data.oee.toString()));
                      });
                      var map2 = {};

                      listEq.forEach((customer) =>
                          map2[customer.equipmentName] = customer.date);

                      object.add(map2);
                    }
                  }

                  result = await CSVApi.generateCSV(object, name);
                } else if (widget.dataType == Constants.CHART_OEE_DTM_SUMMARY) {
                  List<String> dateTime = [];
                  List<DownTimeMonitoringDataDTO> dtm = [];
                  var chartDataDTM = [];
                  summaryUtilAndNonUtilData!.data!
                      .forEach((key, DownTimeMonitoringDataDTO value) {
                    dateTime.add(key.toString());
                    DownTimeMonitoringDataDTO data = DownTimeMonitoringDataDTO(
                        scheduledNonUtilizationTime:
                            value.scheduledNonUtilizationTime,
                        scheduledUtilizationTime:
                            value.scheduledUtilizationTime,
                        unscheduledUtilizationTime:
                            value.unscheduledUtilizationTime);
                    dtm.add(data);
                  });
                  for (int x = 0; x < dtm.length; x++) {
                    chartDataDTM.add({
                      "${Utils.getTranslated(context, "csv_dateTime")}":
                          dateTime[x],
                      "${Utils.getTranslated(context, "csv_scheduledNonUtilizationTime")}":
                          dtm[x].scheduledNonUtilizationTime,
                      "${Utils.getTranslated(context, "csv_scheduledUtilizationTime")}":
                          dtm[x].scheduledUtilizationTime,
                      "${Utils.getTranslated(context, "csv_unscheduledUtilizationTime")}":
                          dtm[x].unscheduledUtilizationTime
                    });
                  }
                  name = Utils.getExportFilename(
                    'SmmyUtiAndNonUti',
                    companyId: AppCache.sortFilterCacheDTO!.preferredCompany,
                    siteId: AppCache.sortFilterCacheDTO!.preferredSite,
                    fromDate: DateFormat('yyyy-MM-dd')
                        .format(AppCache.sortFilterCacheDTO!.startDate!),
                    toDate: DateFormat('yyyy-MM-dd')
                        .format(AppCache.sortFilterCacheDTO!.endDate!),
                    currentDate: curDate,
                    expType: '.csv',
                  );
                  await CSVApi.generateCSV(chartDataDTM, name);
                } else if (widget.dataType ==
                    Constants.CHART_OEE_DTM_DETAILBREAKDOWN) {
                  name = Utils.getExportFilename(
                    'SmmyDetailBrkdwn',
                    companyId: AppCache.sortFilterCacheDTO!.preferredCompany,
                    siteId: AppCache.sortFilterCacheDTO!.preferredSite,
                    fromDate: DateFormat('yyyy-MM-dd')
                        .format(AppCache.sortFilterCacheDTO!.startDate!),
                    toDate: DateFormat('yyyy-MM-dd')
                        .format(AppCache.sortFilterCacheDTO!.endDate!),
                    currentDate: curDate,
                    expType: '.csv',
                  );
                  List<String> dateTime = [];
                  List<DownTimeMonitoringDataDTO> dtm = [];
                  var chartDataDTM = [];

                  detailBreakdownData!.data!
                      .forEach((key, List<DownTimeMonitoringDataDTO> value) {
                    var dm;
                    var idle;
                    var lostheartbeat;
                    var fixturechange;
                    var systemtilt;
                    dateTime.add(key.toString());

                    value.forEach((element) {
                      if (element.status == 'diagnostic maintenance') {
                        dm = element.statusTime;
                      } else if (element.status == 'idle') {
                        idle = element.statusTime;
                      } else if (element.status == 'lost heartbeat') {
                        lostheartbeat = element.statusTime;
                      } else if (element.status == 'fixture change') {
                        fixturechange = element.statusTime;
                      } else if (element.status == 'system tilt') {
                        systemtilt = element.statusTime;
                      }
                    });

                    chartDataDTM.add({
                      "${Utils.getTranslated(context, "csv_dateTime")}":
                          key.toString(),
                      "${Utils.getTranslated(context, "csv_DIAGNOSTIC_MAINTENANCE")}":
                          dm,
                      "${Utils.getTranslated(context, "csv_IDLE")})": idle,
                      "${Utils.getTranslated(context, "csv_LOST_HEARTBEAT")}":
                          lostheartbeat,
                      "${Utils.getTranslated(context, "csv_FIXTURE_CHANGE")}":
                          fixturechange,
                      "${Utils.getTranslated(context, "csv_SYSTEM_TILT")}":
                          systemtilt,
                    });
                  });

                  await CSVApi.generateCSV(chartDataDTM, name);
                } else {
                  result = false;
                }
                Navigator.pop(popContext);
                if (result != null && result == true) {
                  setState(() {
                    isLoading = false;
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
                Navigator.pop(popContext);
                this
                    .oeeWebViewController
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
              Navigator.pop(popContext);
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
}
