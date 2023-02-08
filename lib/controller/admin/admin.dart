import 'dart:convert';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:keysight_pma/cache/appcache.dart';
import 'package:keysight_pma/const/appcolors.dart';
import 'package:keysight_pma/const/appfonts.dart';
import 'package:keysight_pma/const/constants.dart';
import 'package:keysight_pma/const/themedata.dart';
import 'package:keysight_pma/const/utils.dart';
import 'package:keysight_pma/model/custom_server/server.dart';
import 'package:keysight_pma/model/user.dart';
import 'package:keysight_pma/routes/approutes.dart';
import 'package:provider/provider.dart';

class AppAdmin extends StatefulWidget {
  const AppAdmin({Key? key}) : super(key: key);

  @override
  State<AppAdmin> createState() => _AppAdminState();
}

class _AppAdminState extends State<AppAdmin> {
  bool isDarkTheme = false;
  UserDTO? _user;
  bool isLoading = false;

  callUserLogout(BuildContext context, CustomServerDTO customServerDTO) {
    AppCache.getStringValue(AppCache.ID_TOKEN_PREF).then((idToken) async {
      if (Utils.isNotEmpty(idToken)) {
        EasyLoading.show(maskType: EasyLoadingMaskType.black);
        try {
          String mAuthEndpoint = '';
          String mTokenEndpoint = '';
          String mLogoutEndpoint = '';
          String mDiscoveryUrl = '';
          if (Utils.isNotEmpty(customServerDTO.serverIp)) {
            if (Utils.isNotEmpty(customServerDTO.serverPort)) {
              mAuthEndpoint =
                  '${customServerDTO.serverIp!}:${customServerDTO.serverPort}/${Constants.AUTH_ENDPOINT}';
              mTokenEndpoint =
                  '${customServerDTO.serverIp!}:${customServerDTO.serverPort}/${Constants.AUTH_TOKEN_ENDPOINT}';
              mLogoutEndpoint =
                  '${customServerDTO.serverIp!}:${customServerDTO.serverPort}/${Constants.AUTH_LOGOUT_ENDPOINT}';
              mDiscoveryUrl =
                  '${customServerDTO.serverIp!}:${customServerDTO.serverPort}/${Constants.AUTH_DISCOVERY_URL}';
            } else {
              mAuthEndpoint =
                  '${customServerDTO.serverIp!}/${Constants.AUTH_ENDPOINT}';
              mTokenEndpoint =
                  '${customServerDTO.serverIp!}/${Constants.AUTH_TOKEN_ENDPOINT}';
              mLogoutEndpoint =
                  '${customServerDTO.serverIp!}/${Constants.AUTH_LOGOUT_ENDPOINT}';
              mDiscoveryUrl =
                  '${customServerDTO.serverIp!}/${Constants.AUTH_DISCOVERY_URL}';
            }
          }
          AuthorizationServiceConfiguration _serviceConfiguration =
              AuthorizationServiceConfiguration(
            authorizationEndpoint: mAuthEndpoint,
            tokenEndpoint: mTokenEndpoint,
            endSessionEndpoint: mLogoutEndpoint,
          );

          FlutterAppAuth appAuth = FlutterAppAuth();
          EndSessionResponse? endSessionResponse = await appAuth.endSession(
              EndSessionRequest(
                  idTokenHint: idToken,
                  discoveryUrl: mDiscoveryUrl,
                  postLogoutRedirectUrl: Constants.AUTH_REDIRECT_URI,
                  serviceConfiguration: _serviceConfiguration,
                  allowInsecureConnections: true));

          if (endSessionResponse != null) {
            EasyLoading.dismiss();
            AppCache.removeAuthToken();
            AppCache.me = null;
            AppCache.sortFilterCacheDTO = null;
            Navigator.pushNamedAndRemoveUntil(
                context, AppRoutes.loginScreenRoute, (route) => false);
          }
        } catch (e) {
          Utils.printInfo(e);
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    FirebaseAnalytics.instance
        .setCurrentScreen(screenName: Constants.ANALYTICS_ADMIN_SCREEN);
    if (AppCache.me != null) {
      setState(() {
        _user = AppCache.me;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeClass>(
      builder: (context, value, child) {
        isDarkTheme = value.getValue();
        AppCache.sortFilterCacheDTO!.currentTheme = isDarkTheme;
        return Scaffold(
          appBar: AppBar(
            flexibleSpace: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                  isDarkTheme
                      ? AppColors.serverAppBar()
                      : AppColorsLightMode.serverAppBar(),
                  isDarkTheme
                      ? AppColors.serverAppBar()
                      : AppColorsLightMode.serverAppBar(),
                ]))),
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: Text(
              Utils.getTranslated(context, 'admin_appbar_title')!,
              style: AppFonts.robotoRegular(20,
                  color: isDarkTheme
                      ? AppColors.appGrey()
                      : AppColorsLightMode.appGrey(),
                  decoration: TextDecoration.none),
            ),
          ),
          body: Container(
            color: isDarkTheme
                ? AppColors.appPrimaryBlack()
                : AppColorsLightMode.appPrimaryBlack(),
            child: isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(AppColors.appBlue()),
                    ),
                  )
                : SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _userinfo(context),
                          _settings(),
                          _logout(context)
                        ]),
                  ),
          ),
        );
      },
    );
  }

  //Logout UI
  Align _logout(BuildContext context) => Align(
        alignment: Alignment.center,
        child: GestureDetector(
          onTap: () {
            AppCache.getStringValue(AppCache.CUSTOM_SERVER_PREF).then((value) {
              if (Utils.isNotEmpty(value)) {
                List<dynamic> cacheServerList = jsonDecode(value);
                CustomServerDTO customServerDTO = cacheServerList
                    .map((e) => CustomServerDTO.fromJson(e))
                    .toList()
                    .firstWhere((element) => element.isSelected!);
                callUserLogout(context, customServerDTO);
              }
            });
          },
          child: Container(
            width: 156,
            height: 40,
            margin: EdgeInsets.only(top: 39, bottom: 36),
            padding: EdgeInsets.only(top: 8, bottom: 3),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.appRedE9(), width: 2),
            ),
            child: Text(
              Utils.getTranslated(context, 'admin_logOut')!,
              textAlign: TextAlign.center,
              style: AppFonts.robotoRegular(16,
                  color: AppColors.appRedE9(), decoration: TextDecoration.none),
            ),
          ),
        ),
      );

  //user info center
  Container _userinfo(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 33, top: 25),
      width: MediaQuery.of(context).size.width,
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Text(
            _user != null ? _user!.data!.userName! : '',
            style: AppFonts.robotoRegular(15,
                color: isDarkTheme
                    ? AppColors.appGreyDE()
                    : AppColorsLightMode.appGrey(),
                decoration: TextDecoration.none),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 7),
          child: Text(
            _user != null ? _user!.data!.emailId! : '',
            style: AppFonts.robotoRegular(15,
                color: isDarkTheme
                    ? AppColors.appGreyBF()
                    : AppColorsLightMode.appGreyBF(),
                decoration: TextDecoration.none),
          ),
        ),
        Text(
          _user != null ? _user!.data!.phoneNumber! : '',
          style: AppFonts.robotoRegular(15,
              color: isDarkTheme
                  ? AppColors.appGreyBF()
                  : AppColorsLightMode.appGreyBF(),
              decoration: TextDecoration.none),
        )
      ]),
    );
  }

  //all settings
  Column _settings() {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              AppRoutes.account_info,
            );
          },
          child: Container(
            margin: EdgeInsets.only(top: 15, bottom: 15, left: 16, right: 21),
            padding: EdgeInsets.only(top: 15, bottom: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  Utils.getTranslated(context, 'admin_accountInfo')!,
                  style: AppFonts.robotoRegular(16,
                      color: isDarkTheme
                          ? AppColors.appGreyDE()
                          : AppColorsLightMode.appGrey(),
                      decoration: TextDecoration.none),
                ),
                Image.asset(
                  isDarkTheme
                      ? Constants.ASSET_IMAGES + 'next_bttn.png'
                      : Constants.ASSET_IMAGES_LIGHT + 'next_bttn.png',
                  height: 17,
                )
              ],
            ),
          ),
        ),
        Divider(
          color: isDarkTheme
              ? AppColors.appDividerColor()
              : AppColorsLightMode.appDividerColor(),
        ),
        // GestureDetector(
        //   onTap: () {
        //     Navigator.pushNamed(context, AppRoutes.change_pwd);
        //   },
        //   child: Container(
        //     margin: EdgeInsets.only(top: 15, bottom: 15, left: 16, right: 21),
        //     padding: EdgeInsets.only(top: 15, bottom: 15),
        //     child: Row(
        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //       children: [
        //         Text(
        //           Utils.getTranslated(context, 'admin_changePWD')!,
        //           style: AppFonts.robotoRegular(16,
        //               color: theme_dark
        //                   ? AppColors.appGreyDE()
        //                   : AppColorsLightMode.appGrey(),
        //               decoration: TextDecoration.none),
        //         ),
        //         Image.asset(
        //           theme_dark
        //               ? Constants.ASSET_IMAGES + 'next_bttn.png'
        //               : Constants.ASSET_IMAGES_LIGHT + 'next_bttn.png',
        //           height: 17,
        //         )
        //       ],
        //     ),
        //   ),
        // ),
        // Divider(
        //   color: theme_dark
        //       ? AppColors.appDividerColor()
        //       : AppColorsLightMode.appDividerColor(),
        // ),

        Container(
          margin: EdgeInsets.only(top: 15, bottom: 15, left: 16, right: 21),
          padding: EdgeInsets.only(top: 15, bottom: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                Utils.getTranslated(context, 'admin_Appearance')!,
                style: AppFonts.robotoRegular(16,
                    color: isDarkTheme
                        ? AppColors.appGreyDE()
                        : AppColorsLightMode.appGrey(),
                    decoration: TextDecoration.none),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isDarkTheme = !isDarkTheme;
                    AppCache.setThemeValue(isDarkTheme);
                    AppCache.sortFilterCacheDTO!.currentTheme = isDarkTheme;
                    AppCache.setBoolean(AppCache.APP_THEME_PREF, isDarkTheme);
                    Provider.of<ThemeClass>(context, listen: false).swapTheme();
                  });
                },
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 17),
                      child: Text(
                        (isDarkTheme)
                            ? Utils.getTranslated(context, 'admin_darkmode')!
                            : Utils.getTranslated(context, 'admin_lightmode')!,
                        style: AppFonts.sfproMedium(13,
                            color: AppColors.appGrey96(),
                            decoration: TextDecoration.none),
                      ),
                    ),
                    Image.asset(
                      (isDarkTheme)
                          ? Constants.ASSET_IMAGES + 'toggle_on.png'
                          : Constants.ASSET_IMAGES + 'toggle_off.png',
                      height: 28,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        Divider(
          color: isDarkTheme
              ? AppColors.appDividerColor()
              : AppColorsLightMode.appDividerColor(),
        ),
        // GestureDetector(
        //   onTap: () {
        //     Navigator.pushNamed(context, AppRoutes.notification_setting,
        //         arguments: UserDTO(data: _user!.data));
        //   },
        //   child: Container(
        //     margin: EdgeInsets.only(top: 15, bottom: 15, left: 16, right: 21),
        //     padding: EdgeInsets.only(top: 15, bottom: 15),
        //     child: Row(
        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //       children: [
        //         Text(
        //           Utils.getTranslated(context, 'admin_NotificationSetting')!,
        //           style: AppFonts.robotoRegular(16,
        //               color: theme_dark
        //                   ? AppColors.appGreyDE()
        //                   : AppColorsLightMode.appGrey(),
        //               decoration: TextDecoration.none),
        //         ),
        //         Image.asset(
        //           theme_dark
        //               ? Constants.ASSET_IMAGES + 'next_bttn.png'
        //               : Constants.ASSET_IMAGES_LIGHT + 'next_bttn.png',
        //           height: 28,
        //         )
        //       ],
        //     ),
        //   ),
        // ),
        // Divider(
        //   color: theme_dark
        //       ? theme_dark!
        //                   ? AppColors.appDividerColor()
        //                   : AppColorsLightMode.appDividerColor()
        // //       : AppColorsLightMode.appDividerColor(),
        // ),

        GestureDetector(
          onTap: () async {
            final value = await Navigator.pushNamed(
                context, AppRoutes.preferred_setting,
                arguments: UserDTO(data: this._user!.data));
            if (value != null)
              setState(() {
                this._user = AppCache.me;
              });
          },
          child: Container(
            margin: EdgeInsets.only(top: 15, bottom: 15, left: 16, right: 21),
            padding: EdgeInsets.only(top: 15, bottom: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  Utils.getTranslated(context, 'admin_preferredSetting')!,
                  style: AppFonts.robotoRegular(16,
                      color: isDarkTheme
                          ? AppColors.appGreyDE()
                          : AppColorsLightMode.appGrey(),
                      decoration: TextDecoration.none),
                ),
                Image.asset(
                  isDarkTheme
                      ? Constants.ASSET_IMAGES + 'next_bttn.png'
                      : Constants.ASSET_IMAGES_LIGHT + 'next_bttn.png',
                  height: 17,
                )
              ],
            ),
          ),
        ),
        Divider(
            color: isDarkTheme
                ? AppColors.appDividerColor()
                : AppColorsLightMode.appDividerColor()),
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, AppRoutes.alert_preference,
                arguments: UserDTO(data: _user!.data));
          },
          child: Container(
            margin: EdgeInsets.only(top: 15, bottom: 15, left: 16, right: 21),
            padding: EdgeInsets.only(top: 15, bottom: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  Utils.getTranslated(context, 'admin_alertPreference')!,
                  style: AppFonts.robotoRegular(16,
                      color: isDarkTheme
                          ? AppColors.appGreyDE()
                          : AppColorsLightMode.appGrey(),
                      decoration: TextDecoration.none),
                ),
                Image.asset(
                  isDarkTheme
                      ? Constants.ASSET_IMAGES + 'next_bttn.png'
                      : Constants.ASSET_IMAGES_LIGHT + 'next_bttn.png',
                  height: 17,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
