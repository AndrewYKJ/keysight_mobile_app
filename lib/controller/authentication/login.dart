import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:keysight_pma/cache/appcache.dart';
import 'package:keysight_pma/const/appcolors.dart';
import 'package:keysight_pma/const/appfonts.dart';
import 'package:keysight_pma/const/constants.dart';
import 'package:keysight_pma/const/themedata.dart';
import 'package:keysight_pma/const/utils.dart';
import 'package:keysight_pma/dio/api/user.dart';
import 'package:keysight_pma/main.dart';
import 'package:keysight_pma/model/custom_server/server.dart';
import 'package:keysight_pma/model/customize.dart';
import 'package:keysight_pma/model/user.dart';
import 'package:keysight_pma/routes/approutes.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LoginScreen();
  }
}

class _LoginScreen extends State<LoginScreen> {
  FlutterAppAuth appAuth = FlutterAppAuth();
  CustomServerDTO customServerDTO = CustomServerDTO();
  String languageCode = Constants.LANGUAGE_CODE_EN;

  bool? isDarkTheme;
  Future<void> callLogin(BuildContext context) async {
    String mAuthEndpoint = '';
    String mTokenEndpoint = '';
    String mLogoutEndpoint = '';
    String mDiscoveryUrl = '';
    if (Utils.isNotEmpty(this.customServerDTO.serverIp)) {
      if (Utils.isNotEmpty(this.customServerDTO.serverPort)) {
        mAuthEndpoint =
            '${this.customServerDTO.serverIp!}:${this.customServerDTO.serverPort}/${Constants.AUTH_ENDPOINT}';
        mTokenEndpoint =
            '${this.customServerDTO.serverIp!}:${this.customServerDTO.serverPort}/${Constants.AUTH_TOKEN_ENDPOINT}';
        mLogoutEndpoint =
            '${this.customServerDTO.serverIp!}:${this.customServerDTO.serverPort}/${Constants.AUTH_LOGOUT_ENDPOINT}';
        mDiscoveryUrl =
            '${this.customServerDTO.serverIp!}:${this.customServerDTO.serverPort}/${Constants.AUTH_DISCOVERY_URL}';
      } else {
        mAuthEndpoint =
            '${this.customServerDTO.serverIp!}/${Constants.AUTH_ENDPOINT}';
        mTokenEndpoint =
            '${this.customServerDTO.serverIp!}/${Constants.AUTH_TOKEN_ENDPOINT}';
        mLogoutEndpoint =
            '${this.customServerDTO.serverIp!}/${Constants.AUTH_LOGOUT_ENDPOINT}';
        mDiscoveryUrl =
            '${this.customServerDTO.serverIp!}/${Constants.AUTH_DISCOVERY_URL}';
      }
    }
    AuthorizationServiceConfiguration _serviceConfiguration =
        AuthorizationServiceConfiguration(
      authorizationEndpoint: mAuthEndpoint,
      tokenEndpoint: mTokenEndpoint,
      endSessionEndpoint: mLogoutEndpoint,
    );
    AuthorizationTokenResponse? result = await appAuth.authorizeAndExchangeCode(
      AuthorizationTokenRequest(
          Constants.AUTH_CLIENT_ID, Constants.AUTH_REDIRECT_URI,
          clientSecret: Constants.AUTH_CLIENT_SECRET,
          discoveryUrl: mDiscoveryUrl,
          serviceConfiguration: _serviceConfiguration,
          scopes: ['openid', 'profile'],
          allowInsecureConnections: true),
    );

    if (result != null) {
      EasyLoading.show(maskType: EasyLoadingMaskType.black);
      MyHomePage().callStartTimer(result.accessTokenExpirationDateTime!);
      AppCache.setAuthToken(
          result.accessToken!, result.refreshToken!, result.idToken!);
      getUserDetail(context).then((value) async {
        if (AppCache.me != null) {
          SortFilterCacheDTO sortFilterCacheDTO = SortFilterCacheDTO(
              preferredDays: AppCache.me!.data!.preferredDays,
              preferredCompany: AppCache.me!.data!.preferredCompany,
              preferredSite: AppCache.me!.data!.preferredSite,
              preferredStartDate: Utils.isNotEmpty(
                      AppCache.me!.data!.preferredDays!)
                  ? Utils.sortFilterStartDate(AppCache.me!.data!.preferredDays!)
                  : DateTime.now(),
              preferredEndDate: DateTime.now(),
              startDate: Utils.isNotEmpty(AppCache.me!.data!.preferredDays!)
                  ? Utils.sortFilterStartDate(AppCache.me!.data!.preferredDays!)
                  : DateTime.now(),
              endDate: DateTime.now(),
              defaultProjectId:
                  AppCache.me!.data!.projectVersionsDTOs![0].defaultProjectId,
              displayProjectName:
                  AppCache.me!.data!.projectVersionsDTOs![0].defaultProjectId);
          AppCache.sortFilterCacheDTO = sortFilterCacheDTO;
          AppCache.setString(AppCache.LANGUAGE_CODE_PREF, this.languageCode);
          Navigator.pushReplacementNamed(context, AppRoutes.homebaseroute);
        }
      }, onError: (err) {
        Utils.printInfo(err);
      }).whenComplete(() {
        EasyLoading.dismiss();
      });
    } else {
      EasyLoading.dismiss();
    }
  }

