import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:keysight_pma/const/appcolors.dart';
import 'package:keysight_pma/const/appfonts.dart';
import 'package:keysight_pma/const/constants.dart';
import 'package:keysight_pma/const/utils.dart';
import 'package:keysight_pma/model/customize.dart';
import 'package:keysight_pma/model/dqm/custom.dart';

import '../../../cache/appcache.dart';

class DqmTestResultProbeFinderFilterScreen extends StatefulWidget {
  final List<DqmCustomDTO>? fixturesList;
  final List<DqmCustomDTO>? filterType;
  DqmTestResultProbeFinderFilterScreen({
    Key? key,
    this.fixturesList,
    this.filterType,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DqmTestResultProbeFinderFilterScreen();
  }
}

class _DqmTestResultProbeFinderFilterScreen
    extends State<DqmTestResultProbeFinderFilterScreen> {
  int fromFilterBy = 1001;
  int fromView = 1002;
  int fromFixture = 1003;
  List<CustomDqmSortFilterItemSelectionDTO> companyList = [];
  List<DqmCustomDTO> siteList = [];
  List<DqmCustomDTO> versionList = [];
  bool? theme_dark = AppCache.sortFilterCacheDTO!.currentTheme;

  String snfProjectName = '';
  String equipmentNameList = '';
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(const Duration(days: 5));

  @override
  void initState() {
    super.initState();
    Utils.setFirebaseAnalyticsCurrentScreen(
        Constants.ANALYTICS_DQM_TEST_RESULT_PROBE_HEATMAP_FILTER_SCREEN);
    setState(() {
      siteList = widget.filterType!;
      versionList = widget.fixturesList!;
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
                      //probeProperty(context),
                      view(context),
                      fixture(context),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 14.0),
                color: theme_dark!
                    ? AppColors.appPrimaryBlack()
                    : AppColorsLightMode.appPrimaryBlack(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                          padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                          decoration: BoxDecoration(
                              color: Colors.transparent,
                              border: Border.all(
                                color: theme_dark!
                                    ? AppColors.appGreyD3()
                                    : AppColorsLightMode.appPrimaryYellow(),
                              ),
                              borderRadius: BorderRadius.circular(2.0)),
                          child: Text(
                            Utils.getTranslated(
                                context, 'sort_and_filter_clear_btn')!,
                            style: AppFonts.robotoMedium(
                              15,
                              color: theme_dark!
                                  ? AppColors.appPrimaryWhite()
                                  : AppColorsLightMode.appPrimaryYellow(),
                              decoration: TextDecoration.none,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16.0),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context, true);
                        },
                        child: Container(
                          padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                          decoration: BoxDecoration(
                              color: AppColors.appPrimaryYellow(),
                              border: Border.all(color: Colors.transparent),
                              borderRadius: BorderRadius.circular(2.0)),
                          child: Text(
                            Utils.getTranslated(
                                context, 'sort_and_filter_filter_btn')!,
                            style: AppFonts.robotoMedium(
                              15,
                              color: AppColors.appPrimaryWhite(),
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
            ],
          ),
        ),
      ),
    );
  }

  // Widget probeProperty(BuildContext ctx) {
  //   return Container(
  //     margin: EdgeInsets.only(top: 22.0),
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.start,
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(
  //           'View',
  //           style: AppFonts.robotoRegular(
  //             16,
  //             color: theme_dark!
  // ? AppColors.appGrey2()
  // : AppColorsLightMode.appGrey(),
  //             decoration: TextDecoration.none,
  //           ),
  //         ),
  //         SizedBox(height: 8.0),
  //         Wrap(
  //           children: widget.filterProbePropertyList!
  //               .map((e) => probePropertyDataItem(ctx, e))
  //               .toList(),
  //         ),
  //         divider(ctx),
  //       ],
  //     ),
  //   );
  // }

  // Widget probePropertyDataItem(
  //     BuildContext ctx, CustomDqmSortFilterItemSelectionDTO filterDTO) {
  //   return GestureDetector(
  //     onTap: () {
  //       setState(() {
  //         filterDTO.isSelected = !filterDTO.isSelected!;
  //       });
  //     },
  //     child: Container(
  //       padding: EdgeInsets.fromLTRB(12.0, 9.0, 12.0, 9.0),
  //       margin: EdgeInsets.only(right: 14.0, top: 14.0),
  //       decoration: BoxDecoration(
  //         color:
  //             filterDTO.isSelected! ? AppColors.appTeal() : Colors.transparent,
  //         border: filterDTO.isSelected!
  //             ? Border.all(color: Colors.transparent)
  //             : Border.all(color: AppColors.appTeal()),
  //         borderRadius: BorderRadius.circular(50.0),
  //       ),
  //       child: Text(
  //         filterDTO.item!,
  //         style: AppFonts.robotoMedium(
  //           14,
  //           color: filterDTO.isSelected!
  //               ? AppColors.appPrimaryWhite()
  //               : AppColors.appTeal(),
  //           decoration: TextDecoration.none,
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget view(BuildContext ctx) {
    return Container(
      margin: EdgeInsets.only(top: 22.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Utils.getTranslated(ctx, 'dqm_testresult_probe_finder_filterby')!,
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
            children: siteList.map((e) => dataItem(ctx, e, fromView)).toList(),
          ),
          divider(ctx),
        ],
      ),
    );
  }

  Widget fixture(BuildContext ctx) {
    return Container(
      margin: EdgeInsets.only(top: 22.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Utils.getTranslated(
                ctx, 'dqm_testresult_probe_finder_filter_fixture')!,
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
            children:
                versionList.map((e) => dataItem(ctx, e, fromFixture)).toList(),
          ),
        ],
      ),
    );
  }

  Widget dataItem(BuildContext ctx, DqmCustomDTO dqmCustomDTO, int fromWhere) {
    return GestureDetector(
      onTap: () {
        if (fromWhere == fromView) {
          siteList.forEach((value) {
            value.customDataIsSelected = false;
          });
        } else if (fromWhere == fromFixture) {
          versionList.forEach((value) {
            value.customDataIsSelected = false;
          });
        }

        setState(() {
          dqmCustomDTO.customDataIsSelected = true;
        });
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(12.0, 9.0, 12.0, 9.0),
        margin: EdgeInsets.only(right: 14.0, top: 14.0),
        decoration: BoxDecoration(
          color: dqmCustomDTO.customDataIsSelected!
              ? AppColors.appTeal()
              : Colors.transparent,
          border: dqmCustomDTO.customDataIsSelected!
              ? Border.all(color: Colors.transparent)
              : Border.all(color: AppColors.appTeal()),
          borderRadius: BorderRadius.circular(50.0),
        ),
        child: Text(
          dqmCustomDTO.customDataName!,
          style: AppFonts.robotoMedium(
            14,
            color: dqmCustomDTO.customDataIsSelected!
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
