import 'package:flutter/material.dart';
import 'package:keysight_pma/const/appcolors.dart';
import 'package:keysight_pma/const/appfonts.dart';
import 'package:keysight_pma/const/constants.dart';
import 'package:keysight_pma/const/utils.dart';
import 'package:keysight_pma/controller/alert/alertCaseHistoryList.dart';
import 'package:keysight_pma/controller/alert/alertReviewTab.dart';

import '../../cache/appcache.dart';

class AlertBase extends StatefulWidget {
  const AlertBase({
    Key? key,
  }) : super(key: key);

  @override
  State<AlertBase> createState() => _AlertBaseState();
}

class _AlertBaseState extends State<AlertBase> with TickerProviderStateMixin {
  int currentTab = 0;
  int sortAlignment = 168;
  var bottomRange;
  bool? theme_dark = AppCache.sortFilterCacheDTO!.currentTheme;

  TabBar get _tabBar => TabBar(
        unselectedLabelColor: theme_dark!
            ? AppColors.appPrimaryWhite()
            : AppColorsLightMode.appPrimaryWhite(),
        indicatorColor: AppColors.appBlue(),
        isScrollable: true,
        tabs: [
          Tab(
            child: Text(
              Utils.getTranslated(context, "alert_review")!,
              style: AppFonts.robotoMedium(
                13,
                color: currentTab == 0
                    ? AppColors.appBlue()
                    : theme_dark!
                        ? AppColors.appPrimaryWhite()
                        : AppColorsLightMode.appPrimaryWhite(),
                decoration: TextDecoration.none,
              ),
            ),
          ),
          Tab(
            child: Text(
              Utils.getTranslated(context, "alert_case_history")!,
              style: AppFonts.robotoMedium(
                13,
                color: currentTab == 1
                    ? AppColors.appBlue()
                    : theme_dark!
                        ? AppColors.appPrimaryWhite()
                        : AppColorsLightMode.appPrimaryWhite(),
                decoration: TextDecoration.none,
              ),
            ),
          ),
        ],
      );

  @override
  void initState() {
    super.initState();
    Utils.setFirebaseAnalyticsCurrentScreen(Constants.ANALYTICS_ALERT_SCREEN);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Builder(builder: (BuildContext context) {
        final TabController tabController = DefaultTabController.of(context)!;
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
            backgroundColor: theme_dark!
                ? AppColors.serverAppBar()
                : AppColorsLightMode.serverAppBar(),
            title: Text(
              Utils.getTranslated(context, "alert")!,
              style: AppFonts.robotoRegular(
                20,
                color: theme_dark!
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
                theme_dark!
                    ? Constants.ASSET_IMAGES + 'back_bttn.png'
                    : Constants.ASSET_IMAGES_LIGHT + 'back_bttn.png',
              ),
            ),
            bottom: PreferredSize(
              preferredSize: _tabBar.preferredSize,
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(left: 16.0, right: 16.0),
                color: theme_dark!
                    ? AppColors.serverAppBar()
                    : AppColorsLightMode.appPrimaryBlack(),
                child: _tabBar,
              ),
            ),
          ),
          body: SafeArea(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.only(bottom: 20.0),
              child: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                children: [
                  AlertReview(),
                  AlertCaseHistoryList(),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
