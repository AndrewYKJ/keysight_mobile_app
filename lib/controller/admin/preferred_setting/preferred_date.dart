import 'package:flutter/material.dart';
import 'package:keysight_pma/cache/appcache.dart';
import 'package:keysight_pma/const/appcolors.dart';
import 'package:keysight_pma/const/appfonts.dart';
import 'package:keysight_pma/const/constants.dart';
import 'package:keysight_pma/const/utils.dart';
import 'package:keysight_pma/controller/admin/preferred_setting/custom.dart';
import 'package:keysight_pma/model/user.dart';
import 'package:keysight_pma/routes/approutes.dart';

class PreferredDate extends StatefulWidget {
  final String? preferred_date;
  PreferredDate({Key? key, this.preferred_date}) : super(key: key);

  @override
  State<PreferredDate> createState() => _PreferredDateState();
}

class _PreferredDateState extends State<PreferredDate> {
  String? returnValue;
  bool isDays = true;
  List<PDate> dateList = [
    PDate(rangeName: 'Today', rangeValue: 'today', isSelected: false),
    PDate(rangeName: 'Yesterday', rangeValue: 'yesterday', isSelected: false),
    PDate(rangeName: 'Current Week', rangeValue: 'week', isSelected: false),
    PDate(rangeName: 'Current Month', rangeValue: 'month', isSelected: false),
    PDate(rangeName: 'Select By Days', rangeValue: '', isSelected: false),
  ];
  String? selectedDays;
  UserDataDTO? user_info;
  bool? theme_dark;
  @override
  void initState() {
    super.initState();
    Utils.setFirebaseAnalyticsCurrentScreen(
        Constants.ANALYTICS_ADMIN_PREFERRED_DATE_SCREEN);
    user_info = AppCache.me!.data;
    print(widget.preferred_date);
    setState(() {
      if (widget.preferred_date != '') {
        dateList.forEach((element) {
          if (element.rangeValue == widget.preferred_date) {
            element.isSelected = true;
            isDays = false;
          }
        });
        if (isDays) {
          selectedDays = widget.preferred_date;
          returnValue = widget.preferred_date;
        }
      } else {
        dateList.forEach((element) {
          if (element.rangeValue == user_info!.preferredDays) {
            element.isSelected = true;
            isDays = false;
          }
        });
        if (isDays) {
          selectedDays = user_info!.preferredDays;
          returnValue = user_info!.preferredDays;
        }
      }
      theme_dark = AppCache.sortFilterCacheDTO!.currentTheme;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
              theme_dark!
                  ? AppColors.serverAppBar()
                  : AppColorsLightMode.serverAppBar(),
              theme_dark!
                  ? AppColors.serverAppBar()
                  : AppColorsLightMode.serverAppBar(),
            ]))),
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          Utils.getTranslated(context, 'preferredSetting_date')!,
          style: AppFonts.robotoRegular(20,
              color: theme_dark!
                  ? AppColors.appGrey()
                  : AppColorsLightMode.appGrey(),
              decoration: TextDecoration.none),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop(returnValue);
            },
            icon: Image.asset(
              theme_dark!
                  ? Constants.ASSET_IMAGES + 'back_bttn.png'
                  : Constants.ASSET_IMAGES_LIGHT + 'back_bttn.png',
            )),
      ),
      body: Container(
          margin: EdgeInsets.only(top: 12, left: 16, right: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: dateList.map((e) => dataItem(context, e)).toList(),
          )),
    );
  }

  Widget dataItem(BuildContext context, PDate e) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        (e.rangeName != 'Select By Days')
            ? GestureDetector(
                onTap: () {
                  dateList.forEach((value) {
                    value.isSelected = false;
                  });
                  setState(() {
                    isDays = false;
                    e.isSelected = true;
                    returnValue = e.rangeValue;
                  });
                },
                child: Container(
                  padding: EdgeInsets.only(top: 12, right: 20, bottom: 10),
                  color: Colors.transparent,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          e.rangeName!,
                          style: AppFonts.robotoRegular(16,
                              color: theme_dark!
                                  ? AppColors.appGrey2()
                                  : AppColorsLightMode.appGrey(),
                              decoration: TextDecoration.none),
                        ),
                        (e.isSelected!)
                            ? Image.asset(
                                theme_dark!
                                    ? Constants.ASSET_IMAGES + 'tick_icon.png'
                                    : Constants.ASSET_IMAGES_LIGHT +
                                        'tick_icon.png',
                                height: 17,
                              )
                            : Text(''),
                      ]),
                ),
              )
            : GestureDetector(
                onTap: () async {
                  final value =
                      await Navigator.pushNamed(context, AppRoutes.select_days);
                  if (value != null) {
                    setState(() {
                      dateList.forEach((value) {
                        value.isSelected = false;
                      });
                      isDays = true;
                      selectedDays = value.toString();
                      returnValue = selectedDays;
                    });
                  }
                },
                child: Container(
                  padding: EdgeInsets.only(top: 12, right: 20, bottom: 10),
                  color: Colors.transparent,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          Utils.getTranslated(
                              context, 'preferredSetting_selectbydate')!,
                          style: AppFonts.robotoRegular(16,
                              color: theme_dark!
                                  ? AppColors.appGrey2()
                                  : AppColorsLightMode.appGrey(),
                              decoration: TextDecoration.none),
                        ),
                        (isDays)
                            ? Text(
                                '$selectedDays Days',
                                style: AppFonts.robotoRegular(16,
                                    color: theme_dark!
                                        ? AppColors.appGrey2()
                                        : AppColorsLightMode.appGrey(),
                                    decoration: TextDecoration.none),
                              )
                            : Image.asset(
                                theme_dark!
                                    ? Constants.ASSET_IMAGES + 'next_bttn.png'
                                    : Constants.ASSET_IMAGES_LIGHT +
                                        'next_bttn.png',
                                height: 17,
                              )
                      ]),
                ),
              ),
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: Divider(
            color: theme_dark!
                ? AppColors.appDividerColor()
                : AppColorsLightMode.appDividerColor(),
          ),
        ),
      ],
    );
  }
}

