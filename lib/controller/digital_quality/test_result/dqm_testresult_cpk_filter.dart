import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:keysight_pma/cache/appcache.dart';
import 'package:keysight_pma/const/appcolors.dart';
import 'package:keysight_pma/const/appfonts.dart';
import 'package:keysight_pma/const/constants.dart';
import 'package:keysight_pma/const/utils.dart';
import 'package:keysight_pma/model/dqm/custom.dart';

class DqmTestResultCpkFilterScreen extends StatefulWidget {
  final String? sigmaType;
  DqmTestResultCpkFilterScreen({Key? key, this.sigmaType}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DqmTestResultCpkFilterScreen();
  }
}

class _DqmTestResultCpkFilterScreen
    extends State<DqmTestResultCpkFilterScreen> {
  late DqmCustomDTO _dqmCustomDTO;
  bool? isDarkTheme = AppCache.sortFilterCacheDTO!.currentTheme;

  List<DqmCustomDTO> sigmaList = [
    DqmCustomDTO(
        customDataName: 'filter_by_all',
        customDataValue: Constants.SIGMA_ALL,
        customDataIsSelected: false),
    DqmCustomDTO(
        customDataName: 'filter_by_6_sigma',
        customDataValue: Constants.SIGMA_6,
        customDataIsSelected: false),
    DqmCustomDTO(
        customDataName: 'filter_by_5_sigma',
        customDataValue: Constants.SIGMA_5,
        customDataIsSelected: false),
    DqmCustomDTO(
        customDataName: 'filter_by_4_sigma',
        customDataValue: Constants.SIGMA_4,
        customDataIsSelected: false),
    DqmCustomDTO(
        customDataName: 'filter_by_3_sigma',
        customDataValue: Constants.SIGMA_3,
        customDataIsSelected: false),
  ];

  @override
  void initState() {
    super.initState();
    Utils.setFirebaseAnalyticsCurrentScreen(
        Constants.ANALYTICS_DQM_TEST_RESULT_SIGMA_FILTER_SCREEN);
    setState(() {
      sigmaList
          .firstWhere((element) => element.customDataValue == widget.sigmaType)
          .customDataIsSelected = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDarkTheme!
            ? AppColors.serverAppBar()
            : AppColorsLightMode.serverAppBar(),
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Padding(
          padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
          child: Text(
            Utils.getTranslated(context, 'sort_and_filter_appbar_text')!,
            style: AppFonts.robotoRegular(
              20,
              color: isDarkTheme!
                  ? AppColors.appGrey()
                  : AppColorsLightMode.appGrey(),
              decoration: TextDecoration.none,
            ),
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Image.asset(isDarkTheme!
                ? Constants.ASSET_IMAGES + 'close_bttn.png'
                : Constants.ASSET_IMAGES_LIGHT + 'close_icon.png'),
          )
        ],
      ),
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 21.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      sigma(context),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 14.0),
                color: isDarkTheme!
                    ? AppColors.appPrimaryBlack()
                    : AppColorsLightMode.appPrimaryBlack(),
                child: GestureDetector(
                  onTap: () {
                    if (Utils.isNotEmpty(_dqmCustomDTO.customDataValue)) {
                      Navigator.pop(context, _dqmCustomDTO.customDataValue);
                    }
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(left: 90.0, right: 90.0),
                    padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                    decoration: BoxDecoration(
                        color: AppColors.appPrimaryYellow(),
                        border: Border.all(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(2.0)),
                    child: Text(
                      Utils.getTranslated(
                          context, 'sort_and_filter_filter_btn')!,
                      style: AppFonts.robotoMedium(
                        15,
                        color: AppColors.appPrimaryWhite(),
                        decoration: TextDecoration.none,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                // child: Row(
                //   mainAxisAlignment: MainAxisAlignment.start,
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     Expanded(
                //       child: GestureDetector(
                //         onTap: () {},
                //         child: Container(
                //           padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                //           decoration: BoxDecoration(
                //               color: Colors.transparent,
                //               border: Border.all(color: AppColors.appGreyD3()),
                //               borderRadius: BorderRadius.circular(2.0)),
                //           child: Text(
                //             Utils.getTranslated(
                //                 context, 'sort_and_filter_clear_btn')!,
                //             style: AppFonts.robotoMedium(
                //               15,
                //               color: AppColors.appPrimaryWhite(),
                //               decoration: TextDecoration.none,
                //             ),
                //             textAlign: TextAlign.center,
                //           ),
                //         ),
                //       ),
                //     ),
                //     SizedBox(width: 16.0),
                //     Expanded(
                //       child: GestureDetector(
                //         onTap: () {
                //           if (Utils.isNotEmpty(_dqmCustomDTO.customDataValue)) {
                //             Navigator.pop(
                //                 context, _dqmCustomDTO.customDataValue);
                //           }
                //         },
                //         child: Container(
                //           padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                //           decoration: BoxDecoration(
                //               color: AppColors.appPrimaryYellow(),
                //               border: Border.all(color: Colors.transparent),
                //               borderRadius: BorderRadius.circular(2.0)),
                //           child: Text(
                //             Utils.getTranslated(
                //                 context, 'sort_and_filter_filter_btn')!,
                //             style: AppFonts.robotoMedium(
                //               15,
                //               color: AppColors.appPrimaryWhite(),
                //               decoration: TextDecoration.none,
                //             ),
                //             textAlign: TextAlign.center,
                //           ),
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget sigma(BuildContext ctx) {
    return Container(
      margin: EdgeInsets.only(top: 22.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Utils.getTranslated(
                ctx, 'dqm_testresult_analog_cpk_filterby_sigma')!,
            style: AppFonts.robotoRegular(
              16,
              color: isDarkTheme!
                  ? AppColors.appGrey2()
                  : AppColorsLightMode.appGrey(),
              decoration: TextDecoration.none,
            ),
          ),
          SizedBox(height: 8.0),
          Wrap(
            children: sigmaList.map((e) => dataItem(ctx, e)).toList(),
          ),
        ],
      ),
    );
  }

  Widget dataItem(BuildContext ctx, DqmCustomDTO dqmCustomDTO) {
    return GestureDetector(
      onTap: () {
        sigmaList.forEach((value) {
          value.customDataIsSelected = false;
        });

        setState(() {
          dqmCustomDTO.customDataIsSelected = true;
          _dqmCustomDTO = dqmCustomDTO;
        });
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(12.0, 9.0, 12.0, 9.0),
        margin: EdgeInsets.only(right: 14.0, top: 14.0),
        decoration: BoxDecoration(
          color: dqmCustomDTO.customDataIsSelected!
              ? AppColors.appTeal()
              : Colors.transparent,
          border: dqmCustomDTO.customDataIsSelected!
              ? Border.all(color: Colors.transparent)
              : Border.all(color: AppColors.appTeal()),
          borderRadius: BorderRadius.circular(50.0),
        ),
        child: Text(
          Utils.getTranslated(ctx, dqmCustomDTO.customDataName!)!,
          style: AppFonts.robotoMedium(
            14,
            color: dqmCustomDTO.customDataIsSelected!
                ? AppColors.appPrimaryWhite()
                : AppColors.appTeal(),
            decoration: TextDecoration.none,
          ),
        ),
      ),
    );
  }
}
