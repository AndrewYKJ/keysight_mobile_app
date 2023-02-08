import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:keysight_pma/cache/appcache.dart';
import 'package:keysight_pma/const/appcolors.dart';
import 'package:keysight_pma/const/appfonts.dart';
import 'package:keysight_pma/const/constants.dart';
import 'package:keysight_pma/const/utils.dart';
import 'package:keysight_pma/controller/admin/preferred_setting/custom.dart';
import 'package:keysight_pma/dio/api/user.dart';
import 'package:keysight_pma/main.dart';
import 'package:keysight_pma/model/updateUserPrefModel.dart';
import 'package:keysight_pma/model/user.dart';
import 'package:keysight_pma/routes/approutes.dart';

class PreferredSettings extends StatefulWidget {
  UserDataDTO? user_info;
  PreferredSettings({
    Key? key,
    this.user_info,
  }) : super(key: key);

  @override
  State<PreferredSettings> createState() => _PreferredSettingsState();
}

class _PreferredSettingsState extends State<PreferredSettings> {
  String _currentLanguage = '';
  bool isLoading = false;
  var date;
  List<CustomerMapDataDTO>? customerMap;
  var site;
  UserDTO? _user;
  late String selectedId;

  late String selectedCompany;
  String? title;
  String? projectName;
  String? versionName;
  UserDataDTO? buffer;
  List<CustomerMapDataDTO> mapSite = [];
  PreferredLanguage? preferredLanguageData = PreferredLanguage();
  PreferredLandingPageDto? preferredLandingPageData = PreferredLandingPageDto();
  PreferredDaysDto? preferredDaysData = PreferredDaysDto();
  ProjectVersionDTO? preferredProjectVersionsData =
      ProjectVersionDTO(projectVersionList: [], defaultProjectId: null);
  UpdateLoadProject? preferredProjectSetting = UpdateLoadProject();
  updatePreferenceSettingDataDTO newPrefSetting =
      updatePreferenceSettingDataDTO();
  updatePreferenceSettingDTO? response;
  SiteLoadProjectDTO? siteProjectListDTO;

  Future<updatePreferenceSettingDTO> putUpdatePrefSetting(BuildContext ctx) {
    UserApi preferenceUpdateApi = UserApi(ctx);
    return preferenceUpdateApi.updatePreferenceSetting(
        bodyData: newPrefSetting);
  }

  bool? theme_dark;
  @override
  void initState() {
    super.initState();
    Utils.setFirebaseAnalyticsCurrentScreen(
        Constants.ANALYTICS_ADMIN_PREFERRED_SETTING_SCREEN);
    setState(() {
      theme_dark = AppCache.sortFilterCacheDTO!.currentTheme;
      // _currentLanguage = widget.user_info!.preferredLang!;
      // customerMap = widget.user_info!.customerMap!;
      mapSite = widget.user_info!.customerMap!;

      preferredDaysData!.preferredDays = '';
      preferredProjectVersionsData!.siteId = '';
      preferredProjectSetting!.siteId = preferredProjectVersionsData!.siteId;
      // preferredLanguageData!.preferredLanguageCode = _currentLanguage;
      preferredLandingPageData!.preferredLandingPage =
          widget.user_info!.preferredLandingPage;
      preferredProjectVersionsData!.companyId =
          widget.user_info!.preferredCompany!;
      if (AppCache.me != null) {
        _currentLanguage = AppCache.me!.data!.preferredLangCode!;
        _user = AppCache.me;
        AppCache.me!.data!.projectVersionsDTOs![0].defaultProjectId != null
            ? preferredProjectSetting!.defaultProjectId =
                AppCache.me!.data!.projectVersionsDTOs![0].defaultProjectId
            : null;
      }
    });
    getSiteProject(context);
  }

  Future<SiteLoadProjectDTO> getSiteProject(BuildContext ctx) {
    UserApi callProjectList = UserApi(ctx);
    return callProjectList.getSiteProject(
        AppCache.sortFilterCacheDTO!.preferredCompany!,
        (site != null) ? site! : widget.user_info!.preferredSite);
  }

  void getUserProfile() {
    UserApi userProfileApi = UserApi(context);

    userProfileApi.getUserDetail().then((data) {
      if (data.status!.statusCode == 200) {
        _user = data;
        setState(() {
          AppCache.me = _user;
          this.widget.user_info = AppCache.me!.data;
        });

        if (_user!.data!.preferredLangCode! == Constants.CHINESE) {
          AppCache.setString(
              AppCache.LANGUAGE_CODE_PREF, Constants.LANGUAGE_CODE_CN);
          MyHomePage.setLocale(
              context, Utils.mylocale(Constants.LANGUAGE_CODE_CN));
        } else {
          AppCache.setString(
              AppCache.LANGUAGE_CODE_PREF, Constants.LANGUAGE_CODE_EN);
          MyHomePage.setLocale(
              context, Utils.mylocale(Constants.LANGUAGE_CODE_EN));
        }
      }
    }).whenComplete(() {
      setState(() {
        this.isLoading = false;
        this.widget.user_info = _user!.data;
        if (EasyLoading.isShow) {
          EasyLoading.dismiss();
        }
      });
    }).catchError((error) {});
  }

