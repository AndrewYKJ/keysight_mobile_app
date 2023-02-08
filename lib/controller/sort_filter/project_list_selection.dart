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
import 'package:keysight_pma/model/sortAndFilter/projects.dart';
import 'package:keysight_pma/routes/approutes.dart';

class SortAndFilterProjectListScreen extends StatefulWidget {
  SortAndFilterProjectListScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SortAndFilterProjectListScreen();
  }
}

class _SortAndFilterProjectListScreen
    extends State<SortAndFilterProjectListScreen> {
  List<ProjectDataDTO> projectList = [];
  List<ProjectDataDTO> preferedList = [];
  List<ProjectDataDTO> nonPreferedList = [];
  String projectName = '';
  bool isLoading = true;
  bool? isDarkTheme = AppCache.sortFilterCacheDTO!.currentTheme;

  Future<ProjectsDTO> loadProjectList(
      BuildContext ctx, String companyId, String siteId) {
    SortFilterApi sortFilterApi = SortFilterApi(ctx);
    return sortFilterApi.loadProjectList(companyId, siteId);
  }

  @override
  void initState() {
    super.initState();
    Utils.setFirebaseAnalyticsCurrentScreen(
        Constants.ANALYTICS_PROJECT_LIST_SELECTION_SCREEN);
    callLoadProjectList(context);
  }

  callLoadProjectList(BuildContext context) async {
    await loadProjectList(
            context,
            AppCache.sortFilterCacheDTO!.preferredCompany!,
            AppCache.sortFilterCacheDTO!.preferredSite!)
        .then((value) {
      if (value.data != null && value.data!.length > 0) {
        value.data!.forEach((element) {
          if (AppCache.sortFilterCacheDTO!.defaultProjectId ==
              element.projectId) {
            element.isSelected = true;
          } else {
            element.isSelected = false;
          }
          if (element.isPreferred!) {
            this.preferedList.add(element);
          } else {
            this.nonPreferedList.add(element);
          }
        });
        Utils.printInfo("########### Prefered: ${this.preferedList.length}");
        Utils.printInfo("########### Prefered: ${this.nonPreferedList.length}");
        this.preferedList.sort((a, b) {
          return a.projectId!
              .toLowerCase()
              .compareTo(b.projectId!.toLowerCase());
        });
        this.nonPreferedList.sort((a, b) {
          return a.projectId!
              .toLowerCase()
              .compareTo(b.projectId!.toLowerCase());
        });
        this.projectList.addAll(this.preferedList);
        this.projectList.addAll(this.nonPreferedList);
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
        backgroundColor: isDarkTheme!
            ? AppColors.serverAppBar()
            : AppColorsLightMode.serverAppBar(),
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Padding(
          padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
          child: Text(
            Utils.getTranslated(context, 'sort_and_filter_project')!,
            style: AppFonts.robotoRegular(
              20,
              color: isDarkTheme!
                  ? AppColors.appGrey()
                  : AppColorsLightMode.appGrey(),
              decoration: TextDecoration.none,
            ),
          ),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context, true);
          },
          child: Image.asset(
            isDarkTheme!
                ? Constants.ASSET_IMAGES + 'back_bttn.png'
                : Constants.ASSET_IMAGES_LIGHT + 'back_bttn.png',
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () async {
              if (this.projectList.length > 0) {
                final navResult = await Navigator.pushNamed(
                  context,
                  AppRoutes.searchRoute,
                  arguments: SearchArguments(projectList: this.projectList),
                );

                if (navResult != null) {
                  projectList.forEach((data) {
                    data.isSelected = false;
                  });
                  String retProjectId = navResult as String;
                  ProjectDataDTO tmpDTO = this.projectList.firstWhere(
                      (element) => element.projectId == retProjectId);

                  setState(() {
                    tmpDTO.isSelected = true;
                    AppCache.sortFilterCacheDTO!.defaultProjectId =
                        tmpDTO.projectId;
                    if (Utils.isNotEmpty(tmpDTO.projectName)) {
                      AppCache.sortFilterCacheDTO!.displayProjectName =
                          '${tmpDTO.projectName} (${tmpDTO.projectId})';
                    } else {
                      AppCache.sortFilterCacheDTO!.displayProjectName =
                          tmpDTO.projectId;
                    }
                  });
                }
              }
            },
            child: Image.asset(isDarkTheme!
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
              : ListView.builder(
                  itemCount: projectList.length,
                  itemBuilder: (BuildContext listContext, index) {
                    return projectItem(listContext, projectList[index], index);
                  },
                ),
        ),
      ),
    );
  }

  Widget projectItem(
      BuildContext ctx, ProjectDataDTO projectDataDTO, int index) {
    int projectListLens = preferedList.length;

    // Utils.printInfo(
    //     '##### ${projectDataDTO.projectId} | ${projectDataDTO.projectName} | ${projectDataDTO.isSelected} | ${Utils.isNotEmpty(projectDataDTO.projectName)}');

    return GestureDetector(
      onTap: () {
        projectList.forEach((data) {
          data.isSelected = false;
        });
        setState(() {
          projectDataDTO.isSelected = true;
          AppCache.sortFilterCacheDTO!.defaultProjectId =
              projectDataDTO.projectId;
          if (Utils.isNotEmpty(projectDataDTO.projectName)) {
            AppCache.sortFilterCacheDTO!.displayProjectName =
                '${projectDataDTO.projectName} (${projectDataDTO.projectId})';
          } else {
            AppCache.sortFilterCacheDTO!.displayProjectName =
                projectDataDTO.projectId;
          }
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 23.0, bottom: 23.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    Utils.isNotEmpty(projectDataDTO.projectName)
                        ? '${projectDataDTO.projectName} (${projectDataDTO.projectId})'
                        : projectDataDTO.projectId!,
                    style: AppFonts.robotoRegular(
                      16,
                      color: projectListLens > index
                          ? isDarkTheme!
                              ? HexColor("87C2C7")
                              : AppColorsLightMode.appTeal()
                          : isDarkTheme!
                              ? AppColors.appGrey2()
                              : AppColorsLightMode.appGrey(),
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
                SizedBox(width: 12.0),
                Container(
                  margin: EdgeInsets.only(right: 12.0),
                  child: projectDataDTO.isSelected!
                      ? Image.asset(isDarkTheme!
                          ? Constants.ASSET_IMAGES + 'tick_icon.png'
                          : Constants.ASSET_IMAGES_LIGHT + 'tick_icon.png')
                      : Container(),
                ),
              ],
            ),
          ),
          index < (projectList.length - 1) ? divider(ctx) : Container(),
        ],
      ),
    );
  }

  Widget divider(BuildContext ctx) {
    return Container(
      width: MediaQuery.of(ctx).size.width,
      height: 1.0,
      color: isDarkTheme!
          ? AppColors.appDividerColor()
          : AppColorsLightMode.appDividerColor(),
    );
  }
}
