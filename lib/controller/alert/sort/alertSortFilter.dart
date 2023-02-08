import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:keysight_pma/cache/appcache.dart';
import 'package:keysight_pma/const/appcolors.dart';
import 'package:keysight_pma/const/appfonts.dart';
import 'package:keysight_pma/const/constants.dart';
import 'package:keysight_pma/const/utils.dart';
import 'package:keysight_pma/model/customize.dart';

class AlertSortAndFilterScreen extends StatefulWidget {
  final String? menuType;
  final int? currentTab;

  AlertSortAndFilterScreen({Key? key, this.menuType, this.currentTab})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AlertSortAndFilterScreen();
  }
}

class _AlertSortAndFilterScreen extends State<AlertSortAndFilterScreen> {
  List alertType = [
    'Component Anomaly',
    'CPK Alert Anomalies',
    'Degradation Anomaly'
  ];
  List statusType = ['Actual', 'Dispose'];
  List testType = [
    'Capacitor',
    'Diode',
    'Inductor',
    'Jumper',
    'Measure',
    'Resistor'
  ];
  List workflowType = ['To Do', 'Closed'];
  List priorityType = ['Critical', 'Low', 'Medium'];
  bool? theme_dark = AppCache.sortFilterCacheDTO!.currentTheme;

  @override
  void initState() {
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
                    children: [],
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
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {});
                        },
                        child: Container(
                          padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                          decoration: BoxDecoration(
                              color: Colors.transparent,
                              border: Border.all(
                                color: theme_dark!
                                    ? AppColors.appGreyD3()
                                    : AppColorsLightMode.appPrimaryYellow(),
                              ),
                              borderRadius: BorderRadius.circular(2.0)),
                          child: Text(
                            Utils.getTranslated(
                                context, 'sort_and_filter_clear_btn')!,
                            style: AppFonts.robotoMedium(
                              15,
                              color: theme_dark!
                                  ? AppColors.appPrimaryWhite()
                                  : AppColorsLightMode.appPrimaryYellow(),
                              decoration: TextDecoration.none,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16.0),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context, true);
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
                  ],
                ),
              ),
            ],
          ),
        ),
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
              Wrap(
                children:
                    workflowType.map((e) => companyDataItem(ctx, e)).toList(),
              ),
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
                Wrap(
                  children:
                      workflowType.map((e) => companyDataItem(ctx, e)).toList(),
                ),
                divider(ctx),
              ],
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
          AppCache.sortFilterCacheDTO!.preferredCompany = customDTO.value;
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
