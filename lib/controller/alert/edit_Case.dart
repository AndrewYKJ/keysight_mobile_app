import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:keysight_pma/cache/appcache.dart';
import 'package:keysight_pma/const/appcolors.dart';
import 'package:keysight_pma/const/appfonts.dart';
import 'package:keysight_pma/const/constants.dart';
import 'package:keysight_pma/const/utils.dart';
import 'package:keysight_pma/dio/api/alert.dart';
import 'package:keysight_pma/model/alert/alert_assignee.dart';
import 'package:keysight_pma/model/alert/alert_casehistory.dart';
import 'package:keysight_pma/model/arguments/alert_routeTitle.dart';
import 'package:keysight_pma/model/customize.dart';
import 'package:keysight_pma/routes/approutes.dart';

class EditCase extends StatefulWidget {
  AlertOpenCaseDTO data;
  EditCase({Key? key, required this.data}) : super(key: key);

  @override
  State<EditCase> createState() => _EditCaseState();
}

class _EditCaseState extends State<EditCase> {
  TextEditingController subjectEditController = TextEditingController();
  TextEditingController descriptionEditController = TextEditingController();
  AlertAssigneeDataDTO? assignTo = AlertAssigneeDataDTO();
  CustomDTO priority = CustomDTO();
  CustomDTO workflow = CustomDTO();
  CustomDTO status = CustomDTO();
  String? emailId;
  bool? theme_dark = AppCache.sortFilterCacheDTO!.currentTheme;

  List<String>? splitName;
  bool isLoading = true;
  AlertAssigneeDTO? assigneeDTO;
  List<CustomDTO> statusList = [
    CustomDTO(displayName: "Actual", value: "Actual"),
    CustomDTO(displayName: "Dispose", value: "Dispose"),
    CustomDTO(displayName: "Dismiss", value: "Dismiss"),
  ];
  List<CustomDTO> priolityList = [
    CustomDTO(displayName: "Critical", value: "critical"),
    CustomDTO(displayName: "High", value: "high"),
    CustomDTO(displayName: "Medium", value: "medium"),
    CustomDTO(displayName: "Low", value: "low"),
    CustomDTO(displayName: "None", value: "none"),
  ];

  List<CustomDTO> workflowList = [
    CustomDTO(displayName: "To Do", value: "todo"),
    CustomDTO(displayName: "In Progress", value: "inProgress"),
    CustomDTO(displayName: "Verification", value: "verification"),
    CustomDTO(displayName: "Close", value: "closed"),
  ];
  @override
  void initState() {
    super.initState();
    Utils.setFirebaseAnalyticsCurrentScreen(
        Constants.ANALYTICS_ALERT_CREATE_EDIT_CASE_SCREEN);
    setState(() {
      if (widget.data.data!.assignedTo != null)
        emailId = (widget.data.data!.assignedTo);
      if (widget.data.data!.subject != null)
        subjectEditController.text = widget.data.data!.subject!;
      if (widget.data.data!.description != null)
        descriptionEditController.text = widget.data.data!.description!;
      priolityList.forEach((element) {
        if (element.value == widget.data.data!.priority) {
          priority = element;
        }
      });
      workflowList.forEach((element) {
        if (element.value == widget.data.data!.workFlow) {
          workflow = element;
        }
      });
      statusList.forEach((element) {
        if (element.value == widget.data.data!.status) {
          status = element;
        }
      });
    });
    // print(emailId);
    callGetAlertAssignee(context);
  }

  Future<AlertAssigneeDTO> getAlertAssignee(BuildContext context) {
    String companyId = AppCache.sortFilterCacheDTO!.preferredCompany!;
    String siteId = AppCache.sortFilterCacheDTO!.preferredSite!;
    AlertApi alertApi = AlertApi(context);
    return alertApi.getAlertAssignee(companyId, siteId);
  }

  Future<AlertOpenCaseDTO> updateCase(BuildContext context) {
    String alertRowKeys = widget.data.data!.alertRowKey!;

    AlertApi alertApi = AlertApi(context);
    return alertApi.updateCase(
      alertRowKeys,
      priority.value!,
      workflow.value!,
      subjectEditController.text,
      descriptionEditController.text,
      assignTo!.emailId,
      priority.value!,
    );
  }

