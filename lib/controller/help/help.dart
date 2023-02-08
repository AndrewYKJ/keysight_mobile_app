import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:keysight_pma/cache/appcache.dart';
import 'package:keysight_pma/const/appcolors.dart';
import 'package:keysight_pma/const/appfonts.dart';
import 'package:keysight_pma/const/constants.dart';
import 'package:keysight_pma/const/utils.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({Key? key}) : super(key: key);

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  _launchBrowser(Uri website) async {
    Uri url = website;
    if (!await launchUrl(url)) throw 'Could not launch $url';
  }

  final Uri contentUrl = Uri(
      scheme: 'https',
      host: 'edadocs.software.keysight.com',
      path: 'display/kkb/PathWave+Manufacturing+Analytics+Collection+Page');
  // String content_url =
  //    ' https://edadocs.software.keysight.com/display/kkb/PathWave+Manufacturing+Analytics+Collection+Page';

  final Uri contactTechSupport = Uri(
      scheme: 'https',
      host: 'www.keysight.com',
      path: 'main/contactInformation.jspx',
      queryParameters: {'nid': '-11143.0.00', 'lc': 'eng', 'cc': 'US'});
  //String contact_tech_support =
  //    " https://www.keysight.com/main/contactInformation.jspx?nid=-11143.0.00&lc=eng&cc=US";
  bool? isDarkTheme;

  @override
  void initState() {
    super.initState();
    Utils.setFirebaseAnalyticsCurrentScreen(Constants.ANALYTICS_HELP_SCREEN);
    isDarkTheme = AppCache.sortFilterCacheDTO!.currentTheme;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
        centerTitle: true,
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
        title: Text(
          Utils.getTranslated(context, "help")!,
          style: AppFonts.robotoRegular(20,
              color: isDarkTheme!
                  ? AppColors.appPrimaryWhite()
                  : AppColorsLightMode.appPrimaryWhite(),
              decoration: TextDecoration.none),
          textAlign: TextAlign.center,
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 38),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(
              height: 23,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Text(
                Utils.getTranslated(context, 'help_pma')!,
                style: AppFonts.robotoRegular(14,
                    color: AppColors.appGrey96(),
                    decoration: TextDecoration.none),
              ),
            ),
            GestureDetector(
              onTap: (() {
                _launchBrowser(contentUrl);
              }),
              child: Container(
                padding: const EdgeInsets.only(top: 14, bottom: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      Utils.getTranslated(context, 'help_contents')!,
                      style: AppFonts.robotoRegular(16,
                          color: isDarkTheme!
                              ? AppColors.appGreyED()
                              : AppColorsLightMode.appPrimaryWhite(),
                          decoration: TextDecoration.none),
                    ),
                    Image.asset(
                      isDarkTheme!
                          ? Constants.ASSET_IMAGES + 'next_bttn.png'
                          : Constants.ASSET_IMAGES_LIGHT + 'next_bttn.png',
                      height: 17,
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 35,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Text(
                Utils.getTranslated(context, 'help_ts')!,
                style: AppFonts.robotoRegular(14,
                    color: AppColors.appGrey96(),
                    decoration: TextDecoration.none),
              ),
            ),
            GestureDetector(
              onTap: (() {
                _launchBrowser(contactTechSupport);
              }),
              child: Container(
                padding: const EdgeInsets.only(top: 14, bottom: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      Utils.getTranslated(context, 'help_cts')!,
                      style: AppFonts.robotoRegular(16,
                          color: isDarkTheme!
                              ? AppColors.appGreyED()
                              : AppColorsLightMode.appPrimaryWhite(),
                          decoration: TextDecoration.none),
                    ),
                    Image.asset(
                      isDarkTheme!
                          ? Constants.ASSET_IMAGES + 'next_bttn.png'
                          : Constants.ASSET_IMAGES_LIGHT + 'next_bttn.png',
                      height: 17,
                    )
                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
