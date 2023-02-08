import 'dart:math';

import 'package:flutter/material.dart';
import 'package:keysight_pma/cache/appcache.dart';

import 'package:keysight_pma/const/appcolors.dart';
import 'package:keysight_pma/const/appfonts.dart';
import 'package:keysight_pma/const/constants.dart';
import 'package:keysight_pma/const/utils.dart';
import 'package:keysight_pma/dio/api/user.dart';
import 'package:keysight_pma/model/arguments/search_argument.dart';
import 'package:keysight_pma/model/updateUserPrefModel.dart';
import 'package:keysight_pma/model/user.dart';
import 'package:keysight_pma/routes/approutes.dart';

class PreferredProject extends StatefulWidget {
  UpdateLoadProject? projectList;
  PreferredProject({Key? key, this.projectList}) : super(key: key);

  @override
  State<PreferredProject> createState() => _PreferredProjectState();
}

class _PreferredProjectState extends State<PreferredProject> {
  List<String> selectedProject = [];
  ProjectVersionDTO? projectedList;
  UpdateLoadProject? returnValue = UpdateLoadProject();
  // String? _chosenValue;
  String? siteId = '';
  UserDataDTO? user_info;
  SiteLoadProjectDataDTO? _chosenValue;

  SiteLoadProjectDataDTO? defaultValue;
  bool isLoading = true;
  SiteLoadProjectDTO? siteProjectListDTO;
  List<SiteLoadProjectDataDTO> siteProjectListDataDTO = [];
  bool? theme_dark;
  Future<SiteLoadProjectDTO> getSiteProject(BuildContext ctx) {
    UserApi callProjectList = UserApi(ctx);
    return callProjectList.getSiteProject(
        AppCache.sortFilterCacheDTO!.preferredCompany!, siteId!);
  }

  @override
  void initState() {
    super.initState();
    Utils.setFirebaseAnalyticsCurrentScreen(
        Constants.ANALYTICS_ADMIN_PREFERRED_PROJ_VER_SCREEN);
    user_info = AppCache.me!.data;
    print(widget.projectList!.siteId);
    setState(() {
      returnValue!.projectVersionList = [];
      if (widget.projectList!.siteId != '' &&
          widget.projectList!.siteId != null) {
        siteId = widget.projectList!.siteId!;
        callAllData(context);
      } else {
        siteId = user_info!.preferredSite;
        callAllData(context);
      }

      projectedList = user_info!.projectVersionsDTOs![0];
    });
    setState(() {
      theme_dark = AppCache.sortFilterCacheDTO!.currentTheme;
    });
    print(siteId);
  }

  callAllData(BuildContext context) async {
    await getSiteProject(context).then((value) {
      siteProjectListDTO = value;
      if (widget.projectList != null) {
        siteProjectListDTO!.data!.forEach((element) {
          if (element.projectId == widget.projectList!.defaultProjectId) {
            element.isPreferred = true;
          }
        });
      }

      siteProjectListDataDTO = siteProjectListDTO!.data!
          .where((element) => element.isPreferred!)
          .toList();

      if (widget.projectList != null) {
        _chosenValue = siteProjectListDataDTO.firstWhere((element) =>
            element.projectId == widget.projectList!.defaultProjectId);
      } else {
        _chosenValue = siteProjectListDataDTO[0];
      }
      print(siteProjectListDataDTO.length);
      // siteProjectListDTO!.data!.forEach((element) {
      //   if (element.projectId ==
      //       user_info!.projectVersionsDTOs![0].defaultProjectId!) {

      //     // defaultValue = element;
      //     // siteProjectListDataDTO.add(element);
      //   }
      // });
      // print(AppCache.sortFilterCacheDTO!.defaultEquipments![0].equipmentId!);
      //  print(summaryUtilAndNonUtilData.data![0]);
    }).catchError((error) {
      Utils.printInfo(error);
    });

    setState(() {
      isLoading = false;
    });
  }

