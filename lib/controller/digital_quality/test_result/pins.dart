import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
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
import 'package:keysight_pma/model/customize.dart';
import 'package:keysight_pma/model/dqm/test_result_cpk_pins.dart';
import 'package:keysight_pma/model/dqm/test_type.dart';
import 'package:keysight_pma/model/js/js.dart';
import 'package:keysight_pma/routes/approutes.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

class TestResultPinsScreen extends StatefulWidget {
  final Function() notifyParent;
  TestResultPinsScreen({Key? key, required this.notifyParent})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TestResultPinsScreen();
  }
}

class _TestResultPinsScreen extends State<TestResultPinsScreen> {
  String sorting = Constants.SORT_ASCENDING;
  String sortBy = '';
  int sortType = 0;
  TestResultCpkPinsShortsDTO? cpkPinsDTO;
  bool isLoading = true;
  double chartCTNHeight = 316.0;
  late WebViewPlusController cpkTestNameController;
  late Map<String?, List<TestResultCpkPinsShortsTestJetDataDTO>> pinCpkMap;
  List<CustomDqmSortFilterItemSelectionDTO> filterTestTypeList = [];
  int page = 0;
  int pageSize = 10;
  late JSCpkSigmaDataDTO jsSigmaDataDTO;
  bool isShowAnalogSigma = false;
  String? filterSigma = Constants.SIGMA_ALL;
  late TestTypeDTO testTypeDTO;
  List<CustomDqmSortFilterItemSelectionDTO> selectedTestTypeList = [];
  List<TestResultCpkPinsShortsTestJetDataDTO> cpkPinsList = [];
  List<String> sTestTypeList = [];

  bool? theme_dark = AppCache.sortFilterCacheDTO!.currentTheme;
  Future<TestTypeDTO> getTestTypeList(BuildContext context) {
    String companyId = AppCache.sortFilterCacheDTO!.preferredCompany!;
    String siteId = AppCache.sortFilterCacheDTO!.preferredSite!;
    String projectId = AppCache.sortFilterCacheDTO!.defaultProjectId!;
    if (Utils.isNotEmpty(AppCache.sortFilterCacheDTO!.defaultVersion)) {
      if (AppCache.sortFilterCacheDTO!.defaultVersion != "Base") {
        projectId = AppCache.sortFilterCacheDTO!.defaultProjectId! +
            "<" +
            AppCache.sortFilterCacheDTO!.defaultVersion!;
      }
    }
    DqmApi dqmApi = DqmApi(context);
    return dqmApi.getTestTypeList(companyId, siteId, projectId, "EDLPins");
  }

  Future<TestResultCpkPinsShortsDTO> getTestResultCpkPins(
      BuildContext context) {
    String companyId = AppCache.sortFilterCacheDTO!.preferredCompany!;
    String siteId = AppCache.sortFilterCacheDTO!.preferredSite!;
    String startDate =
        DateFormat("yyyyMMdd").format(AppCache.sortFilterCacheDTO!.startDate!);
    String endDate =
        DateFormat("yyyyMMdd").format(AppCache.sortFilterCacheDTO!.endDate!);
    List<String?> equipments = AppCache.sortFilterCacheDTO!.defaultEquipments!
        .map((e) => e.equipmentId)
        .toList();
    String projectId = AppCache.sortFilterCacheDTO!.defaultProjectId!;
    if (Utils.isNotEmpty(AppCache.sortFilterCacheDTO!.defaultVersion)) {
      if (AppCache.sortFilterCacheDTO!.defaultVersion != "Base") {
        projectId = AppCache.sortFilterCacheDTO!.defaultProjectId! +
            "<" +
            AppCache.sortFilterCacheDTO!.defaultVersion!;
      }
    }

    DqmApi dqmApi = DqmApi(context);
    return dqmApi.getTestResultCpkPinsShortsTestJet(companyId, siteId,
        projectId, startDate, endDate, '', equipments, sTestTypeList);
  }

  @override
  void initState() {
    super.initState();
    Utils.setFirebaseAnalyticsCurrentScreen(
        Constants.ANALYTICS_DQM_TEST_RESULT_PINS_SCREEN);
    FocusManager.instance.primaryFocus?.unfocus();
    callGetTestTypeList(context);
  }

