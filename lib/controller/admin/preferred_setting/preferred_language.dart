import 'package:flutter/material.dart';
import 'package:keysight_pma/cache/appcache.dart';
import 'package:keysight_pma/const/appcolors.dart';
import 'package:keysight_pma/const/appfonts.dart';
import 'package:keysight_pma/const/constants.dart';
import 'package:keysight_pma/const/utils.dart';

class PreferredLanguagePage extends StatefulWidget {
  final String? language;
  PreferredLanguagePage({Key? key, this.language}) : super(key: key);

  @override
  State<PreferredLanguagePage> createState() => _PreferredLanguagePageState();
}

class _PreferredLanguagePageState extends State<PreferredLanguagePage> {
  String? languageCode;
  bool? isDarkTheme;

  void initState() {
    super.initState();
    Utils.setFirebaseAnalyticsCurrentScreen(
        Constants.ANALYTICS_ADMIN_PREFERRED_LANG_SCREEN);
    setState(() {
      if (Utils.isNotEmpty(widget.language)) {
        this.languageCode = widget.language;
      } else {
        this.languageCode = Constants.ENGLISH;
      }

      this.isDarkTheme = AppCache.sortFilterCacheDTO!.currentTheme;
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
          Utils.getTranslated(context, 'preferredSetting_language')!,
          style: AppFonts.robotoRegular(20,
              color: isDarkTheme!
                  ? AppColors.appGrey()
                  : AppColorsLightMode.appGrey(),
              decoration: TextDecoration.none),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop(this.languageCode);
            },
            icon: Image.asset(
              isDarkTheme!
                  ? Constants.ASSET_IMAGES + 'back_bttn.png'
                  : Constants.ASSET_IMAGES_LIGHT + 'back_bttn.png',
            )),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 12, left: 16, right: 16),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  this.languageCode = Constants.ENGLISH;
                });
              },
              child: Container(
                padding: EdgeInsets.only(top: 12, right: 20, bottom: 10),
                color: Colors.transparent,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        Utils.getTranslated(context, 'setting_language_en')!,
                        style: AppFonts.robotoRegular(16,
                            color: isDarkTheme!
                                ? AppColors.appGrey2()
                                : AppColorsLightMode.appGrey(),
                            decoration: TextDecoration.none),
                      ),
                      (this.languageCode == Constants.ENGLISH)
                          ? Image.asset(
                              isDarkTheme!
                                  ? Constants.ASSET_IMAGES + 'tick_icon.png'
                                  : Constants.ASSET_IMAGES_LIGHT +
                                      'tick_icon.png',
                              height: 17,
                            )
                          : Container(),
                    ]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Divider(
                color: isDarkTheme!
                    ? AppColors.appDividerColor()
                    : AppColorsLightMode.appDividerColor(),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  this.languageCode = Constants.CHINESE;
                });
              },
              child: Container(
                padding: EdgeInsets.only(top: 12, right: 20, bottom: 10),
                color: Colors.transparent,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        Utils.getTranslated(context, 'setting_language_zh')!,
                        style: AppFonts.robotoRegular(16,
                            color: isDarkTheme!
                                ? AppColors.appGrey2()
                                : AppColorsLightMode.appGrey(),
                            decoration: TextDecoration.none),
                      ),
                      (this.languageCode == Constants.CHINESE)
                          ? Image.asset(
                              isDarkTheme!
                                  ? Constants.ASSET_IMAGES + 'tick_icon.png'
                                  : Constants.ASSET_IMAGES_LIGHT +
                                      'tick_icon.png',
                              height: 17,
                            )
                          : Container(),
                    ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