  dropdownCallback(SiteLoadProjectDataDTO? selectedValue) {
    if (selectedValue != null) {
      setState(() {
        print(selectedValue);
        siteProjectListDataDTO.forEach((element) {
          if (selectedValue.projectId == element.projectId) {
            _chosenValue = element;
          }
        });
      });
    }
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
          Utils.getTranslated(context, 'preferredSetting_proj|ver')!,
          style: AppFonts.robotoRegular(20,
              color: theme_dark!
                  ? AppColors.appGrey()
                  : AppColorsLightMode.appGrey(),
              decoration: TextDecoration.none),
        ),
        leading: IconButton(
            onPressed: () {
              setState(() {
                if (_chosenValue != null) {
                  returnValue!.defaultProjectId = _chosenValue!.projectId;
                  siteProjectListDTO!.data!.forEach((element) {
                    if (element.isPreferred!) {
                      returnValue!.projectVersionList!.add(
                          ProjectVersionListDataDTO(
                              projectId: element.projectId));
                    }
                  });
                  //print(returnValue!.defaultProjectId);
                  Navigator.pop(context, returnValue!);
                } else {
                  Navigator.pop(context, returnValue);
                  siteProjectListDTO!.data!.forEach((element) {
                    if (element.isPreferred!) {
                      returnValue!.projectVersionList!.add(
                          ProjectVersionListDataDTO(
                              projectId: element.projectId));
                    }
                  });
                }
              });
            },
            icon: Image.asset(
              theme_dark!
                  ? Constants.ASSET_IMAGES + 'back_bttn.png'
                  : Constants.ASSET_IMAGES_LIGHT + 'back_bttn.png',
            )),
        actions: [
          IconButton(
              onPressed: () async {
                if (siteProjectListDTO!.data != null) {
                  final result = await Navigator.pushNamed(
                      context, AppRoutes.searchRoute,
                      arguments: SearchArguments(
                          siteProjectListDataDTO: siteProjectListDTO!.data!));

                  if (result != null) {
                    print(result.toString());
                    siteProjectListDTO!.data!.forEach((element) {
                      if (element.projectId == result) {
                        setState(() {
                          element.isPreferred = true;
                          siteProjectListDataDTO.add(element);
                        });
                      }
                    });
                  }
                }
              },
              icon: Image.asset(
                theme_dark!
                    ? Constants.ASSET_IMAGES + 'search_icon.png'
                    : Constants.ASSET_IMAGES_LIGHT + 'search.png',
                height: 24,
              )),
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.appBlue()),
              ),
            )
          : SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                  margin: EdgeInsets.only(left: 16, right: 16, top: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Utils.getTranslated(context,
                                  'preferredSetting_selectdefaultproject')!,
                              style: AppFonts.robotoRegular(14,
                                  color: theme_dark!
                                      ? AppColors.appGrey2()
                                      : AppColorsLightMode.appGrey(),
                                  decoration: TextDecoration.none),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              height: 40,
                              padding: EdgeInsets.fromLTRB(16, 11, 6, 11),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: theme_dark!
                                      ? AppColors.appPrimaryGray()
                                      : AppColors.appPrimaryWhite(),
                                  border: Border.all(
                                    color: theme_dark!
                                        ? AppColors.appPrimaryWhite()
                                            .withOpacity(0.1)
                                        : AppColorsLightMode.appGreyED(),
                                  )),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<SiteLoadProjectDataDTO>(
                                  items: siteProjectListDataDTO.map<
                                          DropdownMenuItem<
                                              SiteLoadProjectDataDTO>>(
                                      (SiteLoadProjectDataDTO g) {
                                    String projectName = '';
                                    String versionName = '';
                                    if (g.projectId!.contains('<')) {
                                      List<String> splitedList =
                                          g.projectId!.split('<');
                                      setState(() {
                                        projectName = splitedList[0];
                                        versionName = splitedList[1];
                                      });
                                    } else {
                                      projectName = g.projectId!;
                                      versionName = 'Base';
                                    }
                                    return DropdownMenuItem<
                                            SiteLoadProjectDataDTO>(
                                        child: Text(
                                            projectName + " | " + versionName),
                                        value: g);
                                  }).toList(),
                                  hint: Text(
                                    'Select',
                                  ),
                                  icon: (Image.asset(
                                    theme_dark!
                                        ? Constants.ASSET_IMAGES +
                                            'dropdown_icon.png'
                                        : Constants.ASSET_IMAGES_LIGHT +
                                            'dropdown.png',
                                    height: 24,
                                  )),
                                  value: _chosenValue,

                                  onChanged: dropdownCallback,
                                  // Customizatons
                                  //iconSize: 42.0,
                                  //iconEnabledColor: Colors.green,
                                  //icon: const Icon(Icons.flutter_dash),
                                  //isExpanded: true,
                                  style: AppFonts.robotoRegular(14,
                                      color: theme_dark!
                                          ? AppColors.appGrey2()
                                          : AppColorsLightMode.appGrey(),
                                      decoration: TextDecoration.none),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 33,
                      ),
                      Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Utils.getTranslated(
                                  context, 'preferredSetting_projectList')!,
                              style: AppFonts.robotoBold(14,
                                  color: theme_dark!
                                      ? AppColors.appGrey2()
                                      : AppColorsLightMode.appGrey(),
                                  decoration: TextDecoration.none),
                            ),
                            SizedBox(
                              height: 13,
                            ),
                            Container(
                              width: 272,
                              child: Text(
                                Utils.getTranslated(context,
                                    'preferredSetting_projecttobeshown')!,
                                style: AppFonts.robotoRegular(14,
                                    color: AppColors.appGrey9A(),
                                    decoration: TextDecoration.none),
                              ),
                            ),
                            SizedBox(
                              height: 26,
                            ),
                            siteProjectListDTO != null &&
                                    siteProjectListDTO!.data!.length > 0
                                ? Wrap(
                                    children: siteProjectListDTO!.data!
                                        .map((e) => projectListName(context, e))
                                        .toList())
                                : Container(),
                          ],
                        ),
                      ),
                    ],
                  ))),
    );
  }

  // Widget projectList(BuildContext ctx, ProjectVersionDTO e) {
  //   return e.defaultProjectId != null
  //       ? Container(
  //           height: 37,
  //           width: 157,
  //           margin: EdgeInsets.only(right: 10, bottom: 20),
  //           padding: EdgeInsets.fromLTRB(0, 9.0, 0, 9.0),
  //           decoration: BoxDecoration(
  //             color: Colors.transparent,
  //             border: Border.all(color: AppColors.appTeal()),
  //             borderRadius: BorderRadius.circular(50.0),
  //           ),
  //           child: Wrap(
  //               children: e.projectVersionList!
  //                   .map((g) => projectListName(ctx, g))
  //                   .toList()),
  //         )
  //       : Container();
  // }

  Widget projectListName(BuildContext ctx, SiteLoadProjectDataDTO g) {
    String projectName = '';
    String versionName = '';
    if (g.projectId!.contains('<')) {
      List<String> splitedList = g.projectId!.split('<');
      setState(() {
        projectName = splitedList[0];
        versionName = splitedList[1];
      });
    } else {
      projectName = g.projectId!;
      versionName = 'Base';
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          g.isPreferred = !g.isPreferred!;
          if (g.isPreferred!) {
            siteProjectListDataDTO.add(g);
            // siteProjectListDataDTO = [];
            // siteProjectListDTO!.data!.forEach((element) {
            //   if (element.isPreferred!) {
            //     siteProjectListDataDTO.add(element);
            //   }
            // });
          } else {
            var index = siteProjectListDataDTO
                .indexWhere((element) => element.projectId == g.projectId);
            print(index);
            siteProjectListDataDTO.removeAt(index);
            _chosenValue = null;
          }
        });
        // if (_chosenValue != null) {
        // if (g.projectId != _chosenValue!.projectId) {
        //   setState(() {
        //     g.isPreferred = !g.isPreferred!;
        //     if (g.isPreferred!) {
        //       siteProjectListDataDTO.add(g);
        //     } else {
        //       siteProjectListDataDTO.remove(g);
        //     }
        //   });
        // }
        // } else {
        //   if (g.projectId != projectedList!.defaultProjectId) {
        //     setState(() {
        //       g.isPreferred = !g.isPreferred!;
        //       if (g.isPreferred!) {
        //         siteProjectListDataDTO.add(g);
        //       } else {
        //         siteProjectListDataDTO.remove(g);
        //       }
        //     });
        //   }
        // }
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(12.0, 9.0, 12.0, 9.0),
        margin: EdgeInsets.fromLTRB(.0, 9.0, 12.0, 9.0),
        decoration: BoxDecoration(
          color: g.isPreferred! ? AppColors.appTeal() : Colors.transparent,
          border: g.isPreferred!
              ? Border.all(color: Colors.transparent)
              : Border.all(color: AppColors.appTeal()),
          borderRadius: BorderRadius.circular(50.0),
        ),
        child: Text(
          (projectName + ' | ' + versionName),
          style: AppFonts.robotoMedium(
            14,
            color: g.isPreferred!
                ? AppColors.appPrimaryWhite()
                : AppColors.appTeal(),
            decoration: TextDecoration.none,
          ),
        ),
      ),
    );
  }
}

