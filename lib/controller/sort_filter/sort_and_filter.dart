import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:keysight_pma/cache/appcache.dart';
import 'package:keysight_pma/const/appcolors.dart';
import 'package:keysight_pma/const/appfonts.dart';
import 'package:keysight_pma/const/constants.dart';
import 'package:keysight_pma/const/utils.dart';
import 'package:keysight_pma/controller/admin/preferred_setting/custom.dart';
import 'package:keysight_pma/controller/sort_filter/calendar/calendar_popup_view.dart';
import 'package:keysight_pma/dio/api/sort_filter.dart';
import 'package:keysight_pma/model/customize.dart';
import 'package:keysight_pma/model/sortAndFilter/company.dart';
import 'package:keysight_pma/model/sortAndFilter/equipment.dart';
import 'package:keysight_pma/model/sortAndFilter/project_version_by_category.dart';
import 'package:keysight_pma/model/sortAndFilter/projects.dart';
import 'package:keysight_pma/model/sortAndFilter/sites.dart';
import 'package:keysight_pma/routes/approutes.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';

class SortAndFilterScreen extends StatefulWidget {
  final String? menuType;
  final int? currentTab;

  SortAndFilterScreen({Key? key, this.menuType, this.currentTab})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SortAndFilterScreen();
  }
}

class _SortAndFilterScreen extends State<SortAndFilterScreen> {
  List<CustomDTO> companyDatalist = [];
  List<CustomDTO> siteDataList = [];
  List<ProjectVersionDataDTO> projectVersionList = [];
  String snfProjectName = '';
  String equipmentNameList = '';
  String singleEquipmentName = '';
  String selectedSiteId = '';
  String selectedProjectId = '';
  bool? theme_dark = AppCache.sortFilterCacheDTO!.currentTheme;
  List<PDate> dateFilterList = [
    PDate(rangeName: "Alert Date", rangeValue: 'alertDate', isSelected: false),
    PDate(
        rangeName: "Case Created Date",
        rangeValue: 'caseCreateDate',
        isSelected: false),
    PDate(
        rangeName: "Case Modified Date",
        rangeValue: 'caseModifiedDate',
        isSelected: false),
  ];
  Future<CompanyDTO> loadCompanys(BuildContext ctx) {
    SortFilterApi sortFilterApi = SortFilterApi(ctx);
    return sortFilterApi.loadCompanys();
  }

  Future<SiteDTO> loadSites(BuildContext ctx, String companyId) {
    SortFilterApi sortFilterApi = SortFilterApi(ctx);
    return sortFilterApi.loadSites(companyId);
  }

  Future<ProjectsDTO> loadProjectList(
      BuildContext ctx, String companyId, String siteId) {
    SortFilterApi sortFilterApi = SortFilterApi(ctx);
    return sortFilterApi.loadProjectList(companyId, siteId);
  }

  Future<ProjectVersionByCategoryDTO> loadProjectVersionByCategory(
      BuildContext ctx, String companyId, String siteId, String projectId) {
    SortFilterApi sortFilterApi = SortFilterApi(ctx);
    return sortFilterApi.loadProjectVersionByCategory(
        companyId, siteId, projectId);
  }

  Future<EquipmentDTO> loadEquipments(BuildContext context) {
    SortFilterApi sortFilterApi = SortFilterApi(context);
    return sortFilterApi.loadEquipments(
        AppCache.sortFilterCacheDTO!.preferredCompany!,
        AppCache.sortFilterCacheDTO!.preferredSite!);
  }

  @override
  void initState() {
    super.initState();
    FirebaseAnalytics.instance
        .setCurrentScreen(screenName: Constants.ANALYTICS_SORT_FILTER_SCREEN);
    setState(() {
      if (AppCache.sortFilterCacheDTO != null) {
        if (Utils.isNotEmpty(AppCache.sortFilterCacheDTO!.preferredSite)) {
          this.selectedSiteId = AppCache.sortFilterCacheDTO!.preferredSite!;
        }
        if (Utils.isNotEmpty(AppCache.sortFilterCacheDTO!.preferredProjectId)) {
          this.selectedProjectId =
              AppCache.sortFilterCacheDTO!.preferredProjectId!;
        }
        if (AppCache.sortFilterCacheDTO!.defaultEquipments != null &&
            AppCache.sortFilterCacheDTO!.defaultEquipments!.length > 0) {
          this.equipmentNameList = AppCache
              .sortFilterCacheDTO!.defaultEquipments!
              .where((element) => element.isSelected!)
              .map((e) => e.equipmentName)
              .toList()
              .join('\n');
        }
        if (AppCache.sortFilterCacheDTO!.casehistorydatetype == null) {
          AppCache.sortFilterCacheDTO!.casehistorydatetype = "alertDate";
        }
        if (widget.menuType == Constants.HOME_MENU_ALERT &&
            widget.currentTab != 0) {
          dateFilterList.forEach(
            (element) {
              if (element.rangeValue ==
                  AppCache.sortFilterCacheDTO!.casehistorydatetype!) {
                setState(() {
                  element.isSelected = true;
                });
              }
            },
          );
        }

        callSortFilterData();
      }
    });
  }

  @override
  void dispose() {
    if (EasyLoading.isShow) {
      EasyLoading.dismiss();
    }
    super.dispose();
  }

  callSortFilterData() async {
    EasyLoading.show(maskType: EasyLoadingMaskType.black);
    await loadCompanys(context).then((value) {
      if (value.status!.statusCode == 200) {
        if (value.data != null && value.data!.length > 0) {
          value.data!.forEach((element) {
            CustomDTO companyCustomDTO = CustomDTO(
                displayName: element.companyName, value: element.companyId);
            companyDatalist.add(companyCustomDTO);
          });

          if (companyDatalist.length > 0) {
            companyDatalist.sort((a, b) {
              return a.displayName!
                  .toLowerCase()
                  .compareTo(b.displayName!.toLowerCase());
            });
          }
        }
        callLoadSites(context);
        loadEquipments(context);
      } else {
        EasyLoading.dismiss();
      }
    }).catchError((error) {
      EasyLoading.dismiss();
    });
  }