  callAllData(BuildContext context) async {
    await putUpdatePrefSetting(context).then((value) {
      if (value.status!.statusCode == 200) {
        response = value;
        getUserProfile();
      } else {
        if (EasyLoading.isShow) {
          EasyLoading.dismiss();
        }
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
      if (EasyLoading.isShow) {
        EasyLoading.dismiss();
      }
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

  loadProjectbySite(BuildContext context) async {
    await getSiteProject(context).then((value) {
      siteProjectListDTO = value;

      // print(AppCache.sortFilterCacheDTO!.defaultEquipments![0].equipmentId!);
      //  print(summaryUtilAndNonUtilData.data![0]);
    }).catchError((error) {
      Utils.printInfo(error);
    });

    setState(() {
      isLoading = false;
    });
  }

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
          Utils.getTranslated(context, 'preferredSetting_appbar')!,
          style: AppFonts.robotoRegular(20,
              color: theme_dark!
                  ? AppColors.appGrey()
                  : AppColorsLightMode.appGrey(),
              decoration: TextDecoration.none),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            icon: Image.asset(
              theme_dark!
                  ? Constants.ASSET_IMAGES + 'back_bttn.png'
                  : Constants.ASSET_IMAGES_LIGHT + 'back_bttn.png',
            )),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.appBlue()),
              ),
            )
          : Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.only(left: 16, right: 16),
              //margin: EdgeInsets.only(top: 26),