  callGetTestTypeList(BuildContext context) async {
    await getTestTypeList(context).then((value) {
      if (value.status!.statusCode == 200) {
        this.testTypeDTO = value;
        if (value.data != null) {
          value.data!.forEach((element) {
            this.sTestTypeList.add(element);
            CustomDqmSortFilterItemSelectionDTO itemSelectionDTO =
                CustomDqmSortFilterItemSelectionDTO(element, true);
            this.selectedTestTypeList.add(itemSelectionDTO);
          });
        }
        callGetTestResultCpkPins(context);
      } else {}
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
    });
  }

  callGetTestResultCpkPins(BuildContext context) async {
    await getTestResultCpkPins(context).then((value) {
      if (value.status!.statusCode == 200) {
        this.cpkPinsDTO = value;
        if (value.data != null && value.data!.length > 0) {
          this.cpkPinsList = value.data!;
        }
      } else {
        if (Utils.isNotEmpty(value.errorMessage)) {
          Utils.showAlertDialog(
              context,
              Utils.getTranslated(context, 'general_alert_error_title')!,
              value.errorMessage!);
        } else {
          Utils.showAlertDialog(
              context,
              Utils.getTranslated(context, 'general_alert_error_title')!,
              Utils.getTranslated(context, 'general_alert_error_message')!);
        }
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
        if (EasyLoading.isShow) {
          this.cpkTestNameController.webViewController.reload();
          EasyLoading.dismiss();
        }
      });
    });
  }

  void sortAnalogCpkList() {
    if (this.cpkPinsList.length > 0) {
      if (this.sortType == Constants.SORT_BY_INDICATOR) {
        List<TestResultCpkPinsShortsTestJetDataDTO> failList = this
            .cpkPinsList
            .where(
                (element) => element.hasFailure != null && element.hasFailure!)
            .toList();
        List<TestResultCpkPinsShortsTestJetDataDTO> noFailList = this
            .cpkPinsList
            .where((element) =>
                element.hasFailure == null || element.hasFailure == false)
            .toList();

        this.cpkPinsList.clear();
        if (failList.length > 0) {
          if (this.sorting == Constants.SORT_DESCENDING) {
            this.cpkPinsList.addAll(failList);
            this.cpkPinsList.addAll(noFailList);
          } else {
            this.cpkPinsList.addAll(noFailList);
            this.cpkPinsList.addAll(failList);
          }
        } else {
          this.cpkPinsList.addAll(noFailList);
        }
      } else if (this.sortType == Constants.SORT_BY_SOURCE) {
        List<TestResultCpkPinsShortsTestJetDataDTO> sourceList = this
            .cpkPinsList
            .where((element) => Utils.isNotEmpty(element.source))
            .toList();
        List<TestResultCpkPinsShortsTestJetDataDTO> noSourceList = this
            .cpkPinsList
            .where((element) => !Utils.isNotEmpty(element.source))
            .toList();
        this.cpkPinsList.clear();
        if (sourceList.length > 0) {
          sourceList.sort((a, b) {
            if (this.sorting == Constants.SORT_DESCENDING) {
              return b.source!.compareTo(a.source!);
            }
            return a.source!.compareTo(b.source!);
          });
        }

        this.cpkPinsList.clear();
        if (noSourceList.length == 0) {
          this.cpkPinsList.addAll(sourceList);
        } else {
          if (this.sorting == Constants.SORT_ASCENDING) {
            this.cpkPinsList.addAll(noSourceList);
            this.cpkPinsList.addAll(sourceList);
          } else {
            this.cpkPinsList.addAll(sourceList);
            this.cpkPinsList.addAll(noSourceList);
          }
        }
      } else if (this.sortType == Constants.SORT_BY_CPK) {
        List<TestResultCpkPinsShortsTestJetDataDTO> cpkList =
            this.cpkPinsList.where((element) => element.cpk != null).toList();
        List<TestResultCpkPinsShortsTestJetDataDTO> noCpkList =
            this.cpkPinsList.where((element) => element.cpk == null).toList();

        this.cpkPinsList.clear();
        if (cpkList.length > 0) {
          cpkList.sort((a, b) {
            if (this.sorting == Constants.SORT_DESCENDING) {
              return b.cpk!.toDouble().compareTo(a.cpk!.toDouble());
            }
            return a.cpk!.toDouble().compareTo(b.cpk!.toDouble());
          });

          if (this.sorting == Constants.SORT_DESCENDING) {
            this.cpkPinsList.addAll(cpkList);
            this.cpkPinsList.addAll(noCpkList);
          } else {
            this.cpkPinsList.addAll(noCpkList);
            this.cpkPinsList.addAll(cpkList);
          }
        } else {
          this.cpkPinsList.addAll(noCpkList);
        }
      } else if (this.sortType == Constants.SORT_BY_DESTINATION) {
        List<TestResultCpkPinsShortsTestJetDataDTO> destinationList = this
            .cpkPinsList
            .where((element) => Utils.isNotEmpty(element.destination))
            .toList();
        List<TestResultCpkPinsShortsTestJetDataDTO> noDestinationList = this
            .cpkPinsList
            .where((element) => !Utils.isNotEmpty(element.destination))
            .toList();
        this.cpkPinsList.clear();
        if (destinationList.length > 0) {
          destinationList.sort((a, b) {
            if (this.sorting == Constants.SORT_DESCENDING) {
              return b.destination!.compareTo(a.destination!);
            }
            return a.destination!.compareTo(b.destination!);
          });
        }

        this.cpkPinsList.clear();
        if (noDestinationList.length == 0) {
          this.cpkPinsList.addAll(destinationList);
        } else {
          if (this.sorting == Constants.SORT_ASCENDING) {
            this.cpkPinsList.addAll(noDestinationList);
            this.cpkPinsList.addAll(destinationList);
          } else {
            this.cpkPinsList.addAll(destinationList);
            this.cpkPinsList.addAll(noDestinationList);
          }
        }
      } else if (this.sortType == Constants.SORT_BY_MIN) {
        List<TestResultCpkPinsShortsTestJetDataDTO> minList =
            this.cpkPinsList.where((element) => element.min != null).toList();
        List<TestResultCpkPinsShortsTestJetDataDTO> noMinList =
            this.cpkPinsList.where((element) => element.min == null).toList();

        this.cpkPinsList.clear();
        if (minList.length > 0) {
          minList.sort((a, b) {
            if (this.sorting == Constants.SORT_DESCENDING) {
              return b.min!.toDouble().compareTo(a.min!.toDouble());
            }
            return a.min!.toDouble().compareTo(b.min!.toDouble());
          });

          if (this.sorting == Constants.SORT_DESCENDING) {
            this.cpkPinsList.addAll(minList);
            this.cpkPinsList.addAll(noMinList);
          } else {
            this.cpkPinsList.addAll(noMinList);
            this.cpkPinsList.addAll(minList);
          }
        } else {
          this.cpkPinsList.addAll(noMinList);
        }
      } else if (this.sortType == Constants.SORT_BY_MAX) {
        List<TestResultCpkPinsShortsTestJetDataDTO> maxList =
            this.cpkPinsList.where((element) => element.max != null).toList();
        List<TestResultCpkPinsShortsTestJetDataDTO> noMaxList =
            this.cpkPinsList.where((element) => element.max == null).toList();

        this.cpkPinsList.clear();
        if (maxList.length > 0) {
          maxList.sort((a, b) {
            if (this.sorting == Constants.SORT_DESCENDING) {
              return b.max!.toDouble().compareTo(a.max!.toDouble());
            }
            return a.max!.toDouble().compareTo(b.max!.toDouble());
          });

          if (this.sorting == Constants.SORT_DESCENDING) {
            this.cpkPinsList.addAll(maxList);
            this.cpkPinsList.addAll(noMaxList);
          } else {
            this.cpkPinsList.addAll(noMaxList);
            this.cpkPinsList.addAll(maxList);
          }
        } else {
          this.cpkPinsList.addAll(noMaxList);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
        child: this.isLoading
            ? Center(
                child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(AppColors.appBlue()),
                ),
              )
            : Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        pinInfoHeader(context),
                        pinSorting(context),
                        pinDataListing(context),
                        pinCPkTestname(context),
                        pinCPKTestnameChart(context),
                        pinSigma(context),
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
                            currentTab: 2,
                          ),
                        );

                        if (navigateResult != null && navigateResult as bool) {
                          if (AppCache
                              .sortFilterCacheDTO!.projectVersionObj!.isEdl!) {
                            setState(() {
                              this.isLoading = false;
                              EasyLoading.show(
                                  maskType: EasyLoadingMaskType.black);
                              callGetTestResultCpkPins(context);
                            });
                          } else {
                            widget.notifyParent();
                          }
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

  Widget pinInfoHeader(BuildContext ctx) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            Utils.getTranslated(ctx, 'dqm_testresult_pin_information')!,
            style: AppFonts.robotoRegular(
              16,
              color: theme_dark!
                  ? AppColors.appGrey2()
                  : AppColorsLightMode.appGrey(),
              decoration: TextDecoration.none,
            ),
          ),
        ),
        SizedBox(width: 12.0),
        InkWell(
          onTap: () {
            Navigator.pushNamed(
              ctx,
              AppRoutes.dqmTestResultProbeFinderRoute,
            );
          },
          child: Image.asset(
            theme_dark!
                ? Constants.ASSET_IMAGES + 'probe_finder_icon.png'
                : Constants.ASSET_IMAGES_LIGHT + 'probe_finder.png',
          ),
        ),
        SizedBox(width: 12.0),
        InkWell(
          onTap: () {
            if (this.cpkPinsList.length > 0) {
              Navigator.pushNamed(
                ctx,
                AppRoutes.searchRoute,
                arguments: SearchArguments(
                  pinsList: this.cpkPinsList,
                ),
              );
            }
          },
          child: Image.asset(
            theme_dark!
                ? Constants.ASSET_IMAGES + 'search_icon.png'
                : Constants.ASSET_IMAGES_LIGHT + 'search.png',
          ),
        ),
        SizedBox(width: 12.0),
        GestureDetector(
          onTap: () async {
            if (this.cpkPinsDTO != null &&
                this.cpkPinsDTO!.data != null &&
                this.cpkPinsDTO!.data!.length > 0) {
              final naviagateResult = await Navigator.pushNamed(
                ctx,
                AppRoutes.dqmTestResultAnalogInfoFilterRoute,
                arguments: DqmTestResultArguments(
                    itemSelectionList: this.selectedTestTypeList),
              );

              if (naviagateResult != null && naviagateResult as bool) {
                sTestTypeList.clear();
                this.selectedTestTypeList.forEach((element) {
                  if (element.isSelected!) {
                    sTestTypeList.add(element.item!);
                  }
                });

                setState(() {
                  this.page = 0;
                  this.cpkPinsList = this
                      .cpkPinsDTO!
                      .data!
                      .where(
                          (element) => sTestTypeList.contains(element.testType))
                      .toList();
                  this.cpkTestNameController.webViewController.reload();
                });
              }
            }
          },
          child: Image.asset(
            theme_dark!
                ? Constants.ASSET_IMAGES + 'filter_icon.png'
                : Constants.ASSET_IMAGES_LIGHT + 'filter_icon.png',
          ),
        ),
        SizedBox(width: 12.0),
        InkWell(
          onTap: () {
            showDownloadCsvPopup(ctx);
          },
          child: Image.asset(
            theme_dark!
                ? Constants.ASSET_IMAGES + 'download_bttn.png'
                : Constants.ASSET_IMAGES_LIGHT + 'download_bttn.png',
          ),
        ),
      ],
    );
  }

  Widget pinSorting(BuildContext ctx) {
    if (this.cpkPinsList.length > 0) {
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
                  border: Border.all(color: AppColors.appPrimaryWhite()),
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
                        color: AppColors.appPrimaryWhite(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                    SizedBox(width: 10.0),
                    Image.asset(Constants.ASSET_IMAGES + 'dropdown_icon.png'),
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
                        border: Border.all(color: AppColors.appPrimaryWhite()),
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
                              color: AppColors.appPrimaryWhite(),
                              decoration: TextDecoration.none,
                            ),
                          ),
                          SizedBox(width: 10.0),
                          Image.asset(theme_dark!
                              ? Constants.ASSET_IMAGES + 'dropdown_icon.png'
                              : Constants.ASSET_IMAGES_LIGHT + 'dropdown.png'),
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

  Widget pinDataListing(BuildContext ctx) {
    if (this.cpkPinsList.length > 0) {
      return Container(
        margin: EdgeInsets.only(top: 30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List<Widget>.generate(
                  this.cpkPinsList.length < ((page * pageSize) + pageSize)
                      ? this.cpkPinsList.length
                      : ((page * pageSize) + pageSize), (index) {
                return pinDataItem(ctx, this.cpkPinsList[index]);
              }),
            ),
            SizedBox(height: 10.0),
            GestureDetector(
              onTap: () {
                setState(() {
                  this.page += 1;
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    Utils.getTranslated(ctx, 'view_more')!,
                    style: AppFonts.robotoMedium(
                      14,
                      color: AppColors.appBlue(),
                      decoration: TextDecoration.none,
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Image.asset(Constants.ASSET_IMAGES + 'view_more_icon.png'),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Container();
  }

  Widget pinDataItem(
      BuildContext ctx, TestResultCpkPinsShortsTestJetDataDTO dataDTO) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          ctx,
          AppRoutes.dqmTestResultAnalogInfoDetailRoute,
          arguments: DqmTestResultArguments(pinsDataDTO: dataDTO),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12.0),
        padding: EdgeInsets.fromLTRB(12.0, 13.0, 12.0, 13.0),
        decoration: BoxDecoration(
          color: (dataDTO.hasFailure!)
              ? AppColors.appRed78()
              : AppColors.appBlackLight(),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dataDTO.testType!,
                  style: AppFonts.robotoMedium(
                    13,
                    color: theme_dark!
                        ? AppColors.appGreyDE()
                        : AppColorsLightMode.appGrey(),
                    decoration: TextDecoration.none,
                  ),
                ),
                SizedBox(width: 14.0),
                Text(
                  '|',
                  style: AppFonts.robotoMedium(
                    13,
                    color: AppColors.appGreyA3(),
                    decoration: TextDecoration.none,
                  ),
                ),
                SizedBox(width: 14.0),
                Text(
                  dataDTO.testName!,
                  style: AppFonts.robotoMedium(
                    13,
                    color: theme_dark!
                        ? AppColors.appGreyDE()
                        : AppColorsLightMode.appGrey(),
                    decoration: TextDecoration.none,
                  ),
                ),
              ],
            ),
            SizedBox(height: 15.0),
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
                        Utils.getTranslated(
                            ctx, 'dqm_testresult_analog_sortby_cpk')!,
                        style: AppFonts.robotoRegular(
                          13,
                          color: theme_dark!
                              ? AppColors.appGreyB1()
                              : AppColorsLightMode.appGrey77(),
                          decoration: TextDecoration.none,
                        ),
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        dataDTO.cpk != null
                            ? dataDTO.cpk!.toDouble().toStringAsFixed(2)
                            : '-',
                        style: AppFonts.robotoMedium(
                          17,
                          color: theme_dark!
                              ? AppColors.appGreyDE()
                              : AppColorsLightMode.appGrey(),
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 15.0),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Utils.getTranslated(
                            ctx, "dqm_testresult_pins_detail_brcc")!,
                        style: AppFonts.robotoRegular(
                          13,
                          color: theme_dark!
                              ? AppColors.appGreyB1()
                              : AppColorsLightMode.appGrey77(),
                          decoration: TextDecoration.none,
                        ),
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        dataDTO.brcc != null ? '${dataDTO.brcc}' : '-',
                        style: AppFonts.robotoMedium(
                          17,
                          color: theme_dark!
                              ? AppColors.appGreyDE()
                              : AppColorsLightMode.appGrey(),
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 15.0),
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
                        Utils.getTranslated(ctx, 'dqm_testresult_minimum')!,
                        style: AppFonts.robotoRegular(
                          13,
                          color: theme_dark!
                              ? AppColors.appGreyB1()
                              : AppColorsLightMode.appGrey77(),
                          decoration: TextDecoration.none,
                        ),
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        dataDTO.min != null ? '${dataDTO.min!}' : '-',
                        style: AppFonts.robotoMedium(
                          17,
                          color: theme_dark!
                              ? AppColors.appGreyDE()
                              : AppColorsLightMode.appGrey(),
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 15.0),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Utils.getTranslated(ctx, 'dqm_testresult_maximum')!,
                        style: AppFonts.robotoRegular(
                          13,
                          color: theme_dark!
                              ? AppColors.appGreyB1()
                              : AppColorsLightMode.appGrey77(),
                          decoration: TextDecoration.none,
                        ),
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        dataDTO.max != null ? '${dataDTO.max}' : '-',
                        style: AppFonts.robotoMedium(
                          17,
                          color: theme_dark!
                              ? AppColors.appGreyDE()
                              : AppColorsLightMode.appGrey(),
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 15.0),
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
                        Utils.getTranslated(
                            ctx, 'dqm_testresult_analog_detail_threshold')!,
                        style: AppFonts.robotoRegular(
                          13,
                          color: theme_dark!
                              ? AppColors.appGreyB1()
                              : AppColorsLightMode.appGrey77(),
                          decoration: TextDecoration.none,
                        ),
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        dataDTO.threshold != null
                            ? '${dataDTO.threshold}'
                            : '-',
                        style: AppFonts.robotoMedium(
                          17,
                          color: theme_dark!
                              ? AppColors.appGreyDE()
                              : AppColorsLightMode.appGrey(),
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget pinCPkTestname(BuildContext ctx) {
    String tt = this.sTestTypeList.length > 0
        ? this.sTestTypeList.join(",")
        : this.selectedTestTypeList.map((e) => e.item).toList().join(",");
    return Container(
      margin: EdgeInsets.only(top: 50.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              '${Utils.getTranslated(ctx, 'dqm_testresult_analog_cpk_testname')!} ($tt)',
              style: AppFonts.robotoMedium(
                14,
                color: theme_dark!
                    ? AppColors.appGreyD3()
                    : AppColorsLightMode.appGrey(),
                decoration: TextDecoration.none,
              ),
            ),
          ),
          SizedBox(width: 20),
          InkWell(
            onTap: () async {
              if (this.cpkPinsDTO != null &&
                  this.cpkPinsDTO!.data != null &&
                  this.cpkPinsDTO!.data!.length > 0) {
                final navResult = await Navigator.pushNamed(
                  ctx,
                  AppRoutes.dqmTestResultAnalogCpkFilterRoute,
                  arguments: DqmAnalogSigmaArguments(
                    sigmaType: this.filterSigma,
                  ),
                );

                if (navResult != null) {
                  if (Utils.isNotEmpty(navResult as String)) {
                    setState(() {
                      this.filterSigma = navResult;
                      this.cpkTestNameController.webViewController.reload();
                    });
                  }
                }
              }
            },
            child: Image.asset(
              theme_dark!
                  ? Constants.ASSET_IMAGES + 'filter_icon.png'
                  : Constants.ASSET_IMAGES_LIGHT + 'filter_icon.png',
            ),
          ),
          SizedBox(width: 20),
          InkWell(
            onTap: () {
              showDownloadPopup(ctx);
            },
            child: Image.asset(
              theme_dark!
                  ? Constants.ASSET_IMAGES + 'download_bttn.png'
                  : Constants.ASSET_IMAGES_LIGHT + 'download_bttn.png',
            ),
          ),
        ],
      ),
    );
  }

  Widget pinCPKTestnameChart(BuildContext ctx) {
    return Container(
      width: MediaQuery.of(ctx).size.width,
      margin: EdgeInsets.only(top: 30),
      padding: EdgeInsets.fromLTRB(14.0, 18.0, 14.0, 18.0),
      decoration: BoxDecoration(
          color: theme_dark!
              ? AppColors.appBlackLight()
              : AppColors.appPrimaryWhite(),
          border: Border.all(
            color:
                theme_dark! ? AppColors.appBlackLight() : AppColors.appGreyDE(),
          )),
      child: Container(
        width: MediaQuery.of(ctx).size.width,
        height: this.chartCTNHeight,
        color: Colors.transparent,
        child: this.cpkPinsList.length > 0
            ? WebViewPlus(
                backgroundColor: Colors.transparent,
                javascriptMode: JavascriptMode.unrestricted,
                initialUrl: theme_dark!
                    ? 'assets/html/highchart_dark_theme.html'
                    : 'assets/html/highchart_light_theme.html',
                zoomEnabled: false,
                gestureRecognizers: Set()
                  ..add(Factory<VerticalDragGestureRecognizer>(
                      () => VerticalDragGestureRecognizer()))
                  ..add(Factory<ScaleGestureRecognizer>(
                      () => ScaleGestureRecognizer())),
                onWebViewCreated: (controllerPlus) {
                  this.cpkTestNameController = controllerPlus;
                },
                onPageFinished: (url) {
                  this.cpkTestNameController.getHeight().then((value) {
                    setState(() {
                      this.chartCTNHeight = value;
                    });
                  });
                },
                javascriptChannels: [
                  JavascriptChannel(
                      name: 'DQMChannel',
                      onMessageReceived: (message) {
                        this.cpkTestNameController.webViewController.runJavascript(
                            'fetchCpkPinsByTestNameData(${jsonEncode(this.cpkPinsList)}, "${this.filterSigma}", "${Utils.getTranslated(ctx, 'chart_footer_testname_cpk')}")');
                      }),
                  JavascriptChannel(
                      name: 'DQMPinsCpkTestNameChannel',
                      onMessageReceived: (message) {
                        print(message.message);
                        this.jsSigmaDataDTO = JSCpkSigmaDataDTO.fromJson(
                            jsonDecode(message.message));
                        this.isShowAnalogSigma = true;
                      }),
                  JavascriptChannel(
                      name: 'DQMPinsCpkTestNameClickChannel',
                      onMessageReceived: (message) {
                        print(message.message);
                        if (Utils.isNotEmpty(message.message)) {
                          JSTestNameCpkDataDTO jsTestNameCpkDataDTO =
                              JSTestNameCpkDataDTO.fromJson(
                                  jsonDecode(message.message));
                          showTestNameCpkTooltipsDialog(
                              ctx, jsTestNameCpkDataDTO);
                        }
                      }),
                  JavascriptChannel(
                      name: 'DQMExportImageChannel',
                      onMessageReceived: (message) async {
                        print(message.message);
                        if (Utils.isNotEmpty(message.message)) {
                          String name = 'pinCPKTestnameChart.png';

                          final result = await ImageApi.generateImage(
                              message.message,
                              600,
                              this.chartCTNHeight.round(),
                              name);
                          if (result != null && result == true) {
                            setState(() {
                              // print('################## hihi');
                              var snackBar = SnackBar(
                                content: Text(
                                  Utils.getTranslated(
                                      context, 'done_download_as_image')!,
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
                          String name = 'pinCPKTestnameChart.pdf';

                          final result = await PdfApi.generatePDF(
                              message.message,
                              600,
                              this.chartCTNHeight.round(),
                              name);
                          if (result != null && result == true) {
                            setState(() {
                              // print('################## hihi');
                              var snackBar = SnackBar(
                                content: Text(
                                  Utils.getTranslated(
                                      context, 'done_download_as_pdf')!,
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
                  Utils.getTranslated(ctx, 'no_data_available')!,
                  style: AppFonts.robotoRegular(
                    16,
                    color: theme_dark!
                        ? AppColors.appGreyB1()
                        : AppColorsLightMode.appGrey77().withOpacity(0.4),
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
      ),
    );
  }

  Widget pinSigma(BuildContext ctx) {
    if (this.isShowAnalogSigma) {
      return Container(
        margin: EdgeInsets.only(top: 10.0),
        padding: EdgeInsets.all(14.0),
        decoration: BoxDecoration(
          color: AppColors.appBlackLight(),
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 4,
                  child: Text(
                    '${this.jsSigmaDataDTO.otherSigma}',
                    style: AppFonts.robotoRegular(14,
                        color: theme_dark!
                            ? AppColors.appGreyB1()
                            : AppColorsLightMode.appGrey77(),
                        decoration: TextDecoration.none),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    ': ${this.jsSigmaDataDTO.otherSigmaValue}%',
                    style: AppFonts.robotoRegular(14,
                        color: theme_dark!
                            ? AppColors.appGreyB1()
                            : AppColorsLightMode.appGrey77(),
                        decoration: TextDecoration.none),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 4,
                  child: Text(
                    '${this.jsSigmaDataDTO.sixSigma}',
                    style: AppFonts.robotoRegular(14,
                        color: theme_dark!
                            ? AppColors.appGreyB1()
                            : AppColorsLightMode.appGrey77(),
                        decoration: TextDecoration.none),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    ': ${this.jsSigmaDataDTO.sixSigmaValue}%',
                    style: AppFonts.robotoRegular(14,
                        color: theme_dark!
                            ? AppColors.appGreyB1()
                            : AppColorsLightMode.appGrey77(),
                        decoration: TextDecoration.none),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 4,
                  child: Text(
                    '${this.jsSigmaDataDTO.fiveSigma}',
                    style: AppFonts.robotoRegular(14,
                        color: theme_dark!
                            ? AppColors.appGreyB1()
                            : AppColorsLightMode.appGrey77(),
                        decoration: TextDecoration.none),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    ': ${this.jsSigmaDataDTO.fiveSigmaValue}%',
                    style: AppFonts.robotoRegular(14,
                        color: theme_dark!
                            ? AppColors.appGreyB1()
                            : AppColorsLightMode.appGrey77(),
                        decoration: TextDecoration.none),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 4,
                  child: Text(
                    '${this.jsSigmaDataDTO.fourSigma}',
                    style: AppFonts.robotoRegular(14,
                        color: theme_dark!
                            ? AppColors.appGreyB1()
                            : AppColorsLightMode.appGrey77(),
                        decoration: TextDecoration.none),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    ': ${this.jsSigmaDataDTO.fourSigmaValue}%',
                    style: AppFonts.robotoRegular(14,
                        color: theme_dark!
                            ? AppColors.appGreyB1()
                            : AppColorsLightMode.appGrey77(),
                        decoration: TextDecoration.none),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 4,
                  child: Text(
                    '${this.jsSigmaDataDTO.threeSigma}',
                    style: AppFonts.robotoRegular(14,
                        color: theme_dark!
                            ? AppColors.appGreyB1()
                            : AppColorsLightMode.appGrey77(),
                        decoration: TextDecoration.none),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    ': ${this.jsSigmaDataDTO.threeSigmaValue}%',
                    style: AppFonts.robotoRegular(14,
                        color: theme_dark!
                            ? AppColors.appGreyB1()
                            : AppColorsLightMode.appGrey77(),
                        decoration: TextDecoration.none),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    return Container();
  }

  void showTestNameCpkTooltipsDialog(
      BuildContext context, JSTestNameCpkDataDTO testNameCpkDataDTO) {
    showDialog(
      context: context,
      builder: (tooltipsDialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: chartTooltipsInfo(context, testNameCpkDataDTO),
        );
      },
    );
  }

  Widget chartTooltipsInfo(
      BuildContext ctx, JSTestNameCpkDataDTO testNameCpkDataDTO) {
    return Container(
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
            testNameCpkDataDTO.testname!,
            style: AppFonts.robotoMedium(
              14,
              color: AppColors.appPrimaryWhite(),
              decoration: TextDecoration.none,
            ),
          ),
          SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${testNameCpkDataDTO.sigmaType}: ',
                style: AppFonts.robotoMedium(
                  14,
                  color: HexColor(testNameCpkDataDTO.colorCode!.substring(0)),
                  decoration: TextDecoration.none,
                ),
              ),
              SizedBox(width: 11.0),
              Text(
                '${testNameCpkDataDTO.value}',
                style: AppFonts.robotoRegular(
                  16,
                  color: theme_dark!
                      ? AppColors.appGrey2()
                      : AppColorsLightMode.appGrey2(),
                  decoration: TextDecoration.none,
                ),
              ),
            ],
          ),
        ],
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

                String name = "analog.csv";
                final result = await CSVApi.generateCSV(cpkPinsList, name);
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
                    .cpkTestNameController
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

                String name = "pinCPKTestnameChart.csv";
                final result = await CSVApi.generateCSV(cpkPinsList, name);
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
                    .cpkTestNameController
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
                  sortBy = Utils.getTranslated(
                      context, 'dqm_testresult_analog_sortby_indicator')!;
                  this.sortType = Constants.SORT_BY_INDICATOR;
                  sortAnalogCpkList();
                });
                Navigator.pop(popContext);
              },
              child: Text(
                Utils.getTranslated(
                    context, 'dqm_testresult_analog_sortby_indicator')!,
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
                  sortBy = Utils.getTranslated(
                      context, 'dqm_testresult_pins_detail_node')!;
                  this.sortType = Constants.SORT_BY_SOURCE;
                  sortAnalogCpkList();
                });
                Navigator.pop(popContext);
              },
              child: Text(
                Utils.getTranslated(
                    context, 'dqm_testresult_pins_detail_node')!,
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
                  sortBy = Utils.getTranslated(
                      context, 'dqm_testresult_analog_sortby_cpk')!;
                  this.sortType = Constants.SORT_BY_CPK;
                  sortAnalogCpkList();
                });
                Navigator.pop(popContext);
              },
              child: Text(
                Utils.getTranslated(
                    context, 'dqm_testresult_analog_sortby_cpk')!,
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
                  sortBy = Utils.getTranslated(
                      context, 'dqm_testresult_pins_detail_brcc')!;
                  this.sortType = Constants.SORT_BY_DESTINATION;
                  sortAnalogCpkList();
                });
                Navigator.pop(popContext);
              },
              child: Text(
                Utils.getTranslated(
                    context, 'dqm_testresult_pins_detail_brcc')!,
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
                      Utils.getTranslated(context, 'dqm_testresult_minimum')!;
                  this.sortType = Constants.SORT_BY_MIN;
                  sortAnalogCpkList();
                });
                Navigator.pop(popContext);
              },
              child: Text(
                Utils.getTranslated(context, 'dqm_testresult_minimum')!,
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
                      Utils.getTranslated(context, 'dqm_testresult_maximum')!;
                  this.sortType = Constants.SORT_BY_MAX;
                  sortAnalogCpkList();
                });
                Navigator.pop(popContext);
              },
              child: Text(
                Utils.getTranslated(context, 'dqm_testresult_maximum')!,
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
