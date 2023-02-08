import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:keysight_pma/const/appcolors.dart';
import 'package:keysight_pma/const/appfonts.dart';
import 'package:keysight_pma/const/constants.dart';
import 'package:keysight_pma/const/utils.dart';
import 'package:keysight_pma/dio/api/alert.dart';
import 'package:keysight_pma/model/alert/alert_assignee.dart';
import 'package:keysight_pma/model/alert/alert_create_case.dart';
import 'package:keysight_pma/model/arguments/alert_routeTitle.dart';
import 'package:keysight_pma/model/customize.dart';
import 'package:keysight_pma/routes/approutes.dart';

import '../../cache/appcache.dart';

class DisposeCreateCase extends StatefulWidget {
  final String? alertRowKeys;
  final List<BulkAlertInfoDTO>? bulkAlertList;
  final List<BulkAlertInfoDTO>? bulkAlertActualList;
  DisposeCreateCase(
      {Key? key,
      this.alertRowKeys,
      this.bulkAlertList,
      this.bulkAlertActualList})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DisposeCreateCase();
  }
}

class _DisposeCreateCase extends State<DisposeCreateCase> {
  TextEditingController subjectEditController = TextEditingController();
  TextEditingController descriptionEditController = TextEditingController();
  AlertAssigneeDataDTO? assignTo;
  CustomDTO priority = CustomDTO();
  CustomDTO workflow = CustomDTO();
  bool? theme_dark = AppCache.sortFilterCacheDTO!.currentTheme;

