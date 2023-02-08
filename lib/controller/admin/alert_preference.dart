import 'package:flutter/material.dart';
import 'package:keysight_pma/cache/appcache.dart';
import 'package:keysight_pma/const/appcolors.dart';
import 'package:keysight_pma/const/appfonts.dart';
import 'package:keysight_pma/const/constants.dart';
import 'package:keysight_pma/const/utils.dart';
import 'package:keysight_pma/controller/admin/preferred_setting/custom.dart';
import 'package:keysight_pma/dio/api/alertPref.dart';
import 'package:keysight_pma/model/alertPreferencemodel.dart';
import 'package:keysight_pma/model/arguments/search_argument.dart';
import 'package:keysight_pma/model/user.dart';

import '../../routes/approutes.dart';

class AlertPreference extends StatefulWidget {
  final UserDataDTO? user_info;
  const AlertPreference({Key? key, this.user_info}) : super(key: key);

  @override
  State<AlertPreference> createState() => _Account_infoState();
}

class _Account_infoState extends State<AlertPreference> {
  String? selectedTag;
  bool? theme_dark;
  bool isLoading = true;
  String selectedGroup = 'MyGroup';
  List<SelectedGroup> groupList = [
    SelectedGroup(groupId: 'MyGroup', groupName: 'My Group', isSelected: true),
    SelectedGroup(
        groupId: 'MyOwnedGroup',
        groupName: 'My Owned Group',
        isSelected: false),
    SelectedGroup(
        groupId: 'MyJoinedGroup',
        groupName: 'My Joined Group',
        isSelected: false),
    SelectedGroup(
        groupId: 'PublicGroup', groupName: 'Public Group', isSelected: false),
  ];
  AlertPreferenceGroupDTO? alertPrefGroupDTO;

  Future<AlertPreferenceGroupDTO> getAlertPreferenceGroup(BuildContext ctx) {
    AlertPreferenceApi alertPreferenceApi = AlertPreferenceApi(ctx);
    return alertPreferenceApi.getAlertPrefGroup(selectedGroup);
  }

  @override
  void initState() {
    super.initState();
    Utils.setFirebaseAnalyticsCurrentScreen(
        Constants.ANALYTICS_ADMIN_ALERT_PREFERENCE_SCREEN);
    callAllData(context);
    setState(() {
      theme_dark = AppCache.sortFilterCacheDTO!.currentTheme;
    });
  }

