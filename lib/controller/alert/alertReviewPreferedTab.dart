import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
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
import 'package:keysight_pma/dio/api/alert.dart';
import 'package:keysight_pma/model/alert/alert_create_case.dart';
import 'package:keysight_pma/model/alert/alert_group.dart';
import 'package:keysight_pma/model/alert/alert_statistics.dart';
import 'package:keysight_pma/model/arguments/alert_routeTitle.dart';
import 'package:keysight_pma/model/arguments/search_argument.dart';
import 'package:keysight_pma/model/customize.dart';
import 'package:keysight_pma/routes/approutes.dart';

class AlertReviewPreferedTab extends StatefulWidget {
  const AlertReviewPreferedTab({Key? key}) : super(key: key);

  @override
  State<AlertReviewPreferedTab> createState() => _AlertReviewPreferedTab();
}

class _AlertReviewPreferedTab extends State<AlertReviewPreferedTab>
    with TickerProviderStateMixin {
  bool selectAll = false;
  bool showBottom = false;
  bool isFiltered = true;
  int statisticsDividerCounter = 0;
  int accuracyDividerCounter = 0;
  bool isLoading = true;
  String sorting = Constants.SORT_ASCENDING;
  String sortBy = '';
  int sortType = 0;
  int pageNo = 0;

  bool? theme_dark = AppCache.sortFilterCacheDTO!.currentTheme;
  int pageSize = 10;
  List<num> selectedGroupIdList = [];
  AlertStatisticsDTO alertStatisticsDTO = AlertStatisticsDTO();
  late Map<String?, List<AlertStatisticsDataDTO>> preferredAlertStatisticMap;
  late Map<String?, List<AlertStatisticsDataDTO>> preferredAlertAccuracyMap;
  List<AlertStatisticsDataDTO> preferedASList = [];
  List<AlertStatisticsDataDTO> preferedAlertSelectedList = [];
  List<CustomDqmSortFilterItemSelectionDTO> filterAlertTypeList = [];
  List<CustomDqmSortFilterItemSelectionDTO> filterAlertStatusList = [];
  late AlertGroupDTO alertGroupDTO;
  bool isDismiss = false;

  Future<AlertGroupDTO> getAlertGroupInfo(BuildContext context) {
    AlertApi alertApi = AlertApi(context);
    return alertApi.getAlertGroupInfo();
  }

  Future<AlertStatisticsDTO> getAlertStatistics(BuildContext context) {
    String startDate = DateFormat("yyyy-MM-dd")
        .format(AppCache.sortFilterCacheDTO!.startDate!);
    String endDate =
        DateFormat("yyyy-MM-dd").format(AppCache.sortFilterCacheDTO!.endDate!);
    AlertApi alertApi = AlertApi(context);
    return alertApi.getAlertStatistics(startDate, endDate, selectedGroupIdList);
  }

  Future<AlertCreateCaseDTO> bulkCasesVerification(
      BuildContext context, String actions) {
    List<String> alertRowKeys = [];
    if (this.preferedAlertSelectedList.length > 0) {
      this.preferedAlertSelectedList.forEach((element) {
        alertRowKeys.add(element.alertRowKey!);
      });
    }
    AlertApi alertApi = AlertApi(context);
    return alertApi.bulkCasesVerification(actions, alertRowKeys);
  }

  void groupPreferredAlertStatisticByType() {
    final groups =
        groupBy(this.alertStatisticsDTO.data!, (AlertStatisticsDataDTO e) {
      return e.sender;
    });

    setState(() {
      this.preferredAlertStatisticMap = groups;
      filterAlertTypeList.clear();
      this.preferredAlertStatisticMap.keys.forEach((element) {
        CustomDqmSortFilterItemSelectionDTO itemDTO =
            CustomDqmSortFilterItemSelectionDTO(element, true);
        filterAlertTypeList.add(itemDTO);
      });
    });
  }

  void groupPreferedAlertAccuracyByStatus() {
    this.alertStatisticsDTO.data!.sort((a, b) {
      return a.status!.compareTo(b.status!);
    });
    final groups =
        groupBy(this.alertStatisticsDTO.data!, (AlertStatisticsDataDTO e) {
      return e.status;
    });

    setState(() {
      this.preferredAlertAccuracyMap = groups;
      filterAlertStatusList.clear();
      this.preferredAlertAccuracyMap.keys.forEach((element) {
        CustomDqmSortFilterItemSelectionDTO itemDTO =
            CustomDqmSortFilterItemSelectionDTO(element, true);
        filterAlertStatusList.add(itemDTO);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    Utils.setFirebaseAnalyticsCurrentScreen(
        Constants.ANALYTICS_ALERT_REVIEW_PREFERRED_SCREEN);
    callGetAlertGroupInfo(context);
  }

  callGetAlertGroupInfo(BuildContext context) async {
    await getAlertGroupInfo(context).then((value) {
      this.alertGroupDTO = value;
      if (value.data != null && value.data!.length > 0) {
        selectedGroupIdList.clear();
        selectedGroupIdList.add(value.data![value.data!.length - 1].groupId!);
        callGetAlertStatistics(context);
      }
    }).catchError((error) {
      Utils.printInfo(error);
      setState(() {
        this.isLoading = false;
        if (EasyLoading.isShow) {
          EasyLoading.dismiss();
        }
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

  callGetAlertStatistics(BuildContext context) async {
    await getAlertStatistics(context).then((value) {
      this.alertStatisticsDTO = value;
      if (this.alertStatisticsDTO.data != null &&
          this.alertStatisticsDTO.data!.length > 0) {
        this.preferedASList = this.alertStatisticsDTO.data!;
        groupPreferredAlertStatisticByType();
        groupPreferedAlertAccuracyByStatus();
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
        if (EasyLoading.isShow) {
          EasyLoading.dismiss();
        }
      });
    });
  }

  callbulkCasesVerification(BuildContext context, String actions) async {
    EasyLoading.show(maskType: EasyLoadingMaskType.black);
    await bulkCasesVerification(context, actions).then((value) {
      if (value.data != null &&
          value.data!.bulkAlertInfo != null &&
          value.data!.bulkAlertInfo!.length > 0) {
        List<BulkAlertInfoDTO> bulkActualList = [];
        List<BulkAlertInfoDTO> bulkDismissList = [];
        List<BulkAlertInfoDTO> bulkDisposeList = [];
        value.data!.bulkAlertInfo!.forEach((element) {
          if (Utils.isNotEmpty(element.status)) {
            if (element.status == Constants.ALERT_ACC_ACTUAL) {
              bulkActualList.add(element);
            } else if (element.status == Constants.ALERT_ACC_DISMISS) {
              bulkDismissList.add(element);
            } else if (element.status == Constants.ALERT_ACC_DISPOSE) {
              bulkDisposeList.add(element);
            }
          } else {
            bulkDisposeList.add(element);
          }
        });

        if (bulkActualList.length > 0 &&
            bulkDismissList.length == 0 &&
            bulkDisposeList.length == 0) {
          if (this.isDismiss) {
            Navigator.pushNamed(context, AppRoutes.dismissCase,
                arguments: AlertArguments(bulkAlertActualList: bulkActualList));
          } else {
            Navigator.pushNamed(context, AppRoutes.disposeORcreateCase,
                arguments: AlertArguments(bulkAlertActualList: bulkActualList));
          }
        } else {
          showBulkDismissAlertDialog(
              context, bulkActualList, bulkDismissList, bulkDisposeList);
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
        EasyLoading.dismiss();
      });
    });
  }

  sortData() {
    if (this.preferedASList.length > 0) {
      if (this.sortType == Constants.ALERT_SORT_BY_TIMESTAMP) {
        this.preferedASList.sort((a, b) {
          if (this.sorting == Constants.SORT_ASCENDING) {
            return a.timestamp!.compareTo(b.timestamp!);
          } else {
            return b.timestamp!.compareTo(a.timestamp!);
          }
        });
      } else if (this.sortType == Constants.ALERT_SORT_BY_ALERT_ID) {
        List<AlertStatisticsDataDTO> alertIdList = this
            .preferedASList
            .where((element) => Utils.isNotEmpty(element.alertIdName))
            .toList();
        List<AlertStatisticsDataDTO> emptyAlertIdList = this
            .preferedASList
            .where((element) => !Utils.isNotEmpty(element.alertIdName))
            .toList();

        this.preferedASList.clear();
        if (alertIdList.length > 0) {
          alertIdList.sort((a, b) {
            if (this.sorting == Constants.SORT_ASCENDING) {
              return a.alertIdName!.compareTo(b.alertIdName!);
            } else {
              return b.alertIdName!.compareTo(a.alertIdName!);
            }
          });

          if (this.sorting == Constants.SORT_ASCENDING) {
            this.preferedASList.addAll(emptyAlertIdList);
            this.preferedASList.addAll(alertIdList);
          } else {
            this.preferedASList.addAll(alertIdList);
            this.preferedASList.addAll(emptyAlertIdList);
          }
        } else {
          this.preferedASList.addAll(emptyAlertIdList);
        }
      } else if (this.sortType == Constants.ALERT_SORT_BY_EQUIPMENT) {
        List<AlertStatisticsDataDTO> equipmentList = this
            .preferedASList
            .where((element) => Utils.isNotEmpty(element.equipmentName))
            .toList();
        List<AlertStatisticsDataDTO> emptyEquipmentList = this
            .preferedASList
            .where((element) => !Utils.isNotEmpty(element.equipmentName))
            .toList();

        this.preferedASList.clear();
        if (equipmentList.length > 0) {
          equipmentList.sort((a, b) {
            if (this.sorting == Constants.SORT_ASCENDING) {
              return a.equipmentName!.compareTo(b.equipmentName!);
            } else {
              return b.equipmentName!.compareTo(a.equipmentName!);
            }
          });

          if (this.sorting == Constants.SORT_ASCENDING) {
            this.preferedASList.addAll(emptyEquipmentList);
            this.preferedASList.addAll(equipmentList);
          } else {
            this.preferedASList.addAll(equipmentList);
            this.preferedASList.addAll(emptyEquipmentList);
          }
        } else {
          this.preferedASList.addAll(emptyEquipmentList);
        }
      } else if (this.sortType == Constants.ALERT_SORT_BY_PROJECT) {
        List<AlertStatisticsDataDTO> projectList = this
            .preferedASList
            .where((element) => Utils.isNotEmpty(element.projectId))
            .toList();
        List<AlertStatisticsDataDTO> emptyProjectList = this
            .preferedASList
            .where((element) => !Utils.isNotEmpty(element.projectId))
            .toList();

        this.preferedASList.clear();
        if (projectList.length > 0) {
          projectList.sort((a, b) {
            if (this.sorting == Constants.SORT_ASCENDING) {
              return a.projectId!.compareTo(b.projectId!);
            } else {
              return b.projectId!.compareTo(a.projectId!);
            }
          });

          if (this.sorting == Constants.SORT_ASCENDING) {
            this.preferedASList.addAll(emptyProjectList);
            this.preferedASList.addAll(projectList);
          } else {
            this.preferedASList.addAll(projectList);
            this.preferedASList.addAll(emptyProjectList);
          }
        } else {
          this.preferedASList.addAll(emptyProjectList);
        }
      } else if (this.sortType == Constants.ALERT_SORT_BY_STATUS) {
        List<AlertStatisticsDataDTO> statusList = this
            .preferedASList
            .where((element) => Utils.isNotEmpty(element.status))
            .toList();
        List<AlertStatisticsDataDTO> emptyStatusList = this
            .preferedASList
            .where((element) => !Utils.isNotEmpty(element.status))
            .toList();

        this.preferedASList.clear();
        if (statusList.length > 0) {
          statusList.sort((a, b) {
            if (this.sorting == Constants.SORT_ASCENDING) {
              return a.status!.compareTo(b.status!);
            } else {
              return b.status!.compareTo(a.status!);
            }
          });

          if (this.sorting == Constants.SORT_ASCENDING) {
            this.preferedASList.addAll(emptyStatusList);
            this.preferedASList.addAll(statusList);
          } else {
            this.preferedASList.addAll(statusList);
            this.preferedASList.addAll(emptyStatusList);
          }
        } else {
          this.preferedASList.addAll(emptyStatusList);
        }
      } else if (this.sortType == Constants.ALERT_SORT_BY_SEVERITY) {
        List<AlertStatisticsDataDTO> severityList = this
            .preferedASList
            .where((element) => Utils.isNotEmpty(element.alertSeverity))
            .toList();
        List<AlertStatisticsDataDTO> emptySeverityList = this
            .preferedASList
            .where((element) => !Utils.isNotEmpty(element.alertSeverity))
            .toList();

        this.preferedASList.clear();
        if (severityList.length > 0) {
          severityList.sort((a, b) {
            if (this.sorting == Constants.SORT_ASCENDING) {
              return a.alertSeverity!.compareTo(b.alertSeverity!);
            } else {
              return b.alertSeverity!.compareTo(a.alertSeverity!);
            }
          });

          if (this.sorting == Constants.SORT_ASCENDING) {
            this.preferedASList.addAll(emptySeverityList);
            this.preferedASList.addAll(severityList);
          } else {
            this.preferedASList.addAll(severityList);
            this.preferedASList.addAll(emptySeverityList);
          }
        } else {
          this.preferedASList.addAll(emptySeverityList);
        }
      } else if (this.sortType == Constants.ALERT_SORT_BY_SCORING) {
        List<AlertStatisticsDataDTO> scoreList = this
            .preferedASList
            .where((element) => Utils.isNotEmpty(element.alertScoring))
            .toList();
        List<AlertStatisticsDataDTO> emptyScoreList = this
            .preferedASList
            .where((element) => !Utils.isNotEmpty(element.alertScoring))
            .toList();

        this.preferedASList.clear();
        if (scoreList.length > 0) {
          scoreList.sort((a, b) {
            if (this.sorting == Constants.SORT_ASCENDING) {
              return a.alertScoring!.compareTo(b.alertScoring!);
            } else {
              return b.alertScoring!.compareTo(a.alertScoring!);
            }
          });

          if (this.sorting == Constants.SORT_ASCENDING) {
            this.preferedASList.addAll(emptyScoreList);
            this.preferedASList.addAll(scoreList);
          } else {
            this.preferedASList.addAll(scoreList);
            this.preferedASList.addAll(emptyScoreList);
          }
        } else {
          this.preferedASList.addAll(emptyScoreList);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
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
                    child: Stack(
                      children: [
                        SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 21.5),
                              preferedAlertStatistics(context),
                              SizedBox(height: 22),
                              preferedAlertAccurracyStatus(context),
                              SizedBox(height: 30),
                              preferedAlertInformationLabel(context),
                              SizedBox(height: 26),
                              preferedAlertInfoSorting(context),
                              SizedBox(height: 26),
                              preferedAlertInformationData(context),
                              SizedBox(height: 20),
                              preferedViewMoreButton(context),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: TextButton(
                            onPressed: () async {
                              final navigateResult = await Navigator.pushNamed(
                                context,
                                AppRoutes.alertPreferedSortFilterRoute,
                                arguments: AlertArguments(
                                  alertGroupDTO: this.alertGroupDTO,
                                  pickedGroupId: this.selectedGroupIdList[0],
                                ),
                              );

                              if (navigateResult != null) {
                                Utils.printInfo(navigateResult);
                                setState(() {
                                  this.preferedASList.clear();
                                  this.selectedGroupIdList.clear();
                                  this
                                      .selectedGroupIdList
                                      .add(navigateResult as num);
                                  EasyLoading.show(
                                      maskType: EasyLoadingMaskType.black);
                                  callGetAlertStatistics(context);
                                });
                              }
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
                                  Image.asset(Constants.ASSET_IMAGES +
                                      'filter_icon.png'),
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
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  bottomBar(context),
                ],
              ),
      ),
    );
  }

  Widget bottomBar(BuildContext ctx) {
    if (this.showBottom) {
      return Container(
        padding: EdgeInsets.fromLTRB(16.0, 22.0, 16.0, 0.0),
        color: theme_dark!
            ? AppColors.appPrimaryBlack()
            : AppColorsLightMode.appPrimaryBlack(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  if (selectAll == true) {
                    this.preferedAlertSelectedList.clear();
                  } else {
                    this.preferedAlertSelectedList.clear();
                    this.preferedAlertSelectedList.addAll(this.preferedASList);
                  }
                  selectAll == true ? selectAll = false : selectAll = true;
                  Utils.printInfo(this.preferedAlertSelectedList.length);
                });
              },
              child: Image.asset((selectAll == false)
                  ? theme_dark!
                      ? Constants.ASSET_IMAGES + 'check_box.png'
                      : Constants.ASSET_IMAGES_LIGHT + 'check_box.png'
                  : theme_dark!
                      ? Constants.ASSET_IMAGES + 'checked_box.png'
                      : Constants.ASSET_IMAGES_LIGHT + 'checked_box.png'),
            ),
            SizedBox(width: 18),
            Text(Utils.getTranslated(context, 'alertSelectAll')!,
                style: AppFonts.sfproMedium(
                  14,
                  color: AppColors.appTeal(),
                  decoration: TextDecoration.none,
                )),
            SizedBox(width: 28),
            GestureDetector(
              onTap: () {
                setState(() {
                  this.isDismiss = false;
                  callbulkCasesVerification(context, "BULKDISPOSE");
                });
              },
              child: Container(
                padding: EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: theme_dark!
                        ? AppColors.appPrimaryWhite()
                        : AppColorsLightMode.appPrimaryYellow(),
                  ),
                ),
                width: MediaQuery.of(context).size.width * 0.28,
                height: 40,
                child: Text(
                  Utils.getTranslated(context, 'alertDispose')!,
                  style: AppFonts.robotoMedium(
                    15,
                    color: theme_dark!
                        ? AppColors.appPrimaryWhite()
                        : AppColorsLightMode.appPrimaryYellow(),
                    decoration: TextDecoration.none,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(width: 11),
            GestureDetector(
              onTap: () {
                setState(() {
                  this.isDismiss = true;
                  callbulkCasesVerification(context, "BULKDISMISS");
                });
              },
              child: Container(
                padding: EdgeInsets.only(top: 10),
                color: AppColors.appPrimaryYellow(),
                width: MediaQuery.of(context).size.width * 0.28,
                height: 40,
                child: Text(
                  Utils.getTranslated(context, 'alertDismiss')!,
                  style: AppFonts.robotoMedium(
                    15,
                    color: AppColors.appPrimaryWhite(),
                    decoration: TextDecoration.none,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      );
    }
    return Container();
  }

  Widget alertStatusItem(BuildContext ctx, String? status, num count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 10,
          width: 10,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: status == Constants.ALERT_HIGH
                  ? AppColors.appAlertHigh()
                  : status == Constants.ALERT_MEDIUM
                      ? AppColors.appAlertMed()
                      : status == Constants.ALERT_LOW
                          ? AppColors.appAlertLow()
                          : AppColors.appPrimaryWhite()),
        ),
        SizedBox(width: 10.0),
        Text(
          '${count.toInt()}',
          style: AppFonts.robotoMedium(
            13,
            color: theme_dark!
                ? AppColors.appGreyDE()
                : AppColorsLightMode.appGrey(),
            decoration: TextDecoration.none,
          ),
        ),
        SizedBox(width: 16.0),
      ],
    );
  }

  Widget preferedAlertStatistics(BuildContext ctx) {
    return GestureDetector(
      onTap: () {
        if (this.alertStatisticsDTO.data != null &&
            this.alertStatisticsDTO.data!.length > 0) {
          Navigator.pushNamed(
            context,
            AppRoutes.alertStatisticsChart,
            arguments: AlertArguments(
              preferedAlertList: this.alertStatisticsDTO.data,
            ),
          );
        }
      },
      child: Container(
        margin: EdgeInsets.only(right: 16, left: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: theme_dark!
              ? AppColors.appBlackLight()
              : AppColorsLightMode.appGreyF0(),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 17, top: 18, bottom: 16),
              child: Text(
                Utils.getTranslated(context, 'alert_statistics')!,
                style: AppFonts.robotoRegular(
                  16,
                  color: theme_dark!
                      ? AppColors.appGrey2()
                      : AppColorsLightMode.appGrey(),
                  decoration: TextDecoration.none,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            (this.alertStatisticsDTO.data != null &&
                    this.alertStatisticsDTO.data!.length > 0)
                ? Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        colorDotLabel(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: this
                              .preferredAlertStatisticMap
                              .entries
                              .map((entry) => preferedAlertStaticsItem(
                                  ctx,
                                  entry.key!,
                                  entry.value,
                                  this.preferredAlertStatisticMap.length))
                              .toList(),
                        )
                      ],
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
      ),
    );
  }

  Widget preferedAlertStaticsItem(BuildContext ctx, String key,
      List<AlertStatisticsDataDTO> dataList, int length) {
    (statisticsDividerCounter != length)
        ? statisticsDividerCounter = statisticsDividerCounter + 1
        : statisticsDividerCounter = 1;

    num? highCount;
    num? medCount;
    num? lowCount;
    num? otherCount;
    if (dataList.length > 0) {
      highCount = dataList
          .where((element) => element.alertSeverity == Constants.ALERT_HIGH)
          .toList()
          .length;
      medCount = dataList
          .where((element) => element.alertSeverity == Constants.ALERT_MEDIUM)
          .toList()
          .length;
      lowCount = dataList
          .where((element) => element.alertSeverity == Constants.ALERT_LOW)
          .toList()
          .length;
      otherCount = dataList
          .where((element) => !Utils.isNotEmpty(element.alertSeverity))
          .toList()
          .length;
    }

    return Container(
      height: 67.5,
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  width: 1,
                  color: (statisticsDividerCounter != length)
                      ? theme_dark!
                          ? AppColors.appDividerColor()
                          : AppColorsLightMode.appDividerColor()
                      : Colors.transparent))),
      margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
      padding: EdgeInsets.fromLTRB(11.5, 15, 0, 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 100,
            child: Text(
              Utils.ammendSentences(key),
              style: AppFonts.sfproRegular(
                13,
                color: theme_dark!
                    ? AppColors.appGreyB1()
                    : AppColorsLightMode.appGrey77(),
                decoration: TextDecoration.none,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          SizedBox(width: 30.0),
          Expanded(
            child: Container(
              child: Wrap(
                children: [
                  (highCount != null && highCount.toInt() > 0)
                      ? preferedAlertStatusItem(ctx, "High", highCount)
                      : Container(),
                  (medCount != null && medCount.toInt() > 0)
                      ? preferedAlertStatusItem(ctx, "Medium", medCount)
                      : Container(),
                  (lowCount != null && lowCount.toInt() > 0)
                      ? preferedAlertStatusItem(ctx, "Low", lowCount)
                      : Container(),
                  (otherCount != null && otherCount.toInt() > 0)
                      ? preferedAlertStatusItem(ctx, "Others", otherCount)
                      : Container(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget preferedAlertStatusItem(BuildContext ctx, String? status, num? count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 10,
          width: 10,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: status == Constants.ALERT_HIGH
                  ? AppColors.appAlertHigh()
                  : status == Constants.ALERT_MEDIUM
                      ? AppColors.appAlertMed()
                      : status == Constants.ALERT_LOW
                          ? AppColors.appAlertLow()
                          : AppColors.appPrimaryWhite()),
        ),
        SizedBox(width: 10.0),
        Text(
          '${count!.toInt()}',
          style: AppFonts.robotoMedium(
            13,
            color: theme_dark!
                ? AppColors.appGreyDE()
                : AppColorsLightMode.appGrey(),
            decoration: TextDecoration.none,
          ),
        ),
        SizedBox(width: 16.0),
      ],
    );
  }

  Widget preferedAlertAccurracyStatus(BuildContext ctx) {
    return GestureDetector(
      onTap: () {
        if (this.alertStatisticsDTO.data != null &&
            this.alertStatisticsDTO.data!.length > 0) {
          Navigator.pushNamed(
            ctx,
            AppRoutes.alertAccuracyStatusRoute,
            arguments: AlertArguments(
              preferedAlertList: this.alertStatisticsDTO.data!,
            ),
          );
        }
      },
      child: Container(
        margin: EdgeInsets.only(right: 16, left: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: theme_dark!
              ? AppColors.appBlackLight()
              : AppColorsLightMode.appGreyF0(),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 17, top: 18, bottom: 16),
              child: Text(
                Utils.getTranslated(context, 'alertAccuracyStatus')!,
                style: AppFonts.robotoRegular(
                  16,
                  color: theme_dark!
                      ? AppColors.appGrey2()
                      : AppColorsLightMode.appGrey(),
                  decoration: TextDecoration.none,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            (this.alertStatisticsDTO.data != null &&
                    this.alertStatisticsDTO.data!.length > 0)
                ? Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        colorDotLabel(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: this
                              .preferredAlertAccuracyMap
                              .entries
                              .map((entry) => preferedAlertAccuracyItem(
                                  context,
                                  entry.key!,
                                  entry.value,
                                  this.preferredAlertAccuracyMap.length))
                              .toList(),
                        ),
                      ],
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
      ),
    );
  }

  Widget preferedAlertAccuracyItem(BuildContext ctx, String key,
      List<AlertStatisticsDataDTO> dataList, int length) {
    int highTotal = 0;
    int mediumTotal = 0;
    int lowTotal = 0;
    int otherTotal = 0;
    List<CustomDTO> totalList = [];

    highTotal = dataList
        .where((element) =>
            Utils.isNotEmpty(element.alertSeverity) &&
            element.alertSeverity == Constants.ALERT_HIGH)
        .toList()
        .length;
    mediumTotal = dataList
        .where((element) =>
            Utils.isNotEmpty(element.alertSeverity) &&
            element.alertSeverity == Constants.ALERT_MEDIUM)
        .toList()
        .length;
    lowTotal = dataList
        .where((element) =>
            Utils.isNotEmpty(element.alertSeverity) &&
            element.alertSeverity == Constants.ALERT_LOW)
        .toList()
        .length;
    otherTotal = dataList
        .where((element) => !Utils.isNotEmpty(element.alertSeverity))
        .toList()
        .length;

    if (highTotal > 0) {
      totalList.add(CustomDTO(
          displayName: highTotal.toString(), value: Constants.ALERT_HIGH));
    }

    if (mediumTotal > 0) {
      totalList.add(CustomDTO(
          displayName: mediumTotal.toString(), value: Constants.ALERT_MEDIUM));
    }

    if (lowTotal > 0) {
      totalList.add(CustomDTO(
          displayName: lowTotal.toString(), value: Constants.ALERT_LOW));
    }

    if (otherTotal > 0) {
      totalList.add(CustomDTO(displayName: otherTotal.toString(), value: ""));
    }

    (accuracyDividerCounter != length)
        ? accuracyDividerCounter = accuracyDividerCounter + 1
        : accuracyDividerCounter = 1;
    return Container(
      height: 67.5,
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  width: 1,
                  color: (accuracyDividerCounter != length)
                      ? theme_dark!
                          ? AppColors.appDividerColor()
                          : AppColorsLightMode.appDividerColor()
                      : Colors.transparent))),
      margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
      padding: EdgeInsets.fromLTRB(11.5, 15, 0, 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 100,
            child: Text(
              Utils.capitalize(key),
              style: AppFonts.sfproRegular(
                13,
                color: theme_dark!
                    ? AppColors.appGreyB1()
                    : AppColorsLightMode.appGrey77(),
                decoration: TextDecoration.none,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          SizedBox(width: 30.0),
          Expanded(
            child: Container(
              child: Wrap(
                children: totalList
                    .map((e) => alertStatusItem(
                        ctx, e.value, num.parse(e.displayName!)))
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget preferedAlertInformationLabel(BuildContext ctx) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            margin: EdgeInsets.only(left: 16),
            child: Text(
              Utils.getTranslated(context, 'alert_information')!,
              style: AppFonts.robotoRegular(
                16,
                color: theme_dark!
                    ? AppColors.appGrey2()
                    : AppColorsLightMode.appGrey(),
                decoration: TextDecoration.none,
              ),
            ),
          ),
        ),
        Row(
          children: [
            GestureDetector(
              onTap: () {
                if (this.preferedASList.length > 0) {
                  Navigator.pushNamed(
                    ctx,
                    AppRoutes.searchRoute,
                    arguments: SearchArguments(
                      preferedASList: this.preferedASList,
                    ),
                  );
                }
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Image.asset(theme_dark!
                    ? Constants.ASSET_IMAGES + 'search_icon.png'
                    : Constants.ASSET_IMAGES_LIGHT + 'search.png'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: GestureDetector(
                onTap: () async {
                  if (this.alertStatisticsDTO.data != null &&
                      this.alertStatisticsDTO.data!.length > 0) {
                    final navResult = await Navigator.pushNamed(
                        ctx, AppRoutes.alertReviewDataFilterRoute,
                        arguments: AlertFilterArguments(
                          filterAlertStatusList: this.filterAlertStatusList,
                          filterAlertTypeList: this.filterAlertTypeList,
                        ));

                    if (navResult != null && navResult as bool) {
                      List<String> selectedType = [];
                      List<String> selectedStatus = [];
                      this.filterAlertTypeList.forEach((element) {
                        if (element.isSelected!) {
                          selectedType.add(element.item!);
                        }
                      });
                      this.filterAlertStatusList.forEach((element) {
                        if (element.isSelected!) {
                          selectedStatus.add(element.item!);
                        }
                      });

                      setState(() {
                        this.pageNo = 0;
                        this.showBottom = false;
                        this.preferedAlertSelectedList.clear();
                        this.preferedASList = this
                            .alertStatisticsDTO
                            .data!
                            .where((e) =>
                                selectedType.contains(e.sender) &&
                                selectedStatus.contains(e.status))
                            .toList();
                      });
                    }
                  }
                },
                child: Image.asset(theme_dark!
                    ? Constants.ASSET_IMAGES + 'filter_icon.png'
                    : Constants.ASSET_IMAGES_LIGHT + 'filter_icon.png'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: GestureDetector(
                onTap: () {
                  if (this.alertStatisticsDTO.data!.length > 0) {
                    showDownloadCsvPopup(context);
                  }
                },
                child: Image.asset(theme_dark!
                    ? Constants.ASSET_IMAGES + 'download_bttn.png'
                    : Constants.ASSET_IMAGES_LIGHT + 'download_bttn.png'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget preferedAlertInfoSorting(BuildContext ctx) {
    if (this.alertStatisticsDTO.data != null &&
        this.alertStatisticsDTO.data!.length > 0) {
      return Container(
        margin: EdgeInsets.only(left: 16.0, right: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                showSortMenuPopup(ctx);
              },
              child: Container(
                padding: EdgeInsets.fromLTRB(20.0, 7.0, 20.0, 7.0),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(
                    color: theme_dark!
                        ? AppColors.appPrimaryWhite()
                        : AppColorsLightMode.appTeal(),
                  ),
                  borderRadius: BorderRadius.circular(50.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      Utils.getTranslated(ctx, 'sort_by')! + ' $sortBy',
                      style: AppFonts.robotoMedium(
                        14,
                        color: theme_dark!
                            ? AppColors.appPrimaryWhite()
                            : AppColorsLightMode.appTeal(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                    SizedBox(width: 10.0),
                    Image.asset(theme_dark!
                        ? Constants.ASSET_IMAGES + 'dropdown_icon.png'
                        : Constants.ASSET_IMAGES_LIGHT + 'dropdown.png'),
                  ],
                ),
              ),
            ),
            SizedBox(width: 12.0),
            sortBy.length > 0
                ? GestureDetector(
                    onTap: () {
                      showSortAscOrDscPopup(ctx);
                    },
                    child: Container(
                      padding: EdgeInsets.fromLTRB(20.0, 7.0, 20.0, 7.0),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(
                          color: theme_dark!
                              ? AppColors.appPrimaryWhite()
                              : AppColorsLightMode.appTeal(),
                        ),
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            sorting.length > 0
                                ? Utils.getTranslated(ctx, sorting)!
                                : 'Please select',
                            style: AppFonts.robotoMedium(
                              14,
                              color: theme_dark!
                                  ? AppColors.appPrimaryWhite()
                                  : AppColorsLightMode.appTeal(),
                              decoration: TextDecoration.none,
                            ),
                          ),
                          SizedBox(width: 10.0),
                          Image.asset(theme_dark!
                              ? Constants.ASSET_IMAGES + 'dropdown_icon.png'
                              : Constants.ASSET_IMAGES_LIGHT + 'dropdown.png'),
                        ],
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      );
    }

    return Container();
  }

  Widget preferedAlertInformationData(BuildContext ctx) {
    if (this.preferedASList.length > 0) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List<Widget>.generate(
            this.preferedASList.length < ((pageNo * pageSize) + pageSize)
                ? this.preferedASList.length
                : ((pageNo * pageSize) + pageSize), (index) {
          return preferedDataItem(ctx, this.preferedASList[index]);
        }),
      );
    }

    return Container(
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
    );
  }

  Widget preferedDataItem(BuildContext ctx, AlertStatisticsDataDTO dataDTO) {
    return Container(
      margin: EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                margin: EdgeInsets.only(top: 20),
                height: 20,
                width: 20,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      if (this.preferedAlertSelectedList.indexOf(dataDTO) < 0) {
                        this.preferedAlertSelectedList.add(dataDTO);
                        this.showBottom = true;
                      } else {
                        this.preferedAlertSelectedList.remove(dataDTO);
                        if (this.preferedAlertSelectedList.length == 0) {
                          this.showBottom = false;
                        }
                      }
                    });
                  },
                  child: Image.asset((this
                              .preferedAlertSelectedList
                              .indexOf(dataDTO) <
                          0)
                      ? theme_dark!
                          ? Constants.ASSET_IMAGES + 'check_box.png'
                          : Constants.ASSET_IMAGES_LIGHT + 'check_box.png'
                      : theme_dark!
                          ? Constants.ASSET_IMAGES + 'checked_box.png'
                          : Constants.ASSET_IMAGES_LIGHT + 'checked_box.png'),
                )),
            SizedBox(
              width: 16,
            ),
            GestureDetector(
              onTap: () async {
                if (dataDTO.sender == Constants.ALERT_COMPONENT_ANOMALY ||
                    dataDTO.sender == Constants.ALERT_DEGRADATION_ANOMALY) {
                  final navResult = await Navigator.pushNamed(
                    context,
                    AppRoutes.alertAnomalyInfo,
                    arguments: AlertArguments(
                        alertStatisticsDataDTO: dataDTO,
                        alertType: dataDTO.sender),
                  );
                  if (navResult != null && navResult as bool) {
                    EasyLoading.show(maskType: EasyLoadingMaskType.black);
                    this.pageNo = 0;
                    callGetAlertStatistics(context);
                  }
                } else if (dataDTO.sender ==
                    Constants.ALERT_CPK_ALERT_ANOMALIES) {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.alertCPKList,
                    arguments: AlertArguments(alertStatisticsDataDTO: dataDTO),
                  );
                } else if (dataDTO.sender ==
                    Constants.ALERT_LIMIT_CHANGE_ANOMALY) {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.alertReviewChangeLimitRoute,
                    arguments: AlertArguments(
                      alertStatisticsDataDTO: dataDTO,
                    ),
                  );
                } else if (dataDTO.sender ==
                        Constants.ALERT_PAT_LIMIT_ANOMALIES ||
                    dataDTO.sender ==
                        Constants.ALERT_PAT_LIMIT_RECOMMENDATION) {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.alertAnomalyInfo,
                    arguments: AlertArguments(
                        alertStatisticsDataDTO: dataDTO,
                        alertType: dataDTO.sender),
                  );
                }
                // if (dataDTO.sender == Constants.ALERT_COMPONENT_ANOMALY ||
                //     dataDTO.sender == Constants.ALERT_DEGRADATION_ANOMALY) {
                //   final navResult = await Navigator.pushNamed(
                //     context,
                //     AppRoutes.alertAnomalyInfo,
                //     arguments: AlertArguments(alertStatisticsDataDTO: dataDTO),
                //   );
                //   if (navResult != null && navResult as bool) {
                //     EasyLoading.show(maskType: EasyLoadingMaskType.black);
                //     this.pageNo = 0;
                //     callGetAlertStatistics(context);
                //   }
                // } else if (dataDTO.sender ==
                //     Constants.ALERT_CPK_ALERT_ANOMALIES) {
                //   Navigator.pushNamed(
                //     context,
                //     AppRoutes.alertCPKList,
                //     arguments: AlertArguments(alertStatisticsDataDTO: dataDTO),
                //   );
                // }
              },
              child: Container(
                padding: EdgeInsets.fromLTRB(12, 13, 9, 12),
                color: theme_dark!
                    ? AppColors.appBlackLight()
                    : AppColorsLightMode.appGreyF0(),
                width: MediaQuery.of(context).size.width - 68,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Visibility(
                        visible: Utils.isNotEmpty(dataDTO.alertSeverity),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            height: 20,
                            padding:
                                EdgeInsets.only(top: 3, right: 10, left: 10),
                            decoration: BoxDecoration(
                                color: getTagColor(dataDTO.alertSeverity),
                                borderRadius: BorderRadius.circular(2)),
                            child: Text(
                              Utils.isNotEmpty(dataDTO.alertSeverity)
                                  ? dataDTO.alertSeverity!
                                  : 'Other',
                              style: AppFonts.robotoMedium(
                                12,
                                color: Utils.isNotEmpty(dataDTO.alertSeverity)
                                    ? AppColors.appGreyDE()
                                    : AppColors.appBlackLight(),
                                decoration: TextDecoration.none,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 35),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Utils.getTranslated(context, 'alert_alertid')!,
                              style: AppFonts.robotoRegular(
                                13,
                                color: theme_dark!
                                    ? AppColors.appGreyB1()
                                    : AppColorsLightMode.appGrey77(),
                                decoration: TextDecoration.none,
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              Utils.isNotEmpty(dataDTO.alertIdName)
                                  ? dataDTO.alertIdName!
                                  : '-',
                              style: AppFonts.robotoRegular(
                                14,
                                color: theme_dark!
                                    ? AppColors.appGreyDE()
                                    : AppColorsLightMode.appGrey(),
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        margin: EdgeInsets.only(right: 35),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Utils.getTranslated(context, 'alert_equipment')!,
                              style: AppFonts.robotoRegular(
                                13,
                                color: theme_dark!
                                    ? AppColors.appGreyB1()
                                    : AppColorsLightMode.appGrey77(),
                                decoration: TextDecoration.none,
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              Utils.isNotEmpty(dataDTO.equipmentName)
                                  ? dataDTO.equipmentName!
                                  : '-',
                              style: AppFonts.robotoRegular(
                                14,
                                color: theme_dark!
                                    ? AppColors.appGreyDE()
                                    : AppColorsLightMode.appGrey(),
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      //project
                      Container(
                        margin: EdgeInsets.only(right: 35),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Utils.getTranslated(context, 'alert_project')!,
                              style: AppFonts.robotoRegular(
                                13,
                                color: theme_dark!
                                    ? AppColors.appGreyB1()
                                    : AppColorsLightMode.appGrey77(),
                                decoration: TextDecoration.none,
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              Utils.isNotEmpty(dataDTO.projectId)
                                  ? dataDTO.projectId!
                                  : '-',
                              style: AppFonts.robotoRegular(
                                14,
                                color: theme_dark!
                                    ? AppColors.appGreyDE()
                                    : AppColorsLightMode.appGrey(),
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 20),
                      //timestamp & scoring
                      Container(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    Utils.getTranslated(
                                        context, 'alert_timestamp')!,
                                    style: AppFonts.robotoRegular(
                                      13,
                                      color: theme_dark!
                                          ? AppColors.appGreyB1()
                                          : AppColorsLightMode.appGrey77(),
                                      decoration: TextDecoration.none,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 6,
                                  ),
                                  Text(
                                    Utils.isNotEmpty(dataDTO.timestamp)
                                        ? DateFormat("dd MMM yyyy HH:mm:ss")
                                            .format(DateTime.parse(
                                                dataDTO.timestamp!))
                                        : '-',
                                    style: AppFonts.robotoRegular(
                                      14,
                                      color: theme_dark!
                                          ? AppColors.appGreyDE()
                                          : AppColorsLightMode.appGrey(),
                                      decoration: TextDecoration.none,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.only(right: 35),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      Utils.getTranslated(
                                          context, 'alert_scoring')!,
                                      style: AppFonts.robotoRegular(
                                        13,
                                        color: theme_dark!
                                            ? AppColors.appGreyB1()
                                            : AppColorsLightMode.appGrey77(),
                                        decoration: TextDecoration.none,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 6,
                                    ),
                                    Text(
                                      Utils.isNotEmpty(dataDTO.alertScoring)
                                          ? double.parse(dataDTO.alertScoring!)
                                              .toStringAsFixed(2)
                                          : '-',
                                      style: AppFonts.robotoRegular(
                                        14,
                                        color: theme_dark!
                                            ? AppColors.appGreyDE()
                                            : AppColorsLightMode.appGrey(),
                                        decoration: TextDecoration.none,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ]),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      //alert message
                      Container(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                Utils.getTranslated(
                                    context, 'alert_information')!,
                                style: AppFonts.robotoRegular(
                                  13,
                                  color: theme_dark!
                                      ? AppColors.appGreyB1()
                                      : AppColorsLightMode.appGrey77(),
                                  decoration: TextDecoration.none,
                                ),
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              Text(
                                Utils.isNotEmpty(dataDTO.event)
                                    ? dataDTO.event!
                                    : '-',
                                style: AppFonts.robotoRegular(
                                  14,
                                  color: theme_dark!
                                      ? AppColors.appGreyDE()
                                      : AppColorsLightMode.appGrey(),
                                  decoration: TextDecoration.none,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ]),
                      ),
                    ]),
              ),
            )
          ]),
    );
  }

  Widget preferedViewMoreButton(BuildContext ctx) {
    if (this.preferedASList.length > 0) {
      if (((pageNo * pageSize) + pageSize) < this.preferedASList.length) {
        return GestureDetector(
          onTap: () {
            setState(() {
              this.pageNo += 1;
            });
          },
          child: Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.only(right: 16.0, bottom: 16.0),
              child: Text(
                Utils.getTranslated(ctx, 'view_more')!,
                style: AppFonts.robotoMedium(
                  14,
                  color: AppColors.appBlue(),
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          ),
        );
      }
    }

    return Container();
  }

  void showDownloadCsvPopup(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext csvContext) => CupertinoActionSheet(
        actions: [
          Container(
            color: theme_dark!
                ? AppColors.cupertinoBackground()
                : AppColorsLightMode.cupertinoBackground().withOpacity(0.8),
            child: CupertinoActionSheetAction(
              onPressed: () async {
                Navigator.pop(csvContext);
                String curDate =
                    '#${DateFormat('yyyy.MM.dd').format(DateTime.now())}@${DateFormat('HH.mm.ss').format(DateTime.now())}';

                String name = Utils.getExportFilename(
                  'alrtRevw',
                  companyId: AppCache.sortFilterCacheDTO!.preferredCompany,
                  siteId: AppCache.sortFilterCacheDTO!.preferredSite,
                  fromDate: DateFormat('yyyy-MM-dd')
                      .format(AppCache.sortFilterCacheDTO!.startDate!),
                  toDate: DateFormat('yyyy-MM-dd')
                      .format(AppCache.sortFilterCacheDTO!.endDate!),
                  currentDate: curDate,
                  expType: '.csv',
                );
                final result = await CSVApi.generateCSV(preferedASList, name);
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
        ],
        cancelButton: Container(
          decoration: BoxDecoration(
              color: theme_dark!
                  ? AppColors.cupertinoBackground()
                  : AppColorsLightMode.cupertinoBackground(),
              borderRadius: BorderRadius.circular(14)),
          child: CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(csvContext);
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

  getTagColor(tag) {
    if (tag == 'Critical')
      return AppColors.appRedE9();
    else if (tag == 'High')
      return AppColors.appRedE9();
    else if (tag == 'Medium')
      return AppColors.appPrimaryOrange();
    else if (tag == 'Low')
      return AppColors.appPrimaryYellow();
    else if (tag == "None")
      return AppColors.appGreen60();
    else
      return Colors.transparent;
  }

  Container colorDotLabel() {
    return Container(
      margin: EdgeInsets.only(left: 9, right: 11, bottom: 9.5),
      padding: EdgeInsets.only(left: 11, top: 12),
      height: 43,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
              width: 1,
              color: theme_dark!
                  ? AppColors.appAlertBorderBlack()
                  : AppColorsLightMode.appTeal())),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(top: 4, right: 10),
              height: 10,
              width: 10,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: AppColors.appAlertHigh()),
            ),
            Text(
              Utils.getTranslated(context, 'colordot_high')!,
              style: AppFonts.robotoMedium(
                13,
                color: theme_dark!
                    ? AppColors.appGreyDE()
                    : AppColorsLightMode.appGrey(),
                decoration: TextDecoration.none,
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Container(
              margin: EdgeInsets.only(top: 4, right: 10),
              height: 10,
              width: 10,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: AppColors.appAlertMed()),
            ),
            Text(
              Utils.getTranslated(context, 'colordot_medium')!,
              style: AppFonts.robotoMedium(
                13,
                color: theme_dark!
                    ? AppColors.appGreyDE()
                    : AppColorsLightMode.appGrey(),
                decoration: TextDecoration.none,
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Container(
              margin: EdgeInsets.only(top: 4, right: 10),
              height: 10,
              width: 10,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: AppColors.appAlertLow()),
            ),
            Text(
              Utils.getTranslated(context, 'colordot_low')!,
              style: AppFonts.robotoMedium(
                13,
                color: theme_dark!
                    ? AppColors.appGreyDE()
                    : AppColorsLightMode.appGrey(),
                decoration: TextDecoration.none,
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Container(
              margin: EdgeInsets.only(top: 4, right: 10),
              height: 10,
              width: 10,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: AppColors.appPrimaryWhite()),
            ),
            Text(
              Utils.getTranslated(context, 'colordot_other')!,
              style: AppFonts.robotoMedium(
                13,
                color: theme_dark!
                    ? AppColors.appGreyDE()
                    : AppColorsLightMode.appGrey(),
                decoration: TextDecoration.none,
              ),
            ),
          ]),
    );
  }

  void showSortMenuPopup(BuildContext context) {
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
                setState(() {
                  sortBy =
                      Utils.getTranslated(context, 'alert_sortby_timestamp')!;
                  this.sortType = Constants.ALERT_SORT_BY_TIMESTAMP;
                  sortData();
                });
                Navigator.pop(popContext);
              },
              child: Text(
                Utils.getTranslated(context, 'alert_sortby_timestamp')!,
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
                setState(() {
                  sortBy =
                      Utils.getTranslated(context, 'alert_sortby_alertid')!;
                  this.sortType = Constants.ALERT_SORT_BY_ALERT_ID;
                  sortData();
                });
                Navigator.pop(popContext);
              },
              child: Text(
                Utils.getTranslated(context, 'alert_sortby_alertid')!,
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
                setState(() {
                  sortBy =
                      Utils.getTranslated(context, 'alert_sortby_equipment')!;
                  this.sortType = Constants.ALERT_SORT_BY_EQUIPMENT;
                  sortData();
                });
                Navigator.pop(popContext);
              },
              child: Text(
                Utils.getTranslated(context, 'alert_sortby_equipment')!,
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
                setState(() {
                  sortBy =
                      Utils.getTranslated(context, 'alert_sortby_project')!;
                  this.sortType = Constants.ALERT_SORT_BY_PROJECT;
                  sortData();
                });
                Navigator.pop(popContext);
              },
              child: Text(
                Utils.getTranslated(context, 'alert_sortby_project')!,
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
                setState(() {
                  sortBy =
                      Utils.getTranslated(context, 'alert_sortby_severity')!;
                  this.sortType = Constants.ALERT_SORT_BY_SEVERITY;
                  sortData();
                });
                Navigator.pop(popContext);
              },
              child: Text(
                Utils.getTranslated(context, 'alert_sortby_severity')!,
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
                setState(() {
                  sortBy =
                      Utils.getTranslated(context, 'alert_sortby_scoring')!;
                  this.sortType = Constants.ALERT_SORT_BY_SCORING;
                  sortData();
                });
                Navigator.pop(popContext);
              },
              child: Text(
                Utils.getTranslated(context, 'alert_sortby_scoring')!,
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
                setState(() {
                  sortBy = Utils.getTranslated(context, 'alert_sortby_status')!;
                  this.sortType = Constants.ALERT_SORT_BY_STATUS;
                  sortData();
                });
                Navigator.pop(popContext);
              },
              child: Text(
                Utils.getTranslated(context, 'alert_sortby_status')!,
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

  void showSortAscOrDscPopup(BuildContext context) {
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
                setState(() {
                  sorting = Constants.SORT_ASCENDING;
                  sortData();
                });
                Navigator.pop(popContext);
              },
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      Utils.getTranslated(context, 'ascending')!,
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
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      margin: EdgeInsets.only(right: 70.0),
                      child: sorting.length > 0 &&
                              sorting == Constants.SORT_ASCENDING
                          ? Image.asset(
                              Constants.ASSET_IMAGES + 'tick_icon.png')
                          : Container(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            color: theme_dark!
                ? AppColors.cupertinoBackground()
                : AppColorsLightMode.cupertinoBackground().withOpacity(0.8),
            child: CupertinoActionSheetAction(
              onPressed: () {
                setState(() {
                  sorting = Constants.SORT_DESCENDING;
                  sortData();
                });
                Navigator.pop(popContext);
              },
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      Utils.getTranslated(context, 'descending')!,
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
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      margin: EdgeInsets.only(right: 70.0),
                      child: sorting.length > 0 &&
                              sorting == Constants.SORT_DESCENDING
                          ? Image.asset(
                              Constants.ASSET_IMAGES + 'tick_icon.png')
                          : Container(),
                    ),
                  ),
                ],
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

  showBulkDismissAlertDialog(
      BuildContext context,
      List<BulkAlertInfoDTO> bulkActualList,
      List<BulkAlertInfoDTO> bulkDismissList,
      List<BulkAlertInfoDTO> bulkDisposeList) {
    List<BulkAlertInfoDTO> list = [];
    List<BulkAlertInfoDTO> allList = [];
    list.addAll(bulkDismissList);
    list.addAll(bulkDisposeList);
    allList.addAll(bulkActualList);
    allList.addAll(list);
    showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return CupertinoAlertDialog(
            title: Text(
                this.isDismiss ? "Bulk Dismiss Alert" : "Bulk Dispose Alert",
                style: AppFonts.robotoBold(16,
                    color: AppColors.appPrimaryWhite(),
                    decoration: TextDecoration.none)),
            content: new Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: list
                        .map((e) => new Text(
                              '${e.alertIdName} (Reason: ${e.statusMessage})',
                              style: AppFonts.robotoRegular(14,
                                  color: AppColors.appPrimaryWhite(),
                                  decoration: TextDecoration.none),
                            ))
                        .toList(),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    this.isDismiss
                        ? 'Do you want to force dismiss all alert at the same time?'
                        : 'Do you want to force dispose all alert at the same time?',
                    style: AppFonts.robotoRegular(14,
                        color: AppColors.appPrimaryWhite(),
                        decoration: TextDecoration.none),
                  ),
                ]),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text(
                  "Yes (${bulkActualList.length + bulkDismissList.length + bulkDisposeList.length})",
                  style: AppFonts.robotoRegular(16,
                      color: AppColors.appBlue(),
                      decoration: TextDecoration.none),
                ),
                onPressed: () async {
                  Navigator.of(dialogContext).pop();
                  if (this.isDismiss) {
                    final navResult = await Navigator.pushNamed(
                        context, AppRoutes.dismissCase,
                        arguments: AlertArguments(bulkAlertList: allList));
                    if (navResult != null && navResult as bool) {
                      this.selectAll = false;
                      this.showBottom = false;
                      this.preferedAlertSelectedList.clear();
                      EasyLoading.show(maskType: EasyLoadingMaskType.black);
                      this.pageNo = 0;
                      callGetAlertStatistics(context);
                    }
                  } else {
                    final navResult = await Navigator.pushNamed(
                        context, AppRoutes.disposeORcreateCase,
                        arguments: AlertArguments(bulkAlertList: allList));
                    if (navResult != null && navResult as bool) {
                      this.selectAll = false;
                      this.showBottom = false;
                      this.preferedAlertSelectedList.clear();
                      EasyLoading.show(maskType: EasyLoadingMaskType.black);
                      this.pageNo = 0;
                      callGetAlertStatistics(context);
                    }
                  }
                },
              ),
              CupertinoDialogAction(
                child: Text(
                  "No (${bulkActualList.length})",
                  style: AppFonts.robotoRegular(16,
                      color: AppColors.appBlue(),
                      decoration: TextDecoration.none),
                ),
                onPressed: () async {
                  Navigator.of(dialogContext).pop();
                  if (this.isDismiss) {
                    if (bulkActualList.length > 0) {
                      final navResult = await Navigator.pushNamed(
                          context, AppRoutes.dismissCase,
                          arguments: AlertArguments(
                              bulkAlertActualList: bulkActualList));
                      if (navResult != null && navResult as bool) {
                        this.selectAll = false;
                        this.showBottom = false;
                        this.preferedAlertSelectedList.clear();
                        EasyLoading.show(maskType: EasyLoadingMaskType.black);
                        this.pageNo = 0;
                        callGetAlertStatistics(context);
                      }
                    }
                  } else {
                    if (bulkActualList.length > 0) {
                      final navResult = await Navigator.pushNamed(
                          context, AppRoutes.disposeORcreateCase,
                          arguments: AlertArguments(
                              bulkAlertActualList: bulkActualList));
                      if (navResult != null && navResult as bool) {
                        this.selectAll = false;
                        this.showBottom = false;
                        this.preferedAlertSelectedList.clear();
                        EasyLoading.show(maskType: EasyLoadingMaskType.black);
                        this.pageNo = 0;
                        callGetAlertStatistics(context);
                      }
                    }
                  }
                },
              ),
              CupertinoDialogAction(
                child: Text(
                  "Cancel",
                  style: AppFonts.robotoRegular(16,
                      color: AppColors.appBlue(),
                      decoration: TextDecoration.none),
                ),
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                },
              ),
            ],
          );
        });
  }
}
