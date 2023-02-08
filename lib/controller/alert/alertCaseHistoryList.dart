import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:keysight_pma/cache/appcache.dart';
import 'package:keysight_pma/const/appcolors.dart';
import 'package:keysight_pma/const/constants.dart';
import 'package:keysight_pma/const/download.dart';
import 'package:keysight_pma/const/utils.dart';
import 'package:keysight_pma/dio/api/alert.dart';
import 'package:keysight_pma/dio/api/sort_filter.dart';
import 'package:keysight_pma/model/alert/alert_casehistory.dart';
import 'package:keysight_pma/model/arguments/alert_routeTitle.dart';
import 'package:keysight_pma/model/arguments/dqm_argument.dart';
import 'package:keysight_pma/model/arguments/search_argument.dart';
import 'package:keysight_pma/model/arguments/sort_filter_argument.dart';
import 'package:keysight_pma/model/sortAndFilter/equipment.dart';
import 'package:keysight_pma/model/sortAndFilter/projects.dart';
import 'package:keysight_pma/routes/approutes.dart';

import '../../const/appfonts.dart';
import '../../model/customize.dart';

class AlertCaseHistoryList extends StatefulWidget {
  const AlertCaseHistoryList({Key? key}) : super(key: key);

  @override
  State<AlertCaseHistoryList> createState() => _AlertCaseHistoryListState();
}

class _AlertCaseHistoryListState extends State<AlertCaseHistoryList> {
  bool isLoading = true;
  AlertCaseHistoryDTO? alertCaseHistoryDTO;
  List<AlertCaseHistoryDataDTO> alertCaseHistoryDataDTO = [];
  List<CustomDqmSortFilterItemSelectionDTO> preferedStatusList = [];
  List<CustomDqmSortFilterItemSelectionDTO> preferedWorkflowList = [];
  List<CustomDqmSortFilterItemSelectionDTO> preferedPriorityList = [];
  late Map<String?, List<AlertCaseHistoryDataDTO>> preferedStatusListMap;
  late Map<String?, List<AlertCaseHistoryDataDTO>> preferedWorkflowListMap;
  late Map<String?, List<AlertCaseHistoryDataDTO>> preferedPriorityListMap;

  String sorting = Constants.SORT_ASCENDING;
  String sortBy = '';
  int sortType = 0;
  int page = 0;
  int pageSize = 10;

  bool? theme_dark = AppCache.sortFilterCacheDTO!.currentTheme;
  Future<ProjectsDTO> loadProjectList(BuildContext ctx) {
    SortFilterApi sortFilterApi = SortFilterApi(ctx);
    return sortFilterApi.loadProjectList(
        AppCache.sortFilterCacheDTO!.preferredCompany!,
        AppCache.sortFilterCacheDTO!.preferredSite!);
  }

  Future<EquipmentDTO> loadEquipments(BuildContext ctx) {
    SortFilterApi sortFilterApi = SortFilterApi(ctx);
    return sortFilterApi.loadEquipments(
        AppCache.sortFilterCacheDTO!.preferredCompany!,
        AppCache.sortFilterCacheDTO!.preferredSite!);
  }

  Future<AlertCaseHistoryDTO> searchCases(
    BuildContext ctx,
  ) {
    AlertApi alertApi = AlertApi(ctx);
    String companyId = AppCache.sortFilterCacheDTO!.preferredCompany!;
    String siteId = AppCache.sortFilterCacheDTO!.preferredSite!;
    String startDate = DateFormat("yyyy-MM-dd")
        .format(AppCache.sortFilterCacheDTO!.startDate!);
    String endDate =
        DateFormat("yyyy-MM-dd").format(AppCache.sortFilterCacheDTO!.endDate!);
    List<String?> equipments = AppCache.sortFilterCacheDTO!.defaultEquipments!
        .map((e) => e.equipmentId)
        .toList();
    String projectId = AppCache.sortFilterCacheDTO!.defaultProjectId!;

    String? dateFilter;
    if (AppCache.sortFilterCacheDTO!.casehistorydatetype != null) {
      dateFilter = AppCache.sortFilterCacheDTO!.casehistorydatetype!;
    } else {
      AppCache.sortFilterCacheDTO!.casehistorydatetype = 'alertDate';
      dateFilter = 'alertDate';
    }

//caseModifiedDate alertDate
    return alertApi.searchCases(companyId, siteId, equipments, null, null, null,
        endDate, startDate, dateFilter, projectId);
  }

