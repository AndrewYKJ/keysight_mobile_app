import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:keysight_pma/cache/appcache.dart';
import 'package:keysight_pma/const/appcolors.dart';
import 'package:keysight_pma/const/appfonts.dart';
import 'package:keysight_pma/const/constants.dart';
import 'package:keysight_pma/const/utils.dart';
import 'package:keysight_pma/controller/alert/alertReviewFilterTab.dart';
import 'package:keysight_pma/controller/alert/alertReviewPreferedTab.dart';

class AlertReview extends StatefulWidget {
  const AlertReview({Key? key}) : super(key: key);

  @override
  State<AlertReview> createState() => _AlertReviewState();
}

class _AlertReviewState extends State<AlertReview>
    with TickerProviderStateMixin {
  late TabController _nestedTabController;
  int _currentIndex = 0;
  bool? theme_dark = AppCache.sortFilterCacheDTO!.currentTheme;

  @override
  void initState() {
    super.initState();
    Utils.setFirebaseAnalyticsCurrentScreen(
        Constants.ANALYTICS_ALERT_REVIEW_SCREEN);
    _nestedTabController = new TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Theme(
                data: Theme.of(context).copyWith(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                ),
                child: Container(
                  padding: EdgeInsets.only(top: 16.0, bottom: 0.0),
                  child: TabBar(
                    controller: _nestedTabController,
                    indicatorColor: Colors.transparent,
                    unselectedLabelColor: Colors.transparent,
                    isScrollable: true,
                    onTap: (index) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                    tabs: [
                      Tab(
                        child: Container(
                          padding: EdgeInsets.fromLTRB(12.0, 10.0, 12.0, 10.0),
                          decoration: BoxDecoration(
                            color: _currentIndex == 0
                                ? AppColors.appPrimaryYellow()
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Center(
                            child: Text(
                              Utils.getTranslated(
                                  context, 'alertFilterTabName')!,
                              style: AppFonts.robotoMedium(
                                14,
                                color: _currentIndex == 0
                                    ? AppColors.appPrimaryWhite()
                                    : theme_dark!
                                        ? AppColors.appPrimaryWhite()
                                        : AppColorsLightMode.appPrimaryWhite(),
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Tab(
                        child: Container(
                          padding: EdgeInsets.fromLTRB(12.0, 10.0, 12.0, 10.0),
                          decoration: BoxDecoration(
                            color: _currentIndex == 1
                                ? AppColors.appPrimaryYellow()
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Center(
                            child: Text(
                              Utils.getTranslated(
                                  context, 'alertPreferredTabName')!,
                              style: AppFonts.robotoMedium(
                                14,
                                color: _currentIndex == 1
                                    ? AppColors.appPrimaryWhite()
                                    : theme_dark!
                                        ? AppColors.appPrimaryWhite()
                                        : AppColorsLightMode.appPrimaryWhite(),
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height - 251,
              child: TabBarView(
                controller: _nestedTabController,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  AlertReviewFilterTab(),
                  AlertReviewPreferedTab(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
