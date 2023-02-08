import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:keysight_pma/cache/appcache.dart';
import 'package:keysight_pma/const/appcolors.dart';
import 'package:keysight_pma/const/appfonts.dart';
import 'package:keysight_pma/const/constants.dart';
import 'package:keysight_pma/const/utils.dart';
import 'package:keysight_pma/controller/digital_quality/test_result/analog.dart';
import 'package:keysight_pma/controller/digital_quality/test_result/functional.dart';
import 'package:keysight_pma/controller/digital_quality/test_result/pins.dart';
import 'package:keysight_pma/controller/digital_quality/test_result/shorts.dart';
import 'package:keysight_pma/controller/digital_quality/test_result/summary.dart';
import 'package:keysight_pma/controller/digital_quality/test_result/vtep.dart';
import 'package:keysight_pma/controller/digital_quality/test_result/xvtep.dart';
import 'package:keysight_pma/model/customize.dart';
import 'package:keysight_pma/model/dqm/boardresult_summary_byproject.dart';
import 'package:keysight_pma/model/dqm/custom.dart';
import 'package:keysight_pma/model/dqm/failure_component_by_fixture.dart';
import 'package:keysight_pma/model/dqm/test_result_cpk_analog.dart';
import 'package:keysight_pma/model/dqm/test_time_distribution.dart';
import 'package:keysight_pma/model/js/js.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

class DigitalQualityTestResultScreen extends StatefulWidget {
  DigitalQualityTestResultScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DigitalQualityTestResultScreen();
  }
}

class _DigitalQualityTestResultScreen
    extends State<DigitalQualityTestResultScreen>
    with TickerProviderStateMixin {
  List<DqmTestResultSelectionDTO> selectionList = [
    DqmTestResultSelectionDTO(
        dataName: 'Summary', dataValue: 'summary', isSelected: true),
    DqmTestResultSelectionDTO(
        dataName: 'Analog', dataValue: 'analog', isSelected: false),
    DqmTestResultSelectionDTO(
        dataName: 'Pins', dataValue: 'pins', isSelected: false),
    DqmTestResultSelectionDTO(
        dataName: 'Shorts', dataValue: 'shorts', isSelected: false),
    DqmTestResultSelectionDTO(
        dataName: 'VTEP', dataValue: 'vtep', isSelected: false),
  ];

  List<String> tabList = ["dqm_tab_summary"];

  late String selectedDataName;
  late TabController _nestedTabController;
  int _currentIndex = 0;
  String currentTab = '';
  bool? isDarkTheme = AppCache.sortFilterCacheDTO!.currentTheme;

  @override
  void initState() {
    super.initState();
    Utils.setFirebaseAnalyticsCurrentScreen(
        Constants.ANALYTICS_DQM_TEST_RESULT_SCREEN);
    _nestedTabController =
        new TabController(length: tabList.length, vsync: this);
    this.selectedDataName = selectionList[0].dataValue!;
    FocusManager.instance.primaryFocus?.unfocus();
  }

  refresh() {
    setState(() {
      tabList.clear();
      tabList.add("dqm_tab_summary");
      _currentIndex = 0;
      currentTab = tabList[0];
      if (AppCache.sortFilterCacheDTO!.projectVersionObj != null) {
        if (AppCache.sortFilterCacheDTO!.projectVersionObj!.isIct!) {
          tabList.add("dqm_testresult_analog");
        }

        if (AppCache.sortFilterCacheDTO!.projectVersionObj!.isEdl!) {
          tabList.add("dqm_testresult_tab_pins");
          tabList.add("dqm_testresult_tab_shorts");
          tabList.add("dqm_testresult_tab_vtep");
        }

        if (AppCache.sortFilterCacheDTO!.projectVersionObj!.isfunctional!) {
          tabList.add("dqm_testresult_tab_functional");
        }

        if (AppCache.sortFilterCacheDTO!.projectVersionObj!.isXvtep!) {
          tabList.add("dqm_testresult_tab_xvtep");
        }
      }

      _nestedTabController = TabController(
        length: tabList.length,
        vsync: this,
      );

      if (tabList.elementAt(_currentIndex) == currentTab) {
        _nestedTabController.animateTo(_currentIndex);
      } else {
        _nestedTabController.animateTo(0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: TabBar(
                controller: _nestedTabController,
                indicatorColor: Colors.transparent,
                unselectedLabelColor: Colors.transparent,
                isScrollable: true,
                onTap: (index) {
                  setState(() {
                    _currentIndex = index;
                    currentTab = tabList[index];
                  });
                },
                tabs: tabList
                    .asMap()
                    .entries
                    .map(
                      (e) => Tab(
                        child: Container(
                          padding: EdgeInsets.fromLTRB(12.0, 10.0, 12.0, 10.0),
                          decoration: BoxDecoration(
                            color: _currentIndex == e.key
                                ? AppColors.appPrimaryYellow()
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Center(
                            child: Text(
                              Utils.getTranslated(context, e.value)!,
                              style: AppFonts.robotoMedium(
                                14,
                                color: _currentIndex == e.key
                                    ? AppColors.appPrimaryWhite()
                                    : isDarkTheme!
                                        ? AppColors.appPrimaryWhite()
                                        : AppColorsLightMode.appPrimaryWhite(),
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.70,
              child: TabBarView(
                controller: _nestedTabController,
                physics: NeverScrollableScrollPhysics(),
                children: tabList
                    .asMap()
                    .entries
                    .map(
                      (e) => e.value == "dqm_tab_summary"
                          ? TestResultSummaryScreen(notifyParent: refresh)
                          : e.value == "dqm_testresult_analog"
                              ? TestResultAnalogScreen(notifyParent: refresh)
                              : e.value == "dqm_testresult_tab_pins"
                                  ? TestResultPinsScreen(notifyParent: refresh)
                                  : e.value == "dqm_testresult_tab_shorts"
                                      ? TestResultShortsScreen(
                                          notifyParent: refresh)
                                      : e.value == "dqm_testresult_tab_vtep"
                                          ? TestResultVTEPScreen(
                                              notifyParent: refresh)
                                          : e.value ==
                                                  "dqm_testresult_tab_functional"
                                              ? TestResultFunctionalScreen(
                                                  notifyParent: refresh)
                                              : e.value ==
                                                      "dqm_testresult_tab_xvtep"
                                                  ? TestResultXVTEPScreen(
                                                      notifyParent: refresh)
                                                  : Container(),
                    )
                    .toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