  callAllData(BuildContext context) async {
    await getAlertPreferenceGroup(context).then((value) {
      alertPrefGroupDTO = value;

      // print(AppCache.sortFilterCacheDTO!.defaultEquipments![0].equipmentId!);
      //  print(summaryUtilAndNonUtilData.data![0]);
    }).catchError((error) {
      Utils.printInfo(error);
    });

    setState(() {
      isLoading = false;
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
          Utils.getTranslated(context, 'alertPreference_appbar_title')!,
          style: AppFonts.robotoRegular(20,
              color: theme_dark!
                  ? AppColors.appGrey()
                  : AppColorsLightMode.appGrey(),
              decoration: TextDecoration.none),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Image.asset(
              theme_dark!
                  ? Constants.ASSET_IMAGES + 'back_bttn.png'
                  : Constants.ASSET_IMAGES_LIGHT + 'back_bttn.png',
            )),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.searchRoute,
                    arguments:
                        SearchArguments(groupList: alertPrefGroupDTO!.data));
              },
              icon: Image.asset(
                theme_dark!
                    ? Constants.ASSET_IMAGES + 'search_icon.png'
                    : Constants.ASSET_IMAGES_LIGHT + 'search.png',
                height: 24,
              )),
        ],
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
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 16, top: 20, bottom: 20),
                          child: Row(
                            children: groupList
                                .map((e) => dataGroup(context, e))
                                .toList(),
                          ),
                        )),
                    Container(
                      margin: EdgeInsets.only(left: 16, right: 16),
                      child: Column(
                        children: alertPrefGroupDTO!.data!
                            .map((e) =>
                                alertgroupdataItem(context, e, selectedTag))
                            .toList(),
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }

  Widget alertgroupdataItem(BuildContext context, AlertPreferenceGroupDataDTO e,
      String? selectedTag) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.group_details, arguments: e);
      },
      child: Container(
        // height: 130,
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: theme_dark!
              ? AppColors.appBlackLight()
              : AppColorsLightMode.serverAppBar(),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Expanded(
                child: Row(
                  children: [
                    Text(
                      e.groupId!.toString(),
                      style: AppFonts.robotoMedium(14,
                          color: theme_dark!
                              ? AppColors.appGreyDE()
                              : AppColorsLightMode.appGrey(),
                          decoration: TextDecoration.none),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 14, right: 14),
                      child: Text(
                        '|',
                        style: AppFonts.robotoMedium(14,
                            color: theme_dark!
                                ? AppColors.appGreyDE()
                                : AppColorsLightMode.appGrey(),
                            decoration: TextDecoration.none),
                      ),
                    ),
                    Flexible(
                      child: Text(
                        e.groupName!,
                        style: AppFonts.robotoMedium(14,
                            color: theme_dark!
                                ? AppColors.appGreyDE()
                                : AppColorsLightMode.appGrey(),
                            decoration: TextDecoration.none),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              (e.groupVisibility!)
                  ? Image.asset(
                      theme_dark!
                          ? Constants.ASSET_IMAGES + 'public_icon.png'
                          : Constants.ASSET_IMAGES_LIGHT + 'public.png',
                    )
                  : Image.asset(
                      theme_dark!
                          ? Constants.ASSET_IMAGES + 'private_icon.png'
                          : Constants.ASSET_IMAGES_LIGHT + 'private.png',
                    ),
            ]),
            SizedBox(
              height: 13,
            ),
            Text(
              Utils.isNotEmpty(e.groupDescription) ? e.groupDescription! : '-',
              style: AppFonts.robotoRegular(14,
                  color: theme_dark!
                      ? AppColors.appGreyB1()
                      : AppColorsLightMode.appGrey(),
                  decoration: TextDecoration.none),
            ),
            SizedBox(
              height: 29,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(
                  theme_dark!
                      ? Constants.ASSET_IMAGES + 'member_icon.png'
                      : Constants.ASSET_IMAGES_LIGHT + 'members_icon.png',
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: Text(
                    '${e.groupUsers!.length.toString()} ${Utils.getTranslated(context, 'members')!}',
                    style: AppFonts.robotoRegular(
                      14,
                      color: theme_dark!
                          ? AppColors.appGreyB1()
                          : AppColorsLightMode.appGrey(),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget dataGroup(BuildContext ctx, SelectedGroup e) {
    String? title;
    if (e.groupId == 'MyGroup') {
      title = Utils.getTranslated(ctx, 'setting_myGroup')!;
    } else if (e.groupId == 'MyOwnedGroup') {
      title = Utils.getTranslated(ctx, 'setting_myOwnedGroup')!;
    } else if (e.groupId == 'MyJoinedGroup') {
      title = Utils.getTranslated(ctx, 'setting_myJoinedGroup')!;
    } else {
      title = Utils.getTranslated(ctx, 'setting_publicGroup')!;
    }
    return Container(
      margin: EdgeInsets.only(right: 16),
      child: GestureDetector(
        onTap: () {
          setState(() {
            groupList.forEach((element) {
              element.isSelected = false;
            });
            e.isSelected = true;
            isLoading = true;
            selectedGroup = e.groupId!;
            callAllData(context);
          });
        },
        child: Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(17.5),
              color: e.isSelected!
                  ? theme_dark!
                      ? AppColors.appTeal()
                      : AppColorsLightMode.appTeal()
                  : theme_dark!
                      ? AppColors.appGrey4A()
                      : AppColors.appPrimaryWhite(),
              border: Border.all(
                color: theme_dark! ? Colors.transparent : AppColors.appGrey89(),
              )),
          height: 35,
          //padding: EdgeInsets.all(10),

          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(
              title,
              style: AppFonts.robotoRegular(16,
                  color: e.isSelected!
                      ? theme_dark!
                          ? AppColors.appPrimaryWhite()
                          : AppColors.appPrimaryWhite()
                      : theme_dark!
                          ? AppColors.appPrimaryWhite()
                          : AppColorsLightMode.appPrimaryWhite(),
                  decoration: TextDecoration.none),
            ),
          ]),
        ),
      ),
    );
  }
}