  Future<AlertCreateCaseDTO> bulkCreateCase(BuildContext context) {
    List<String> alertRowKeys = [];

    if (widget.alertRowKeys != null) {
      alertRowKeys.add(widget.alertRowKeys!);
    } else if (widget.bulkAlertList != null) {
      widget.bulkAlertList!.forEach((element) {
        if (Utils.isNotEmpty(element.alertRowKey)) {
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
    return alertApi.bulkCreateCase(
        "BULKDISPOSE-CONFIRM",
        assignTo!.emailId!,
        descriptionEditController.text,
        priority.value!,
        subjectEditController.text,
        "Dispose",
        workflow.value!,
        alertRowKeys);
  }

  @override
  void initState() {
    super.initState();
    Utils.setFirebaseAnalyticsCurrentScreen(
        Constants.ANALYTICS_ALERT_DISPOSE_CASE_SCREEN);
  }

  callBulkCreateCase(BuildContext context) async {
    await bulkCreateCase(context).then((value) {
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
          backgroundColor: theme_dark!
              ? AppColors.serverAppBar()
              : AppColorsLightMode.serverAppBar(),
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            Utils.getTranslated(context, 'case_create')!,
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
        height: MediaQuery.of(context).size.height,
        margin: EdgeInsets.only(left: 17, right: 17),
        child: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 26),
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
                      color: AppColors.appPrimaryWhite().withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8)),
                  child: TextField(
                    style: TextStyle(color: AppColors.appPrimaryWhite()),
                    controller: subjectEditController,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        hintText:
                            Utils.getTranslated(context, 'case_subjecthint')!,
                        hintStyle: TextStyle(color: AppColors.appGrey9A())),
                  ),
                ),
                SizedBox(height: 25),
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
                      color: AppColors.appPrimaryWhite().withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8)),
                  child: TextField(
                    style: TextStyle(color: AppColors.appPrimaryWhite()),
                    controller: descriptionEditController,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        hintText: Utils.getTranslated(
                            context, 'case_descriptionhint')!,
                        hintStyle: TextStyle(color: AppColors.appGrey9A())),
                  ),
                ),
                SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    Utils.getTranslated(context, 'case_assignedTo')!,
                    style: AppFonts.robotoMedium(
                      16,
                      color: theme_dark!
                          ? AppColors.appGreyB1()
                          : AppColorsLightMode.appGrey77(),
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    final navResult = await Navigator.pushNamed(
                        context, AppRoutes.alertCreateCaseSelectionRoute,
                        arguments: AlertArguments(
                            createCaseSelectionType: Constants.ASIGNED_TO,
                            assigneeDataDTO: this.assignTo));

                    if (navResult != null) {
                      setState(() {
                        this.assignTo = navResult as AlertAssigneeDataDTO;
                      });
                    }
                  },
                  child: Container(
                    height: 40,
                    padding: const EdgeInsets.only(left: 16, right: 18),
                    decoration: BoxDecoration(
                        color: AppColors.appPrimaryWhite().withOpacity(0.3),
                        borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          (this.assignTo != null)
                              ? '${Utils.isNotEmpty(this.assignTo!.firstName) ? '${this.assignTo!.firstName}' : ''}' +
                                  ' ' +
                                  '${Utils.isNotEmpty(this.assignTo!.lastName) ? '${this.assignTo!.lastName}' : ''}'
                              : Utils.getTranslated(context, 'case_select')!,
                          style: AppFonts.robotoRegular(
                            15,
                            color: AppColors.appPrimaryWhite(),
                            decoration: TextDecoration.none,
                          ),
                        ),
                        Image.asset(
                          Constants.ASSET_IMAGES + 'dropdown_icon.png',
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    Utils.getTranslated(context, 'case_priority')!,
                    style: AppFonts.robotoMedium(
                      16,
                      color: theme_dark!
                          ? AppColors.appGreyB1()
                          : AppColorsLightMode.appGrey77(),
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    final navResult = await Navigator.pushNamed(
                        context, AppRoutes.alertCreateCaseSelectionRoute,
                        arguments: AlertArguments(
                            createCaseSelectionType: Constants.PRIORITY,
                            priority: this.priority));

                    if (navResult != null) {
                      setState(() {
                        this.priority = navResult as CustomDTO;
                      });
                    }
                  },
                  child: Container(
                    height: 40,
                    padding: const EdgeInsets.only(left: 16, right: 18),
                    decoration: BoxDecoration(
                        color: AppColors.appPrimaryWhite().withOpacity(0.3),
                        borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          Utils.isNotEmpty(this.priority.displayName)
                              ? this.priority.displayName!
                              : Utils.getTranslated(context, 'case_select')!,
                          style: AppFonts.robotoRegular(
                            15,
                            color: AppColors.appPrimaryWhite(),
                            decoration: TextDecoration.none,
                          ),
                        ),
                        Image.asset(
                          Constants.ASSET_IMAGES + 'dropdown_icon.png',
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    Utils.getTranslated(context, 'case_workflow')!,
                    style: AppFonts.robotoMedium(
                      16,
                      color: theme_dark!
                          ? AppColors.appGreyB1()
                          : AppColorsLightMode.appGrey77(),
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    final navResult = await Navigator.pushNamed(
                        context, AppRoutes.alertCreateCaseSelectionRoute,
                        arguments: AlertArguments(
                            createCaseSelectionType: Constants.WORKFLOw,
                            workflow: this.workflow));

                    if (navResult != null) {
                      setState(() {
                        this.workflow = navResult as CustomDTO;
                      });
                    }
                  },
                  child: Container(
                    height: 40,
                    padding: const EdgeInsets.only(left: 16, right: 18),
                    decoration: BoxDecoration(
                        color: AppColors.appPrimaryWhite().withOpacity(0.3),
                        borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          Utils.isNotEmpty(this.workflow.displayName)
                              ? this.workflow.displayName!
                              : Utils.getTranslated(context, 'case_select')!,
                          style: AppFonts.robotoRegular(
                            15,
                            color: AppColors.appPrimaryWhite(),
                            decoration: TextDecoration.none,
                          ),
                        ),
                        Image.asset(
                          Constants.ASSET_IMAGES + 'dropdown_icon.png',
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(left: 109.5, top: 27, right: 109.5),
        height: 67,
        color: theme_dark!
            ? AppColors.appPrimaryBlack()
            : AppColorsLightMode.appPrimaryBlack(),
        child: GestureDetector(
          onTap: () {
            if (Utils.isNotEmpty(subjectEditController.text.trim()) &&
                Utils.isNotEmpty(descriptionEditController.text.trim()) &&
                this.assignTo != null &&
                Utils.isNotEmpty(this.priority.value) &&
                Utils.isNotEmpty(this.workflow.value)) {
              EasyLoading.show(maskType: EasyLoadingMaskType.black);
              callBulkCreateCase(context);
            } else {
              Utils.showAlertDialog(
                  context, "Info", "Please fill in all the field");
            }
          },
          child: Container(
            height: 40,
            padding: EdgeInsets.only(top: 10),
            width: 156,
            color: AppColors.appPrimaryYellow(),
            child: Text(
              Utils.getTranslated(context, 'create')!,
              style: AppFonts.robotoMedium(14,
                  color: AppColors.appPrimaryWhite(),
                  decoration: TextDecoration.none),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
