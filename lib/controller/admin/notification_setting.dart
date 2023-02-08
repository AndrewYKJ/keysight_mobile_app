import 'package:flutter/material.dart';
import 'package:keysight_pma/cache/appcache.dart';
import 'package:keysight_pma/const/appcolors.dart';
import 'package:keysight_pma/const/appfonts.dart';
import 'package:keysight_pma/const/constants.dart';
import 'package:keysight_pma/const/utils.dart';
import 'package:keysight_pma/model/user.dart';

class NotificationSettings extends StatefulWidget {
  final UserDataDTO? user_info;
  const NotificationSettings({Key? key, this.user_info}) : super(key: key);

  @override
  State<NotificationSettings> createState() => _NotificationSettingsState();
}

class _NotificationSettingsState extends State<NotificationSettings> {
  bool? expireNotification;
  bool? emailNotification;

  bool? theme_dark = AppCache.sortFilterCacheDTO!.currentTheme;
  @override
  void initState() {
    super.initState();
    setState(() {
      expireNotification = widget.user_info!.expireNotification!;
      emailNotification = widget.user_info!.isSendEmailAlert!;
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
          Utils.getTranslated(context, 'notificationSetting_appbar')!,
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
            icon: Image.asset(
              theme_dark!
                  ? Constants.ASSET_IMAGES + 'back_bttn.png'
                  : Constants.ASSET_IMAGES_LIGHT + 'back_bttn.png',
            )),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.only(left: 16, right: 16),
        //margin: EdgeInsets.only(top: 26),
        color: theme_dark!
            ? AppColors.appPrimaryBlack()
            : AppColorsLightMode.appPrimaryBlack(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                SizedBox(
                  height: 26,
                ),
                expiryNotification(),
                SizedBox(
                  height: 37,
                ),
                emailNotifications(),
              ],
            ),
            saveButton(),
          ],
        ),
      ),
    );
  }

  Container saveButton() {
    return Container(
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          height: 40,
          padding: const EdgeInsets.all(12),
          color: AppColors.appPrimaryYellow(),
          width: 236,
          child: Text(
            Utils.getTranslated(context, 'save_changes')!,
            style: AppFonts.robotoMedium(14,
                color: AppColors.appPrimaryWhite(),
                decoration: TextDecoration.none),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Container expiryNotification() {
    return Container(
      color: theme_dark!
          ? AppColors.appPrimaryBlack()
          : AppColorsLightMode.appPrimaryBlack(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                Utils.getTranslated(context, 'notificationSetting_expire')!,
                style: AppFonts.robotoMedium(16,
                    color: theme_dark!
                        ? AppColors.appGrey2()
                        : AppColorsLightMode.appGrey(),
                    decoration: TextDecoration.none),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                Utils.getTranslated(
                    context, 'notificationSetting_expire_text')!,
                style: AppFonts.robotoRegular(16,
                    color: theme_dark!
                        ? AppColors.appGreyB1()
                        : AppColorsLightMode.appGrey77(),
                    decoration: TextDecoration.none),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                expireNotification = !expireNotification!;
                print(expireNotification);
              });
            },
            child: Container(
              color: Colors.transparent,
              margin: EdgeInsets.only(right: 14),
              padding: EdgeInsets.only(top: 20, bottom: 20),
              child: Image.asset(
                (expireNotification!)
                    ? Constants.ASSET_IMAGES + 'toggle_on.png'
                    : Constants.ASSET_IMAGES + 'toggle_off.png',
                height: 28,
              ),
            ),
          )
        ],
      ),
    );
  }

  Container emailNotifications() {
    return Container(
      color: theme_dark!
          ? AppColors.appPrimaryBlack()
          : AppColorsLightMode.appPrimaryBlack(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                Utils.getTranslated(context, 'notificationSetting_email')!,
                style: AppFonts.robotoMedium(16,
                    color: theme_dark!
                        ? AppColors.appGrey2()
                        : AppColorsLightMode.appGrey(),
                    decoration: TextDecoration.none),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                width: 232,
                child: Text(
                  Utils.getTranslated(
                      context, 'notificationSetting_email_text')!,
                  style: AppFonts.robotoRegular(16,
                      color: theme_dark!
                          ? AppColors.appGreyB1()
                          : AppColorsLightMode.appGrey77(),
                      decoration: TextDecoration.none),
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                emailNotification = !emailNotification!;
              });
            },
            child: Container(
              margin: EdgeInsets.only(right: 14),
              color: Colors.transparent,
              padding: EdgeInsets.only(top: 20, bottom: 20),
              child: Image.asset(
                (emailNotification!)
                    ? Constants.ASSET_IMAGES + 'toggle_on.png'
                    : Constants.ASSET_IMAGES + 'toggle_off.png',
                height: 28,
              ),
            ),
          )
        ],
      ),
    );
  }
}
