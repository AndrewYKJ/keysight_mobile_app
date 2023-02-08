import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:keysight_pma/cache/appcache.dart';
import 'package:keysight_pma/const/appcolors.dart';
import 'package:keysight_pma/const/appfonts.dart';
import 'package:keysight_pma/const/constants.dart';
import 'package:keysight_pma/const/utils.dart';
import 'package:keysight_pma/model/customize.dart';

class DqmTestResultAnalogInfoFilterScreen extends StatefulWidget {
  final List<CustomDqmSortFilterItemSelectionDTO>? filterTestTypeList;
  DqmTestResultAnalogInfoFilterScreen({Key? key, this.filterTestTypeList})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DqmTestResultAnalogInfoFilterScreen();
  }
}

class _DqmTestResultAnalogInfoFilterScreen
    extends State<DqmTestResultAnalogInfoFilterScreen> {
  List<CustomDqmSortFilterItemSelectionDTO> testTypeList = [];
  bool isSelectAll = false;
  bool? theme_dark = AppCache.sortFilterCacheDTO!.currentTheme;

  @override
  void initState() {
    super.initState();
    Utils.setFirebaseAnalyticsCurrentScreen(
        Constants.ANALYTICS_DQM_TEST_RESULT_FILTER_SCREEN);
    if (widget.filterTestTypeList != null &&
        widget.filterTestTypeList!.length > 0) {
      setState(() {
        this.isSelectAll =
            Utils.isSelectAll(itemList: widget.filterTestTypeList);
      });
    }
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
                      testType(context),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 14.0),
                color: theme_dark!
                    ? AppColors.appPrimaryBlack()
                    : AppColorsLightMode.appPrimaryBlack(),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context, true);
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                    margin: EdgeInsets.only(left: 90.0, right: 90.0),
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
                // child: Row(
                //   mainAxisAlignment: MainAxisAlignment.start,
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     Expanded(
                //       child: GestureDetector(
                //         onTap: () {},
                //         child: Container(
                //           padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                //           decoration: BoxDecoration(
                //               color: Colors.transparent,
                //               border: Border.all(color: AppColors.appGreyD3()),
                //               borderRadius: BorderRadius.circular(2.0)),
                //           child: Text(
                //             Utils.getTranslated(
                //                 context, 'sort_and_filter_clear_btn')!,
                //             style: AppFonts.robotoMedium(
                //               15,
                //               color: AppColors.appPrimaryWhite(),
                //               decoration: TextDecoration.none,
                //             ),
                //             textAlign: TextAlign.center,
                //           ),
                //         ),
                //       ),
                //     ),
                //     SizedBox(width: 16.0),
                //     Expanded(
                //       child: GestureDetector(
                //         onTap: () {
                //           Navigator.pop(context, true);
                //         },
                //         child: Container(
                //           padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                //           margin: EdgeInsets.only(left: 90.0, right: 90.0),
                //           decoration: BoxDecoration(
                //               color: AppColors.appPrimaryYellow(),
                //               border: Border.all(color: Colors.transparent),
                //               borderRadius: BorderRadius.circular(2.0)),
                //           child: Text(
                //             Utils.getTranslated(
                //                 context, 'sort_and_filter_filter_btn')!,
                //             style: AppFonts.robotoMedium(
                //               15,
                //               color: AppColors.appPrimaryWhite(),
                //               decoration: TextDecoration.none,
                //             ),
                //             textAlign: TextAlign.center,
                //           ),
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget testType(BuildContext ctx) {
    return Container(
      margin: EdgeInsets.only(top: 22.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  Utils.getTranslated(
                      ctx, 'dqm_testresult_analog_info_filterby_test_type')!,
                  style: AppFonts.robotoRegular(
                    16,
                    color: theme_dark!
                        ? AppColors.appGrey2()
                        : AppColorsLightMode.appGrey(),
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
              SizedBox(width: 10.0),
              GestureDetector(
                onTap: () {
                  setState(() {
                    this.isSelectAll = !this.isSelectAll;
                    if (this.isSelectAll) {
                      widget.filterTestTypeList!.forEach((element) {
                        element.isSelected = true;
                      });
                    } else {
                      widget.filterTestTypeList!.forEach((element) {
                        element.isSelected = false;
                      });
                    }
                  });
                },
                child: Text(
                  !this.isSelectAll
                      ? Utils.getTranslated(ctx, 'select_all')!
                      : Utils.getTranslated(ctx, 'deselect_all')!,
                  style: AppFonts.robotoRegular(
                    16,
                    color: theme_dark!
                        ? AppColors.appGrey2()
                        : AppColorsLightMode.appGrey(),
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.0),
          Wrap(
            children: widget.filterTestTypeList!
                .map((e) => testTypeDataItem(ctx, e))
                .toList(),
          ),
          // divider(ctx),
        ],
      ),
    );
  }

  Widget testTypeDataItem(
      BuildContext ctx, CustomDqmSortFilterItemSelectionDTO filterDTO) {
    return GestureDetector(
      onTap: () {
        setState(() {
          filterDTO.isSelected = !filterDTO.isSelected!;
          this.isSelectAll =
              Utils.isSelectAll(itemList: widget.filterTestTypeList);
        });
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(12.0, 9.0, 12.0, 9.0),
        margin: EdgeInsets.only(right: 14.0, top: 14.0),
        decoration: BoxDecoration(
          color:
              filterDTO.isSelected! ? AppColors.appTeal() : Colors.transparent,
          border: filterDTO.isSelected!
              ? Border.all(color: Colors.transparent)
              : Border.all(color: AppColors.appTeal()),
          borderRadius: BorderRadius.circular(50.0),
        ),
        child: Text(
          filterDTO.item!,
          style: AppFonts.robotoMedium(
            14,
            color: filterDTO.isSelected!
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
