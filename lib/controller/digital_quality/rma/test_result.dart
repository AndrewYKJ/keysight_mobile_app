import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:keysight_pma/cache/appcache.dart';
import 'package:keysight_pma/const/appcolors.dart';
import 'package:keysight_pma/const/appfonts.dart';
import 'package:keysight_pma/const/constants.dart';
import 'package:keysight_pma/const/utils.dart';
import 'package:keysight_pma/controller/digital_quality/rma/test_result_corelation.dart';
import 'package:keysight_pma/controller/digital_quality/rma/test_result_scatter.dart';
import 'package:keysight_pma/model/dqm/anomalies.dart';

class DqmRmaTestResultScreen extends StatefulWidget {
  final MeasurementAnomalyDataDTO? measurementDTO;
  final MeasurementAnomalyDataDTO? nextMeasurementDTO;
  DqmRmaTestResultScreen(
      {Key? key, this.measurementDTO, this.nextMeasurementDTO})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DqmRmaTestResultScreen();
  }
}

typedef DownloadAsImage = void Function(
    BuildContext context, void Function() downloadAsImage);
typedef DownloadAsPdf = void Function(
    BuildContext context, void Function() downloadAsPdf);
typedef DownloadAsCsv = void Function(
    BuildContext context, void Function() downloadAsCsv);

class _DqmRmaTestResultScreen extends State<DqmRmaTestResultScreen> {
  int currentTab = 0;
  bool? isDarkTheme = AppCache.sortFilterCacheDTO!.currentTheme;
  late void Function() callDownloadImage;
  late void Function() callDownloadPdf;
  late void Function() callDownloadCsv;

  TabBar get _tabBar => widget.nextMeasurementDTO != null
      ? TabBar(
          indicatorColor: AppColors.appBlue(),
          isScrollable: true,
          tabs: [
            Tab(
              child: Text(
                Utils.getTranslated(
                    context, "dqm_rma_test_result_tab_scatter")!,
                style: AppFonts.robotoMedium(
                  13,
                  color: currentTab == 0
                      ? AppColors.appBlue()
                      : isDarkTheme!
                          ? AppColors.appPrimaryWhite()
                          : AppColorsLightMode.appGrey(),
                  decoration: TextDecoration.none,
                ),
              ),
            ),
            Tab(
              child: Text(
                Utils.getTranslated(
                    context, "dqm_rma_test_result_tab_corelation")!,
                style: AppFonts.robotoMedium(
                  13,
                  color: currentTab == 1
                      ? AppColors.appBlue()
                      : isDarkTheme!
                          ? AppColors.appPrimaryWhite()
                          : AppColorsLightMode.appGrey(),
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          ],
        )
      : TabBar(
          indicatorColor: AppColors.appBlue(),
          isScrollable: true,
          tabs: [
            Tab(
              child: Text(
                Utils.getTranslated(
                    context, "dqm_rma_test_result_tab_scatter")!,
                style: AppFonts.robotoMedium(
                  13,
                  color: currentTab == 0
                      ? AppColors.appBlue()
                      : AppColors.appPrimaryWhite(),
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          ],
        );

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: widget.nextMeasurementDTO != null ? 2 : 1,
      child: Builder(builder: (BuildContext context) {
        final TabController tabController = DefaultTabController.of(context)!;
        tabController.addListener(() {
          if (tabController.indexIsChanging) {
            setState(() {
              this.currentTab = tabController.index;
            });
          }
        });
        return Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            centerTitle: true,
            backgroundColor: isDarkTheme!
                ? AppColors.serverAppBar()
                : AppColorsLightMode.serverAppBar(),
            title: Text(
              Utils.getTranslated(context, "dqm_rma_test_result_appbar_title")!,
              style: AppFonts.robotoRegular(
                20,
                color: isDarkTheme!
                    ? AppColors.appGrey()
                    : AppColorsLightMode.appGrey(),
                decoration: TextDecoration.none,
              ),
            ),
            actions: [
              GestureDetector(
                  onTap: () {
                    showDownloadPopup(context);
                  },
                  child: Image.asset(
                    isDarkTheme!
                        ? Constants.ASSET_IMAGES + 'download_bttn.png'
                        : Constants.ASSET_IMAGES_LIGHT + 'download_bttn.png',
                  ))
            ],
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Image.asset(
                isDarkTheme!
                    ? Constants.ASSET_IMAGES + 'back_bttn.png'
                    : Constants.ASSET_IMAGES_LIGHT + 'back_bttn.png',
              ),
            ),
            bottom: PreferredSize(
              preferredSize: _tabBar.preferredSize,
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(left: 16.0, right: 16.0),
                color: isDarkTheme!
                    ? AppColors.appPrimaryBlack()
                    : AppColorsLightMode.appPrimaryBlack(),
                child: _tabBar,
              ),
            ),
          ),
          body: SafeArea(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.only(bottom: 20.0),
              child: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                children: widget.nextMeasurementDTO != null
                    ? [
                        TestResultScatterScreen(
                          measurementDTO: widget.measurementDTO,
                          dwnImg:
                              (BuildContext context, void Function() download) {
                            callDownloadImage = download;
                          },
                          dwnPdf:
                              (BuildContext context, void Function() download) {
                            callDownloadPdf = download;
                          },
                          dwnCsv:
                              (BuildContext context, void Function() download) {
                            callDownloadCsv = download;
                          },
                        ),
                        TestResultCorelationScreen(
                          measurementDTO: widget.measurementDTO,
                          nextMeasurementDTO: widget.nextMeasurementDTO,
                          dwnImg:
                              (BuildContext context, void Function() download) {
                            callDownloadImage = download;
                          },
                          dwnPdf:
                              (BuildContext context, void Function() download) {
                            callDownloadPdf = download;
                          },
                          dwnCsv:
                              (BuildContext context, void Function() download) {
                            callDownloadCsv = download;
                          },
                        ),
                      ]
                    : [
                        TestResultScatterScreen(
                          measurementDTO: widget.measurementDTO,
                          dwnImg:
                              (BuildContext context, void Function() download) {
                            callDownloadImage = download;
                          },
                          dwnPdf:
                              (BuildContext context, void Function() download) {
                            callDownloadPdf = download;
                          },
                          dwnCsv:
                              (BuildContext context, void Function() download) {
                            callDownloadCsv = download;
                          },
                        ),
                      ],
              ),
            ),
          ),
        );
      }),
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
              onPressed: () {
                callDownloadImage.call();
                Navigator.pop(popContext);
              },
              child: Text(
                Utils.getTranslated(context, 'download_as_image')!,
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
              onPressed: () async {
                callDownloadCsv.call();
                Navigator.pop(popContext);
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
          Container(
            color: isDarkTheme!
                ? AppColors.cupertinoBackground()
                : AppColorsLightMode.cupertinoBackground().withOpacity(0.8),
            child: CupertinoActionSheetAction(
              onPressed: () {
                callDownloadPdf.call();
                Navigator.pop(popContext);
              },
              child: Text(
                Utils.getTranslated(context, 'download_as_pdf')!,
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
}
