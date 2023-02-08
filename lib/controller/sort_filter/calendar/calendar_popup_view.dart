import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:keysight_pma/cache/appcache.dart';
import 'package:keysight_pma/const/appcolors.dart';
import 'package:keysight_pma/const/appfonts.dart';
import 'package:keysight_pma/const/utils.dart';
import 'package:keysight_pma/controller/sort_filter/calendar/custom_calendar_view.dart';

class CalendarPopupView extends StatefulWidget {
  const CalendarPopupView(
      {Key? key,
      this.initialStartDate,
      this.initialEndDate,
      this.onApplyClick,
      this.barrierDismissible = true,
      this.minimumDate,
      this.maximumDate})
      : super(key: key);

  final DateTime? minimumDate;
  final DateTime? maximumDate;
  final bool barrierDismissible;
  final DateTime? initialStartDate;
  final DateTime? initialEndDate;
  final Function(DateTime, DateTime)? onApplyClick;

  @override
  _CalendarPopupViewState createState() => _CalendarPopupViewState();
}

class _CalendarPopupViewState extends State<CalendarPopupView>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  DateTime? startDate;
  DateTime? endDate;
  bool? theme_dark = AppCache.sortFilterCacheDTO!.currentTheme;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 400), vsync: this);
    if (widget.initialStartDate != null) {
      startDate = widget.initialStartDate;
    }
    if (widget.initialEndDate != null) {
      endDate = widget.initialEndDate;
    }
    animationController?.forward();
    super.initState();
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: InkWell(
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          onTap: () {
            if (widget.barrierDismissible) {
              Navigator.pop(context);
            }
          },
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: theme_dark!
                      ? AppColors.appGrey60()
                      : AppColors.appPrimaryWhite(),
                  borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        offset: const Offset(4, 4),
                        blurRadius: 8.0),
                  ],
                ),
                child: InkWell(
                  borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                  onTap: () {},
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "From",
                                  textAlign: TextAlign.left,
                                  style: AppFonts.robotoRegular(
                                    14,
                                    color: theme_dark!
                                        ? AppColors.appGrey()
                                        : AppColorsLightMode.appGrey(),
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                Text(
                                  startDate != null
                                      ? DateFormat('EEE, dd MMM')
                                          .format(startDate!)
                                      : '--/-- ',
                                  style: AppFonts.robotoBold(
                                    16,
                                    color: theme_dark!
                                        ? AppColors.appWhiteE6()
                                        : AppColorsLightMode.appGrey(),
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 74,
                            width: 1,
                            color: AppColors.appGrey70(),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "To",
                                  style: AppFonts.robotoRegular(
                                    14,
                                    color: theme_dark!
                                        ? AppColors.appGrey()
                                        : AppColorsLightMode.appGrey(),
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                                const SizedBox(
                                  height: 8.0,
                                ),
                                Text(
                                  endDate != null
                                      ? DateFormat('EEE, dd MMM')
                                          .format(endDate!)
                                      : '--/-- ',
                                  style: AppFonts.robotoBold(
                                    16,
                                    color: theme_dark!
                                        ? AppColors.appWhiteE6()
                                        : AppColorsLightMode.appGrey(),
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 60.0),
                      CustomCalendarView(
                        minimumDate: widget.minimumDate,
                        maximumDate: widget.maximumDate,
                        initialEndDate: widget.initialEndDate,
                        initialStartDate: widget.initialStartDate,
                        startEndDateChange:
                            (DateTime startDateData, DateTime endDateData) {
                          setState(() {
                            startDate = startDateData;
                            endDate = endDateData;
                          });
                        },
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(24.0, 30.0, 24.0, 30.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    startDate = AppCache.sortFilterCacheDTO!
                                        .preferredStartDate!;
                                    endDate = AppCache
                                        .sortFilterCacheDTO!.preferredEndDate!;
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    border: Border.all(
                                        color: theme_dark!
                                            ? AppColors.appGreyD3()
                                            : AppColorsLightMode
                                                .appPrimaryYellow()),
                                    borderRadius: BorderRadius.circular(2.0),
                                  ),
                                  child: Text(
                                    Utils.getTranslated(
                                        context, 'calendar_reset')!,
                                    style: AppFonts.robotoMedium(
                                      15,
                                      color: theme_dark!
                                          ? AppColors.appPrimaryWhite()
                                          : AppColorsLightMode
                                              .appPrimaryYellow(),
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
                                  try {
                                    widget.onApplyClick!(startDate!, endDate!);
                                    Navigator.pop(context);
                                  } catch (_) {}
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                    color: AppColors.appPrimaryYellow(),
                                    borderRadius: BorderRadius.circular(2.0),
                                  ),
                                  child: Text(
                                    Utils.getTranslated(
                                        context, 'calendar_apply')!,
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
                      // Padding(
                      //   padding: const EdgeInsets.only(
                      //       left: 16, right: 16, bottom: 16, top: 8),
                      //   child: Container(
                      //     height: 48,
                      //     decoration: BoxDecoration(
                      //       color: Theme.of(context).primaryColor,
                      //       borderRadius:
                      //           const BorderRadius.all(Radius.circular(24.0)),
                      //       boxShadow: <BoxShadow>[
                      //         BoxShadow(
                      //           color: Colors.grey.withOpacity(0.6),
                      //           blurRadius: 8,
                      //           offset: const Offset(4, 4),
                      //         ),
                      //       ],
                      //     ),
                      //     child: Material(
                      //       color: Colors.transparent,
                      //       child: InkWell(
                      //         borderRadius:
                      //             const BorderRadius.all(Radius.circular(24.0)),
                      //         highlightColor: Colors.transparent,
                      //         onTap: () {
                      //           try {
                      //             widget.onApplyClick!(startDate!, endDate!);
                      //             Navigator.pop(context);
                      //           } catch (_) {}
                      //         },
                      //         child: const Center(
                      //           child: Text(
                      //             'Apply',
                      //             style: TextStyle(
                      //                 fontWeight: FontWeight.w500,
                      //                 fontSize: 18,
                      //                 color: Colors.white),
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
