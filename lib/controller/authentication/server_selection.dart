import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:keysight_pma/cache/appcache.dart';
import 'package:keysight_pma/const/appcolors.dart';
import 'package:keysight_pma/const/appfonts.dart';
import 'package:keysight_pma/const/themedata.dart';
import 'package:keysight_pma/const/utils.dart';
import 'package:keysight_pma/model/custom_server/server.dart';
import 'package:provider/provider.dart';

import '../../const/constants.dart';

class ServerSelection extends StatefulWidget {
  const ServerSelection({Key? key}) : super(key: key);

  @override
  State<ServerSelection> createState() => _ServerSelectionState();
}

class _ServerSelectionState extends State<ServerSelection> {
  List<CustomServerDTO> serverList = [];
  bool isDarkTheme = true;

  @override
  void initState() {
    super.initState();
    Utils.setFirebaseAnalyticsCurrentScreen(
        Constants.ANALYTICS_CUSTOM_SERVER_SELECTION_SCREEN);
    AppCache.getStringValue(AppCache.CUSTOM_SERVER_PREF).then((value) {
      if (value.length > 0) {
        List<dynamic> cacheServerList = jsonDecode(value);
        if (cacheServerList.length > 0) {
          setState(() {
            this.serverList = cacheServerList
                .map((e) => CustomServerDTO.fromJson(e))
                .toList();
          });
        }
      }
    });

    AppCache.getbooleanValue(AppCache.APP_THEME_PREF).then((value) {
      setState(() {
        if (value) {
          isDarkTheme = value;
        } else {
          isDarkTheme = true;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDarkTheme
            ? AppColors.serverAppBar()
            : AppColorsLightMode.serverAppBar(),
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          Utils.getTranslated(context, 'server_selection')!,
          style: AppFonts.robotoRegular(
            20,
            color: isDarkTheme
                ? AppColors.appGrey()
                : AppColorsLightMode.appGrey(),
            decoration: TextDecoration.none,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Image.asset(
              isDarkTheme
                  ? Constants.ASSET_IMAGES + 'close_bttn.png'
                  : Constants.ASSET_IMAGES_LIGHT + 'close_icon.png',
            ),
          ),
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: ListView.separated(
          itemCount: this.serverList.length,
          itemBuilder: (BuildContext itemContext, int index) {
            return GestureDetector(
              onTap: () {
                this.serverList.forEach((element) {
                  element.isSelected = false;
                });
                this.serverList[index].isSelected = true;
                AppCache.setString(
                    AppCache.CUSTOM_SERVER_PREF, jsonEncode(this.serverList));
                Navigator.pop(context, this.serverList[index]);
              },
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        serverList[index].serverName!,
                        style: AppFonts.robotoRegular(
                          19,
                          color: isDarkTheme
                              ? AppColors.appGrey()
                              : AppColorsLightMode.appGrey(),
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                    serverList[index].isSelected!
                        ? Image.asset(
                            isDarkTheme
                                ? Constants.ASSET_IMAGES + 'tick_icon.png'
                                : Constants.ASSET_IMAGES_LIGHT +
                                    'tick_icon.png',
                          )
                        : Container(),
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) => Divider(
            color: isDarkTheme
                ? AppColors.appDividerColor()
                : AppColorsLightMode.appDividerColor(),
          ),
        ),
      ),
    );
    // return Consumer<ThemeClass>(builder: (context, value, child) {
    //   // isDarkTheme = value.getValue();
    //   // AppCache.sortFilterCacheDTO!.currentTheme = isDarkTheme;

    // });
  }
}
