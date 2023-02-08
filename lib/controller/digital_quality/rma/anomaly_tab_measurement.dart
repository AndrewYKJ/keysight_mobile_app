import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:keysight_pma/const/appcolors.dart';
import 'package:keysight_pma/const/appfonts.dart';
import 'package:keysight_pma/const/constants.dart';
import 'package:keysight_pma/const/utils.dart';
import 'package:keysight_pma/model/arguments/dqm_argument.dart';
import 'package:keysight_pma/model/dqm/anomalies.dart';
import 'package:keysight_pma/routes/approutes.dart';

import '../../../cache/appcache.dart';

class AnomalyTabMeasurementScreen extends StatefulWidget {
  final List<MeasurementAnomalyDataDTO>? measurementAnomaly;
  AnomalyTabMeasurementScreen({Key? key, this.measurementAnomaly})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AnomalyTabMeasurementScreen();
  }
}

class _AnomalyTabMeasurementScreen extends State<AnomalyTabMeasurementScreen> {
  bool? isDarkTheme = AppCache.sortFilterCacheDTO!.currentTheme;
  int nextIndex = 1;

  @override
  void initState() {
    super.initState();
    Utils.setFirebaseAnalyticsCurrentScreen(
        Constants.ANALYTICS_DQM_RMA_MEASUREMENT_SCREEN);
    setState(() {
      if (widget.measurementAnomaly != null) {
        widget.measurementAnomaly!.sort((a, b) {
          return a.testName!.compareTo(b.testName!);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: MediaQuery.of(context).size.width,
        color: isDarkTheme!
            ? AppColors.appBlackLight()
            : AppColorsLightMode.appPrimaryBlack(),
        child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemCount: widget.measurementAnomaly!.length,
            itemBuilder: (BuildContext listContext, int index) {
              return measurementDataItem(
                  listContext, widget.measurementAnomaly![index], index);
            }),
      ),
    );
  }

  Widget measurementDataItem(
      BuildContext ctx, MeasurementAnomalyDataDTO measurementDTO, int index) {
    return GestureDetector(
      onTap: () {
        if ((index + 1) < widget.measurementAnomaly!.length) {
          Navigator.pushNamed(ctx, AppRoutes.dqmRmaTestResultRoute,
              arguments: DqmRmaArguments(
                  measurementDTO: measurementDTO,
                  nextMeasurementDTO: widget.measurementAnomaly![index + 1]));
        } else {
          Navigator.pushNamed(ctx, AppRoutes.dqmRmaTestResultRoute,
              arguments: DqmRmaArguments(measurementDTO: measurementDTO));
        }
      },
      child: Container(
        height: 60.0,
        padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    '${measurementDTO.testName}',
                    style: AppFonts.robotoMedium(
                      16,
                      color: isDarkTheme!
                          ? AppColors.appPrimaryWhite()
                          : AppColorsLightMode.appGrey(),
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
                SizedBox(width: 10.0),
                Image.asset(isDarkTheme!
                    ? Constants.ASSET_IMAGES + 'next_bttn.png'
                    : Constants.ASSET_IMAGES_LIGHT + 'next_bttn.png'),
              ],
            ),
            divider(ctx),
          ],
        ),
      ),
    );
  }

  Widget divider(BuildContext ctx) {
    return Container(
      height: 1.0,
      margin: EdgeInsets.only(top: 20.0),
      color: isDarkTheme!
          ? AppColors.appDividerColor()
          : AppColorsLightMode.appDividerColor(),
    );
  }
}