  Future<UserDTO> getUserDetail(BuildContext ctx) {
    UserApi userApi = UserApi(ctx);
    return userApi.getUserDetail();
  }

  void _localization(BuildContext ctx, double width) {
    showModalBottomSheet(
      backgroundColor: isDarkTheme!
          ? AppColors.applocale()
          : AppColorsLightMode.appPrimaryBlack(),
      context: ctx,
      builder: (BuildContext ctc) => StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: width * 0.38),
                    child: Text(
                      Utils.getTranslated(
                          context, 'preferredSetting_language')!,
                      textAlign: TextAlign.center,
                      style: AppFonts.robotoMedium(
                        16,
                        color: isDarkTheme!
                            ? AppColors.appGrey()
                            : AppColorsLightMode.appPrimaryWhite(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Image.asset(
                      isDarkTheme!
                          ? Constants.ASSET_IMAGES + 'close_bttn.png'
                          : Constants.ASSET_IMAGES_LIGHT + 'close_icon.png',
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 43,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    this.languageCode = Constants.LANGUAGE_CODE_EN;
                  });
                },
                child: Container(
                  color: Colors.transparent,
                  margin: EdgeInsets.only(left: 16, right: 56),
                  width: MediaQuery.of(context).size.width,
                  height: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(Utils.getTranslated(context, 'setting_language_en')!,
                          style: AppFonts.robotoRegular(16,
                              color: isDarkTheme!
                                  ? AppColors.appGrey2()
                                  : AppColorsLightMode.appGrey(),
                              decoration: TextDecoration.none)),
                      Image.asset(
                        (this.languageCode == Constants.LANGUAGE_CODE_EN)
                            ? isDarkTheme!
                                ? Constants.ASSET_IMAGES +
                                    'radio_bttn_active.png'
                                : Constants.ASSET_IMAGES_LIGHT +
                                    'radio_bttn_inactive.png'
                            : isDarkTheme!
                                ? Constants.ASSET_IMAGES +
                                    'radio_bttn_inactive.png'
                                : Constants.ASSET_IMAGES_LIGHT +
                                    'radio_bttn_active.png',
                        height: 24,
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    this.languageCode = Constants.LANGUAGE_CODE_CN;
                  });
                },
                child: Container(
                  color: Colors.transparent,
                  margin: EdgeInsets.only(left: 16, right: 56),
                  width: MediaQuery.of(context).size.width,
                  height: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(Utils.getTranslated(context, 'setting_language_zh')!,
                          style: AppFonts.robotoRegular(16,
                              color: isDarkTheme!
                                  ? AppColors.appGrey2()
                                  : AppColorsLightMode.appPrimaryWhite(),
                              decoration: TextDecoration.none)),
                      Image.asset(
                        (this.languageCode == Constants.LANGUAGE_CODE_CN)
                            ? isDarkTheme!
                                ? Constants.ASSET_IMAGES +
                                    'radio_bttn_active.png'
                                : Constants.ASSET_IMAGES_LIGHT +
                                    'radio_bttn_inactive.png'
                            : isDarkTheme!
                                ? Constants.ASSET_IMAGES +
                                    'radio_bttn_inactive.png'
                                : Constants.ASSET_IMAGES_LIGHT +
                                    'radio_bttn_active.png',
                        height: 24,
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 138),
              GestureDetector(
                onTap: () {
                  MyHomePage.setLocale(
                      context, Utils.mylocale(this.languageCode));
                  Navigator.pop(context);
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  height: 40,
                  width: 236,
                  color: AppColors.appTeal(),
                  child: Text(
                    Utils.getTranslated(context, 'done')!,
                    style: AppFonts.robotoMedium(16,
                        color: isDarkTheme!
                            ? AppColors.appGrey2()
                            : AppColorsLightMode.appGrey2(),
                        decoration: TextDecoration.none),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Utils.setFirebaseAnalyticsCurrentScreen(Constants.ANALYTICS_LOGIN_SCREEN);
    AppCache.getStringValue(AppCache.CUSTOM_SERVER_PREF).then((value) {
      if (!Utils.isNotEmpty(value)) {
        List<CustomServerDTO> serverList = [];
        serverList.add(CustomServerDTO(
            serverName: 'PMA',
            serverIp: Constants.PMA_DOMAIN,
            serverPort: '',
            isSelected: true));
        // serverList.add(CustomServerDTO(
        //     serverName: 'PMA-DEV',
        //     serverIp: Constants.DEV_DOMAIN,
        //     serverPort: '',
        //     isSelected: false));
        AppCache.setString(AppCache.CUSTOM_SERVER_PREF, jsonEncode(serverList));
      } else {
        List<dynamic> cacheServerList = jsonDecode(value);
        if (cacheServerList.length > 0) {
          cacheServerList.forEach((element) {
            if (CustomServerDTO.fromJson(element).isSelected!) {
              this.customServerDTO = CustomServerDTO.fromJson(element);
            }
          });

          setState(() {});
        }
      }
    });

    AppCache.getThemeValue().then((value) {
      setState(() {
        AppCache.sortFilterCacheDTO!.currentTheme = value;
        isDarkTheme = value;
      });
    });

    AppCache.getStringValue(AppCache.LANGUAGE_CODE_PREF).then((value) {
      setState(() {
        if (Utils.isNotEmpty(value)) {
          this.languageCode = value;
        } else {
          this.languageCode = Constants.LANGUAGE_CODE_EN;
        }
        MyHomePage.setLocale(context, Utils.mylocale(this.languageCode));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;
    double width = MediaQuery.of(context).size.width;
    return Consumer<ThemeClass>(
      builder: (context, value, child) {
        isDarkTheme = value.getValue();
        return Scaffold(
          body: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.only(top: statusBarHeight),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(
                              77, 94.73, 77.7, 105.64),
                          child: Image.asset(
                            isDarkTheme!
                                ? Constants.ASSET_IMAGES +
                                    'keysight_logo_splash.png'
                                : Constants.ASSET_IMAGES_LIGHT +
                                    'keysight_logo_splash.png',
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                          child: Text(
                            Utils.getTranslated(
                                context, 'login_chooserServer')!,
                            style: AppFonts.robotoMedium(16,
                                color: isDarkTheme!
                                    ? AppColors.appPrimaryWhite()
                                    : AppColorsLightMode.appPrimaryWhite(),
                                decoration: TextDecoration.none),
                          ),
                        ),
                        SizedBox(
                          height: 27,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                          child: Text(
                            Utils.getTranslated(context, 'login_server')!,
                            style: AppFonts.robotoMedium(16,
                                color: isDarkTheme!
                                    ? AppColors.appPrimaryWhite()
                                    : AppColorsLightMode.appPrimaryWhite(),
                                decoration: TextDecoration.none),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            final navigateResult = await Navigator.pushNamed(
                                context, AppRoutes.serverSelectionRoute);
                            if (navigateResult != null) {
                              setState(() {
                                this.customServerDTO =
                                    navigateResult as CustomServerDTO;
                              });
                            }
                          },
                          child: Container(
                            color: isDarkTheme!
                                ? AppColors.appPrimaryGray()
                                : AppColors.appPrimaryWhite(),
                            margin: const EdgeInsets.fromLTRB(16, 10, 10, 0),
                            padding: const EdgeInsets.fromLTRB(16, 10, 10, 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  Utils.isNotEmpty(
                                          this.customServerDTO.serverName)
                                      ? this.customServerDTO.serverName!
                                      : Utils.getTranslated(
                                          context, 'login_selectServer')!,
                                  style: AppFonts.robotoRegular(15,
                                      color: isDarkTheme!
                                          ? AppColors.appPrimaryWhite()
                                          : AppColorsLightMode
                                              .appPrimaryWhite(),
                                      decoration: TextDecoration.none),
                                ),
                                Image.asset(
                                  isDarkTheme!
                                      ? Constants.ASSET_IMAGES +
                                          'dropdown_icon.png'
                                      : Constants.ASSET_IMAGES_LIGHT +
                                          'dropdown.png',
                                  height: 17,
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          color: AppColors.appPrimaryYellow(),
                          width: 236,
                          child: GestureDetector(
                            onTap: () {
                              if (Utils.isNotEmpty(
                                  this.customServerDTO.serverIp)) {
                                callLogin(context);
                              }
                            },
                            child: Text(
                              Utils.getTranslated(context, 'login_loginNow')!,
                              style: AppFonts.robotoMedium(15,
                                  color: isDarkTheme!
                                      ? AppColors.appPrimaryWhite()
                                      : AppColors.appPrimaryWhite(),
                                  decoration: TextDecoration.none),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        GestureDetector(
                          onTap: () async {
                            final navResult = await Navigator.pushNamed(
                              context,
                              AppRoutes.customServerRoute,
                            );

                            if (navResult != null) {
                              setState(() {
                                this.languageCode = navResult as String;
                                MyHomePage.setLocale(
                                    context, Utils.mylocale(this.languageCode));
                              });
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 2,
                                    color: isDarkTheme!
                                        ? AppColors.appGrey2()
                                        : AppColorsLightMode
                                            .appPrimaryYellow())),
                            width: 236,
                            child: Text(
                              Utils.getTranslated(
                                  context, 'login_addCustomServer')!,
                              style: AppFonts.robotoMedium(15,
                                  color: isDarkTheme!
                                      ? AppColors.appPrimaryWhite()
                                      : AppColorsLightMode.appPrimaryYellow(),
                                  decoration: TextDecoration.none),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        GestureDetector(
                          onTap: () => _localization(context, width),
                          child: Container(
                            padding: EdgeInsets.all(18),
                            width: width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  isDarkTheme!
                                      ? Constants.ASSET_IMAGES +
                                          'language_icon.png'
                                      : Constants.ASSET_IMAGES_LIGHT +
                                          'language.png',
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text(
                                    this.languageCode ==
                                            Constants.LANGUAGE_CODE_CN
                                        ? Utils.getTranslated(
                                            context, 'setting_language_zh')!
                                        : Utils.getTranslated(
                                            context, 'setting_language_en')!,
                                    style: AppFonts.robotoMedium(16,
                                        color: isDarkTheme!
                                            ? AppColors.appPrimaryWhite()
                                            : AppColorsLightMode.appTeal(),
                                        decoration: TextDecoration.none),
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
