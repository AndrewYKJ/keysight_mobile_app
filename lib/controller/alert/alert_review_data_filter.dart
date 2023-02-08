import 'package:flutter/material.dart';
import 'package:keysight_pma/const/appcolors.dart';
import 'package:keysight_pma/const/appfonts.dart';
import 'package:keysight_pma/const/constants.dart';
import 'package:keysight_pma/const/utils.dart';
import 'package:keysight_pma/model/customize.dart';
import 'package:keysight_pma/model/dqm/custom.dart';

import '../../cache/appcache.dart';

class AlertReviewDataInfoFilterScreen extends StatefulWidget {
  final List<CustomDqmSortFilterItemSelectionDTO>? filterAlertTypeList;
  final List<CustomDqmSortFilterItemSelectionDTO>? filterAlertStatusList;
  final int? fromWhere;
  final List<CustomDqmSortFilterItemSelectionDTO>? filterAlertPriority;
  final List<CustomDqmSortFilterItemSelectionDTO>? filterAlertWorkflow;

  final List<CustomDqmSortFilterItemSelectionDTO>? filterProbePropertyList;

  AlertReviewDataInfoFilterScreen(
      {Key? key,
      this.filterAlertTypeList,
      this.filterAlertStatusList,
      this.filterAlertWorkflow,
      this.fromWhere,
      this.filterProbePropertyList,
      this.filterAlertPriority})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AlertReviewDataInfoFilterScreen();
  }
}