              child: Stack(
                children: [
                  Column(
                    children: [
                      SizedBox(height: 22),
                      _language(),
                      _date(),
                      _site(context),
                      _project(),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: saveButton(),
                  )
                ],
              ),
            ),
    );
  }

  Container saveButton() {
    return Container(
      child: GestureDetector(
        onTap: () {
          setState(() {
            preferredLanguageData!.preferredLanguageCode = _currentLanguage;
            preferredProjectVersionsData!.companyId =
                widget.user_info!.preferredCompany!;

            if (preferredDaysData!.preferredDays!.length == 0) {
              preferredDaysData!.preferredDays =
                  widget.user_info!.preferredDays;
            }
            // if (preferredProjectVersionsData!.projectVersionList!.length == 0) {
            //   preferredProjectVersionsData!.projectVersionList =
            //       widget.user_info!.projectVersionsDTOs![0].projectVersionList!;
            // }

            if (preferredProjectVersionsData!.siteId!.length == 0) {
              preferredProjectVersionsData!.siteId =
                  widget.user_info!.projectVersionsDTOs![0].siteId!;
            }

            newPrefSetting = updatePreferenceSettingDataDTO(
                analyticsConsent: true,
                preferredDaysDto: preferredDaysData,
                preferredLandingPageDto: preferredLandingPageData,
                preferredLanguage: preferredLanguageData,
                projectVersionDTO: preferredProjectVersionsData);

            EasyLoading.show(maskType: EasyLoadingMaskType.black);
            callAllData(context);
          });
        },
        child: Container(
          height: 40,
          padding: const EdgeInsets.all(12),
          color: AppColors.appPrimaryYellow(),
          width: 236,
          child: Text(
            Utils.getTranslated(context, 'save_changes')!,
            style: AppFonts.robotoMedium(14,
                color: AppColors.appPrimaryWhite(),
                decoration: TextDecoration.none),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  GestureDetector _language() {
    return GestureDetector(
      onTap: () async {
        final navResult = await Navigator.pushNamed(
            context, AppRoutes.preferred_language,
            arguments: _currentLanguage);

        if (navResult != null) {
          setState(() {
            _currentLanguage = navResult as String;
          });
        }
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              Utils.getTranslated(context, 'preferredSetting_language')!,
              style: AppFonts.robotoMedium(16,
                  color: theme_dark!
                      ? AppColors.appGrey2()
                      : AppColorsLightMode.appGrey86(),
                  decoration: TextDecoration.none),
            ),
            Container(
              margin: EdgeInsets.only(right: 6, top: 5, bottom: 5),
              padding: EdgeInsets.only(top: 15, bottom: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _currentLanguage == Constants.CHINESE
                        ? Utils.getTranslated(context, 'setting_language_zh')!
                        : Utils.getTranslated(context, 'setting_language_en')!,
                    style: AppFonts.robotoRegular(16,
                        color: theme_dark!
                            ? AppColors.appGreyB1()
                            : AppColorsLightMode.appGrey(),
                        decoration: TextDecoration.none),
                  ),
                  Container(
                    color: Colors.transparent,
                    child: Image.asset(
                      theme_dark!
                          ? Constants.ASSET_IMAGES + 'next_bttn.png'
                          : Constants.ASSET_IMAGES_LIGHT + 'next_bttn.png',
                      height: 28,
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              color: theme_dark!
                  ? AppColors.appDividerColor()
                  : AppColorsLightMode.appDividerColor(),
            )
          ],
        ),
      ),
    );
  }

  GestureDetector _date() {
    return GestureDetector(
      onTap: () async {
        final value = await Navigator.pushNamed(
            context, AppRoutes.preferred_date,
            arguments: preferredDaysData!.preferredDays != ''
                ? preferredDaysData!.preferredDays
                : widget.user_info!.preferredDays!);
        //  print('asds $value');
        if (value != null)
          setState(() {
            preferredDaysData!.preferredDays = value.toString();
          });
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              Utils.getTranslated(context, 'preferredSetting_date')!,
              style: AppFonts.robotoMedium(16,
                  color: theme_dark!
                      ? AppColors.appGrey2()
                      : AppColorsLightMode.appGrey86(),
                  decoration: TextDecoration.none),
            ),
            Container(
              margin: EdgeInsets.only(right: 6, top: 5, bottom: 5),
              padding: EdgeInsets.only(top: 15, bottom: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    preferredDaysData!.preferredDays != ''
                        ? preferredDaysData!.preferredDays!
                        : '${widget.user_info!.preferredDays!}',
                    style: AppFonts.robotoRegular(16,
                        color: theme_dark!
                            ? AppColors.appGreyB1()
                            : AppColorsLightMode.appGrey(),
                        decoration: TextDecoration.none),
                  ),
                  Container(
                    color: Colors.transparent,
                    child: Image.asset(
                      theme_dark!
                          ? Constants.ASSET_IMAGES + 'next_bttn.png'
                          : Constants.ASSET_IMAGES_LIGHT + 'next_bttn.png',
                      height: 28,
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              color: theme_dark!
                  ? AppColors.appDividerColor()
                  : AppColorsLightMode.appDividerColor(),
            )
          ],
        ),
      ),
    );
  }

  Widget _site(context) {
    String? titleSite;
    selectedId = preferredProjectVersionsData!.siteId != ''
        ? preferredProjectVersionsData!.siteId!
        : '${widget.user_info!.preferredSite}';
    selectedCompany = preferredProjectVersionsData!.companyId!;
    titleSite = selectedCompany + " | " + selectedId;
    mapSite.forEach(((element) {
      // print("#########");
      // print(element.siteId);
      // print("#########");
      // print(element.companyId);

      // if (element.companyId == (selectedCompany))
      //   setState(() {
      //     titleSite = element.companyName!;
      //   });

      // print("#########");
      // print(titleSite);

      // if (element.siteId == (selectedId))
      //   setState(() {
      //     titleSite = titleSite! + ' | ' + element.siteName!;
      //   });
      // print("#########");
      // print(titleSite);

      if (element.siteId!.contains(selectedId) &&
          element.companyId!.contains(selectedCompany)) {
        // print(element.companyName!);
        setState(() {
          titleSite = element.companyName! + ' | ' + element.siteName!;
        });
      }
    }));
    // if(titleSite ==null){
    //  setState(() {
    //     titleSite = _user.data.projectVersionsDTOs[0]. + ' | ' + element.siteName!;
    //   });
    // }
    return GestureDetector(
      onTap: () async {
        final value = await Navigator.pushNamed(
            context, AppRoutes.preferred_site,
            arguments: PDate(
                rangeName: this.selectedCompany, rangeValue: this.selectedId));
        //print('asds $value');
        if (value != null) {
          setState(() {
            PDate x = value as PDate;
            this.selectedCompany = x.rangeName!;
            this.selectedId = x.rangeValue!;

            preferredProjectVersionsData!.companyId = selectedCompany;
            preferredProjectVersionsData!.siteId = selectedId;
            preferredProjectSetting!.siteId = selectedId;

            isLoading = true;
            loadProjectbySite(context);
            siteProjectListDTO!.data!.forEach((element) {
              if (element.isPreferred!) {
                preferredProjectVersionsData!.projectVersionList!.add(
                    ProjectVersionListDataDTO(projectId: element.projectId));
              }
            });
          });
        }
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              Utils.getTranslated(context, 'preferredSetting_site')!,
              style: AppFonts.robotoMedium(16,
                  color: theme_dark!
                      ? AppColors.appGrey2()
                      : AppColorsLightMode.appGrey86(),
                  decoration: TextDecoration.none),
            ),
            Container(
              margin: EdgeInsets.only(right: 6, top: 5, bottom: 5),
              padding: EdgeInsets.only(top: 15, bottom: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    titleSite!, // != null ? titleSite! : 'Select',
                    style: AppFonts.robotoRegular(16,
                        color: theme_dark!
                            ? AppColors.appGrey2()
                            : AppColorsLightMode.appGrey(),
                        decoration: TextDecoration.none),
                  ),
                  Container(
                    color: Colors.transparent,
                    child: Image.asset(
                      theme_dark!
                          ? Constants.ASSET_IMAGES + 'next_bttn.png'
                          : Constants.ASSET_IMAGES_LIGHT + 'next_bttn.png',
                      height: 28,
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              color: theme_dark!
                  ? AppColors.appDividerColor()
                  : AppColorsLightMode.appDividerColor(),
            )
          ],
        ),
      ),
    );
  }

  Widget _project() {
    if (_user!.data!.projectVersionsDTOs![0].defaultProjectId != null) {
      if (_user!.data!.projectVersionsDTOs![0].defaultProjectId!
          .contains('<')) {
        List<String> splitedList =
            _user!.data!.projectVersionsDTOs![0].defaultProjectId!.split('<');

        projectName = splitedList[0];
        versionName = splitedList[1];
      } else {
        projectName = _user!.data!.projectVersionsDTOs![0].defaultProjectId!;
        versionName = 'Base';
      }
      setState(() {
        title = projectName! + " | " + versionName!;
      });
    } else if (preferredProjectSetting != null &&
        preferredProjectSetting!.defaultProjectId != null &&
        preferredProjectSetting!.defaultProjectId!.length > 0) {
      if (preferredProjectSetting!.defaultProjectId!.contains('<')) {
        List<String> splitedList =
            preferredProjectSetting!.defaultProjectId!.split('<');

        projectName = splitedList[0];
        versionName = splitedList[1];
      } else {
        projectName = preferredProjectSetting!.defaultProjectId!;
        versionName = 'Base';
      }
      setState(() {
        title = projectName! + " | " + versionName!;
      });
    } else {
      setState(() {
        title = "";
      });
    }

    return GestureDetector(
      onTap: () async {
        final value = await Navigator.pushNamed(
            context, AppRoutes.preferred_project,
            arguments: preferredProjectSetting);

        if (value != null) {
          preferredProjectSetting = value as UpdateLoadProject?;
          _user!.data!.projectVersionsDTOs![0].defaultProjectId =
              preferredProjectSetting!.defaultProjectId;
          preferredProjectVersionsData!.projectVersionList =
              preferredProjectSetting!.projectVersionList;

          preferredProjectVersionsData!.defaultProjectId =
              preferredProjectSetting!.defaultProjectId;
          // preferredProjectVersionsData = value;
          setState(() {
            if (preferredProjectSetting != null &&
                preferredProjectSetting!.defaultProjectId != null &&
                preferredProjectSetting!.defaultProjectId!.length > 0) {
              if (preferredProjectSetting!.defaultProjectId!.contains('<')) {
                List<String> splitedList =
                    preferredProjectSetting!.defaultProjectId!.split('<');

                projectName = splitedList[0];
                versionName = splitedList[1];
              } else {
                projectName = preferredProjectSetting!.defaultProjectId!;
                versionName = 'Base';
              }
              title = projectName! + " | " + versionName!;
            } else {
              title = '';
            }

            // title = projectName! + " | " + versionName!;
            print(title);
          });
        } else {
          setState(() {
            preferredProjectSetting!.defaultProjectId = '';
            title = '';
          });
        }
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              Utils.getTranslated(context, 'preferredSetting_proj|ver')!,
              style: AppFonts.robotoMedium(16,
                  color: theme_dark!
                      ? AppColors.appGrey2()
                      : AppColorsLightMode.appGrey86(),
                  decoration: TextDecoration.none),
            ),
            Container(
              margin: EdgeInsets.only(right: 6, top: 5, bottom: 5),
              padding: EdgeInsets.only(top: 15, bottom: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    this.title!,
                    style: AppFonts.robotoRegular(16,
                        color: theme_dark!
                            ? AppColors.appGreyB1()
                            : AppColorsLightMode.appGrey(),
                        decoration: TextDecoration.none),
                  ),
                  Container(
                    color: Colors.transparent,
                    child: Image.asset(
                      theme_dark!
                          ? Constants.ASSET_IMAGES + 'next_bttn.png'
                          : Constants.ASSET_IMAGES_LIGHT + 'next_bttn.png',
                      height: 28,
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              color: theme_dark!
                  ? AppColors.appDividerColor()
                  : AppColorsLightMode.appDividerColor(),
            )
          ],
        ),
      ),
    );
  }
}