  callLoadSites(BuildContext context) async {
    await loadSites(context, AppCache.sortFilterCacheDTO!.preferredCompany!)
        .then((value) {
      EasyLoading.dismiss();
      if (value.status!.statusCode == 200) {
        if (value.data != null && value.data!.length > 0) {
          siteDataList.clear();
          value.data!.forEach((element) {
            CustomDTO siteCustomDTO =
                CustomDTO(displayName: element.siteName, value: element.siteId);
            siteDataList.add(siteCustomDTO);
          });
        }

        if (siteDataList.length > 0) {
          siteDataList.sort((a, b) {
            return a.displayName!
                .toLowerCase()
                .compareTo(b.displayName!.toLowerCase());
          });
        }

        if (!Utils.isNotEmpty(this.selectedSiteId)) {
          this.selectedSiteId = siteDataList[0].value!;
          AppCache.sortFilterCacheDTO!.preferredSite = siteDataList[0].value!;
        }

        if (Utils.isNotEmpty(widget.menuType) &&
            widget.menuType == Constants.HOME_MENU_DQM) {
          if (widget.currentTab == 2) {
            callLoadProjectList(context);
          }
        }

        // if (Utils.isNotEmpty(widget.menuType) &&
        //     widget.menuType == Constants.HOME_MENU_DQM) {
        //   if (widget.currentTab == 2) {
        //     callLoadProjectList(context);
        //     // callLoadProjectVersion(context);
        //   } else {
        //     setState(() {});
        //   }
        // } else

        if (Utils.isNotEmpty(widget.menuType) &&
            widget.menuType == Constants.HOME_MENU_ALERT) {
          if (widget.currentTab == 0) {
            callLoadProjectVersion(context);
          } else {
            callLoadProjectVersion(context);
          }
        } else {
          setState(() {});
        }
      } else {
        EasyLoading.dismiss();
      }
    }).catchError((error) {
      EasyLoading.dismiss();
    });
  }

  callLoadProjectList(BuildContext context) async {
    await loadProjectList(
            context,
            AppCache.sortFilterCacheDTO!.preferredCompany!,
            AppCache.sortFilterCacheDTO!.preferredSite!)
        .then((value) {
      if (value.data != null && value.data!.length > 0) {
        List<ProjectDataDTO> preferedProjectList =
            value.data!.where((element) => element.isPreferred = true).toList();
        List<ProjectDataDTO> notPreferedProjectList = value.data!
            .where((element) => element.isPreferred = false)
            .toList();
        preferedProjectList.sort((a, b) {
          return a.projectId!.compareTo(b.projectId!);
        });
        notPreferedProjectList.sort((a, b) {
          return a.projectId!.compareTo(b.projectId!);
        });

        ProjectDataDTO? projectDataDTO;
        if (preferedProjectList.length > 0) {
          projectDataDTO = preferedProjectList[0];
        } else {
          projectDataDTO = notPreferedProjectList[0];
        }

        AppCache.sortFilterCacheDTO!.defaultProjectId =
            projectDataDTO.projectId!;
        AppCache.sortFilterCacheDTO!.displayProjectName =
            Utils.isNotEmpty(projectDataDTO.projectName)
                ? '${projectDataDTO.projectName} (${projectDataDTO.projectId})'
                : projectDataDTO.projectId!;

        callLoadProjectVersion(context);
      }
    }).catchError((error) {
      Utils.printInfo(error);
    }).whenComplete(() {
      setState(() {
        if (EasyLoading.isShow) {
          EasyLoading.dismiss();
        }
      });
    });
  }

  callLoadProjectVersion(BuildContext context) async {
    await loadProjectVersionByCategory(
            context,
            AppCache.sortFilterCacheDTO!.preferredCompany!,
            AppCache.sortFilterCacheDTO!.preferredSite!,
            AppCache.sortFilterCacheDTO!.defaultProjectId!)
        .then((value) {
      this.projectVersionList.clear();
      if (value.data != null && value.data!.length > 0) {
        value.data!.forEach((element) {
          if (element.version == "Base") {
            this.projectVersionList.insert(0, element);
          } else {
            this.projectVersionList.add(element);
          }
        });

        if (!Utils.isNotEmpty(AppCache.sortFilterCacheDTO!.defaultVersion)) {
          AppCache.sortFilterCacheDTO!.defaultVersion =
              this.projectVersionList[0].version;
          AppCache.sortFilterCacheDTO!.projectVersionObj =
              this.projectVersionList[0];
        }
      }
    }).catchError((error) {
      Utils.printInfo(error);
    }).whenComplete(() {
      setState(() {
        EasyLoading.dismiss();
      });
    });
  }