  callAlertCaseHistory(BuildContext context) async {
    await searchCases(context).then((value) {
      if (value.status!.statusCode == 200) {
        alertCaseHistoryDTO = value;
        if (value.data != null && value.data!.length > 0) {
          this.alertCaseHistoryDataDTO = value.data!;
          //groupAnalogCpkList(value.data!);
          groupPreferredPriority();
          groupPreferedStatus();
          groupPreferredWorkflow();
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
  //   void groupAnalogCpkList(List<AlertCaseHistoryDataDTO> data) {
  //   final groups = groupBy(data, (AlertCaseHistoryDataDTO e) {
  //     return e.;
  //   });

  //   setState(() {
  //     this.analogCpkMap = groups;
  //     if (this.analogTestTypeList.length == 0) {
  //       this.analogCpkMap.keys.forEach((element) {
  //         CustomDqmSortFilterItemSelectionDTO itemSelectionDTO =
  //             CustomDqmSortFilterItemSelectionDTO(element, true);
  //         this.analogTestTypeList.add(itemSelectionDTO);
  //       });
  //     }
  //   });
  // }

  void groupPreferredPriority() {
    final groups =
        groupBy(this.alertCaseHistoryDTO!.data!, (AlertCaseHistoryDataDTO e) {
      return e.priority;
    });

    setState(() {
      this.preferedPriorityListMap = groups;
      preferedPriorityList.clear();
      this.preferedPriorityListMap.keys.forEach((element) {
        CustomDqmSortFilterItemSelectionDTO itemDTO =
            CustomDqmSortFilterItemSelectionDTO(element, true);
        preferedPriorityList.add(itemDTO);
      });
    });
  }

  void groupPreferedStatus() {
    final groups =
        groupBy(this.alertCaseHistoryDTO!.data!, (AlertCaseHistoryDataDTO e) {
      return e.status;
    });

    setState(() {
      this.preferedStatusListMap = groups;
      preferedStatusList.clear();
      this.preferedStatusListMap.keys.forEach((element) {
        CustomDqmSortFilterItemSelectionDTO itemDTO =
            CustomDqmSortFilterItemSelectionDTO(element, true);
        preferedStatusList.add(itemDTO);
      });
    });
  }

  void groupPreferredWorkflow() {
    final groups =
        groupBy(this.alertCaseHistoryDTO!.data!, (AlertCaseHistoryDataDTO e) {
      return e.workFlow;
    });

    setState(() {
      this.preferedWorkflowListMap = groups;
      preferedWorkflowList.clear();
      this.preferedWorkflowListMap.keys.forEach((element) {
        CustomDqmSortFilterItemSelectionDTO itemDTO =
            CustomDqmSortFilterItemSelectionDTO(element, true);
        preferedWorkflowList.add(itemDTO);
      });
    });
  }

  void sortAnalogCpkList() {
    if (this.alertCaseHistoryDataDTO.length > 0) {
      if (this.sortType == Constants.SORT_BY_ID) {
        this.alertCaseHistoryDataDTO.sort((a, b) {
          var oneB = '';
          var oneA = '';
          if (b.alertIdName != null) {
            oneB = b.alertIdName!;
          }
          if (a.alertIdName != null) {
            oneA = a.alertIdName!;
          }
          if (this.sorting == Constants.SORT_DESCENDING) {
            return oneB.compareTo(oneA);
          }
          return oneA.compareTo(oneB);
        });
      } else if (this.sortType == Constants.SORT_BY_EQ) {
        this.alertCaseHistoryDataDTO.sort((a, b) {
          var oneB = '';
          var oneA = '';
          if (b.equipmentName != null) {
            oneB = b.equipmentName!;
          }
          if (a.equipmentName != null) {
            oneA = a.equipmentName!;
          }
          if (this.sorting == Constants.SORT_DESCENDING) {
            return oneB.compareTo(oneA);
          }
          return oneA.compareTo(oneB);
        });
      } else if (this.sortType == Constants.SORT_BY_AssignedTo) {
        this.alertCaseHistoryDataDTO.sort((a, b) {
          var oneB = '';
          var oneA = '';
          if (b.assignedToName != null) {
            oneB = b.assignedToName!;
          }
          if (a.assignedToName != null) {
            oneA = a.assignedToName!;
          }
          if (this.sorting == Constants.SORT_DESCENDING) {
            return oneB.compareTo(oneA);
          }
          return oneA.compareTo(oneB);
        });
      } else if (this.sortType == Constants.SORT_BY_STATUS) {
        this.alertCaseHistoryDataDTO.sort((a, b) {
          var oneB = '';
          var oneA = '';
          if (b.status != null) {
            oneB = b.status!;
          }
          if (a.status != null) {
            oneA = a.status!;
          }
          if (this.sorting == Constants.SORT_DESCENDING) {
            return oneB.compareTo(oneA);
          }
          return oneA.compareTo(oneB);
        });
      } else if (this.sortType == Constants.SORT_BY_PRIORITY) {
        this.alertCaseHistoryDataDTO.sort((a, b) {
          var oneB = '';
          var oneA = '';
          if (b.priority != null) {
            oneB = b.priority!;
          }
          if (a.priority != null) {
            oneA = a.priority!;
          }
          if (this.sorting == Constants.SORT_DESCENDING) {
            return oneB.compareTo(oneA);
          }
          return oneA.compareTo(oneB);
        });
      } else if (this.sortType == Constants.SORT_BY_WORKFLOW) {
        this.alertCaseHistoryDataDTO.sort((a, b) {
          var oneB = '';
          var oneA = '';
          if (b.workFlow != null) {
            oneB = b.workFlow!;
          }
          if (a.workFlow != null) {
            oneA = a.workFlow!;
          }
          if (this.sorting == Constants.SORT_DESCENDING) {
            return oneB.compareTo(oneA);
          }
          return oneA.compareTo(oneB);
        });
      } else if (this.sortType == Constants.SORT_BY_MESSAGE) {
        this.alertCaseHistoryDataDTO.sort((a, b) {
          var oneB = '';
          var oneA = '';
          if (b.event != null) {
            oneB = b.event!;
          }
          if (a.event != null) {
            oneA = a.event!;
          }
          if (this.sorting == Constants.SORT_DESCENDING) {
            return oneB.compareTo(oneA);
          }
          return oneA.compareTo(oneB);
        });
      }
    }
  }

  callLoadProjectList(BuildContext context) async {
    await loadProjectList(context).then((value) {
      if (value.data != null && value.data!.length > 0) {
        AppCache.sortFilterCacheDTO!.defaultProjectId =
            value.data![0].projectId!;
        AppCache.sortFilterCacheDTO!.defaultVersion = 'Base';
        if (Utils.isNotEmpty(value.data![0].projectName)) {
          AppCache.sortFilterCacheDTO!.displayProjectName =
              '${value.data![0].projectName} (${value.data![0].projectId})';
        } else {
          AppCache.sortFilterCacheDTO!.displayProjectName =
              value.data![0].projectId!;
        }
      }
      if (AppCache.sortFilterCacheDTO!.defaultEquipments == null ||
          AppCache.sortFilterCacheDTO!.defaultEquipments!.length == 0) {
        callLoadEquipments(context);
      } else {
        callAlertCaseHistory(context);
      }
    }).catchError((error) {
      setState(() {
        this.isLoading = false;
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

  callLoadEquipments(BuildContext context) async {
    await loadEquipments(context).then((value) {
      if (value.data != null && value.data!.length > 0) {
        AppCache.sortFilterCacheDTO!.defaultEquipments = [];
        value.data!.forEach((element) {
          EquipmentDataDTO equipmentDataDTO = EquipmentDataDTO(
              equipmentId: element.equipmentId,
              equipmentName: element.equipmentName,
              isSelected: true);
          AppCache.sortFilterCacheDTO!.defaultEquipments!.add(equipmentDataDTO);
        });
        AppCache.sortFilterCacheDTO!.preferredEquipments =
            AppCache.sortFilterCacheDTO!.defaultEquipments![0];
      }
      callAlertCaseHistory(context);
    }).catchError((error) {
      Utils.printInfo(error);
      setState(() {
        this.isLoading = false;
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

  @override
  void initState() {
    super.initState();
    Utils.setFirebaseAnalyticsCurrentScreen(
        Constants.ANALYTICS_ALERT_CASE_HISTORY_SCREEN);
    if (AppCache.sortFilterCacheDTO != null &&
        Utils.isNotEmpty(AppCache.sortFilterCacheDTO!.preferredProjectId)) {
      if (AppCache.sortFilterCacheDTO!.preferredProjectId!.contains('<')) {
        List<String> splitedList =
            AppCache.sortFilterCacheDTO!.preferredProjectId!.split('<');
        AppCache.sortFilterCacheDTO!.defaultProjectId = splitedList[0];
        AppCache.sortFilterCacheDTO!.displayProjectName = splitedList[0];
        if (Utils.isNotEmpty(splitedList[1])) {
          AppCache.sortFilterCacheDTO!.defaultVersion = splitedList[1];
        } else {
          AppCache.sortFilterCacheDTO!.defaultVersion = 'Base';
        }
      }
      callAlertCaseHistory(context);
    } else {
      if (Utils.isNotEmpty(AppCache.sortFilterCacheDTO!.defaultProjectId)) {
        if (AppCache.sortFilterCacheDTO!.defaultEquipments == null ||
            AppCache.sortFilterCacheDTO!.defaultEquipments!.length == 0) {
          callLoadEquipments(context);
        } else if (AppCache.sortFilterCacheDTO!.preferredEquipments == null) {
          AppCache.sortFilterCacheDTO!.preferredEquipments =
              AppCache.sortFilterCacheDTO!.defaultEquipments![0];
        } else {
          callAlertCaseHistory(context);
        }
      } else {
        callLoadProjectList(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(AppColors.appBlue()),
                ),
              )
            : Stack(
                children: [
                  Container(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 16),
                                child: Text(
                                  Utils.getTranslated(
                                      context, 'alert_casehistory_appbar')!,
                                  style: AppFonts.robotoRegular(
                                    16,
                                    color: theme_dark!
                                        ? AppColors.appGrey2()
                                        : AppColorsLightMode.appGrey(),
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      if (this.alertCaseHistoryDataDTO.length >
                                          0) {
                                        final navResult =
                                            await Navigator.pushNamed(
                                          context,
                                          AppRoutes.searchRoute,
                                          arguments: SearchArguments(
                                            caseHistoryList:
                                                this.alertCaseHistoryDataDTO,
                                          ),
                                        );

                                        if (navResult != null &&
                                            navResult as bool) {
                                          Navigator.pop(context, true);
                                        }
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 12),
                                      child: Image.asset(
                                        theme_dark!
                                            ? Constants.ASSET_IMAGES +
                                                'search_icon.png'
                                            : Constants.ASSET_IMAGES_LIGHT +
                                                'search.png',
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 12),
                                    child: GestureDetector(
                                      onTap: () async {
                                        if (this.alertCaseHistoryDTO!.data !=
                                                null &&
                                            this
                                                    .alertCaseHistoryDTO!
                                                    .data!
                                                    .length >
                                                0) {
                                          final navResult = await Navigator.pushNamed(
                                              context,
                                              AppRoutes
                                                  .alertReviewDataFilterRoute,
                                              arguments: AlertFilterArguments(
                                                  filterAlertStatusList:
                                                      this.preferedStatusList,
                                                  fromWhere: 2,
                                                  filterAlertWorkflowList:
                                                      this.preferedWorkflowList,
                                                  filterAlertPriorityList: this
                                                      .preferedPriorityList));

                                          if (navResult != null &&
                                              navResult as bool) {
                                            List<String> selectedPriority = [];
                                            List<String> selectedStatus = [];

                                            List<String> selectedWorkflow = [];

                                            this
                                                .preferedStatusList
                                                .forEach((element) {
                                              if (element.isSelected!) {
                                                selectedStatus
                                                    .add(element.item!);
                                              }
                                            });
                                            this
                                                .preferedPriorityList
                                                .forEach((element) {
                                              if (element.isSelected!) {
                                                selectedPriority
                                                    .add(element.item!);
                                              }
                                            });
                                            this
                                                .preferedWorkflowList
                                                .forEach((element) {
                                              if (element.isSelected!) {
                                                selectedWorkflow
                                                    .add(element.item!);
                                              }
                                            });
                                            setState(() {
                                              this.alertCaseHistoryDataDTO =
                                                  this
                                                      .alertCaseHistoryDTO!
                                                      .data!
                                                      .where((e) =>
                                                          selectedPriority
                                                              .contains(
                                                                  e.priority) &&
                                                          selectedStatus
                                                              .contains(
                                                                  e.status) &&
                                                          selectedWorkflow
                                                              .contains(
                                                                  e.workFlow))
                                                      .toList();
                                            });
                                          }
                                        }
                                      },
                                      child: Image.asset(
                                        theme_dark!
                                            ? Constants.ASSET_IMAGES +
                                                'filter_icon.png'
                                            : Constants.ASSET_IMAGES_LIGHT +
                                                'filter_icon.png',
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 16),
                                    child: GestureDetector(
                                      onTap: () {
                                        if (this
                                                .alertCaseHistoryDataDTO
                                                .length >
                                            0) {
                                          showDownloadCSVPopup(context);
                                        }
                                      },
                                      child: Image.asset(
                                        theme_dark!
                                            ? Constants.ASSET_IMAGES +
                                                'download_bttn.png'
                                            : Constants.ASSET_IMAGES_LIGHT +
                                                'download_bttn.png',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 16),
                            child: analogSorting(context),
                          ),

                          // if (alertCaseHistoryDTO != null)
                          //   Column(
                          //     mainAxisAlignment: MainAxisAlignment.start,
                          //     crossAxisAlignment: CrossAxisAlignment.start,
                          //     children: alertCaseHistoryDataDTO
                          //         .map((e) => dataItem(context, e))
                          //         .toList(),
                          //   ),
                          this.alertCaseHistoryDataDTO.length > 0
                              ? Container(
                                  margin: EdgeInsets.only(top: 26.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: List<Widget>.generate(
                                            this
                                                        .alertCaseHistoryDataDTO
                                                        .length <
                                                    ((page * pageSize) +
                                                        pageSize)
                                                ? this
                                                    .alertCaseHistoryDataDTO
                                                    .length
                                                : ((page * pageSize) +
                                                    pageSize), (index) {
                                          return dataItem(
                                            context,
                                            alertCaseHistoryDataDTO[index],
                                          );
                                        }),
                                      ),
                                      SizedBox(height: 10.0),
                                      this.alertCaseHistoryDataDTO.length >
                                              ((page * pageSize) + pageSize)
                                          ? GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  this.page += 1;
                                                });
                                              },
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    Utils.getTranslated(
                                                        context, 'view_more')!,
                                                    style:
                                                        AppFonts.robotoMedium(
                                                      14,
                                                      color:
                                                          AppColors.appBlue(),
                                                      decoration:
                                                          TextDecoration.none,
                                                    ),
                                                  ),
                                                  SizedBox(width: 10.0),
                                                  Image.asset(
                                                      Constants.ASSET_IMAGES +
                                                          'view_more_icon.png'),
                                                ],
                                              ),
                                            )
                                          : Container(),
                                    ],
                                  ),
                                )
                              : Container(),
                          SizedBox(
                            height: 80,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: TextButton(
                      onPressed: () async {
                        final navigateResult = await Navigator.pushNamed(
                          context,
                          AppRoutes.sortAndFilterRoute,
                          arguments: SortFilterArguments(
                            menuType: Constants.HOME_MENU_ALERT,
                            currentTab: 1,
                          ),
                        );

                        if (navigateResult != null && navigateResult as bool) {
                          setState(() {
                            isLoading = true;
                          });
                          callAlertCaseHistory(context);
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
                            Image.asset(
                                Constants.ASSET_IMAGES + 'filter_icon.png'),
                            SizedBox(width: 10.0),
                            Text(
                              Utils.getTranslated(context, 'sort_and_filter')!,
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
              ));
  }

  void showDownloadCSVPopup(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext downloadContext) => CupertinoActionSheet(
        actions: [
          Container(
            color: theme_dark!
                ? AppColors.cupertinoBackground()
                : AppColorsLightMode.cupertinoBackground().withOpacity(0.8),
            child: CupertinoActionSheetAction(
              onPressed: () async {
                String curDate =
                    '#${DateFormat('yyyy.MM.dd').format(DateTime.now())}@${DateFormat('HH.mm.ss').format(DateTime.now())}';
                var object = [];
                String name = Utils.getExportFilename(
                  'Case History',
                  fromDate: DateFormat('yyyy-MM-dd')
                      .format(AppCache.sortFilterCacheDTO!.startDate!),
                  toDate: DateFormat('yyyy-MM-dd')
                      .format(AppCache.sortFilterCacheDTO!.endDate!),
                  currentDate: curDate,
                  expType: '.csv',
                );
                this.alertCaseHistoryDataDTO.forEach((e) {
                  object.add({
                    "ID": e.alertRowKey,
                    Utils.getTranslated(context, 'csv_equipment_name')!:
                        e.equipmentName,
                    Utils.getTranslated(context, 'csv_assginedTo')!:
                        e.assignedToName,
                    Utils.getTranslated(context, 'csv_status')!: e.status,
                    Utils.getTranslated(context, 'csv_priority')!: e.priority,
                    Utils.getTranslated(context, 'csv_workflow')!: e.workFlow,
                    Utils.getTranslated(context, 'csv_subject')!: e.subject,
                    Utils.getTranslated(context, 'csv_description')!:
                        e.description,
                    Utils.getTranslated(context, 'csv_message')!: e.event,
                    Utils.getTranslated(context, 'csv_createdon')!:
                        e.createdTimestamp,
                    Utils.getTranslated(context, 'csv_createdby')!:
                        e.createdByName,
                    Utils.getTranslated(context, 'csv_modifiedby')!:
                        e.modifiedByName,
                    Utils.getTranslated(context, 'csv_modifieddate')!:
                        e.modifiedTimestamp,
                    Utils.getTranslated(context, 'csv_alertdate')!: e.timestamp
                  });
                });
                final result = await CSVApi.generateCSV(object, name);
                Navigator.pop(downloadContext);
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

  getTagColor(tag) {
    if (tag == 'Critical' || tag == 'critical')
      return AppColors.appRedE9();
    else if (tag == 'High' || tag == 'high')
      return AppColors.appRedE9();
    else if (tag == 'Medium' || tag == 'medium')
      return AppColors.appPrimaryOrange();
    else if (tag == 'Low' || tag == 'medium')
      return AppColors.appPrimaryYellow();
    else if (tag == "None" || tag == 'none')
      return AppColors.appGreen60();
    else
      return Colors.transparent;
  }

  pushRoutebySender(
      BuildContext ctx, String? sender, AlertCaseHistoryDataDTO data) {
    if (sender == "DUTPatLimitRecommendation") {
      Navigator.pushNamed(context, AppRoutes.casehistoryPatRecommend,
          arguments: AlertArguments(
            appBarTitle: Utils.getTranslated(context,
                'senderPATRecommendation')!, //Utils.getTranslated(context, 'alert_information'),
            caseHistoryData: data,
          ));
    } else if (sender == "DUTLimitChangeAnomaly") {
      Navigator.pushNamed(context, AppRoutes.casehistoryLimitChangeAnomaly,
          arguments: AlertArguments(
            appBarTitle: Utils.getTranslated(context,
                'senderLimitChangeAnomaly')!, //Utils.getTranslated(context, 'alert_information'),
            caseHistoryData: data,
          ));
    } else if (sender == "ConsecutiveTestFailure") {
      AppCache.sortFilterCacheDTO!.preferredCompany = data.companyId!;
      AppCache.sortFilterCacheDTO!.preferredSite = data.siteId!;
      AppCache.sortFilterCacheDTO!.preferredProjectId = data.projectId;
      AppCache.sortFilterCacheDTO!.startDate =
          DateFormat("yyyy-MM-dd").parse(data.startDate!);
      AppCache.sortFilterCacheDTO!.endDate =
          DateFormat("yyyy-MM-dd").parse(data.endDate!);
      Navigator.pop(ctx, true);
    } else if (sender == "DUTCpkAlertAnomalies") {
      Navigator.pushNamed(context, AppRoutes.alertCPKDetails,
          arguments: AlertArguments(
            appBarTitle: Utils.getTranslated(context,
                'senderCPKInformation')!, //Utils.getTranslated(context, 'alert_information'),
            caseHistoryData: data,
          ));
    } else if (sender == "DUTDegradationAnomaly" ||
        sender == "DUTComponentAnomaly") {
      Navigator.pushNamed(context, AppRoutes.casehistoryDegradationAnomaly,
          arguments: AlertArguments(
            appBarTitle: Utils.getTranslated(context,
                'senderDegradationAnomaly')!, //Utils.getTranslated(context, 'alert_information'),
            caseHistoryData: data,
          ));
    } else if (sender == Constants.ALERT_PAT_LIMIT_ANOMALIES) {
      Navigator.pushNamed(context, AppRoutes.alertPatAnomaliesRoute,
          arguments: AlertArguments(
            caseHistoryData: data,
          ));
    } else {
      Navigator.pushNamed(context, AppRoutes.casehistoryOthers,
          arguments: AlertArguments(
            appBarTitle: Utils.getTranslated(context,
                'senderOthers')!, //Utils.getTranslated(context, 'alert_information'),
            caseHistoryData: data,
          ));
    }
  }

  Widget dataItem(BuildContext ctx, AlertCaseHistoryDataDTO e) {
    String startDate = '-';
    String endDate = '-';
    if (e.startDate != null) {
      startDate =
          DateFormat('d MMM yyy HH:mm:ss').format(DateTime.parse(e.startDate!));
    }
    if (e.endDate != null) {
      endDate =
          DateFormat('d MMM yyy HH:mm:ss').format(DateTime.parse(e.endDate!));
    }

    return GestureDetector(
      onTap: () {
        // e.priority == 'Critical'
        //     ? Navigator.pushNamed(context, AppRoutes.alertCPKDetails,
        //         arguments: AlertPageTitle(
        //           title: Utils.getTranslated(context, 'alert_information'),
        //         ))
        //     : null;

        pushRoutebySender(ctx, e.sender, e);
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(12, 13, 9, 12),
        margin: EdgeInsets.fromLTRB(16, 0, 16, 12),
        color: theme_dark!
            ? AppColors.appBlackLight()
            : AppColorsLightMode.appGreyBA(),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  height: 20,
                  padding: EdgeInsets.only(top: 3, right: 10, left: 10),
                  decoration: BoxDecoration(
                      color: getTagColor(e.priority!),
                      borderRadius: BorderRadius.circular(2)),
                  child: Text(
                    e.priority!,
                    style: AppFonts.robotoMedium(
                      12,
                      color: theme_dark!
                          ? AppColors.appGreyDE()
                          : AppColors.appPrimaryWhite(),
                      decoration: TextDecoration.none,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

              Container(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 171.5,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Utils.getTranslated(context, 'alert_starttime')!,
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
                              startDate,
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
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Utils.getTranslated(context, 'alert_endtime')!,
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
                            endDate,
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
                    ]),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 171.5,
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
                            SizedBox(
                              height: 6,
                            ),
                            Text(
                              e.equipmentName != null ? e.equipmentName! : '-',
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
                      Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Utils.getTranslated(context, 'alert_workflow')!,
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
                              e.workFlow!,
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
                height: 20,
              ),
              Container(
                margin: EdgeInsets.only(right: 35),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Utils.getTranslated(context, 'alert_sortby_alertid')!,
                      // Utils.getTranslated(context, 'alert_subject')!,
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
                      e.alertIdName != null ? e.alertIdName! : '-',
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
              SizedBox(
                height: 20,
              ),
              Container(
                margin: EdgeInsets.only(right: 35),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Utils.getTranslated(context, 'alert_subject')!,
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
                      e.subject != null ? e.subject! : '-',
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
              SizedBox(
                height: 20,
              ),
              //project
              Container(
                margin: EdgeInsets.only(right: 35),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Utils.getTranslated(context, 'alert_description')!,
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
                      e.description != null ? e.description! : '-',
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

              SizedBox(
                height: 20,
              ),

              Container(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Utils.getTranslated(context, 'alert_assignedto')!,
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
                        e.assignedTo != null ? e.assignedTo! : '-',
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
              SizedBox(
                height: 20,
              ),

              Container(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Utils.getTranslated(context, 'case_message')!,

                        // Utils.getTranslated(context, 'alert_assignedto')!,
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
                        e.event != null ? e.event! : '-',
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
    );
  }

  Widget analogSorting(BuildContext ctx) {
    if (this.alertCaseHistoryDataDTO.length > 0) {
      return Container(
        margin: EdgeInsets.only(top: 26.0),
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
                  sortBy = Utils.getTranslated(context, 'alert_alertid')!;
                  this.sortType = Constants.SORT_BY_ID;
                  sortAnalogCpkList();
                });
                Navigator.pop(popContext);
              },
              child: Text(
                Utils.getTranslated(context, 'alert_alertid')!,
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
                  sortBy = Utils.getTranslated(context, 'alert_equipment')!;
                  // Utils.getTranslated(
                  //     context, 'dqm_testresult_analog_sortby_type')!;
                  this.sortType = Constants.SORT_BY_EQ;
                  sortAnalogCpkList();
                });
                Navigator.pop(popContext);
              },
              child: Text(
                Utils.getTranslated(context, 'alert_equipment')!,
                // Utils.getTranslated(
                //     context, 'dqm_testresult_analog_sortby_type')!,
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
          // Container(
          //   color: theme_dark!
          //       ? AppColors.cupertinoBackground()
          //       : AppColorsLightMode.cupertinoBackground().withOpacity(0.8),
          // //   child: CupertinoActionSheetAction(
          //     onPressed: () {
          //       setState(() {
          //         sortBy = 'Assigned To';

          //         // Utils.getTranslated(
          //         //     context, 'dqm_testresult_analog_sortby_testname')!;
          //         this.sortType = Constants.SORT_BY_AssignedTo;
          //         sortAnalogCpkList();
          //       });
          //       Navigator.pop(popContext);
          //     },
          //     child: Text(
          //       'Assigned To',
          //       // Utils.getTranslated(
          //       //     context, 'dqm_testresult_analog_sortby_testname')!,
          //       style: AppFonts.robotoRegular(
          //         15,
          // //         color: theme_dark!
          //       ? AppColors.appPrimaryWhite().withOpacity(0.8)
          //       : AppColorsLightMode.appGrey(),
          //         decoration: TextDecoration.none,
          //       ),
          //       textAlign: TextAlign.center,
          //     ),
          //   ),
          // ),

          Container(
            color: theme_dark!
                ? AppColors.cupertinoBackground()
                : AppColorsLightMode.cupertinoBackground().withOpacity(0.8),
            child: CupertinoActionSheetAction(
              onPressed: () {
                setState(() {
                  sortBy = Utils.getTranslated(context, 'alert_status')!;
                  // Utils.getTranslated(
                  //     context, 'dqm_testresult_analog_sortby_cpk')!;
                  this.sortType = Constants.SORT_BY_STATUS;
                  sortAnalogCpkList();
                });
                Navigator.pop(popContext);
              },
              child: Text(
                Utils.getTranslated(context, 'alert_status')!,
                // Utils.getTranslated(
                //     context, 'dqm_testresult_analog_sortby_cpk')!,
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
                  sortBy = Utils.getTranslated(context, 'case_priority')!;
                  // Utils.getTranslated(
                  //     context, 'dqm_testresult_analog_sortby_nominal')!;
                  this.sortType = Constants.SORT_BY_PRIORITY;
                  sortAnalogCpkList();
                });
                Navigator.pop(popContext);
              },
              child: Text(
                Utils.getTranslated(context, 'case_priority')!,
                // Utils.getTranslated(
                //     context, 'dqm_testresult_analog_sortby_nominal')!,
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
                  sortBy = Utils.getTranslated(context, 'case_workflow')!;
                  // Utils.getTranslated(
                  //     context, 'dqm_testresult_analog_sortby_lower_limit')!;
                  this.sortType = Constants.SORT_BY_WORKFLOW;
                  sortAnalogCpkList();
                });
                Navigator.pop(popContext);
              },
              child: Text(
                Utils.getTranslated(context, 'case_workflow')!,
                // Utils.getTranslated(
                //     context, 'dqm_testresult_analog_sortby_lower_limit')!,
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
                  sortBy = Utils.getTranslated(context, 'case_message')!;
                  // Utils.getTranslated(
                  //     context, 'dqm_testresult_analog_sortby_upper_limit')!;
                  this.sortType = Constants.SORT_BY_MESSAGE;
                  sortAnalogCpkList();
                });
                Navigator.pop(popContext);
              },
              child: Text(
                Utils.getTranslated(context, 'case_message')!,
                // Utils.getTranslated(
                //     context, 'dqm_testresult_analog_sortby_upper_limit')!,
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
                  sortAnalogCpkList();
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
                  sortAnalogCpkList();
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
}
