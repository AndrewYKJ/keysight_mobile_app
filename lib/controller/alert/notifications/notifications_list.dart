import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:keysight_pma/cache/appcache.dart';
import 'package:keysight_pma/const/appcolors.dart';
import 'package:keysight_pma/const/appfonts.dart';
import 'package:keysight_pma/const/constants.dart';
import 'package:keysight_pma/const/notificationCounter.dart';
import 'package:keysight_pma/const/themedata.dart';
import 'package:keysight_pma/const/utils.dart';
import 'package:keysight_pma/dio/api/alert.dart';
import 'package:keysight_pma/model/alert/alert_recentList.dart';
import 'package:keysight_pma/model/arguments/alert_routeTitle.dart';
import 'package:keysight_pma/model/arguments/search_argument.dart';
import 'package:keysight_pma/routes/approutes.dart';
import 'package:provider/provider.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';

class NotificationList extends StatefulWidget {
  final StreamController<int> countController;
  NotificationList({required this.countController});

  @override
  State<NotificationList> createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  bool isLoading = true;
  bool? themeDark;
  int? unReadCount = 100;
  AlertRecentListDTO? reponseData;
  List<AlertRecentModel> dataList = [];
  AlertUpdateStatusDTO? alertStatus;
  Future<AlertRecentListDTO> getRecentAlertList(BuildContext context) {
    String companyId = AppCache.sortFilterCacheDTO!.preferredCompany!;
    String siteId = AppCache.sortFilterCacheDTO!.preferredSite!;
    String status = 'All';
    int limit = 100;

    AlertApi alertApi = AlertApi(context);
    return alertApi.getRecentAlertList(
      companyId,
      siteId,
      status,
      limit,
    );
  }

  Future<AlertUpdateStatusDTO> updateAlertStatus(
      BuildContext context, String alertRowKey) {
    AlertApi alertApi = AlertApi(context);
    return alertApi.putAlertReadStatus(alertRowKey: alertRowKey);
  }

  @override
  void initState() {
    super.initState();
    Utils.setFirebaseAnalyticsCurrentScreen(
        Constants.ANALYTICS_NOTIFICATION_SCREEN);
    callGetList(context);
  }

