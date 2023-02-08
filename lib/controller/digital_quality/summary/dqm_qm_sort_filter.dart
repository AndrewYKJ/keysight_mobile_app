import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:keysight_pma/const/appcolors.dart';
import 'package:keysight_pma/const/appfonts.dart';
import 'package:keysight_pma/const/constants.dart';
import 'package:keysight_pma/const/utils.dart';
import 'package:keysight_pma/model/arguments/dqm_argument.dart';
import 'package:keysight_pma/model/customize.dart';
import 'package:keysight_pma/routes/approutes.dart';

import '../../../cache/appcache.dart';

class DqmQualityMetricSortAndFilterScreen extends StatefulWidget {
  final String? sortBy;
  final List<CustomDqmSortFilterProjectsDTO>? projectIdList;
  final String? filterBy;
  final int? fromWhere;
  final String? sumType;
  DqmQualityMetricSortAndFilterScreen(
      {Key? key,
      this.sortBy,
      this.projectIdList,
      this.filterBy,
      this.fromWhere,
      this.sumType})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DqmQualityMetricSortAndFilterScreen();
  }
}

class _DqmQualityMetricSortAndFilterScreen
    extends State<DqmQualityMetricSortAndFilterScreen> {
  String selectedProject = '';
  String sorting = '';
  String filtering = '';
  List<CustomDqmSortFilterProjectsDTO> projectIdList = [];
  List<CustomDTO> sortList = [
    CustomDTO(
        displayName: 'sort_and_filter_project',
        value: Constants.SORT_BY_PROJECT),
    CustomDTO(
        displayName: 'dqm_summary_volume', value: Constants.SORT_BY_VOLUME),
  ];
  List<CustomDTO> sortEquipList = [
    CustomDTO(
        displayName: 'dqm_summary_volume', value: Constants.SORT_BY_VOLUME),
    CustomDTO(
        displayName: 'sort_and_filter_equipment',
        value: Constants.SORT_BY_EQUIPMENT),
  ];
  List<CustomDTO> sortTestnameList = [
    CustomDTO(
        displayName: 'dqm_summary_volume', value: Constants.SORT_BY_VOLUME),
    CustomDTO(displayName: 'alertTestName', value: Constants.SORT_BY_TESTNAME),
  ];
  List<CustomDTO> filterEquipList = [
    CustomDTO(
        displayName: 'sort_and_filter_equipment',
        value: Constants.FILTER_BY_EQUIPMENT),
    CustomDTO(
        displayName: 'alertTestName', value: Constants.FILTER_BY_TESTNAME),
  ];
  bool? theme_dark = AppCache.sortFilterCacheDTO!.currentTheme;
  @override
  void initState() {
    super.initState();
    Utils.setFirebaseAnalyticsCurrentScreen(
        Constants.ANALYTICS_DQM_SUMMARY_FILTER_SCREEN);
    if (widget.projectIdList != null && widget.projectIdList!.length > 0) {
      widget.projectIdList!.forEach((element) {
        this.projectIdList.add(element);
      });
    }
    displaySelectedProjects();
  }

  void displaySelectedProjects() {
    if (this.projectIdList.length > 0) {
      this.selectedProject = '';
      this.projectIdList.forEach((data) {
        if (data.isSelected!) {
          if (Utils.isNotEmpty(this.selectedProject)) {
            this.selectedProject =
                this.selectedProject + '\n' + data.projectId!;
          } else {
            this.selectedProject = data.projectId!;
          }
        }
      });
    }

    setState(() {
      if (widget.sortBy != null) {
        this.sorting = widget.sortBy!;
      }

      if (widget.filterBy != null) {
        this.filtering = widget.filterBy!;
      }
    });
  }

  void displayAllProjects() {
    if (this.projectIdList.length > 0) {
      this.selectedProject = '';
      this.projectIdList.forEach((data) {
        data.isSelected = true;
        if (Utils.isNotEmpty(this.selectedProject)) {
          this.selectedProject = this.selectedProject + '\n' + data.projectId!;
        } else {
          this.selectedProject = data.projectId!;
        }
      });
    }

    setState(() {
      this.sorting = widget.sortBy!;
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
                Navigator.pop(context);
              },
              child: Image.asset(
                theme_dark!
                    ? Constants.ASSET_IMAGES + 'close_bttn.png'
                    : Constants.ASSET_IMAGES_LIGHT + 'close_icon.png',
              ))
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
                      widget.fromWhere == 12345
                          ? Container()
                          : widget.fromWhere == Constants.FROM_DQMS_PROJECT
                              ? sortBy(context)
                              : sortOtherBy(context),
                      widget.fromWhere == 12345
                          ? equipment(context)
                          : Container(),
                      widget.fromWhere == Constants.FROM_DQMS_PROJECT
                          ? project(context)
                          : Container(),
                      widget.fromWhere == Constants.FROM_DQMS_EQUIPMENT &&
                              widget.sumType == Constants.SUMMARY_TYPE_FAILURE
                          ? filterBy(context)
                          : Container(),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 14.0),
                color: theme_dark!
                    ? AppColors.appPrimaryBlack()
                    : AppColorsLightMode.appPrimaryBlack(),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(left: 90, right: 90),
                  child: GestureDetector(
                    onTap: () {
                      DqmSortFilterArguments arguments = DqmSortFilterArguments(
                          sortBy: this.sorting,
                          projectIdList: this.projectIdList,
                          filterBy: this.filtering);
                      Navigator.pop(context, arguments);
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
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.start,
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     Expanded(
                //       child: GestureDetector(
                //         onTap: () {
                //           displayAllProjects();
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
                //           DqmSortFilterArguments arguments =
                //               DqmSortFilterArguments(
                //                   sortBy: this.sorting,
                //                   projectIdList: this.projectIdList,
                //                   filterBy: this.filtering);
                //           Navigator.pop(context, arguments);
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

  Widget sortBy(BuildContext ctx) {
    return Container(
      margin: EdgeInsets.only(top: 22.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Utils.getTranslated(ctx, 'dqm_summary_qm_sort_by')!,
            style: AppFonts.robotoRegular(
              16,
              color: theme_dark!
                  ? AppColors.appGrey2()
                  : AppColorsLightMode.appGrey(),
              decoration: TextDecoration.none,
            ),
          ),
          SizedBox(height: 8.0),
          sortList.length > 0
              ? Wrap(
                  children: sortList.map((e) => sortItem(ctx, e)).toList(),
                )
              : Container(),
          this.projectIdList.length > 0 ? divider(ctx) : Container(),
        ],
      ),
    );
  }

  Widget sortOtherBy(BuildContext ctx) {
    return Container(
      margin: EdgeInsets.only(top: 22.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Utils.getTranslated(ctx, 'dqm_summary_qm_sort_by')!,
            style: AppFonts.robotoRegular(
              16,
              color: theme_dark!
                  ? AppColors.appGrey2()
                  : AppColorsLightMode.appGrey(),
              decoration: TextDecoration.none,
            ),
          ),
          SizedBox(height: 8.0),
          this.filtering == Constants.FILTER_BY_EQUIPMENT
              ? Wrap(
                  children: sortEquipList.map((e) => sortItem(ctx, e)).toList(),
                )
              : this.filtering == Constants.FILTER_BY_TESTNAME
                  ? Wrap(
                      children: sortTestnameList
                          .map((e) => sortItem(ctx, e))
                          .toList(),
                    )
                  : Container(),
          widget.sumType == Constants.SUMMARY_TYPE_FAILURE
              ? divider(ctx)
              : Container(),
        ],
      ),
    );
  }

  Widget sortItem(BuildContext ctx, CustomDTO customDTO) {
    return GestureDetector(
      onTap: () {
        setState(() {
          this.sorting = customDTO.value!;
        });
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(12.0, 9.0, 12.0, 9.0),
        margin: EdgeInsets.only(right: 14.0, top: 14.0),
        decoration: BoxDecoration(
          color: (this.sorting == customDTO.value)
              ? AppColors.appTeal()
              : Colors.transparent,
          border: (this.sorting == customDTO.value)
              ? Border.all(color: Colors.transparent)
              : Border.all(color: AppColors.appTeal()),
          borderRadius: BorderRadius.circular(50.0),
        ),
        child: Text(
          Utils.getTranslated(ctx, customDTO.displayName!)!,
          style: AppFonts.robotoMedium(
            14,
            color: (this.sorting == customDTO.value)
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

  Widget equipment(BuildContext ctx) {
    if (this.projectIdList.length > 0) {
      return GestureDetector(
        onTap: () async {
          final navigateResult = await Navigator.pushNamed(
            ctx,
            AppRoutes.dqmDashboardDetailSortFilterProjectsRoute,
            arguments: DqmSortFilterArguments(
              projectIdList: widget.projectIdList,
            ),
          );

          if (navigateResult != null) {
            List<CustomDqmSortFilterProjectsDTO> resultList =
                navigateResult as List<CustomDqmSortFilterProjectsDTO>;
            if (resultList.length > 0) {
              this.projectIdList.clear();
              resultList.forEach((element) {
                this.projectIdList.add(element);
              });
              displaySelectedProjects();
            }
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
                      Utils.getTranslated(ctx, 'sort_and_filter_equipment')!,
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
                this.selectedProject,
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

    return Container();
  }

  Widget project(BuildContext ctx) {
    if (this.projectIdList.length > 0) {
      return GestureDetector(
        onTap: () async {
          final navigateResult = await Navigator.pushNamed(
            ctx,
            AppRoutes.dqmDashboardDetailSortFilterProjectsRoute,
            arguments: DqmSortFilterArguments(
              projectIdList: widget.projectIdList,
            ),
          );

          if (navigateResult != null) {
            List<CustomDqmSortFilterProjectsDTO> resultList =
                navigateResult as List<CustomDqmSortFilterProjectsDTO>;
            if (resultList.length > 0) {
              this.projectIdList.clear();
              resultList.forEach((element) {
                this.projectIdList.add(element);
              });
              displaySelectedProjects();
            }
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
                this.selectedProject,
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

    return Container();
  }

  Widget filterBy(BuildContext ctx) {
    return Container(
      margin: EdgeInsets.only(top: 22.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Utils.getTranslated(ctx, 'dqm_testresult_probe_finder_filterby')!,
            style: AppFonts.robotoRegular(
              16,
              color: theme_dark!
                  ? AppColors.appGrey2()
                  : AppColorsLightMode.appGrey(),
              decoration: TextDecoration.none,
            ),
          ),
          SizedBox(height: 8.0),
          sortList.length > 0
              ? Wrap(
                  children:
                      filterEquipList.map((e) => filterItem(ctx, e)).toList(),
                )
              : Container(),
        ],
      ),
    );
  }

  Widget filterItem(BuildContext ctx, CustomDTO customDTO) {
    return GestureDetector(
      onTap: () {
        setState(() {
          this.filtering = customDTO.value!;
          this.sorting = Constants.SORT_BY_VOLUME;
        });
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(12.0, 9.0, 12.0, 9.0),
        margin: EdgeInsets.only(right: 14.0, top: 14.0),
        decoration: BoxDecoration(
          color: (this.filtering == customDTO.value)
              ? AppColors.appTeal()
              : Colors.transparent,
          border: (this.filtering == customDTO.value)
              ? Border.all(color: Colors.transparent)
              : Border.all(color: AppColors.appTeal()),
          borderRadius: BorderRadius.circular(50.0),
        ),
        child: Text(
          Utils.getTranslated(ctx, customDTO.displayName!)!,
          style: AppFonts.robotoMedium(
            14,
            color: (this.filtering == customDTO.value)
                ? AppColors.appPrimaryWhite()
                : AppColors.appTeal(),
            decoration: TextDecoration.none,
          ),
        ),
      ),
    );
  }
}
