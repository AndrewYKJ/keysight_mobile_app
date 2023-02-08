import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:keysight_pma/cache/appcache.dart';
import 'package:keysight_pma/const/appcolors.dart';
import 'package:keysight_pma/const/appfonts.dart';
import 'package:keysight_pma/const/constants.dart';
import 'package:keysight_pma/const/utils.dart';
import 'package:keysight_pma/model/arguments/dqm_argument.dart';
import 'package:keysight_pma/model/customize.dart';

class DqmTestResultDetailSortAndFilterScreen extends StatefulWidget {
  final String? filterBy;
  final int? fromWhere;
  final List<CustomDqmSortFilterProjectsDTO>? finalDispositionList;
  final String? mode;
  DqmTestResultDetailSortAndFilterScreen(
      {Key? key,
      this.filterBy,
      this.fromWhere,
      this.finalDispositionList,
      this.mode})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DqmTestResultDetailSortAndFilterScreen();
  }
}

class _DqmTestResultDetailSortAndFilterScreen
    extends State<DqmTestResultDetailSortAndFilterScreen> {
  String selectedProject = '';
  bool? theme_dark = AppCache.sortFilterCacheDTO!.currentTheme;
  bool isSelectAll = true;

  String filtering = '';
  String appBarTitle = '';
  String filterMode = '';
  List<CustomDTO> volumeFilterList = [
    CustomDTO(
        displayName: 'filter_by_equipment',
        value: Constants.FILTER_BY_CHART_VOLUME_EQUIPMENT,
        appBarTitle: 'dqm_testresult_volume_and_yield_by_equipment'),
    CustomDTO(
        displayName: 'filter_by_equipment_fixture',
        value: Constants.FILTER_BY_CHART_VOLUME_EQUIPMENT_FIXTURE,
        appBarTitle: 'dqm_testresult_volume_and_yield_fixture_by_equipment'),
  ];
  List<CustomDTO> testTimeFilterList = [
    CustomDTO(
        displayName: 'filter_by_pass_test_time',
        value: Constants.FILTER_BY_CHART_TEST_TIME_PASS,
        appBarTitle: 'dqm_testresult_pass_test_time_distribution'),
    CustomDTO(
        displayName: 'filter_by_fail_test_time',
        value: Constants.FILTER_BY_CHART_TEST_TIME_FAIL,
        appBarTitle: 'dqm_testresult_fail_test_time_distribution'),
  ];
  List<CustomDTO> componentFailureFilterList = [
    CustomDTO(
        displayName: 'filter_by_testtype_fixture_fail',
        value: Constants.FILTER_BY_CHART_TEST_TYPE_FAIL,
        appBarTitle: 'dqm_testresult_failure_count_by_test_type_fixture_id_f'),
    CustomDTO(
        displayName: 'filter_by_testtype_fixture_first_failure',
        value: Constants.FILTER_BY_CHART_TEST_TYPE_FIRST_FAIL,
        mode: Constants.MODE_FIRST_FAIL,
        appBarTitle:
            'dqm_testresult_failure_count_by_test_type_fixture_id_first_f'),
    CustomDTO(
        displayName: 'filter_by_testtype_fixture_false_failure',
        value: Constants.FILTER_BY_CHART_TEST_TYPE_FALSE_FAIL,
        mode: Constants.MODE_FALSE_FAIL,
        appBarTitle:
            'dqm_testresult_failure_count_by_test_type_fixture_id_false_f'),
    CustomDTO(
        displayName: 'filter_by_pin_retest_fixture',
        value: Constants.FILTER_BY_CHART_PIN_RETEST,
        appBarTitle: 'dqm_testresult_pin_retest_count_by_fixture_id'),
    CustomDTO(
        displayName: 'filter_by_worst_testname_fail',
        value: Constants.FILTER_BY_CHART_WORST_TESTNAME_FAIL,
        mode: Constants.MODE_FAIL,
        appBarTitle: 'dqm_testresult_worst_testname_fail'),
    CustomDTO(
        displayName: 'filter_by_worst_testname_first_failure',
        value: Constants.FILTER_BY_CHART_WORST_TESTNAME_FIRST_FAIL,
        mode: Constants.MODE_FIRST_FAIL,
        appBarTitle: 'dqm_testresult_worst_testname_first_fail'),
    CustomDTO(
        displayName: 'filter_by_worst_testname_false_failure',
        value: Constants.FILTER_BY_CHART_WORST_TESTNAME_FALSE_FAIL,
        mode: Constants.MODE_FALSE_FAIL,
        appBarTitle: 'dqm_testresult_worst_testname_false_fail'),
  ];

  @override
  void initState() {
    super.initState();
    Utils.setFirebaseAnalyticsCurrentScreen(
        Constants.ANALYTICS_DQM_TEST_RESULT_WORST_TESTNAME_FILTER_SCREEN);
    setState(() {
      this.filtering = widget.filterBy!;
      if (widget.finalDispositionList != null) {
        widget.finalDispositionList!.forEach((element) {
          if (element.isSelected == false) {
            this.isSelectAll = false;
          }
        });
      }
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
                      filterBy(context),
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
                      DqmTestResultArguments arguments = DqmTestResultArguments(
                        filterBy: this.filtering,
                        appBarTitle: this.appBarTitle,
                        finalDispositionList: widget.finalDispositionList,
                        mode: this.filterMode,
                      );
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
                //           setState(() {
                //             if (widget.fromWhere ==
                //                 Constants.TEST_RESULT_CHART_VOLUME) {
                //               this.filtering = volumeFilterList[0].value!;
                //             } else if (widget.fromWhere ==
                //                 Constants.TEST_RESULT_CHART_TEST_TIME) {
                //               this.filtering = testTimeFilterList[0].value!;
                //             } else if (widget.fromWhere ==
                //                 Constants.TEST_RESULT_CHART_FINAL_DISPOSITION) {
                //               widget.finalDispositionList!.forEach((element) {
                //                 element.isSelected = true;
                //               });
                //             } else if (widget.fromWhere ==
                //                 Constants.TEST_RESULT_CHART_COMPONENT_FAILURE) {
                //               this.filtering =
                //                   componentFailureFilterList[0].value!;
                //             }
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
                //           DqmTestResultArguments arguments =
                //               DqmTestResultArguments(
                //             filterBy: this.filtering,
                //             appBarTitle: this.appBarTitle,
                //             finalDispositionList: widget.finalDispositionList,
                //             mode: this.filterMode,
                //           );
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

  Widget filterBy(BuildContext ctx) {
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
                      ctx, 'dqm_testresult_probe_finder_filterby')!,
                  style: AppFonts.robotoRegular(
                    16,
                    color: theme_dark!
                        ? AppColors.appGrey2()
                        : AppColorsLightMode.appGrey(),
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
              (widget.fromWhere ==
                      Constants.TEST_RESULT_CHART_FINAL_DISPOSITION)
                  ? GestureDetector(
                      onTap: () {
                        setState(() {
                          this.isSelectAll = !this.isSelectAll;
                          if (this.isSelectAll) {
                            widget.finalDispositionList!.forEach((element) {
                              element.isSelected = true;
                            });
                          } else {
                            widget.finalDispositionList!.forEach((element) {
                              element.isSelected = false;
                            });
                          }
                        });
                      },
                      child: Text(
                        this.isSelectAll
                            ? Utils.getTranslated(ctx, 'deselect_all')!
                            : Utils.getTranslated(ctx, 'select_all')!,
                        style: AppFonts.robotoRegular(
                          16,
                          color: theme_dark!
                              ? AppColors.appGrey2()
                              : AppColorsLightMode.appGrey(),
                          decoration: TextDecoration.none,
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
          SizedBox(height: 8.0),
          filterList(ctx),
        ],
      ),
    );
  }

  Widget filterList(BuildContext ctx) {
    if (widget.fromWhere == Constants.TEST_RESULT_CHART_VOLUME) {
      return Wrap(
        children: volumeFilterList.map((e) => filterItem(ctx, e)).toList(),
      );
    } else if (widget.fromWhere == Constants.TEST_RESULT_CHART_TEST_TIME) {
      return Wrap(
        children: testTimeFilterList.map((e) => filterItem(ctx, e)).toList(),
      );
    } else if (widget.fromWhere ==
        Constants.TEST_RESULT_CHART_FINAL_DISPOSITION) {
      return Wrap(
        children: widget.finalDispositionList!
            .map((e) => filterFinalDispositionItem(ctx, e))
            .toList(),
      );
    } else if (widget.fromWhere ==
        Constants.TEST_RESULT_CHART_COMPONENT_FAILURE) {
      return Wrap(
        children:
            componentFailureFilterList.map((e) => filterItem(ctx, e)).toList(),
      );
    }

    return Container();
  }

  Widget filterItem(BuildContext ctx, CustomDTO customDTO) {
    return GestureDetector(
      onTap: () {
        setState(() {
          this.filtering = customDTO.value!;
          this.appBarTitle = customDTO.appBarTitle!;
          if (Utils.isNotEmpty(customDTO.mode)) {
            this.filterMode = customDTO.mode!;
          } else {
            this.filterMode = '';
          }
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

  Widget filterFinalDispositionItem(
      BuildContext ctx, CustomDqmSortFilterProjectsDTO customDTO) {
    return GestureDetector(
      onTap: () {
        setState(() {
          customDTO.isSelected = !customDTO.isSelected!;
          this.isSelectAll =
              Utils.isSelectAll(otherItemList: widget.finalDispositionList);
        });
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(12.0, 9.0, 12.0, 9.0),
        margin: EdgeInsets.only(right: 14.0, top: 14.0),
        decoration: BoxDecoration(
          color: (customDTO.isSelected!)
              ? AppColors.appTeal()
              : Colors.transparent,
          border: (customDTO.isSelected!)
              ? Border.all(color: Colors.transparent)
              : Border.all(color: AppColors.appTeal()),
          borderRadius: BorderRadius.circular(50.0),
        ),
        child: Text(
          customDTO.projectId!,
          style: AppFonts.robotoMedium(
            14,
            color: (customDTO.isSelected!)
                ? AppColors.appPrimaryWhite()
                : AppColors.appTeal(),
            decoration: TextDecoration.none,
          ),
        ),
      ),
    );
  }
}
