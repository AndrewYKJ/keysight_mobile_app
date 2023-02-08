import 'package:flutter/material.dart';
import 'package:keysight_pma/cache/appcache.dart';
import 'package:keysight_pma/const/appcolors.dart';
import 'package:keysight_pma/const/appfonts.dart';
import 'package:keysight_pma/const/constants.dart';
import 'package:keysight_pma/const/utils.dart';
import 'package:keysight_pma/dio/api/user.dart';
import 'package:keysight_pma/model/user.dart';

class AccountInfo extends StatefulWidget {
  const AccountInfo({
    Key? key,
  }) : super(key: key);

  @override
  State<AccountInfo> createState() => _AccountInfoState();
}

class _AccountInfoState extends State<AccountInfo> {
  UserDTO? _user;
  bool? theme_dark;
  late UserDataDTO user_info;
  bool isLoading = true;

  Future<void> _getData() async {
    getUserProfile();
  }

  void getUserProfile() {
    UserApi userProfileApi = UserApi(context);

    userProfileApi.getUserDetail().then((data) {
      _user = data;
    }).whenComplete(() {
      setState(() {
        this.isLoading = false;
        user_info = _user!.data!;
        AppCache.me = _user;
      });
    }).catchError((error) {});
  }

  @override
  void initState() {
    super.initState();
    Utils.setFirebaseAnalyticsCurrentScreen(
        Constants.ANALYTICS_ADMIN_ACCOUNT_INFO_SCREEN);
    _getData();
    setState(() {
      theme_dark = AppCache.sortFilterCacheDTO!.currentTheme;
    });
    //print(widget.user_info.emailId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
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
        title: Text(
          Utils.getTranslated(context, 'account_appbar_title')!,
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
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.appBlue()),
              ),
            )
          : Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.only(left: 16, right: 16),
              //margin: EdgeInsets.only(top: 26),

              child: ListView(
                physics: NeverScrollableScrollPhysics(),
                children: [
                  SizedBox(
                    height: 26,
                  ),
                  username(),
                  SizedBox(
                    height: 17,
                  ),
                  firstName(),
                  SizedBox(
                    height: 17,
                  ),
                  lastName(),
                  SizedBox(
                    height: 17,
                  ),
                  email(),
                  SizedBox(
                    height: 17,
                  ),
                  phone(),
                  SizedBox(
                    height: 17,
                  )
                ],
              ),
            ),
    );
  }

  Container phone() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Utils.getTranslated(context, 'account_phone_no')!,
            style: AppFonts.robotoMedium(
              16,
              color: theme_dark!
                  ? AppColors.appGreyB1()
                  : AppColorsLightMode.appGrey77(),
              decoration: TextDecoration.none,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15, bottom: 20),
            child: Text(
              user_info.phoneNumber != null ? user_info.phoneNumber! : "-",
              style: AppFonts.robotoRegular(
                16,
                color: theme_dark!
                    ? AppColors.appGreyDE()
                    : AppColorsLightMode.appGrey(),
                decoration: TextDecoration.none,
              ),
            ),
          ),
          Divider(
            color: theme_dark!
                ? AppColors.appDividerColor()
                : AppColorsLightMode.appDividerColor(),
          )
        ],
      ),
    );
  }

  Container email() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Utils.getTranslated(context, 'account_email')!,
            style: AppFonts.robotoMedium(
              16,
              color: theme_dark!
                  ? AppColors.appGreyB1()
                  : AppColorsLightMode.appGrey77(),
              decoration: TextDecoration.none,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15, bottom: 20),
            child: Text(
              user_info.emailId != null ? user_info.emailId! : "-",
              style: AppFonts.robotoRegular(
                16,
                color: theme_dark!
                    ? AppColors.appGreyDE()
                    : AppColorsLightMode.appGrey(),
                decoration: TextDecoration.none,
              ),
            ),
          ),
          Divider(
            color: theme_dark!
                ? AppColors.appDividerColor()
                : AppColorsLightMode.appDividerColor(),
          )
        ],
      ),
    );
  }

  Container lastName() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Utils.getTranslated(context, 'account_lastName')!,
            style: AppFonts.robotoMedium(
              16,
              color: theme_dark!
                  ? AppColors.appGreyB1()
                  : AppColorsLightMode.appGrey77(),
              decoration: TextDecoration.none,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15, bottom: 20),
            child: Text(
              user_info.lastName != null ? user_info.lastName! : "-",
              style: AppFonts.robotoRegular(
                16,
                color: theme_dark!
                    ? AppColors.appGreyDE()
                    : AppColorsLightMode.appGrey(),
                decoration: TextDecoration.none,
              ),
            ),
          ),
          Divider(
            color: theme_dark!
                ? AppColors.appDividerColor()
                : AppColorsLightMode.appDividerColor(),
          )
        ],
      ),
    );
  }

  Container firstName() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Utils.getTranslated(context, 'account_firstName')!,
            style: AppFonts.robotoMedium(
              16,
              color: theme_dark!
                  ? AppColors.appGreyB1()
                  : AppColorsLightMode.appGrey77(),
              decoration: TextDecoration.none,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15, bottom: 20),
            child: Text(
              user_info.firstName != null ? user_info.firstName! : "-",
              style: AppFonts.robotoRegular(
                16,
                color: theme_dark!
                    ? AppColors.appGreyDE()
                    : AppColorsLightMode.appGrey(),
                decoration: TextDecoration.none,
              ),
            ),
          ),
          Divider(
            color: theme_dark!
                ? AppColors.appDividerColor()
                : AppColorsLightMode.appDividerColor(),
          )
        ],
      ),
    );
  }

  Container username() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Utils.getTranslated(context, 'account_username')!,
            style: AppFonts.robotoMedium(
              16,
              color: theme_dark!
                  ? AppColors.appGreyB1()
                  : AppColorsLightMode.appGrey77(),
              decoration: TextDecoration.none,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15, bottom: 20),
            child: Text(
              user_info.userName != null ? user_info.userName! : "-",
              style: AppFonts.robotoRegular(
                16,
                color: theme_dark!
                    ? AppColors.appGreyDE()
                    : AppColorsLightMode.appGrey(),
                decoration: TextDecoration.none,
              ),
            ),
          ),
          Divider(
            color: theme_dark!
                ? AppColors.appDividerColor()
                : AppColorsLightMode.appDividerColor(),
          )
        ],
      ),
    );
  }
}
