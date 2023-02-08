import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:keysight_pma/cache/appcache.dart';
import 'package:keysight_pma/const/appcolors.dart';
import 'package:keysight_pma/const/appfonts.dart';
import 'package:keysight_pma/const/constants.dart';
import 'package:keysight_pma/model/arguments/dqm_argument.dart';
import 'package:keysight_pma/model/dqm/anomalies.dart';
import 'package:keysight_pma/routes/approutes.dart';

class AnomalyTabChangeLimitScreen extends StatefulWidget {
  final List<LimitChangeAnomalyDataDTO>? limitChangeAnomaly;
  final String? serialNumber;
  AnomalyTabChangeLimitScreen(
      {Key? key, this.limitChangeAnomaly, this.serialNumber})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AnomalyTabChangeLimitScreen();
  }
}

class _AnomalyTabChangeLimitScreen extends State<AnomalyTabChangeLimitScreen> {
  bool? theme_dark = AppCache.sortFilterCacheDTO!.currentTheme;
  @override
  void initState() {
    super.initState();
    setState(() {
      if (widget.limitChangeAnomaly != null) {
        widget.limitChangeAnomaly!.sort((a, b) {
          return a.testName!.compareTo(b.testName!);
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: MediaQuery.of(context).size.width,
        color: theme_dark!
            ? AppColors.appBlackLight()
            : AppColorsLightMode.appPrimaryBlack(),
        child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemCount: widget.limitChangeAnomaly!.length,
            itemBuilder: (BuildContext listContext, int index) {
              return limitChangeDataItem(
                  listContext, widget.limitChangeAnomaly![index]);
            }),
      ),
    );
  }

  Widget limitChangeDataItem(
      BuildContext ctx, LimitChangeAnomalyDataDTO limitChangeDTO) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(ctx, AppRoutes.dqmRmaTestResultChangeLimitRoute,
            arguments: DqmRmaArguments(
                limitChangeDTO: limitChangeDTO,
                serialNumber: widget.serialNumber));
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
                    '${limitChangeDTO.testName}',
                    style: AppFonts.robotoMedium(
                      16,
                      color: theme_dark!
                          ? AppColors.appPrimaryWhite()
                          : AppColorsLightMode.appGrey(),
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
                SizedBox(width: 10.0),
                Image.asset(theme_dark!
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
      color: theme_dark!
          ? AppColors.appDividerColor()
          : AppColorsLightMode.appDividerColor(),
    );
  }
}
