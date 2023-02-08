import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:keysight_pma/cache/appcache.dart';
import 'package:keysight_pma/const/appcolors.dart';
import 'package:keysight_pma/const/appfonts.dart';
import 'package:keysight_pma/const/constants.dart';
import 'package:keysight_pma/const/themedata.dart';
import 'package:keysight_pma/const/utils.dart';
import 'package:keysight_pma/main.dart';
import 'package:keysight_pma/model/custom_server/server.dart';
import 'package:keysight_pma/routes/approutes.dart';
import 'package:provider/provider.dart';

class CustomServer extends StatefulWidget {
  const CustomServer({Key? key}) : super(key: key);

  @override
  State<CustomServer> createState() => _CustomServer();
}

class _CustomServer extends State<CustomServer> {
  final nameTextController = TextEditingController();
  final ipTextController = TextEditingController();
  final portTextController = TextEditingController();
  var dio = Dio();

  String languageCode = Constants.LANGUAGE_CODE_EN;
  String curLang = '';
  bool? isDarkTheme;

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
                                  : AppColorsLightMode.appPrimaryWhite(),
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
              SizedBox(
                height: 138,
              ),
              GestureDetector(
                onTap: () {
                  this.curLang = this.languageCode;
                  AppCache.setString(
                      AppCache.LANGUAGE_CODE_PREF, this.languageCode);
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

  getHttp(String url) async {
    try {
      var response =
          await Dio().get(url + '/pma-mobile-services/api/getServerStatus');
      Utils.printInfo(response);
      return response.statusCode;
    } catch (e) {
      return e;
    }
  }

  @override
  void dispose() {
    nameTextController.dispose();
    ipTextController.dispose();
    portTextController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Utils.setFirebaseAnalyticsCurrentScreen(
        Constants.ANALYTICS_CUSTOM_SERVER_SCREEN);
    AppCache.getStringValue(AppCache.LANGUAGE_CODE_PREF).then((value) {
      setState(() {
        if (Utils.isNotEmpty(value)) {
          Utils.printInfo("############# $value");
          this.languageCode = value;
        } else {
          this.languageCode = Constants.LANGUAGE_CODE_EN;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Consumer<ThemeClass>(builder: (context, value, child) {
      isDarkTheme = value.getValue();

      return Scaffold(
        appBar: AppBar(
          backgroundColor: isDarkTheme!
              ? AppColors.appPrimaryBlack()
              : AppColorsLightMode.serverAppBar(),
          centerTitle: true,
          title: Text(
            Utils.getTranslated(context, 'login_addCustomServer')!,
            style: AppFonts.robotoRegular(
              20,
              color: isDarkTheme!
                  ? AppColors.appGrey()
                  : AppColorsLightMode.appGrey(),
              decoration: TextDecoration.none,
            ),
          ),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Image.asset(
                isDarkTheme!
                    ? Constants.ASSET_IMAGES + 'back_bttn.png'
                    : Constants.ASSET_IMAGES_LIGHT + 'back_bttn.png',
              )),
        ),
        body: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              color: isDarkTheme!
                  ? AppColors.appPrimaryBlack()
                  : AppColorsLightMode.appPrimaryBlack(),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - kToolbarHeight,
              margin: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 27,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            Utils.getTranslated(context, 'customServer_name')!,
                            style: AppFonts.robotoMedium(
                              16,
                              color: isDarkTheme!
                                  ? AppColors.appGreyB1()
                                  : AppColorsLightMode.appPrimaryWhite(),
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(8),
                          padding: const EdgeInsets.only(left: 10),
                          decoration: BoxDecoration(
                              color: isDarkTheme!
                                  ? AppColors.appPrimaryWhite().withOpacity(0.1)
                                  : AppColors.appPrimaryWhite(),
                              border: Border.all(
                                color: isDarkTheme!
                                    ? AppColors.appPrimaryWhite()
                                        .withOpacity(0.1)
                                    : AppColorsLightMode.appGreyED(),
                              ),
                              borderRadius: BorderRadius.circular(8)),
                          child: TextField(
                            style: TextStyle(
                              color: isDarkTheme!
                                  ? AppColors.appPrimaryWhite()
                                  : AppColorsLightMode.appPrimaryWhite(),
                            ),
                            controller: nameTextController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              hintText: Utils.getTranslated(
                                  context, 'customServer_hintName')!,
                              hintStyle: AppFonts.robotoRegular(
                                15,
                                color: AppColors.appGrey9A(),
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            Utils.getTranslated(context, 'customServer_ip')!,
                            style: AppFonts.robotoMedium(
                              16,
                              color: isDarkTheme!
                                  ? AppColors.appGreyB1()
                                  : AppColorsLightMode.appPrimaryWhite(),
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(8),
                          padding: const EdgeInsets.only(left: 10),
                          decoration: BoxDecoration(
                              color: isDarkTheme!
                                  ? AppColors.appPrimaryWhite().withOpacity(0.1)
                                  : AppColors.appPrimaryWhite(),
                              border: Border.all(
                                color: isDarkTheme!
                                    ? AppColors.appPrimaryWhite()
                                        .withOpacity(0.1)
                                    : AppColorsLightMode.appGreyED(),
                              ),
                              borderRadius: BorderRadius.circular(8)),
                          child: TextField(
                            style: TextStyle(
                              color: isDarkTheme!
                                  ? AppColors.appPrimaryWhite()
                                  : AppColorsLightMode.appPrimaryWhite(),
                            ),
                            controller: ipTextController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              hintText: Utils.getTranslated(
                                  context, 'customServer_hintIP')!,
                              hintStyle: AppFonts.robotoRegular(
                                15,
                                color: AppColors.appGrey9A(),
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            Utils.getTranslated(context, 'customServer_port')!,
                            style: AppFonts.robotoMedium(
                              16,
                              color: isDarkTheme!
                                  ? AppColors.appGreyB1()
                                  : AppColorsLightMode.appPrimaryWhite(),
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(8),
                          padding: const EdgeInsets.only(left: 10),
                          decoration: BoxDecoration(
                              color: isDarkTheme!
                                  ? AppColors.appPrimaryWhite().withOpacity(0.1)
                                  : AppColors.appPrimaryWhite(),
                              border: Border.all(
                                color: isDarkTheme!
                                    ? AppColors.appPrimaryWhite()
                                        .withOpacity(0.1)
                                    : AppColorsLightMode.appGreyED(),
                              ),
                              borderRadius: BorderRadius.circular(8)),
                          child: TextField(
                            style: TextStyle(
                              color: isDarkTheme!
                                  ? AppColors.appPrimaryWhite()
                                  : AppColorsLightMode.appPrimaryWhite(),
                            ),
                            controller: portTextController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              hintText: Utils.getTranslated(
                                  context, 'customServer_port')!,
                              hintStyle: AppFonts.robotoRegular(
                                15,
                                color: AppColors.appGrey9A(),
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 150),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          color: (nameTextController.text.trim().isNotEmpty &&
                                  ipTextController.text.trim().isNotEmpty)
                              ? AppColors.appPrimaryYellow()
                              : AppColors.appSaveButton(),
                          width: 236,
                          child: GestureDetector(
                            onTap: () async {
                              if (nameTextController.text.trim().isNotEmpty &&
                                  ipTextController.text.trim().isNotEmpty) {
                                String data =
                                    portTextController.text.trim().isNotEmpty
                                        ? ipTextController.text.trim() +
                                            ":" +
                                            portTextController.text.trim()
                                        : ipTextController.text.trim();

                                Utils.printInfo(data);
                                if (!data.startsWith("http")) {
                                  Utils.showAlertDialog(
                                      context,
                                      Utils.getTranslated(
                                          context, 'alert_dialog_info_title')!,
                                      Utils.getTranslated(context,
                                          'alert_dialog_url_not_valid')!);
                                } else {
                                  bool isExist = false;
                                  EasyLoading.show(
                                      maskType: EasyLoadingMaskType.black);
                                  final response = await getHttp(data);
                                  Utils.printInfo(response);
                                  if (response == 200) {
                                    AppCache.getStringValue(
                                            AppCache.CUSTOM_SERVER_PREF)
                                        .then((value) {
                                      List<CustomServerDTO> customServerList =
                                          [];
                                      if (Utils.isNotEmpty(value)) {
                                        List<dynamic> cacheServerList =
                                            jsonDecode(value);
                                        customServerList = cacheServerList
                                            .map((e) =>
                                                CustomServerDTO.fromJson(e))
                                            .toList();
                                        customServerList.forEach((element) {
                                          if (element.serverIp ==
                                                  ipTextController.text
                                                      .trim() &&
                                              element.serverPort ==
                                                  portTextController.text
                                                      .trim()) {
                                            isExist = true;
                                          }
                                          element.isSelected = false;
                                        });
                                        if (isExist) {
                                          Utils.showAlertDialog(
                                              context,
                                              Utils.getTranslated(context,
                                                  'alert_dialog_info_title')!,
                                              "Ip Address / Domain exits");
                                        } else {
                                          customServerList.add(CustomServerDTO(
                                              serverIp: ipTextController.text,
                                              serverName:
                                                  nameTextController.text,
                                              serverPort:
                                                  portTextController.text,
                                              isSelected: true));
                                          AppCache.setString(
                                              AppCache.CUSTOM_SERVER_PREF,
                                              jsonEncode(customServerList));
                                        }
                                      } else {
                                        customServerList.add(CustomServerDTO(
                                            serverIp: ipTextController.text,
                                            serverName: nameTextController.text,
                                            serverPort: portTextController.text,
                                            isSelected: true));
                                      }
                                    }).whenComplete(() {
                                      EasyLoading.dismiss();
                                      if (!isExist) {
                                        Navigator.pushReplacementNamed(context,
                                            AppRoutes.serverCreatedRoute);
                                      }
                                    });
                                  } else {
                                    EasyLoading.dismiss();
                                    Utils.showAlertDialog(
                                        context,
                                        Utils.getTranslated(context,
                                            'alert_dialog_info_title')!,
                                        Utils.getTranslated(context,
                                            'alert_dialog_invalid_server')!);
                                  }
                                }
                              }
                            },
                            child: Text(
                              Utils.getTranslated(context, 'create')!,
                              style: AppFonts.robotoRegular(15,
                                  color: AppColors.appPrimaryWhite(),
                                  decoration: TextDecoration.none),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: () => _localization(context, width),
                          child: Container(
                            padding: EdgeInsets.all(18),
                            width: width * 0.4,
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
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
