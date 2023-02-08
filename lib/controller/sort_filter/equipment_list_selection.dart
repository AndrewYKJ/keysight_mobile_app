import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:keysight_pma/cache/appcache.dart';
import 'package:keysight_pma/const/appcolors.dart';
import 'package:keysight_pma/const/appfonts.dart';
import 'package:keysight_pma/const/constants.dart';
import 'package:keysight_pma/const/utils.dart';
import 'package:keysight_pma/dio/api/sort_filter.dart';
import 'package:keysight_pma/model/arguments/search_argument.dart';
import 'package:keysight_pma/model/sortAndFilter/equipment.dart';
import 'package:keysight_pma/routes/approutes.dart';

class SortAndFilterEquipmentListScreen extends StatefulWidget {
  SortAndFilterEquipmentListScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SortAndFilterEquipmentListScreen();
  }
}

class _SortAndFilterEquipmentListScreen
    extends State<SortAndFilterEquipmentListScreen> {
  List<EquipmentDataDTO> equipmentList = [];
  bool isLoading = true;
  bool? theme_dark = AppCache.sortFilterCacheDTO!.currentTheme;
  Future<EquipmentDTO> loadEquipments(
      BuildContext ctx, String companyId, String siteId) {
    SortFilterApi sortFilterApi = SortFilterApi(ctx);
    return sortFilterApi.loadEquipments(companyId, siteId);
  }

  @override
  void initState() {
    super.initState();
    Utils.setFirebaseAnalyticsCurrentScreen(
        Constants.ANALYTICS_EQUIPMENT_LIST_SELECTION_SCREEN);
    loadEquipments(context, AppCache.sortFilterCacheDTO!.preferredCompany!,
            AppCache.sortFilterCacheDTO!.preferredSite!)
        .then((value) {
      if (value.data != null && value.data!.length > 0) {
        value.data!.forEach((element) {
          element.isSelected = false;
          for (int i = 0;
              i < AppCache.sortFilterCacheDTO!.defaultEquipments!.length;
              i++) {
            EquipmentDataDTO cacheEquipmentDTO =
                AppCache.sortFilterCacheDTO!.defaultEquipments![i];
            if (element.equipmentId == cacheEquipmentDTO.equipmentId) {
              element.isSelected = true;
              break;
            }
          }

          this.equipmentList.add(element);
        });
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
      setState(() {
        this.isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme_dark!
            ? AppColors.serverAppBar()
            : AppColorsLightMode.serverAppBar(),
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Padding(
          padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
          child: Text(
            Utils.getTranslated(context, 'sort_and_filter_equipment')!,
            style: AppFonts.robotoRegular(
              20,
              color: theme_dark!
                  ? AppColors.appGrey()
                  : AppColorsLightMode.appGrey(),
              decoration: TextDecoration.none,
            ),
          ),
        ),
        leading: GestureDetector(
          onTap: () {
            AppCache.sortFilterCacheDTO!.defaultEquipments = this
                .equipmentList
                .where((element) => element.isSelected!)
                .toList();
            Navigator.pop(context, true);
          },
          child: Image.asset(
            theme_dark!
                ? Constants.ASSET_IMAGES + 'back_bttn.png'
                : Constants.ASSET_IMAGES_LIGHT + 'back_bttn.png',
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () async {
              if (this.equipmentList.length > 0) {
                final navResult = await Navigator.pushNamed(
                  context,
                  AppRoutes.searchRoute,
                  arguments: SearchArguments(equipMentList: this.equipmentList),
                );

                if (navResult != null) {
                  String tmpId = navResult as String;
                  setState(() {
                    EquipmentDataDTO equipmentDataDTO = this
                        .equipmentList
                        .firstWhere((element) => element.equipmentId == tmpId);
                    equipmentDataDTO.isSelected = !equipmentDataDTO.isSelected!;
                  });
                }
              }
            },
            child: Image.asset(theme_dark!
                ? Constants.ASSET_IMAGES + 'search_icon.png'
                : Constants.ASSET_IMAGES_LIGHT + 'search.png'),
          )
        ],
      ),
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 21.0),
          child: this.isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppColors.appBlue()),
                  ),
                )
              : Wrap(
                  children: equipmentList
                      .map((e) => equipmentItem(context, e))
                      .toList(),
                ),
        ),
      ),
    );
  }

  Widget equipmentItem(BuildContext ctx, EquipmentDataDTO equipmentDataDTO) {
    return GestureDetector(
      onTap: () {
        setState(() {
          equipmentDataDTO.isSelected = !equipmentDataDTO.isSelected!;
        });
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(12.0, 9.0, 12.0, 9.0),
        margin: EdgeInsets.only(right: 14.0, top: 14.0),
        decoration: BoxDecoration(
          color: equipmentDataDTO.isSelected!
              ? AppColors.appTeal()
              : Colors.transparent,
          border: equipmentDataDTO.isSelected!
              ? Border.all(color: Colors.transparent)
              : Border.all(color: AppColors.appTeal()),
          borderRadius: BorderRadius.circular(50.0),
        ),
        child: Text(
          equipmentDataDTO.equipmentName!,
          style: AppFonts.robotoMedium(
            14,
            color: equipmentDataDTO.isSelected!
                ? AppColors.appPrimaryWhite()
                : AppColors.appTeal(),
            decoration: TextDecoration.none,
          ),
        ),
      ),
    );
  }
}
