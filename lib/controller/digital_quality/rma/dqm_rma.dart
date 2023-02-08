import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:keysight_pma/cache/appcache.dart';
import 'package:keysight_pma/const/appcolors.dart';
import 'package:keysight_pma/const/appfonts.dart';
import 'package:keysight_pma/const/constants.dart';
import 'package:keysight_pma/const/download.dart';
import 'package:keysight_pma/const/utils.dart';
import 'package:keysight_pma/dio/api/dqm.dart';
import 'package:keysight_pma/model/arguments/dqm_argument.dart';
import 'package:keysight_pma/model/arguments/search_argument.dart';
import 'package:keysight_pma/model/arguments/sort_filter_argument.dart';
import 'package:keysight_pma/model/dqm/anomaly_company.dart';
import 'package:keysight_pma/routes/approutes.dart';

class DigitalQualityRmaScreen extends StatefulWidget {
  DigitalQualityRmaScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DigitalQualityRmaScreen();
  }
}

class _DigitalQualityRmaScreen extends State<DigitalQualityRmaScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final editController = TextEditingController();
  bool hasText = false;
  String filterBy = '';
  int filterType = 0;

  bool? isDarkTheme = AppCache.sortFilterCacheDTO!.currentTheme;
  String sortBy = Constants.SORT_ASCENDING;
  late AnomalyCompanyDTO anomalyCompanyDTO;
  List<AnomalyCompanyDataDTO> anomalyCompanyList = [];

  Future<AnomalyCompanyDTO> getListAnomalyCompanyData(
      BuildContext context, String serialNumber) {
    String companyId = AppCache.sortFilterCacheDTO!.preferredCompany!;
    String siteId = AppCache.sortFilterCacheDTO!.preferredSite!;
    DqmApi dqmApi = DqmApi(context);
    return dqmApi.getListAnomalyCompanyData(companyId, siteId, serialNumber);
  }

  void textFieldOnChange() {
    setState(() {
      if (editController.text.trim().isNotEmpty) {
        hasText = true;
      } else {
        hasText = false;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    Utils.setFirebaseAnalyticsCurrentScreen(Constants.ANALYTICS_DQM_RMA_SCREEN);
    FocusManager.instance.primaryFocus?.unfocus();
    editController.addListener(textFieldOnChange);
  }

  @override
  void dispose() {
    editController.dispose();
    super.dispose();
  }

  callGetListAnomalyCompanyData(
      BuildContext context, String serialNumber) async {
    await getListAnomalyCompanyData(context, serialNumber).then((value) {
      this.anomalyCompanyDTO = value;
      if (this.anomalyCompanyDTO.data != null &&
          this.anomalyCompanyDTO.data!.length > 0) {
        this.anomalyCompanyList = this.anomalyCompanyDTO.data!;
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
        if (EasyLoading.isShow) {
          EasyLoading.dismiss();
        }
      });
    });
  }

  sortAnomalyCompanyList() {
    if (this.anomalyCompanyList.length > 0) {
      if (this.filterType == Constants.RMA_SORT_BY_START_TIME) {
        this.anomalyCompanyList.sort((a, b) {
          if (this.sortBy == Constants.SORT_ASCENDING) {
            return a.startTime!.compareTo(b.startTime!);
          } else {
            return b.startTime!.compareTo(a.startTime!);
          }
        });
      } else if (this.filterType == Constants.RMA_SORT_BY_END_TIME) {
        this.anomalyCompanyList.sort((a, b) {
          if (this.sortBy == Constants.SORT_ASCENDING) {
            return a.endTime!.compareTo(b.endTime!);
          } else {
            return b.endTime!.compareTo(a.endTime!);
          }
        });
      } else if (this.filterType == Constants.RMA_SORT_BY_FIXTURE) {
        this.anomalyCompanyList.sort((a, b) {
          if (this.sortBy == Constants.SORT_ASCENDING) {
            return a.fixtureId!.compareTo(b.fixtureId!);
          } else {
            return b.fixtureId!.compareTo(a.fixtureId!);
          }
        });
      } else if (this.filterType == Constants.RMA_SORT_BY_EQUIPMENT) {
        this.anomalyCompanyList.sort((a, b) {
          if (this.sortBy == Constants.SORT_ASCENDING) {
            return a.equipmentName!.compareTo(b.equipmentName!);
          } else {
            return b.equipmentName!.compareTo(a.equipmentName!);
          }
        });
      } else if (this.filterType == Constants.RMA_SORT_BY_STATUS) {
        this.anomalyCompanyList.sort((a, b) {
          if (this.sortBy == Constants.SORT_ASCENDING) {
            return a.status!.compareTo(b.status!);
          } else {
            return b.status!.compareTo(a.status!);
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.all(16.0),
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      inputLabel(context),
                      inputField(context),
                      rmaSearchText(context),
                      rmaSearchResult(context),
                      rmaDataSorting(context),
                      rmaTestDataList(context),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: TextButton(
                    onPressed: () async {
                      final navigateResult = await Navigator.pushNamed(
                        context,
                        AppRoutes.sortAndFilterRoute,
                        arguments: SortFilterArguments(
                          menuType: Constants.HOME_MENU_DQM,
                          currentTab: 3,
                        ),
                      );

                      if (navigateResult != null && navigateResult as bool) {
                        setState(() {
                          if (Utils.isNotEmpty(editController.text.trim())) {
                            EasyLoading.show(
                                maskType: EasyLoadingMaskType.black);
                            callGetListAnomalyCompanyData(
                                context, editController.text.trim());
                          }
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
        ),
      ),
    );
  }

  Widget inputLabel(BuildContext ctx) {
    return Container(
      margin: EdgeInsets.only(top: 25),
      child: Text(
        Utils.getTranslated(ctx, 'dqm_rma_input_label')!,
        style: AppFonts.sfproMedium(
          15,
          color: isDarkTheme!
              ? AppColors.appGreyDE()
              : AppColorsLightMode.appGrey(),
          decoration: TextDecoration.none,
        ),
      ),
    );
  }

  Widget inputField(BuildContext ctx) {
    return Container(
      margin: EdgeInsets.only(top: 25.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: isDarkTheme!
                    ? AppColors.appBlackLight()
                    : AppColors.appPrimaryWhite(),
                borderRadius: BorderRadius.circular(6.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextField(
                      controller: editController,
                      minLines: null,
                      maxLines: null,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0),
                        hintText:
                            Utils.getTranslated(ctx, 'dqm_rma_input_hint_text'),
                        hintStyle: AppFonts.robotoRegular(
                          14,
                          color: isDarkTheme!
                              ? AppColors.appGrey9A()
                              : AppColorsLightMode.appGrey(),
                          decoration: TextDecoration.none,
                        ),
                      ),
                      style: AppFonts.sfproMedium(
                        14,
                        color: isDarkTheme!
                            ? AppColors.appGrey2()
                            : AppColorsLightMode.appGrey(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                  hasText
                      ? GestureDetector(
                          onTap: () {
                            FocusScopeNode currentFocus = FocusScope.of(ctx);
                            if (!currentFocus.hasPrimaryFocus) {
                              currentFocus.unfocus();
                            }
                            editController.clear();
                            setState(() {
                              hasText = false;
                            });
                          },
                          child: Container(
                            height: 48.0,
                            padding: EdgeInsets.all(10.0),
                            child: Center(
                              child: Text(
                                Utils.getTranslated(ctx, 'dqm_rma_clear_text')!,
                                style: AppFonts.sfproMedium(
                                  14,
                                  color: AppColors.appGrey89(),
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ),
                          ),
                        )
                      : Container(),
                  GestureDetector(
                    onTap: () {
                      if (Utils.isNotEmpty(editController.text.trim())) {
                        FocusScopeNode currentFocus = FocusScope.of(context);
                        if (!currentFocus.hasPrimaryFocus) {
                          currentFocus.unfocus();
                        }
                        EasyLoading.show(maskType: EasyLoadingMaskType.black);
                        editController.text =
                            "BM_4_P1479299-00-D_SPGT19119000510"; //BM_6_P1479299-00-D_SPGT19115001335
                        callGetListAnomalyCompanyData(
                            context, editController.text.trim());
                      }
                    },
                    child: Container(
                      height: 48.0,
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: AppColors.appGreen(),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(6.0),
                          bottomRight: Radius.circular(6.0),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            Utils.getTranslated(ctx, 'dqm_rma_action_go')!,
                            style: AppFonts.robotoMedium(
                              14,
                              color: AppColors.appPrimaryWhite(),
                              decoration: TextDecoration.none,
                            ),
                          ),
                          SizedBox(width: 5.0),
                          Image.asset(isDarkTheme!
                              ? Constants.ASSET_IMAGES + 'go_icon.png'
                              : Constants.ASSET_IMAGES_LIGHT + 'go_icon.png'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 22.0),
          InkWell(
            onTap: () async {
              final navResult = await Navigator.pushNamed(
                  ctx, AppRoutes.dqmRmaQrcodeScanRoute);
              if (navResult != null) {
                String result = navResult as String;
                if (Utils.isNotEmpty(result)) {
                  EasyLoading.show(maskType: EasyLoadingMaskType.black);
                  callGetListAnomalyCompanyData(context, result);
                }
              }
            },
            child: Image.asset(isDarkTheme!
                ? Constants.ASSET_IMAGES + 'scan_icon.png'
                : Constants.ASSET_IMAGES_LIGHT + 'scan.png'),
          )
        ],
      ),
    );
  }

  Widget rmaSearchText(BuildContext ctx) {
    String searchText = Utils.getTranslated(ctx, 'dqm_rma_input_hint_text')! +
        ': \n${editController.text.trim()}';
    return Container(
      margin: EdgeInsets.only(top: 32.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              searchText,
              style: AppFonts.sfproMedium(
                14,
                color: isDarkTheme!
                    ? AppColors.appGrey2()
                    : AppColorsLightMode.appGrey21(),
                decoration: TextDecoration.none,
              ),
            ),
          ),
          SizedBox(width: 12.0),
          InkWell(
            onTap: () {
              if (this.anomalyCompanyList.length > 0) {
                Navigator.pushNamed(
                  ctx,
                  AppRoutes.searchRoute,
                  arguments: SearchArguments(
                    rmaAnomalyInfoList: this.anomalyCompanyList,
                  ),
                );
              }
            },
            child: Image.asset(isDarkTheme!
                ? Constants.ASSET_IMAGES + 'search_icon.png'
                : Constants.ASSET_IMAGES_LIGHT + 'search.png'),
          ),
          SizedBox(width: 12.0),
          InkWell(
            onTap: () {
              showDownloadPopup(ctx);
            },
            child: Image.asset(isDarkTheme!
                ? Constants.ASSET_IMAGES + 'download_bttn.png'
                : Constants.ASSET_IMAGES_LIGHT + 'download_bttn.png'),
          ),
        ],
      ),
    );
  }

  Widget rmaSearchResult(BuildContext ctx) {
    String label = Utils.getTranslated(ctx, 'dqm_rma_test_history_detected')! +
        ' (' +
        Utils.getTranslated(ctx, 'dqm_rma_tested')! +
        ': ${this.anomalyCompanyList.length})';
    return Container(
      margin: EdgeInsets.only(top: 15.0),
      child: Text(
        label,
        style: AppFonts.sfproMedium(
          13,
          color: isDarkTheme!
              ? AppColors.appGrey2()
              : AppColorsLightMode.appGrey21(),
          decoration: TextDecoration.none,
        ),
      ),
    );
  }

  Widget rmaDataSorting(BuildContext ctx) {
    if (this.anomalyCompanyList.length > 0) {
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
                      color: isDarkTheme!
                          ? AppColors.appPrimaryWhite()
                          : AppColorsLightMode.appTeal()),
                  borderRadius: BorderRadius.circular(50.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      Utils.getTranslated(ctx, 'sort_by')! + ' $filterBy',
                      style: AppFonts.robotoMedium(
                        14,
                        color: isDarkTheme!
                            ? AppColors.appPrimaryWhite()
                            : AppColorsLightMode.appTeal(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                    SizedBox(width: 10.0),
                    Image.asset(isDarkTheme!
                        ? Constants.ASSET_IMAGES + 'dropdown_icon.png'
                        : Constants.ASSET_IMAGES_LIGHT + 'dropdown.png')
                  ],
                ),
              ),
            ),
            SizedBox(width: 12.0),
            filterBy.length > 0
                ? GestureDetector(
                    onTap: () {
                      showSortAscOrDscPopup(ctx);
                    },
                    child: Container(
                      padding: EdgeInsets.fromLTRB(20.0, 7.0, 20.0, 7.0),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(color: AppColors.appPrimaryWhite()),
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            sortBy.length > 0
                                ? Utils.getTranslated(ctx, sortBy)!
                                : 'Please select',
                            style: AppFonts.robotoMedium(
                              14,
                              color: AppColors.appPrimaryWhite(),
                              decoration: TextDecoration.none,
                            ),
                          ),
                          SizedBox(width: 10.0),
                          Image.asset(isDarkTheme!
                              ? Constants.ASSET_IMAGES + 'dropdown_icon.png'
                              : Constants.ASSET_IMAGES_LIGHT + 'dropdown.png')
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

  Widget rmaTestDataList(BuildContext ctx) {
    if (this.anomalyCompanyList.length > 0) {
      return Container(
        margin: EdgeInsets.only(top: 30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: this
                  .anomalyCompanyList
                  .map((e) => rmaTestDataItem(ctx, e))
                  .toList(),
            ),
          ],
        ),
      );
    }

    return Container();
  }

  Widget rmaTestDataItem(BuildContext ctx, AnomalyCompanyDataDTO dataDTO) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(ctx, AppRoutes.dqmRmaResultInfoRoute,
            arguments: DqmRmaArguments(anomalyCompanyDataDTO: dataDTO));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 14.0),
        padding: EdgeInsets.fromLTRB(17.0, 15.0, 17.0, 15.0),
        decoration: BoxDecoration(
          color: isDarkTheme!
              ? AppColors.appBlackLight()
              : AppColorsLightMode.serverAppBar(),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    '${dataDTO.projectId}',
                    style: AppFonts.robotoBold(
                      15,
                      color: isDarkTheme!
                          ? AppColors.appGreyDE()
                          : AppColorsLightMode.appGrey(),
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(12.0, 5.0, 12.0, 5.0),
                  decoration: BoxDecoration(
                    color: (dataDTO.status!.contains("PASS") ||
                            dataDTO.status!.contains("Pass") ||
                            dataDTO.status!.contains("pass"))
                        ? AppColors.appGreen60()
                        : AppColors.appRedE9(),
                    borderRadius: BorderRadius.circular(2.0),
                  ),
                  child: (dataDTO.status!.contains("PASS") ||
                          dataDTO.status!.contains("Pass") ||
                          dataDTO.status!.contains("pass"))
                      ? Text(
                          Utils.getTranslated(ctx, 'dqm_rma_passed')!,
                          style: AppFonts.robotoMedium(
                            12,
                            color: AppColors.appPrimaryWhite(),
                            decoration: TextDecoration.none,
                          ),
                        )
                      : Text(
                          Utils.getTranslated(ctx, 'dqm_rma_failed')!,
                          style: AppFonts.robotoMedium(
                            12,
                            color: AppColors.appPrimaryWhite(),
                            decoration: TextDecoration.none,
                          ),
                        ),
                ),
              ],
            ),
            SizedBox(height: 25.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Utils.getTranslated(ctx, 'dqm_rma_sortby_start_time')!,
                        style: AppFonts.robotoRegular(
                          13,
                          color: isDarkTheme!
                              ? AppColors.appGreyB1()
                              : AppColorsLightMode.appGrey70(),
                          decoration: TextDecoration.none,
                        ),
                      ),
                      SizedBox(height: 7.0),
                      Text(
                        DateFormat("dd MMM yyyy HH:mm:ss")
                            .format(DateTime.parse(dataDTO.startTime!)),
                        style: AppFonts.robotoMedium(
                          13,
                          color: isDarkTheme!
                              ? AppColors.appGreyDE()
                              : AppColorsLightMode.appGrey(),
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10.0),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Utils.getTranslated(ctx, 'dqm_rma_sortby_end_time')!,
                        style: AppFonts.robotoRegular(
                          13,
                          color: isDarkTheme!
                              ? AppColors.appGreyB1()
                              : AppColorsLightMode.appGrey70(),
                          decoration: TextDecoration.none,
                        ),
                      ),
                      SizedBox(height: 7.0),
                      Text(
                        DateFormat("dd MMM yyyy HH:mm:ss")
                            .format(DateTime.parse(dataDTO.endTime!)),
                        style: AppFonts.robotoMedium(
                          13,
                          color: isDarkTheme!
                              ? AppColors.appGreyDE()
                              : AppColorsLightMode.appGrey(),
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void showDownloadPopup(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext popContext) => CupertinoActionSheet(
        actions: [
          Container(
            color: isDarkTheme!
                ? AppColors.cupertinoBackground()
                : AppColorsLightMode.cupertinoBackground().withOpacity(0.8),
            child: CupertinoActionSheetAction(
              onPressed: () async {
                Navigator.pop(popContext);
                //Test History Detected_2022-08-10
                String curDate =
                    '${DateFormat('yyyy.MM.dd').format(DateTime.now())}';
                String name = Utils.getExportFilename(
                  'Test History Detected',
                  currentDate: curDate,
                  expType: '.csv',
                );
                final result =
                    await CSVApi.generateCSV(anomalyCompanyList, name);
                if (result == true) {
                  setState(() {
                    var snackBar = SnackBar(
                      content: Text(
                        Utils.getTranslated(context, 'done_download_as_csv')!,
                        style: AppFonts.robotoRegular(
                          16,
                          color: isDarkTheme!
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
                  color: isDarkTheme!
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
              color: isDarkTheme!
                  ? AppColors.cupertinoBackground()
                  : AppColorsLightMode.cupertinoBackground(),
              borderRadius: BorderRadius.circular(14)),
          child: CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(popContext);
            },
            child: Text(
              Utils.getTranslated(context, 'cancel')!,
              style: AppFonts.robotoMedium(15,
                  color: isDarkTheme!
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

  void showSortMenuPopup(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext popContext) => CupertinoActionSheet(
        actions: [
          Container(
            color: isDarkTheme!
                ? AppColors.cupertinoBackground()
                : AppColorsLightMode.cupertinoBackground().withOpacity(0.8),
            child: CupertinoActionSheetAction(
              onPressed: () {
                setState(() {
                  this.filterType = Constants.RMA_SORT_BY_START_TIME;
                  filterBy = Utils.getTranslated(
                      context, 'dqm_rma_sortby_start_time')!;
                  sortAnomalyCompanyList();
                });
                Navigator.pop(popContext);
              },
              child: Text(
                Utils.getTranslated(context, 'dqm_rma_sortby_start_time')!,
                style: AppFonts.robotoRegular(
                  15,
                  color: isDarkTheme!
                      ? AppColors.appPrimaryWhite().withOpacity(0.8)
                      : AppColorsLightMode.appGrey(),
                  decoration: TextDecoration.none,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Container(
            color: isDarkTheme!
                ? AppColors.cupertinoBackground()
                : AppColorsLightMode.cupertinoBackground().withOpacity(0.8),
            child: CupertinoActionSheetAction(
              onPressed: () {
                setState(() {
                  this.filterType = Constants.RMA_SORT_BY_END_TIME;
                  filterBy =
                      Utils.getTranslated(context, 'dqm_rma_sortby_end_time')!;
                  sortAnomalyCompanyList();
                });
                Navigator.pop(popContext);
              },
              child: Text(
                Utils.getTranslated(context, 'dqm_rma_sortby_end_time')!,
                style: AppFonts.robotoRegular(
                  15,
                  color: isDarkTheme!
                      ? AppColors.appPrimaryWhite().withOpacity(0.8)
                      : AppColorsLightMode.appGrey(),
                  decoration: TextDecoration.none,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Container(
            color: isDarkTheme!
                ? AppColors.cupertinoBackground()
                : AppColorsLightMode.cupertinoBackground().withOpacity(0.8),
            child: CupertinoActionSheetAction(
              onPressed: () {
                setState(() {
                  this.filterType = Constants.RMA_SORT_BY_FIXTURE;
                  filterBy =
                      Utils.getTranslated(context, 'dqm_rma_sortby_fixture')!;
                  sortAnomalyCompanyList();
                });
                Navigator.pop(popContext);
              },
              child: Text(
                Utils.getTranslated(context, 'dqm_rma_sortby_fixture')!,
                style: AppFonts.robotoRegular(
                  15,
                  color: isDarkTheme!
                      ? AppColors.appPrimaryWhite().withOpacity(0.8)
                      : AppColorsLightMode.appGrey(),
                  decoration: TextDecoration.none,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Container(
            color: isDarkTheme!
                ? AppColors.cupertinoBackground()
                : AppColorsLightMode.cupertinoBackground().withOpacity(0.8),
            child: CupertinoActionSheetAction(
              onPressed: () {
                setState(() {
                  this.filterType = Constants.RMA_SORT_BY_EQUIPMENT;
                  filterBy =
                      Utils.getTranslated(context, 'dqm_rma_sortby_equipment')!;
                  sortAnomalyCompanyList();
                });
                Navigator.pop(popContext);
              },
              child: Text(
                Utils.getTranslated(context, 'dqm_rma_sortby_equipment')!,
                style: AppFonts.robotoRegular(
                  15,
                  color: isDarkTheme!
                      ? AppColors.appPrimaryWhite().withOpacity(0.8)
                      : AppColorsLightMode.appGrey(),
                  decoration: TextDecoration.none,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Container(
            color: isDarkTheme!
                ? AppColors.cupertinoBackground()
                : AppColorsLightMode.cupertinoBackground().withOpacity(0.8),
            child: CupertinoActionSheetAction(
              onPressed: () {
                setState(() {
                  this.filterType = Constants.RMA_SORT_BY_STATUS;
                  filterBy =
                      Utils.getTranslated(context, 'dqm_rma_sortby_status')!;
                  sortAnomalyCompanyList();
                });
                Navigator.pop(popContext);
              },
              child: Text(
                Utils.getTranslated(context, 'dqm_rma_sortby_status')!,
                style: AppFonts.robotoRegular(
                  15,
                  color: isDarkTheme!
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
              color: isDarkTheme!
                  ? AppColors.cupertinoBackground()
                  : AppColorsLightMode.cupertinoBackground(),
              borderRadius: BorderRadius.circular(14)),
          child: CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(popContext);
            },
            child: Text(
              Utils.getTranslated(context, 'cancel')!,
              style: AppFonts.robotoMedium(15,
                  color: isDarkTheme!
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

  void showSortAscOrDscPopup(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext popContext) => CupertinoActionSheet(
        actions: [
          Container(
            color: isDarkTheme!
                ? AppColors.cupertinoBackground()
                : AppColorsLightMode.cupertinoBackground().withOpacity(0.8),
            child: CupertinoActionSheetAction(
              onPressed: () {
                setState(() {
                  sortBy = Constants.SORT_ASCENDING;
                  sortAnomalyCompanyList();
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
                        color: isDarkTheme!
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
                      child: sortBy.length > 0 &&
                              sortBy == Constants.SORT_ASCENDING
                          ? Image.asset(isDarkTheme!
                              ? Constants.ASSET_IMAGES + 'tick_icon.png'
                              : Constants.ASSET_IMAGES_LIGHT + 'tick_icon.png')
                          : Container(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            color: isDarkTheme!
                ? AppColors.cupertinoBackground()
                : AppColorsLightMode.cupertinoBackground().withOpacity(0.8),
            child: CupertinoActionSheetAction(
              onPressed: () {
                setState(() {
                  sortBy = Constants.SORT_DESCENDING;
                  sortAnomalyCompanyList();
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
                        color: isDarkTheme!
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
                      child: sortBy.length > 0 &&
                              sortBy == Constants.SORT_DESCENDING
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
              color: isDarkTheme!
                  ? AppColors.cupertinoBackground()
                  : AppColorsLightMode.cupertinoBackground(),
              borderRadius: BorderRadius.circular(14)),
          child: CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(popContext);
            },
            child: Text(
              Utils.getTranslated(context, 'cancel')!,
              style: AppFonts.robotoMedium(15,
                  color: isDarkTheme!
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
}