  callGetList(BuildContext context) async {
    await getRecentAlertList(context).then((value) {
      this.reponseData = value;
      if (value.data!.alerts != null && value.data!.alerts!.length > 0) {
        this.dataList = value.data!.alerts!;
        unReadCount = value.data!.totalUnreadCount;

        setCount(context, unReadCount!);
        dataList.sort((a, b) {
          //sorting in ascending order
          return DateTime.parse(b.timestamp!)
              .compareTo(DateTime.parse(a.timestamp!));
        });
      } else {
        // setCount(context, 0);
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

  updateReadAlertStatus(BuildContext context, String alertRowKey, int count,
      AlertRecentModel e) async {
    await updateAlertStatus(context, alertRowKey).then((value) {
      this.alertStatus = value;
      if (alertStatus!.data != null) {
        setState(() {
          e.readStatus = true;
          if (unReadCount! > 0) unReadCount = unReadCount! - 1;
          print(unReadCount);
          setCount(context, unReadCount!);
          Future.delayed(const Duration(milliseconds: 500), () {
            if (e.sender == Constants.ALERT_COMPONENT_ANOMALY ||
                e.sender == Constants.ALERT_DEGRADATION_ANOMALY) {
              Navigator.pushNamed(
                context,
                AppRoutes.alertAnomalyInfo,
                arguments: AlertArguments(
                    notificationListData: e, alertType: e.sender),
              );
            } else if (e.sender == Constants.ALERT_CPK_ALERT_ANOMALIES) {
              Navigator.pushNamed(
                context,
                AppRoutes.alertCPKList,
                arguments: AlertArguments(notificationListData: e),
              );
            } else if (e.sender == Constants.ALERT_LIMIT_CHANGE_ANOMALY) {
              Navigator.pushNamed(
                  context, AppRoutes.alertReviewChangeLimitRoute,
                  arguments: AlertArguments(
                    notificationListData: e,
                  ));
            } else if (e.sender == Constants.ALERT_PAT_LIMIT_RECOMMENDATION ||
                e.sender == Constants.ALERT_PAT_LIMIT_ANOMALIES) {
              Navigator.pushNamed(context, AppRoutes.casehistoryPatRecommend,
                  arguments: AlertArguments(
                    appBarTitle: Utils.getTranslated(context,
                        'senderPATRecommendation')!, //Utils.getTranslated(context, 'alert_information'),
                    notificationListData: e,
                  ));
            }
          });
        });
      }
    }).catchError((error) {
      Utils.printInfo(error);
      if (error is DioError) {
        if (error.response != null) {
          if (error.response!.data != null) {
            Utils.showAlertDialog(
                context,
                Utils.getTranslated(context, 'general_alert_error_title')!,
                error.response!.data.toString());
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
  }

  void setCount(BuildContext context, int count) {
    Provider.of<Counter>(context, listen: false).setCount(count);
  }

  @override
  Widget build(BuildContext context) {
    themeDark = Provider.of<ThemeClass>(context, listen: false).getValue();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeDark!
            ? AppColors.serverAppBar()
            : AppColorsLightMode.serverAppBar(),
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          Utils.getTranslated(context, 'notification_tab')!,
          style: AppFonts.robotoRegular(20,
              color: themeDark!
                  ? AppColors.appGrey()
                  : AppColorsLightMode.appGrey(),
              decoration: TextDecoration.none),
        ),
        actions: [
          IconButton(
              onPressed: () async {
                // setState(() {
                //   //  dataList[count].readStatus = false;
                //   unReadCount = unReadCount! - 1;
                //   print(unReadCount);
                //   setCount(context, unReadCount!);
                // });
                Navigator.pushNamed(
                  context,
                  AppRoutes.searchRoute,
                  arguments: SearchArguments(
                    notificationList: this.dataList,
                  ),
                );
              },
              icon: Image.asset(themeDark!
                  ? Constants.ASSET_IMAGES + 'search_icon.png'
                  : Constants.ASSET_IMAGES_LIGHT + 'search.png'))
        ],
      ),
      body: RefreshIndicator(
        color: AppColors.appBlue(),
        onRefresh: () {
          return Future.delayed(Duration(seconds: 0), () {
            setState(() {
              isLoading = true;
              dataList.clear();
            });
            callGetList(context);
          });
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          margin: EdgeInsets.only(top: 24),
          padding: EdgeInsets.only(left: 20, right: 20),
          //  color: theme_dark!
          //             ? AppColors.appPrimaryBlack()
          //             : AppColorsLightMode.appPrimaryBlack(),
          child: this.isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppColors.appBlue()),
                  ),
                )
              : ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: dataList.length,
                  itemBuilder: (BuildContext listContext, int index) {
                    return notificationList(
                        listContext, dataList[index], index);
                  },
                ),
        ),
      ),
    );
  }

  Widget notificationList(BuildContext context, AlertRecentModel e, int count) {
    return Column(
      children: [
        GestureDetector(
          onTap: () async {
            if (e.readStatus != true)
              await updateReadAlertStatus(context, e.alertRowKey!, count, e);
            else if (e.sender == Constants.ALERT_COMPONENT_ANOMALY ||
                e.sender == Constants.ALERT_DEGRADATION_ANOMALY) {
              Navigator.pushNamed(
                context,
                AppRoutes.alertAnomalyInfo,
                arguments: AlertArguments(
                    notificationListData: e, alertType: e.sender),
              );
            } else if (e.sender == Constants.ALERT_CPK_ALERT_ANOMALIES) {
              Navigator.pushNamed(
                context,
                AppRoutes.alertCPKList,
                arguments: AlertArguments(notificationListData: e),
              );
            } else if (e.sender == Constants.ALERT_LIMIT_CHANGE_ANOMALY) {
              Navigator.pushNamed(
                  context, AppRoutes.alertReviewChangeLimitRoute,
                  arguments: AlertArguments(
                    notificationListData: e,
                  ));
            } else if (e.sender == Constants.ALERT_PAT_LIMIT_RECOMMENDATION ||
                e.sender == Constants.ALERT_PAT_LIMIT_ANOMALIES) {
              Navigator.pushNamed(context, AppRoutes.casehistoryPatRecommend,
                  arguments: AlertArguments(
                    appBarTitle: Utils.getTranslated(context,
                        'senderPATRecommendation')!, //Utils.getTranslated(context, 'alert_information'),
                    notificationListData: e,
                  ));
            }

            // updateAlertStatus(context, e.alertRowKey!)
            //     .catchError((error) {
            //   Utils.printInfo(error);
            //   if (error is DioError) {
            //     if (error.response != null) {
            //       if (error.response!.data != null) {
            //         Utils.showAlertDialog(
            //             context,
            //             Utils.getTranslated(
            //                 context, 'general_alert_error_title')!,
            //             error.response!.statusMessage!);
            //       } else {
            //         Utils.showAlertDialog(
            //             context,
            //             Utils.getTranslated(
            //                 context, 'general_alert_error_title')!,
            //             Utils.getTranslated(
            //                 context, 'general_alert_error_message')!);
            //       }
            //     } else {
            //       Utils.showAlertDialog(
            //           context,
            //           Utils.getTranslated(
            //               context, 'general_alert_error_title')!,
            //           Utils.getTranslated(
            //               context, 'general_alert_error_message')!);
            //     }
            //   } else {
            //     Utils.showAlertDialog(
            //         context,
            //         Utils.getTranslated(context, 'general_alert_error_title')!,
            //         Utils.getTranslated(
            //             context, 'general_alert_error_message')!);
            //   }
            // }).whenComplete(() {
            //   setState(() {
            //     dataList[count].readStatus = false;
            //     if (unReadCount! > 0) unReadCount = unReadCount! - 1;
            //     print(unReadCount);
            //     setCount(context, unReadCount!);
            //   });

            // });

            // myMap[index]['clicked'] = true;
          },
          child: Container(
            color: Colors.transparent,
            padding: const EdgeInsets.fromLTRB(0, 24, 0, 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(right: 10),
                  width: 44,
                  child: Stack(
                    children: <Widget>[
                      Image.asset(
                        themeDark!
                            ? Constants.ASSET_IMAGES + 'notification_icon.png'
                            : Constants.ASSET_IMAGES_LIGHT + 'notification.png',
                        width: 44,
                        fit: BoxFit.contain,
                      ),
                      (e.readStatus != true)
                          ? Positioned(
                              left: 0,
                              child: Container(
                                padding: EdgeInsets.all(1),
                                decoration: new BoxDecoration(
                                  color: AppColors.appNotificationRed(),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                constraints: BoxConstraints(
                                  minWidth: 12,
                                  minHeight: 12,
                                ),
                                child: Image.asset(
                                  Constants.ASSET_IMAGES +
                                      'notification_badge.png',
                                  width: 6,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            )
                          : Text('')
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 94,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 200,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(Utils.ammendSentences(e.sender!),
                                overflow: TextOverflow.ellipsis,
                                style: AppFonts.robotoMedium(14,
                                    color: themeDark!
                                        ? AppColors.appGreyDE()
                                        : AppColorsLightMode.appGreyDE(),
                                    decoration: TextDecoration.none)),
                            SizedBox(
                              height: 10,
                            ),
                            Text(e.event!,
                                // overflow: TextOverflow.ellipsis,
                                style: AppFonts.robotoRegular(14,
                                    color: AppColors.appGrey5B(),
                                    decoration: TextDecoration.none)),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 4),
                        height: 40,
                        width: 70,
                        child: Text(Utils.convertToAgo(e.timestamp!, true),
                            textAlign: TextAlign.right,
                            style: AppFonts.robotoRegular(12,
                                color: AppColors.appGrey5B(),
                                decoration: TextDecoration.none)),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        count != dataList.length - 1
            ? Divider(
                color: themeDark!
                    ? AppColors.appDividerColor()
                    : AppColorsLightMode.appDividerColor(),
              )
            : Container(),
      ],
    );
  }
}
