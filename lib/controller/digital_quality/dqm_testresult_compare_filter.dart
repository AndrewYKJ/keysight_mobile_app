import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:keysight_pma/cache/appcache.dart';
import 'package:keysight_pma/const/appcolors.dart';
import 'package:keysight_pma/const/appfonts.dart';
import 'package:keysight_pma/const/constants.dart';
import 'package:keysight_pma/const/utils.dart';
import 'package:keysight_pma/model/customize.dart';

class DqmTestResultCompareFilterScreen extends StatefulWidget {
  final List<CustomDqmSortFilterItemSelectionDTO>? filterTestResultList;
  final String? compareBy;
  DqmTestResultCompareFilterScreen(
      {Key? key, this.filterTestResultList, this.compareBy})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DqmTestResultCompareFilterScreen();
  }
}

class _DqmTestResultCompareFilterScreen
    extends State<DqmTestResultCompareFilterScreen> {
  bool? theme_dark = AppCache.sortFilterCacheDTO!.currentTheme;

  @override
  void initState() {
    super.initState();
    Utils.setFirebaseAnalyticsCurrentScreen(
        Constants.ANALYTICS_DQM_TEST_RESULT_COMPARE_FILTER_SCREEN);
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
            Utils.getTranslated(context, 'sort_and_filter_appbar_text')!,
            style: AppFonts.robotoRegular(
              20,
              color: theme_dark!
                  ? AppColors.appGrey()
                  : AppColorsLightMode.appGrey(),
              decoration: TextDecoration.none,
            ),
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Image.asset(theme_dark!
                ? Constants.ASSET_IMAGES + 'close_bttn.png'
                : Constants.ASSET_IMAGES_LIGHT + 'close_icon.png'),
          )
        ],
      ),
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 21.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      testResult(context),
                    ],
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(top: 14.0, left: 50.0, right: 50.0),
                color: theme_dark!
                    ? AppColors.appPrimaryBlack()
                    : AppColorsLightMode.appPrimaryBlack(),
                child: GestureDetector(
                  onTap: () {
                    List<String?> tempList = widget.filterTestResultList!
                        .where((element) => element.isSelected!)
                        .map((e) => e.item)
                        .toList();
                    if (tempList.length > 0) {
                      Navigator.pop(context, tempList);
                    } else {
                      if (widget.compareBy == Constants.COMPARE_BY_FIXTURE) {
                        Utils.showAlertDialog(
                            context,
                            'Info',
                            Utils.getTranslated(
                                context, 'compare_fixture_empty_msg')!);
                      } else if (widget.compareBy ==
                          Constants.COMPARE_BY_EQUIPMENT) {
                        Utils.showAlertDialog(
                            context,
                            'Info',
                            Utils.getTranslated(
                                context, 'compare_equipemnt_empty_msg')!);
                      } else if (widget.compareBy ==
                          Constants.COMPARE_BY_EQUIP_FIX) {
                        Utils.showAlertDialog(
                            context,
                            'Info',
                            Utils.getTranslated(
                                context, 'compare_equip_fix_empty_msg')!);
                      } else if (widget.compareBy ==
                          Constants.COMPARE_BY_PANEL) {
                        Utils.showAlertDialog(
                            context,
                            'Info',
                            Utils.getTranslated(
                                context, 'compare_panel_empty_msg')!);
                      }
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                    decoration: BoxDecoration(
                        color: AppColors.appPrimaryYellow(),
                        border: Border.all(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(2.0)),
                    child: Text(
                      Utils.getTranslated(context, 'compare')!,
                      style: AppFonts.robotoMedium(
                        15,
                        color: theme_dark!
                            ? AppColors.appPrimaryWhite()
                            : AppColorsLightMode.appGrey(),
                        decoration: TextDecoration.none,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget testResult(BuildContext ctx) {
    return Container(
      margin: EdgeInsets.only(top: 22.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.compareBy == Constants.COMPARE_BY_EQUIPMENT
                ? Utils.getTranslated(ctx, 'compare_equipment_selection')!
                : widget.compareBy == Constants.COMPARE_BY_FIXTURE
                    ? Utils.getTranslated(ctx, 'compare_fixture_selection')!
                    : widget.compareBy == Constants.COMPARE_BY_EQUIP_FIX
                        ? Utils.getTranslated(
                            ctx, 'compare_equip_fix_selection')!
                        : widget.compareBy == Constants.COMPARE_BY_PANEL ||
                                widget.compareBy ==
                                    Constants.COMPARE_BY_ALL_PANEL
                            ? Utils.getTranslated(
                                ctx, 'compare_panel_selection')!
                            : '',
            style: AppFonts.robotoRegular(
              16,
              color: theme_dark!
                  ? AppColors.appGrey2()
                  : AppColorsLightMode.appGrey(),
              decoration: TextDecoration.none,
            ),
          ),
          SizedBox(height: 8.0),
          Wrap(
            children: widget.filterTestResultList!
                .map((e) => testResultDataItem(ctx, e))
                .toList(),
          ),
          // divider(ctx),
        ],
      ),
    );
  }

  Widget testResultDataItem(
      BuildContext ctx, CustomDqmSortFilterItemSelectionDTO data) {
    return GestureDetector(
      onTap: () {
        setState(() {
          data.isSelected = !data.isSelected!;
        });
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(12.0, 9.0, 12.0, 9.0),
        margin: EdgeInsets.only(right: 14.0, top: 14.0),
        decoration: BoxDecoration(
          color: data.isSelected! ? AppColors.appTeal() : Colors.transparent,
          border: data.isSelected!
              ? Border.all(color: Colors.transparent)
              : Border.all(color: AppColors.appTeal()),
          borderRadius: BorderRadius.circular(50.0),
        ),
        child: Text(
          data.item!,
          style: AppFonts.robotoMedium(
            14,
            color: data.isSelected!
                ? AppColors.appPrimaryWhite()
                : AppColors.appTeal(),
            decoration: TextDecoration.none,
          ),
        ),
      ),
    );
  }

  Widget divider(BuildContext ctx) {
    return Container(
      margin: EdgeInsets.only(top: 22.0),
      width: MediaQuery.of(ctx).size.width,
      height: 1.0,
      color: theme_dark!
          ? AppColors.appDividerColor()
          : AppColorsLightMode.appDividerColor(),
    );
  }
}
