import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:keysight_pma/cache/appcache.dart';
import 'package:keysight_pma/const/appcolors.dart';
import 'package:keysight_pma/const/appfonts.dart';
import 'package:keysight_pma/const/constants.dart';
import 'package:keysight_pma/const/utils.dart';
import 'package:keysight_pma/dio/api/dqm.dart';
import 'package:keysight_pma/dio/api/sort_filter.dart';
import 'package:keysight_pma/model/arguments/dqm_argument.dart';
import 'package:keysight_pma/model/arguments/sort_filter_argument.dart';
import 'package:keysight_pma/model/dqm/boardresult_summary_byproject.dart';
import 'package:keysight_pma/model/dqm/failure_component_by_fixture.dart';
import 'package:keysight_pma/model/dqm/test_time_distribution.dart';
import 'package:keysight_pma/model/sortAndFilter/equipment.dart';
import 'package:keysight_pma/model/sortAndFilter/project_version_by_category.dart';
import 'package:keysight_pma/model/sortAndFilter/projects.dart';
import 'package:keysight_pma/routes/approutes.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

class TestResultSummaryScreen extends StatefulWidget {
  final Function() notifyParent;
  TestResultSummaryScreen({Key? key, required this.notifyParent})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TestResultSummaryScreen();
  }
}

class _TestResultSummaryScreen extends State<TestResultSummaryScreen> {
  late BoardResultSummaryByProjectDataDTO boardResultDataDTO;
  late TestTimeDistributionDataDTO testTimeDistributionDataDTO;
  late DqmFailureComponentDTO failureComponentDTO;
  bool isLoading = true;
  double chartVYHeight = 316.0;
  double chartTTDHeight = 316.0;
  double chartFDHeight = 316.0;
  double chartTTHeight = 316.0;
  bool? theme_dark = AppCache.sortFilterCacheDTO!.currentTheme;
  late WebViewPlusController volumeAndYieldController;
  late WebViewPlusController testTimeController;
  late WebViewPlusController firstFailController;
  late WebViewPlusController failureCountController;
  late Map<String?, List<FinalDispositionStructDataDTO>> finalDispositionMap;
  late Map<String?, List<DqmFailureComponentDataDTO>> testTypeFailureMap;

  Future<ProjectsDTO> loadProjectList(BuildContext ctx) {
    SortFilterApi sortFilterApi = SortFilterApi(ctx);
    return sortFilterApi.loadProjectList(
        AppCache.sortFilterCacheDTO!.preferredCompany!,
        AppCache.sortFilterCacheDTO!.preferredSite!);
  }

  Future<ProjectVersionByCategoryDTO> loadProjectVersionByCategory(
      BuildContext ctx, String projectId) {
    SortFilterApi sortFilterApi = SortFilterApi(ctx);
    return sortFilterApi.loadProjectVersionByCategory(
        AppCache.sortFilterCacheDTO!.preferredCompany!,
        AppCache.sortFilterCacheDTO!.preferredSite!,
        projectId);
  }

  Future<EquipmentDTO> loadEquipments(BuildContext ctx) {
    SortFilterApi sortFilterApi = SortFilterApi(ctx);
    return sortFilterApi.loadEquipments(
        AppCache.sortFilterCacheDTO!.preferredCompany!,
        AppCache.sortFilterCacheDTO!.preferredSite!);
  }

  Future<BoardResultSummaryByProjectDTO> getBoardResultSummaryListByProject(
      BuildContext context) {
    String companyId = AppCache.sortFilterCacheDTO!.preferredCompany!;
    String siteId = AppCache.sortFilterCacheDTO!.preferredSite!;
    String startDate = DateFormat("yyyy-MM-dd")
        .format(AppCache.sortFilterCacheDTO!.startDate!);
    String endDate =
        DateFormat("yyyy-MM-dd").format(AppCache.sortFilterCacheDTO!.endDate!);
    List<String?> equipments = AppCache.sortFilterCacheDTO!.defaultEquipments!
        .where((element) => element.isSelected!)
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
    return dqmApi.getBoardResultSummaryListByProject(
        companyId, siteId, startDate, endDate, equipments, projectId);
  }

