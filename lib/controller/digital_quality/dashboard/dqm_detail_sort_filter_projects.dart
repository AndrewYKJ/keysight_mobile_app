import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:keysight_pma/const/appcolors.dart';
import 'package:keysight_pma/const/appfonts.dart';
import 'package:keysight_pma/const/constants.dart';
import 'package:keysight_pma/const/utils.dart';
import 'package:keysight_pma/model/arguments/search_argument.dart';
import 'package:keysight_pma/model/customize.dart';
import 'package:keysight_pma/routes/approutes.dart';

import '../../../cache/appcache.dart';

class DqmDetailSortAndFilterProjectsScreen extends StatefulWidget {
  final List<CustomDqmSortFilterProjectsDTO>? projectIdList;
  DqmDetailSortAndFilterProjectsScreen({Key? key, this.projectIdList})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DqmDetailSortAndFilterProjectsScreen();
  }
}

class _DqmDetailSortAndFilterProjectsScreen
    extends State<DqmDetailSortAndFilterProjectsScreen> {
  bool? theme_dark = AppCache.sortFilterCacheDTO!.currentTheme;
  bool isSelectAll = true;

  @override
  void initState() {
    super.initState();
    if (widget.projectIdList != null && widget.projectIdList!.length > 0) {
      setState(() {
        this.isSelectAll =
            Utils.isSelectAll(otherItemList: widget.projectIdList);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: theme_dark!
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
                color: theme_dark!
                    ? AppColors.appGrey()
                    : AppColorsLightMode.appGrey(),
                decoration: TextDecoration.none,
              ),
            ),
          ),
          leading: GestureDetector(
            onTap: () {
              int unselectCount = 0;
              widget.projectIdList!.forEach((element) {
                if (!element.isSelected!) {
                  unselectCount++;
                }
              });
              if (unselectCount == widget.projectIdList!.length) {
                Utils.showAlertDialog(
                    context,
                    Utils.getTranslated(context, 'alert_dialog_info_title')!,
                    Utils.getTranslated(
                        context, 'alert_dialog_no_project_select_message')!);
              } else {
                Navigator.pop(context, widget.projectIdList);
              }
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
                if (widget.projectIdList != null &&
                    widget.projectIdList!.length > 0) {
                  final navResult = await Navigator.pushNamed(
                    context,
                    AppRoutes.searchRoute,
                    arguments: SearchArguments(
                        customSFProjectList: widget.projectIdList),
                  );

                  if (navResult != null) {
                    String tmpId = navResult as String;
                    setState(() {
                      CustomDqmSortFilterProjectsDTO tmpDTO = widget
                          .projectIdList!
                          .firstWhere((element) => element.projectId == tmpId);
                      tmpDTO.isSelected = !tmpDTO.isSelected!;
                      this.isSelectAll = Utils.isSelectAll(
                          otherItemList: widget.projectIdList);
                    });
                  }
                }
              },
              child: Image.asset(
                theme_dark!
                    ? Constants.ASSET_IMAGES + 'search_icon.png'
                    : Constants.ASSET_IMAGES_LIGHT + 'search.png',
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
                  child: ListView.builder(
                    itemCount: widget.projectIdList!.length,
                    itemBuilder: (BuildContext listContext, index) {
                      return projectItem(
                          listContext, widget.projectIdList![index], index);
                    },
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      this.isSelectAll = !this.isSelectAll;
                      if (this.isSelectAll) {
                        widget.projectIdList!.forEach((element) {
                          element.isSelected = true;
                        });
                      } else {
                        widget.projectIdList!.forEach((element) {
                          element.isSelected = false;
                        });
                      }
                    });
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(left: 90.0, right: 90.0, top: 16.0),
                    padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                    decoration: BoxDecoration(
                        color: AppColors.appPrimaryYellow(),
                        border: Border.all(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(2.0)),
                    child: Text(
                      this.isSelectAll
                          ? Utils.getTranslated(context, 'deselect_all')!
                          : Utils.getTranslated(context, 'select_all')!,
                      style: AppFonts.robotoMedium(
                        15,
                        color: AppColors.appPrimaryWhite(),
                        decoration: TextDecoration.none,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      onWillPop: () async {
        return false;
      },
    );
  }

  Widget projectItem(
      BuildContext ctx, CustomDqmSortFilterProjectsDTO customDTO, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          customDTO.isSelected = !customDTO.isSelected!;
          this.isSelectAll =
              Utils.isSelectAll(otherItemList: widget.projectIdList);
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
                    customDTO.projectId!,
                    style: AppFonts.robotoRegular(
                      16,
                      color: theme_dark!
                          ? AppColors.appGrey2()
                          : AppColorsLightMode.appGrey(),
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
                SizedBox(width: 12.0),
                Container(
                  margin: EdgeInsets.only(right: 12.0),
                  child: customDTO.isSelected!
                      ? Image.asset(
                          theme_dark!
                              ? Constants.ASSET_IMAGES + 'tick_icon.png'
                              : Constants.ASSET_IMAGES_LIGHT + 'tick_icon.png',
                        )
                      : Container(),
                ),
              ],
            ),
          ),
          index < (widget.projectIdList!.length - 1)
              ? divider(ctx)
              : Container(),
        ],
      ),
    );
  }

  Widget divider(BuildContext ctx) {
    return Container(
      width: MediaQuery.of(ctx).size.width,
      height: 1.0,
      color: theme_dark!
          ? AppColors.appDividerColor()
          : AppColorsLightMode.appDividerColor(),
    );
  }
}
