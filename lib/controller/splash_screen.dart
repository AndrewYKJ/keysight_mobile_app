import 'dart:convert';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:keysight_pma/cache/appcache.dart';
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

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SplashScreen();
  }
}

class _SplashScreen extends State<SplashScreen> {
  Future<UserDTO> getUserDetail(BuildContext ctx) {
    UserApi userApi = UserApi(ctx);
    return userApi.getUserDetail();
  }

  @override
  void initState() {
    super.initState();
    Utils.setFirebaseAnalyticsCurrentScreen(Constants.ANALYTICS_SPLASH_SCREEN);
    startTimer();
  }

  startTimer() {
    Future.delayed(Duration(seconds: 3), () {
      AppCache.getThemeValue().then((value) {
        print(value);
        var isDarkTheme = value;
        setState(() {
          AppCache.sortFilterCacheDTO!.currentTheme = isDarkTheme;
        });
      });
      AppCache.getStringValue(AppCache.ACCESS_TOKEN_PREF).then((value) {
        if (Utils.isNotEmpty(value)) {
          EasyLoading.show(maskType: EasyLoadingMaskType.black);
          callGetUserDetail();
        } else {
          Navigator.pushReplacementNamed(context, AppRoutes.loginScreenRoute);
        }
      });
    });
  }

  callGetUserDetail() async {
    await getUserDetail(context).then((value) {
      if (AppCache.me != null) {
        if (Utils.isNotEmpty(AppCache.me!.data!.preferredLangCode)) {
          if (AppCache.me!.data!.preferredLangCode == Constants.CHINESE) {
            MyHomePage.setLocale(
                context, Utils.mylocale(Constants.LANGUAGE_CODE_CN));
          } else {
            MyHomePage.setLocale(
                context, Utils.mylocale(Constants.LANGUAGE_CODE_EN));
          }
        } else {
          MyHomePage.setLocale(
              context, Utils.mylocale(Constants.LANGUAGE_CODE_EN));
        }
        SortFilterCacheDTO sortFilterCacheDTO = SortFilterCacheDTO(
            preferredDays: AppCache.me!.data!.preferredDays,
            preferredCompany: AppCache.me!.data!.preferredCompany,
            preferredSite: AppCache.me!.data!.preferredSite,
            preferredStartDate: Utils.isNotEmpty(
                    AppCache.me!.data!.preferredDays)
                ? Utils.sortFilterStartDate(AppCache.me!.data!.preferredDays!)
                : DateTime.now(),
            preferredEndDate: DateTime.now(),
            startDate: Utils.isNotEmpty(AppCache.me!.data!.preferredDays)
                ? Utils.sortFilterStartDate(AppCache.me!.data!.preferredDays!)
                : DateTime.now(),
            endDate: DateTime.now(),
            defaultProjectId:
                AppCache.me!.data!.projectVersionsDTOs![0].defaultProjectId,
            displayProjectName:
                AppCache.me!.data!.projectVersionsDTOs![0].defaultProjectId);
        AppCache.sortFilterCacheDTO = sortFilterCacheDTO;
        Navigator.pushReplacementNamed(context, AppRoutes.homebaseroute);
      } else {
        AppCache.removeAuthToken();
        Navigator.pushReplacementNamed(context, AppRoutes.loginScreenRoute);
      }
    }, onError: (err) {
      Utils.printInfo(err);
      AppCache.getStringValue(AppCache.CUSTOM_SERVER_PREF).then((value) {
        if (Utils.isNotEmpty(value)) {
          Utils.printInfo("######################");
          List<dynamic> cacheServerList = jsonDecode(value);
          CustomServerDTO customServerDTO = cacheServerList
              .map((e) => CustomServerDTO.fromJson(e))
              .toList()
              .firstWhere((element) => element.isSelected!);
          Utils.printInfo(
              "###################### ${customServerDTO.serverName}");
          callUserLogout(context, customServerDTO);
        } else {
          AppCache.removeAuthToken();
          Navigator.pushReplacementNamed(context, AppRoutes.loginScreenRoute);
        }
      });
    }).whenComplete(() {
      setState(() {
        if (EasyLoading.isShow) {
          EasyLoading.dismiss();
        }
      });
    });
  }

  callUserLogout(BuildContext context, CustomServerDTO customServerDTO) {
    AppCache.getStringValue(AppCache.ID_TOKEN_PREF).then((idToken) async {
      if (Utils.isNotEmpty(idToken)) {
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
            AppCache.removeAuthToken();
            AppCache.me = null;
            AppCache.sortFilterCacheDTO = null;
            Navigator.pushReplacementNamed(context, AppRoutes.loginScreenRoute);
          }
        } catch (e) {
          Utils.printInfo(">>>>>>>>>>>>>>>>>>>>>");
          Utils.printInfo(e);
        }
      }
    });
  }

//ASSET_IMAGES_LIGHT
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeClass>(builder: (context, value, child) {
      AppCache.sortFilterCacheDTO!.currentTheme = value.getValue();
      return Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(100.0, 0, 100.0, 0),
                  child: Image.asset(value.getValue()
                      ? Constants.ASSET_IMAGES + 'keysight_logo_splash.png'
                      : Constants.ASSET_IMAGES_LIGHT +
                          'keysight_logo_splash.png'),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
