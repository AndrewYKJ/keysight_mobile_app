import 'package:flutter/material.dart';
import 'package:keysight_pma/cache/appcache.dart';
import 'package:keysight_pma/const/appcolors.dart';
import 'package:keysight_pma/const/appfonts.dart';
import 'package:keysight_pma/const/constants.dart';
import 'package:keysight_pma/const/utils.dart';
import 'package:keysight_pma/model/alertPreferencemodel.dart';
import 'package:keysight_pma/routes/approutes.dart';

class GroupPage extends StatefulWidget {
  final AlertPreferenceGroupDataDTO groupDetailsData;
  GroupPage({Key? key, required this.groupDetailsData}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _GroupPage();
  }
}

class _GroupPage extends State<GroupPage> {
  bool? isDarkTheme = AppCache.sortFilterCacheDTO!.currentTheme;

  @override
  void initState() {
    super.initState();
    Utils.setFirebaseAnalyticsCurrentScreen(
        Constants.ANALYTICS_ADMIN_ALERT_PREFERENCE_GROUP_INFO_SCREEN);
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
              isDarkTheme!
                  ? AppColors.serverAppBar()
                  : AppColorsLightMode.serverAppBar(),
              isDarkTheme!
                  ? AppColors.serverAppBar()
                  : AppColorsLightMode.serverAppBar(),
            ]))),
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          Utils.getTranslated(context, 'setting_myGroup')!,
          style: AppFonts.robotoRegular(20,
              color: isDarkTheme!
                  ? AppColors.appGrey()
                  : AppColorsLightMode.appGrey(),
              decoration: TextDecoration.none),
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
      body: Container(
        margin: EdgeInsets.only(left: 14, top: 15),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 32),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.groupDetailsData.groupId.toString(),
                        style: AppFonts.robotoRegular(16,
                            color: isDarkTheme!
                                ? AppColors.appGrey2()
                                : AppColorsLightMode.appGrey(),
                            decoration: TextDecoration.none),
                      ),
                      Row(
                        children: [
                          Text(
                            widget.groupDetailsData.groupVisibility == true
                                ? Utils.getTranslated(context, 'group_public')!
                                : Utils.getTranslated(
                                    context, 'group_private')!,
                            style: AppFonts.sfproRegular(14,
                                color: isDarkTheme!
                                    ? AppColors.appGreyB1()
                                    : AppColorsLightMode.appGrey70(),
                                decoration: TextDecoration.none),
                          ),
                          Text(
                            '  |  ',
                            style: AppFonts.sfproRegular(14,
                                color: isDarkTheme!
                                    ? AppColors.appGreyB1()
                                    : AppColorsLightMode.appGrey70(),
                                decoration: TextDecoration.none),
                          ),
                          Text(
                            '${widget.groupDetailsData.groupUsers!.length} members',
                            style: AppFonts.sfproRegular(14,
                                color: isDarkTheme!
                                    ? AppColors.appGreyB1()
                                    : AppColorsLightMode.appGrey70(),
                                decoration: TextDecoration.none),
                          ),
                        ],
                      )
                    ]),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 32),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Utils.getTranslated(context, 'groupdetail_ownder')!,
                        style: AppFonts.robotoRegular(16,
                            color: isDarkTheme!
                                ? AppColors.appGrey2()
                                : AppColorsLightMode.appGrey(),
                            decoration: TextDecoration.none),
                      ),
                      Text(
                        widget.groupDetailsData.groupOwnerName!,
                        style: AppFonts.sfproRegular(14,
                            color: isDarkTheme!
                                ? AppColors.appGreyB1()
                                : AppColorsLightMode.appGrey70(),
                            decoration: TextDecoration.none),
                      )
                    ]),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 32),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Utils.getTranslated(
                            context, 'groupdetail_description')!,
                        style: AppFonts.robotoRegular(16,
                            color: isDarkTheme!
                                ? AppColors.appGrey2()
                                : AppColorsLightMode.appGrey(),
                            decoration: TextDecoration.none),
                      ),
                      Text(
                        widget.groupDetailsData.groupDescription!,
                        style: AppFonts.sfproRegular(14,
                            color: isDarkTheme!
                                ? AppColors.appGreyB1()
                                : AppColorsLightMode.appGrey70(),
                            decoration: TextDecoration.none),
                      )
                    ]),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 32),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            Utils.getTranslated(context, 'groupUserList')!,
                            style: AppFonts.robotoRegular(16,
                                color: isDarkTheme!
                                    ? AppColors.appGrey2()
                                    : AppColorsLightMode.appGrey(),
                                decoration: TextDecoration.none),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, AppRoutes.groupUserList,
                                  arguments: AlertPreferenceGroupDataDTO(
                                      groupUsers:
                                          widget.groupDetailsData.groupUsers));
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 16),
                              child: Image.asset(
                                isDarkTheme!
                                    ? Constants.ASSET_IMAGES + 'next_bttn.png'
                                    : Constants.ASSET_IMAGES_LIGHT +
                                        'next_bttn.png',
                                height: 20,
                              ),
                            ),
                          )
                        ],
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: widget.groupDetailsData.groupUsers!
                              .map((e) => dataGroup(context, e))
                              .toList(),
                        ),
                      ),
                    ]),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 32),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            Utils.getTranslated(context, 'alertList')!,
                            style: AppFonts.robotoRegular(16,
                                color: isDarkTheme!
                                    ? AppColors.appGrey2()
                                    : AppColorsLightMode.appGrey(),
                                decoration: TextDecoration.none),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, AppRoutes.groupAlertList,
                                  arguments: AlertPreferenceGroupDataDTO(
                                      alertPrefAlertList: widget
                                          .groupDetailsData
                                          .alertPrefAlertList));
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 16),
                              child: Image.asset(
                                isDarkTheme!
                                    ? Constants.ASSET_IMAGES + 'next_bttn.png'
                                    : Constants.ASSET_IMAGES_LIGHT +
                                        'next_bttn.png',
                                height: 20,
                              ),
                            ),
                          )
                        ],
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child:
                            widget.groupDetailsData.alertPrefAlertList!.length >
                                    0
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: widget
                                        .groupDetailsData.alertPrefAlertList!
                                        .map((e) => dataAlert(context, e))
                                        .toList(),
                                  )
                                : Container(),
                      ),
                    ]),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 32),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            Utils.getTranslated(context, 'parameterList')!,
                            style: AppFonts.robotoRegular(16,
                                color: isDarkTheme!
                                    ? AppColors.appGrey2()
                                    : AppColorsLightMode.appGrey(),
                                decoration: TextDecoration.none),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, AppRoutes.groupParameterList,
                                  arguments: AlertPreferenceGroupDataDTO(
                                      groupParametersDisplay: widget
                                          .groupDetailsData
                                          .groupParametersDisplay));
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 16),
                              child: Image.asset(
                                isDarkTheme!
                                    ? Constants.ASSET_IMAGES + 'next_bttn.png'
                                    : Constants.ASSET_IMAGES_LIGHT +
                                        'next_bttn.png',
                                height: 20,
                              ),
                            ),
                          )
                        ],
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children:
                              widget.groupDetailsData.groupParametersDisplay!
                                  .map((e) => dataPara(
                                        context,
                                        e,
                                      ))
                                  .toList(),
                        ),
                      ),
                    ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget dataGroup(BuildContext context, GroupUser e) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 70,
        width: 233,
        margin: EdgeInsets.only(right: 16, top: 12),
        padding: EdgeInsets.only(
          top: 13,
          left: 17,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: e.moderator!
              ? AppColors.appGreen60()
              : isDarkTheme!
                  ? AppColors.appBlackLight()
                  : AppColorsLightMode.serverAppBar(),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              e.userName!,
              style: AppFonts.robotoMedium(13,
                  color: e.moderator!
                      ? AppColors.appWhiteE6()
                      : isDarkTheme!
                          ? AppColors.appGreyDE()
                          : AppColorsLightMode.appPrimaryWhite(),
                  decoration: TextDecoration.none),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              e.emailId!,
              overflow: TextOverflow.ellipsis,
              style: AppFonts.sfproRegular(14,
                  color: e.moderator!
                      ? AppColors.appGreyDE()
                      : isDarkTheme!
                          ? AppColors.appGreyB1()
                          : AppColorsLightMode.appGrey70(),
                  decoration: TextDecoration.none),
            ),
          ],
        ),
      ),
    );
  }

  Widget dataAlert(
    BuildContext context,
    AlertPrefAlertList e,
  ) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 50,
        width: 187,
        margin: EdgeInsets.only(right: 16, top: 12),
        padding: EdgeInsets.only(
          left: 14,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: isDarkTheme!
              ? AppColors.appBlackLight()
              : AppColorsLightMode.serverAppBar(),
        ),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(
            e.alertDescription != null ? e.alertDescription! : "",
            style: AppFonts.robotoMedium(13,
                color: isDarkTheme!
                    ? AppColors.appGreyDE()
                    : AppColorsLightMode.appGrey(),
                decoration: TextDecoration.none),
          ),
        ]),
      ),
    );
  }

  Widget dataPara(BuildContext context, GroupParametersDisplay e) {
    String eqString = '';
    String prjString = '';
    String shiftString = '';

    if (e.equipmentList!.length > 0) {
      e.equipmentList!.forEach((element) {
        eqString = eqString +
            ((element.equipmentName == null)
                ? ''
                : (eqString.length > 0)
                    ? ', '
                    : '') +
            ((element.equipmentName != null) ? element.equipmentName : '')!;
      });
    }
    if (e.projectList!.length > 0) {
      e.projectList!.forEach((element) {
        prjString = prjString +
            ((element.projectName == null)
                ? ''
                : (prjString.length > 0)
                    ? ', '
                    : '') +
            ((element.projectName != null) ? element.projectName : '')!;
      });
    }
    if (e.shiftList!.length > 0) {
      e.shiftList!.forEach((element) {
        shiftString = shiftString +
            ((element.shiftName == null)
                ? ''
                : (shiftString.length > 0)
                    ? ', '
                    : '') +
            ((element.shiftName != null) ? element.shiftName : '')!;
      });
    }
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 135,
        width: 243,
        margin: EdgeInsets.only(right: 16, top: 12),
        padding: EdgeInsets.only(
          top: 13,
          left: 17,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: isDarkTheme!
              ? AppColors.appBlackLight()
              : AppColorsLightMode.serverAppBar(),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${e.companyName}  |  ${e.siteName}',
              style: AppFonts.robotoMedium(13,
                  color: isDarkTheme!
                      ? AppColors.appGreyDE()
                      : AppColorsLightMode.appPrimaryWhite(),
                  decoration: TextDecoration.none),
            ),
            SizedBox(
              height: 14,
            ),
            shiftString.length > 0
                ? Text(
                    (shiftString.length > 24)
                        ? shiftString.substring(0, 24) + '...'
                        : shiftString,
                    style: AppFonts.sfproRegular(14,
                        color: isDarkTheme!
                            ? AppColors.appGreyB1()
                            : AppColorsLightMode.appGrey70(),
                        decoration: TextDecoration.none),
                  )
                : SizedBox(
                    height: 14,
                  ),
            SizedBox(
              height: 14,
            ),
            prjString.length > 0
                ? Text(
                    (prjString.length > 24)
                        ? prjString.substring(0, 24) + '...'
                        : prjString,
                    style: AppFonts.sfproRegular(14,
                        color: isDarkTheme!
                            ? AppColors.appGreyB1()
                            : AppColorsLightMode.appGrey70(),
                        decoration: TextDecoration.none),
                  )
                : SizedBox(
                    height: 14,
                  ),
            SizedBox(
              height: 14,
            ),
            eqString.length > 0
                ? Text(
                    (eqString.length > 24)
                        ? eqString.substring(0, 24) + '...'
                        : eqString,
                    style: AppFonts.sfproRegular(14,
                        color: isDarkTheme!
                            ? AppColors.appGreyB1()
                            : AppColorsLightMode.appGrey70(),
                        decoration: TextDecoration.none),
                  )
                : SizedBox(
                    height: 14,
                  ),
          ],
        ),
      ),
    );
  }
}
