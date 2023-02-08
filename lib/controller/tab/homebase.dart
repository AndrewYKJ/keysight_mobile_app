import 'dart:async';
import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:keysight_pma/cache/appcache.dart';
import 'package:keysight_pma/const/appcolors.dart';
import 'package:keysight_pma/const/constants.dart';
import 'package:keysight_pma/const/notificationCounter.dart';
import 'package:keysight_pma/const/themedata.dart';
import 'package:keysight_pma/const/utils.dart';
import 'package:keysight_pma/controller/admin/admin.dart';
import 'package:keysight_pma/controller/alert/notifications/notifications_list.dart';
import 'package:keysight_pma/controller/home.dart';
import 'package:keysight_pma/controller/tab/tab_item.dart';
import 'package:keysight_pma/dio/api/user.dart';
import 'package:keysight_pma/model/updateUserPrefModel.dart';
import 'package:keysight_pma/model/user.dart';
import 'package:provider/provider.dart';
import 'package:umeng_push_sdk/umeng_push_sdk.dart';

class HomeBase extends StatefulWidget {
  const HomeBase({Key? key}) : super(key: key);

  @override
  State<HomeBase> createState() => _HomeBaseState();
}

class _HomeBaseState extends State<HomeBase> {
  var _currentTab = TabItem.Home;
  StreamController<int> _countController = StreamController<int>();

  // Future<UpdatePreferredLanguageDTO> updatePreferredLanguages(
  //     BuildContext context, String languageCode) {
  //   UserApi userApi = UserApi(context);
  //   return userApi.updatePreferredLanguages(languageCode);
  // }

  Future<updatePreferenceSettingDTO> updatePreferredLanguages(
      BuildContext ctx, updatePreferenceSettingDataDTO newPrefSetting) {
    UserApi preferenceUpdateApi = UserApi(ctx);
    return preferenceUpdateApi.updatePreferenceSetting(
        bodyData: newPrefSetting);
  }

  Future<PushTokenDTO> savePushToken(
      BuildContext context, String token, String platform, String tokenType) {
    UserApi userApi = UserApi(context);
    return userApi.savePushToken(token, platform, tokenType);
  }

  @override
  void initState() {
    super.initState();
    if (Constants.IS_SUPPORT_GOOGLE) {
      FirebaseAnalytics.instance
          .setCurrentScreen(screenName: Constants.ANALYTICS_MAIN_SCREEN);
      getFcmToken();
    } else {
      UmengPushSdk.getRegisteredId().then((value) {
        Utils.printInfo("###### Get Umeng token: $value");
        String platform = Platform.isAndroid
            ? Constants.PLATFORM_ANDROID
            : Constants.PLATFORM_IOS;
        callSavePushToken(context, value!, platform, "UMENG");
      });
    }

    AppCache.getStringValue(AppCache.LANGUAGE_CODE_PREF).then((value) {
      if (Utils.isNotEmpty(value)) {
        if (value == Constants.LANGUAGE_CODE_CN) {
          callUpdatePreferredLanguages(context, Constants.CHINESE);
        } else {
          callUpdatePreferredLanguages(context, Constants.ENGLISH);
        }
      }
    });
  }

  callUpdatePreferredLanguages(
      BuildContext context, String languageCode) async {
    PreferredLanguage preferredLanguageData = PreferredLanguage();
    PreferredLandingPageDto preferredLandingPageData =
        PreferredLandingPageDto();
    PreferredDaysDto preferredDaysData = PreferredDaysDto();
    ProjectVersionDTO preferredProjectVersionsData =
        ProjectVersionDTO(projectVersionList: [], defaultProjectId: null);
    updatePreferenceSettingDataDTO newPrefSetting =
        updatePreferenceSettingDataDTO();

    preferredLanguageData.preferredLanguageCode = languageCode;
    preferredProjectVersionsData.companyId =
        AppCache.me!.data!.preferredCompany!;

    preferredDaysData.preferredDays = AppCache.me!.data!.preferredDays;
    preferredProjectVersionsData.projectVersionList =
        AppCache.me!.data!.projectVersionsDTOs![0].projectVersionList!;

    preferredProjectVersionsData.siteId =
        AppCache.me!.data!.projectVersionsDTOs![0].siteId!;

    preferredLandingPageData.preferredLandingPage =
        AppCache.me!.data!.preferredLandingPage!;

    newPrefSetting = updatePreferenceSettingDataDTO(
        analyticsConsent: true,
        preferredDaysDto: preferredDaysData,
        preferredLandingPageDto: preferredLandingPageData,
        preferredLanguage: preferredLanguageData,
        projectVersionDTO: preferredProjectVersionsData);

    await updatePreferredLanguages(context, newPrefSetting).then((value) {
      if (value.status != null && value.status!.statusCode == 200) {
        if (AppCache.me != null) {
          AppCache.me!.data!.preferredLangCode = languageCode;
        }
      }
    }).catchError((error) {
      Utils.printInfo(error);
    });
  }

  getFcmToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    Utils.printInfo("##### FCM Token: $token");
    String platform = Platform.isAndroid
        ? Constants.PLATFORM_ANDROID
        : Constants.PLATFORM_IOS;
    callSavePushToken(context, token!, platform, "FIREBASE");
  }

  callSavePushToken(BuildContext context, String token, String platform,
      String tokenType) async {
    await savePushToken(context, token, platform, tokenType).then((value) {
      if (value.status!.statusCode == 200) {
        Utils.printInfo("Push token upload successful");
      }
    }).catchError((error) {
      Utils.printInfo(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeClass>(builder: (context, value, child) {
      return new Scaffold(
        body: IndexedStack(
          index: _currentTab.index,
          children: [
            HomeScreen(),
            NotificationList(countController: _countController),
            AppAdmin()
          ],
        ),
        bottomNavigationBar: BottomNavigation(
          value: value.getValue(),
          currentTab: _currentTab,
          onSelectTab: _selectTab,
          controller: _countController,
        ),
      );
    });
  }

  void _selectTab(TabItem tabItem) {
    setState(() {
      _currentTab = tabItem;
    });
  }
}

class BottomNavigation extends StatefulWidget {
  BottomNavigation(
      {required this.value,
      required this.currentTab,
      required this.onSelectTab,
      required this.controller});
  final TabItem currentTab;
  final bool value;
  final StreamController<int> controller;
  final ValueChanged<TabItem> onSelectTab;

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  @override
  Widget build(BuildContext context) {
    var counter = Provider.of<Counter>(context).getCounter;
    return BottomNavigationBar(
      backgroundColor: widget.value
          ? AppColors.bottomNavi()
          : AppColorsLightMode.bottomNavi(),
      currentIndex: widget.currentTab.index,
      selectedItemColor: AppColors.appBlue(),
      unselectedItemColor: widget.value
          ? AppColors.appPrimaryWhite()
          : AppColorsLightMode.appPrimaryWhite(),
      type: BottomNavigationBarType.fixed,
      items: [
        _buildItem(context, TabItem.Home, null),
        _buildItem(context, TabItem.Notification, counter),
        _buildItem(context, TabItem.Admin, null),
      ],
      onTap: (index) {
        widget.onSelectTab(TabItem.values[index]);
      },
    );
  }

  BottomNavigationBarItem _buildItem(
      BuildContext context, TabItem tabItem, int? count) {
    String? label;
    if (tabItem == TabItem.Home) {
      label = Utils.getTranslated(context, 'main_tabbar')!;
    } else if (tabItem == TabItem.Notification) {
      label = Utils.getTranslated(context, 'notification_tabbar')!;
    } else if (tabItem == TabItem.Admin) {
      label = Utils.getTranslated(context, 'admin_tabbar')!;
    }

    if (tabItem == TabItem.Notification) {
      return BottomNavigationBarItem(
        icon: StreamBuilder<Object>(
            initialData: count,
            stream: widget.controller.stream,
            builder: (context, snapshot) {
              return Container(
                width: 35,
                child: new Stack(
                  children: <Widget>[
                    (widget.value
                        ? _iconTabMatching(tabItem)
                        : _iconTabMatchingLight(tabItem)),
                    count != 0
                        ? new Positioned(
                            right: 0,
                            top: 0,
                            child: new Container(
                              padding: EdgeInsets.all(1),
                              decoration: new BoxDecoration(
                                color: AppColors.appNotificationRed(),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              constraints: BoxConstraints(
                                minWidth: 18,
                                minHeight: 18,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 2.0),
                                child: new Text(
                                  count! <= 99 ? '$count' : "99+",
                                  style: new TextStyle(
                                    color: Colors.white,
                                    fontSize: 8,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          )
                        : Container()
                  ],
                ),
              );
            }),
        label: label,
      );
    } else {
      return BottomNavigationBarItem(
        icon: widget.value
            ? _iconTabMatching(tabItem)
            : _iconTabMatchingLight(tabItem),
        label: label,
      );
    }
  }

  _iconTabMatching(TabItem item) {
    return widget.currentTab == item
        ? tabIconSelected[item]
        : tabIconUnselected[item];
  }

  _iconTabMatchingLight(TabItem item) {
    return widget.currentTab == item
        ? tabIconSelectedLight[item]
        : tabIconUnselectedLight[item];
  }
}
