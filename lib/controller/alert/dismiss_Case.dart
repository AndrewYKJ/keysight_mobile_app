import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:keysight_pma/const/appcolors.dart';
import 'package:keysight_pma/const/appfonts.dart';
import 'package:keysight_pma/const/constants.dart';
import 'package:keysight_pma/const/utils.dart';
import 'package:keysight_pma/dio/api/alert.dart';
import 'package:keysight_pma/model/alert/alert_create_case.dart';

import '../../cache/appcache.dart';

class DismissCase extends StatefulWidget {
  final String? alertRowKeys;
  final List<BulkAlertInfoDTO>? bulkAlertList;
  final List<BulkAlertInfoDTO>? bulkAlertActualList;
  DismissCase(
      {Key? key,
      this.alertRowKeys,
      this.bulkAlertList,
      this.bulkAlertActualList})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DismissCase();
  }
}

class _DismissCase extends State<DismissCase> {
  TextEditingController subjectTextController = TextEditingController();
  TextEditingController descriptionTextController = TextEditingController();
  bool? theme_dark = AppCache.sortFilterCacheDTO!.currentTheme;

  Future<AlertCreateCaseDTO> dismiss(BuildContext context) {
    String actions = 'BULKDISMISS-CONFIRM';
    String assignedTo = '';
    String description = descriptionTextController.text.trim();
    String priority = 'none';
    String subject = subjectTextController.text.trim();
    String status = 'Dismiss';
    String workFlow = 'closed';
    List<String> alertRowKeys = [];

    if (widget.alertRowKeys != null) {
      alertRowKeys.add(widget.alertRowKeys!);
    } else if (widget.bulkAlertList != null) {
      widget.bulkAlertList!.forEach((element) {
        if (Utils.isNotEmpty(element.status)) {
          alertRowKeys.add(element.alertRowKey!);
        } else {
          alertRowKeys.add(jsonEncode(null));
        }
      });
    } else if (widget.bulkAlertActualList != null) {
      widget.bulkAlertActualList!.forEach((element) {
        alertRowKeys.add(element.alertRowKey!);
      });
    }

    AlertApi alertApi = AlertApi(context);
    return alertApi.bulkCreateCase(actions, assignedTo, description, priority,
        subject, status, workFlow, alertRowKeys);
  }

  @override
  void initState() {
    super.initState();
    Utils.setFirebaseAnalyticsCurrentScreen(
        Constants.ANALYTICS_ALERT_DISMISS_CASE_SCREEN);
  }

  callDismiss(BuildContext context) async {
    EasyLoading.show(maskType: EasyLoadingMaskType.black);
    await dismiss(context).then((value) {
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
        EasyLoading.dismiss();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: theme_dark!
              ? AppColors.serverAppBar()
              : AppColorsLightMode.serverAppBar(),
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            Utils.getTranslated(context, 'dismissAlert_appbar')!,
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
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Text(
                              Utils.getTranslated(context, 'case_subject')!,
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
                            height: 40,
                            padding: const EdgeInsets.only(left: 10),
                            decoration: BoxDecoration(
                                color: AppColors.appPrimaryWhite()
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8)),
                            child: TextField(
                              style:
                                  TextStyle(color: AppColors.appPrimaryWhite()),
                              controller: subjectTextController,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  hintText: Utils.getTranslated(
                                      context, 'case_subjecthint')!,
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
                              Utils.getTranslated(context, 'case_description')!,
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
                                color: AppColors.appPrimaryWhite()
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8)),
                            child: TextField(
                              style:
                                  TextStyle(color: AppColors.appPrimaryWhite()),
                              controller: descriptionTextController,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  hintText: Utils.getTranslated(
                                      context, 'case_descriptionhint')!,
                                  hintStyle:
                                      TextStyle(color: AppColors.appGrey9A())),
                            ),
                          ),
                        ],
                      )),
                  Container(
                    child: GestureDetector(
                      onTap: () {
                        if (Utils.isNotEmpty(
                                subjectTextController.text.trim()) &&
                            Utils.isNotEmpty(
                                descriptionTextController.text.trim())) {
                          callDismiss(context);
                        } else {
                          Utils.showAlertDialog(context, "Info",
                              "Please fill in subject and description");
                        }
                      },
                      child: Container(
                        height: 40,
                        padding: const EdgeInsets.all(12),
                        color: AppColors.appPrimaryYellow(),
                        width: 156,
                        child: Text(
                          Utils.getTranslated(context, 'save')!,
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
      ),
    );
  }
}
