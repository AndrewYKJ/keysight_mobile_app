import 'package:flutter/material.dart';
import 'package:keysight_pma/cache/appcache.dart';

import 'package:keysight_pma/const/appcolors.dart';
import 'package:keysight_pma/const/appfonts.dart';
import 'package:keysight_pma/const/constants.dart';
import 'package:keysight_pma/const/utils.dart';

class SelectByDays extends StatefulWidget {
  const SelectByDays({Key? key}) : super(key: key);

  @override
  State<SelectByDays> createState() => _SelectByDaysState();
}

class _SelectByDaysState extends State<SelectByDays> {
  var month;

  String? value;

  int getMonth() {
    var now = DateTime.now();
    var month = now.month;
    if ((month % 2) == 0) {
      if (month == 2) {
        return 28;
      } else if (month == 8) {
        return 31;
      } else {
        return 30;
      }
    } else {
      return 31;
    }
  }

  bool? theme_dark;
  @override
  void initState() {
    super.initState();
    Utils.setFirebaseAnalyticsCurrentScreen(
        Constants.ANALYTICS_ADMIN_PREFERRED_DAY_SELECTION_SCREEN);
    month = (getMonth());

    print(month.toString());
    setState(() {
      theme_dark = AppCache.sortFilterCacheDTO!.currentTheme;
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
              theme_dark!
                  ? AppColors.serverAppBar()
                  : AppColorsLightMode.serverAppBar(),
              theme_dark!
                  ? AppColors.serverAppBar()
                  : AppColorsLightMode.serverAppBar(),
            ]))),
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          Utils.getTranslated(context, 'preferredSetting_date')!,
          style: AppFonts.robotoRegular(20,
              color: theme_dark!
                  ? AppColors.appGrey()
                  : AppColorsLightMode.appGrey(),
              decoration: TextDecoration.none),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Image.asset(theme_dark!
                ? Constants.ASSET_IMAGES + 'back_bttn.png'
                : Constants.ASSET_IMAGES_LIGHT + 'back_bttn.png')),
      ),
      body: SingleChildScrollView(
        child: Container(
            margin: EdgeInsets.only(top: 12, left: 16, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var i = 1; i <= month; i++)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            value = i.toString();
                          });
                          Navigator.of(context).pop(value);
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding:
                              EdgeInsets.only(top: 12, right: 20, bottom: 10),
                          color: Colors.transparent,
                          child: Text(
                            ('${i.toString()} ' +
                                Utils.getTranslated(context, 'setting_day')!),
                            style: AppFonts.robotoRegular(16,
                                color: theme_dark!
                                    ? AppColors.appGrey()
                                    : AppColorsLightMode.appPrimaryWhite(),
                                decoration: TextDecoration.none),
                          ),
                        ),
                      ),
                      (i == month)
                          ? Text('')
                          : Padding(
                              padding:
                                  const EdgeInsets.only(top: 10, bottom: 10),
                              child: Divider(
                                color: theme_dark!
                                    ? AppColors.appDividerColor()
                                    : AppColorsLightMode.appDividerColor(),
                              ),
                            ),
                    ],
                  ),
              ],
            )),
      ),
    );
  }
}
