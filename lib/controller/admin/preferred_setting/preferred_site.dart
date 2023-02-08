import 'package:flutter/material.dart';
import 'package:keysight_pma/cache/appcache.dart';

import 'package:keysight_pma/const/appcolors.dart';
import 'package:keysight_pma/const/appfonts.dart';
import 'package:keysight_pma/const/constants.dart';
import 'package:keysight_pma/const/utils.dart';
import 'package:keysight_pma/controller/admin/preferred_setting/custom.dart';
import 'package:keysight_pma/model/arguments/search_argument.dart';
import 'package:keysight_pma/model/customize.dart';
import 'package:keysight_pma/model/user.dart';
import 'package:keysight_pma/routes/approutes.dart';

class PreferredSite extends StatefulWidget {
  final String preferredSite;
  final String preferredCompany;
  PreferredSite(
      {Key? key, required this.preferredSite, required this.preferredCompany})
      : super(key: key);

  @override
  State<PreferredSite> createState() => _PreferredSiteState();
}

class _PreferredSiteState extends State<PreferredSite> {
  String? returnValue;

  bool? theme_dark;
  List<CustomerMapDataDTO>? isMappedData = [];
  List<CustomerMapDataDTO>? emtpy = [];
  List<PDate> dataList = [];
  PDate returnData = PDate();

  String? preferredCompany;
  String? preferredSite;
  UserDataDTO? user_info;

  List<CustomPreferredSortFilterProjectsDTO> preferedCompanyList = [];
  List<CustomPreferredSortFilterProjectsDTO> preferedSiteList = [];
  late Map<String?, List<CustomerMapDataDTO>> preferedCompanyListMap;
  late Map<String?, List<CustomerMapDataDTO>> preferedSiteListMap;
  var count = 0;
  @override
  void initState() {
    super.initState();
    Utils.setFirebaseAnalyticsCurrentScreen(
        Constants.ANALYTICS_ADMIN_PREFERRED_COMP_SITE_SCREEN);
    user_info = AppCache.me!.data;

    setState(() {
      preferredCompany = widget.preferredCompany;
      preferredSite = widget.preferredSite;

      user_info!.customerMap!.sort((a, b) {
        return a.siteName!.compareTo(b.siteName!);
      });

      user_info!.customerMap!.sort((a, b) {
        return a.companyName!.compareTo(b.companyName!);
      });

      for (int x = 0; x < user_info!.customerMap!.length; x++) {
        CustomerMapDataDTO y = user_info!.customerMap![x];
        if (y.isCompanySiteMapped == true) isMappedData!.add(y);
      }

      // isMappedData!.forEach((element) {
      //   PDate value = PDate(
      //       isSelected: element.siteId == widget.preferredSite ? true : false,
      //       rangeName: element.companyName,
      //       rangeValue: element.siteName,
      //       rangeGroup: element.siteId);

      //   dataList.add(value);
      // });
    });
    setState(() {
      theme_dark = AppCache.sortFilterCacheDTO!.currentTheme;
    });
    // print(data![1].companyId);
  }

  // void groupPreferredSite() {
  //   final groups =
  //       groupBy(this.user_info!.customerMap!, (CustomerMapDataDTO e) {
  //     CustomPreferredSortFilterProjectsDTO x =
  //         CustomPreferredSortFilterProjectsDTO(name: e.siteName, id: e.siteId);
  //     return e.siteId;
  //   });

  //   setState(() {
  //     this.preferedSiteListMap = groups;
  //     preferedSiteList.clear();
  //     this.preferedSiteListMap.keys.forEach((element) {
  //       CustomPreferredSortFilterProjectsDTO itemDTO =
  //           CustomPreferredSortFilterProjectsDTO(element, true);
  //       preferedSiteList.add(itemDTO);
  //     });
  //   });
  // }

  // void groupPreferredCompany() {
  //   final groups =
  //       groupBy(this.user_info!.customerMap!, (CustomerMapDataDTO e) {
  //     return e.companyId;
  //   });

