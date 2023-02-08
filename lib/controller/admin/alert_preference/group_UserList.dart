import 'package:flutter/material.dart';
import 'package:keysight_pma/const/appcolors.dart';
import 'package:keysight_pma/const/appfonts.dart';
import 'package:keysight_pma/const/constants.dart';
import 'package:keysight_pma/const/utils.dart';
import 'package:keysight_pma/model/alertPreferencemodel.dart';
import 'package:keysight_pma/routes/approutes.dart';

import '../../../cache/appcache.dart';

class GroupUserList extends StatefulWidget {
  final List<GroupUser>? groupUsers;
  GroupUserList({Key? key, this.groupUsers}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _GroupUserList();
  }
}

class _GroupUserList extends State<GroupUserList> {
  bool? isDarkTheme = AppCache.sortFilterCacheDTO!.currentTheme;

  @override
  void initState() {
    super.initState();
    Utils.setFirebaseAnalyticsCurrentScreen(
        Constants.ANALYTICS_ADMIN_ALERT_PREFERENCE_GROUP_USER_LIST_INFO_SCREEN);
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
          Utils.getTranslated(context, 'groupUserList')!,
          style: AppFonts.robotoRegular(20,
              color: isDarkTheme!
                  ? AppColors.appGrey()
                  : AppColorsLightMode.appGrey(),
              decoration: TextDecoration.none),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.searchRoute);
              },
              icon: Image.asset(
                isDarkTheme!
                    ? Constants.ASSET_IMAGES + 'search_icon.png'
                    : Constants.ASSET_IMAGES_LIGHT + 'search.png',
              )),
        ],
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
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children:
              widget.groupUsers!.map((e) => dataGroup(context, e)).toList(),
        ),
      ),
    );
  }

  Widget dataGroup(BuildContext context, GroupUser e) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 70,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(right: 16, top: 12, left: 16),
        padding: EdgeInsets.only(
          top: 13,
          left: 17,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: e.moderator!
              ? AppColors.appGreen60()
              : isDarkTheme!
                  ? AppColors.appBlackLight()
                  : AppColorsLightMode.serverAppBar(),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              e.userName!,
              style: AppFonts.robotoMedium(13,
                  color: e.moderator!
                      ? AppColors.appWhiteE6()
                      : isDarkTheme!
                          ? AppColors.appGreyDE()
                          : AppColorsLightMode.appPrimaryWhite(),
                  decoration: TextDecoration.none),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              e.emailId!,
              overflow: TextOverflow.ellipsis,
              style: AppFonts.sfproRegular(14,
                  color: e.moderator!
                      ? AppColors.appGreyDE()
                      : isDarkTheme!
                          ? AppColors.appGreyB1()
                          : AppColorsLightMode.appGrey70(),
                  decoration: TextDecoration.none),
            ),
          ],
        ),
      ),
    );
  }
}
