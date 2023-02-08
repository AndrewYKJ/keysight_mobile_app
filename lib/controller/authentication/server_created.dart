import 'package:flutter/material.dart';
import 'package:keysight_pma/cache/appcache.dart';
import 'package:keysight_pma/const/appcolors.dart';
import 'package:keysight_pma/const/appfonts.dart';
import 'package:keysight_pma/const/constants.dart';
import 'package:keysight_pma/const/utils.dart';
import 'package:keysight_pma/routes/approutes.dart';

class ServerCreated extends StatefulWidget {
  ServerCreated({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ServerCreated();
  }
}

class _ServerCreated extends State<ServerCreated> {
  bool? isDarkTheme = true;

  @override
  void initState() {
    super.initState();
    Utils.setFirebaseAnalyticsCurrentScreen(
        Constants.ANALYTICS_CUSTOM_SERVER_SUCCESS_SCREEN);
    setState(() {
      AppCache.getbooleanValue(AppCache.APP_THEME_PREF).then((value) {
        if (value) {
          isDarkTheme = value;
        } else {
          isDarkTheme = true;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: isDarkTheme!
              ? AppColors.appPrimaryBlack()
              : AppColorsLightMode.appPrimaryBlack(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  SizedBox(
                    height: 234,
                  ),
                  Image.asset(
                    Constants.ASSET_IMAGES + 'created_successfully.png',
                    width: 110,
                    height: 110,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 20,
                      top: 35,
                    ),
                    child: Text(
                      Utils.getTranslated(context, 'server_created')!,
                      style: AppFonts.robotoMedium(18,
                          color: isDarkTheme!
                              ? AppColors.appGreyDE()
                              : AppColorsLightMode.appGrey(),
                          decoration: TextDecoration.none),
                    ),
                  ),
                  Text(
                    Utils.getTranslated(context, 'server_login')!,
                    style: AppFonts.robotoRegular(15,
                        color: isDarkTheme!
                            ? AppColors.appGreyB1()
                            : AppColorsLightMode.appGrey77(),
                        decoration: TextDecoration.none),
                  ),
                ],
              ),
              Container(
                width: 236,
                margin: EdgeInsets.only(bottom: 30),
                padding: EdgeInsets.only(top: 12, bottom: 12),
                color: AppColors.appPrimaryYellow(),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.loginScreenRoute,
                        (Route<dynamic> route) => false);
                  },
                  child: Text(
                    Utils.getTranslated(context, 'server_gotoLogin')!,
                    textAlign: TextAlign.center,
                    style: AppFonts.robotoMedium(15,
                        color: AppColors.appPrimaryWhite(),
                        decoration: TextDecoration.none),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      onWillPop: () async {
        return false;
      },
    );
  }
}
