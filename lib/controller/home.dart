import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:keysight_pma/cache/appcache.dart';
import 'package:keysight_pma/const/appcolors.dart';
import 'package:keysight_pma/const/appfonts.dart';
import 'package:keysight_pma/const/constants.dart';
import 'package:keysight_pma/const/utils.dart';
import 'package:keysight_pma/controller/about/about.dart';
import 'package:keysight_pma/controller/help/help.dart';
import 'package:keysight_pma/dio/api/dqm.dart';
import 'package:keysight_pma/model/arguments/dqm_argument.dart';
import 'package:keysight_pma/model/arguments/oee_argument.dart';
import 'package:keysight_pma/model/dqm/daily_board_volume.dart';
import 'package:keysight_pma/routes/approutes.dart';
import 'package:provider/provider.dart';
import '../const/themedata.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HomeScreen();
  }
}

class _HomeScreen extends State<HomeScreen> {
  //List of data for summary
  int? ttc = 45;
  int? y_ttc = 50;
  int? dby_ttc = 60;
  int? tec = 60;
  int? y_tec = 90;
  int? dby_tec = 120;
  int? fpc;
  int? y_fpc;
  int? dby_fpc;
  int? rpc;
  int? y_rpc;
  int? dby_rpc;
  int? firstPassYield;
  int? y_firstPassYield;
  int? dby_firstPassYield;
  int? finalYield;
  int? y_finalYield;
  int? dby_finalYield;
  int? fc;
  int? y_fc;
  int? dby_fc;
  int? tvc;
  int? y_tvc;
  int? dby_tvc;
  //end of data for summary
  bool? theme_dark;
  String today = DateFormat("yyyyMMdd").format(DateTime.now());
  // String today = DateFormat("yyyyMMdd").format(DateTime.utc(2022, 5, 3));
  // DateFormat("yyyyMMdd").format(DateTime.now());
  String dayBeforeYesterday =
      // DateFormat("yyyyMMdd").format(DateTime.utc(2022, 5, 1));
      DateFormat("yyyyMMdd").format(DateTime.now().subtract(Duration(days: 2)));
  String yesterday = //DateFormat("yyyyMMdd").format(DateTime.utc(2022, 5, 2));
      DateFormat("yyyyMMdd").format(DateTime.now().subtract(Duration(days: 1)));
  String todayDate = DateFormat.yMMMEd().format(DateTime.now());
  String? about;
  String? help;
  bool isLoading = true;
  String? cancel;

  DailyBoardVolumeDTO dailyBoardVolumeDTO = DailyBoardVolumeDTO();

