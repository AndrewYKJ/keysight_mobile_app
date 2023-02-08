import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:keysight_pma/cache/appcache.dart';
import 'package:keysight_pma/const/appcolors.dart';
import 'package:keysight_pma/const/appfonts.dart';
import 'package:keysight_pma/const/constants.dart';
import 'package:keysight_pma/const/download.dart';
import 'package:keysight_pma/const/utils.dart';
import 'package:keysight_pma/controller/admin/preferred_setting/custom.dart';
import 'package:keysight_pma/dio/api/alert.dart';
import 'package:keysight_pma/model/alert/alertInfo_model.dart';
import 'package:keysight_pma/model/alert/alert_casehistory.dart';
import 'package:keysight_pma/model/alert/alert_cpk.dart';
import 'package:keysight_pma/model/alert/alert_detail.dart';
import 'package:keysight_pma/model/arguments/alert_routeTitle.dart';
import 'package:keysight_pma/model/arguments/search_argument.dart';
import 'package:keysight_pma/routes/approutes.dart';
import 'package:keysight_pma/widget/expandableWidget.dart';

class AlertCPKDetails extends StatefulWidget {
  final String title;
  final AlertCaseHistoryDataDTO data;

  AlertCPKDetails({Key? key, required this.title, required this.data})
      : super(key: key);

  @override
  State<AlertCPKDetails> createState() => _AlertCPKDetailsState();
}

class _AlertCPKDetailsState extends State<AlertCPKDetails> {
  ScrollController controller = ScrollController();
  bool isExpandedCard = false;
  bool isExpandedCpk = false;
  bool isLoading = true;
  int defaultList = 6;

  bool? theme_dark = AppCache.sortFilterCacheDTO!.currentTheme;
  int counterList = 6;
  int page = 0;
  int pageSize = 10;
  List<PDate> historyInfo = [
    PDate(
      rangeName: '07 May 2022 15:55',
      rangeValue: 'Workflow has been changed from todo to inPr…',
      tag: 'Workflow',
      rangeGroup: "Updated by Admin Kimatic",
    ),
    PDate(
      rangeName: '07 May 2022 15:55',
      rangeValue: 'Case has been edited.',
      tag: 'Edit Case',
      rangeGroup: "Updated by Admin Kimatic",
    ),
    PDate(
      rangeName: '07 May 2022 15:55',
      rangeValue: 'Case has been edited.',
      tag: 'Edit Case',
      rangeGroup: "Updated by Admin Kimatic",
    ),
  ];

  AlertOpenCaseDTO? openCaseData;
  List<PDate> alertInfo = [
    PDate(
      rangeName: 'ICT003',
      rangeValue: '2.54',
      rangeGroup: "1.55",
    ),
    PDate(
      rangeName: 'c122',
      rangeValue: '1.52',
      rangeGroup: "1.55",
    ),
    PDate(
      rangeName: 'c162',
      rangeValue: '1.02',
      rangeGroup: "1.55",
    ),
    PDate(
      rangeName: 'c122',
      rangeValue: '1.52',
      rangeGroup: "1.55",
    ),
    PDate(
      rangeName: 'c162',
      rangeValue: '1.02',
      rangeGroup: "1.55",
    ),
    PDate(
      rangeName: 'c122',
      rangeValue: '1.52',
      rangeGroup: "1.55",
    ),
    PDate(
      rangeName: 'c162',
      rangeValue: '1.02',
      rangeGroup: "1.55",
    ),
    PDate(
      rangeName: 'c162',
      rangeValue: '1.02',
      rangeGroup: "1.55",
    ),
    PDate(
      rangeName: 'c122',
      rangeValue: '1.52',
      rangeGroup: "1.55",
    ),
    PDate(
      rangeName: 'c162',
      rangeValue: '1.02',
      rangeGroup: "1.55",
    ),
  ];
  AlertInfo info = AlertInfo(
      company: 'Keysight',
      site: 'DemoSite',
      createdBy: 'Admin Kimatic',
      createdOn: '05 Apr 2021 12:21',
      modifiedBy: 'Admin Kimatic',
      modifiedDate: '05 Apr 2021 12:21',
      recentUpdate: 'Updated 5 minutes ago',
      alertDate: '05 Apr 2021 12:21',
      alertID: '20125191251',
      status: 'Dismiss',
      equipment: 'ICT003',
      subject: 'Approved by manager',
      description: null,
      assignedTo: 'Benjamin Leong',
      tag: 'Critical',
      workflow: 'Closed',
      message: 'Test coverage changes in Proj_BM from 2917 to 2916');
  AlertCpkDTO? cpkList;

