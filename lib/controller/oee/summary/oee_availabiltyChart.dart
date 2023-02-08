import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:keysight_pma/const/appcolors.dart';
import 'package:keysight_pma/const/appfonts.dart';
import 'package:keysight_pma/const/constants.dart';
import 'package:keysight_pma/const/download.dart';
import 'package:keysight_pma/const/utils.dart';
import 'package:keysight_pma/model/arguments/oee_argument.dart';
import 'package:keysight_pma/model/oee/oeeSummary.dart';
import 'package:keysight_pma/routes/approutes.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';
import '../../../cache/appcache.dart';
import '../../../const/appfonts.dart';
import '../../../dio/api/oee.dart';

class OEEAvailabiltyChart extends StatefulWidget {
  final String selectedCompany;
  final String selectedSite;

  OEEAvailabiltyChart(
      {Key? key, required this.selectedSite, required this.selectedCompany})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _OEEAvailabiltyChart();
  }
}

class _OEEAvailabiltyChart extends State<OEEAvailabiltyChart> {
  String sorting = Constants.SORT_ASCENDING;
  String sortBy = '';
  int sortType = 0;
  bool isLoading = true;
  OeeSummaryDTO listEquipmentOEE = OeeSummaryDTO();
  List<OeeSummaryDataDTO> listEquipmentOEEData = [];
  OeeSummaryDTO dailySiteOEEData = OeeSummaryDTO();
  OeeSummaryDataDTO chartData = OeeSummaryDataDTO();
  late WebViewPlusController oeeWebViewController;
  double chartHeight = 400;

  bool? theme_dark = AppCache.sortFilterCacheDTO!.currentTheme;
  Future<OeeSummaryDTO> getAggregatedOEEbyEquipment(BuildContext context) {
    OeeApi oeeApi = OeeApi(context);
    return oeeApi.getAggregatedOEEbyEquipment(
        widget.selectedCompany,
        widget.selectedSite,
        DateFormat("yyyyMMdd").format(AppCache.sortFilterCacheDTO!.startDate!),
        DateFormat("yyyyMMdd").format(AppCache.sortFilterCacheDTO!.endDate!));
  }

  Future<OeeSummaryDTO> getDailyOEEforSite(BuildContext context) {
    OeeApi oeeApi = OeeApi(context);
    return oeeApi.getDailyOEEforSite(
        widget.selectedCompany,
        widget.selectedSite,
        DateFormat("yyyyMMdd").format(AppCache.sortFilterCacheDTO!.startDate!),
        DateFormat("yyyyMMdd").format(AppCache.sortFilterCacheDTO!.endDate!));
  }

