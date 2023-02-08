import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:keysight_pma/cache/appcache.dart';
import 'package:keysight_pma/const/appcolors.dart';
import 'package:keysight_pma/const/appfonts.dart';
import 'package:keysight_pma/const/constants.dart';
import 'package:keysight_pma/const/utils.dart';
import 'package:keysight_pma/dio/api/alert.dart';
import 'package:keysight_pma/model/alert/alert_cpk.dart';
import 'package:keysight_pma/model/alert/alert_review_data.dart';
import 'package:keysight_pma/model/alert/alert_statistics.dart';
import 'package:keysight_pma/model/arguments/alert_routeTitle.dart';
import 'package:keysight_pma/model/customize.dart';
import 'package:keysight_pma/routes/approutes.dart';

import '../../const/download.dart';

class AlertCPKList extends StatefulWidget {
  final AlertListDataDTO? alertListDataDTO;
  final AlertStatisticsDataDTO? alertStatisticsDataDTO;
  const AlertCPKList(
      {Key? key, this.alertListDataDTO, this.alertStatisticsDataDTO})
      : super(key: key);

  @override
  State<AlertCPKList> createState() => _AlertCPKListState();
}

class _AlertCPKListState extends State<AlertCPKList> {
  String sorting = Constants.SORT_ASCENDING;
  String sortBy = '';
  int sortType = 0;
  bool isLoading = true;
  bool? theme_dark = AppCache.sortFilterCacheDTO!.currentTheme;
  late AlertCpkDTO alertCpkDTO;
  late Map<String?, List<AlertCpkDataDTO>> alertCpkMap;
  List<CustomDqmSortFilterItemSelectionDTO> filterTestTypeList = [];
  List<AlertCpkDataDTO> cpkList = [];

  Future<AlertCpkDTO> getAlertCpk(BuildContext context) {
    String companyId = '';
    String siteId = '';
    String projectId = '';
    String equipmentId = '';
    String fixtureId = '';
    String timestamp = '';
    if (widget.alertListDataDTO != null) {
      companyId = widget.alertListDataDTO!.companyId!;
      siteId = widget.alertListDataDTO!.siteId!;
      projectId = widget.alertListDataDTO!.projectId!;
      equipmentId = widget.alertListDataDTO!.equipmentId!;
      fixtureId = widget.alertListDataDTO!.fixtureId!;
      timestamp = DateFormat("yyyyMMdd")
          .format(DateTime.parse(widget.alertListDataDTO!.timestamp!));
    } else {
      companyId = widget.alertStatisticsDataDTO!.companyId!;
      siteId = widget.alertStatisticsDataDTO!.siteId!;
      projectId = widget.alertStatisticsDataDTO!.projectId!;
      equipmentId = widget.alertStatisticsDataDTO!.equipmentId!;
      fixtureId = widget.alertStatisticsDataDTO!.fixtureId!;
      timestamp = DateFormat("yyyyMMdd")
          .format(DateTime.parse(widget.alertStatisticsDataDTO!.timestamp!));
    }
    AlertApi alertApi = AlertApi(context);
    return alertApi.getAlertCpk(
        companyId, siteId, projectId, equipmentId, fixtureId, timestamp);
  }

