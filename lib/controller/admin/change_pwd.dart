import 'package:flutter/material.dart';
import 'package:keysight_pma/cache/appcache.dart';
import 'package:keysight_pma/const/appcolors.dart';
import 'package:keysight_pma/const/appfonts.dart';
import 'package:keysight_pma/const/constants.dart';
import 'package:keysight_pma/const/utils.dart';

class Change_pwd extends StatefulWidget {
  const Change_pwd({Key? key}) : super(key: key);

  @override
  State<Change_pwd> createState() => _Account_infoState();
}

class _Account_infoState extends State<Change_pwd> {
  final oldPwd = TextEditingController();
  final newPwd = TextEditingController();
  final cmfPwd = TextEditingController();

  bool? theme_dark;
  @override
  void initState() {
    super.initState();
    setState(() {
      theme_dark = AppCache.sortFilterCacheDTO!.currentTheme;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme_dark!
            ? AppColors.serverAppBar()
            : AppColorsLightMode.serverAppBar(),
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          Utils.getTranslated(context, 'chgPWD_appbar_title')!,
          style: AppFonts.robotoRegular(
            20,
            color: theme_dark!
                ? AppColors.appGrey()
                : AppColorsLightMode.appPrimaryWhite(),
            decoration: TextDecoration.none,
          ),
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
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height - 80,
          margin: EdgeInsets.only(left: 17, right: 17),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 26,
                        ),
                        Text(
                          Utils.getTranslated(context, 'chgPWD_header')!,
                          style: AppFonts.robotoMedium(
                            16,
                            color: theme_dark!
                                ? AppColors.appGrey2()
                                : AppColorsLightMode.appPrimaryWhite(),
                            decoration: TextDecoration.none,
                          ),
                        ),
                        SizedBox(
                          height: 26,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Text(
                            Utils.getTranslated(context, 'chgPWD_oldpwd')!,
                            style: AppFonts.robotoMedium(
                              16,
                              color: theme_dark!
                                  ? AppColors.appGreyB1()
                                  : AppColorsLightMode.appPrimaryWhite(),
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 10),
                          decoration: BoxDecoration(
                              color: theme_dark!
                                  ? AppColors.appPrimaryWhite().withOpacity(0.1)
                                  : AppColors.appPrimaryWhite(),
                              border: Border.all(
                                color: theme_dark!
                                    ? AppColors.appPrimaryWhite()
                                        .withOpacity(0.1)
                                    : AppColorsLightMode.appGreyED(),
                              ),
                              borderRadius: BorderRadius.circular(8)),
                          child: TextField(
                            style: TextStyle(
                              color: theme_dark!
                                  ? AppColors.appPrimaryWhite()
                                  : AppColorsLightMode.appPrimaryWhite(),
                            ),
                            controller: oldPwd,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                hintText: Utils.getTranslated(
                                    context, 'chgPWD_oldpwd_hinttext')!,
                                hintStyle:
                                    TextStyle(color: AppColors.appGrey9A())),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Text(
                            Utils.getTranslated(context, 'chgPWD_newpwd')!,
                            style: AppFonts.robotoMedium(
                              16,
                              color: theme_dark!
                                  ? AppColors.appGreyB1()
                                  : AppColorsLightMode.appPrimaryWhite(),
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 10),
                          decoration: BoxDecoration(
                              color: theme_dark!
                                  ? AppColors.appPrimaryWhite().withOpacity(0.1)
                                  : AppColors.appPrimaryWhite(),
                              border: Border.all(
                                color: theme_dark!
                                    ? AppColors.appPrimaryWhite()
                                        .withOpacity(0.1)
                                    : AppColorsLightMode.appGreyED(),
                              ),
                              borderRadius: BorderRadius.circular(8)),
                          child: TextField(
                            style: TextStyle(
                              color: theme_dark!
                                  ? AppColors.appPrimaryWhite()
                                  : AppColorsLightMode.appPrimaryWhite(),
                            ),
                            controller: newPwd,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                hintText: Utils.getTranslated(
                                    context, 'chgPWD_newpwd_hinttext')!,
                                hintStyle:
                                    TextStyle(color: AppColors.appGrey9A())),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Text(
                            Utils.getTranslated(context, 'chgPWD_cfmnewpwd')!,
                            style: AppFonts.robotoMedium(
                              16,
                              color: theme_dark!
                                  ? AppColors.appGreyB1()
                                  : AppColorsLightMode.appPrimaryWhite(),
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 10),
                          decoration: BoxDecoration(
                              color: theme_dark!
                                  ? AppColors.appPrimaryWhite().withOpacity(0.1)
                                  : AppColors.appPrimaryWhite(),
                              border: Border.all(
                                color: theme_dark!
                                    ? AppColors.appPrimaryWhite()
                                        .withOpacity(0.1)
                                    : AppColorsLightMode.appGreyED(),
                              ),
                              borderRadius: BorderRadius.circular(8)),
                          child: TextField(
                            style: TextStyle(
                              color: theme_dark!
                                  ? AppColors.appPrimaryWhite()
                                  : AppColorsLightMode.appPrimaryWhite(),
                            ),
                            controller: cmfPwd,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                hintText: Utils.getTranslated(
                                    context, 'chgPWD_cfmnewpwd_hinttext')!,
                                hintStyle:
                                    TextStyle(color: AppColors.appGrey9A())),
                          ),
                        )
                      ],
                    )),
                Container(
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: 40,
                      padding: const EdgeInsets.all(12),
                      color: AppColors.appSaveButton(),
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
                ),
              ]),
        ),
      ),
    );
  }
}
