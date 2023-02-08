import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:keysight_pma/cache/appcache.dart';
import 'package:keysight_pma/const/appcolors.dart';
import 'package:keysight_pma/const/appfonts.dart';
import 'package:keysight_pma/const/constants.dart';
import 'package:keysight_pma/const/utils.dart';
import 'package:keysight_pma/controller/admin/preferred_setting/custom.dart';
import 'package:keysight_pma/model/arguments/oee_argument.dart';
import 'package:keysight_pma/model/dqm/custom.dart';
import 'package:keysight_pma/routes/approutes.dart';

class OEESitePerformanceMetric extends StatefulWidget {
  OEESitePerformanceMetric({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _OEESitePerformanceMetric();
  }
}

class _OEESitePerformanceMetric extends State<OEESitePerformanceMetric> {
  List<PDate> siteAxisRangeList = [
    PDate(
      rangeName: '0.00% Availability',
      rangeValue: '0.00% Availability',
      isSelected: false,
      route: AppRoutes.oeeSummarySiteAvailabiltyMetric,
    ),
    PDate(
      rangeName: '0.00% Quality',
      rangeValue: '0.00% Quality',
      isSelected: false,
      route: AppRoutes.oeeSummarySiteQualityMetric,
    ),
    PDate(
      rangeName: '0.00% Performance',
      rangeValue: '0.00% Performance',
      isSelected: true,
      route: AppRoutes.oeeSummarySitePerformanceMetric,
    ),
    PDate(
      rangeName: '0.00% OEE',
      rangeValue: '0.00% OEE',
      isSelected: false,
    ),
  ];
  List<DqmXaxisRangeDTO> oeeAxisRangeList = [
    DqmXaxisRangeDTO(rangeName: '1M', rangeValue: '1M', isSelected: false),
    DqmXaxisRangeDTO(rangeName: '3M', rangeValue: '3M', isSelected: false),
    DqmXaxisRangeDTO(rangeName: '6M', rangeValue: '6M', isSelected: false),
    DqmXaxisRangeDTO(rangeName: 'YTD', rangeValue: 'YTD', isSelected: false),
    DqmXaxisRangeDTO(rangeName: '1Y', rangeValue: '1Y', isSelected: false),
    DqmXaxisRangeDTO(rangeName: 'ALL', rangeValue: 'ALL', isSelected: false),
  ];
  bool? theme_dark = AppCache.sortFilterCacheDTO!.currentTheme;
  @override
  void initState() {
    super.initState();
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Image.asset(
            theme_dark!
                ? Constants.ASSET_IMAGES + 'back_bttn.png'
                : Constants.ASSET_IMAGES_LIGHT + 'back_bttn.png',
          ),
        ),
        centerTitle: true,
        title: Text(
          Utils.getTranslated(context, 'oee_site_performance_metric')!,
          style: AppFonts.robotoRegular(
            20,
            color: theme_dark!
                ? AppColors.appGrey()
                : AppColorsLightMode.appGrey(),
            decoration: TextDecoration.none,
          ),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              header(context),
              siteAvailabilityMetricRangeSelection(context),
              siteAvailabilityMetricChart(context),
              retestpassfail(context),
              firstpass(context),
              idealcycle(context),
              performance(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget header(BuildContext ctx) {
    return Container(
      width: MediaQuery.of(ctx).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Utils.getTranslated(ctx, 'this_week')!,
            style: AppFonts.robotoMedium(
              14,
              color: AppColors.appPrimaryWhite(),
              decoration: TextDecoration.none,
            ),
          ),
          SizedBox(height: 17.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              headerItem(
                  ctx,
                  '24',
                  Utils.getTranslated(ctx, 'dqm_summary_component_anomaly')!,
                  AppColors.appDarkRed()),
              SizedBox(width: 20.0),
              headerItem(
                  ctx,
                  '0',
                  Utils.getTranslated(ctx, 'dqm_summary_degradation_anomaly')!,
                  AppColors.appIvoryWhite()),
            ],
          ),
          SizedBox(height: 17.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              headerItem(
                  ctx,
                  '200',
                  Utils.getTranslated(ctx, 'dqm_summary_limit_change')!,
                  AppColors.appYellowLight()),
              SizedBox(width: 20.0),
              headerItem(
                  ctx,
                  '2',
                  Utils.getTranslated(ctx, 'dqm_summary_low_cpk')!,
                  AppColors.appYellowLight()),
            ],
          )
        ],
      ),
    );
  }

  Widget headerItem(
      BuildContext ctx, String value, String label, Color bgColor) {
    return Expanded(
      child: Container(
        height: 65.0,
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              value,
              style: AppFonts.robotoBold(
                23,
                color: Colors.black,
                decoration: TextDecoration.none,
              ),
            ),
            Text(
              label,
              style: AppFonts.robotoRegular(
                12,
                color: Colors.black,
                decoration: TextDecoration.none,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget siteAvailabilityMetricRangeSelection(BuildContext ctx) {
    return Container(
      margin: EdgeInsets.only(top: 34.0),
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
                  Utils.getTranslated(ctx, 'yesterday')!,
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
          Container(
            margin: EdgeInsets.only(top: 17.0),
            height: 40.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: siteAxisRangeList.length,
              itemBuilder: (BuildContext listContext, int index) {
                return rangeItem2(listContext, siteAxisRangeList[index], index,
                    siteAxisRangeList.length);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget siteAvailabilityMetricChart(BuildContext ctx) {
    return Container(
      margin: EdgeInsets.only(top: 34.0),
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
                  Utils.getTranslated(ctx, 'oee_site_performance_metric')!,
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
                onTap: () {
                  showDownloadPopup(context);
                },
                child: Image.asset(theme_dark!
                    ? Constants.ASSET_IMAGES + 'download_bttn.png'
                    : Constants.ASSET_IMAGES_LIGHT + 'download_bttn.png'),
              )
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 39.0),
            height: 30.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: oeeAxisRangeList.length,
              itemBuilder: (BuildContext listContext, int index) {
                return rangeItem(listContext, oeeAxisRangeList[index], index);
              },
            ),
          ),
        ],
      ),
    );
  }

  void showDownloadPopup(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext downloadContext) => CupertinoActionSheet(
        actions: [
          Container(
            color: theme_dark!
                ? AppColors.cupertinoBackground()
                : AppColorsLightMode.cupertinoBackground().withOpacity(0.8),
            child: CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(downloadContext);
              },
              child: Text(
                Utils.getTranslated(context, 'download_as_image')!,
                style: AppFonts.robotoRegular(
                  15,
                  color: theme_dark!
                      ? AppColors.appPrimaryWhite().withOpacity(0.8)
                      : AppColorsLightMode.appGrey(),
                  decoration: TextDecoration.none,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Container(
            color: theme_dark!
                ? AppColors.cupertinoBackground()
                : AppColorsLightMode.cupertinoBackground().withOpacity(0.8),
            child: CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(downloadContext);
              },
              child: Text(
                Utils.getTranslated(context, 'download_as_csv')!,
                style: AppFonts.robotoRegular(
                  15,
                  color: theme_dark!
                      ? AppColors.appPrimaryWhite().withOpacity(0.8)
                      : AppColorsLightMode.appGrey(),
                  decoration: TextDecoration.none,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Container(
            color: theme_dark!
                ? AppColors.cupertinoBackground()
                : AppColorsLightMode.cupertinoBackground().withOpacity(0.8),
            child: CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(downloadContext);
              },
              child: Text(
                Utils.getTranslated(context, 'download_as_pdf')!,
                style: AppFonts.robotoRegular(
                  15,
                  color: theme_dark!
                      ? AppColors.appPrimaryWhite().withOpacity(0.8)
                      : AppColorsLightMode.appGrey(),
                  decoration: TextDecoration.none,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
        cancelButton: Container(
          decoration: BoxDecoration(
            color: theme_dark!
                ? AppColors.cupertinoBackground()
                : AppColorsLightMode.cupertinoBackground().withOpacity(0.8),
            borderRadius: BorderRadius.circular(10),
          ),
          child: CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(downloadContext);
            },
            child: Text(
              Utils.getTranslated(context, 'cancel')!,
              style: AppFonts.robotoMedium(
                15,
                color: theme_dark!
                    ? AppColors.appPrimaryWhite().withOpacity(0.8)
                    : AppColorsLightMode.appCancelBlue(),
                decoration: TextDecoration.none,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  Widget rangeItem(
      BuildContext ctx, DqmXaxisRangeDTO dqmXaxisRangeDTO, int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            oeeAxisRangeList.forEach((element) {
              element.isSelected = false;
            });
            setState(() {
              dqmXaxisRangeDTO.isSelected = true;
            });
          },
          child: Container(
            width: 60.0,
            padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
            decoration: BoxDecoration(
              color: dqmXaxisRangeDTO.isSelected!
                  ? AppColors.appPrimaryYellow()
                  : Colors.transparent,
              border: dqmXaxisRangeDTO.isSelected!
                  ? Border.all(color: Colors.transparent)
                  : Border.all(color: AppColors.appMediumGrey()),
              borderRadius: BorderRadius.circular(50.0),
            ),
            child: Center(
              child: Text(
                dqmXaxisRangeDTO.rangeName!,
                style: AppFonts.sfproBold(
                  11,
                  color: dqmXaxisRangeDTO.isSelected!
                      ? AppColors.appPrimaryWhite()
                      : AppColors.appMediumGrey(),
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          ),
        ),
        index < oeeAxisRangeList.length ? SizedBox(width: 16.0) : Container(),
      ],
    );
  }

  Widget rangeItem2(
      BuildContext ctx, PDate siteAxisRangeList, int index, int length) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            (siteAxisRangeList.route) != null
                ? Navigator.pushNamed(ctx, siteAxisRangeList.route!)
                : Navigator.pushNamed(
                    ctx,
                    AppRoutes.oeeHomeBase,
                    arguments: OeeChartDetailArguments(currentTab: 1),
                  );
          },
          child: Container(
            padding: EdgeInsets.fromLTRB(22.0, 0, 22.0, 0),
            decoration: BoxDecoration(
              color: siteAxisRangeList.isSelected!
                  ? AppColors.appPrimaryWhite()
                  : Colors.transparent,
              border: siteAxisRangeList.isSelected!
                  ? Border.all(color: Colors.transparent)
                  : Border.all(color: AppColors.appMediumGrey()),
              borderRadius: BorderRadius.circular(50.0),
            ),
            child: Center(
              child: Text(
                siteAxisRangeList.rangeName!,
                style: AppFonts.sfproBold(
                  11,
                  color: siteAxisRangeList.isSelected!
                      ? AppColors.appPrimaryBlack()
                      : AppColors.appMediumGrey(),
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          ),
        ),
        index < length ? SizedBox(width: 16.0) : Container(),
      ],
    );
  }

  Widget retestpassfail(BuildContext ctx) {
    return Container(
      margin: EdgeInsets.only(top: 37.0),
      height: 350.0,
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
                  Utils.getTranslated(ctx, 'oee_firstpassyield')!,
                  style: AppFonts.robotoMedium(
                    14,
                    color: AppColors.appPrimaryWhite(),
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
              InkWell(
                onTap: () {},
                child: Image.asset(
                    Constants.ASSET_IMAGES + 'next_bttn_withbg.png'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget firstpass(BuildContext ctx) {
    return Container(
      margin: EdgeInsets.only(top: 37.0),
      height: 350.0,
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
                  Utils.getTranslated(ctx, 'oee_firstpass')!,
                  style: AppFonts.robotoMedium(
                    14,
                    color: AppColors.appPrimaryWhite(),
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
              InkWell(
                onTap: () {},
                child: Image.asset(
                    Constants.ASSET_IMAGES + 'next_bttn_withbg.png'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget idealcycle(BuildContext ctx) {
    return Container(
      margin: EdgeInsets.only(top: 37.0),
      height: 350.0,
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
                  Utils.getTranslated(ctx, 'oee_idealcycle')!,
                  style: AppFonts.robotoMedium(
                    14,
                    color: AppColors.appPrimaryWhite(),
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
              InkWell(
                onTap: () {},
                child: Image.asset(
                    Constants.ASSET_IMAGES + 'next_bttn_withbg.png'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget performance(BuildContext ctx) {
    return Container(
      margin: EdgeInsets.only(top: 37.0),
      height: 350.0,
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
                  Utils.getTranslated(ctx, 'oee_performance')!,
                  style: AppFonts.robotoMedium(
                    14,
                    color: AppColors.appPrimaryWhite(),
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
              InkWell(
                onTap: () {},
                child: Image.asset(
                    Constants.ASSET_IMAGES + 'next_bttn_withbg.png'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
