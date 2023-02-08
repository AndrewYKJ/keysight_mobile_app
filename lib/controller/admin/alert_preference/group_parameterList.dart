import 'package:flutter/material.dart';
import 'package:keysight_pma/cache/appcache.dart';
import 'package:keysight_pma/const/appcolors.dart';
import 'package:keysight_pma/const/appfonts.dart';
import 'package:keysight_pma/const/constants.dart';
import 'package:keysight_pma/const/utils.dart';
import 'package:keysight_pma/model/alertPreferencemodel.dart';

class GroupParameterList extends StatefulWidget {
  final List<GroupParametersDisplay>? alertInfo;
  const GroupParameterList({Key? key, this.alertInfo}) : super(key: key);

  @override
  State<GroupParameterList> createState() => _GroupParameterListState();
}

class _GroupParameterListState extends State<GroupParameterList> {
  bool? isDarkTheme = AppCache.sortFilterCacheDTO!.currentTheme;

  @override
  void initState() {
    super.initState();
    Utils.setFirebaseAnalyticsCurrentScreen(Constants
        .ANALYTICS_ADMIN_ALERT_PREFERENCE_GROUP_PARAMETER_LIST_INFO_SCREEN);
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
          Utils.getTranslated(context, 'parameterList')!,
          style: AppFonts.robotoRegular(20,
              color: isDarkTheme!
                  ? AppColors.appGrey()
                  : AppColorsLightMode.appGrey(),
              decoration: TextDecoration.none),
        ),
        actions: [
          //   IconButton(
          //       onPressed: () {
          //         Navigator.pushNamed(context, AppRoutes.searchRoute);
          //       },
          //       icon: Image.asset(theme_dark!
          //           ? Constants.ASSET_IMAGES + 'search_icon.png'
          //           : Constants.ASSET_IMAGES_LIGHT + 'search.png')),
          //
        ],
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
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: widget.alertInfo!.map((e) => dataPara(context, e)).toList(),
        ),
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
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(left: 16, right: 16, top: 12),
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
              '${e.companyName}  |  ${e.siteName} ',
              style: AppFonts.robotoMedium(13,
                  color: isDarkTheme!
                      ? AppColors.appGreyDE()
                      : AppColorsLightMode.appGrey(),
                  decoration: TextDecoration.none),
            ),
            SizedBox(
              height: 14,
            ),
            Text(
              ('${Utils.getTranslated(context, 'alert_shift')} (' +
                  e.shiftList!.length.toString() +
                  ')'),
              style: AppFonts.sfproRegular(14,
                  color: isDarkTheme!
                      ? AppColors.appGreyB1()
                      : AppColorsLightMode.appGrey77(),
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
                            : AppColorsLightMode.appGrey77(),
                        decoration: TextDecoration.none),
                  )
                : SizedBox(
                    height: 14,
                  ),
            SizedBox(
              height: 14,
            ),
            Text(
              ('${Utils.getTranslated(context, 'alert_project')} (' +
                  e.projectList!.length.toString() +
                  ')'),
              style: AppFonts.sfproRegular(14,
                  color: isDarkTheme!
                      ? AppColors.appGreyB1()
                      : AppColorsLightMode.appGrey77(),
                  decoration: TextDecoration.none),
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
                            : AppColorsLightMode.appGrey77(),
                        decoration: TextDecoration.none),
                  )
                : SizedBox(
                    height: 14,
                  ),
            SizedBox(
              height: 14,
            ),
            Text(
              ('${Utils.getTranslated(context, 'alert_equipment')} (' +
                  e.equipmentList!.length.toString() +
                  ')'),
              style: AppFonts.sfproRegular(14,
                  color: isDarkTheme!
                      ? AppColors.appGreyB1()
                      : AppColorsLightMode.appGrey77(),
                  decoration: TextDecoration.none),
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
                            : AppColorsLightMode.appGrey77(),
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