  callGetAlertAssignee(BuildContext context) async {
    await getAlertAssignee(context).then((value) {
      if (value.status!.statusCode == 200) {
        this.assigneeDTO = value;
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
        assigneeDTO!.data!.forEach((element) {
          if (element.emailId == emailId) {
            if (element.firstName != null)
              assignTo!.firstName = element.firstName!;
            if (element.lastName != null)
              assignTo!.lastName = element.lastName!;
            if (element.emailId != null) assignTo!.emailId = element.emailId;
          }
        });
        this.isLoading = false;
      });
    });
  }

  callBulkCreateCase(BuildContext context) async {
    await updateCase(context).then((value) {
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
            Utils.getTranslated(context, 'editCase_appbar')!,
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
        color: theme_dark!
            ? AppColors.appPrimaryBlack()
            : AppColorsLightMode.appPrimaryBlack(),
        margin: EdgeInsets.only(left: 17, right: 17),
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(AppColors.appBlue()),
                ),
              )
            : GestureDetector(
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
                                : AppColorsLightMode.appGrey5C(),
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                      Container(
                        height: 40,
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
                                  : AppColorsLightMode.appPrimaryWhite()),
                          controller: subjectEditController,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              hintText: Utils.getTranslated(
                                  context, 'case_subjecthint')!,
                              hintStyle:
                                  TextStyle(color: AppColors.appGrey9A())),
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
                                : AppColorsLightMode.appGrey5C(),
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
                                  : AppColorsLightMode.appPrimaryWhite()),
                          controller: descriptionEditController,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              hintText: Utils.getTranslated(
                                  context, 'case_descriptionhint')!,
                              hintStyle:
                                  TextStyle(color: AppColors.appGrey9A())),
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
                                : AppColorsLightMode.appGrey5C(),
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          if (workflow.value != 'closed') {
                            final navResult = await Navigator.pushNamed(context,
                                AppRoutes.alertCreateCaseSelectionRoute,
                                arguments: AlertArguments(
                                    createCaseSelectionType:
                                        Constants.ASIGNED_TO,
                                    assigneeDataDTO: this.assignTo));

                            if (navResult != null) {
                              setState(() {
                                this.assignTo =
                                    navResult as AlertAssigneeDataDTO;
                              });
                            }
                          }
                        },
                        child: Container(
                          height: 40,
                          padding: const EdgeInsets.only(left: 16, right: 18),
                          decoration: BoxDecoration(
                              color:
                                  AppColors.appPrimaryWhite().withOpacity(0.1),
                              border: Border.all(
                                color: theme_dark!
                                    ? AppColors.appPrimaryWhite()
                                        .withOpacity(0.1)
                                    : AppColorsLightMode.appGreyED(),
                              ),
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
                                    : Utils.getTranslated(
                                        context, 'case_select')!,
                                style: AppFonts.robotoRegular(
                                  15,
                                  color: theme_dark!
                                      ? AppColors.appPrimaryWhite()
                                      : AppColorsLightMode.appPrimaryWhite(),
                                  decoration: TextDecoration.none,
                                ),
                              ),
                              Image.asset(
                                theme_dark!
                                    ? Constants.ASSET_IMAGES +
                                        'dropdown_icon.png'
                                    : Constants.ASSET_IMAGES_LIGHT +
                                        'dropdown.png',
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
                          Utils.getTranslated(context, 'case_status')!,
                          style: AppFonts.robotoMedium(
                            16,
                            color: theme_dark!
                                ? AppColors.appGreyB1()
                                : AppColorsLightMode.appGrey5C(),
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          final navResult = await Navigator.pushNamed(
                              context, AppRoutes.alertCreateCaseSelectionRoute,
                              arguments: AlertArguments(
                                  createCaseSelectionType: Constants.STATUS,
                                  status: this.status));

                          if (navResult != null) {
                            setState(() {
                              this.status = navResult as CustomDTO;
                            });
                          }
                        },
                        child: Container(
                          height: 40,
                          padding: const EdgeInsets.only(left: 16, right: 18),
                          decoration: BoxDecoration(
                              color:
                                  AppColors.appPrimaryWhite().withOpacity(0.1),
                              border: Border.all(
                                color: theme_dark!
                                    ? AppColors.appPrimaryWhite()
                                        .withOpacity(0.1)
                                    : AppColorsLightMode.appGreyED(),
                              ),
                              borderRadius: BorderRadius.circular(8)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                Utils.isNotEmpty(this.status.displayName)
                                    ? this.status.displayName!
                                    : Utils.getTranslated(
                                        context, 'case_select')!,
                                style: AppFonts.robotoRegular(
                                  15,
                                  color: theme_dark!
                                      ? AppColors.appPrimaryWhite()
                                      : AppColorsLightMode.appPrimaryWhite(),
                                  decoration: TextDecoration.none,
                                ),
                              ),
                              Image.asset(
                                theme_dark!
                                    ? Constants.ASSET_IMAGES +
                                        'dropdown_icon.png'
                                    : Constants.ASSET_IMAGES_LIGHT +
                                        'dropdown.png',
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
                          Utils.getTranslated(context, 'case_priority')!,
                          style: AppFonts.robotoMedium(
                            16,
                            color: theme_dark!
                                ? AppColors.appGreyB1()
                                : AppColorsLightMode.appGrey5C(),
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
                              color:
                                  AppColors.appPrimaryWhite().withOpacity(0.1),
                              border: Border.all(
                                color: theme_dark!
                                    ? AppColors.appPrimaryWhite()
                                        .withOpacity(0.1)
                                    : AppColorsLightMode.appGreyED(),
                              ),
                              borderRadius: BorderRadius.circular(8)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                Utils.isNotEmpty(this.priority.displayName)
                                    ? this.priority.displayName!
                                    : Utils.getTranslated(
                                        context, 'case_select')!,
                                style: AppFonts.robotoRegular(
                                  15,
                                  color: theme_dark!
                                      ? AppColors.appPrimaryWhite()
                                      : AppColorsLightMode.appPrimaryWhite(),
                                  decoration: TextDecoration.none,
                                ),
                              ),
                              Image.asset(
                                theme_dark!
                                    ? Constants.ASSET_IMAGES +
                                        'dropdown_icon.png'
                                    : Constants.ASSET_IMAGES_LIGHT +
                                        'dropdown.png',
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
                                : AppColorsLightMode.appGrey5C(),
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          if (workflow.value != 'closed') {
                            final navResult = await Navigator.pushNamed(context,
                                AppRoutes.alertCreateCaseSelectionRoute,
                                arguments: AlertArguments(
                                    createCaseSelectionType: Constants.WORKFLOw,
                                    workflow: this.workflow));

                            if (navResult != null) {
                              setState(() {
                                this.workflow = navResult as CustomDTO;
                              });
                            }
                          }
                        },
                        child: Container(
                          height: 40,
                          padding: const EdgeInsets.only(left: 16, right: 18),
                          decoration: BoxDecoration(
                              color:
                                  AppColors.appPrimaryWhite().withOpacity(0.1),
                              border: Border.all(
                                color: theme_dark!
                                    ? AppColors.appPrimaryWhite()
                                        .withOpacity(0.1)
                                    : AppColorsLightMode.appGreyED(),
                              ),
                              borderRadius: BorderRadius.circular(8)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                Utils.isNotEmpty(this.workflow.displayName)
                                    ? this.workflow.displayName!
                                    : Utils.getTranslated(
                                        context, 'case_select')!,
                                style: AppFonts.robotoRegular(
                                  15,
                                  color: theme_dark!
                                      ? AppColors.appPrimaryWhite()
                                      : AppColorsLightMode.appPrimaryWhite(),
                                  decoration: TextDecoration.none,
                                ),
                              ),
                              Image.asset(
                                theme_dark!
                                    ? Constants.ASSET_IMAGES +
                                        'dropdown_icon.png'
                                    : Constants.ASSET_IMAGES_LIGHT +
                                        'dropdown.png',
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
                Utils.isNotEmpty(this.status.value) &&
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
              Utils.getTranslated(context, 'save_changes')!,
              style: AppFonts.robotoMedium(14,
                  color: theme_dark!
                      ? AppColors.appPrimaryWhite()
                      : AppColorsLightMode.appPrimaryWhite(),
                  decoration: TextDecoration.none),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