  callLoadProjectAndEquipments(BuildContext context) async {
    await loadProjectList(
            context,
            AppCache.sortFilterCacheDTO!.preferredCompany!,
            AppCache.sortFilterCacheDTO!.preferredSite!)
        .then((value) async {
      if (value.status!.statusCode == 200) {
        if (value.data != null && value.data!.length > 0) {
          List<ProjectDataDTO> preferedProjectList = value.data!
              .where((element) => element.isPreferred = true)
              .toList();
          List<ProjectDataDTO> notPreferedProjectList = value.data!
              .where((element) => element.isPreferred = false)
              .toList();
          preferedProjectList.sort((a, b) {
            return a.projectId!.compareTo(b.projectId!);
          });
          notPreferedProjectList.sort((a, b) {
            return a.projectId!.compareTo(b.projectId!);
          });

          ProjectDataDTO? projectDataDTO;
          if (preferedProjectList.length > 0) {
            projectDataDTO = preferedProjectList[0];
          } else {
            projectDataDTO = notPreferedProjectList[0];
          }

          AppCache.sortFilterCacheDTO!.defaultProjectId =
              projectDataDTO.projectId!;
          AppCache.sortFilterCacheDTO!.displayProjectName = Utils.isNotEmpty(
                  projectDataDTO.projectName)
              ? '${projectDataDTO.projectName} (${projectDataDTO.projectId})'
              : projectDataDTO.projectId!;

          await loadProjectVersionByCategory(
                  context,
                  AppCache.sortFilterCacheDTO!.preferredCompany!,
                  AppCache.sortFilterCacheDTO!.preferredSite!,
                  AppCache.sortFilterCacheDTO!.defaultProjectId!)
              .then((value) async {
            if (value.status!.statusCode == 200) {
              this.projectVersionList.clear();
              if (value.data != null && value.data!.length > 0) {
                value.data!.forEach((element) {
                  if (element.version == "Base") {
                    this.projectVersionList.insert(0, element);
                  } else {
                    this.projectVersionList.add(element);
                  }
                });

                if (!Utils.isNotEmpty(
                    AppCache.sortFilterCacheDTO!.defaultVersion)) {
                  AppCache.sortFilterCacheDTO!.defaultVersion =
                      this.projectVersionList[0].version;
                  AppCache.sortFilterCacheDTO!.projectVersionObj =
                      this.projectVersionList[0];
                }
              }

              await loadEquipments(context).then((value) {
                if (value.status!.statusCode == 200) {
                  this.equipmentNameList = '';
                  if (value.data != null && value.data!.length > 0) {
                    List<EquipmentDataDTO> tempEquipmentList = [];
                    value.data!.forEach((element) {
                      element.isSelected = true;
                      tempEquipmentList.add(element);
                    });
                    AppCache.sortFilterCacheDTO!.preferredEquipments =
                        tempEquipmentList[0];
                    AppCache.sortFilterCacheDTO!.defaultEquipments =
                        tempEquipmentList;
                    this.equipmentNameList = value.data!
                        .map((e) => e.equipmentName)
                        .toList()
                        .join('\n');
                  }
                }
              }).catchError((error) {
                Utils.printInfo(error);
              }).whenComplete(() {
                setState(() {
                  EasyLoading.dismiss();
                });
              });
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
          });
        } else {
          setState(() {
            if (EasyLoading.isShow) {
              EasyLoading.dismiss();
            }
          });
        }
      } else {
        setState(() {
          if (EasyLoading.isShow) {
            EasyLoading.dismiss();
          }
        });
      }
    }).catchError((error) {
      Utils.printInfo(error);
      setState(() {
        if (EasyLoading.isShow) {
          EasyLoading.dismiss();
        }
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
            Utils.getTranslated(context, 'sort_and_filter_appbar_text')!,
            style: AppFonts.robotoRegular(
              20,
              color: theme_dark!
                  ? AppColors.appGrey()
                  : AppColorsLightMode.appGrey(),
              decoration: TextDecoration.none,
            ),
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              if (AppCache.sortFilterCacheDTO!.preferredCompany == null ||
                  AppCache.sortFilterCacheDTO!.preferredSite == null ||
                  AppCache.sortFilterCacheDTO!.startDate == null ||
                  AppCache.sortFilterCacheDTO!.endDate == null) {
                Utils.showAlertDialog(
                    context, "Info", "Please select sort and filter data");
              } else {
                Navigator.pop(context);
              }
            },
            child: Image.asset(theme_dark!
                ? Constants.ASSET_IMAGES + 'close_bttn.png'
                : Constants.ASSET_IMAGES_LIGHT + 'close_icon.png'),
          )
        ],
      ),
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 21.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      dateRange(context),
                      company(context),
                      site(context),
                      (widget.menuType == Constants.HOME_MENU_ALERT &&
                              widget.currentTab != 0)
                          ? dateFilter(context)
                          : Container(),
                      project(context),
                      version(context),
                      equipment(context),
                    ],
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(left: 90.0, right: 90.0),
                padding: EdgeInsets.only(top: 14.0),
                child: GestureDetector(
                  onTap: () {
                    if (widget.menuType == Constants.HOME_MENU_DQM) {
                      if (!Utils.isNotEmpty(this.selectedSiteId)) {
                        Utils.showAlertDialog(
                            context,
                            Utils.getTranslated(
                                context, 'alert_dialog_info_title')!,
                            Utils.getTranslated(
                                context, 'alert_dialog_siteid_required_msg')!);
                      } else {
                        Navigator.pop(context, true);
                      }
                    } else if (widget.menuType == Constants.HOME_MENU_ALERT &&
                        widget.currentTab != 0) {
                      PDate newDateFilter = dateFilterList
                          .where((element) => element.isSelected!)
                          .first;
                      AppCache.sortFilterCacheDTO!.casehistorydatetype =
                          newDateFilter.rangeValue!;
                      Navigator.pop(context, true);
                    } else if (widget.menuType == Constants.HOME_MENU_OEE) {
                      Navigator.pop(context, true);
                    } else {
                      Navigator.pop(context, true);
                    }

                    // if (widget.menuType == Constants.HOME_MENU_ALERT &&
                    //     widget.currentTab != 0) {
                    //   PDate newDateFilter = dateFilterList
                    //       .where((element) => element.isSelected!)
                    //       .first;
                    //   AppCache.sortFilterCacheDTO!.casehistorydatetype =
                    //       newDateFilter.rangeValue!;
                    // }
                    // if (widget.menuType == Constants.HOME_MENU_DQM &&
                    //     widget.currentTab == 2) {
                    //   if (Utils.isNotEmpty(
                    //       AppCache.sortFilterCacheDTO!.defaultVersion)) {
                    //     Navigator.pop(context, true);
                    //   } else {
                    //     Utils.showAlertDialog(
                    //         context,
                    //         Utils.getTranslated(
                    //             context, 'alert_dialog_info_title')!,
                    //         Utils.getTranslated(
                    //             context, 'alert_dialog_version_required_msg')!);
                    //   }
                    // } else {
                    //   Navigator.pop(context, true);
                    // }
                  },
                  child: Container(
                    padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                    decoration: BoxDecoration(
                        color: AppColors.appPrimaryYellow(),
                        border: Border.all(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(2.0)),
                    child: Text(
                      Utils.getTranslated(
                          context, 'sort_and_filter_filter_btn')!,
                      style: AppFonts.robotoMedium(
                        15,
                        color: AppColors.appPrimaryWhite(),
                        decoration: TextDecoration.none,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.start,
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     Expanded(
                //       child: GestureDetector(
                //         onTap: () {
                //           setState(() {
                //             AppCache.sortFilterCacheDTO!.startDate =
                //                 AppCache.sortFilterCacheDTO!.preferredStartDate;
                //             AppCache.sortFilterCacheDTO!.endDate =
                //                 AppCache.sortFilterCacheDTO!.preferredEndDate;
                //           });
                //         },
                //         child: Container(
                //           padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                //           decoration: BoxDecoration(
                //               color: Colors.transparent,
                //               border: Border.all(
                //                 color: theme_dark!
                //                     ? AppColors.appGreyD3()
                //                     : AppColorsLightMode.appPrimaryYellow(),
                //               ),
                //               borderRadius: BorderRadius.circular(2.0)),
                //           child: Text(
                //             Utils.getTranslated(
                //                 context, 'sort_and_filter_clear_btn')!,
                //             style: AppFonts.robotoMedium(
                //               15,
                //               color: theme_dark!
                //                   ? AppColors.appPrimaryWhite()
                //                   : AppColorsLightMode.appPrimaryYellow(),
                //               decoration: TextDecoration.none,
                //             ),
                //             textAlign: TextAlign.center,
                //           ),
                //         ),
                //       ),
                //     ),
                //     SizedBox(width: 16.0),
                //     Expanded(
                //       child: GestureDetector(
                //         onTap: () {
                //           if (widget.menuType == Constants.HOME_MENU_ALERT &&
                //               widget.currentTab != 0) {
                //             PDate newDateFilter = dateFilterList
                //                 .where((element) => element.isSelected!)
                //                 .first;
                //             AppCache.sortFilterCacheDTO!.casehistorydatetype =
                //                 newDateFilter.rangeValue!;
                //           }
                //           if (widget.menuType == Constants.HOME_MENU_DQM &&
                //               widget.currentTab == 2) {
                //             if (Utils.isNotEmpty(
                //                 AppCache.sortFilterCacheDTO!.defaultVersion)) {
                //               Navigator.pop(context, true);
                //             } else {
                //               Utils.showAlertDialog(
                //                   context, 'Info', 'Please select version');
                //             }
                //           } else {
                //             Navigator.pop(context, true);
                //           }
                //         },
                //         child: Container(
                //           padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                //           decoration: BoxDecoration(
                //               color: AppColors.appPrimaryYellow(),
                //               border: Border.all(color: Colors.transparent),
                //               borderRadius: BorderRadius.circular(2.0)),
                //           child: Text(
                //             Utils.getTranslated(
                //                 context, 'sort_and_filter_filter_btn')!,
                //             style: AppFonts.robotoMedium(
                //               15,
                //               color: AppColors.appPrimaryWhite(),
                //               decoration: TextDecoration.none,
                //             ),
                //             textAlign: TextAlign.center,
                //           ),
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  dateFilter(BuildContext ctx) {
    return Container(
      margin: EdgeInsets.only(top: 22.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Utils.getTranslated(context, 'sort_and_filter_datetype')!,
            style: AppFonts.robotoRegular(
              16,
              color: theme_dark!
                  ? AppColors.appGrey2()
                  : AppColorsLightMode.appGrey(),
              decoration: TextDecoration.none,
            ),
          ),
          SizedBox(height: 8.0),
          Wrap(
            children: dateFilterList.map((e) => dataItem(ctx, e)).toList(),
          ),
          divider(ctx)
        ],
      ),
    );
  }

  Widget dataItem(ctx, PDate e) {
    return GestureDetector(
      onTap: () {
        setState(() {
          dateFilterList.forEach((element) {
            element.isSelected = false;
          });
          e.isSelected = true;
        });
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(12.0, 9.0, 12.0, 9.0),
        margin: EdgeInsets.only(right: 14.0, top: 14.0),
        decoration: BoxDecoration(
          color: (e.isSelected!) ? AppColors.appTeal() : Colors.transparent,
          border: (e.isSelected!)
              ? Border.all(color: Colors.transparent)
              : Border.all(color: AppColors.appTeal()),
          borderRadius: BorderRadius.circular(50.0),
        ),
        child: Text(
          e.rangeName!,
          style: AppFonts.robotoMedium(
            14,
            color: (e.isSelected!)
                ? AppColors.appPrimaryWhite()
                : AppColors.appTeal(),
            decoration: TextDecoration.none,
          ),
        ),
      ),
    );
  }

  Widget dateRange(BuildContext ctx) {
    return Container(
      margin: EdgeInsets.only(top: 22.0),
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
                  Utils.getTranslated(ctx, 'sort_and_filter_daterange')!,
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
                onTap: () async {
                  FocusScope.of(ctx).requestFocus(FocusNode());
                  showCalendarDialog(ctx);
                  // List<DateTime>? dateTimeList =
                  //     await showOmniDateTimeRangePicker(
                  //   context: ctx,
                  //   type: OmniDateTimePickerType.date,
                  //   primaryColor: Colors.cyan,
                  //   backgroundColor: theme_dark!
                  //       ? Colors.grey[900]
                  //       : AppColors.appPrimaryWhite(),
                  //   calendarTextColor: theme_dark!
                  //       ? Colors.white
                  //       : AppColors.appPrimaryBlack(),
                  //   tabTextColor: theme_dark!
                  //       ? Colors.white
                  //       : AppColors.appPrimaryBlack(),
                  //   unselectedTabBackgroundColor: Colors.grey[700],
                  //   buttonTextColor: theme_dark!
                  //       ? Colors.white
                  //       : AppColors.appPrimaryBlack(),
                  //   timeSpinnerTextStyle: TextStyle(
                  //       color: theme_dark!
                  //           ? Colors.white
                  //           : AppColors.appPrimaryBlack(),
                  //       fontSize: 18),
                  //   timeSpinnerHighlightedTextStyle: TextStyle(
                  //       color: theme_dark!
                  //           ? Colors.white
                  //           : AppColors.appPrimaryBlack(),
                  //       fontSize: 24),
                  //   is24HourMode: false,
                  //   isShowSeconds: false,
                  //   startInitialDate: AppCache.sortFilterCacheDTO!.startDate,
                  //   startFirstDate:
                  //       DateTime(1600).subtract(const Duration(days: 3652)),
                  //   startLastDate: DateTime.now().add(
                  //     const Duration(days: 3652),
                  //   ),
                  //   endInitialDate: AppCache.sortFilterCacheDTO!.endDate,
                  //   endFirstDate:
                  //       DateTime(1600).subtract(const Duration(days: 3652)),
                  //   endLastDate: DateTime.now().add(
                  //     const Duration(days: 3652),
                  //   ),
                  //   borderRadius: const Radius.circular(16),
                  // );
                  // print(dateTimeList);
                  // if (dateTimeList != null) {
                  //   if (dateTimeList[0].isAfter(dateTimeList[1])) {
                  //     Utils.showAlertDialog(
                  //         ctx,
                  //         Utils.getTranslated(ctx, 'invalid_date_range')!,
                  //         Utils.getTranslated(
                  //             context, 'please_select_valid_date')!);
                  //   } else {
                  //     setState(() {
                  //       AppCache.sortFilterCacheDTO!.startDate =
                  //           dateTimeList[0];
                  //       AppCache.sortFilterCacheDTO!.endDate = dateTimeList[1];
                  //     });
                  //   }
                  // }
                },
                child: Container(
                  margin: EdgeInsets.only(right: 12.0),
                  child: Image.asset(theme_dark!
                      ? Constants.ASSET_IMAGES + 'date_icon.png'
                      : Constants.ASSET_IMAGES_LIGHT + 'calendar.png'),
                ),
              ),
            ],
          ),
          SizedBox(height: 13.0),
          Text(
            (AppCache.sortFilterCacheDTO!.startDate != null &&
                    AppCache.sortFilterCacheDTO!.endDate != null)
                ? '${DateFormat("MMM dd, yy").format(AppCache.sortFilterCacheDTO!.startDate!)} - ${DateFormat("MMM dd, yy").format(AppCache.sortFilterCacheDTO!.endDate!)}'
                : '',
            style: AppFonts.robotoRegular(
              16,
              color: theme_dark!
                  ? AppColors.appGrey2()
                  : AppColorsLightMode.appGrey(),
              decoration: TextDecoration.none,
            ),
          ),
          divider(ctx),
        ],
      ),
    );
  }