//Seleted List Widget
/*
                        
                        Container(
                          height: 37,
                          width: 183,
                          padding: EdgeInsets.fromLTRB(12.0, 9.0, 12.0, 9.0),
                          decoration: BoxDecoration(
                            color: AppColors.appTeal(),
                            border: Border.all(color: AppColors.appTeal()),
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                'PROJ003',
                                style: AppFonts.robotoMedium(
                                  14,
                                  color: AppColors.appPrimaryWhite(),
                                  decoration: TextDecoration.none,
                                ),
                              ),
                              Text(
                                '|',
                                style: AppFonts.robotoMedium(
                                  14,
                                  color: AppColors.appPrimaryWhite(),
                                  decoration: TextDecoration.none,
                                ),
                              ),
                              Text(
                                'VER001',
                                style: AppFonts.robotoMedium(
                                  14,
                                  color: AppColors.appPrimaryWhite(),
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
                          height: 37,
                          width: 183,
                          padding: EdgeInsets.fromLTRB(12.0, 9.0, 12.0, 9.0),
                          decoration: BoxDecoration(
                            color: AppColors.appTeal(),
                            border: Border.all(color: AppColors.appTeal()),
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                'PROJ003',
                                style: AppFonts.robotoMedium(
                                  14,
                                  color: AppColors.appPrimaryWhite(),
                                  decoration: TextDecoration.none,
                                ),
                              ),
                              Text(
                                '|',
                                style: AppFonts.robotoMedium(
                                  14,
                                  color: AppColors.appPrimaryWhite(),
                                  decoration: TextDecoration.none,
                                ),
                              ),
                              Text(
                                'VER001',
                                style: AppFonts.robotoMedium(
                                  14,
                                  color: AppColors.appPrimaryWhite(),
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
                          height: 37,
                          width: 183,
                          padding: EdgeInsets.fromLTRB(12.0, 9.0, 12.0, 9.0),
                          decoration: BoxDecoration(
                            color: AppColors.appTeal(),
                            border: Border.all(color: AppColors.appTeal()),
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                'PROJ003',
                                style: AppFonts.robotoMedium(
                                  14,
                                  color: AppColors.appPrimaryWhite(),
                                  decoration: TextDecoration.none,
                                ),
                              ),
                              Text(
                                '|',
                                style: AppFonts.robotoMedium(
                                  14,
                                  color: AppColors.appPrimaryWhite(),
                                  decoration: TextDecoration.none,
                                ),
                              ),
                              Text(
                                'VER001',
                                style: AppFonts.robotoMedium(
                                  14,
                                  color: AppColors.appPrimaryWhite(),
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ],
                          ),
                        ),
            */