class _AlertReviewDataInfoFilterScreen
    extends State<AlertReviewDataInfoFilterScreen> {
  // List<CustomDTO> alertTypeList = [
  //   CustomDTO(
  //       displayName: "Pat Limit Recomendation",
  //       value: "DUTPatLimitRecommendation"),
  //   CustomDTO(
  //       displayName: "Limit Change Anomaly", value: "DUTLimitChangeAnomaly"),
  //   CustomDTO(
  //       displayName: "Test Coverage Changed", value: "TestCoverageChanged"),
  //   CustomDTO(
  //       displayName: "Consecutive Test Failure",
  //       value: "ConsecutiveTestFailure"),
  //   CustomDTO(displayName: "Component Anomaly", value: "DUTComponentAnomaly"),
  //   CustomDTO(displayName: "Fixture Maintenance", value: "FixtureMaintenance"),
  //   CustomDTO(
  //       displayName: "Degradation Anomaly", value: "DUTDegradationAnomaly"),
  //   CustomDTO(
  //       displayName: "Cpk Alert Anomalies", value: "DUTCpkAlertAnomalies"),
  //   CustomDTO(
  //       displayName: "Pat Limit Anomalies", value: "DUTPatLimitAnomalies"),
  //   CustomDTO(
  //       displayName: "Wip Scrap Board Alert", value: "WipScrapBoardAlert"),
  //   CustomDTO(displayName: "Sensor", value: "Sensor"),
  //   CustomDTO(
  //       displayName: "Post Fixture Maintenance",
  //       value: "PostFixtureMaintenance")
  // ];

  bool? theme_dark = AppCache.sortFilterCacheDTO!.currentTheme;

  bool? typeBool;
  bool? statusBool;
  bool? workFlowBool;
  bool? priorityBool;
  bool? probeBool;

  List<DqmXaxisRangeDTO> summaryWorkflow = [
    DqmXaxisRangeDTO(
        rangeName: 'To Do',
        rangeValue: 'todo',
        isAvailable: false,
        isSelected: false),
    DqmXaxisRangeDTO(
        rangeName: 'In Progress',
        rangeValue: 'inProgress',
        isAvailable: false,
        isSelected: false),
    DqmXaxisRangeDTO(
        rangeName: 'Verification',
        rangeValue: 'verification',
        isAvailable: false,
        isSelected: false),
    DqmXaxisRangeDTO(
        rangeName: 'Closed',
        rangeValue: 'closed',
        isAvailable: false,
        isSelected: false),
  ];

  List<DqmXaxisRangeDTO> summaryStatus = [
    DqmXaxisRangeDTO(
        rangeName: 'Actual',
        rangeValue: 'Actual',
        isAvailable: false,
        isSelected: false),
    DqmXaxisRangeDTO(
        rangeName: 'Dispose',
        rangeValue: 'Dispose',
        isAvailable: false,
        isSelected: false),
    DqmXaxisRangeDTO(
        rangeName: 'Dismiss',
        rangeValue: 'Dismiss',
        isAvailable: false,
        isSelected: false),
  ];
  List<DqmXaxisRangeDTO> summaryPriority = [
    DqmXaxisRangeDTO(
        rangeName: 'Critical',
        rangeValue: 'critical',
        isAvailable: false,
        isSelected: false),
    DqmXaxisRangeDTO(
        rangeName: 'High',
        rangeValue: 'high',
        isAvailable: false,
        isSelected: false),
    DqmXaxisRangeDTO(
        rangeName: 'Medium',
        rangeValue: 'medium',
        isAvailable: false,
        isSelected: false),
    DqmXaxisRangeDTO(
        rangeName: 'Low',
        rangeValue: 'low',
        isAvailable: false,
        isSelected: false),
    DqmXaxisRangeDTO(
        rangeName: 'None',
        rangeValue: 'none',
        isAvailable: false,
        isSelected: false),
  ];

  @override
  void initState() {
    Utils.setFirebaseAnalyticsCurrentScreen(
        Constants.ANALYTICS_ALERT_REVIEW_SORT_FILTER_SCREEN);
    if (widget.fromWhere == null) {
      if (widget.filterAlertStatusList != null &&
          widget.filterAlertStatusList!.length > 0) {
        setState(() {
          this.statusBool =
              Utils.isSelectAll(itemList: widget.filterAlertStatusList);
        });
      }
      if (widget.filterAlertTypeList != null &&
          widget.filterAlertTypeList!.length > 0) {
        setState(() {
          this.typeBool =
              Utils.isSelectAll(itemList: widget.filterAlertTypeList);
        });
      }
    }

    if (widget.filterProbePropertyList != null &&
        widget.filterProbePropertyList!.length > 0) {
      setState(() {
        this.probeBool =
            Utils.isSelectAll(itemList: widget.filterProbePropertyList);
      });
    }

    if (widget.filterAlertPriority != null) {
      summaryPriority.forEach((element) {
        element.isAvailable = widget.filterAlertPriority!
            .any((value) => value.item == element.rangeName);

        widget.filterAlertPriority!.forEach((value) {
          if (element.rangeName == value.item) {
            element.isSelected = value.isSelected;
          }
        });
        this.priorityBool = Utils.isSelectAll(caseHistoryItem: summaryPriority);
      });
    }

    if (widget.filterAlertWorkflow != null) {
      summaryWorkflow.forEach((element) {
        element.isAvailable = widget.filterAlertWorkflow!
            .any((value) => value.item == element.rangeName);
        widget.filterAlertWorkflow!.forEach((value) {
          if (element.rangeName == value.item) {
            element.isSelected = value.isSelected;
          }
        });
      });
      this.workFlowBool = Utils.isSelectAll(caseHistoryItem: summaryWorkflow);
    }

    if (widget.filterAlertStatusList != null && widget.fromWhere != null) {
      summaryStatus.forEach((element) {
        element.isAvailable = widget.filterAlertStatusList!
            .any((value) => value.item == element.rangeName);
        widget.filterAlertStatusList!.forEach((value) {
          if (element.rangeName == value.item) {
            element.isSelected = value.isSelected;
          }
        });
      });
      this.statusBool = Utils.isSelectAll(caseHistoryItem: summaryStatus);
    }

    super.initState();
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
                      widget.filterAlertTypeList != null
                          ? alertType(context)
                          : Container(),
                      widget.filterAlertPriority != null
                          ? alertPriority(context)
                          : Container(),
                      widget.filterAlertStatusList != null
                          ? widget.fromWhere != null
                              ? alertStatusfromCaseHistory(context)
                              : alertStatus(context)
                          : Container(),
                      widget.filterAlertWorkflow != null
                          ? alertWorkflow(context)
                          : Container(),
                      widget.filterProbePropertyList != null
                          ? probeProperty(context)
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Expanded(
                    //   child: GestureDetector(
                    //     onTap: () {},
                    //     child: Container(
                    //       padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                    //       decoration: BoxDecoration(
                    //           color: Colors.transparent,
                    //           border: Border.all(
                    //             color: theme_dark!
                    //                 ? AppColors.appGreyD3()
                    //                 : AppColorsLightMode.appPrimaryYellow(),
                    //           ),
                    //           borderRadius: BorderRadius.circular(2.0)),
                    //       child: Text(
                    //         Utils.getTranslated(
                    //             context, 'sort_and_filter_clear_btn')!,
                    //         style: AppFonts.robotoMedium(
                    //           15,
                    //           color: theme_dark!
                    //               ? AppColors.appPrimaryWhite()
                    //               : AppColorsLightMode.appPrimaryYellow(),
                    //           decoration: TextDecoration.none,
                    //         ),
                    //         textAlign: TextAlign.center,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(width: 16.0),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context, true);
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                          margin: EdgeInsets.only(left: 90.0, right: 90.0),
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget probeProperty(BuildContext ctx) {
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
                  Utils.getTranslated(
                      ctx, 'dqm_testresult_probe_finder_filter_view')!,
                  style: AppFonts.robotoRegular(
                    16,
                    color: theme_dark!
                        ? AppColors.appGrey2()
                        : AppColorsLightMode.appGrey(),
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
              SizedBox(width: 10.0),
              GestureDetector(
                onTap: () {
                  setState(() {
                    this.probeBool = !this.probeBool!;
                    if (this.probeBool!) {
                      widget.filterProbePropertyList!.forEach((element) {
                        element.isSelected = true;
                      });
                    } else {
                      widget.filterProbePropertyList!.forEach((element) {
                        element.isSelected = false;
                      });
                    }
                  });
                },
                child: Text(
                  !this.probeBool!
                      ? Utils.getTranslated(ctx, 'select_all')!
                      : Utils.getTranslated(ctx, 'deselect_all')!,
                  style: AppFonts.robotoRegular(
                    16,
                    color: theme_dark!
                        ? AppColors.appGrey2()
                        : AppColorsLightMode.appGrey(),
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.0),
          Wrap(
            children: widget.filterProbePropertyList!
                .map((e) => probePropertyDataItem(ctx, e))
                .toList(),
          ),
          divider(ctx),
        ],
      ),
    );
  }

  Widget probePropertyDataItem(
      BuildContext ctx, CustomDqmSortFilterItemSelectionDTO filterDTO) {
    return GestureDetector(
      onTap: () {
        setState(() {
          filterDTO.isSelected = !filterDTO.isSelected!;
          this.probeBool =
              Utils.isSelectAll(itemList: widget.filterProbePropertyList);
        });
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(12.0, 9.0, 12.0, 9.0),
        margin: EdgeInsets.only(right: 14.0, top: 14.0),
        decoration: BoxDecoration(
          color:
              filterDTO.isSelected! ? AppColors.appTeal() : Colors.transparent,
          border: filterDTO.isSelected!
              ? Border.all(color: Colors.transparent)
              : Border.all(color: AppColors.appTeal()),
          borderRadius: BorderRadius.circular(50.0),
        ),
        child: Text(
          filterDTO.item!,
          style: AppFonts.robotoMedium(
            14,
            color: filterDTO.isSelected!
                ? AppColors.appPrimaryWhite()
                : AppColors.appTeal(),
            decoration: TextDecoration.none,
          ),
        ),
      ),
    );
  }

  Widget alertWorkflow(BuildContext ctx) {
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
                  Utils.getTranslated(context, 'case_workflow')!,
                  style: AppFonts.robotoRegular(
                    16,
                    color: theme_dark!
                        ? AppColors.appGrey2()
                        : AppColorsLightMode.appGrey(),
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
              SizedBox(width: 10.0),
              GestureDetector(
                onTap: () {
                  setState(() {
                    this.workFlowBool = !this.workFlowBool!;
                    if (this.workFlowBool!) {
                      summaryWorkflow.forEach((element) {
                        element.isSelected = true;
                      });
                    } else {
                      summaryWorkflow.forEach((element) {
                        element.isSelected = false;
                      });
                    }
                  });
                },
                child: Text(
                  !this.workFlowBool!
                      ? Utils.getTranslated(ctx, 'select_all')!
                      : Utils.getTranslated(ctx, 'deselect_all')!,
                  style: AppFonts.robotoRegular(
                    16,
                    color: theme_dark!
                        ? AppColors.appGrey2()
                        : AppColorsLightMode.appGrey(),
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.0),
          Wrap(
            children: summaryWorkflow
                .map((e) => alertWorkflowDataItem(ctx, e))
                .toList(),
          ),
          divider(ctx),
        ],
      ),
    );
  }

  Widget alertWorkflowDataItem(BuildContext ctx, DqmXaxisRangeDTO filterDTO) {
    if (filterDTO.isAvailable != false)
      return GestureDetector(
        onTap: () {
          setState(() {
            filterDTO.isSelected = !filterDTO.isSelected!;

            widget.filterAlertWorkflow!.forEach((value) {
              if (value.item == filterDTO.rangeName) {
                value.isSelected = !value.isSelected!;
              }
              // value.isSelected = summaryWorkflow
              //     .firstWhere((element) => value.item == element.rangeName)
              //     .isSelected;
            });
            this.workFlowBool =
                Utils.isSelectAll(caseHistoryItem: summaryWorkflow);
          });
        },
        child: Container(
          padding: EdgeInsets.fromLTRB(12.0, 9.0, 12.0, 9.0),
          margin: EdgeInsets.only(right: 14.0, top: 14.0),
          decoration: BoxDecoration(
            color: filterDTO.isSelected!
                ? AppColors.appTeal()
                : Colors.transparent,
            border: filterDTO.isSelected!
                ? Border.all(color: Colors.transparent)
                : Border.all(color: AppColors.appTeal()),
            borderRadius: BorderRadius.circular(50.0),
          ),
          child: Text(
            filterDTO.rangeName!,
            style: AppFonts.robotoMedium(
              14,
              color: filterDTO.isSelected!
                  ? AppColors.appPrimaryWhite()
                  : AppColors.appTeal(),
              decoration: TextDecoration.none,
            ),
          ),
        ),
      );
    else {
      return Text('');
    }
  }

  Widget alertPriority(BuildContext ctx) {
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
                  Utils.getTranslated(context, 'case_priority')!,
                  style: AppFonts.robotoRegular(
                    16,
                    color: theme_dark!
                        ? AppColors.appGrey2()
                        : AppColorsLightMode.appGrey(),
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
              SizedBox(width: 10.0),
              GestureDetector(
                onTap: () {
                  setState(() {
                    this.priorityBool = !this.priorityBool!;
                    if (this.priorityBool!) {
                      summaryPriority.forEach((element) {
                        element.isSelected = true;
                      });
                    } else {
                      summaryPriority.forEach((element) {
                        element.isSelected = false;
                      });
                    }
                  });
                },
                child: Text(
                  !this.priorityBool!
                      ? Utils.getTranslated(ctx, 'select_all')!
                      : Utils.getTranslated(ctx, 'deselect_all')!,
                  style: AppFonts.robotoRegular(
                    16,
                    color: theme_dark!
                        ? AppColors.appGrey2()
                        : AppColorsLightMode.appGrey(),
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.0),
          Wrap(
            children: summaryPriority
                .map((e) => alertPriorityDataItem(ctx, e))
                .toList(),
          ),
          divider(ctx),
        ],
      ),
    );
  }

  Widget alertPriorityDataItem(BuildContext ctx, DqmXaxisRangeDTO filterDTO) {
    if (filterDTO.isAvailable != false)
      return GestureDetector(
        onTap: () {
          setState(() {
            filterDTO.isSelected = !filterDTO.isSelected!;
            widget.filterAlertPriority!.forEach((value) {
              if (value.item == filterDTO.rangeName) {
                value.isSelected = !value.isSelected!;
              }
            });
            this.priorityBool =
                Utils.isSelectAll(caseHistoryItem: summaryPriority);
            // widget.filterAlertPriority!.forEach((value) {
            //   widget.filterAlertPriority!.forEach((value) {
            //     if (value.item == filterDTO.rangeName) {
            //       value.isSelected = !value.isSelected!;
            //     }
            //     // value.isSelected = summaryWorkflow
            //     //     .firstWhere((element) => value.item == element.rangeName)
            //     //     .isSelected;
            //   });
            //   value.isSelected = summaryPriority
            //       .firstWhere((element) => value.item == element.rangeName)
            //       .isSelected;
            // });
          });
        },
        child: Container(
          padding: EdgeInsets.fromLTRB(12.0, 9.0, 12.0, 9.0),
          margin: EdgeInsets.only(right: 14.0, top: 14.0),
          decoration: BoxDecoration(
            color: filterDTO.isSelected!
                ? AppColors.appTeal()
                : Colors.transparent,
            border: filterDTO.isSelected!
                ? Border.all(color: Colors.transparent)
                : Border.all(color: AppColors.appTeal()),
            borderRadius: BorderRadius.circular(50.0),
          ),
          child: Text(
            filterDTO.rangeName!,
            style: AppFonts.robotoMedium(
              14,
              color: filterDTO.isSelected!
                  ? AppColors.appPrimaryWhite()
                  : AppColors.appTeal(),
              decoration: TextDecoration.none,
            ),
          ),
        ),
      );
    else {
      return Text('');
    }
  }

  Widget alertStatusfromCaseHistory(BuildContext ctx) {
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
                  (widget.filterAlertWorkflow != null &&
                          widget.filterAlertPriority != null)
                      ? Utils.getTranslated(context, 'case_status')!
                      : Utils.getTranslated(
                          ctx, 'dqm_testresult_analog_info_filterby_panel')!,
                  style: AppFonts.robotoRegular(
                    16,
                    color: theme_dark!
                        ? AppColors.appGrey2()
                        : AppColorsLightMode.appGrey(),
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
              SizedBox(width: 10.0),
              GestureDetector(
                onTap: () {
                  setState(() {
                    this.statusBool = !this.statusBool!;
                    if (this.statusBool!) {
                      summaryStatus.forEach((element) {
                        element.isSelected = true;
                      });
                      // widget.filterAlertStatusList!.forEach((element) {
                      //   element.isSelected = true;
                      // });
                    } else {
                      summaryStatus.forEach((element) {
                        element.isSelected = false;
                      });
                      // widget.filterAlertStatusList!.forEach((element) {
                      //   element.isSelected = true;
                      // });
                    }
                  });
                },
                child: Text(
                  !this.statusBool!
                      ? Utils.getTranslated(ctx, 'select_all')!
                      : Utils.getTranslated(ctx, 'deselect_all')!,
                  style: AppFonts.robotoRegular(
                    16,
                    color: theme_dark!
                        ? AppColors.appGrey2()
                        : AppColorsLightMode.appGrey(),
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.0),
          Wrap(
            children: summaryStatus
                .map((e) => alertStatusfromCaseHistoryDataItem(ctx, e))
                .toList(),
          ),
          divider(ctx),
        ],
      ),
    );
  }

  Widget alertStatusfromCaseHistoryDataItem(
      BuildContext ctx, DqmXaxisRangeDTO filterDTO) {
    if (filterDTO.isAvailable != false)
      return GestureDetector(
        onTap: () {
          setState(() {
            filterDTO.isSelected = !filterDTO.isSelected!;
            widget.filterAlertStatusList!.forEach((value) {
              if (value.item == filterDTO.rangeName) {
                value.isSelected = !value.isSelected!;
              }
              // value.isSelected = summaryWorkflow
              //     .firstWhere((element) => value.item == element.rangeName)
              //     .isSelected;
            });
            this.statusBool = Utils.isSelectAll(caseHistoryItem: summaryStatus);
          });
        },
        child: Container(
          padding: EdgeInsets.fromLTRB(12.0, 9.0, 12.0, 9.0),
          margin: EdgeInsets.only(right: 14.0, top: 14.0),
          decoration: BoxDecoration(
            color: filterDTO.isSelected!
                ? AppColors.appTeal()
                : Colors.transparent,
            border: filterDTO.isSelected!
                ? Border.all(color: Colors.transparent)
                : Border.all(color: AppColors.appTeal()),
            borderRadius: BorderRadius.circular(50.0),
          ),
          child: Text(
            filterDTO.rangeName!,
            style: AppFonts.robotoMedium(
              14,
              color: filterDTO.isSelected!
                  ? AppColors.appPrimaryWhite()
                  : AppColors.appTeal(),
              decoration: TextDecoration.none,
            ),
          ),
        ),
      );
    else {
      return Text('');
    }
  }

  Widget alertType(BuildContext ctx) {
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
                  Utils.getTranslated(
                      ctx, 'dqm_testresult_analog_info_filterby_test_type')!,
                  style: AppFonts.robotoRegular(
                    16,
                    color: theme_dark!
                        ? AppColors.appGrey2()
                        : AppColorsLightMode.appGrey(),
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
              SizedBox(width: 10.0),
              GestureDetector(
                onTap: () {
                  setState(() {
                    this.typeBool = !this.typeBool!;
                    if (this.typeBool!) {
                      widget.filterAlertTypeList!.forEach((element) {
                        element.isSelected = true;
                      });
                    } else {
                      widget.filterAlertTypeList!.forEach((element) {
                        element.isSelected = false;
                      });
                    }
                  });
                },
                child: Text(
                  !this.typeBool!
                      ? Utils.getTranslated(ctx, 'select_all')!
                      : Utils.getTranslated(ctx, 'deselect_all')!,
                  style: AppFonts.robotoRegular(
                    16,
                    color: theme_dark!
                        ? AppColors.appGrey2()
                        : AppColorsLightMode.appGrey(),
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.0),
          Wrap(
            children: widget.filterAlertTypeList!
                .map((e) => alertTypeDataItem(ctx, e))
                .toList(),
          ),
          divider(ctx),
        ],
      ),
    );
  }

  Widget alertStatus(BuildContext ctx) {
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
                  (widget.filterAlertWorkflow != null &&
                          widget.filterAlertPriority != null)
                      ? Utils.getTranslated(context, 'case_status')!
                      : Utils.getTranslated(
                          ctx, 'dqm_testresult_analog_info_filterby_panel')!,
                  style: AppFonts.robotoRegular(
                    16,
                    color: theme_dark!
                        ? AppColors.appGrey2()
                        : AppColorsLightMode.appGrey(),
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
              SizedBox(width: 10.0),
              GestureDetector(
                onTap: () {
                  setState(() {
                    this.statusBool = !this.statusBool!;
                    if (this.statusBool!) {
                      if (widget.filterAlertWorkflow != null &&
                          widget.filterAlertPriority != null) {
                        widget.filterAlertWorkflow!.forEach((element) {
                          element.isSelected = true;
                        });
                      } else {
                        widget.filterAlertStatusList!.forEach((element) {
                          element.isSelected = true;
                        });
                      }
                    } else {
                      if (widget.filterAlertWorkflow != null &&
                          widget.filterAlertPriority != null) {
                        widget.filterAlertWorkflow!.forEach((element) {
                          element.isSelected = false;
                        });
                      } else {
                        widget.filterAlertStatusList!.forEach((element) {
                          element.isSelected = false;
                        });
                      }
                    }
                  });
                },
                child: Text(
                  !this.statusBool!
                      ? Utils.getTranslated(ctx, 'select_all')!
                      : Utils.getTranslated(ctx, 'deselect_all')!,
                  style: AppFonts.robotoRegular(
                    16,
                    color: theme_dark!
                        ? AppColors.appGrey2()
                        : AppColorsLightMode.appGrey(),
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.0),
          Wrap(
            children: widget.filterAlertStatusList!
                .map((e) => alertStatusDataItem(ctx, e))
                .toList(),
          ),
          divider(ctx),
        ],
      ),
    );
  }

  Widget alertTypeDataItem(
      BuildContext ctx, CustomDqmSortFilterItemSelectionDTO filterDTO) {
    return GestureDetector(
      onTap: () {
        setState(() {
          filterDTO.isSelected = !filterDTO.isSelected!;
          this.typeBool =
              Utils.isSelectAll(itemList: widget.filterAlertTypeList);
        });
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(12.0, 9.0, 12.0, 9.0),
        margin: EdgeInsets.only(right: 14.0, top: 14.0),
        decoration: BoxDecoration(
          color:
              filterDTO.isSelected! ? AppColors.appTeal() : Colors.transparent,
          border: filterDTO.isSelected!
              ? Border.all(color: Colors.transparent)
              : Border.all(color: AppColors.appTeal()),
          borderRadius: BorderRadius.circular(50.0),
        ),
        child: Text(
          Utils.ammendSentences(filterDTO.item!),
          style: AppFonts.robotoMedium(
            14,
            color: filterDTO.isSelected!
                ? AppColors.appPrimaryWhite()
                : AppColors.appTeal(),
            decoration: TextDecoration.none,
          ),
        ),
      ),
    );
  }

  Widget alertStatusDataItem(
      BuildContext ctx, CustomDqmSortFilterItemSelectionDTO customDTO) {
    return GestureDetector(
      onTap: () {
        setState(() {
          customDTO.isSelected = !customDTO.isSelected!;
        });
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(12.0, 9.0, 12.0, 9.0),
        margin: EdgeInsets.only(right: 14.0, top: 14.0),
        decoration: BoxDecoration(
          color:
              customDTO.isSelected! ? AppColors.appTeal() : Colors.transparent,
          border: customDTO.isSelected!
              ? Border.all(color: Colors.transparent)
              : Border.all(color: AppColors.appTeal()),
          borderRadius: BorderRadius.circular(50.0),
        ),
        child: Text(
          customDTO.item!,
          style: AppFonts.robotoMedium(
            14,
            color: customDTO.isSelected!
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
}
