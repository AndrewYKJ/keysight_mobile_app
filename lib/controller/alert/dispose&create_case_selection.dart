import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:keysight_pma/cache/appcache.dart';
import 'package:keysight_pma/const/appcolors.dart';
import 'package:keysight_pma/const/appfonts.dart';
import 'package:keysight_pma/const/constants.dart';
import 'package:keysight_pma/const/utils.dart';
import 'package:keysight_pma/dio/api/alert.dart';
import 'package:keysight_pma/model/alert/alert_assignee.dart';
import 'package:keysight_pma/model/customize.dart';

class DisposeCreateCaseSelectionScreen extends StatefulWidget {
  final int? selectionType;
  final AlertAssigneeDataDTO? assigneeDataDTO;
  final CustomDTO? priority;
  final CustomDTO? workflow;
  final CustomDTO? status;
  DisposeCreateCaseSelectionScreen(
      {Key? key,
      this.selectionType,
      this.assigneeDataDTO,
      this.priority,
      this.status,
      this.workflow})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DisposeCreateCaseSelectionScreen();
  }
}

class _DisposeCreateCaseSelectionScreen
    extends State<DisposeCreateCaseSelectionScreen> {
  bool isLoading = true;
  late AlertAssigneeDTO assigneeDTO;
  AlertAssigneeDataDTO selectedAssignee = AlertAssigneeDataDTO();
  CustomDTO priority = CustomDTO();
  CustomDTO workflow = CustomDTO();
  CustomDTO status = CustomDTO();
  bool? theme_dark = AppCache.sortFilterCacheDTO!.currentTheme;

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
    CustomDTO(displayName: "Closed", value: "closed"),
  ];

  Future<AlertAssigneeDTO> getAlertAssignee(BuildContext context) {
    String companyId = AppCache.sortFilterCacheDTO!.preferredCompany!;
    String siteId = AppCache.sortFilterCacheDTO!.preferredSite!;
    AlertApi alertApi = AlertApi(context);
    return alertApi.getAlertAssignee(companyId, siteId);
  }

  @override
  void initState() {
    super.initState();
    Utils.setFirebaseAnalyticsCurrentScreen(
        Constants.ANALYTICS_ALERT_STATUS_PRIORITY_WORKFLOW_SELECTION_SCREEN);
    if (widget.selectionType == Constants.ASIGNED_TO) {
      if (widget.assigneeDataDTO != null) {
        this.selectedAssignee = widget.assigneeDataDTO!;
      }
      callGetAlertAssignee(context);
    } else {
      setState(() {
        if (widget.priority != null) {
          this.priority = widget.priority!;
        }

        if (widget.workflow != null) {
          this.workflow = widget.workflow!;
        }
        if (widget.status != null) {
          this.status = widget.status!;
        }
        this.isLoading = false;
      });
    }
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
        this.isLoading = false;
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
        title: Padding(
          padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
          child: Text(
            (widget.selectionType == Constants.ASIGNED_TO)
                ? 'Asign To'
                : (widget.selectionType == Constants.PRIORITY)
                    ? 'Priority'
                    : (widget.selectionType == Constants.WORKFLOw)
                        ? 'Workflow'
                        : (widget.selectionType == Constants.STATUS)
                            ? 'Status'
                            : '',
            style: AppFonts.robotoRegular(
              20,
              color: theme_dark!
                  ? AppColors.appGrey()
                  : AppColorsLightMode.appGrey(),
              decoration: TextDecoration.none,
            ),
          ),
        ),
        leading: GestureDetector(
          onTap: () {
            if (widget.selectionType == Constants.ASIGNED_TO) {
              Navigator.pop(context, this.selectedAssignee);
            } else if (widget.selectionType == Constants.PRIORITY) {
              Navigator.pop(context, this.priority);
            } else if (widget.selectionType == Constants.WORKFLOw) {
              Navigator.pop(context, this.workflow);
            } else {
              Navigator.pop(context, this.status);
            }
          },
          child: Image.asset(
            theme_dark!
                ? Constants.ASSET_IMAGES + 'back_bttn.png'
                : Constants.ASSET_IMAGES_LIGHT + 'back_bttn.png',
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 21.0),
          child: this.isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppColors.appBlue()),
                  ),
                )
              : ListView.builder(
                  itemCount: widget.selectionType == Constants.ASIGNED_TO
                      ? this.assigneeDTO.data!.length
                      : widget.selectionType == Constants.PRIORITY
                          ? this.priolityList.length
                          : widget.selectionType == Constants.WORKFLOw
                              ? this.workflowList.length
                              : widget.selectionType == Constants.STATUS
                                  ? this.statusList.length
                                  : 0,
                  itemBuilder: (BuildContext listContext, index) {
                    if (widget.selectionType == Constants.ASIGNED_TO) {
                      return assigneeItem(
                          listContext, this.assigneeDTO.data![index], index);
                    } else if (widget.selectionType == Constants.PRIORITY) {
                      return priorityItem(
                          listContext, this.priolityList[index], index);
                    } else if (widget.selectionType == Constants.WORKFLOw) {
                      return workflowItem(
                          listContext, this.workflowList[index], index);
                    } else {
                      return statusItem(
                          listContext, this.statusList[index], index);
                    }
                  },
                ),
        ),
      ),
    );
  }

  Widget assigneeItem(
      BuildContext ctx, AlertAssigneeDataDTO dataDTO, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          this.selectedAssignee = dataDTO;
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 23.0, bottom: 23.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    '${Utils.isNotEmpty(dataDTO.firstName) ? '${dataDTO.firstName}' : ''}' +
                        ' ' +
                        '${Utils.isNotEmpty(dataDTO.lastName) ? '${dataDTO.lastName}' : ''}',
                    style: AppFonts.robotoRegular(
                      16,
                      color: theme_dark!
                          ? AppColors.appGrey2()
                          : AppColorsLightMode.appGrey(),
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
                SizedBox(width: 12.0),
                Container(
                  margin: EdgeInsets.only(right: 12.0),
                  child: this.selectedAssignee.userId == dataDTO.userId
                      ? Image.asset(theme_dark!
                          ? Constants.ASSET_IMAGES + 'tick_icon.png'
                          : Constants.ASSET_IMAGES_LIGHT + 'tick_icon.png')
                      : Container(),
                ),
              ],
            ),
          ),
          index < (this.assigneeDTO.data!.length - 1)
              ? divider(ctx)
              : Container(),
        ],
      ),
    );
  }

  Widget priorityItem(BuildContext ctx, CustomDTO customDTO, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          this.priority = customDTO;
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 23.0, bottom: 23.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    customDTO.displayName!,
                    style: AppFonts.robotoRegular(
                      16,
                      color: theme_dark!
                          ? AppColors.appGrey2()
                          : AppColorsLightMode.appGrey(),
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
                SizedBox(width: 12.0),
                Container(
                  margin: EdgeInsets.only(right: 12.0),
                  child: this.priority.value == customDTO.value
                      ? Image.asset(theme_dark!
                          ? Constants.ASSET_IMAGES + 'tick_icon.png'
                          : Constants.ASSET_IMAGES_LIGHT + 'tick_icon.png')
                      : Container(),
                ),
              ],
            ),
          ),
          index < (this.priolityList.length - 1) ? divider(ctx) : Container(),
        ],
      ),
    );
  }

  Widget workflowItem(BuildContext ctx, CustomDTO customDTO, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          this.workflow = customDTO;
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 23.0, bottom: 23.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    customDTO.displayName!,
                    style: AppFonts.robotoRegular(
                      16,
                      color: theme_dark!
                          ? AppColors.appGrey2()
                          : AppColorsLightMode.appGrey(),
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
                SizedBox(width: 12.0),
                Container(
                  margin: EdgeInsets.only(right: 12.0),
                  child: this.workflow.value == customDTO.value
                      ? Image.asset(theme_dark!
                          ? Constants.ASSET_IMAGES + 'tick_icon.png'
                          : Constants.ASSET_IMAGES_LIGHT + 'tick_icon.png')
                      : Container(),
                ),
              ],
            ),
          ),
          index < (this.workflowList.length - 1) ? divider(ctx) : Container(),
        ],
      ),
    );
  }

  Widget statusItem(BuildContext ctx, CustomDTO customDTO, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          this.status = customDTO;
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 23.0, bottom: 23.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    customDTO.displayName!,
                    style: AppFonts.robotoRegular(
                      16,
                      color: theme_dark!
                          ? AppColors.appGrey2()
                          : AppColorsLightMode.appGrey(),
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
                SizedBox(width: 12.0),
                Container(
                  margin: EdgeInsets.only(right: 12.0),
                  child: this.status.value == customDTO.value
                      ? Image.asset(theme_dark!
                          ? Constants.ASSET_IMAGES + 'tick_icon.png'
                          : Constants.ASSET_IMAGES_LIGHT + 'tick_icon.png')
                      : Container(),
                ),
              ],
            ),
          ),
          index < (this.statusList.length - 1) ? divider(ctx) : Container(),
        ],
      ),
    );
  }

  Widget divider(BuildContext ctx) {
    return Container(
      width: MediaQuery.of(ctx).size.width,
      height: 1.0,
      color: theme_dark!
          ? AppColors.appDividerColor()
          : AppColorsLightMode.appDividerColor(),
    );
  }
}
