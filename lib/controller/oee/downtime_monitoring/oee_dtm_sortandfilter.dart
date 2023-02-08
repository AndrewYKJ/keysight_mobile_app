import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:keysight_pma/cache/appcache.dart';
import 'package:keysight_pma/const/appcolors.dart';
import 'package:keysight_pma/const/appfonts.dart';
import 'package:keysight_pma/const/constants.dart';
import 'package:keysight_pma/const/utils.dart';
import 'package:keysight_pma/controller/admin/preferred_setting/custom.dart';

class DTMSortAndFilterScreen extends StatefulWidget {
  final String? menuType;
  final int? currentTab;

  DTMSortAndFilterScreen({Key? key, this.menuType, this.currentTab})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DTMSortAndFilterScreen();
  }
}

class _DTMSortAndFilterScreen extends State<DTMSortAndFilterScreen> {
  List<PDate> dateRange = [
    PDate(rangeName: "By Date", rangeValue: 'Date', isSelected: false),
    PDate(rangeName: "By Week", rangeValue: 'Week', isSelected: false),
    PDate(rangeName: "By Month", rangeValue: 'Month', isSelected: false),
    PDate(rangeName: "By Shift", rangeValue: 'Shift', isSelected: false),
  ];

  bool? theme_dark = AppCache.sortFilterCacheDTO!.currentTheme;

  @override
  void initState() {
    super.initState();
    Utils.setFirebaseAnalyticsCurrentScreen(
        Constants.ANALYTICS_OEE_DOWNTIME_MONITOR_FILTER_SCREEN);
    callCache();
  }

  callCache() {
    if (AppCache.sortFilterCacheDTO!.dtmPreferredRange != null) {
      dateRange.forEach((element) {
        if (element.rangeValue ==
            AppCache.sortFilterCacheDTO!.dtmPreferredRange!) {
          setState(() {
            element.isSelected = true;
          });
        }
      });
    } else {
      setState(() {
        dateRange[0].isSelected = true;
      });
    }
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
              Container(
                padding: EdgeInsets.only(top: 28, bottom: 10),
                child: Text(
                  Utils.getTranslated(context, 'sort_and_filter_timeline')!,
                  style: AppFonts.robotoRegular(
                    16,
                    color: theme_dark!
                        ? AppColors.appGrey2()
                        : AppColorsLightMode.appGrey(),
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                    child: Wrap(
                  children: dateRange.map((e) => dataItem(context, e)).toList(),
                )),
              ),
              Container(
                padding: EdgeInsets.only(top: 14.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            dateRange.forEach((element) {
                              if (element.isSelected == true) {
                                AppCache.sortFilterCacheDTO!.dtmPreferredRange =
                                    element.rangeValue;
                              }
                            });
                          });

                          Navigator.pop(context, true);
                        },
                        child: Container(
                          margin: EdgeInsets.only(left: 90.0, right: 90.0),
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget dataItem(ctx, PDate e) {
    String? title;
    if (e.rangeValue == "Date") {
      title = Utils.getTranslated(context, 'BY_DATE')!;
    } else if (e.rangeValue == "Week") {
      title = Utils.getTranslated(context, 'BY_WEEK')!;
    } else if (e.rangeValue == "Month") {
      title = Utils.getTranslated(context, 'BY_MONTH')!;
    } else {
      title = Utils.getTranslated(context, 'BY_SHIFT')!;
    }
    return GestureDetector(
      onTap: () {
        setState(() {
          dateRange.forEach((element) {
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
          title,
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
}