  Future<TestTimeDistributionDTO> getTestTimeDistribution(
      BuildContext context) {
    String companyId = AppCache.sortFilterCacheDTO!.preferredCompany!;
    String siteId = AppCache.sortFilterCacheDTO!.preferredSite!;
    String startDate = DateFormat("yyyy-MM-dd")
        .format(AppCache.sortFilterCacheDTO!.startDate!);
    String endDate =
        DateFormat("yyyy-MM-dd").format(AppCache.sortFilterCacheDTO!.endDate!);
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
    return dqmApi.getTestTimeDistribution(
        companyId, siteId, startDate, endDate, equipments, projectId);
  }

  Future<DqmFailureComponentDTO> getListComponentFailureByFixture(
      BuildContext context, String mode) {
    String companyId = AppCache.sortFilterCacheDTO!.preferredCompany!;
    String siteId = AppCache.sortFilterCacheDTO!.preferredSite!;
    String startDate = DateFormat("yyyy-MM-dd")
        .format(AppCache.sortFilterCacheDTO!.startDate!);
    String endDate =
        DateFormat("yyyy-MM-dd").format(AppCache.sortFilterCacheDTO!.endDate!);
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
    return dqmApi.getListComponentFailureByFixture(
        companyId, siteId, startDate, endDate, equipments, projectId, mode);
  }

  @override
  void initState() {
    super.initState();
    Utils.setFirebaseAnalyticsCurrentScreen(
        Constants.ANALYTICS_DQM_TEST_RESULT_SUMMARY_SCREEN);
    FocusManager.instance.primaryFocus?.unfocus();
    if (AppCache.sortFilterCacheDTO != null) {
      if (Utils.isNotEmpty(AppCache.sortFilterCacheDTO!.preferredProjectId)) {
        if (AppCache.sortFilterCacheDTO!.preferredProjectId!.contains('<')) {
          List<String> splitedList =
              AppCache.sortFilterCacheDTO!.preferredProjectId!.split('<');
          AppCache.sortFilterCacheDTO!.defaultProjectId = splitedList[0];
          AppCache.sortFilterCacheDTO!.displayProjectName = splitedList[0];
          if (Utils.isNotEmpty(splitedList[1])) {
            AppCache.sortFilterCacheDTO!.defaultVersion = splitedList[1];
          } else {
            AppCache.sortFilterCacheDTO!.defaultVersion = 'Base';
          }
        }
        callLoadEquipments(context);
        // callGetBoardResultSummaryListByProject(context);
      } else {
        if (Utils.isNotEmpty(AppCache.sortFilterCacheDTO!.defaultProjectId)) {
          if (AppCache.sortFilterCacheDTO!.defaultEquipments == null ||
              AppCache.sortFilterCacheDTO!.defaultEquipments!.length == 0) {
            callLoadEquipments(context);
          } else {
            callGetBoardResultSummaryListByProject(context);
          }
        } else {
          callLoadProjectList(context);
        }
      }
    }
  }