  void sortAnalogCpkList() {
    if (this.listEquipmentOEEData.length > 0) {
      if (this.sortType == Constants.SORT_BY_EQ) {
        this.listEquipmentOEEData.sort((a, b) {
          var oneB = '';
          var oneA = '';
          if (b.equipmentName != null) {
            oneB = b.equipmentName!;
          }
          if (a.companyId != null) {
            oneA = a.equipmentName!;
          }
          if (this.sorting == Constants.SORT_DESCENDING) {
            return oneB.compareTo(oneA);
          }
          return oneA.compareTo(oneB);
        });
      } else if (this.sortType == Constants.SORT_BY_AVAILABLE) {
        List<OeeSummaryDataDTO> lowerList = this
            .listEquipmentOEEData
            .where(
                (element) => Utils.isNotEmpty(element.availability.toString()))
            .toList();
        List<OeeSummaryDataDTO> noLowerList = this
            .listEquipmentOEEData
            .where(
                (element) => !Utils.isNotEmpty(element.availability.toString()))
            .toList();

        this.listEquipmentOEEData.clear();
        if (lowerList.length > 0) {
          lowerList.sort((a, b) {
            if (this.sorting == Constants.SORT_DESCENDING) {
              return b.availability!.compareTo(a.availability!);
            }
            return a.availability!.compareTo(b.availability!);
          });

          if (this.sorting == Constants.SORT_DESCENDING) {
            this.listEquipmentOEEData.addAll(lowerList);
            this.listEquipmentOEEData.addAll(noLowerList);
          } else {
            this.listEquipmentOEEData.addAll(noLowerList);
            this.listEquipmentOEEData.addAll(lowerList);
          }
        } else {
          this.listEquipmentOEEData.addAll(noLowerList);
        }
      } else if (this.sortType == Constants.SORT_BY_PERFORMANCE) {
        List<OeeSummaryDataDTO> SORT_BY_PERFORMANCE = this
            .listEquipmentOEEData
            .where(
                (element) => Utils.isNotEmpty(element.performance.toString()))
            .toList();
        List<OeeSummaryDataDTO> noSORT_BY_PERFORMANCE = this
            .listEquipmentOEEData
            .where(
                (element) => !Utils.isNotEmpty(element.performance.toString()))
            .toList();

        this.listEquipmentOEEData.clear();
        if (SORT_BY_PERFORMANCE.length > 0) {
          SORT_BY_PERFORMANCE.sort((a, b) {
            if (this.sorting == Constants.SORT_DESCENDING) {
              return b.performance!.compareTo(a.performance!);
            }
            return a.performance!.compareTo(b.performance!);
          });

          if (this.sorting == Constants.SORT_DESCENDING) {
            this.listEquipmentOEEData.addAll(SORT_BY_PERFORMANCE);
            this.listEquipmentOEEData.addAll(noSORT_BY_PERFORMANCE);
          } else {
            this.listEquipmentOEEData.addAll(noSORT_BY_PERFORMANCE);
            this.listEquipmentOEEData.addAll(SORT_BY_PERFORMANCE);
          }
        } else {
          this.listEquipmentOEEData.addAll(noSORT_BY_PERFORMANCE);
        }
      } else if (this.sortType == Constants.SORT_BY_QUALITY) {
        List<OeeSummaryDataDTO> SORT_BY_QUALITY = this
            .listEquipmentOEEData
            .where((element) => Utils.isNotEmpty(element.quality.toString()))
            .toList();
        List<OeeSummaryDataDTO> noSORT_BY_QUALITY = this
            .listEquipmentOEEData
            .where((element) => !Utils.isNotEmpty(element.quality.toString()))
            .toList();

        this.listEquipmentOEEData.clear();
        if (SORT_BY_QUALITY.length > 0) {
          SORT_BY_QUALITY.sort((a, b) {
            if (this.sorting == Constants.SORT_DESCENDING) {
              return b.quality!.compareTo(a.quality!);
            }
            return a.quality!.compareTo(b.quality!);
          });

          if (this.sorting == Constants.SORT_DESCENDING) {
            this.listEquipmentOEEData.addAll(SORT_BY_QUALITY);
            this.listEquipmentOEEData.addAll(noSORT_BY_QUALITY);
          } else {
            this.listEquipmentOEEData.addAll(noSORT_BY_QUALITY);
            this.listEquipmentOEEData.addAll(SORT_BY_QUALITY);
          }
        } else {
          this.listEquipmentOEEData.addAll(noSORT_BY_QUALITY);
        }
      } else if (this.sortType == Constants.SORT_BY_OEE) {
        List<OeeSummaryDataDTO> SORT_BY_OEE = this
            .listEquipmentOEEData
            .where((element) => Utils.isNotEmpty(element.oee.toString()))
            .toList();
        List<OeeSummaryDataDTO> noSORT_BY_OEE = this
            .listEquipmentOEEData
            .where((element) => !Utils.isNotEmpty(element.oee.toString()))
            .toList();

        this.listEquipmentOEEData.clear();
        if (SORT_BY_OEE.length > 0) {
          SORT_BY_OEE.sort((a, b) {
            if (this.sorting == Constants.SORT_DESCENDING) {
              return b.oee!.compareTo(a.oee!);
            }
            return a.oee!.compareTo(b.oee!);
          });

          if (this.sorting == Constants.SORT_DESCENDING) {
            this.listEquipmentOEEData.addAll(SORT_BY_OEE);
            this.listEquipmentOEEData.addAll(noSORT_BY_OEE);
          } else {
            this.listEquipmentOEEData.addAll(noSORT_BY_OEE);
            this.listEquipmentOEEData.addAll(SORT_BY_OEE);
          }
        } else {
          this.listEquipmentOEEData.addAll(noSORT_BY_OEE);
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    Utils.setFirebaseAnalyticsCurrentScreen(
        Constants.ANALYTICS_OEE_SUMMARY_SITE_INFO_SCREEN);
    callListSiteOEE(context);
  }

  callListSiteOEE(BuildContext context) async {
    await getAggregatedOEEbyEquipment(context).then((value) {
      listEquipmentOEE = value;
      if (listEquipmentOEE.data != null && listEquipmentOEE.data!.length > 0) {
        this.listEquipmentOEEData = listEquipmentOEE.data!;
      }
//print(listEquipmentOEE);
    }).catchError((error) {
      Utils.printInfo(error);
    });
    await getDailyOEEforSite(context).then((value) {
      dailySiteOEEData = value;
      //print(listEquipmentOEE);
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
        backgroundColor: theme_dark!
            ? AppColors.serverAppBar()
            : AppColorsLightMode.serverAppBar(),
        centerTitle: true,
        title: Padding(
          padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
          child: Text(
            Utils.getTranslated(context, 'oee_site_oee_infomation')!,
            style: AppFonts.robotoRegular(
              20,
              color: theme_dark!
                  ? AppColors.appGrey()
                  : AppColorsLightMode.appPrimaryWhite(),
            ),
          ),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Image.asset(theme_dark!
              ? Constants.ASSET_IMAGES + 'back_bttn.png'
              : Constants.ASSET_IMAGES_LIGHT + 'back_bttn.png'),
        ),
      ),
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.all(16.0),
          child: isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppColors.appBlue()),
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5, top: 27),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                Utils.getTranslated(
                                    context, 'oee_daily_site_oee')!,
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
                                  : Constants.ASSET_IMAGES_LIGHT +
                                      'download_bttn.png'),
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.only(bottom: 5, top: 0),
                        height: this.chartHeight,
                        child: (dailySiteOEEData.data != null &&
                                dailySiteOEEData.data!.length > 0)
                            ? WebViewPlus(
                                backgroundColor: Colors.transparent,
                                javascriptMode: JavascriptMode.unrestricted,
                                initialUrl: theme_dark!
                                    ? 'assets/html/oee_highchart_dark_theme.html'
                                    : 'assets/html/oee_highchart_light_theme.html',
                                zoomEnabled: false,
                                onWebViewCreated: (controllerPlus) {
                                  this.oeeWebViewController = controllerPlus;
                                },
                                onPageFinished: (url) {
                                  this
                                      .oeeWebViewController
                                      .getHeight()
                                      .then((value) {
                                    Utils.printInfo(value);
                                    setState(() {
                                      this.chartHeight = value;
                                    });
                                  });
                                },
                                javascriptChannels: [
                                  JavascriptChannel(
                                      name: 'OEEChannel',
                                      onMessageReceived: (message) {
                                        print(message.message);
                                        this
                                            .oeeWebViewController
                                            .webViewController
                                            .runJavascript(
                                                'fetchSiteDailyOEEInfo(${jsonEncode(this.dailySiteOEEData)}, "${DateFormat("yyyy-MM-dd").format(AppCache.sortFilterCacheDTO!.startDate!)}", "${DateFormat("yyyy-MM-dd").format(AppCache.sortFilterCacheDTO!.endDate!)}","${Utils.getTranslated(context, 'oee_chart_availability')}","${Utils.getTranslated(context, 'oee_chart_perfornance')}","${Utils.getTranslated(context, 'oee_chart_quality')}","${Utils.getTranslated(context, 'oee_chart_oee')}","${Utils.getTranslated(context, 'oee_chart_credit_timestamp/score')}")');
                                      }),
                                  JavascriptChannel(
                                      name: 'OEEClickChannel',
                                      onMessageReceived: (message) {
                                        print(message.message);
                                        setState(() {
                                          chartData =
                                              OeeSummaryDataDTO.fromJson(
                                                  jsonDecode(message.message));
                                          //(chartData.date);
                                        });
                                        showTooltipsDialog(context);
                                      }),
                                  JavascriptChannel(
                                      name: 'DQMExportImageChannel',
                                      onMessageReceived: (message) async {
                                        print(message.message);
                                        if (Utils.isNotEmpty(message.message)) {
                                          String name = 'siteDailyOEE.png';

                                          final result =
                                              await ImageApi.generateImage(
                                                  message.message,
                                                  600,
                                                  this.chartHeight.round(),
                                                  name);
                                          if (result != null &&
                                              result == true) {
                                            setState(() {
                                              // print('################## hihi');
                                              var snackBar = SnackBar(
                                                content: Text(
                                                  Utils.getTranslated(context,
                                                      'done_download_as_image')!,
                                                  style: AppFonts.robotoRegular(
                                                    16,
                                                    color: theme_dark!
                                                        ? AppColors.appGrey()
                                                        : AppColors.appGrey(),
                                                    decoration:
                                                        TextDecoration.none,
                                                  ),
                                                ),
                                                backgroundColor:
                                                    AppColors.appBlack0F(),
                                              );
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(snackBar);
                                            });
                                          }
                                        }
                                      }),
                                  JavascriptChannel(
                                      name: 'DQMExportPDFChannel',
                                      onMessageReceived: (message) async {
                                        if (Utils.isNotEmpty(message.message)) {
                                          String name = 'siteDailyOEE.pdf';

                                          final result =
                                              await PdfApi.generatePDF(
                                                  message.message,
                                                  600,
                                                  this.chartHeight.round(),
                                                  name);
                                          if (result != null &&
                                              result == true) {
                                            setState(() {
                                              // print('################## hihi');
                                              var snackBar = SnackBar(
                                                content: Text(
                                                  Utils.getTranslated(context,
                                                      'done_download_as_pdf')!,
                                                  style: AppFonts.robotoRegular(
                                                    16,
                                                    color: theme_dark!
                                                        ? AppColors.appGrey()
                                                        : AppColors.appGrey(),
                                                    decoration:
                                                        TextDecoration.none,
                                                  ),
                                                ),
                                                backgroundColor:
                                                    AppColors.appBlack0F(),
                                              );
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(snackBar);
                                            });
                                          }
                                        }
                                      }),
                                ].toSet(),
                              )
                            : Center(
                                child: Text(
                                  Utils.getTranslated(
                                      context, 'no_data_available')!,
                                  style: AppFonts.robotoRegular(
                                    16,
                                    color:
                                        AppColors.appGreyB1().withOpacity(0.4),
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                              ),
                      ),
                      Divider(
                        color: theme_dark!
                            ? AppColors.appDividerColor()
                            : AppColorsLightMode.appDividerColor(),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 24, top: 27),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                Utils.getTranslated(
                                    context, 'oee_equipment_oee_info')!,
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
                              onTap: () => showDownloadCsvPopup(context),
                              child: Image.asset(theme_dark!
                                  ? Constants.ASSET_IMAGES + 'download_bttn.png'
                                  : Constants.ASSET_IMAGES_LIGHT +
                                      'download_bttn.png'),
                            )
                          ],
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
                        children: listEquipmentOEEData
                            .map((e) => dataItem(context, e))
                            .toList(),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  void showDownloadCsvPopup(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext downloadContext) => CupertinoActionSheet(
        actions: [
          Container(
            color: theme_dark!
                ? AppColors.cupertinoBackground()
                : AppColorsLightMode.cupertinoBackground().withOpacity(0.8),
            child: CupertinoActionSheetAction(
              onPressed: () async {
                Navigator.pop(downloadContext);

                String name = "equipmentOEEInfo.csv";
                var object = [];
                listEquipmentOEEData.forEach((key) {
                  object.add({
                    "${Utils.getTranslated(context, 'csv_equipment_name')}":
                        key.equipmentName,
                    '${Utils.getTranslated(context, 'oee_chart_availability')}':
                        key.availability,
                    '${Utils.getTranslated(context, 'oee_chart_perfornance')}':
                        key.performance,
                    '${Utils.getTranslated(context, 'oee_chart_quality')}':
                        key.quality,
                    '${Utils.getTranslated(context, 'oee_chart_oee')}': key.oee,
                  });
                });

                final result =
                    await CSVApi.generateCSV(listEquipmentOEEData, name);
                if (result != null && result == true) {
                  setState(() {
                    isLoading = false;
                    // print('################## hihi');
                    var snackBar = SnackBar(
                      content: Text(
                        Utils.getTranslated(context, 'done_download_as_csv')!,
                        style: AppFonts.robotoRegular(
                          16,
                          color: theme_dark!
                              ? AppColors.appGrey()
                              : AppColors.appGrey(),
                          decoration: TextDecoration.none,
                        ),
                      ),
                      backgroundColor: AppColors.appBlack0F(),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  });
                }
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
        ],
        cancelButton: Container(
          decoration: BoxDecoration(
              color: theme_dark!
                  ? AppColors.cupertinoBackground()
                  : AppColorsLightMode.cupertinoBackground(),
              borderRadius: BorderRadius.circular(14)),
          child: CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(downloadContext);
            },
            child: Text(
              Utils.getTranslated(context, 'cancel')!,
              style: AppFonts.robotoMedium(15,
                  color: theme_dark!
                      ? AppColors.appPrimaryWhite()
                      : AppColorsLightMode.appCancelBlue(),
                  decoration: TextDecoration.none),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  void showTooltipsDialog(
    BuildContext ctx,
  ) {
    String date =
        DateFormat.yMMMMEEEEd().format(DateTime.parse(chartData.date!));
    showDialog(
        context: ctx,
        builder: (tooltipsDialogContext) {
          return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              elevation: 0,
              backgroundColor: Colors.transparent,
              child: Container(
                padding: EdgeInsets.fromLTRB(14.0, 12.0, 14.0, 12.0),
                decoration: BoxDecoration(
                  color: AppColors.appBlack2C(),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      date,
                      style: AppFonts.robotoRegular(
                        16,
                        color: theme_dark!
                            ? AppColors.appGrey2()
                            : AppColorsLightMode.appGrey2(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                    SizedBox(height: 14),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Utils.getTranslated(context, 'oee_availability')!,
                            style: AppFonts.robotoRegular(
                              14,
                              color: HexColor("#f5d845"),
                              decoration: TextDecoration.none,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            ':',
                            style: AppFonts.robotoRegular(
                              14,
                              color: theme_dark!
                                  ? AppColors.appGrey2()
                                  : AppColorsLightMode.appGrey2(),
                              decoration: TextDecoration.none,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            chartData.availability!.toString(),
                            style: AppFonts.robotoRegular(
                              14,
                              color: theme_dark!
                                  ? AppColors.appGrey2()
                                  : AppColorsLightMode.appGrey2(),
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ]),
                    SizedBox(height: 14),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Utils.getTranslated(context, 'oee_performance')!,
                            style: AppFonts.robotoRegular(
                              14,
                              color: HexColor("fba30a"),
                              decoration: TextDecoration.none,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            ':',
                            style: AppFonts.robotoRegular(
                              14,
                              color: theme_dark!
                                  ? AppColors.appGrey2()
                                  : AppColorsLightMode.appGrey2(),
                              decoration: TextDecoration.none,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            chartData.performance!.toString(),
                            style: AppFonts.robotoRegular(
                              14,
                              color: theme_dark!
                                  ? AppColors.appGrey2()
                                  : AppColorsLightMode.appGrey2(),
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ]),
                    SizedBox(height: 14),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Utils.getTranslated(context, 'oee_quality')!,
                            style: AppFonts.robotoRegular(
                              14,
                              color: HexColor("f37719"),
                              decoration: TextDecoration.none,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            ':',
                            style: AppFonts.robotoRegular(
                              14,
                              color: theme_dark!
                                  ? AppColors.appGrey2()
                                  : AppColorsLightMode.appGrey2(),
                              decoration: TextDecoration.none,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            chartData.quality!.toString(),
                            style: AppFonts.robotoRegular(
                              14,
                              color: theme_dark!
                                  ? AppColors.appGrey2()
                                  : AppColorsLightMode.appGrey2(),
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ]),
                    SizedBox(height: 14),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "OEE",
                            style: AppFonts.robotoRegular(
                              14,
                              color: HexColor("dc5039"),
                              decoration: TextDecoration.none,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            ':',
                            style: AppFonts.robotoRegular(
                              14,
                              color: theme_dark!
                                  ? AppColors.appGrey2()
                                  : AppColorsLightMode.appGrey2(),
                              decoration: TextDecoration.none,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            chartData.oee!.toString(),
                            style: AppFonts.robotoRegular(
                              14,
                              color: theme_dark!
                                  ? AppColors.appGrey2()
                                  : AppColorsLightMode.appGrey2(),
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ]),
                  ],
                ),
              ));
        });
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
                this
                    .oeeWebViewController
                    .webViewController
                    .runJavascript('exportImage()');
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
              onPressed: () async {
                Navigator.pop(downloadContext);

                String name = "oeeAvailabilityChart.csv";

                var object = [];
                dailySiteOEEData.data!.forEach((key) {
                  object.add({
                    "${Utils.getTranslated(context, 'csv_dateTime')}": key.date,
                    '${Utils.getTranslated(context, 'oee_chart_availability')}':
                        key.availability,
                    '${Utils.getTranslated(context, 'oee_chart_perfornance')}':
                        key.performance,
                    '${Utils.getTranslated(context, 'oee_chart_quality')}':
                        key.quality,
                    '${Utils.getTranslated(context, 'oee_chart_oee')}': key.oee,
                  });
                });
                final result = await CSVApi.generateCSV(object, name);
                if (result != null && result == true) {
                  setState(() {
                    // print('################## hihi');
                    var snackBar = SnackBar(
                      content: Text(
                        Utils.getTranslated(context, 'done_download_as_csv')!,
                        style: AppFonts.robotoRegular(
                          16,
                          color: theme_dark!
                              ? AppColors.appGrey()
                              : AppColors.appGrey(),
                          decoration: TextDecoration.none,
                        ),
                      ),
                      backgroundColor: AppColors.appBlack0F(),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  });
                }
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
                this
                    .oeeWebViewController
                    .webViewController
                    .runJavascript('exportPDF()');
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

  Widget dataItem(BuildContext context, OeeSummaryDataDTO e) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: EdgeInsets.fromLTRB(0, 0, 0, 12),
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
                    height: 18,
                    child: Row(
                      children: [
                        Text(
                          e.equipmentName!,
                          style: AppFonts.robotoRegular(13,
                              color: theme_dark!
                                  ? AppColors.appGrey2()
                                  : AppColorsLightMode.appGrey(),
                              decoration: TextDecoration.none),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.oeeSummaryDailyChart,
                        arguments: OeeChartDetailArguments(
                          chartName: Utils.getTranslated(
                              context, 'oee_daily_equipment_oee')!,
                          selectedCompany: widget.selectedCompany,
                          selectedSite: widget.selectedSite,
                          selectedEquipment: e.equipmentId,
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 18),
                      //width: 119,
                      height: 14,
                      child: Image.asset(theme_dark!
                          ? Constants.ASSET_IMAGES + 'next_bttn.png'
                          : Constants.ASSET_IMAGES_LIGHT + 'next_bttn.png'),
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 15, 37, 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      //color: Colors.amber,
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
                          Text(
                            e.availability!.toString(),
                            textAlign: TextAlign.left,
                            style: AppFonts.robotoMedium(17,
                                color: AppColors.appDarkRed(),
                                decoration: TextDecoration.none),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      //color: Colors.amber,
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
                          Text(
                            e.quality!.toString(),
                            textAlign: TextAlign.left,
                            style: AppFonts.robotoMedium(17,
                                color: AppColors.appDarkRed(),
                                decoration: TextDecoration.none),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      //color: Colors.amber,
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
                          Text(
                            e.performance!.toString(),
                            textAlign: TextAlign.left,
                            style: AppFonts.robotoMedium(17,
                                color: AppColors.appDarkRed(),
                                decoration: TextDecoration.none),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      //color: Colors.amber,
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
                          Text(
                            e.oee!.toString(),
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
    if (this.listEquipmentOEEData.length > 0) {
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