  Future<AlertCpkDTO> getAlertCpk(
    BuildContext ctx,
  ) {
    AlertApi alertApi = AlertApi(ctx);
    String companyId = AppCache.sortFilterCacheDTO!.preferredCompany!;
    String siteId = AppCache.sortFilterCacheDTO!.preferredSite!;

    String projectId = AppCache.sortFilterCacheDTO!.defaultProjectId!;
    String timestamp = widget.data.timestamp!.replaceAll('-', '');
    String equipmentId = widget.data.equipmentId!;
    String fixturesId = widget.data.fixtureId!;

    return alertApi.getAlertCpk(
        companyId, siteId, projectId, equipmentId, fixturesId, timestamp);
  }

  Future<AlertOpenCaseDTO> openCase(
    BuildContext ctx,
  ) {
    AlertApi alertApi = AlertApi(ctx);
    String alertRowKey = widget.data.alertRowKey!;

    return alertApi.openCase(alertRowKey);
  }

  callCPKList(BuildContext context) async {
    await openCase(context).then((value) {
      if (value.status!.statusCode == 200) {
        openCaseData = value;
        print(openCaseData!.data);
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
    }).whenComplete(() {});
    await getAlertCpk(context).then((value) {
      if (value.status!.statusCode == 200) {
        cpkList = value;
        print(cpkList!.data![0]);
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
        // _dtSource = UserDataTableSource(
        //     userData: patRecommendDTO!.data!,
        //     onRowSelect: (int index) {
        //       print(index);
        //     },
        //     ctx: context);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    Utils.setFirebaseAnalyticsCurrentScreen(
        Constants.ANALYTICS_ALERT_REVIEW_CPK_LIST_SCREEN);
    setState(() {
      controller = ScrollController();
    });
    callCPKList(context);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var x = MediaQuery.of(context).size.height;
    print(x);
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
              theme_dark!
                  ? AppColors.serverAppBar()
                  : AppColorsLightMode.serverAppBar(),
              theme_dark!
                  ? AppColors.serverAppBar()
                  : AppColorsLightMode.serverAppBar(),
            ]))),
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          Utils.getTranslated(context, 'alert_information')!,
          style: AppFonts.robotoRegular(20,
              color: theme_dark!
                  ? AppColors.appGrey()
                  : AppColorsLightMode.appGrey(),
              decoration: TextDecoration.none),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Image.asset(
              theme_dark!
                  ? Constants.ASSET_IMAGES + 'back_bttn.png'
                  : Constants.ASSET_IMAGES_LIGHT + 'back_bttn.png',
            )),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.only(top: 26),
        color: theme_dark!
            ? AppColors.appPrimaryBlack()
            : AppColorsLightMode.appPrimaryBlack(),
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(AppColors.appBlue()),
                ),
              )
            : SingleChildScrollView(
                scrollDirection: Axis.vertical,
                controller: controller,
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                child: Column(
                  children: [
                    widget.data != null
                        ? ExpandaleCardContainer(
                            collapsedChild:
                                createCollapseColumn(context, widget.data),
                            expandedChild:
                                createExpandedColumn(context, widget.data),
                            isExpanded: isExpandedCard,
                          )
                        : Container(),
                    SizedBox(
                      height: widget.data != null ? 20 : 0,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 16),
                          child: Text(
                            Utils.getTranslated(
                                context, 'alertCPK_info_header')!,
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
                            // Padding(
                            //   padding: const EdgeInsets.only(right: 12),
                            //   child: GestureDetector(
                            //     child: Image.asset(
                            //         Constants.ASSET_IMAGES + 'filter_icon.png'),
                            //   ),
                            // ),
                            Padding(
                              padding: const EdgeInsets.only(right: 16),
                              child: GestureDetector(
                                onTap: () => showDownloadCsvPopup(context),
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

                    this.cpkList!.data!.length > 0
                        ? Container(
                            margin: EdgeInsets.only(top: 30.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: List<Widget>.generate(
                                      this.cpkList!.data!.length <
                                              ((page * pageSize) + pageSize)
                                          ? this.cpkList!.data!.length
                                          : ((page * pageSize) + pageSize),
                                      (index) {
                                    return dataItem(context,
                                        cpkList!.data![index], counterList);
                                  }),
                                ),
                                SizedBox(height: 10.0),
                                this.cpkList!.data!.length >
                                        ((page * pageSize) + pageSize)
                                    ? GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            this.page += 1;
                                          });
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              Utils.getTranslated(
                                                  context, 'view_more')!,
                                              style: AppFonts.robotoMedium(
                                                14,
                                                color: AppColors.appBlue(),
                                                decoration: TextDecoration.none,
                                              ),
                                            ),
                                            SizedBox(width: 10.0),
                                            Image.asset(Constants.ASSET_IMAGES +
                                                'view_more_icon.png'),
                                          ],
                                        ),
                                      )
                                    : Container(),
                              ],
                            ),
                          )
                        : Container(),
                    // Column(
                    //   mainAxisAlignment: MainAxisAlignment.start,
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: [
                    //     for (var i = 0; i < counterList; i++)
                    //       dataItem(context, cpkList!.data![i], counterList)
                    //   ],
                    //   //alertInfo
                    //   //    .map((e) => dataItem(context, e, counterList))
                    //   // .toList(),
                    // ),
                    // GestureDetector(
                    //   onTap: () {
                    //     setState(() {
                    //       isExpandedCpk = !isExpandedCpk;
                    //       !isExpandedCpk
                    //           ? defaultList > cpkList!.data!.length
                    //               ? counterList = cpkList!.data!.length
                    //               : counterList = defaultList
                    //           : counterList = cpkList!.data!.length;
                    //     });
                    //   },
                    //   child: Container(
                    //     width: 150,
                    //     height: 20,
                    //     color: Colors.transparent,
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.center,
                    //       children: [
                    //         Container(
                    //           child: Text(
                    //             !isExpandedCpk
                    //                 ? Utils.getTranslated(context, 'view_more')!
                    //                 : Utils.getTranslated(
                    //                     context, 'view_less')!,
                    //             style: AppFonts.robotoMedium(
                    //               14,
                    //               color: AppColors.appBlue(),
                    //               decoration: TextDecoration.none,
                    //             ),
                    //           ),
                    //         ),
                    //         SizedBox(
                    //           width: 10,
                    //         ),
                    //         !isExpandedCpk
                    //             ? Image.asset(Constants.ASSET_IMAGES +
                    //                 'view_more_icon.png')
                    //             : Image.asset(Constants.ASSET_IMAGES +
                    //                 'view_less_icon.png'),
                    //       ],
                    //     ),
                    //   ),
                    // ),

                    if (openCaseData != null)
                      SizedBox(
                        height: 40,
                      ),
                    if (openCaseData != null)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 16),
                            child: Text(
                              Utils.getTranslated(context, 'alerthistory')!,
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
                              Padding(
                                padding: const EdgeInsets.only(right: 20),
                                child: GestureDetector(
                                  onTap: () {
                                    if (this
                                            .openCaseData!
                                            .data!
                                            .histories!
                                            .length >
                                        0) {
                                      Navigator.pushNamed(
                                        context,
                                        AppRoutes.searchRoute,
                                        arguments: SearchArguments(
                                          caseHistoryCommentList: this
                                              .openCaseData!
                                              .data!
                                              .histories!,
                                        ),
                                      );
                                    }
                                  },
                                  child: Image.asset(theme_dark!
                                      ? Constants.ASSET_IMAGES +
                                          'search_icon.png'
                                      : Constants.ASSET_IMAGES_LIGHT +
                                          'search.png'),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 13),
                                child: GestureDetector(
                                  onTap: () async {
                                    final result = await Navigator.pushNamed(
                                        context, AppRoutes.editComment,
                                        arguments: widget.data.alertRowKey);
                                    if (result != null) {
                                      setState(() {
                                        isLoading = true;
                                      });
                                    }
                                    callCPKList(context);
                                  },
                                  child: Image.asset(
                                    theme_dark!
                                        ? Constants.ASSET_IMAGES +
                                            'add_comment_icon.png'
                                        : Constants.ASSET_IMAGES_LIGHT +
                                            'add_comment_icon.png',
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 16),
                                child: GestureDetector(
                                  onTap: () => showDownloadPopup(context),
                                  child: Image.asset(
                                    theme_dark!
                                        ? Constants.ASSET_IMAGES +
                                            'download_bttn.png'
                                        : Constants.ASSET_IMAGES_LIGHT +
                                            'download_bttn.png',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    SizedBox(
                      height: 33.5,
                    ),
                    if (openCaseData != null)
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: openCaseData!.data!.histories!
                            .map((e) => dataHistory(context, e))
                            .toList(),
                      ),
                  ],
                )),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(left: 69.5, top: 27, right: 69.5),
        height: 67,
        color: theme_dark!
            ? AppColors.appPrimaryBlack()
            : AppColorsLightMode.appPrimaryBlack(),
        child: GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, AppRoutes.editCase);
          },
          child: Container(
            height: 40,
            padding: EdgeInsets.only(top: 12),
            width: 156,
            color: AppColors.appPrimaryYellow(),
            child: Text(
              Utils.getTranslated(context, 'alertCPK_editcasedetail')!,
              style: AppFonts.robotoMedium(15,
                  color: AppColors.appPrimaryWhite(),
                  decoration: TextDecoration.none),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  Widget dataItem(BuildContext ctx, AlertCpkDataDTO e, int length) {
    var cpk = double.parse(e.cpk!).toStringAsFixed(2);
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.alertCPKChart,
          arguments: AlertArguments(
              appBarTitle: Utils.getTranslated(context, 'alertDailyCPK')!,
              alertCpkDataDTO: e),
        );
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(15, 14, 12, 12),
        margin: EdgeInsets.fromLTRB(16, 0, 16, 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: theme_dark!
              ? AppColors.appBlackLight()
              : AppColorsLightMode.appGreyF0(),
        ),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * .25,
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
                    SizedBox(
                      height: 9,
                    ),
                    Text(
                      e.testName!,
                      style: AppFonts.robotoRegular(13,
                          color: theme_dark!
                              ? AppColors.appGreyDE()
                              : AppColorsLightMode.appGrey(),
                          decoration: TextDecoration.none),
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * .15,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      Utils.getTranslated(
                          context, 'dqm_testresult_analog_sortby_cpk')!,
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
                      cpk,
                      style: AppFonts.robotoRegular(13,
                          color: theme_dark!
                              ? AppColors.appGreyDE()
                              : AppColorsLightMode.appGrey(),
                          decoration: TextDecoration.none),
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * .4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      Utils.getTranslated(context, 'alertThreshold')!,
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
              Image.asset(
                Constants.ASSET_IMAGES + 'oee_info_button.png',
              ),
            ]),
      ),
    );
  }

  Widget dataHistory(BuildContext ctx, AlertDetailHistoriesDTO e) {
    return Container(
      padding: EdgeInsets.fromLTRB(15, 14, 12, 0),
      margin: EdgeInsets.fromLTRB(16, 0, 16, 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: theme_dark!
            ? AppColors.appBlackLight()
            : AppColorsLightMode.appGreyF0(),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                e.dateCreated!,
                style: AppFonts.sfproRegular(13,
                    color: AppColors.appGreyB7(),
                    decoration: TextDecoration.none),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 14.0, right: 14),
                child: Text(
                  '|',
                  style: AppFonts.sfproRegular(13,
                      color: AppColors.appGreyB7(),
                      decoration: TextDecoration.none),
                ),
              ),
              Text(
                e.historyType!,
                style: AppFonts.sfproRegular(13,
                    color: AppColors.appGreyB7(),
                    decoration: TextDecoration.none),
              ),
            ],
          ),
          SizedBox(
            height: 9,
          ),
          Text(
            e.message!,
            style: AppFonts.robotoBold(13,
                color: theme_dark!
                    ? AppColors.appGreyDE()
                    : AppColorsLightMode.appGrey(),
                decoration: TextDecoration.none),
          ),
          SizedBox(
            height: 9,
          ),
          Text(
            e.createdByName!,
            style: AppFonts.sfproLight(13,
                color: AppColors.appGreyB7(), decoration: TextDecoration.none),
          ),
          SizedBox(
            height: 12,
          ),
        ],
      ),
    );
  }

  getTagColor(tag) {
    if (tag == 'Critical' || tag == 'critical')
      return AppColors.appRedE9();
    else if (tag == 'High' || tag == 'high')
      return AppColors.appRedE9();
    else if (tag == 'Medium' || tag == 'medium')
      return AppColors.appPrimaryOrange();
    else if (tag == 'Low' || tag == 'medium')
      return AppColors.appPrimaryYellow();
    else if (tag == "None" || tag == 'none')
      return AppColors.appGreen60();
    else
      return Colors.transparent;
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
                final result = await CSVApi.generateCSV(cpkList!.data!, name);
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
                  'Case',
                  fromDate: DateFormat('yyyy-MM-dd')
                      .format(AppCache.sortFilterCacheDTO!.startDate!),
                  toDate: DateFormat('yyyy-MM-dd')
                      .format(AppCache.sortFilterCacheDTO!.endDate!),
                  currentDate: curDate,
                  expType: '.csv',
                );
                var object1 = [];
                var object2 = [];
                var e = openCaseData!.data;
                object1.add({
                  "Alert ID": e!.alertIdName,
                  "Message": e.event,
                  "Case ID": e.caseId,
                  "Subject": e.subject,
                  "Desciption": e.description,
                  "Assigned To": e.assignedToName,
                  "Priority": e.priority,
                  "Status": e.status,
                  "Workflow": e.workFlow,
                  "Company": e.companyName,
                  "Site": e.siteName,
                  "Equipment": e.equipmentName,
                  "Severity": e.severity,
                  "Scoring": e.alertScoring,
                  "Alert Date": e.timestamp,
                  "Created By": e.createdByName,
                  "Created Date": e.createdTimestamp,
                  "Modified By": e.modifiedByName,
                  "Modified Date": e.modifiedTimestamp,
                });

                openCaseData!.data!.histories!.forEach((element) {
                  object2.add({
                    "Timestamp": element.dateCreated,
                    "Type": element.historyType,
                    "Message": element.message,
                    "Updated By": element.createdByName,
                  });
                });
                final result = await CSVApi.generateCaseHistoryCSV(
                    object1,
                    object2,
                    Utils.getExportFilename(
                      'Case',
                      currentDate: curDate,
                      expType: '.csv',
                    ));
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

  createExpandedColumn(BuildContext context, AlertCaseHistoryDataDTO e) {
    String createdDate = '-';
    String modifiedDate = '-';
    String alertDate = '-';
    if (e.createdTimestamp != null) {
      createdDate = DateFormat('d MMM yyy HH:mm:ss')
          .format(DateTime.parse(e.createdTimestamp!));
    }
    if (e.modifiedTimestamp != null) {
      modifiedDate = DateFormat('d MMM yyy HH:mm:ss')
          .format(DateTime.parse(e.modifiedTimestamp!));
    }
    if (e.timestamp != null) {
      alertDate =
          DateFormat('d MMM yyy HH:mm:ss').format(DateTime.parse(e.timestamp!));
    }
    return Container(
        padding: EdgeInsets.fromLTRB(18, 19, 15, 15),
        margin: EdgeInsets.fromLTRB(16, 0, 16, 12),
        color: theme_dark!
            ? AppColors.appBlackLight()
            : AppColorsLightMode.appGreyBA(),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Utils.getTranslated(context, 'alert_company')!,
                            style: AppFonts.robotoRegular(
                              13,
                              color: theme_dark!
                                  ? AppColors.appGreyB1()
                                  : AppColorsLightMode.appGrey77(),
                              decoration: TextDecoration.none,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            e.companyName!,
                            style: AppFonts.robotoMedium(
                              13,
                              color: theme_dark!
                                  ? AppColors.appPrimaryWhite()
                                  : AppColorsLightMode.appGrey(),
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 20,
                        padding: EdgeInsets.only(top: 4, left: 12, right: 12),
                        decoration: BoxDecoration(
                            color: getTagColor(e.priority!),
                            borderRadius: BorderRadius.circular(2)),
                        child: Text(
                          Utils.capitalize(e.priority!),
                          style: AppFonts.robotoMedium(
                            12,
                            color: AppColors.appPrimaryWhite(),
                            decoration: TextDecoration.none,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ]),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Utils.getTranslated(context, 'alert_site')!,
                      style: AppFonts.robotoRegular(
                        13,
                        color: theme_dark!
                            ? AppColors.appGreyB1()
                            : AppColorsLightMode.appGrey77(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      e.siteName!,
                      style: AppFonts.robotoRegular(
                        14,
                        color: theme_dark!
                            ? AppColors.appGreyDE()
                            : AppColorsLightMode.appGrey(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Utils.getTranslated(context, 'alert_createdby')!,
                      style: AppFonts.robotoRegular(
                        13,
                        color: theme_dark!
                            ? AppColors.appGreyB1()
                            : AppColorsLightMode.appGrey77(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      e.createdByName!,
                      style: AppFonts.robotoRegular(
                        14,
                        color: theme_dark!
                            ? AppColors.appGreyDE()
                            : AppColorsLightMode.appGrey(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Utils.getTranslated(context, 'alert_createdon')!,
                      style: AppFonts.robotoRegular(
                        13,
                        color: theme_dark!
                            ? AppColors.appGreyB1()
                            : AppColorsLightMode.appGrey77(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      createdDate,
                      style: AppFonts.robotoRegular(
                        14,
                        color: theme_dark!
                            ? AppColors.appGreyDE()
                            : AppColorsLightMode.appGrey(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Utils.getTranslated(context, 'alert_modifiedby')!,
                      style: AppFonts.robotoRegular(
                        13,
                        color: theme_dark!
                            ? AppColors.appGreyB1()
                            : AppColorsLightMode.appGrey77(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      e.modifiedByName != null ? e.modifiedByName! : '-',
                      style: AppFonts.robotoRegular(
                        14,
                        color: theme_dark!
                            ? AppColors.appGreyDE()
                            : AppColorsLightMode.appGrey(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Utils.getTranslated(context, 'alert_modifieddate')!,
                      style: AppFonts.robotoRegular(
                        13,
                        color: theme_dark!
                            ? AppColors.appGreyB1()
                            : AppColorsLightMode.appGrey77(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      modifiedDate,
                      style: AppFonts.robotoRegular(
                        14,
                        color: theme_dark!
                            ? AppColors.appGreyDE()
                            : AppColorsLightMode.appGrey(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Utils.getTranslated(context, 'alert_recentupdate')!,
                      style: AppFonts.robotoRegular(
                        13,
                        color: theme_dark!
                            ? AppColors.appGreyB1()
                            : AppColorsLightMode.appGrey77(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      '-',
                      style: AppFonts.robotoRegular(
                        14,
                        color: theme_dark!
                            ? AppColors.appGreyDE()
                            : AppColorsLightMode.appGrey(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Utils.getTranslated(context, 'alert_alertdate')!,
                      style: AppFonts.robotoRegular(
                        13,
                        color: theme_dark!
                            ? AppColors.appGreyB1()
                            : AppColorsLightMode.appGrey77(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      alertDate,
                      style: AppFonts.robotoRegular(
                        14,
                        color: theme_dark!
                            ? AppColors.appGreyDE()
                            : AppColorsLightMode.appGrey(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Utils.getTranslated(context, 'alert_alertid')!,
                      style: AppFonts.robotoRegular(
                        13,
                        color: theme_dark!
                            ? AppColors.appGreyB1()
                            : AppColorsLightMode.appGrey77(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      e.alertIdName!,
                      style: AppFonts.robotoRegular(
                        14,
                        color: theme_dark!
                            ? AppColors.appGreyDE()
                            : AppColorsLightMode.appGrey(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Utils.getTranslated(context, 'alert_equipment')!,
                      style: AppFonts.robotoRegular(
                        13,
                        color: theme_dark!
                            ? AppColors.appGreyB1()
                            : AppColorsLightMode.appGrey77(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      e.equipmentName != null ? e.equipmentName! : '-',
                      style: AppFonts.robotoRegular(
                        14,
                        color: theme_dark!
                            ? AppColors.appGreyDE()
                            : AppColorsLightMode.appGrey(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Utils.getTranslated(context, 'alert_subject')!,
                      style: AppFonts.robotoRegular(
                        13,
                        color: theme_dark!
                            ? AppColors.appGreyB1()
                            : AppColorsLightMode.appGrey77(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      e.subject != null ? e.subject! : '-',
                      style: AppFonts.robotoRegular(
                        14,
                        color: theme_dark!
                            ? AppColors.appGreyDE()
                            : AppColorsLightMode.appGrey(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Utils.getTranslated(context, 'alert_description')!,
                      style: AppFonts.robotoRegular(
                        13,
                        color: theme_dark!
                            ? AppColors.appGreyB1()
                            : AppColorsLightMode.appGrey77(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      e.description != null ? e.description! : 'None',
                      style: AppFonts.robotoRegular(
                        14,
                        color: theme_dark!
                            ? AppColors.appGreyDE()
                            : AppColorsLightMode.appGrey(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Utils.getTranslated(context, 'alert_assignedto')!,
                      style: AppFonts.robotoRegular(
                        13,
                        color: theme_dark!
                            ? AppColors.appGreyB1()
                            : AppColorsLightMode.appGrey77(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      e.assignedTo != null ? e.assignedTo! : '-',
                      style: AppFonts.robotoRegular(
                        14,
                        color: theme_dark!
                            ? AppColors.appGreyDE()
                            : AppColorsLightMode.appGrey(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Utils.getTranslated(context, 'alert_status')!,
                      style: AppFonts.robotoRegular(
                        13,
                        color: theme_dark!
                            ? AppColors.appGreyB1()
                            : AppColorsLightMode.appGrey77(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      e.status!,
                      style: AppFonts.robotoRegular(
                        14,
                        color: theme_dark!
                            ? AppColors.appGreyDE()
                            : AppColorsLightMode.appGrey(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Utils.getTranslated(context, 'alert_workflow')!,
                      style: AppFonts.robotoRegular(
                        13,
                        color: theme_dark!
                            ? AppColors.appGreyB1()
                            : AppColorsLightMode.appGrey77(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      e.workFlow!,
                      style: AppFonts.robotoRegular(
                        14,
                        color: theme_dark!
                            ? AppColors.appGreyDE()
                            : AppColorsLightMode.appGrey(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Utils.getTranslated(context, 'alert_message')!,
                      style: AppFonts.robotoRegular(
                        13,
                        color: theme_dark!
                            ? AppColors.appGreyB1()
                            : AppColorsLightMode.appGrey77(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      e.event!,
                      style: AppFonts.robotoRegular(
                        14,
                        color: theme_dark!
                            ? AppColors.appGreyDE()
                            : AppColorsLightMode.appGrey(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isExpandedCard = false;
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Text(
                        Utils.getTranslated(context, 'view_less_detail')!,
                        style: AppFonts.robotoMedium(
                          14,
                          color: AppColors.appBlue(),
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Image.asset(Constants.ASSET_IMAGES + 'view_less_icon.png')
                  ],
                ),
              ),
            ]));
  }

  createCollapseColumn(BuildContext context, AlertCaseHistoryDataDTO e) {
    String createdDate = '-';
    String modifiedDate = '-';
    String alertDate = '-';
    if (e.createdTimestamp != null) {
      createdDate = DateFormat('d MMM yyy HH:mm:ss')
          .format(DateTime.parse(e.createdTimestamp!));
    }
    if (e.modifiedTimestamp != null) {
      modifiedDate = DateFormat('d MMM yyy HH:mm:ss')
          .format(DateTime.parse(e.modifiedTimestamp!));
    }
    if (e.timestamp != null) {
      alertDate =
          DateFormat('d MMM yyy HH:mm:ss').format(DateTime.parse(e.timestamp!));
    }
    return Container(
        padding: EdgeInsets.fromLTRB(18, 19, 15, 15),
        margin: EdgeInsets.fromLTRB(16, 0, 16, 12),
        color: theme_dark!
            ? AppColors.appBlackLight()
            : AppColorsLightMode.appGreyBA(),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Utils.getTranslated(context, 'alert_company')!,
                            style: AppFonts.robotoRegular(
                              13,
                              color: theme_dark!
                                  ? AppColors.appGreyB1()
                                  : AppColorsLightMode.appGrey77(),
                              decoration: TextDecoration.none,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            e.companyName!,
                            style: AppFonts.robotoMedium(
                              13,
                              color: theme_dark!
                                  ? AppColors.appPrimaryWhite()
                                  : AppColorsLightMode.appGrey(),
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 20,
                        padding: EdgeInsets.only(top: 4, left: 12, right: 12),
                        decoration: BoxDecoration(
                            color: getTagColor(e.priority!),
                            borderRadius: BorderRadius.circular(2)),
                        child: Text(
                          Utils.capitalize(e.priority!),
                          style: AppFonts.robotoMedium(
                            12,
                            color: AppColors.appPrimaryWhite(),
                            decoration: TextDecoration.none,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ]),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Utils.getTranslated(context, 'alert_site')!,
                      style: AppFonts.robotoRegular(
                        13,
                        color: theme_dark!
                            ? AppColors.appGreyB1()
                            : AppColorsLightMode.appGrey77(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      e.siteName!,
                      style: AppFonts.robotoRegular(
                        14,
                        color: theme_dark!
                            ? AppColors.appGreyDE()
                            : AppColorsLightMode.appGrey(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Utils.getTranslated(context, 'alert_createdby')!,
                      style: AppFonts.robotoRegular(
                        13,
                        color: theme_dark!
                            ? AppColors.appGreyB1()
                            : AppColorsLightMode.appGrey77(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      e.createdByName!,
                      style: AppFonts.robotoRegular(
                        14,
                        color: theme_dark!
                            ? AppColors.appGreyDE()
                            : AppColorsLightMode.appGrey(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Utils.getTranslated(context, 'alert_createdon')!,
                      style: AppFonts.robotoRegular(
                        13,
                        color: theme_dark!
                            ? AppColors.appGreyB1()
                            : AppColorsLightMode.appGrey77(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      createdDate,
                      style: AppFonts.robotoRegular(
                        14,
                        color: theme_dark!
                            ? AppColors.appGreyDE()
                            : AppColorsLightMode.appGrey(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Utils.getTranslated(context, 'alert_modifiedby')!,
                      style: AppFonts.robotoRegular(
                        13,
                        color: theme_dark!
                            ? AppColors.appGreyB1()
                            : AppColorsLightMode.appGrey77(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      e.modifiedByName != null ? e.modifiedByName! : '-',
                      style: AppFonts.robotoRegular(
                        14,
                        color: theme_dark!
                            ? AppColors.appGreyDE()
                            : AppColorsLightMode.appGrey(),
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isExpandedCard = true;
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Text(
                        Utils.getTranslated(context, 'view_more')!,
                        style: AppFonts.robotoMedium(
                          14,
                          color: AppColors.appBlue(),
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Image.asset(Constants.ASSET_IMAGES + 'view_more_icon.png')
                  ],
                ),
              ),
            ]));
  }
}
