import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:keysight_pma/cache/appcache.dart';
import 'package:keysight_pma/const/appcolors.dart';
import 'package:keysight_pma/const/appfonts.dart';
import 'package:keysight_pma/const/constants.dart';
import 'package:keysight_pma/const/utils.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatefulWidget {
  AboutPage({Key? key}) : super(key: key);

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  _launchBrowser(Uri website) async {
    Uri url = website;
    if (!await launchUrl(url)) throw 'Could not launch $url';
  }

  final Uri learnMore = Uri(
      scheme: 'https',
      host: 'www.keysight.com',
      path:
          '/sg/en/products/software/pathwave-test-software/pathwave-manufacturing-analytics.html');

  final Uri thirdParty = Uri(
      scheme: 'http',
      host: 'pwasit21.sgp.is.keysight.com',
      path: '/3rdpartylicenses.txt');

  bool? isDarkTheme;
  @override
  void initState() {
    super.initState();
    Utils.setFirebaseAnalyticsCurrentScreen(Constants.ANALYTICS_ABOUT_SCREEN);
    isDarkTheme = AppCache.sortFilterCacheDTO!.currentTheme;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: isDarkTheme!
            ? AppColors.serverAppBar()
            : AppColorsLightMode.serverAppBar(),
        title: Padding(
          padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
          child: Text(
            Utils.getTranslated(context, 'about_pma_appbar_title')!,
            style: AppFonts.robotoRegular(
              20,
              color: isDarkTheme!
                  ? AppColors.appGrey()
                  : AppColorsLightMode.appGrey(),
              decoration: TextDecoration.none,
            ),
          ),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Image.asset(
            isDarkTheme!
                ? Constants.ASSET_IMAGES + 'back_bttn.png'
                : Constants.ASSET_IMAGES_LIGHT + 'back_bttn.png',
          ),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(
              height: 21,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 23.0),
              child: Text(
                Utils.getTranslated(context, 'about_pma_title')!,
                style: AppFonts.robotoRegular(16,
                    color: isDarkTheme!
                        ? AppColors.appGrey2()
                        : AppColorsLightMode.appPrimaryWhite(),
                    decoration: TextDecoration.none),
              ),
            ),
            Row(
              children: [
                Image.asset(
                  Constants.ASSET_IMAGES + 'about_pwa.png',
                  height: 64,
                ),
                Container(
                  padding: EdgeInsets.only(left: 17),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          Utils.getTranslated(context, 'about_pma_version')!,
                          style: AppFonts.robotoRegular(16,
                              color: isDarkTheme!
                                  ? AppColors.appGrey2()
                                  : AppColorsLightMode.appPrimaryWhite(),
                              decoration: TextDecoration.none),
                        ),
                        SizedBox(
                          height: 7,
                        ),
                        Text(
                          Utils.getTranslated(context, 'about_pma_poweredBy')!,
                          style: AppFonts.robotoLight(14,
                              color: isDarkTheme!
                                  ? AppColors.appGrey2()
                                  : AppColorsLightMode.appGrey5B(),
                              decoration: TextDecoration.none),
                        ),
                      ]),
                )
              ],
            ),
            SizedBox(
              height: 23,
            ),
            Text(
              Utils.getTranslated(context, 'about_pma_text')!,
              style: AppFonts.robotoLight(14,
                  color: isDarkTheme!
                      ? AppColors.appGrey2()
                      : AppColorsLightMode.appPrimaryWhite(),
                  decoration: TextDecoration.none),
            ),
            SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                _launchBrowser(learnMore);
              },
              child: Container(
                padding: EdgeInsets.only(top: 12, bottom: 9),
                child: Text(
                  Utils.getTranslated(context, 'about_pma_learnMore')!,
                  style: AppFonts.robotoMedium(14,
                      color: AppColors.appBlue(),
                      decoration: TextDecoration.none),
                ),
              ),
            ),
            SizedBox(
              height: 4,
            ),
            GestureDetector(
              onTap: () {
                _launchBrowser(thirdParty);
              },
              child: Container(
                padding: EdgeInsets.only(top: 8, bottom: 9),
                child: Text(
                  Utils.getTranslated(
                      context, 'about_pma_thirdpartiesLicense')!,
                  style: AppFonts.robotoMedium(14,
                      color: AppColors.appBlue(),
                      decoration: TextDecoration.none),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
