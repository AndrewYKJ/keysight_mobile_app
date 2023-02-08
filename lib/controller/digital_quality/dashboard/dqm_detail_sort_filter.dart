import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:keysight_pma/cache/appcache.dart';
import 'package:keysight_pma/const/appcolors.dart';
import 'package:keysight_pma/const/appfonts.dart';
import 'package:keysight_pma/const/constants.dart';
import 'package:keysight_pma/const/utils.dart';
import 'package:keysight_pma/model/arguments/dqm_argument.dart';
import 'package:keysight_pma/model/customize.dart';
import 'package:keysight_pma/routes/approutes.dart';

class DqmDetailSortAndFilterScreen extends StatefulWidget {
  final List<CustomDqmSortFilterProjectsDTO>? projectIdList;
  DqmDetailSortAndFilterScreen({Key? key, this.projectIdList})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DqmDetailSortAndFilterScreen();
  }
}

class _DqmDetailSortAndFilterScreen
    extends State<DqmDetailSortAndFilterScreen> {
  String selectedProject = '';
  List<CustomDqmSortFilterProjectsDTO> projectIdList = [];
  bool? theme_dark = AppCache.sortFilterCacheDTO!.currentTheme;
  @override
  void initState() {
    super.initState();
    if (widget.projectIdList != null && widget.projectIdList!.length > 0) {
      widget.projectIdList!.forEach((element) {
        this.projectIdList.add(element);
      });
    }
    displaySelectedProjects();
  }

  void displaySelectedProjects() {
    if (this.projectIdList.length > 0) {
      this.selectedProject = '';
      // this.projectIdList.forEach((data) {
      //   if (data.isSelected!) {
      //     if (Utils.isNotEmpty(this.selectedProject)) {
      //       this.selectedProject =
      //           this.selectedProject + ', ' + data.projectId!;
      //     } else {
      //       this.selectedProject = data.projectId!;
      //     }
      //   }
      // });

      this.selectedProject = this
          .projectIdList
          .where((element) => element.isSelected!)
          .toList()
          .map((e) => e.projectId)
          .join("\n\n");
    }

    setState(() {});
  }

  void displayAllProjects() {
    if (this.projectIdList.length > 0) {
      // this.selectedProject = '';
      // this.projectIdList.forEach((data) {
      //   data.isSelected = true;
      //   if (Utils.isNotEmpty(this.selectedProject)) {
      //     this.selectedProject = this.selectedProject + ', ' + data.projectId!;
      //   } else {
      //     this.selectedProject = data.projectId!;
      //   }
      // });

      this.selectedProject =
          this.projectIdList.toList().map((e) => e.projectId).join("\n\n");
    }

    setState(() {});
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
            Utils.getTranslated(context, 'sort_and_filter_appbar_text')!,
            style: AppFonts.robotoRegular(
              20,
              color: theme_dark!
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
            child: Image.asset(
              theme_dark!
                  ? Constants.ASSET_IMAGES + 'close_bttn.png'
                  : Constants.ASSET_IMAGES_LIGHT + 'close_icon.png',
            ),
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
                      project(context),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 14.0),
                color: theme_dark!
                    ? AppColors.appPrimaryBlack()
                    : AppColorsLightMode.appPrimaryBlack(),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(left: 90, right: 90),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context, this.projectIdList);
                    },
                    child: Container(
                      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                      decoration: BoxDecoration(
                          color: this.selectedProject.length > 0
                              ? AppColors.appPrimaryYellow()
                              : AppColors.appSaveButton(),
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
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.start,
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     Expanded(
                //       child: GestureDetector(
                //         onTap: () {
                //           displayAllProjects();
                //         },
                //         child: Container(
                //           padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                //           decoration: BoxDecoration(
                //               color: Colors.transparent,
                //               border: Border.all(
                //                 color: theme_dark!
                //                     ? AppColors.appGreyD3()
                //                     : AppColorsLightMode.appPrimaryYellow(),
                //               ),
                //               borderRadius: BorderRadius.circular(2.0)),
                //           child: Text(
                //             Utils.getTranslated(
                //                 context, 'sort_and_filter_clear_btn')!,
                //             style: AppFonts.robotoMedium(
                //               15,
                //               color: theme_dark!
                //                   ? AppColors.appPrimaryWhite()
                //                   : AppColorsLightMode.appPrimaryYellow(),
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
                //           Navigator.pop(context, this.projectIdList);
                //         },
                //         child: Container(
                //           padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                //           decoration: BoxDecoration(
                //               color: this.selectedProject.length > 0
                //                   ? AppColors.appPrimaryYellow()
                //                   : AppColors.appSaveButton(),
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

  Widget project(BuildContext ctx) {
    return GestureDetector(
      onTap: () async {
        final navigateResult = await Navigator.pushNamed(
          ctx,
          AppRoutes.dqmDashboardDetailSortFilterProjectsRoute,
          arguments: DqmSortFilterArguments(
            projectIdList: widget.projectIdList,
          ),
        );

        if (navigateResult != null) {
          List<CustomDqmSortFilterProjectsDTO> resultList =
              navigateResult as List<CustomDqmSortFilterProjectsDTO>;
          if (resultList.length > 0) {
            this.projectIdList.clear();
            resultList.forEach((element) {
              this.projectIdList.add(element);
            });
            displaySelectedProjects();
          }
        }
      },
      child: Container(
        width: MediaQuery.of(ctx).size.width,
        margin: EdgeInsets.only(top: 22.0),
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
                    Utils.getTranslated(ctx, 'sort_and_filter_project')!,
                    style: AppFonts.robotoRegular(
                      16,
                      color: theme_dark!
                          ? AppColors.appGrey2()
                          : AppColorsLightMode.appGrey(),
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: 12.0),
                  child: Image.asset(
                    theme_dark!
                        ? Constants.ASSET_IMAGES + 'next_bttn.png'
                        : Constants.ASSET_IMAGES_LIGHT + 'next_bttn.png',
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.0),
            Text(
              this.selectedProject,
              style: AppFonts.robotoRegular(
                16,
                color: theme_dark!
                    ? AppColors.appGrey2()
                    : AppColorsLightMode.appGrey(),
                decoration: TextDecoration.none,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
