import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:keysight_pma/cache/appcache.dart';
import 'package:keysight_pma/const/appcolors.dart';
import 'package:keysight_pma/const/constants.dart';
import 'package:keysight_pma/const/utils.dart';
import 'package:keysight_pma/controller/admin/preferred_setting/custom.dart';
import 'package:keysight_pma/model/arguments/oee_argument.dart';
import 'package:keysight_pma/model/arguments/sort_filter_argument.dart';
import 'package:keysight_pma/model/oee/oeeSummary.dart';
import 'package:keysight_pma/routes/approutes.dart';

import '../../../const/appfonts.dart';
import '../../../dio/api/oee.dart';

class OeeSummaryScreen extends StatefulWidget {
  const OeeSummaryScreen({Key? key}) : super(key: key);

  @override
  State<OeeSummaryScreen> createState() => _OeeSummaryScreenState();
}

class _OeeSummaryScreenState extends State<OeeSummaryScreen> {
  bool isLoading = true;
  OeeSummaryDTO listSiteOEEInfo = OeeSummaryDTO();
  List<OeeSummaryDataDTO> listSiteOEEInfoData = [];
  Future<OeeSummaryDTO> getAggregatedOEEbySite(BuildContext context) {
    OeeApi oeeApi = OeeApi(context);
    return oeeApi.getAggregatedOEEbySite(
        DateFormat("yyyyMMdd").format(AppCache.sortFilterCacheDTO!.startDate!),
        DateFormat("yyyyMMdd").format(AppCache.sortFilterCacheDTO!.endDate!));
  }

  bool? theme_dark = AppCache.sortFilterCacheDTO!.currentTheme;
  String sorting = Constants.SORT_ASCENDING;
  String sortBy = '';
  int sortType = 0;