  //   setState(() {
  //     this.preferedSiteListMap = groups;
  //     preferedSiteList.clear();
  //     this.preferedSiteListMap.keys.forEach((element) {
  //       CustomDqmSortFilterItemSelectionDTO itemDTO =
  //           CustomDqmSortFilterItemSelectionDTO(element, true);
  //       preferedSiteList.add(itemDTO);
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
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
          Utils.getTranslated(context, 'preferredSetting_site')!,
          style: AppFonts.robotoRegular(20,
              color: theme_dark!
                  ? AppColors.appGrey()
                  : AppColorsLightMode.appGrey(),
              decoration: TextDecoration.none),
        ),
        leading: IconButton(
            onPressed: () {
              // dataList.forEach((element) {
              //   if (element.isSelected!) {
              //     setState(() {
              //       widget.preferredCompany = element.rangeGroup!;
              //       widget.preferredSite = element.rangeGroup!;
              //     });
              //   }
              // });
              Navigator.pop(context, returnData);
            },
            icon: Image.asset(
              theme_dark!
                  ? Constants.ASSET_IMAGES + 'back_bttn.png'
                  : Constants.ASSET_IMAGES_LIGHT + 'back_bttn.png',
            )),
        actions: [
          IconButton(
              onPressed: () async {
                if (this.isMappedData!.length > 0) {
                  final value = await Navigator.pushNamed(
                    context,
                    AppRoutes.searchRoute,
                    arguments: SearchArguments(
                      customerMapData: this.isMappedData,
                    ),
                  );

                  if (value != null) {
                    CustomerMapDataDTO data = value as CustomerMapDataDTO;
                    setState(() {
                      this.preferredCompany = data.companyId!;
                      this.preferredSite = data.siteId!;
                      print('################################');
                      print(preferredCompany);
                      print(preferredSite);
                      returnData = PDate(
                          rangeName: this.preferredCompany,
                          rangeValue: this.preferredSite);
                    });
                  }
                }

                //Navigator.pushNamed(context, AppRoutes.searchRoute);
              },
              icon: Image.asset(
                theme_dark!
                    ? Constants.ASSET_IMAGES + 'search_icon.png'
                    : Constants.ASSET_IMAGES_LIGHT + 'search.png',
                height: 24,
              )),
        ],
      ),
      body: Container(
          margin: EdgeInsets.only(top: 12, left: 16, right: 16),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: isMappedData!
                  .map((
                    e,
                  ) =>
                      preferredSiteDataItem(context, e))
                  .toList(),
            ),
          )),
    );
  }

  Widget preferredSiteDataItem(BuildContext context, CustomerMapDataDTO e) {
    String title = e.companyName! + ' | ' + e.siteName!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              this.preferredCompany = e.companyId!;
              this.preferredSite = e.siteId!;
              returnData = PDate(
                  rangeName: this.preferredCompany,
                  rangeValue: this.preferredSite);
              print(preferredCompany);
              print(preferredSite);
            });
          },
          child: Container(
            padding: EdgeInsets.only(top: 12, right: 20, bottom: 10),
            color: Colors.transparent,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 300,
                    child: Text(
                      title,
                      style: AppFonts.robotoRegular(16,
                          color: theme_dark!
                              ? AppColors.appGrey()
                              : AppColorsLightMode.appGrey(),
                          decoration: TextDecoration.none),
                    ),
                  ),
                  (preferredCompany == e.companyId && preferredSite == e.siteId)
                      ? Image.asset(
                          theme_dark!
                              ? Constants.ASSET_IMAGES + 'tick_icon.png'
                              : Constants.ASSET_IMAGES_LIGHT + 'tick_icon.png',
                          height: 17,
                        )
                      : Text(''),
                ]),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: Divider(
            color: theme_dark!
                ? AppColors.appDividerColor()
                : AppColorsLightMode.appDividerColor(),
          ),
        ),
      ],
    );
  }
}
