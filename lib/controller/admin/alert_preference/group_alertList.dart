import 'package:flutter/material.dart';
import 'package:keysight_pma/const/appcolors.dart';
import 'package:keysight_pma/const/appfonts.dart';
import 'package:keysight_pma/const/constants.dart';
import 'package:keysight_pma/const/utils.dart';
import 'package:keysight_pma/model/alertPreferencemodel.dart';

import '../../../cache/appcache.dart';

class GroupAlertList extends StatefulWidget {
  final List<AlertPrefAlertList>? alertPrefAlertList;
  GroupAlertList({Key? key, this.alertPrefAlertList}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _GroupAlertList();
  }
}

class _GroupAlertList extends State<GroupAlertList> {
  bool? isDarkTheme = AppCache.sortFilterCacheDTO!.currentTheme;
  String alertString = '';

  @override
  void initState() {
    super.initState();
    Utils.setFirebaseAnalyticsCurrentScreen(Constants
        .ANALYTICS_ADMIN_ALERT_PREFERENCE_GROUP_ALERT_LIST_INFO_SCREEN);
    if (widget.alertPrefAlertList!.length > 0) {
      setState(() {
        alertString = widget.alertPrefAlertList!
            .map((e) => e.alertDescription)
            .toList()
            .join(', ');
      });
    }
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
                isDarkTheme!
                    ? AppColors.serverAppBar()
                    : AppColorsLightMode.serverAppBar(),
                isDarkTheme!
                    ? AppColors.serverAppBar()
                    : AppColorsLightMode.serverAppBar(),
              ]))),
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            Utils.getTranslated(context, 'alertList')!,
            style: AppFonts.robotoRegular(20,
                color: isDarkTheme!
                    ? AppColors.appGrey()
                    : AppColorsLightMode.appGrey(),
                decoration: TextDecoration.none),
          ),
          // actions: [
          //   IconButton(
          //       onPressed: () {
          //         Navigator.pushNamed(context, AppRoutes.searchRoute);
          //       },
          //       icon: Image.asset(theme_dark!
          // ? Constants.ASSET_IMAGES + 'search_icon.png'
          // : Constants.ASSET_IMAGES_LIGHT + 'search_icon.png')),
          // ],
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Image.asset(
                isDarkTheme!
                    ? Constants.ASSET_IMAGES + 'back_bttn.png'
                    : Constants.ASSET_IMAGES_LIGHT + 'back_bttn.png',
              )),
        ),
        body: Container(
          margin: EdgeInsets.only(left: 14, top: 15, right: 14),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Utils.getTranslated(context, 'groupdetail_selectedAlerts')!,
                  style: AppFonts.robotoMedium(16,
                      color: isDarkTheme!
                          ? AppColors.appPrimaryWhite()
                          : AppColorsLightMode.appPrimaryWhite(),
                      decoration: TextDecoration.none),
                ),
                SizedBox(
                  height: 16,
                ),
                Container(
                  padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: isDarkTheme!
                          ? AppColors.appBlackLight()
                          : AppColorsLightMode.serverAppBar(),
                      borderRadius: BorderRadius.circular(14)),
                  child: Text(
                    alertString,
                    style: AppFonts.robotoRegular(
                      14,
                      color: isDarkTheme!
                          ? AppColors.appGrey89()
                          : AppColorsLightMode.appGrey70(),
                      decoration: TextDecoration.none,
                      height: 2.5,
                    ),
                  ),
                )
              ]),
        ));
  }
}