  Widget company(BuildContext ctx) {
    if (Utils.isNotEmpty(widget.menuType)) {
      if (widget.menuType == Constants.HOME_MENU_DQM) {
        return Container(
          margin: EdgeInsets.only(top: 22.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                Utils.getTranslated(ctx, 'sort_and_filter_company')!,
                style: AppFonts.robotoRegular(
                  16,
                  color: theme_dark!
                      ? AppColors.appGrey2()
                      : AppColorsLightMode.appGrey(),
                  decoration: TextDecoration.none,
                ),
              ),
              SizedBox(height: 8.0),
              companyDatalist.length > 0
                  ? Wrap(
                      children: companyDatalist
                          .map((e) => companyDataItem(ctx, e))
                          .toList(),
                    )
                  : Container(),
              divider(ctx),
            ],
          ),
        );
      } else if (widget.menuType == Constants.HOME_MENU_OEE) {
        if (widget.currentTab != 1) {
          return Container(
            margin: EdgeInsets.only(top: 22.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Utils.getTranslated(ctx, 'sort_and_filter_company')!,
                  style: AppFonts.robotoRegular(
                    16,
                    color: theme_dark!
                        ? AppColors.appGrey2()
                        : AppColorsLightMode.appGrey(),
                    decoration: TextDecoration.none,
                  ),
                ),
                SizedBox(height: 8.0),
                companyDatalist.length > 0
                    ? Wrap(
                        children: companyDatalist
                            .map((e) => companyDataItem(ctx, e))
                            .toList(),
                      )
                    : Container(),
                divider(ctx),
              ],
            ),
          );
        }
      } else {
        return Container(
          margin: EdgeInsets.only(top: 22.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                Utils.getTranslated(ctx, 'sort_and_filter_company')!,
                style: AppFonts.robotoRegular(
                  16,
                  color: theme_dark!
                      ? AppColors.appGrey2()
                      : AppColorsLightMode.appGrey(),
                  decoration: TextDecoration.none,
                ),
              ),
              SizedBox(height: 8.0),
              companyDatalist.length > 0
                  ? Wrap(
                      children: companyDatalist
                          .map((e) => companyDataItem(ctx, e))
                          .toList(),
                    )
                  : Container(),
              divider(ctx),
            ],
          ),
        );
      }
    }

    return Container();
  }

  Widget site(BuildContext ctx) {
    if (Utils.isNotEmpty(widget.menuType)) {
      if (widget.menuType == Constants.HOME_MENU_DQM) {
        return Container(
          margin: EdgeInsets.only(top: 22.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                Utils.getTranslated(ctx, 'sort_and_filter_site')!,
                style: AppFonts.robotoRegular(
                  16,
                  color: theme_dark!
                      ? AppColors.appGrey2()
                      : AppColorsLightMode.appGrey(),
                  decoration: TextDecoration.none,
                ),
              ),
              SizedBox(height: 8.0),
              siteDataList.length > 0
                  ? Wrap(
                      children: siteDataList
                          .map((e) => siteDataItem(ctx, e))
                          .toList(),
                    )
                  : Container(),
              (widget.currentTab == 2) ? divider(ctx) : Container(),
            ],
          ),
        );
      } else if (widget.menuType == Constants.HOME_MENU_OEE) {
        if (widget.currentTab != 1) {
          return Container(
            margin: EdgeInsets.only(top: 22.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Utils.getTranslated(ctx, 'sort_and_filter_site')!,
                  style: AppFonts.robotoRegular(
                    16,
                    color: theme_dark!
                        ? AppColors.appGrey2()
                        : AppColorsLightMode.appGrey(),
                    decoration: TextDecoration.none,
                  ),
                ),
                SizedBox(height: 8.0),
                siteDataList.length > 0
                    ? Wrap(
                        children: siteDataList
                            .map((e) => siteDataItem(ctx, e))
                            .toList(),
                      )
                    : Container(),
                (widget.currentTab == 2) ? divider(ctx) : Container(),
              ],
            ),
          );
        }
      } else {
        return Container(
          margin: EdgeInsets.only(top: 22.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                Utils.getTranslated(ctx, 'sort_and_filter_site')!,
                style: AppFonts.robotoRegular(
                  16,
                  color: theme_dark!
                      ? AppColors.appGrey2()
                      : AppColorsLightMode.appGrey(),
                  decoration: TextDecoration.none,
                ),
              ),
              SizedBox(height: 8.0),
              siteDataList.length > 0
                  ? Wrap(
                      children: siteDataList
                          .map((e) => siteDataItem(ctx, e))
                          .toList(),
                    )
                  : Container(),
              divider(ctx),
            ],
          ),
        );
      }
    }

    return Container();
  }

  Widget project(BuildContext ctx) {
    if (Utils.isNotEmpty(widget.menuType)) {
      if (widget.menuType == Constants.HOME_MENU_DQM) {
        if (widget.currentTab == 2) {
          return GestureDetector(
            onTap: () async {
              final navigateResult = await Navigator.pushNamed(
                  ctx, AppRoutes.sortAndFilterProjectRoute);
              if (navigateResult != null && navigateResult as bool) {
                EasyLoading.show(maskType: EasyLoadingMaskType.black);
                AppCache.sortFilterCacheDTO!.defaultVersion = null;
                callLoadProjectVersion(ctx);
              }
            },
            child: Container(
              width: MediaQuery.of(ctx).size.width,
              margin: EdgeInsets.only(top: 22.0),
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
                          Utils.getTranslated(ctx, 'sort_and_filter_project')!,
                          style: AppFonts.robotoRegular(
                            16,
                            color: theme_dark!
                                ? AppColors.appGrey2()
                                : AppColorsLightMode.appGrey(),
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 12.0),
                        child: Image.asset(
                          theme_dark!
                              ? Constants.ASSET_IMAGES + 'next_bttn.png'
                              : Constants.ASSET_IMAGES_LIGHT + 'next_bttn.png',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.0),
                  Text(
                    '${AppCache.sortFilterCacheDTO!.displayProjectName}',
                    style: AppFonts.robotoRegular(
                      16,
                      color: theme_dark!
                          ? AppColors.appGrey2()
                          : AppColorsLightMode.appGrey(),
                      decoration: TextDecoration.none,
                    ),
                  ),
                  divider(ctx),
                ],
              ),
            ),
          );
        }
      } else if (widget.menuType == Constants.HOME_MENU_OEE) {
        return Container();
      } else {
        return GestureDetector(
          onTap: () async {
            final navigateResult = await Navigator.pushNamed(
                ctx, AppRoutes.sortAndFilterProjectRoute);
            if (navigateResult != null && navigateResult as bool) {
              EasyLoading.show(maskType: EasyLoadingMaskType.black);
              AppCache.sortFilterCacheDTO!.defaultVersion = null;
              callLoadProjectVersion(ctx);
            }
          },
          child: Container(
            width: MediaQuery.of(ctx).size.width,
            margin: EdgeInsets.only(top: 22.0),
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
                        Utils.getTranslated(ctx, 'sort_and_filter_project')!,
                        style: AppFonts.robotoRegular(
                          16,
                          color: theme_dark!
                              ? AppColors.appGrey2()
                              : AppColorsLightMode.appGrey(),
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(right: 12.0),
                      child: Image.asset(theme_dark!
                          ? Constants.ASSET_IMAGES + 'next_bttn.png'
                          : Constants.ASSET_IMAGES_LIGHT + 'next_bttn.png'),
                    ),
                  ],
                ),
                SizedBox(height: 12.0),
                Text(
                  '${AppCache.sortFilterCacheDTO!.displayProjectName}',
                  style: AppFonts.robotoRegular(
                    16,
                    color: theme_dark!
                        ? AppColors.appGrey2()
                        : AppColorsLightMode.appGrey(),
                    decoration: TextDecoration.none,
                  ),
                ),
                divider(ctx),
              ],
            ),
          ),
        );
      }
    }

    return Container();
  }

  Widget version(BuildContext ctx) {
    if (Utils.isNotEmpty(widget.menuType)) {
      if (widget.menuType == Constants.HOME_MENU_DQM) {
        if (widget.currentTab == 2) {
          return projectVersionList.length > 0
              ? Container(
                  margin: EdgeInsets.only(top: 22.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Utils.getTranslated(ctx, 'sort_and_filter_version')!,
                        style: AppFonts.robotoRegular(
                          16,
                          color: theme_dark!
                              ? AppColors.appGrey2()
                              : AppColorsLightMode.appGrey(),
                          decoration: TextDecoration.none,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Wrap(
                        children: projectVersionList
                            .map((e) => versionDataItem(ctx, e))
                            .toList(),
                      ),
                      divider(ctx),
                    ],
                  ),
                )
              : Container();
        }
      } else if (widget.menuType == Constants.HOME_MENU_OEE) {
        return Container();
      } else {
        return Container(
          margin: EdgeInsets.only(top: 22.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                Utils.getTranslated(ctx, 'sort_and_filter_version')!,
                style: AppFonts.robotoRegular(
                  16,
                  color: theme_dark!
                      ? AppColors.appGrey2()
                      : AppColorsLightMode.appGrey(),
                  decoration: TextDecoration.none,
                ),
              ),
              SizedBox(height: 8.0),
              Wrap(
                children: projectVersionList
                    .map((e) => versionDataItem(ctx, e))
                    .toList(),
              ),
              // divider(ctx),
            ],
          ),
        );
      }
    }

    return Container();
  }

  Widget equipment(BuildContext ctx) {
    if (Utils.isNotEmpty(widget.menuType)) {
      if (widget.menuType == Constants.HOME_MENU_DQM) {
        if (widget.currentTab == 2) {
          return GestureDetector(
            onTap: () async {
              final navigateResult = await Navigator.pushNamed(
                  ctx, AppRoutes.sortAndFilterEquipmentRoute);
              if (navigateResult != null && navigateResult as bool) {
                setState(() {
                  this.equipmentNameList = AppCache
                      .sortFilterCacheDTO!.defaultEquipments!
                      .where((element) => element.isSelected!)
                      .map((e) => e.equipmentName)
                      .toList()
                      .join('\n');
                });
              }
            },
            child: Container(
              margin: EdgeInsets.only(top: 22.0, bottom: 22.0),
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
                          Utils.getTranslated(
                              ctx, 'sort_and_filter_equipment')!,
                          style: AppFonts.robotoRegular(
                            16,
                            color: theme_dark!
                                ? AppColors.appGrey2()
                                : AppColorsLightMode.appGrey(),
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 12.0),
                        child: Image.asset(theme_dark!
                            ? Constants.ASSET_IMAGES + 'next_bttn.png'
                            : Constants.ASSET_IMAGES_LIGHT + 'next_bttn.png'),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.0),
                  Text(
                    this.equipmentNameList,
                    style: AppFonts.robotoRegular(
                      16,
                      color: theme_dark!
                          ? AppColors.appGrey2()
                          : AppColorsLightMode.appGrey(),
                      decoration: TextDecoration.none,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      } else if (widget.menuType == Constants.HOME_MENU_OEE) {
        if (widget.currentTab == 2) {
          return GestureDetector(
            onTap: () async {
              final equipmentStr = await Navigator.pushNamed(
                  ctx, AppRoutes.sortAndFilterSingleEquipmentRoute);
              setState(() {
                this.singleEquipmentName = AppCache
                    .sortFilterCacheDTO!.preferredEquipments!.equipmentId!;
              });
            },
            child: Container(
              margin: EdgeInsets.only(top: 22.0, bottom: 22.0),
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
                          Utils.getTranslated(
                              ctx, 'sort_and_filter_equipment')!,
                          style: AppFonts.robotoRegular(
                            16,
                            color: theme_dark!
                                ? AppColors.appGrey2()
                                : AppColorsLightMode.appGrey(),
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 12.0),
                        child: Image.asset(theme_dark!
                            ? Constants.ASSET_IMAGES + 'next_bttn.png'
                            : Constants.ASSET_IMAGES_LIGHT + 'next_bttn.png'),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.0),
                  Text(
                    AppCache.sortFilterCacheDTO!.preferredEquipments != null
                        ? AppCache.sortFilterCacheDTO!.preferredEquipments!
                            .equipmentId!
                        : '',
                    style: AppFonts.robotoRegular(
                      16,
                      color: theme_dark!
                          ? AppColors.appGrey2()
                          : AppColorsLightMode.appGrey(),
                      decoration: TextDecoration.none,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      } else {
        if (widget.currentTab == 1) {
          return GestureDetector(
            onTap: () async {
              final equipmentStr = await Navigator.pushNamed(
                  ctx, AppRoutes.sortAndFilterEquipmentRoute);
              setState(() {
                this.equipmentNameList = equipmentStr as String;
              });
            },
            child: Container(
              margin: EdgeInsets.only(top: 22.0, bottom: 22.0),
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
                          Utils.getTranslated(
                              ctx, 'sort_and_filter_equipment')!,
                          style: AppFonts.robotoRegular(
                            16,
                            color: theme_dark!
                                ? AppColors.appGrey2()
                                : AppColorsLightMode.appGrey(),
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 12.0),
                        child: Image.asset(theme_dark!
                            ? Constants.ASSET_IMAGES + 'next_bttn.png'
                            : Constants.ASSET_IMAGES_LIGHT + 'next_bttn.png'),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.0),
                  Text(
                    this.equipmentNameList,
                    style: AppFonts.robotoRegular(
                      16,
                      color: theme_dark!
                          ? AppColors.appGrey2()
                          : AppColorsLightMode.appGrey(),
                      decoration: TextDecoration.none,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      }
    }

    return Container();
  }

  Widget companyDataItem(BuildContext ctx, CustomDTO customDTO) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (AppCache.sortFilterCacheDTO!.preferredCompany !=
              customDTO.value) {
            this.selectedSiteId = '';
            AppCache.sortFilterCacheDTO!.preferredCompany = customDTO.value;
            EasyLoading.show(maskType: EasyLoadingMaskType.black);
            callLoadSites(ctx);
          }
        });
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(12.0, 9.0, 12.0, 9.0),
        margin: EdgeInsets.only(right: 14.0, top: 14.0),
        decoration: BoxDecoration(
          color:
              (AppCache.sortFilterCacheDTO!.preferredCompany == customDTO.value)
                  ? AppColors.appTeal()
                  : Colors.transparent,
          border:
              (AppCache.sortFilterCacheDTO!.preferredCompany == customDTO.value)
                  ? Border.all(color: Colors.transparent)
                  : Border.all(color: AppColors.appTeal()),
          borderRadius: BorderRadius.circular(50.0),
        ),
        child: Text(
          customDTO.displayName!,
          style: AppFonts.robotoMedium(
            14,
            color: (AppCache.sortFilterCacheDTO!.preferredCompany ==
                    customDTO.value)
                ? AppColors.appPrimaryWhite()
                : AppColors.appTeal(),
            decoration: TextDecoration.none,
          ),
        ),
      ),
    );
  }

  Widget siteDataItem(BuildContext ctx, CustomDTO customDTO) {
    return GestureDetector(
      onTap: () {
        setState(() {
          this.selectedSiteId = customDTO.value!;
          AppCache.sortFilterCacheDTO!.preferredSite = customDTO.value;
          if (widget.menuType == Constants.HOME_MENU_DQM) {
            if (widget.currentTab == 2) {
              EasyLoading.show(maskType: EasyLoadingMaskType.black);
              callLoadProjectAndEquipments(ctx);
            }
          } else {
            EasyLoading.show(maskType: EasyLoadingMaskType.black);
            callLoadProjectList(ctx);
          }
        });
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(12.0, 9.0, 12.0, 9.0),
        margin: EdgeInsets.only(right: 14.0, top: 14.0),
        decoration: BoxDecoration(
          color: (this.selectedSiteId == customDTO.value)
              ? AppColors.appTeal()
              : Colors.transparent,
          border: (this.selectedSiteId == customDTO.value)
              ? Border.all(color: Colors.transparent)
              : Border.all(color: AppColors.appTeal()),
          borderRadius: BorderRadius.circular(50.0),
        ),
        child: Text(
          customDTO.displayName!,
          style: AppFonts.robotoMedium(
            14,
            color: (this.selectedSiteId == customDTO.value)
                ? AppColors.appPrimaryWhite()
                : AppColors.appTeal(),
            decoration: TextDecoration.none,
          ),
        ),
      ),
    );
  }

  Widget versionDataItem(BuildContext ctx, ProjectVersionDataDTO versionDTO) {
    return GestureDetector(
      onTap: () {
        setState(() {
          AppCache.sortFilterCacheDTO!.defaultVersion = versionDTO.version;
          AppCache.sortFilterCacheDTO!.projectVersionObj = versionDTO;
        });
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(12.0, 9.0, 12.0, 9.0),
        margin: EdgeInsets.only(right: 14.0, top: 14.0),
        decoration: BoxDecoration(
          color: (AppCache.sortFilterCacheDTO!.defaultVersion ==
                  versionDTO.version)
              ? AppColors.appTeal()
              : Colors.transparent,
          border: (AppCache.sortFilterCacheDTO!.defaultVersion ==
                  versionDTO.version)
              ? Border.all(color: Colors.transparent)
              : Border.all(color: AppColors.appTeal()),
          borderRadius: BorderRadius.circular(50.0),
        ),
        child: Text(
          versionDTO.version!,
          style: AppFonts.robotoMedium(
            14,
            color: (AppCache.sortFilterCacheDTO!.defaultVersion ==
                    versionDTO.version)
                ? AppColors.appPrimaryWhite()
                : AppColors.appTeal(),
            decoration: TextDecoration.none,
          ),
        ),
      ),
    );
  }

  Widget divider(BuildContext ctx) {
    return Container(
      margin: EdgeInsets.only(top: 22.0),
      width: MediaQuery.of(ctx).size.width,
      height: 1.0,
      color: theme_dark!
          ? AppColors.appDividerColor()
          : AppColorsLightMode.appDividerColor(),
    );
  }

  void showCalendarDialog(BuildContext ctx) {
    showDialog<dynamic>(
      context: ctx,
      builder: (BuildContext context) => CalendarPopupView(
        barrierDismissible: true,
        minimumDate: DateTime.now(),
        initialEndDate: AppCache.sortFilterCacheDTO!.endDate,
        initialStartDate: AppCache.sortFilterCacheDTO!.startDate,
        onApplyClick: (DateTime startData, DateTime endData) {
          setState(() {
            AppCache.sortFilterCacheDTO!.startDate = startData;
            AppCache.sortFilterCacheDTO!.endDate = endData;
          });
        },
      ),
    );
  }
}