  _showActionSheet(BuildContext context, about, help, cancel) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext c) => CupertinoActionSheet(
        actions: [
          Container(
            color: theme_dark!
                ? AppColors.cupertinoBackground()
                : AppColorsLightMode.cupertinoBackground().withOpacity(0.8),
            child: CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(c);
                Navigator.push(
                    c, MaterialPageRoute(builder: (c) => AboutPage()));
              },
              child: Text(
                about,
                style: AppFonts.robotoMedium(15,
                    color: theme_dark!
                        ? AppColors.appGreyED()
                        : AppColorsLightMode.appGrey(),
                    decoration: TextDecoration.none),
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
                Navigator.pop(c);
                Navigator.push(
                    c, MaterialPageRoute(builder: (c) => HelpPage()));
              },
              child: Text(
                help,
                style: AppFonts.robotoMedium(15,
                    color: theme_dark!
                        ? AppColors.appGreyED()
                        : AppColorsLightMode.appGrey(),
                    decoration: TextDecoration.none),
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
              Navigator.pop(c);
            },
            child: Text(
              cancel,
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

  Future<DailyBoardVolumeDTO> getDailyBoardVolumeBySite(BuildContext context) {
    DqmApi dqmApi = DqmApi(context);
    return dqmApi.getDailyBoardVolumeBySite(
        AppCache.sortFilterCacheDTO!.preferredCompany!,
        AppCache.sortFilterCacheDTO!.preferredSite!,
        dayBeforeYesterday,
        today);
  }

  _calculationSummary(BuildContext context, DailyBoardVolumeDTO x) {
    for (var i = 0; i < x.data!.length; i++) {
      DailyBoardVolumeDataDTO data = x.data![i];

      if (data.date!.replaceAll('-', '') == today) {
        firstPassYield = (100 *
                (data.firstPass! /
                    (data.firstPass! + data.rework! + data.failed!)))
            .toInt();
        finalYield = (((data.firstPass! + data.rework!) /
                    (data.firstPass! + data.rework! + data.failed!)) *
                100)
            .toInt();
        tvc = (data.firstPass! + data.rework! + data.failed!).toInt();

        fpc = data.firstPass!.toInt();
        fc = data.failed!.toInt();
        rpc = data.rework!.toInt();
      }
      if (data.date!.replaceAll('-', '') == yesterday) {
        y_firstPassYield = (100 *
                (data.firstPass! /
                    (data.firstPass! + data.rework! + data.failed!)))
            .toInt();

        y_finalYield = (((data.firstPass! + data.rework!) /
                    (data.firstPass! + data.rework! + data.failed!)) *
                100)
            .toInt();
        y_tvc = (data.firstPass! + data.rework! + data.failed!).toInt();
        y_fpc = data.firstPass!.toInt();
        y_fc = data.failed!.toInt();
        y_rpc = data.rework!.toInt();
      }
      if (data.date!.replaceAll('-', '') == dayBeforeYesterday) {
        dby_firstPassYield = (100 *
                (data.firstPass! /
                    (data.firstPass! + data.rework! + data.failed!)))
            .toInt();

        dby_finalYield = (((data.firstPass! + data.rework!) /
                    (data.firstPass! + data.rework! + data.failed!)) *
                100)
            .toInt();
        dby_tvc = (data.firstPass! + data.rework! + data.failed!).toInt();

        dby_fpc = data.firstPass!.toInt();
        dby_fc = data.failed!.toInt();
        dby_rpc = data.rework!.toInt();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    FirebaseAnalytics.instance
        .setCurrentScreen(screenName: Constants.ANALYTICS_HOME_SCREEN);
    theme_dark = AppCache.sortFilterCacheDTO!.currentTheme;
    FocusManager.instance.primaryFocus?.unfocus();
    callGetDailyBoardVolumeBySite(context);
  }

  callGetDailyBoardVolumeBySite(BuildContext context) async {
    await getDailyBoardVolumeBySite(context).then((value) {
      dailyBoardVolumeDTO = value;
    }).catchError((error) {
      Utils.printInfo(error);
      throw error;
    });
    /* await getDayBeforeYtdDailyBoardVolumeBySite(context).then((value) {
      daybeforeytdDailyBoard = value;
    }).catchError((error) {
      Utils.printInfo(error);
    });
    await getYtdDailyBoardVolumeBySite(context).then((value) {
      ytdDailyBoard = value;
    }).catchError((error) {
      Utils.printInfo(error);
    });
*/
    if (dailyBoardVolumeDTO.data != null) {
      _calculationSummary(context, dailyBoardVolumeDTO);
      // print('start Calculation');
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeClass>(
      builder: (context, value, child) {
        theme_dark = value.getValue();
        AppCache.sortFilterCacheDTO!.currentTheme = theme_dark;
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
            leadingWidth: 90,
            leading: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Image.asset(
                theme_dark!
                    ? Constants.ASSET_IMAGES + 'keysight_home_top_bar.png'
                    : Constants.ASSET_IMAGES_LIGHT +
                        'keysight_home_top_bar.png',
                fit: BoxFit.contain,
              ),
            ),
            centerTitle: true,
            title: Text(
              Utils.getTranslated(context, 'keysight_application')!,
              style: AppFonts.robotoMedium(
                14,
                color: theme_dark!
                    ? AppColors.appPrimaryWhite()
                    : AppColorsLightMode.appPrimaryWhite(),
                decoration: TextDecoration.none,
              ),
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      about = Utils.getTranslated(context, 'about')!;
                      help = Utils.getTranslated(context, 'help')!;
                      cancel = Utils.getTranslated(context, 'cancel')!;
                    });

                    _showActionSheet(context, about, help, cancel);
                  },
                  icon: Icon(
                    Icons.more_horiz,
                    color: theme_dark!
                        ? AppColors.appPrimaryWhite()
                        : AppColorsLightMode.appPrimaryWhite(),
                  ))
            ],
          ),
          body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 24,
                  ),
                  GestureDetector(
                    onTap: () {
                      AppCache.isFromAlert = false;
                      Navigator.pushNamed(context, AppRoutes.dqmScreenRoute);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                            theme_dark!
                                ? AppColors.appButtonBlack()
                                : AppColorsLightMode.appButtonBlack(),
                            theme_dark!
                                ? AppColors.bottomNavi()
                                : AppColorsLightMode.bottombutton(),
                          ])),
                      margin: const EdgeInsets.only(left: 16, right: 16),
                      padding: const EdgeInsets.fromLTRB(12, 28, 12, 28),
                      child: Row(
                        children: [
                          Image.asset(
                            theme_dark!
                                ? Constants.ASSET_IMAGES + 'digital_quality.png'
                                : Constants.ASSET_IMAGES_LIGHT +
                                    'digital_quality.png',
                          ),
                          Padding(padding: EdgeInsets.only(left: 11)),
                          Text(
                            Utils.getTranslated(context, 'dqm_appbar_title')!,
                            style: AppFonts.robotoRegular(18,
                                color: theme_dark!
                                    ? AppColors.appPrimaryWhite()
                                    : AppColorsLightMode.appPrimaryWhite(),
                                decoration: TextDecoration.none),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.oeeHomeBase,
                        arguments: OeeChartDetailArguments(
                          currentTab: 0,
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                            theme_dark!
                                ? AppColors.appButtonBlack()
                                : AppColorsLightMode.appButtonBlack(),
                            theme_dark!
                                ? AppColors.bottomNavi()
                                : AppColorsLightMode.bottombutton(),
                          ])),
                      margin: const EdgeInsets.only(left: 16, right: 16),
                      padding: const EdgeInsets.fromLTRB(12, 28, 12, 28),
                      child: Row(
                        children: [
                          Image.asset(
                            theme_dark!
                                ? Constants.ASSET_IMAGES + 'oee.png'
                                : Constants.ASSET_IMAGES_LIGHT + 'oee.png',
                          ),
                          Padding(padding: EdgeInsets.only(left: 11)),
                          Text(
                            Utils.getTranslated(context, 'ooe_title')!,
                            style: AppFonts.robotoRegular(18,
                                color: theme_dark!
                                    ? AppColors.appPrimaryWhite()
                                    : AppColorsLightMode.appPrimaryWhite(),
                                decoration: TextDecoration.none),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  GestureDetector(
                    onTap: () async {
                      final navResult = await Navigator.pushNamed(
                          context, AppRoutes.alertBase);
                      if (navResult != null && navResult as bool) {
                        AppCache.isFromAlert = true;
                        Navigator.pushNamed(context, AppRoutes.dqmScreenRoute,
                            arguments: DqmChartDetailArguments(currentTab: 2));
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                            theme_dark!
                                ? AppColors.appButtonBlack()
                                : AppColorsLightMode.appButtonBlack(),
                            theme_dark!
                                ? AppColors.bottomNavi()
                                : AppColorsLightMode.bottombutton(),
                          ])),
                      margin: const EdgeInsets.only(left: 16, right: 16),
                      padding: const EdgeInsets.fromLTRB(12, 28, 12, 28),
                      child: Row(
                        children: [
                          Image.asset(
                            theme_dark!
                                ? Constants.ASSET_IMAGES + 'alert.png'
                                : Constants.ASSET_IMAGES_LIGHT + 'alert.png',
                          ),
                          Padding(padding: EdgeInsets.only(left: 11)),
                          Text(
                            Utils.getTranslated(context, 'alert')!,
                            style: AppFonts.robotoRegular(18,
                                color: theme_dark!
                                    ? AppColors.appPrimaryWhite()
                                    : AppColorsLightMode.appPrimaryWhite(),
                                decoration: TextDecoration.none),
                          ),
                        ],
                      ),
                    ),
                  ),
                  //summary UI
                  SizedBox(
                    height: 42,
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 16, right: 16),
                    child: Text(
                      Utils.getTranslated(context, 'summary_title')!,
                      textAlign: TextAlign.left,
                      style: AppFonts.robotoMedium(18,
                          color: theme_dark!
                              ? AppColors.appPrimaryWhite()
                              : AppColorsLightMode.appPrimaryWhite(),
                          decoration: TextDecoration.none),
                    ),
                  ),
                  SizedBox(
                    height: 18,
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 16, right: 16),
                    child: Text(
                      todayDate,
                      textAlign: TextAlign.left,
                      style: AppFonts.robotoRegular(16,
                          color: theme_dark!
                              ? AppColors.appPrimaryWhite()
                              : AppColorsLightMode.appPrimaryWhite(),
                          decoration: TextDecoration.none),
                    ),
                  ),
                  SizedBox(
                    height: 9,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 16.0, left: 16, bottom: 8, right: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 115,
                              width: MediaQuery.of(context).size.width / 2 - 20,
                              margin: EdgeInsets.only(right: 8, bottom: 8),
                              padding: EdgeInsets.only(left: 18, top: 15),
                              decoration: BoxDecoration(
                                  color: theme_dark!
                                      ? AppColors.appSummaryCard()
                                      : AppColorsLightMode.appSummaryCard(),
                                  borderRadius: BorderRadius.circular(14)),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Row(
                                        children: [
                                          Text(
                                            firstPassYield != null
                                                ? ('$firstPassYield')
                                                : '-',
                                            //textAlign: TextAlign.left,
                                            style: AppFonts.robotoBold(25,
                                                color: theme_dark!
                                                    ? AppColors
                                                        .appPrimaryWhite()
                                                    : AppColorsLightMode
                                                        .appSummaryCardTextGrey(),
                                                decoration:
                                                    TextDecoration.none),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        Utils.getTranslated(
                                            context, 'home_summary_fpy')!,
                                        textAlign: TextAlign.left,
                                        style: AppFonts.robotoMedium(13,
                                            color: theme_dark!
                                                ? AppColors
                                                    .appSummaryCardTextGrey()
                                                : AppColorsLightMode
                                                    .appSummaryCardTextGrey(),
                                            decoration: TextDecoration.none),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Row(
                                        children: [
                                          Text(
                                            Utils.getTranslated(
                                                context, 'yesterday')!,
                                            textAlign: TextAlign.left,
                                            style: AppFonts.robotoMedium(13,
                                                color: theme_dark!
                                                    ? AppColors
                                                        .appSummaryCardTextGrey()
                                                    : AppColorsLightMode
                                                        .appSummaryCardTextGrey(),
                                                decoration:
                                                    TextDecoration.none),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 8),
                                            child: Text(
                                              (y_firstPassYield != null
                                                  ? ('$y_firstPassYield')
                                                  : '-'),
                                              //textAlign: TextAlign.left,
                                              style: AppFonts.robotoMedium(13,
                                                  color: theme_dark!
                                                      ? AppColors
                                                          .appSummaryCardTextGrey()
                                                      : AppColorsLightMode
                                                          .appSummaryCardTextGrey(),
                                                  decoration:
                                                      TextDecoration.none),
                                            ),
                                          ),
                                          (firstPassYield != null &&
                                                  dby_firstPassYield != null &&
                                                  y_firstPassYield != null)
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 6),
                                                  child: (dby_firstPassYield ==
                                                          y_firstPassYield)
                                                      ? null
                                                      : (dby_firstPassYield! >=
                                                              y_firstPassYield!)
                                                          ? Image.asset(
                                                              Constants
                                                                      .ASSET_IMAGES +
                                                                  'decrease_icon.png',
                                                              height: 13,
                                                            )
                                                          : Image.asset(
                                                              Constants
                                                                      .ASSET_IMAGES +
                                                                  'increase_icon.png',
                                                              height: 13,
                                                            ))
                                              : Container()
                                        ],
                                      ),
                                    ),
                                  ]),
                            ),
                            Container(
                              height: 115,
                              width: MediaQuery.of(context).size.width / 2 - 20,
                              margin: EdgeInsets.only(right: 8, bottom: 8),
                              padding: EdgeInsets.only(left: 18, top: 15),
                              decoration: BoxDecoration(
                                  color: theme_dark!
                                      ? AppColors.appSummaryCard()
                                      : AppColorsLightMode.appSummaryCard(),
                                  borderRadius: BorderRadius.circular(14)),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Row(
                                        children: [
                                          Text(
                                            finalYield != null
                                                ? ('$finalYield')
                                                : '-',
                                            //textAlign: TextAlign.left,
                                            style: AppFonts.robotoBold(25,
                                                color: theme_dark!
                                                    ? AppColors
                                                        .appPrimaryWhite()
                                                    : AppColorsLightMode
                                                        .appSummaryCardTextGrey(),
                                                decoration:
                                                    TextDecoration.none),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        Utils.getTranslated(
                                            context, 'home_summary_fy')!,
                                        textAlign: TextAlign.left,
                                        style: AppFonts.robotoMedium(13,
                                            color: theme_dark!
                                                ? AppColors
                                                    .appSummaryCardTextGrey()
                                                : AppColorsLightMode
                                                    .appSummaryCardTextGrey(),
                                            decoration: TextDecoration.none),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Row(
                                        children: [
                                          Text(
                                            Utils.getTranslated(
                                                context, 'yesterday')!,
                                            textAlign: TextAlign.left,
                                            style: AppFonts.robotoMedium(13,
                                                color: theme_dark!
                                                    ? AppColors
                                                        .appSummaryCardTextGrey()
                                                    : AppColorsLightMode
                                                        .appSummaryCardTextGrey(),
                                                decoration:
                                                    TextDecoration.none),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 8),
                                            child: Text(
                                              y_finalYield != null
                                                  ? ('$y_finalYield')
                                                  : '-',
                                              //textAlign: TextAlign.left,
                                              style: AppFonts.robotoMedium(13,
                                                  color: theme_dark!
                                                      ? AppColors
                                                          .appSummaryCardTextGrey()
                                                      : AppColorsLightMode
                                                          .appSummaryCardTextGrey(),
                                                  decoration:
                                                      TextDecoration.none),
                                            ),
                                          ),
                                          (finalYield != null &&
                                                  dby_finalYield != null &&
                                                  y_finalYield != null)
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 6),
                                                  child: (dby_finalYield ==
                                                          y_finalYield)
                                                      ? null
                                                      : (dby_finalYield! >=
                                                              y_finalYield!)
                                                          ? Image.asset(
                                                              Constants
                                                                      .ASSET_IMAGES +
                                                                  'decrease_icon.png',
                                                              height: 13,
                                                            )
                                                          : Image.asset(
                                                              Constants
                                                                      .ASSET_IMAGES +
                                                                  'increase_icon.png',
                                                              height: 13,
                                                            ))
                                              : Container()
                                        ],
                                      ),
                                    ),
                                  ]),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 115,
                              width: MediaQuery.of(context).size.width / 2 - 20,
                              margin: EdgeInsets.only(right: 8, bottom: 8),
                              padding: EdgeInsets.only(left: 18, top: 15),
                              decoration: BoxDecoration(
                                  color: theme_dark!
                                      ? AppColors.appSummaryCard()
                                      : AppColorsLightMode.appSummaryCard(),
                                  borderRadius: BorderRadius.circular(14)),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Row(
                                        children: [
                                          Text(
                                            fpc != null ? ('$fpc') : '-',
                                            //textAlign: TextAlign.left,
                                            style: AppFonts.robotoBold(25,
                                                color: theme_dark!
                                                    ? AppColors
                                                        .appPrimaryWhite()
                                                    : AppColorsLightMode
                                                        .appSummaryCardTextGrey(),
                                                decoration:
                                                    TextDecoration.none),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        Utils.getTranslated(
                                            context, 'home_summary_fpc')!,
                                        textAlign: TextAlign.left,
                                        style: AppFonts.robotoMedium(13,
                                            color: theme_dark!
                                                ? AppColors
                                                    .appSummaryCardTextGrey()
                                                : AppColorsLightMode
                                                    .appSummaryCardTextGrey(),
                                            decoration: TextDecoration.none),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Row(
                                        children: [
                                          Text(
                                            Utils.getTranslated(
                                                context, 'yesterday')!,
                                            textAlign: TextAlign.left,
                                            style: AppFonts.robotoMedium(13,
                                                color: theme_dark!
                                                    ? AppColors
                                                        .appSummaryCardTextGrey()
                                                    : AppColorsLightMode
                                                        .appSummaryCardTextGrey(),
                                                decoration:
                                                    TextDecoration.none),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 8),
                                            child: Text(
                                              y_fpc != null ? ('$y_fpc') : '-',
                                              //textAlign: TextAlign.left,
                                              style: AppFonts.robotoMedium(13,
                                                  color: theme_dark!
                                                      ? AppColors
                                                          .appSummaryCardTextGrey()
                                                      : AppColorsLightMode
                                                          .appSummaryCardTextGrey(),
                                                  decoration:
                                                      TextDecoration.none),
                                            ),
                                          ),
                                          (fpc != null &&
                                                  dby_fpc != null &&
                                                  y_fpc != null)
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 6),
                                                  child: (dby_fpc == y_fpc)
                                                      ? null
                                                      : (dby_fpc! >= y_fpc!)
                                                          ? Image.asset(
                                                              Constants
                                                                      .ASSET_IMAGES +
                                                                  'decrease_icon.png',
                                                              height: 13,
                                                            )
                                                          : Image.asset(
                                                              Constants
                                                                      .ASSET_IMAGES +
                                                                  'increase_icon.png',
                                                              height: 13,
                                                            ))
                                              : Container()
                                        ],
                                      ),
                                    ),
                                  ]),
                            ),
                            Container(
                              height: 115,
                              width: MediaQuery.of(context).size.width / 2 - 20,
                              margin: EdgeInsets.only(right: 8, bottom: 8),
                              padding: EdgeInsets.only(left: 18, top: 15),
                              decoration: BoxDecoration(
                                  color: theme_dark!
                                      ? AppColors.appSummaryCard()
                                      : AppColorsLightMode.appSummaryCard(),
                                  borderRadius: BorderRadius.circular(14)),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Row(
                                        children: [
                                          Text(
                                            rpc != null ? ('$rpc') : '-',
                                            //textAlign: TextAlign.left,
                                            style: AppFonts.robotoBold(25,
                                                color: theme_dark!
                                                    ? AppColors
                                                        .appPrimaryWhite()
                                                    : AppColorsLightMode
                                                        .appSummaryCardTextGrey(),
                                                decoration:
                                                    TextDecoration.none),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        Utils.getTranslated(
                                            context, 'home_summary_rpc')!,
                                        textAlign: TextAlign.left,
                                        style: AppFonts.robotoMedium(13,
                                            color: theme_dark!
                                                ? AppColors
                                                    .appSummaryCardTextGrey()
                                                : AppColorsLightMode
                                                    .appSummaryCardTextGrey(),
                                            decoration: TextDecoration.none),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Row(
                                        children: [
                                          Text(
                                            Utils.getTranslated(
                                                context, 'yesterday')!,
                                            textAlign: TextAlign.left,
                                            style: AppFonts.robotoMedium(13,
                                                color: theme_dark!
                                                    ? AppColors
                                                        .appSummaryCardTextGrey()
                                                    : AppColorsLightMode
                                                        .appSummaryCardTextGrey(),
                                                decoration:
                                                    TextDecoration.none),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 8),
                                            child: Text(
                                              y_rpc != null ? ('$y_rpc') : '-',
                                              //textAlign: TextAlign.left,
                                              style: AppFonts.robotoMedium(13,
                                                  color: theme_dark!
                                                      ? AppColors
                                                          .appSummaryCardTextGrey()
                                                      : AppColorsLightMode
                                                          .appSummaryCardTextGrey(),
                                                  decoration:
                                                      TextDecoration.none),
                                            ),
                                          ),
                                          (rpc != null &&
                                                  dby_rpc != null &&
                                                  y_rpc != null)
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 6),
                                                  child: (dby_rpc == y_rpc)
                                                      ? null
                                                      : (dby_rpc! >= y_rpc!)
                                                          ? Image.asset(
                                                              Constants
                                                                      .ASSET_IMAGES +
                                                                  'decrease_icon.png',
                                                              height: 13,
                                                            )
                                                          : Image.asset(
                                                              Constants
                                                                      .ASSET_IMAGES +
                                                                  'increase_icon.png',
                                                              height: 13,
                                                            ))
                                              : Container()
                                        ],
                                      ),
                                    ),
                                  ]),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 115,
                              width: MediaQuery.of(context).size.width / 2 - 20,
                              margin: EdgeInsets.only(right: 8, bottom: 8),
                              padding: EdgeInsets.only(left: 18, top: 15),
                              decoration: BoxDecoration(
                                  color: theme_dark!
                                      ? AppColors.appSummaryCard()
                                      : AppColorsLightMode.appSummaryCard(),
                                  borderRadius: BorderRadius.circular(14)),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Row(
                                        children: [
                                          Text(
                                            fc != null ? ('$fc') : '-',
                                            //textAlign: TextAlign.left,
                                            style: AppFonts.robotoBold(25,
                                                color: theme_dark!
                                                    ? AppColors
                                                        .appPrimaryWhite()
                                                    : AppColorsLightMode
                                                        .appSummaryCardTextGrey(),
                                                decoration:
                                                    TextDecoration.none),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        Utils.getTranslated(
                                            context, 'home_summary_fc')!,
                                        textAlign: TextAlign.left,
                                        style: AppFonts.robotoMedium(13,
                                            color: theme_dark!
                                                ? AppColors
                                                    .appSummaryCardTextGrey()
                                                : AppColorsLightMode
                                                    .appSummaryCardTextGrey(),
                                            decoration: TextDecoration.none),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Row(
                                        children: [
                                          Text(
                                            Utils.getTranslated(
                                                context, 'yesterday')!,
                                            textAlign: TextAlign.left,
                                            style: AppFonts.robotoMedium(13,
                                                color: theme_dark!
                                                    ? AppColors
                                                        .appSummaryCardTextGrey()
                                                    : AppColorsLightMode
                                                        .appSummaryCardTextGrey(),
                                                decoration:
                                                    TextDecoration.none),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 8),
                                            child: Text(
                                              y_fc != null ? ('$y_fc') : '-',
                                              //textAlign: TextAlign.left,
                                              style: AppFonts.robotoMedium(13,
                                                  color: theme_dark!
                                                      ? AppColors
                                                          .appSummaryCardTextGrey()
                                                      : AppColorsLightMode
                                                          .appSummaryCardTextGrey(),
                                                  decoration:
                                                      TextDecoration.none),
                                            ),
                                          ),
                                          (fc != null &&
                                                  dby_fc != null &&
                                                  y_fc != null)
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 6),
                                                  child: (dby_fc == y_fc)
                                                      ? null
                                                      : (dby_fc! >= y_fc!)
                                                          ? Image.asset(
                                                              Constants
                                                                      .ASSET_IMAGES +
                                                                  'decrease_icon.png',
                                                              height: 13,
                                                            )
                                                          : Image.asset(
                                                              Constants
                                                                      .ASSET_IMAGES +
                                                                  'increase_icon.png',
                                                              height: 13,
                                                            ))
                                              : Container()
                                        ],
                                      ),
                                    ),
                                  ]),
                            ),
                            Container(
                              height: 115,
                              width: MediaQuery.of(context).size.width / 2 - 20,
                              margin: EdgeInsets.only(right: 8, bottom: 8),
                              padding: EdgeInsets.only(left: 18, top: 15),
                              decoration: BoxDecoration(
                                  color: theme_dark!
                                      ? AppColors.appSummaryCard()
                                      : AppColorsLightMode.appSummaryCard(),
                                  borderRadius: BorderRadius.circular(14)),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Row(
                                        children: [
                                          Text(
                                            tvc != null ? ('$tvc') : '-',
                                            //textAlign: TextAlign.left,
                                            style: AppFonts.robotoBold(25,
                                                color: theme_dark!
                                                    ? AppColors
                                                        .appPrimaryWhite()
                                                    : AppColorsLightMode
                                                        .appSummaryCardTextGrey(),
                                                decoration:
                                                    TextDecoration.none),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        Utils.getTranslated(
                                            context, 'home_summary_tvc')!,
                                        textAlign: TextAlign.left,
                                        style: AppFonts.robotoMedium(13,
                                            color: theme_dark!
                                                ? AppColors
                                                    .appSummaryCardTextGrey()
                                                : AppColorsLightMode
                                                    .appSummaryCardTextGrey(),
                                            decoration: TextDecoration.none),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Row(
                                        children: [
                                          Text(
                                            Utils.getTranslated(
                                                context, 'yesterday')!,
                                            textAlign: TextAlign.left,
                                            style: AppFonts.robotoMedium(13,
                                                color: theme_dark!
                                                    ? AppColors
                                                        .appSummaryCardTextGrey()
                                                    : AppColorsLightMode
                                                        .appSummaryCardTextGrey(),
                                                decoration:
                                                    TextDecoration.none),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 8),
                                            child: Text(
                                              y_tvc != null ? ('$y_tvc') : '-',
                                              //textAlign: TextAlign.left,
                                              style: AppFonts.robotoMedium(13,
                                                  color: theme_dark!
                                                      ? AppColors
                                                          .appSummaryCardTextGrey()
                                                      : AppColorsLightMode
                                                          .appSummaryCardTextGrey(),
                                                  decoration:
                                                      TextDecoration.none),
                                            ),
                                          ),
                                          (tvc != null &&
                                                  dby_tvc != null &&
                                                  y_tvc != null)
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 6),
                                                  child: (dby_tvc == y_tvc)
                                                      ? null
                                                      : (dby_tvc! >= y_tvc!)
                                                          ? Image.asset(
                                                              Constants
                                                                      .ASSET_IMAGES +
                                                                  'decrease_icon.png',
                                                              height: 13,
                                                            )
                                                          : Image.asset(
                                                              Constants
                                                                      .ASSET_IMAGES +
                                                                  'increase_icon.png',
                                                              height: 13,
                                                            ))
                                              : Container()
                                        ],
                                      ),
                                    ),
                                  ]),
                            ),
                          ],
                        ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //     Container(
                        //       height: 115,
                        //       width: MediaQuery.of(context).size.width / 2 - 12,
                        //       margin: EdgeInsets.only(bottom: 8),
                        //       padding: EdgeInsets.only(left: 18, top: 15),
                        //       decoration: BoxDecoration(
                        //           color: AppColors.appSummaryCard(),
                        //           borderRadius: BorderRadius.only(
                        //               topLeft: Radius.circular(14),
                        //               bottomLeft: Radius.circular(14))),
                        //       child: Column(
                        //           mainAxisAlignment: MainAxisAlignment.start,
                        //           crossAxisAlignment: CrossAxisAlignment.start,
                        //           children: [
                        //             Padding(
                        //               padding: const EdgeInsets.only(top: 8.0),
                        //               child: Row(
                        //                 children: [
                        //                   Text(
                        //                     ttc != null ? ('$ttc') : '-',
                        //                     //textAlign: TextAlign.left,
                        //                     style: AppFonts.robotoBold(25,
                        //                         color: AppColors.appPrimaryWhite(),
                        //                         decoration: TextDecoration.none),
                        //                   ),
                        //                 ],
                        //               ),
                        //             ),
                        //             Padding(
                        //               padding: const EdgeInsets.only(top: 8.0),
                        //               child: Text(
                        //                 Utils.getTranslated(
                        //                     context, 'home_summary_tpc')!,
                        //                 textAlign: TextAlign.left,
                        //                 style: AppFonts.robotoMedium(13,
                        //                     color:
                        //                         AppColors.appSummaryCardTextGrey(),
                        //                     decoration: TextDecoration.none),
                        //               ),
                        //             ),
                        //             Padding(
                        //               padding: const EdgeInsets.only(top: 8.0),
                        //               child: Row(
                        //                 children: [
                        //                   Text(
                        //                     Utils.getTranslated(
                        //                         context, 'yesterday')!,
                        //                     textAlign: TextAlign.left,
                        //                     style: AppFonts.robotoMedium(13,
                        //                         color: AppColors
                        //                             .appSummaryCardTextGrey(),
                        //                         decoration: TextDecoration.none),
                        //                   ),
                        //                   Padding(
                        //                     padding: const EdgeInsets.only(left: 8),
                        //                     child: Text(
                        //                       y_ttc != null ? ('$y_ttc') : '-',
                        //                       //textAlign: TextAlign.left,
                        //                       style: AppFonts.robotoMedium(13,
                        //                           color: AppColors
                        //                               .appSummaryCardTextGrey(),
                        //                           decoration: TextDecoration.none),
                        //                     ),
                        //                   ),
                        //                   ttc != null
                        //                       ? Padding(
                        //                           padding: const EdgeInsets.only(
                        //                               left: 6),
                        //                           child: (ttc == y_ttc)
                        //                               ? null
                        //                               : (ttc! <= y_ttc!)
                        //                                   ? Image.asset(
                        //                                       Constants
                        //                                               .ASSET_IMAGES +
                        //                                           'decrease_icon.png',
                        //                                       height: 13,
                        //                                     )
                        //                                   : Image.asset(
                        //                                       Constants
                        //                                               .ASSET_IMAGES +
                        //                                           'increase_icon.png',
                        //                                       height: 13,
                        //                                     ))
                        //                       : Container()
                        //                 ],
                        //               ),
                        //             ),
                        //           ]),
                        //     ),
                        //     // Container(
                        //     //   height: 115,
                        //     //   width: MediaQuery.of(context).size.width / 2 - 20,
                        //     //   margin: EdgeInsets.only(right: 8, bottom: 8),
                        //     //   padding: EdgeInsets.only(left: 18, top: 15),
                        //     //   decoration: BoxDecoration(
                        //     //       color: AppColors.appSummaryCard(),
                        //     //       borderRadius: BorderRadius.only(
                        //     //           topRight: Radius.circular(14),
                        //     //           bottomRight: Radius.circular(14))),
                        //     //   child: Column(
                        //     //       mainAxisAlignment: MainAxisAlignment.start,
                        //     //       crossAxisAlignment: CrossAxisAlignment.start,
                        //     //       children: [
                        //     //         Padding(
                        //     //           padding: const EdgeInsets.only(top: 8.0),
                        //     //           child: Text(
                        //     //             tec != null ? ('$tec') : '-',
                        //     //             //textAlign: TextAlign.left,
                        //     //             style: AppFonts.robotoBold(25,
                        //     //                 color: AppColors.appPrimaryWhite(),
                        //     //                 decoration: TextDecoration.none),
                        //     //           ),
                        //     //         ),
                        //     //         Padding(
                        //     //           padding: const EdgeInsets.only(top: 8.0),
                        //     //           child: Text(
                        //     //             Utils.getTranslated(
                        //     //                 context, 'home_summary_tec')!,
                        //     //             textAlign: TextAlign.left,
                        //     //             style: AppFonts.robotoMedium(13,
                        //     //                 color:
                        //     //                     AppColors.appSummaryCardTextGrey(),
                        //     //                 decoration: TextDecoration.none),
                        //     //           ),
                        //     //         ),
                        //     //         Padding(
                        //     //           padding: const EdgeInsets.only(top: 8.0),
                        //     //           child: Row(
                        //     //             children: [
                        //     //               Text(
                        //     //                 Utils.getTranslated(
                        //     //                     context, 'yesterday')!,
                        //     //                 textAlign: TextAlign.left,
                        //     //                 style: AppFonts.robotoMedium(13,
                        //     //                     color: AppColors
                        //     //                         .appSummaryCardTextGrey(),
                        //     //                     decoration: TextDecoration.none),
                        //     //               ),
                        //     //               Padding(
                        //     //                 padding: const EdgeInsets.only(left: 8),
                        //     //                 child: Text(
                        //     //                   y_tec != null ? ('$y_tec') : '-',
                        //     //                   //textAlign: TextAlign.left,
                        //     //                   style: AppFonts.robotoMedium(13,
                        //     //                       color: AppColors
                        //     //                           .appSummaryCardTextGrey(),
                        //     //                       decoration: TextDecoration.none),
                        //     //                 ),
                        //     //               ),
                        //     //               tec != null
                        //     //                   ? Padding(
                        //     //                       padding: const EdgeInsets.only(
                        //     //                           left: 6),
                        //     //                       child: (dby_tec == y_tec)
                        //     //                           ? null
                        //     //                           : (dby_tec! >= y_tec!)
                        //     //                               ? Image.asset(
                        //     //                                   Constants
                        //     //                                           .ASSET_IMAGES +
                        //     //                                       'decrease_icon.png',
                        //     //                                   height: 13,
                        //     //                                 )
                        //     //                               : Image.asset(
                        //     //                                   Constants
                        //     //                                           .ASSET_IMAGES +
                        //     //                                       'increase_icon.png',
                        //     //                                   height: 13,
                        //     //                                 ))
                        //     //                   : Container()
                        //     //             ],
                        //     //           ),
                        //     //         ),
                        //     //       ]),
                        //     // ),
                        //   ],
                        // ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
