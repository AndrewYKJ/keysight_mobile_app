import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:keysight_pma/cache/appcache.dart';
import 'package:keysight_pma/const/appcolors.dart';
import 'package:keysight_pma/const/appfonts.dart';
import 'package:keysight_pma/const/constants.dart';
import 'package:keysight_pma/const/utils.dart';
import 'package:keysight_pma/controller/admin/preferred_setting/custom.dart';
import 'package:keysight_pma/model/oee/oeeAvailability.dart';
import 'package:keysight_pma/model/oee/oeeEquipment.dart';
import 'package:keysight_pma/model/sortAndFilter/equipment.dart';

class OeeDashboardSortAndFilterScreen extends StatefulWidget {
  final OeeEquipmentDTO? equipmentDTO;
  final String dataType;
  final OeeAvailabilityDTO? availabilityDTO;
  final List<EquipmentDataDTO>? selectedEquipmentList;
  OeeDashboardSortAndFilterScreen(
      {Key? key,
      this.equipmentDTO,
      required this.dataType,
      this.selectedEquipmentList,
      this.availabilityDTO})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _OeeDashboardSortAndFilterScreen();
  }
}

class _OeeDashboardSortAndFilterScreen
    extends State<OeeDashboardSortAndFilterScreen> {
  List<PDate> dateRange = [
    PDate(rangeName: "By Date", rangeValue: 'Date', isSelected: false),
    PDate(rangeName: "By Week", rangeValue: 'Week', isSelected: false),
    PDate(rangeName: "By Month", rangeValue: 'Month', isSelected: false),
    PDate(rangeName: "By Shift", rangeValue: 'Shift', isSelected: false),
  ];
  List<EquipmentDataDTO>? eqList = [];
  List<EquipmentDataDTO>? base = [];
  List<EquipmentDataDTO>? projList = [];
  OeeEquipmentDTO? returnList;
  OeeEquipmentDTO? rawApiEQ;
  OeeAvailabilityDTO? rawApiProj;
  bool isLoading = false;
  bool projectSelectAll = true;
  bool equipmenrSelectAll = true;

  bool? theme_dark = AppCache.sortFilterCacheDTO!.currentTheme;

  @override
  void initState() {
    super.initState();
    Utils.setFirebaseAnalyticsCurrentScreen(
        Constants.ANALYTICS_OEE_DASHBOARD_FILTER_SCREEN);
    callAllData(context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  callAllData(BuildContext context) async {
    if (widget.dataType == Constants.CHART_OEE_DASHBOARD_DAILY_VO_EQUIPMENT ||
        widget.dataType ==
            Constants.CHART_OEE_DASHBOARD_DAILY_SCORE_EQUIPMENT ||
        widget.dataType == Constants.CHART_OEE_DASHBOARD_VO_EQUIPMENT) {
      // rawApiEQ = widget.equipmentDTO;
      setState(() {
        // returnList = widget.equipmentDTO;
        eqList = widget.selectedEquipmentList;
        this.equipmenrSelectAll = Utils.isSelectAll(eqList: eqList);

        eqList!.forEach((element) {
          print(element.equipmentId);
          print(element.isSelected);
        });
      });
    } else {
      setState(() {
        // returnList = widget.equipmentDTO;
        eqList = widget.selectedEquipmentList;
        this.equipmenrSelectAll = Utils.isSelectAll(eqList: eqList);

        eqList!.forEach((element) {
          print(element.equipmentId);
          print(element.isSelected);
        });
      });
    }

    setState(() {
      isLoading = false;
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
            child: Image.asset(
              theme_dark!
                  ? Constants.ASSET_IMAGES + 'close_bttn.png'
                  : Constants.ASSET_IMAGES_LIGHT + 'close_icon.png',
            ),
          )
        ],
      ),
      body: SafeArea(
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(AppColors.appBlue()),
                ),
              )
            : Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 21.0),
                child: Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        (widget.dataType ==
                                    Constants
                                        .CHART_OEE_DASHBOARD_DAILY_VO_PROJECT ||
                                widget.dataType ==
                                    Constants.CHART_OEE_DASHBOARD_VO_PROJECT)
                            ? projectList(context)
                            : equipmentList(context)
                      ],
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        padding: EdgeInsets.only(top: 14.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  // (widget.dataType ==
                                  //             Constants
                                  //                 .CHART_OEE_DASHBOARD_DAILY_VO_PROJECT ||
                                  //         widget.dataType ==
                                  //             Constants
                                  //                 .CHART_OEE_DASHBOARD_VO_PROJECT)
                                  //     ? returnList = removeUnselectProject(
                                  //         rawApiEQ, projList)
                                  //     : returnList = removeUnselectEquipment(
                                  //        rawApiEQ, eqList);

                                  Navigator.pop(context, eqList);
                                },
                                child: Container(
                                  margin: EdgeInsets.only(left: 90, right: 90),
                                  padding:
                                      EdgeInsets.only(top: 10.0, bottom: 10.0),
                                  decoration: BoxDecoration(
                                      color: AppColors.appPrimaryYellow(),
                                      border:
                                          Border.all(color: Colors.transparent),
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
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget equipmentList(BuildContext ctx) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.only(top: 28, bottom: 10),
                child: Text(
                  Utils.getTranslated(ctx, 'sort_and_filter_equipment')!,
                  style: AppFonts.robotoRegular(
                    16,
                    color: theme_dark!
                        ? AppColors.appGrey2()
                        : AppColorsLightMode.appGrey(),
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ),
            SizedBox(width: 10.0),
            GestureDetector(
              onTap: () {
                setState(() {
                  this.equipmenrSelectAll = !this.equipmenrSelectAll;
                  if (this.equipmenrSelectAll) {
                    eqList!.forEach((element) {
                      element.isSelected = true;
                    });
                  } else {
                    eqList!.forEach((element) {
                      element.isSelected = false;
                    });
                  }
                });
              },
              child: Container(
                padding: EdgeInsets.only(top: 28, bottom: 10),
                child: Text(
                  !this.equipmenrSelectAll
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
            ),
          ],
        ),
        Wrap(
          children: eqList!.map((e) => eqItem(context, e)).toList(),
        ),
      ],
    );
  }

  Widget projectList(BuildContext ctx) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.only(top: 28, bottom: 10),
                child: Text(
                  Utils.getTranslated(ctx, 'sort_and_filter_project')!,
                  style: AppFonts.robotoRegular(
                    16,
                    color: theme_dark!
                        ? AppColors.appGrey2()
                        : AppColorsLightMode.appGrey(),
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ),
            SizedBox(width: 10.0),
            GestureDetector(
              onTap: () {
                setState(() {
                  this.equipmenrSelectAll = !this.equipmenrSelectAll;
                  if (this.equipmenrSelectAll) {
                    eqList!.forEach((element) {
                      element.isSelected = true;
                    });
                  } else {
                    eqList!.forEach((element) {
                      element.isSelected = false;
                    });
                  }
                });
              },
              child: Container(
                padding: EdgeInsets.only(top: 28, bottom: 10),
                child: Text(
                  !this.equipmenrSelectAll
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
            ),
          ],
        ),
        Wrap(
          children: eqList!.map((e) => eqItem(context, e)).toList(),
        ),
      ],
    );
  }

  Widget eqItem(ctx, EquipmentDataDTO e) {
    return GestureDetector(
      onTap: () {
        setState(() {
          e.isSelected = !e.isSelected!;
          this.equipmenrSelectAll = Utils.isSelectAll(eqList: eqList);
        });
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(12.0, 9.0, 12.0, 9.0),
        margin: EdgeInsets.only(right: 14.0, top: 14.0),
        decoration: BoxDecoration(
          color: (e.isSelected!) ? AppColors.appTeal() : Colors.transparent,
          border: (e.isSelected!)
              ? Border.all(color: Colors.transparent)
              : Border.all(color: AppColors.appTeal()),
          borderRadius: BorderRadius.circular(50.0),
        ),
        child: Text(
          e.equipmentId!,
          style: AppFonts.robotoMedium(
            14,
            color: (e.isSelected!)
                ? AppColors.appPrimaryWhite()
                : AppColors.appTeal(),
            decoration: TextDecoration.none,
          ),
        ),
      ),
    );
  }

  removeUnselectEquipment(
      OeeEquipmentDTO? returnList, List<EquipmentDataDTO>? eqList) {
    returnList = rawApiEQ;
    eqList!.forEach((element) {
      var unselectedEq;
      if (!element.isSelected!) {
        unselectedEq = element.equipmentId!;
        returnList!.data!
            .removeWhere((item) => item.equipmentName == unselectedEq);
      }
    });
    return returnList;
  }

  removeUnselectProject(
      OeeEquipmentDTO? returnList, List<EquipmentDataDTO>? projList) {
    returnList = widget.equipmentDTO;
    projList!.forEach((element) {
      var unselectedEq;
      if (!element.isSelected!) {
        unselectedEq = element.equipmentId!;
        returnList!.data!.removeWhere((item) => item.projectId == unselectedEq);
      }
    });
    return returnList;
  }
}