/*Column(children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _english = true;

                days = null;
              });
            },
            child: Container(
              padding: EdgeInsets.only(top: 12, right: 20, bottom: 10),
              color: Colors.transparent,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Today',
                      style: AppFonts.robotoRegular(16,
                          color: theme_dark!
                                  ? AppColors.appGrey2()
                                  : AppColorsLightMode.appGrey(),
                          decoration: TextDecoration.none),
                    ),
                    (_english)
                        ? Image.asset(
                            Constants.ASSET_IMAGES + 'tick_icon.png',
                            height: 17,
                          )
                        : Text(''),
                  ]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: Divider(
              color: theme_dark!
                          ? AppColors.appDividerColor()
                          : AppColorsLightMode.appDividerColor(),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _english = false;

                days = null;
              });
            },
            child: Container(
              padding: EdgeInsets.only(top: 12, right: 20, bottom: 10),
              color: Colors.transparent,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Yesterday',
                      style: AppFonts.robotoRegular(16,
                          color: theme_dark!
                                  ? AppColors.appGrey2()
                                  : AppColorsLightMode.appGrey(),
                          decoration: TextDecoration.none),
                    ),
                    (!_english)
                        ? Image.asset(
                            Constants.ASSET_IMAGES + 'tick_icon.png',
                            height: 17,
                          )
                        : Text(''),
                  ]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: Divider(
              color: theme_dark!
                          ? AppColors.appDividerColor()
                          : AppColorsLightMode.appDividerColor(),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _english = false;

                days = null;
              });
            },
            child: Container(
              padding: EdgeInsets.only(top: 12, right: 20, bottom: 10),
              color: Colors.transparent,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Current Week',
                      style: AppFonts.robotoRegular(16,
                          color: theme_dark!
                                  ? AppColors.appGrey2()
                                  : AppColorsLightMode.appGrey(),
                          decoration: TextDecoration.none),
                    ),
                    (!_english)
                        ? Image.asset(
                            Constants.ASSET_IMAGES + 'tick_icon.png',
                            height: 17,
                          )
                        : Text(''),
                  ]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: Divider(
              color: theme_dark!
                          ? AppColors.appDividerColor()
                          : AppColorsLightMode.appDividerColor(),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _english = false;
                days = null;
              });
            },
            child: Container(
              padding: EdgeInsets.only(top: 12, right: 20, bottom: 10),
              color: Colors.transparent,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Current Month',
                      style: AppFonts.robotoRegular(16,
                          color: theme_dark!
                                  ? AppColors.appGrey2()
                                  : AppColorsLightMode.appGrey(),
                          decoration: TextDecoration.none),
                    ),
                    (!_english)
                        ? Image.asset(
                            Constants.ASSET_IMAGES + 'tick_icon.png',
                            height: 17,
                          )
                        : Text(''),
                  ]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: Divider(
              color: theme_dark!
                          ? AppColors.appDividerColor()
                          : AppColorsLightMode.appDividerColor(),
            ),
          ),
          GestureDetector(
            onTap: () async {
              final value =
                  await Navigator.pushNamed(context, AppRoutes.select_days);
              // print(value);
              setState(() {
                days = value.toString();
              });
            },
            child: Container(
              padding: EdgeInsets.only(top: 12, right: 20, bottom: 10),
              color: Colors.transparent,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Select By Days',
                      style: AppFonts.robotoRegular(16,
                          color: theme_dark!
                                  ? AppColors.appGrey2()
                                  : AppColorsLightMode.appGrey(),
                          decoration: TextDecoration.none),
                    ),
                    (days != null)
                        ? Text(
                            '$days days',
                            style: AppFonts.robotoRegular(16,
                                color: theme_dark!
                                  ? AppColors.appGrey2()
                                  : AppColorsLightMode.appGrey(),
                                decoration: TextDecoration.none),
                          )
                        : Image.asset(
                            Constants.ASSET_IMAGES + 'next_bttn.png',
                            height: 17,
                          )
                  ]),
            ),
          ),
        ]),
    */