  callLoadProjectList(BuildContext context) async {
    await loadProjectList(context).then((value) {
      if (value.status!.statusCode == 200) {
        if (value.data != null && value.data!.length > 0) {
          AppCache.sortFilterCacheDTO!.defaultProjectId =
              value.data![0].projectId!;
          if (Utils.isNotEmpty(value.data![0].projectName)) {
            AppCache.sortFilterCacheDTO!.displayProjectName =
                '${value.data![0].projectName} (${value.data![0].projectId})';
          } else {
            AppCache.sortFilterCacheDTO!.displayProjectName =
                value.data![0].projectId!;
          }
        }
        callLoadProjectVersion(
            context, AppCache.sortFilterCacheDTO!.defaultProjectId!);
      } else {
        setState(() {
          this.isLoading = false;
        });
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
      setState(() {
        this.isLoading = false;
      });
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

  callLoadProjectVersion(BuildContext context, String projectId) async {
    await loadProjectVersionByCategory(context, projectId).then((value) {
      if (value.status!.statusCode == 200) {
        if (value.data != null && value.data!.length > 0) {
          if (!Utils.isNotEmpty(AppCache.sortFilterCacheDTO!.defaultVersion)) {
            AppCache.sortFilterCacheDTO!.defaultVersion =
                value.data![0].version;
            AppCache.sortFilterCacheDTO!.projectVersionObj = value.data![0];
          }
        }

        if (AppCache.sortFilterCacheDTO!.defaultEquipments == null ||
            AppCache.sortFilterCacheDTO!.defaultEquipments!.length == 0) {
          callLoadEquipments(context);
        } else {
          callGetBoardResultSummaryListByProject(context);
        }
      } else {
        setState(() {
          this.isLoading = false;
        });
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
      setState(() {
        this.isLoading = false;
      });
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
        EasyLoading.dismiss();
      });
    });
  }

  callLoadEquipments(BuildContext context) async {
    await loadEquipments(context).then((value) {
      if (value.status!.statusCode == 200) {
        if (value.data != null && value.data!.length > 0) {
          AppCache.sortFilterCacheDTO!.defaultEquipments = [];
          value.data!.forEach((element) {
            EquipmentDataDTO equipmentDataDTO = EquipmentDataDTO(
                equipmentId: element.equipmentId,
                equipmentName: element.equipmentName,
                isSelected: true);
            AppCache.sortFilterCacheDTO!.defaultEquipments!
                .add(equipmentDataDTO);
          });
        }
        callGetBoardResultSummaryListByProject(context);
      } else {
        setState(() {
          this.isLoading = false;
        });
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
      setState(() {
        this.isLoading = false;
      });
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

  callGetBoardResultSummaryListByProject(BuildContext context) async {
    await getBoardResultSummaryListByProject(context).then((value) {
      if (value.status!.statusCode == 200) {
        if (value.data != null) {
          this.boardResultDataDTO = value.data!;
          if (this.boardResultDataDTO.finalDispositionStruct != null &&
              this.boardResultDataDTO.finalDispositionStruct!.length > 0) {
            groupByLastStatusData(
                this.boardResultDataDTO.finalDispositionStruct!);
          }
        }
        callGetTestTimeDistribution(context);
      } else {
        setState(() {
          this.isLoading = false;
          if (EasyLoading.isShow) {
            EasyLoading.dismiss();
          }
        });
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
      setState(() {
        this.isLoading = false;
        if (EasyLoading.isShow) {
          EasyLoading.dismiss();
        }
      });
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

  callGetTestTimeDistribution(BuildContext context) async {
    await getTestTimeDistribution(context).then((value) {
      if (value.status!.statusCode == 200) {
        if (value.data != null) {
          this.testTimeDistributionDataDTO = value.data!;
        }
        callGetListComponentFailureByFixture(context);
      } else {
        setState(() {
          this.isLoading = false;
          if (EasyLoading.isShow) {
            EasyLoading.dismiss();
          }
        });
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
      setState(() {
        this.isLoading = false;
        if (EasyLoading.isShow) {
          EasyLoading.dismiss();
        }
      });
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

  callGetListComponentFailureByFixture(BuildContext context) async {
    await getListComponentFailureByFixture(context, '').then((value) {
      if (value.status!.statusCode == 200) {
        this.failureComponentDTO = value;
        if (value.data != null && value.data!.length > 0) {
          groupDataByFixtureId(value.data!);
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
      widget.notifyParent();
      setState(() {
        this.isLoading = false;
        if (EasyLoading.isShow) {
          EasyLoading.dismiss();
        }
      });
    });
  }

  void groupByLastStatusData(List<FinalDispositionStructDataDTO> data) {
    final groups = groupBy(data, (FinalDispositionStructDataDTO e) {
      return e.lastStatus;
    });

    setState(() {
      this.finalDispositionMap = groups;
    });
  }

  void groupDataByFixtureId(List<DqmFailureComponentDataDTO> data) {
    final groups = groupBy(data, (DqmFailureComponentDataDTO e) {
      return e.fixtureId;
    });

    setState(() {
      this.testTypeFailureMap = groups;
    });
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
                        summaryData(context),
                        volumeAndYieldByEquipmentChart(context),
                        passTestTimeDistributionChart(context),
                        firstFailFinalDispositionChart(context),
                        failureCountByTestTypeAndFixtureIdChart(context),
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
                          widget.notifyParent();
                          setState(() {
                            EasyLoading.show(
                                maskType: EasyLoadingMaskType.black);
                            callGetBoardResultSummaryListByProject(context);
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

  Widget summaryData(BuildContext ctx) {
    String totalVolume = '-';
    String totalSerialNumber = '-';
    String firstPassYield = '-';
    String finalYield = '-';
    String totalEquipment = '-';
    String totalFixture = '-';
    String totalTestName = '-';
    String totalTestTime = '-';
    if (this.boardResultDataDTO.projectSummary != null) {
      totalVolume = this
          .boardResultDataDTO
          .projectSummary!
          .totalVolume!
          .toInt()
          .toString();
      totalSerialNumber = this
          .boardResultDataDTO
          .projectSummary!
          .totalVolumeBySerialNumber!
          .toInt()
          .toString();
      firstPassYield =
          this.boardResultDataDTO.projectSummary!.firstPassYield.toString();
      finalYield =
          this.boardResultDataDTO.projectSummary!.finalYield.toString();
      totalEquipment = this
          .boardResultDataDTO
          .projectSummary!
          .totalEquipment!
          .toInt()
          .toString();
      totalFixture = this
          .boardResultDataDTO
          .projectSummary!
          .totalFixture!
          .toInt()
          .toString();
      totalTestName = this
          .boardResultDataDTO
          .projectSummary!
          .totalTestName!
          .toInt()
          .toString();
      totalTestTime = this.boardResultDataDTO.projectSummary!.totalTestTime!;
    }
    return Container(
      padding: EdgeInsets.fromLTRB(14.0, 16.0, 14.0, 16.0),
      decoration: BoxDecoration(
        color: theme_dark!
            ? AppColors.appBlackLight()
            : AppColors.appPrimaryWhite(),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Utils.getTranslated(ctx, 'dqm_testresult_summary')!,
            style: AppFonts.robotoRegular(
              16,
              color: theme_dark!
                  ? AppColors.appGrey2()
                  : AppColorsLightMode.appGrey(),
              decoration: TextDecoration.none,
            ),
          ),
          SizedBox(height: 6.0),
          summaryDataItem(
              ctx, 'dqm_testresult_gross_total_volume', totalVolume),
          summaryDataItem(ctx, 'dqm_testresult_total_volume_by_serial_number',
              totalSerialNumber),
          summaryDataItem(
              ctx, 'dqm_testresult_first_pass_yield', firstPassYield),
          summaryDataItem(ctx, 'dqm_testresult_final_yield', finalYield),
          summaryDataItem(
              ctx, 'dqm_testresult_total_equipment', totalEquipment),
          summaryDataItem(ctx, 'dqm_testresult_total_fixture', totalFixture),
          summaryDataItem(ctx, 'dqm_testresult_total_test_name', totalTestName),
          Utils.isNotEmpty(totalTestTime)
              ? summaryDataItem(
                  ctx, 'dqm_testresult_total_test_time', totalTestTime)
              : Container(),
        ],
      ),
    );
  }

  Widget summaryDataItem(BuildContext ctx, String dataName, String value) {
    return Container(
      margin: EdgeInsets.only(top: 7.0),
      padding: EdgeInsets.fromLTRB(19.0, 7.0, 19.0, 7.0),
      decoration: BoxDecoration(
        color: theme_dark!
            ? AppColors.appBlack33()
            : AppColorsLightMode.appGreyD1(),
        borderRadius: BorderRadius.circular(2.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              Utils.getTranslated(ctx, dataName)!,
              style: AppFonts.robotoMedium(
                13,
                color: theme_dark!
                    ? AppColors.appGreyDE()
                    : AppColorsLightMode.appGrey(),
                decoration: TextDecoration.none,
              ),
            ),
          ),
          Text(
            value,
            textAlign: TextAlign.right,
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
    );
  }

  Widget volumeAndYieldByEquipmentChart(BuildContext ctx) {
    return Container(
      width: MediaQuery.of(ctx).size.width,
      margin: EdgeInsets.only(top: 10.0),
      decoration: BoxDecoration(
        color: theme_dark!
            ? AppColors.appBlackLight()
            : AppColors.appPrimaryWhite(),
        border: Border.all(
          color:
              theme_dark! ? AppColors.appBlackLight() : AppColors.appGreyDE(),
        ),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(14.0, 16.0, 14.0, 0.0),
            child: Text(
              Utils.getTranslated(
                  ctx, 'dqm_testresult_volume_and_yield_by_equipment')!,
              style: AppFonts.robotoRegular(
                16,
                color: theme_dark!
                    ? AppColors.appGrey2()
                    : AppColorsLightMode.appGrey(),
                decoration: TextDecoration.none,
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: this.chartVYHeight,
            color: theme_dark!
                ? AppColors.appBlackLight()
                : AppColors.appPrimaryWhite(),
            child: (this.boardResultDataDTO.volumeByEquipment != null &&
                    this.boardResultDataDTO.volumeByEquipment!.length > 0)
                ? WebViewPlus(
                    backgroundColor: Colors.transparent,
                    javascriptMode: JavascriptMode.unrestricted,
                    initialUrl: theme_dark!
                        ? 'assets/html/highchart_dark_theme.html'
                        : 'assets/html/highchart_light_theme.html',
                    zoomEnabled: false,
                    onWebViewCreated: (controllerPlus) {
                      this.volumeAndYieldController = controllerPlus;
                    },
                    onPageFinished: (url) {
                      this.volumeAndYieldController.getHeight().then((value) {
                        Utils.printInfo(value);
                        setState(() {
                          this.chartVYHeight = value;
                        });
                      });
                    },
                    javascriptChannels: [
                      JavascriptChannel(
                          name: 'DQMChannel',
                          onMessageReceived: (message) {
                            this
                                .volumeAndYieldController
                                .webViewController
                                .runJavascript(
                                    'fetchVolumeAndYieldData(${jsonEncode(this.boardResultDataDTO)},  "${Utils.getTranslated(ctx, 'dqm_dashboard_finalyield')}", "${Utils.getTranslated(ctx, 'dqm_dashboard_firstpassyield')}", "${Utils.getTranslated(ctx, 'dqm_dashboard_fail')}", "${Utils.getTranslated(ctx, 'dqm_dashboard_retestpass')}", "${Utils.getTranslated(ctx, 'dqm_dashboard_firstpass')}", "${Utils.getTranslated(ctx, 'dqm_testresult_eq/vo')}")');
                          }),
                      JavascriptChannel(
                          name: 'DQMTestResultVolumeAndYieldChannel',
                          onMessageReceived: (message) {
                            Navigator.pushNamed(
                              ctx,
                              AppRoutes.dqmTestResultChartDetailRoute,
                              arguments: DqmTestResultArguments(
                                boardResultDataDTO: this.boardResultDataDTO,
                                fromWhere: Constants.TEST_RESULT_CHART_VOLUME,
                                appBarTitle: Utils.getTranslated(ctx,
                                    'dqm_testresult_volume_and_yield_by_equipment'),
                              ),
                            );
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
        ],
      ),
    );
  }

  Widget passTestTimeDistributionChart(BuildContext ctx) {
    return Container(
      width: MediaQuery.of(ctx).size.width,
      margin: EdgeInsets.only(top: 10.0),
      decoration: BoxDecoration(
        color: theme_dark!
            ? AppColors.appBlackLight()
            : AppColors.appPrimaryWhite(),
        border: Border.all(
          color:
              theme_dark! ? AppColors.appBlackLight() : AppColors.appGreyDE(),
        ),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(14.0, 16.0, 14.0, 0.0),
            child: Text(
              Utils.getTranslated(
                  ctx, 'dqm_testresult_pass_test_time_distribution')!,
              style: AppFonts.robotoRegular(
                16,
                color: theme_dark!
                    ? AppColors.appGrey2()
                    : AppColorsLightMode.appGrey(),
                decoration: TextDecoration.none,
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: this.chartTTDHeight,
            color: theme_dark!
                ? AppColors.appBlackLight()
                : AppColors.appPrimaryWhite(),
            child: (this.testTimeDistributionDataDTO.pass != null &&
                    (this.testTimeDistributionDataDTO.pass!.boxPlotData !=
                            null &&
                        this
                                .testTimeDistributionDataDTO
                                .pass!
                                .boxPlotData!
                                .length >
                            0) &&
                    (this.testTimeDistributionDataDTO.pass!.pointData != null &&
                        this
                                .testTimeDistributionDataDTO
                                .pass!
                                .pointData!
                                .length >
                            0))
                ? WebViewPlus(
                    backgroundColor: Colors.transparent,
                    javascriptMode: JavascriptMode.unrestricted,
                    initialUrl: theme_dark!
                        ? 'assets/html/highchart_dark_theme.html'
                        : 'assets/html/highchart_light_theme.html',
                    zoomEnabled: false,
                    onWebViewCreated: (controllerPlus) {
                      this.testTimeController = controllerPlus;
                    },
                    onPageFinished: (url) {
                      this.testTimeController.getHeight().then((value) {
                        Utils.printInfo(value);
                        setState(() {
                          this.chartTTDHeight = value;
                        });
                      });
                    },
                    javascriptChannels: [
                      JavascriptChannel(
                          name: 'DQMChannel',
                          onMessageReceived: (message) {
                            this.testTimeController.webViewController.runJavascript(
                                'fetchTestTimeDistributionData(${jsonEncode(this.testTimeDistributionDataDTO)}, "${Utils.getTranslated(ctx, 'dqm_summary_testtimeanalysis')}", "${Utils.getTranslated(ctx, 'dqm_summary_outlier')}" )');
                          }),
                      JavascriptChannel(
                          name: 'DQMTestResultTestTimeChannel',
                          onMessageReceived: (message) {
                            Navigator.pushNamed(
                              ctx,
                              AppRoutes.dqmTestResultChartDetailRoute,
                              arguments: DqmTestResultArguments(
                                fromWhere:
                                    Constants.TEST_RESULT_CHART_TEST_TIME,
                                appBarTitle: Utils.getTranslated(ctx,
                                    'dqm_testresult_pass_test_time_distribution'),
                              ),
                            );
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
        ],
      ),
    );
  }

  Widget firstFailFinalDispositionChart(BuildContext ctx) {
    return Container(
      width: MediaQuery.of(ctx).size.width,
      margin: EdgeInsets.only(top: 10.0),
      decoration: BoxDecoration(
        color: theme_dark!
            ? AppColors.appBlackLight()
            : AppColors.appPrimaryWhite(),
        border: Border.all(
          color:
              theme_dark! ? AppColors.appBlackLight() : AppColors.appGreyDE(),
        ),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(14.0, 16.0, 14.0, 0.0),
            child: Text(
              Utils.getTranslated(
                  ctx, 'dqm_testresult_first_fail_final_disposition')!,
              style: AppFonts.robotoRegular(
                16,
                color: theme_dark!
                    ? AppColors.appGrey2()
                    : AppColorsLightMode.appGrey(),
                decoration: TextDecoration.none,
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: this.chartFDHeight,
            color: theme_dark!
                ? AppColors.appBlackLight()
                : AppColors.appPrimaryWhite(),
            child: (this.boardResultDataDTO.finalDispositionStruct != null &&
                    this.boardResultDataDTO.finalDispositionStruct!.length > 0)
                ? WebViewPlus(
                    backgroundColor: Colors.transparent,
                    javascriptMode: JavascriptMode.unrestricted,
                    initialUrl: theme_dark!
                        ? 'assets/html/highchart_dark_theme.html'
                        : 'assets/html/highchart_light_theme.html',
                    zoomEnabled: false,
                    onWebViewCreated: (controllerPlus) {
                      this.firstFailController = controllerPlus;
                    },
                    onPageFinished: (url) {
                      this.firstFailController.getHeight().then((value) {
                        Utils.printInfo(value);
                        setState(() {
                          this.chartFDHeight = value;
                        });
                      });
                    },
                    javascriptChannels: [
                      JavascriptChannel(
                          name: 'DQMChannel',
                          onMessageReceived: (message) {
                            this
                                .firstFailController
                                .webViewController
                                .runJavascript(
                                    'fetchFailFinalDispositionData(${jsonEncode(this.boardResultDataDTO)}, ${jsonEncode(this.finalDispositionMap)})');
                          }),
                      JavascriptChannel(
                          name: 'DQMTestResultFirstFailChannel',
                          onMessageReceived: (message) {
                            print(message.message);
                            Navigator.pushNamed(
                              ctx,
                              AppRoutes.dqmTestResultChartDetailRoute,
                              arguments: DqmTestResultArguments(
                                fromWhere: Constants
                                    .TEST_RESULT_CHART_FINAL_DISPOSITION,
                                appBarTitle: Utils.getTranslated(ctx,
                                    'dqm_testresult_first_fail_final_disposition'),
                              ),
                            );
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
        ],
      ),
    );
  }

  Widget failureCountByTestTypeAndFixtureIdChart(BuildContext ctx) {
    return Container(
      width: MediaQuery.of(ctx).size.width,
      margin: EdgeInsets.only(top: 10.0),
      decoration: BoxDecoration(
        color: theme_dark!
            ? AppColors.appBlackLight()
            : AppColors.appPrimaryWhite(),
        border: Border.all(
            color: theme_dark!
                ? AppColors.appBlackLight()
                : AppColors.appGreyDE()),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(14.0, 16.0, 14.0, 0.0),
            child: Text(
              Utils.getTranslated(ctx,
                  'dqm_testresult_failure_count_by_test_type_fixture_id_f')!,
              style: AppFonts.robotoRegular(
                16,
                color: theme_dark!
                    ? AppColors.appGrey2()
                    : AppColorsLightMode.appGrey(),
                decoration: TextDecoration.none,
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: this.chartTTHeight,
            color: theme_dark!
                ? AppColors.appBlackLight()
                : AppColors.appPrimaryWhite(),
            child: (this.failureComponentDTO.data != null &&
                    this.failureComponentDTO.data!.length > 0)
                ? WebViewPlus(
                    backgroundColor: Colors.transparent,
                    javascriptMode: JavascriptMode.unrestricted,
                    initialUrl: theme_dark!
                        ? 'assets/html/highchart_dark_theme.html'
                        : 'assets/html/highchart_light_theme.html',
                    zoomEnabled: false,
                    onWebViewCreated: (controllerPlus) {
                      this.failureCountController = controllerPlus;
                    },
                    onPageFinished: (url) {
                      this.failureCountController.getHeight().then((value) {
                        Utils.printInfo(value);
                        setState(() {
                          this.chartTTHeight = value;
                        });
                      });
                    },
                    javascriptChannels: [
                      JavascriptChannel(
                          name: 'DQMChannel',
                          onMessageReceived: (message) {
                            this
                                .failureCountController
                                .webViewController
                                .runJavascript(
                                    'fetchTestTypeFailureCountData(${jsonEncode(this.failureComponentDTO)}, ${jsonEncode(this.testTypeFailureMap)})');
                          }),
                      JavascriptChannel(
                          name: 'DQMTestResultComponentFailureChannel',
                          onMessageReceived: (message) {
                            Navigator.pushNamed(
                              ctx,
                              AppRoutes.dqmTestResultChartDetailRoute,
                              arguments: DqmTestResultArguments(
                                fromWhere: Constants
                                    .TEST_RESULT_CHART_COMPONENT_FAILURE,
                                appBarTitle: Utils.getTranslated(ctx,
                                    'dqm_testresult_failure_count_by_test_type_fixture_id_f'),
                              ),
                            );
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
              onPressed: () {
                Navigator.pop(csvContext);
              },
              child: Text(
                Utils.getTranslated(context, 'done_download_as_csv')!,
                style: AppFonts.robotoRegular(
                  15,
                  color: theme_dark!
                      ? AppColors.appPrimaryWhite().withOpacity(0.8)
                      : AppColors.appGrey(),
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
}