  void groupAlertCpkByTestType() {
    final groups = groupBy(this.alertCpkDTO.data!, (AlertCpkDataDTO e) {
      return e.testType;
    });

    setState(() {
      this.alertCpkMap = groups;
      this.alertCpkMap.keys.forEach((element) {
        if (Utils.isNotEmpty(element)) {
          CustomDqmSortFilterItemSelectionDTO itemDTO =
              CustomDqmSortFilterItemSelectionDTO(element, true);
          filterTestTypeList.add(itemDTO);
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    Utils.setFirebaseAnalyticsCurrentScreen(
        Constants.ANALYTICS_ALERT_CPK_LIST_SCREEN);
    callGetAlertCpk(context);
  }

  callGetAlertCpk(BuildContext context) async {
    await getAlertCpk(context).then((value) {
      if (value.status!.statusCode == 200) {
        this.alertCpkDTO = value;
        this.cpkList = value.data!;
        groupAlertCpkByTestType();
      } else {
        Utils.showAlertDialog(
            context,
            Utils.getTranslated(context, 'general_alert_error_title')!,
            value.status!.statusMessage!);
      }
    }).catchError((error) {
      Utils.printInfo(error);
      if (error is DioError) {
        if (error.response != null) {
          if (error.response!.data != null) {
            Utils.showAlertDialog(
                context,
                Utils.getTranslated(context, 'general_alert_error_title')!,
                error.response!.data['errorMessage'].toString());
          } else {
            Utils.showAlertDialog(
                context,
                Utils.getTranslated(context, 'general_alert_error_title')!,
                Utils.getTranslated(context, 'general_alert_error_message')!);
          }
        } else {
          Utils.showAlertDialog(
              context,
              Utils.getTranslated(context, 'general_alert_error_title')!,
              Utils.getTranslated(context, 'general_alert_error_message')!);
        }
      } else {
        Utils.showAlertDialog(
            context,
            Utils.getTranslated(context, 'general_alert_error_title')!,
            Utils.getTranslated(context, 'general_alert_error_message')!);
      }
    }).whenComplete(() {
      setState(() {
        this.isLoading = false;
      });
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
        title: Text(
          Utils.getTranslated(context, 'alertCPKAlert_appbar')!,
          style: AppFonts.robotoRegular(20,
              color: theme_dark!
                  ? AppColors.appGrey()
                  : AppColorsLightMode.appGrey(),
              decoration: TextDecoration.none),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Image.asset(
              theme_dark!
                  ? Constants.ASSET_IMAGES + 'back_bttn.png'
                  : Constants.ASSET_IMAGES_LIGHT + 'back_bttn.png',
            )),
      ),
      body: this.isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.appBlue()),
              ),
            )
          : Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 25),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 16),
                          child: Text(
                            Utils.getTranslated(
                                context, 'alertCPK_info_appbar')!,
                            style: AppFonts.robotoRegular(
                              16,
                              color: theme_dark!
                                  ? AppColors.appGrey2()
                                  : AppColorsLightMode.appGrey(),
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            this.filterTestTypeList.length > 0
                                ? Padding(
                                    padding: const EdgeInsets.only(right: 12),
                                    child: GestureDetector(
                                      onTap: () async {
                                        if (this.filterTestTypeList.length >
                                            0) {
                                          final navResult =
                                              await Navigator.pushNamed(
                                            context,
                                            AppRoutes.alertFilterRoute,
                                            arguments: AlertArguments(
                                                filterItemSelectionList:
                                                    this.filterTestTypeList),
                                          );

                                          if (navResult != null) {
                                            List<String> selectedTestType = [];
                                            this
                                                .filterTestTypeList
                                                .forEach((element) {
                                              if (element.isSelected!) {
                                                selectedTestType
                                                    .add(element.item!);
                                              }
                                            });
                                            setState(() {
                                              this.cpkList = this
                                                  .alertCpkDTO
                                                  .data!
                                                  .where((e) => selectedTestType
                                                      .contains(e.testType))
                                                  .toList();
                                            });
                                          }
                                        }
                                      },
                                      child: Image.asset(
                                          Constants.ASSET_IMAGES +
                                              'filter_icon.png'),
                                    ),
                                  )
                                : Container(),
                            Padding(
                              padding: const EdgeInsets.only(right: 16),
                              child: GestureDetector(
                                onTap: () {
                                  showDownloadCsvPopup(context);
                                },
                                child: Image.asset(theme_dark!
                                    ? Constants.ASSET_IMAGES +
                                        'download_bttn.png'
                                    : Constants.ASSET_IMAGES_LIGHT +
                                        'download_bttn.png'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 24),
                    this.cpkList.length > 0
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: this
                                .cpkList
                                .map((e) => dataItem(context, e))
                                .toList(),
                          )
                        : Container(),
                  ],
                ),
              ),
            ),
    );
  }

  void showDownloadCsvPopup(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext csvContext) => CupertinoActionSheet(
        actions: [
          Container(
            color: theme_dark!
                ? AppColors.cupertinoBackground()
                : AppColorsLightMode.cupertinoBackground().withOpacity(0.8),
            child: CupertinoActionSheetAction(
              onPressed: () async {
                Navigator.pop(csvContext);

                String curDate =
                    '#${DateFormat('yyyy.MM.dd').format(DateTime.now())}@${DateFormat('HH.mm.ss').format(DateTime.now())}';

                String name = Utils.getExportFilename(
                  'CPK Information',
                  fromDate: DateFormat('yyyy-MM-dd')
                      .format(AppCache.sortFilterCacheDTO!.startDate!),
                  toDate: DateFormat('yyyy-MM-dd')
                      .format(AppCache.sortFilterCacheDTO!.endDate!),
                  currentDate: curDate,
                  expType: '.csv',
                );

                final result = await CSVApi.generateCSV(cpkList, name);
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
              Navigator.pop(csvContext);
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

  Widget dataItem(BuildContext ctx, AlertCpkDataDTO e) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.alertCPKChart,
          arguments:
              AlertArguments(appBarTitle: "Daily CPK", alertCpkDataDTO: e),
        );
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(15, 14, 12, 12),
        height: 80,
        margin: EdgeInsets.fromLTRB(16, 0, 16, 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: theme_dark!
              ? AppColors.appBlackLight()
              : AppColorsLightMode.appGreyF0(),
        ),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      Utils.getTranslated(context, 'alertTestName')!,
                      style: AppFonts.robotoRegular(13,
                          color: theme_dark!
                              ? AppColors.appGreyB1()
                              : AppColorsLightMode.appGrey77(),
                          decoration: TextDecoration.none),
                    ),
                    SizedBox(height: 9),
                    Flexible(
                      child: Text(
                        e.testName!,
                        style: AppFonts.robotoRegular(13,
                            color: theme_dark!
                                ? AppColors.appGreyDE()
                                : AppColorsLightMode.appGrey(),
                            decoration: TextDecoration.none),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      Utils.getTranslated(
                          context, 'dqm_rma_cpk_dashboard_histogram_cpk')!,
                      style: AppFonts.robotoRegular(13,
                          color: theme_dark!
                              ? AppColors.appGreyB1()
                              : AppColorsLightMode.appGrey77(),
                          decoration: TextDecoration.none),
                    ),
                    SizedBox(
                      height: 9,
                    ),
                    Text(
                      double.parse(e.cpk!).toStringAsFixed(2),
                      style: AppFonts.robotoRegular(13,
                          color: theme_dark!
                              ? AppColors.appGreyDE()
                              : AppColorsLightMode.appGrey(),
                          decoration: TextDecoration.none),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            Utils.getTranslated(context, 'alertThreshold')!,
                            style: AppFonts.robotoRegular(13,
                                color: theme_dark!
                                    ? AppColors.appGreyB1()
                                    : AppColorsLightMode.appGrey77(),
                                decoration: TextDecoration.none),
                          ),
                        ),
                        InkWell(
                          onTap: () {},
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Image.asset(
                              Constants.ASSET_IMAGES + 'oee_info_button.png',
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 9),
                    Text(
                      e.threshold!,
                      style: AppFonts.robotoRegular(13,
                          color: theme_dark!
                              ? AppColors.appGreyDE()
                              : AppColorsLightMode.appGrey(),
                          decoration: TextDecoration.none),
                    ),
                  ],
                ),
              ),
              // Expanded(
              //   child: Align(
              //     alignment: Alignment.topRight,
              //     child: Image.asset(
              //       Constants.ASSET_IMAGES + 'oee_info_button.png',
              //     ),
              //   ),
              // ),
            ]),
      ),
    );
  }
}
