import 'package:flutter/material.dart';
import 'package:keysight_pma/cache/appcache.dart';
import 'package:keysight_pma/const/appcolors.dart';
import 'package:keysight_pma/const/appfonts.dart';
import 'package:keysight_pma/const/constants.dart';
import 'package:keysight_pma/const/utils.dart';
import 'package:keysight_pma/controller/oee/dashboard/oee_dashboardscreen.dart';
import 'package:keysight_pma/controller/oee/downtime_monitoring/oee_dtmscreen.dart';
import 'package:keysight_pma/controller/oee/summary/oee_summaryscreen.dart';

class OeeBase extends StatefulWidget {
  final int? currentTab;
  const OeeBase({
    Key? key,
    this.currentTab,
  }) : super(key: key);

  @override
  State<OeeBase> createState() => _OeeBaseState();
}

class _OeeBaseState extends State<OeeBase> {
  int currentTab = 0;
  late TabController _tabController;
  bool? isDarkTheme = AppCache.sortFilterCacheDTO!.currentTheme;

  @override
  void initState() {
    Utils.setFirebaseAnalyticsCurrentScreen(Constants.ANALYTICS_OEE_SCREEN);
    (widget.currentTab != null) ? currentTab = widget.currentTab! : 0;
    print(currentTab);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: currentTab,
      length: 3,
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
              backgroundColor: isDarkTheme!
                  ? AppColors.serverAppBar()
                  : AppColorsLightMode.serverAppBar(),
              title: Text(
                Utils.getTranslated(context, 'ooe_title')!,
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
                      Utils.getTranslated(context, "oee_dashboard")!,
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
                      Utils.getTranslated(context, "oee_summary")!,
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
                      Utils.getTranslated(context, "oee_downtime_monitoring")!,
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
                ],
              ),
            ),
            body: SafeArea(
                child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.only(bottom: 20.0),
              child: Stack(children: [
                TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    OeeDashboardScreen(),
                    OeeSummaryScreen(),
                    OeeDtmScreen()
                  ],
                ),
                //   Align(
                //     alignment: Alignment.bottomCenter,
                //     child: TextButton(
                //       onPressed: () async {
                //         final result = await Navigator.pushNamed(
                //           context,
                //           AppRoutes.sortAndFilterRoute,
                //           arguments: SortFilterArguments(
                //             menuType: Constants.HOME_MENU_OEE,
                //             currentTab: currentTab,
                //           ),
                //         );
                //         print(currentTab);
                //         if (result != null && result as bool) {
                //           setState(() {});
                //         }
                //       },
                //       child: Container(
                //         padding: EdgeInsets.all(10.0),
                //         decoration: BoxDecoration(
                //           borderRadius: BorderRadius.circular(50.0),
                //           color: AppColors.appTeal(),
                //         ),
                //         child: Row(
                //           mainAxisAlignment: MainAxisAlignment.center,
                //           crossAxisAlignment: CrossAxisAlignment.center,
                //           mainAxisSize: MainAxisSize.min,
                //           children: [
                //             Image.asset(
                //                 Constants.ASSET_IMAGES + 'filter_icon.png'),
                //             SizedBox(width: 10.0),
                //             Text(
                //               Utils.getTranslated(context, 'sort_and_filter')!,
                //               style: AppFonts.robotoMedium(
                //                 14,
                //                 color: AppColors.appPrimaryWhite(),
                //                 decoration: TextDecoration.none,
                //               ),
                //             ),
                //             /* Container(
                //               margin: EdgeInsets.only(left: 10.0),
                //               padding: EdgeInsets.all(8.0),
                //               decoration: BoxDecoration(
                //                 color: AppColors.appRed(),
                //                 shape: BoxShape.circle,
                //               ),
                //               child: Text(
                //                 '2',
                //                 style: AppFonts.robotoMedium(
                //                   14,
                //                   color: AppColors.appPrimaryWhite(),
                //                   decoration: TextDecoration.none,
                //                 ),
                //               ),
                //             )*/
                //           ],
                //         ),
                //       ),
                //     ),
                //   ),
                // ],
              ]),
            )));
      }),
    );
  }
}
