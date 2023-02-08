import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:keysight_pma/cache/appcache.dart';
import 'package:keysight_pma/const/appcolors.dart';
import 'package:keysight_pma/const/appfonts.dart';
import 'package:keysight_pma/const/constants.dart';
import 'package:keysight_pma/const/utils.dart';
import 'package:keysight_pma/controller/sort_filter/calendar/calendar_popup_view.dart';
import 'package:keysight_pma/model/alert/alert_group.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';

class AlertPreferedSortFilterScreen extends StatefulWidget {
  final AlertGroupDTO? alertGroupDTO;
  final num? pickedGroupId;

  AlertPreferedSortFilterScreen(
      {Key? key, this.alertGroupDTO, this.pickedGroupId})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AlertSortAndFilterScreen();
  }
}

class _AlertSortAndFilterScreen extends State<AlertPreferedSortFilterScreen> {
  num? groupId;
  bool? theme_dark = AppCache.sortFilterCacheDTO!.currentTheme;

  @override
  void initState() {
    super.initState();
    Utils.setFirebaseAnalyticsCurrentScreen(
        Constants.ANALYTICS_ALERT_REVIEW_PREFERED_FILTER_SCREEN);
    setState(() {
      this.groupId = widget.pickedGroupId;
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
                      dateRange(context),
                      group(context),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 14.0),
                color: theme_dark!
                    ? AppColors.appPrimaryBlack()
                    : AppColorsLightMode.appPrimaryBlack(),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(left: 90, right: 90),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context, this.groupId);
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
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.start,
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     Expanded(
                //       child: GestureDetector(
                //         onTap: () {
                //           setState(() {});
                //         },
                //         child: Container(
                //           padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                //           decoration: BoxDecoration(
                //               color: Colors.transparent,
                //               border: Border.all(
                //                 color: theme_dark!
                //                     ? AppColors.appGreyD3()
                //                     : AppColorsLightMode.appPrimaryYellow(),
                //               ),
                //               borderRadius: BorderRadius.circular(2.0)),
                //           child: Text(
                //             Utils.getTranslated(
                //                 context, 'sort_and_filter_clear_btn')!,
                //             style: AppFonts.robotoMedium(
                //               15,
                //               color: theme_dark!
                //                   ? AppColors.appPrimaryWhite()
                //                   : AppColorsLightMode.appPrimaryYellow(),
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
                //           Navigator.pop(context, this.groupId);
                //         },
                //         child: Container(
                //           padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
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

  Widget dateRange(BuildContext ctx) {
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
                  Utils.getTranslated(ctx, 'sort_and_filter_daterange')!,
                  style: AppFonts.robotoRegular(
                    16,
                    color: theme_dark!
                        ? AppColors.appGrey2()
                        : AppColorsLightMode.appGrey(),
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  FocusScope.of(ctx).requestFocus(FocusNode());
                  showCalendarDialog(ctx);
                  // List<DateTime>? dateTimeList =
                  //     await showOmniDateTimeRangePicker(
                  //   context: ctx,
                  //   type: OmniDateTimePickerType.date,
                  //   primaryColor: Colors.cyan,
                  //   backgroundColor: theme_dark!
                  //       ? Colors.grey[900]
                  //       : AppColors.appPrimaryWhite(),
                  //   calendarTextColor: theme_dark!
                  //       ? Colors.white
                  //       : AppColors.appPrimaryBlack(),
                  //   tabTextColor: theme_dark!
                  //       ? Colors.white
                  //       : AppColors.appPrimaryBlack(),
                  //   unselectedTabBackgroundColor: Colors.grey[700],
                  //   buttonTextColor: theme_dark!
                  //       ? Colors.white
                  //       : AppColors.appPrimaryBlack(),
                  //   timeSpinnerTextStyle: TextStyle(
                  //       color: theme_dark!
                  //           ? Colors.white
                  //           : AppColors.appPrimaryBlack(),
                  //       fontSize: 18),
                  //   timeSpinnerHighlightedTextStyle: TextStyle(
                  //       color: theme_dark!
                  //           ? Colors.white
                  //           : AppColors.appPrimaryBlack(),
                  //       fontSize: 24),
                  //   is24HourMode: false,
                  //   isShowSeconds: false,
                  //   startInitialDate: AppCache.sortFilterCacheDTO!.startDate,
                  //   startFirstDate:
                  //       DateTime(1600).subtract(const Duration(days: 3652)),
                  //   startLastDate: DateTime.now().add(
                  //     const Duration(days: 3652),
                  //   ),
                  //   endInitialDate: AppCache.sortFilterCacheDTO!.endDate,
                  //   endFirstDate:
                  //       DateTime(1600).subtract(const Duration(days: 3652)),
                  //   endLastDate: DateTime.now().add(
                  //     const Duration(days: 3652),
                  //   ),
                  //   borderRadius: const Radius.circular(16),
                  // );
                  // print(dateTimeList);
                  // if (dateTimeList != null) {
                  //   if (dateTimeList[0].isAfter(dateTimeList[1])) {
                  //     Utils.showAlertDialog(
                  //         ctx,
                  //         Utils.getTranslated(ctx, 'invalid_date_range')!,
                  //         Utils.getTranslated(
                  //             context, 'please_select_valid_date')!);
                  //   } else {
                  //     setState(() {
                  //       AppCache.sortFilterCacheDTO!.startDate =
                  //           dateTimeList[0];
                  //       AppCache.sortFilterCacheDTO!.endDate = dateTimeList[1];
                  //     });
                  //   }
                  // }
                },
                child: Container(
                  margin: EdgeInsets.only(right: 12.0),
                  child: Image.asset(theme_dark!
                      ? Constants.ASSET_IMAGES + 'date_icon.png'
                      : Constants.ASSET_IMAGES_LIGHT + 'calendar.png'),
                ),
              ),
            ],
          ),
          SizedBox(height: 13.0),
          Text(
            (AppCache.sortFilterCacheDTO!.startDate != null &&
                    AppCache.sortFilterCacheDTO!.endDate != null)
                ? '${DateFormat("MMM dd, yy").format(AppCache.sortFilterCacheDTO!.startDate!)} - ${DateFormat("MMM dd, yy").format(AppCache.sortFilterCacheDTO!.endDate!)}'
                : '',
            style: AppFonts.robotoRegular(
              16,
              color: theme_dark!
                  ? AppColors.appGrey2()
                  : AppColorsLightMode.appGrey(),
              decoration: TextDecoration.none,
            ),
          ),
          divider(ctx),
        ],
      ),
    );
  }

  void showCalendarDialog(BuildContext ctx) {
    showDialog<dynamic>(
      context: ctx,
      builder: (BuildContext context) => CalendarPopupView(
        barrierDismissible: true,
        minimumDate: DateTime.now(),
        initialEndDate: AppCache.sortFilterCacheDTO!.endDate,
        initialStartDate: AppCache.sortFilterCacheDTO!.startDate,
        onApplyClick: (DateTime startData, DateTime endData) {
          setState(() {
            AppCache.sortFilterCacheDTO!.startDate = startData;
            AppCache.sortFilterCacheDTO!.endDate = endData;
          });
        },
      ),
    );
  }

  Widget group(BuildContext ctx) {
    return Container(
      margin: EdgeInsets.only(top: 22.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Utils.getTranslated(context, 'group_name')!,
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
            children: widget.alertGroupDTO!.data!
                .map((e) => groupDataItem(ctx, e))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget groupDataItem(BuildContext ctx, AlertGroupDataDTO dataDTO) {
    return GestureDetector(
      onTap: () {
        setState(() {
          this.groupId = dataDTO.groupId;
        });
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(12.0, 9.0, 12.0, 9.0),
        margin: EdgeInsets.only(right: 14.0, top: 14.0),
        decoration: BoxDecoration(
          color: (this.groupId != null && this.groupId == dataDTO.groupId)
              ? AppColors.appTeal()
              : Colors.transparent,
          border: (this.groupId != null && this.groupId == dataDTO.groupId)
              ? Border.all(color: Colors.transparent)
              : Border.all(color: AppColors.appTeal()),
          borderRadius: BorderRadius.circular(50.0),
        ),
        child: Text(
          dataDTO.groupName!,
          style: AppFonts.robotoMedium(
            14,
            color: (this.groupId != null && this.groupId == dataDTO.groupId)
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