  void sortAnalogCpkList() {
    if (this.listSiteOEEInfoData.length > 0) {
      if (this.sortType == Constants.SORT_BY_COMPANY) {
        this.listSiteOEEInfoData.sort((a, b) {
          var oneB = '';
          var oneA = '';
          if (b.companyId != null) {
            oneB = b.companyName!;
          }
          if (a.companyId != null) {
            oneA = a.companyName!;
          }
          if (this.sorting == Constants.SORT_DESCENDING) {
            return oneB.compareTo(oneA);
          }
          return oneA.compareTo(oneB);
        });
      } else if (this.sortType == Constants.SORT_BY_SITE) {
        this.listSiteOEEInfoData.sort((a, b) {
          var twoB = '';
          var twoA = '';
          if (b.siteName != null) {
            twoB = b.siteName!;
          }
          if (a.siteName != null) {
            twoA = a.siteName!;
          }
          if (this.sorting == Constants.SORT_DESCENDING) {
            return twoB.compareTo(twoA);
          }
          return twoA.compareTo(twoB);
        });
      } else if (this.sortType == Constants.SORT_BY_AVAILABLE) {
        List<OeeSummaryDataDTO> lowerList = this
            .listSiteOEEInfoData
            .where(
                (element) => Utils.isNotEmpty(element.availability.toString()))
            .toList();
        List<OeeSummaryDataDTO> noLowerList = this
            .listSiteOEEInfoData
            .where(
                (element) => !Utils.isNotEmpty(element.availability.toString()))
            .toList();

        this.listSiteOEEInfoData.clear();
        if (lowerList.length > 0) {
          lowerList.sort((a, b) {
            if (this.sorting == Constants.SORT_DESCENDING) {
              return b.availability!.compareTo(a.availability!);
            }
            return a.availability!.compareTo(b.availability!);
          });

          if (this.sorting == Constants.SORT_DESCENDING) {
            this.listSiteOEEInfoData.addAll(lowerList);
            this.listSiteOEEInfoData.addAll(noLowerList);
          } else {
            this.listSiteOEEInfoData.addAll(noLowerList);
            this.listSiteOEEInfoData.addAll(lowerList);
          }
        } else {
          this.listSiteOEEInfoData.addAll(noLowerList);
        }
      } else if (this.sortType == Constants.SORT_BY_PERFORMANCE) {
        List<OeeSummaryDataDTO> SORTBYPERFORMANCE = this
            .listSiteOEEInfoData
            .where(
                (element) => Utils.isNotEmpty(element.performance.toString()))
            .toList();
        List<OeeSummaryDataDTO> noSORTBYPERFORMANCE = this
            .listSiteOEEInfoData
            .where(
                (element) => !Utils.isNotEmpty(element.performance.toString()))
            .toList();

        this.listSiteOEEInfoData.clear();
        if (SORTBYPERFORMANCE.length > 0) {
          SORTBYPERFORMANCE.sort((a, b) {
            if (this.sorting == Constants.SORT_DESCENDING) {
              return b.performance!.compareTo(a.performance!);
            }
            return a.performance!.compareTo(b.performance!);
          });

          if (this.sorting == Constants.SORT_DESCENDING) {
            this.listSiteOEEInfoData.addAll(SORTBYPERFORMANCE);
            this.listSiteOEEInfoData.addAll(noSORTBYPERFORMANCE);
          } else {
            this.listSiteOEEInfoData.addAll(noSORTBYPERFORMANCE);
            this.listSiteOEEInfoData.addAll(SORTBYPERFORMANCE);
          }
        } else {
          this.listSiteOEEInfoData.addAll(noSORTBYPERFORMANCE);
        }
      } else if (this.sortType == Constants.SORT_BY_QUALITY) {
        print('QUALITY SORTING');
        List<OeeSummaryDataDTO> SORT_BY_QUALITY = this
            .listSiteOEEInfoData
            .where((element) => Utils.isNotEmpty(element.quality.toString()))
            .toList();
        List<OeeSummaryDataDTO> noSORT_BY_QUALITY = this
            .listSiteOEEInfoData
            .where((element) => !Utils.isNotEmpty(element.quality.toString()))
            .toList();

        this.listSiteOEEInfoData.clear();
        if (SORT_BY_QUALITY.length > 0) {
          SORT_BY_QUALITY.sort((a, b) {
            num value1 = a.quality!;
            num value2 = b.quality!;
            if (this.sorting == Constants.SORT_DESCENDING) {
              return value2.compareTo(value1);
            }
            return value1.compareTo(value2);
          });

          if (this.sorting == Constants.SORT_DESCENDING) {
            this.listSiteOEEInfoData.addAll(SORT_BY_QUALITY);
            this.listSiteOEEInfoData.addAll(noSORT_BY_QUALITY);
          } else {
            this.listSiteOEEInfoData.addAll(noSORT_BY_QUALITY);
            this.listSiteOEEInfoData.addAll(SORT_BY_QUALITY);
          }
        } else {
          this.listSiteOEEInfoData.addAll(noSORT_BY_QUALITY);
        }
      } else if (this.sortType == Constants.SORT_BY_OEE) {
        List<OeeSummaryDataDTO> SORT_BY_OEE = this
            .listSiteOEEInfoData
            .where((element) => Utils.isNotEmpty(element.oee.toString()))
            .toList();
        List<OeeSummaryDataDTO> noSORT_BY_OEE = this
            .listSiteOEEInfoData
            .where((element) => !Utils.isNotEmpty(element.oee.toString()))
            .toList();

        this.listSiteOEEInfoData.clear();
        if (SORT_BY_OEE.length > 0) {
          SORT_BY_OEE.sort((a, b) {
            if (this.sorting == Constants.SORT_DESCENDING) {
              return b.oee!.compareTo(a.oee!);
            }
            return a.oee!.compareTo(b.oee!);
          });

          if (this.sorting == Constants.SORT_DESCENDING) {
            this.listSiteOEEInfoData.addAll(SORT_BY_OEE);
            this.listSiteOEEInfoData.addAll(noSORT_BY_OEE);
          } else {
            this.listSiteOEEInfoData.addAll(noSORT_BY_OEE);
            this.listSiteOEEInfoData.addAll(SORT_BY_OEE);
          }
        } else {
          this.listSiteOEEInfoData.addAll(noSORT_BY_OEE);
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    Utils.setFirebaseAnalyticsCurrentScreen(
        Constants.ANALYTICS_OEE_SUMMARY_SCREEN);
    callListSiteOEE(context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  callListSiteOEE(BuildContext context) async {
    await getAggregatedOEEbySite(context).then((value) {
      listSiteOEEInfo = value;
      print(listSiteOEEInfo);
      if (listSiteOEEInfo.data != null && listSiteOEEInfo.data!.length > 0) {
        this.listSiteOEEInfoData = listSiteOEEInfo.data!;
      }
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
      body: SafeArea(
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(AppColors.appBlue()),
                ),
              )
            : Stack(
                children: [
                  Container(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.fromLTRB(16, 30, 16, 20),
                              child: Text(
                                Utils.getTranslated(
                                    context, 'oee_site_oee_infomation')!,
                                style: AppFonts.robotoRegular(16,
                                    color: theme_dark!
                                        ? AppColors.appGrey2()
                                        : AppColorsLightMode.appGrey(),
                                    decoration: TextDecoration.none),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 16),
                              child: analogSorting(context),
                            ),
                            SizedBox(
                              height: 26,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: listSiteOEEInfoData
                                  .map((e) => dataItem(context, e))
                                  .toList(),
                            ),
                          ]),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: TextButton(
                      onPressed: () async {
                        final result = await Navigator.pushNamed(
                          context,
                          AppRoutes.sortAndFilterRoute,
                          arguments: SortFilterArguments(
                            menuType: Constants.HOME_MENU_OEE,
                            currentTab: 1,
                          ),
                        );

                        if (result != null && result as bool) {
                          setState(() {
                            isLoading = true;
                            callListSiteOEE(context);
                          });
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50.0),
                          color: AppColors.appTeal(),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                                Constants.ASSET_IMAGES + 'filter_icon.png'),
                            SizedBox(width: 10.0),
                            Text(
                              Utils.getTranslated(context, 'sort_and_filter')!,
                              style: AppFonts.robotoMedium(
                                14,
                                color: AppColors.appPrimaryWhite(),
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget dataItem(BuildContext context, OeeSummaryDataDTO e) {
    String title = e.companyName! + ' | ' + e.siteName!;
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: EdgeInsets.fromLTRB(16, 0, 16, 12),
        padding: EdgeInsets.only(top: 10, left: 12, bottom: 10),
        color: theme_dark!
            ? AppColors.appBlackLight()
            : AppColorsLightMode.appGreyED(),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    //width: 119,
                    padding: EdgeInsets.only(right: 20),
                    width: 303,
                    child: Text(
                      title,
                      style: AppFonts.robotoRegular(13,
                          color: theme_dark!
                              ? AppColors.appGrey2()
                              : AppColorsLightMode.appGrey(),
                          decoration: TextDecoration.none),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.oeeSummaryAvailabiltyChart,
                        arguments: OeeChartDetailArguments(
                            selectedCompany: e.companyId,
                            selectedSite: e.siteId),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 16),
                      //width: 119,
                      height: 14,
                      child: Image.asset(
                        theme_dark!
                            ? Constants.ASSET_IMAGES + 'next_bttn.png'
                            : Constants.ASSET_IMAGES_LIGHT + 'next_bttn.png',
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 15, 37, 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.oeeSummarySiteAvailabiltyMetric,
                          arguments: OeeChartDetailArguments(
                              chartName: Utils.getTranslated(
                                  context, 'oee_site_availability_metric')!,
                              currentTab: 0,
                              selectedCompany: e.companyId,
                              selectedSite: e.siteId),
                        );
                      },
                      child: Container(
                        color: Colors.transparent,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Utils.getTranslated(
                                  context, 'oee_chart_availability')!,
                              style: AppFonts.robotoRegular(13,
                                  color: theme_dark!
                                      ? AppColors.appGreyB1()
                                      : AppColorsLightMode.appGrey(),
                                  decoration: TextDecoration.none),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Text(
                                  e.availability!.toStringAsFixed(2),
                                  textAlign: TextAlign.left,
                                  style: AppFonts.robotoMedium(17,
                                      color: AppColors.appDarkRed(),
                                      decoration: TextDecoration.none),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Image.asset(
                                  theme_dark!
                                      ? Constants.ASSET_IMAGES +
                                          'oee_info_button.png'
                                      : Constants.ASSET_IMAGES_LIGHT +
                                          'oee_info_bttn.png',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.oeeSummarySiteAvailabiltyMetric,
                          arguments: OeeChartDetailArguments(
                              chartName: Utils.getTranslated(
                                  context, 'oee_site_availability_metric')!,
                              currentTab: 1,
                              selectedCompany: e.companyId,
                              selectedSite: e.siteId),
                        );
                      },
                      child: Container(
                        color: Colors.transparent,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Utils.getTranslated(context, 'oee_quality')!,
                              style: AppFonts.robotoRegular(13,
                                  color: theme_dark!
                                      ? AppColors.appGreyB1()
                                      : AppColorsLightMode.appGrey(),
                                  decoration: TextDecoration.none),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Text(
                                  e.quality!.toStringAsFixed(2),
                                  textAlign: TextAlign.left,
                                  style: AppFonts.robotoMedium(17,
                                      color: AppColors.appDarkRed(),
                                      decoration: TextDecoration.none),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Image.asset(
                                  theme_dark!
                                      ? Constants.ASSET_IMAGES +
                                          'oee_info_button.png'
                                      : Constants.ASSET_IMAGES_LIGHT +
                                          'oee_info_bttn.png',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.oeeSummarySiteAvailabiltyMetric,
                          arguments: OeeChartDetailArguments(
                              chartName: Utils.getTranslated(
                                  context, 'oee_site_availability_metric')!,
                              currentTab: 2,
                              selectedCompany: e.companyId,
                              selectedSite: e.siteId),
                        );
                      },
                      child: Container(
                        color: Colors.transparent,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Utils.getTranslated(context, 'oee_performance')!,
                              style: AppFonts.robotoRegular(13,
                                  color: theme_dark!
                                      ? AppColors.appGreyB1()
                                      : AppColorsLightMode.appGrey(),
                                  decoration: TextDecoration.none),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Text(
                                  e.performance!.toStringAsFixed(2),
                                  textAlign: TextAlign.left,
                                  style: AppFonts.robotoMedium(17,
                                      color: AppColors.appDarkRed(),
                                      decoration: TextDecoration.none),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Image.asset(
                                  theme_dark!
                                      ? Constants.ASSET_IMAGES +
                                          'oee_info_button.png'
                                      : Constants.ASSET_IMAGES_LIGHT +
                                          'oee_info_bttn.png',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.transparent,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Utils.getTranslated(context, 'oee_chart_oee')!,
                            style: AppFonts.robotoRegular(13,
                                color: theme_dark!
                                    ? AppColors.appGreyB1()
                                    : AppColorsLightMode.appGrey(),
                                decoration: TextDecoration.none),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            e.oee!.toStringAsFixed(2),
                            textAlign: TextAlign.left,
                            style: AppFonts.robotoMedium(17,
                                color: AppColors.appDarkRed(),
                                decoration: TextDecoration.none),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ]),
      ),
    );
  }

  Widget analogSorting(BuildContext ctx) {
    if (this.listSiteOEEInfoData.length > 0) {
      return Container(
        margin: EdgeInsets.only(top: 26.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                showSortMenuPopup(ctx);
              },
              child: Container(
                padding: EdgeInsets.fromLTRB(20.0, 7.0, 20.0, 7.0),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(
                    color: theme_dark!
                        ? AppColors.appPrimaryWhite()
                        : AppColorsLightMode.appTeal(),
                  ),
                  borderRadius: BorderRadius.circular(50.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      Utils.getTranslated(ctx, 'sort_by')! + ' $sortBy',
                      style: AppFonts.robotoMedium(
                        14,
                        color: theme_dark!
                            ? AppColors.appPrimaryWhite()
                            : AppColorsLightMode.appTeal(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                    SizedBox(width: 10.0),
                    Image.asset(
                      theme_dark!
                          ? Constants.ASSET_IMAGES + 'dropdown_icon.png'
                          : Constants.ASSET_IMAGES_LIGHT + 'dropdown.png',
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 12.0),
            sortBy.length > 0
                ? GestureDetector(
                    onTap: () {
                      showSortAscOrDscPopup(ctx);
                    },
                    child: Container(
                      padding: EdgeInsets.fromLTRB(20.0, 7.0, 20.0, 7.0),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(
                          color: theme_dark!
                              ? AppColors.appPrimaryWhite()
                              : AppColorsLightMode.appTeal(),
                        ),
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            sorting.length > 0
                                ? Utils.getTranslated(ctx, sorting)!
                                : 'Please select',
                            style: AppFonts.robotoMedium(
                              14,
                              color: theme_dark!
                                  ? AppColors.appPrimaryWhite()
                                  : AppColorsLightMode.appTeal(),
                              decoration: TextDecoration.none,
                            ),
                          ),
                          SizedBox(width: 10.0),
                          Image.asset(
                            theme_dark!
                                ? Constants.ASSET_IMAGES + 'dropdown_icon.png'
                                : Constants.ASSET_IMAGES_LIGHT + 'dropdown.png',
                          ),
                        ],
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      );
    }

    return Container();
  }

  void showSortMenuPopup(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext popContext) => CupertinoActionSheet(
        actions: [
          Container(
            color: theme_dark!
                ? AppColors.cupertinoBackground()
                : AppColorsLightMode.cupertinoBackground().withOpacity(0.8),
            child: CupertinoActionSheetAction(
              onPressed: () {
                setState(() {
                  sortBy = Utils.getTranslated(context, 'alert_company')!;
                  this.sortType = Constants.SORT_BY_COMPANY;
                  sortAnalogCpkList();
                });
                Navigator.pop(popContext);
              },
              child: Text(
                Utils.getTranslated(context, 'alert_company')!,
                // Utils.getTranslated(
                //     context, 'dqm_testresult_analog_sortby_indicator')!,
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
                setState(() {
                  sortBy = Utils.getTranslated(context, 'alert_site')!;
                  // Utils.getTranslated(
                  //     context, 'dqm_testresult_analog_sortby_type')!;
                  this.sortType = Constants.SORT_BY_SITE;
                  sortAnalogCpkList();
                });
                Navigator.pop(popContext);
              },
              child: Text(
                Utils.getTranslated(
                    context, 'alert_site')!, // Utils.getTranslated(
                //     context, 'dqm_testresult_analog_sortby_type')!,
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
                setState(() {
                  sortBy =
                      Utils.getTranslated(context, 'oee_chart_availability')!;

                  // Utils.getTranslated(
                  //     context, 'dqm_testresult_analog_sortby_testname')!;
                  this.sortType = Constants.SORT_BY_AVAILABLE;
                  sortAnalogCpkList();
                });
                Navigator.pop(popContext);
              },
              child: Text(
                Utils.getTranslated(context, 'oee_chart_availability')!,
                // Utils.getTranslated(
                //     context, 'dqm_testresult_analog_sortby_testname')!,
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
                setState(() {
                  sortBy = Utils.getTranslated(context, 'oee_performance')!;
                  // Utils.getTranslated(
                  //     context, 'dqm_testresult_analog_sortby_cpk')!;
                  this.sortType = Constants.SORT_BY_PERFORMANCE;
                  sortAnalogCpkList();
                });
                Navigator.pop(popContext);
              },
              child: Text(
                Utils.getTranslated(context, 'oee_performance')!,
                // Utils.getTranslated(
                //     context, 'dqm_testresult_analog_sortby_cpk')!,
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
                setState(() {
                  sortBy = Utils.getTranslated(context, 'oee_quality')!;
                  this.sortType = Constants.SORT_BY_QUALITY;
                  sortAnalogCpkList();
                });
                Navigator.pop(popContext);
              },
              child: Text(
                Utils.getTranslated(context, 'oee_quality')!,
                // Utils.getTranslated(
                //     context, 'dqm_testresult_analog_sortby_nominal')!,
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
                setState(() {
                  sortBy = Utils.getTranslated(context, 'oee_oee')!;
                  // Utils.getTranslated(
                  //     context, 'dqm_testresult_analog_sortby_lower_limit')!;
                  this.sortType = Constants.SORT_BY_OEE;
                  sortAnalogCpkList();
                });
                Navigator.pop(popContext);
              },
              child: Text(
                Utils.getTranslated(
                    context, 'oee_oee')!, // Utils.getTranslated(
                //     context, 'dqm_testresult_analog_sortby_lower_limit')!,
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
              Navigator.pop(popContext);
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

  void showSortAscOrDscPopup(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext popContext) => CupertinoActionSheet(
        actions: [
          Container(
            color: theme_dark!
                ? AppColors.cupertinoBackground()
                : AppColorsLightMode.cupertinoBackground().withOpacity(0.8),
            child: CupertinoActionSheetAction(
              onPressed: () {
                setState(() {
                  sorting = Constants.SORT_ASCENDING;
                  sortAnalogCpkList();
                });
                Navigator.pop(popContext);
              },
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      Utils.getTranslated(context, 'ascending')!,
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
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      margin: EdgeInsets.only(right: 70.0),
                      child: sorting.length > 0 &&
                              sorting == Constants.SORT_ASCENDING
                          ? Image.asset(
                              Constants.ASSET_IMAGES + 'tick_icon.png')
                          : Container(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            color: theme_dark!
                ? AppColors.cupertinoBackground()
                : AppColorsLightMode.cupertinoBackground().withOpacity(0.8),
            child: CupertinoActionSheetAction(
              onPressed: () {
                setState(() {
                  sorting = Constants.SORT_DESCENDING;
                  sortAnalogCpkList();
                });
                Navigator.pop(popContext);
              },
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      Utils.getTranslated(context, 'descending')!,
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
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      margin: EdgeInsets.only(right: 70.0),
                      child: sorting.length > 0 &&
                              sorting == Constants.SORT_DESCENDING
                          ? Image.asset(
                              Constants.ASSET_IMAGES + 'tick_icon.png')
                          : Container(),
                    ),
                  ),
                ],
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
              Navigator.pop(popContext);
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
}
