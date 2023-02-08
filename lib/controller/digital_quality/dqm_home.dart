import 'package:flutter/material.dart';
import 'package:keysight_pma/cache/appcache.dart';
import 'package:keysight_pma/const/appcolors.dart';
import 'package:keysight_pma/const/appfonts.dart';
import 'package:keysight_pma/const/constants.dart';
import 'package:keysight_pma/const/utils.dart';
import 'package:keysight_pma/controller/digital_quality/dashboard/dqm_dashboard.dart';
import 'package:keysight_pma/controller/digital_quality/rma/dqm_rma.dart';
import 'package:keysight_pma/controller/digital_quality/summary/dqm_summary.dart';
import 'package:keysight_pma/controller/digital_quality/test_result/dqm_testresult.dart';

class DigitalQualityHomeScreen extends StatefulWidget {
  final int? currentTab;
  DigitalQualityHomeScreen({Key? key, this.currentTab}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DigitalQualityHomeScreen();
  }
}

class _DigitalQualityHomeScreen extends State<DigitalQualityHomeScreen> {
  int currentTab = 0;
  late TabController tabController;
  bool? isDarkTheme = AppCache.sortFilterCacheDTO!.currentTheme;

  @override
  void initState() {
    super.initState();
    if (widget.currentTab != null) {
      setState(() {
        currentTab = widget.currentTab!;
      });
    } else {
      if (AppCache.isFromAlert) {
        setState(() {
          currentTab = 2;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      initialIndex: currentTab,
      child: Builder(builder: (BuildContext context) {
        tabController = DefaultTabController.of(context)!;
        tabController.addListener(() {
          if (tabController.indexIsChanging) {
            setState(() {
              this.currentTab = tabController.index;
            });
          }
        });
        return Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            centerTitle: true,
            backgroundColor: isDarkTheme!
                ? AppColors.serverAppBar()
                : AppColorsLightMode.serverAppBar(),
            title: Text(
              Utils.getTranslated(context, "dqm_appbar_title")!,
              style: AppFonts.robotoRegular(
                20,
                color: isDarkTheme!
                    ? AppColors.appGrey()
                    : AppColorsLightMode.appGrey(),
                decoration: TextDecoration.none,
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
            bottom: TabBar(
              indicatorColor: AppColors.appBlue(),
              tabs: [
                Tab(
                  child: Text(
                    Utils.getTranslated(context, "dqm_tab_dashboard")!,
                    style: AppFonts.robotoMedium(
                      13,
                      color: currentTab == 0
                          ? AppColors.appBlue()
                          : isDarkTheme!
                              ? AppColors.appPrimaryWhite()
                              : AppColorsLightMode.appGrey(),
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    Utils.getTranslated(context, "dqm_tab_summary")!,
                    style: AppFonts.robotoMedium(
                      13,
                      color: currentTab == 1
                          ? AppColors.appBlue()
                          : isDarkTheme!
                              ? AppColors.appPrimaryWhite()
                              : AppColorsLightMode.appGrey(),
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    Utils.getTranslated(context, "dqm_tab_testresult")!,
                    style: AppFonts.robotoMedium(
                      13,
                      color: currentTab == 2
                          ? AppColors.appBlue()
                          : isDarkTheme!
                              ? AppColors.appPrimaryWhite()
                              : AppColorsLightMode.appGrey(),
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    Utils.getTranslated(context, "dqm_tab_rma")!,
                    style: AppFonts.robotoMedium(
                      14,
                      color: currentTab == 3
                          ? AppColors.appBlue()
                          : isDarkTheme!
                              ? AppColors.appPrimaryWhite()
                              : AppColorsLightMode.appGrey(),
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: SafeArea(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: TabBarView(
                controller: tabController,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  DigitalQualityDashboardScreen(tabController: tabController),
                  DigitalQualitySummaryScreen(),
                  DigitalQualityTestResultScreen(),
                  DigitalQualityRmaScreen(),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