//Project List Widget
/*                     Container(
                              height: 37,
                              width: 157,
                              margin: EdgeInsets.only(right: 10, bottom: 20),
                              padding: EdgeInsets.fromLTRB(0, 9.0, 0, 9.0),
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                border: Border.all(color: AppColors.appTeal()),
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    'PROJ003',
                                    style: AppFonts.robotoMedium(
                                      14,
                                      color: AppColors.appTeal(),
                                      decoration: TextDecoration.none,
                                    ),
                                  ),
                                  Text(
                                    '|',
                                    style: AppFonts.robotoMedium(
                                      14,
                                      color: AppColors.appTeal(),
                                      decoration: TextDecoration.none,
                                    ),
                                  ),
                                  Text(
                                    'VER001',
                                    style: AppFonts.robotoMedium(
                                      14,
                                      color: AppColors.appTeal(),
                                      decoration: TextDecoration.none,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 37,
                              width: 157,
                              margin: EdgeInsets.only(right: 10, bottom: 20),
                              padding: EdgeInsets.fromLTRB(0, 9.0, 0, 9.0),
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                border: Border.all(color: AppColors.appTeal()),
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    'PROJ003',
                                    style: AppFonts.robotoMedium(
                                      14,
                                      color: AppColors.appTeal(),
                                      decoration: TextDecoration.none,
                                    ),
                                  ),
                                  Text(
                                    '|',
                                    style: AppFonts.robotoMedium(
                                      14,
                                      color: AppColors.appTeal(),
                                      decoration: TextDecoration.none,
                                    ),
                                  ),
                                  Text(
                                    'VER001',
                                    style: AppFonts.robotoMedium(
                                      14,
                                      color: AppColors.appTeal(),
                                      decoration: TextDecoration.none,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 37,
                              width: 157,
                              margin: EdgeInsets.only(right: 10, bottom: 20),
                              padding: EdgeInsets.fromLTRB(0, 9.0, 0, 9.0),
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                border: Border.all(color: AppColors.appTeal()),
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    'PROJ003',
                                    style: AppFonts.robotoMedium(
                                      14,
                                      color: AppColors.appTeal(),
                                      decoration: TextDecoration.none,
                                    ),
                                  ),
                                  Text(
                                    '|',
                                    style: AppFonts.robotoMedium(
                                      14,
                                      color: AppColors.appTeal(),
                                      decoration: TextDecoration.none,
                                    ),
                                  ),
                                  Text(
                                    'VER001',
                                    style: AppFonts.robotoMedium(
                                      14,
                                      color: AppColors.appTeal(),
                                      decoration: TextDecoration.none,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 37,
                              width: 157,
                              margin: EdgeInsets.only(right: 10, bottom: 20),
                              padding: EdgeInsets.fromLTRB(0, 9.0, 0, 9.0),
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                border: Border.all(color: AppColors.appTeal()),
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    'PROJ003',
                                    style: AppFonts.robotoMedium(
                                      14,
                                      color: AppColors.appTeal(),
                                      decoration: TextDecoration.none,
                                    ),
                                  ),
                                  Text(
                                    '|',
                                    style: AppFonts.robotoMedium(
                                      14,
                                      color: AppColors.appTeal(),
                                      decoration: TextDecoration.none,
                                    ),
                                  ),
                                  Text(
                                    'VER001',
                                    style: AppFonts.robotoMedium(
                                      14,
                                      color: AppColors.appTeal(),
                                      decoration: TextDecoration.none,
                                    ),
                                  ),
                                ],
                              ),
                            ),
         */