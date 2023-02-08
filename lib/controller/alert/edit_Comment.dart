import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:keysight_pma/cache/appcache.dart';

import 'package:keysight_pma/const/appcolors.dart';
import 'package:keysight_pma/const/appfonts.dart';
import 'package:keysight_pma/const/constants.dart';
import 'package:keysight_pma/const/utils.dart';
import 'package:keysight_pma/dio/api/alert.dart';
import 'package:keysight_pma/model/alert/alert_casehistory.dart';

class EditComment extends StatefulWidget {
  final String alertRowKey;
  EditComment({Key? key, required this.alertRowKey}) : super(key: key);

  @override
  State<EditComment> createState() => _EditCommentState();
}

class _EditCommentState extends State<EditComment> {
  final cmt = TextEditingController();
  bool? theme_dark = AppCache.sortFilterCacheDTO!.currentTheme;

  Future<AlertOpenCaseDTO> postComment(BuildContext context) {
    String alertRowKeys = widget.alertRowKey;

    AlertApi alertApi = AlertApi(context);
    return alertApi.postComment(alertRowKeys, cmt.text);
  }

  @override
  void initState() {
    super.initState();
    Utils.setFirebaseAnalyticsCurrentScreen(
        Constants.ANALYTICS_ALERT_GIVE_COMMENT_SCREEN);
  }

  postCreateComment(BuildContext context) async {
    await postComment(context).then((value) {
      if (value.status!.statusCode == 200) {
        Navigator.pop(context, true);
      } else {
        if (Utils.isNotEmpty(value.errorMessage)) {
          Utils.showAlertDialog(
              context,
              Utils.getTranslated(context, 'general_alert_error_title')!,
              value.errorMessage!);
        } else {
          Utils.showAlertDialog(
              context,
              Utils.getTranslated(context, 'general_alert_error_title')!,
              Utils.getTranslated(context, 'general_alert_error_message')!);
        }
      }
    }).catchError((error) {
      Utils.printInfo(error);
      if (error is DioError) {
        if (error.response != null) {
          if (error.response!.data != null) {
            Utils.showAlertDialog(
                context,
                Utils.getTranslated(context, 'general_alert_error_title')!,
                error.response!.data['errorMessage'].toString());
          } else {
            Utils.showAlertDialog(
                context,
                Utils.getTranslated(context, 'general_alert_error_title')!,
                Utils.getTranslated(context, 'general_alert_error_message')!);
          }
        } else {
          Utils.showAlertDialog(
              context,
              Utils.getTranslated(context, 'general_alert_error_title')!,
              Utils.getTranslated(context, 'general_alert_error_message')!);
        }
      } else {
        Utils.showAlertDialog(
            context,
            Utils.getTranslated(context, 'general_alert_error_title')!,
            Utils.getTranslated(context, 'general_alert_error_message')!);
      }
    }).whenComplete(() {
      setState(() {
        if (EasyLoading.isShow) {
          EasyLoading.dismiss();
        }
      });
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
                    ? AppColors.appBlackLight()
                    : AppColorsLightMode.serverAppBar(),
                theme_dark!
                    ? AppColors.appBlackLight()
                    : AppColorsLightMode.serverAppBar(),
              ]))),
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            Utils.getTranslated(context, 'crtcmt_appbar')!,
            style: AppFonts.robotoRegular(20,
                color: theme_dark!
                    ? AppColors.appGrey()
                    : AppColorsLightMode.appGrey(),
                decoration: TextDecoration.none),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Image.asset(theme_dark!
                    ? Constants.ASSET_IMAGES + 'close_bttn.png'
                    : Constants.ASSET_IMAGES_LIGHT + 'close_icon.png')),
          ]),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height - 80,
        color: theme_dark!
            ? AppColors.appPrimaryBlack()
            : AppColorsLightMode.appPrimaryBlack(),
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
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text(
                          Utils.getTranslated(context, 'crtcmt_comment')!,
                          style: AppFonts.robotoMedium(
                            16,
                            color: theme_dark!
                                ? AppColors.appGreyB1()
                                : AppColorsLightMode.appGrey77(),
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                      Container(
                        height: 129,
                        padding: const EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                            color: AppColors.appPrimaryWhite().withOpacity(0.1),
                            border: Border.all(
                              color: theme_dark!
                                  ? AppColors.appPrimaryWhite().withOpacity(0.1)
                                  : AppColorsLightMode.appGreyED(),
                            ),
                            borderRadius: BorderRadius.circular(8)),
                        child: TextField(
                          style: TextStyle(
                            color: theme_dark!
                                ? AppColors.appPrimaryWhite()
                                : AppColorsLightMode.appGrey(),
                          ),
                          controller: cmt,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              hintText: Utils.getTranslated(
                                  context, 'crtcmt_writecomment')!,
                              hintStyle:
                                  TextStyle(color: AppColors.appGrey9A())),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                    ],
                  )),
              Container(
                child: GestureDetector(
                  onTap: () {
                    if (Utils.isNotEmpty(cmt.text.trim())) {
                      EasyLoading.show(maskType: EasyLoadingMaskType.black);
                      postCreateComment(context);
                    } else {
                      Utils.showAlertDialog(
                          context, "Info", "Please fill in all the field");
                    }
                  },
                  child: Container(
                    height: 40,
                    padding: const EdgeInsets.all(12),
                    color: AppColors.appPrimaryYellow(),
                    width: 156,
                    child: Text(
                      Utils.getTranslated(context, 'confirm')!,
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
    );
  }
}
