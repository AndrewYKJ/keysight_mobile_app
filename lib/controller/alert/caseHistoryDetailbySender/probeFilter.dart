import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:keysight_pma/cache/appcache.dart';
import 'package:keysight_pma/const/appcolors.dart';
import 'package:keysight_pma/const/appfonts.dart';
import 'package:keysight_pma/const/constants.dart';
import 'package:keysight_pma/const/utils.dart';
import 'package:keysight_pma/dio/api/alert.dart';
import 'package:keysight_pma/model/alert/alert_probe.dart';

class ProbeNodeDetailScreen extends StatefulWidget {
  final AlertFixtureMapDTO? nodeData;

  final String? companyId;
  final String? siteId;
  final String? projectId;
  ProbeNodeDetailScreen(
      {Key? key, this.nodeData, this.companyId, this.siteId, this.projectId})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ProbeNodeDetailScreen();
  }
}

const Color primaryColor = Color(0xFF1e2f36); //corner
const Color accentColor = Color(0xFF0d2026); //background
const TextStyle textStyle = TextStyle(color: Colors.white);
const TextStyle textStyleSubItems = TextStyle(color: Colors.grey);

class _ProbeNodeDetailScreen extends State<ProbeNodeDetailScreen> {
  bool isLoading = true;
  bool probleExpanded = true;
  bool textNameExpanded = true;
  bool nodeExpanded = true;
  bool nodePinsExpanded = true;
  bool nodeProbeExpanded = true;
  bool nodePersonalityPin = true;
  bool nodeTransferPin = true;
  AlertFixtureMapDTO? probeData;
  AlertProbeNodeDTO? nodeDetailDTO;
  AlertProbeNodeDataDTO nodeDetailDataDTO = AlertProbeNodeDataDTO();
  String title = '';
  int totalNodeCalculation = 0;
  String totalNode = '';
  bool? theme_dark = AppCache.sortFilterCacheDTO!.currentTheme;

  @override
  void initState() {
    super.initState();
    Utils.setFirebaseAnalyticsCurrentScreen(
        Constants.ANALYTICS_ALERT_PROBE_FINDER_FILTER_SCREEN);
    setState(() {
      probeData = widget.nodeData!;
    });
    callAllData(context);
  }

  Future<AlertProbeNodeDTO> getNodeDetail(
    BuildContext ctx,
  ) {
    AlertApi alertApi = AlertApi(ctx);
    String companyId = widget.companyId!;
    String nodeId = widget.nodeData!.node!;
    String siteId = widget.siteId!;
    String projectId = widget.projectId!;
    return alertApi.getNodeDetail(companyId, siteId, projectId, nodeId);
  }

  callAllData(BuildContext context) async {
    await getNodeDetail(context).then((value) {
      if (value.status!.statusCode == 200) {
        nodeDetailDTO = value;
        if (nodeDetailDTO!.data != null) {
          nodeDetailDataDTO = nodeDetailDTO!.data!;

          if (nodeDetailDataDTO.pin != null)
            totalNodeCalculation =
                totalNodeCalculation + nodeDetailDataDTO.pin!.length;
          print(totalNodeCalculation);
          if (nodeDetailDataDTO.personalityPin!.length > 0 &&
              nodeDetailDataDTO.personalityPin != null)
            totalNodeCalculation =
                totalNodeCalculation + nodeDetailDataDTO.personalityPin!.length;
          print(totalNodeCalculation);

          if (nodeDetailDataDTO.probeId != null)
            totalNodeCalculation =
                totalNodeCalculation + nodeDetailDataDTO.probeId!.length;
          print(totalNodeCalculation);

          if (nodeDetailDataDTO.node != null)
            totalNodeCalculation = totalNodeCalculation + 1;
          print(totalNodeCalculation);

          if (nodeDetailDataDTO.transferPin != null)
            totalNodeCalculation =
                totalNodeCalculation + nodeDetailDataDTO.transferPin!.length;
          print(totalNodeCalculation);
          setState(() {
            totalNode = totalNodeCalculation.toString();
            title = '${Utils.getTranslated(context, 'PROBE_INFORMATION')!} (' +
                widget.nodeData!.node! +
                ')';
          });
        }
      } else {
        Utils.showAlertDialog(
            context,
            Utils.getTranslated(context, 'general_alert_error_title')!,
            value.status!.statusMessage!);
      }
    }).catchError((error) {
      Utils.printInfo(error);
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
    }).whenComplete(() {});

    setState(() {
      this.isLoading = false;
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
            title,
            // Utils.getTranslated(context, 'sort_and_filter_appbar_text')!,
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
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(AppColors.appBlue()),
                ),
              )
            : Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                padding: EdgeInsets.only(left: 8.0, right: 16.0, bottom: 21.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width / 2,
                              padding: EdgeInsets.only(
                                  left: 8.0, top: 12, bottom: 12.0),
                              child: Text(
                                Utils.getTranslated(
                                    context, 'probe_finder_detail')!,
                                style: AppFonts.robotoRegular(16,
                                    color: theme_dark!
                                        ? AppColors.appPrimaryWhite()
                                        : AppColorsLightMode.appPrimaryWhite(),
                                    decoration: TextDecoration.none),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                  left: 8.0, top: 12, bottom: 12.0),
                              child: Text(
                                Utils.getTranslated(
                                    context, 'probe_finder_value')!,
                                style: AppFonts.robotoRegular(16,
                                    color: theme_dark!
                                        ? AppColors.appPrimaryWhite()
                                        : AppColorsLightMode.appPrimaryWhite(),
                                    decoration: TextDecoration.none),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                            // height: 10,
                            ),
                        divider(context),
                        SizedBox(
                          height: 10,
                        ),
                        //Probe COntainer
                        Container(
                          child: Column(
                            children: [
                              //ProdeHeader
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    probleExpanded = !probleExpanded;
                                  });
                                },
                                child: Row(
                                  children: [
                                    Container(
                                      width: 40,
                                      padding: EdgeInsets.only(bottom: 10.0),
                                      child: probleExpanded
                                          ? Image.asset(
                                              theme_dark!
                                                  ? Constants.ASSET_IMAGES +
                                                      'dropdown_icon.png'
                                                  : Constants
                                                          .ASSET_IMAGES_LIGHT +
                                                      'dropdown.png',
                                              width: 6,
                                              height: 10,
                                            )
                                          : Image.asset(
                                              theme_dark!
                                                  ? Constants.ASSET_IMAGES +
                                                      'next_bttn.png'
                                                  : Constants
                                                          .ASSET_IMAGES_LIGHT +
                                                      'next_bttn.png',
                                              width: 6,
                                              height: 10,
                                            ),
                                    ),
                                    Container(
                                      //width: MediaQuery.of(context).size.width / 2 - 40,
                                      padding: EdgeInsets.only(
                                          left: 8.0, top: 0, bottom: 12.0),
                                      child: Text(
                                        Utils.getTranslated(
                                            context, 'probe_finder_probe')!,
                                        style: AppFonts.robotoRegular(16,
                                            color: theme_dark!
                                                ? AppColors.appPrimaryWhite()
                                                : AppColorsLightMode
                                                    .appPrimaryWhite(),
                                            decoration: TextDecoration.none),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(
                                          left: 8.0, top: 0, bottom: 12.0),
                                      child: Text(
                                        '(' +
                                            (probeData!.testNames!.length + 2)
                                                .toString() +
                                            ')',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              divider(context),
                              SizedBox(
                                height: 10,
                              ),
                              //Prode Detail
                              probleExpanded
                                  ? Column(
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      2 -
                                                  45,
                                              padding: EdgeInsets.only(
                                                  left: 8.0,
                                                  top: 0,
                                                  bottom: 0.0),
                                              margin: EdgeInsets.only(
                                                left: 45,
                                              ),
                                              child: Text(
                                                Utils.getTranslated(
                                                    context, 'probe_finder_x')!,
                                                style: AppFonts.robotoRegular(
                                                    16,
                                                    color: theme_dark!
                                                        ? AppColors
                                                            .appPrimaryWhite()
                                                        : AppColorsLightMode
                                                            .appPrimaryWhite(),
                                                    decoration:
                                                        TextDecoration.none),
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.only(
                                                  left: 0.0,
                                                  top: 8,
                                                  bottom: 10.0),
                                              child:
                                                  Text(probeData!.x.toString()),
                                            ),
                                          ],
                                        ),
                                        divider(context),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      2 -
                                                  45,
                                              padding: EdgeInsets.only(
                                                  left: 8.0,
                                                  top: 0,
                                                  bottom: 0.0),
                                              margin: EdgeInsets.only(
                                                left: 45,
                                              ),
                                              child: Text(
                                                Utils.getTranslated(
                                                    context, 'probe_finder_y')!,
                                                style: AppFonts.robotoRegular(
                                                    16,
                                                    color: theme_dark!
                                                        ? AppColors
                                                            .appPrimaryWhite()
                                                        : AppColorsLightMode
                                                            .appPrimaryWhite(),
                                                    decoration:
                                                        TextDecoration.none),
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.only(
                                                  left: 0,
                                                  top: 10,
                                                  bottom: 12.0),
                                              child:
                                                  Text(probeData!.y.toString()),
                                            ),
                                          ],
                                        ),
                                        divider(context),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Column(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  textNameExpanded =
                                                      !textNameExpanded;
                                                });
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 30.0),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      width: 20,
                                                      padding: EdgeInsets.only(
                                                          bottom: 10.0),
                                                      child: textNameExpanded
                                                          ? Image.asset(
                                                              theme_dark!
                                                                  ? Constants
                                                                          .ASSET_IMAGES +
                                                                      'dropdown_icon.png'
                                                                  : Constants
                                                                          .ASSET_IMAGES_LIGHT +
                                                                      'dropdown.png',
                                                            )
                                                          : Image.asset(
                                                              theme_dark!
                                                                  ? Constants
                                                                          .ASSET_IMAGES +
                                                                      'next_bttn.png'
                                                                  : Constants
                                                                          .ASSET_IMAGES_LIGHT +
                                                                      'next_bttn.png',
                                                              width: 6,
                                                              height: 10,
                                                            ),
                                                    ),
                                                    Container(
                                                      //width: MediaQuery.of(context).size.width / 2 - 40,
                                                      padding: EdgeInsets.only(
                                                          left: 8.0,
                                                          top: 0,
                                                          bottom: 12.0),
                                                      child: Text(
                                                        Utils.getTranslated(
                                                            context,
                                                            'probe_finder_testName')!,
                                                        style: AppFonts.robotoRegular(
                                                            16,
                                                            color: theme_dark!
                                                                ? AppColors
                                                                    .appPrimaryWhite()
                                                                : AppColorsLightMode
                                                                    .appPrimaryWhite(),
                                                            decoration:
                                                                TextDecoration
                                                                    .none),
                                                      ),
                                                    ),
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          left: 8.0,
                                                          top: 0,
                                                          bottom: 12.0),
                                                      child: Text(
                                                        '(' +
                                                            probeData!
                                                                .testNames!
                                                                .length
                                                                .toString() +
                                                            ')',
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            divider(context),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            //Prode Detail
                                            textNameExpanded
                                                ? Column(
                                                    children: [
                                                      for (var i = 0;
                                                          i <
                                                              probeData!
                                                                  .testNames!
                                                                  .length;
                                                          i++)
                                                        dataItem(
                                                            context,
                                                            probeData!
                                                                .testNames![i])
                                                    ],
                                                  )
                                                : Container(),
                                          ],
                                        )
                                      ],
                                    )
                                  : Container(),
                            ],
                          ),
                        ),
                        Container(
                          child: Column(
                            children: [
                              //ProdeHeader
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    nodeExpanded = !nodeExpanded;
                                  });
                                },
                                child: Row(
                                  children: [
                                    Container(
                                      width: 40,
                                      padding: EdgeInsets.only(bottom: 10.0),
                                      child: Image.asset(
                                        nodeExpanded
                                            ? theme_dark!
                                                ? Constants.ASSET_IMAGES +
                                                    'dropdown_icon.png'
                                                : Constants.ASSET_IMAGES_LIGHT +
                                                    'dropdown.png'
                                            : theme_dark!
                                                ? Constants.ASSET_IMAGES +
                                                    'next_bttn.png'
                                                : Constants.ASSET_IMAGES_LIGHT +
                                                    'next_bttn.png',
                                        width: 6,
                                        height: 10,
                                      ),
                                    ),
                                    Container(
                                      //width: MediaQuery.of(context).size.width / 2 - 40,
                                      padding: EdgeInsets.only(
                                          left: 8.0, top: 0, bottom: 12.0),
                                      child: Text(
                                        Utils.getTranslated(
                                            context, 'probe_finder_node')!,
                                        style: AppFonts.robotoRegular(16,
                                            color: theme_dark!
                                                ? AppColors.appPrimaryWhite()
                                                : AppColorsLightMode
                                                    .appPrimaryWhite(),
                                            decoration: TextDecoration.none),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(
                                          left: 8.0, top: 0, bottom: 12.0),
                                      child: Text(
                                        '(' + totalNode.toString() + ')',
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              divider(context),
                              SizedBox(
                                height: 10,
                              ),
                              //Prode Detail
                              nodeExpanded
                                  ? Column(
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      2 -
                                                  45,
                                              padding: EdgeInsets.only(
                                                  left: 8.0,
                                                  top: 0,
                                                  bottom: 0.0),
                                              margin: EdgeInsets.only(
                                                left: 45,
                                              ),
                                              child: Text(
                                                Utils.getTranslated(context,
                                                    'probe_finder_nodeName')!,
                                                style: AppFonts.robotoRegular(
                                                    16,
                                                    color: theme_dark!
                                                        ? AppColors
                                                            .appPrimaryWhite()
                                                        : AppColorsLightMode
                                                            .appPrimaryWhite(),
                                                    decoration:
                                                        TextDecoration.none),
                                              ),
                                            ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      2 -
                                                  24,
                                              padding: EdgeInsets.only(
                                                  left: 0.0,
                                                  top: 0,
                                                  bottom: 0.0),
                                              child: Text(
                                                nodeDetailDataDTO.node!,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 12,
                                        ),
                                        divider(context),
                                        SizedBox(
                                          height: 12,
                                        ),
                                        Column(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  nodePinsExpanded =
                                                      !nodePinsExpanded;
                                                });
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 30.0),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      width: 20,
                                                      padding: EdgeInsets.only(
                                                          bottom: 10.0),
                                                      child: Image.asset(
                                                        nodePinsExpanded
                                                            ? theme_dark!
                                                                ? Constants
                                                                        .ASSET_IMAGES +
                                                                    'dropdown_icon.png'
                                                                : Constants
                                                                        .ASSET_IMAGES_LIGHT +
                                                                    'dropdown.png'
                                                            : theme_dark!
                                                                ? Constants
                                                                        .ASSET_IMAGES +
                                                                    'next_bttn.png'
                                                                : Constants
                                                                        .ASSET_IMAGES_LIGHT +
                                                                    'next_bttn.png',
                                                        width: 6,
                                                        height: 10,
                                                      ),
                                                    ),
                                                    Container(
                                                      //width: MediaQuery.of(context).size.width / 2 - 40,
                                                      padding: EdgeInsets.only(
                                                          left: 8.0,
                                                          top: 0,
                                                          bottom: 12.0),
                                                      child: Text(
                                                        Utils.getTranslated(
                                                            context,
                                                            'probe_finder_pins')!,
                                                        style: AppFonts.robotoRegular(
                                                            16,
                                                            color: theme_dark!
                                                                ? AppColors
                                                                    .appPrimaryWhite()
                                                                : AppColorsLightMode
                                                                    .appPrimaryWhite(),
                                                            decoration:
                                                                TextDecoration
                                                                    .none),
                                                      ),
                                                    ),
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          left: 8.0,
                                                          top: 0,
                                                          bottom: 12.0),
                                                      child: Text(
                                                        '(' +
                                                            nodeDetailDataDTO
                                                                .pin!.length
                                                                .toString() +
                                                            ')',
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),

                                            divider(context),
                                            SizedBox(
                                              height: 12,
                                            ),
                                            //Prode Detail
                                            nodePinsExpanded
                                                ? Column(
                                                    children: [
                                                      for (var i = 0;
                                                          i <
                                                              nodeDetailDataDTO
                                                                  .pin!.length;
                                                          i++)
                                                        dataItem(
                                                            context,
                                                            nodeDetailDataDTO
                                                                .pin![i])
                                                    ],
                                                  )
                                                : Container(),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  nodeProbeExpanded =
                                                      !nodeProbeExpanded;
                                                });
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 30.0),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      width: 20,
                                                      padding: EdgeInsets.only(
                                                          bottom: 10.0),
                                                      child: Image.asset(
                                                        nodeProbeExpanded
                                                            ? theme_dark!
                                                                ? Constants
                                                                        .ASSET_IMAGES +
                                                                    'dropdown_icon.png'
                                                                : Constants
                                                                        .ASSET_IMAGES_LIGHT +
                                                                    'dropdown.png'
                                                            : theme_dark!
                                                                ? Constants
                                                                        .ASSET_IMAGES +
                                                                    'next_bttn.png'
                                                                : Constants
                                                                        .ASSET_IMAGES_LIGHT +
                                                                    'next_bttn.png',
                                                        width: 6,
                                                        height: 10,
                                                      ),
                                                    ),
                                                    Container(
                                                      //width: MediaQuery.of(context).size.width / 2 - 40,
                                                      padding: EdgeInsets.only(
                                                          left: 8.0,
                                                          top: 0,
                                                          bottom: 12.0),
                                                      child: Text(
                                                        Utils.getTranslated(
                                                            context,
                                                            'probe_finder_probe')!,
                                                        style: AppFonts.robotoRegular(
                                                            16,
                                                            color: theme_dark!
                                                                ? AppColors
                                                                    .appPrimaryWhite()
                                                                : AppColorsLightMode
                                                                    .appPrimaryWhite(),
                                                            decoration:
                                                                TextDecoration
                                                                    .none),
                                                      ),
                                                    ),
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          left: 8.0,
                                                          top: 0,
                                                          bottom: 12.0),
                                                      child: Text(
                                                        '(' +
                                                            nodeDetailDataDTO
                                                                .probeId!.length
                                                                .toString() +
                                                            ')',
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            divider(context),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            //Prode Detail
                                            nodeProbeExpanded
                                                ? Column(
                                                    children: [
                                                      for (var i = 0;
                                                          i <
                                                              nodeDetailDataDTO
                                                                  .probeId!
                                                                  .length;
                                                          i++)
                                                        dataItem(
                                                            context,
                                                            nodeDetailDataDTO
                                                                .probeId![i])
                                                    ],
                                                  )
                                                : Container(),
                                          ],
                                        ),
                                        nodeDetailDataDTO.personalityPin != null
                                            ? Column(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        nodePersonalityPin =
                                                            !nodePersonalityPin;
                                                      });
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 30.0),
                                                      child: Row(
                                                        children: [
                                                          Container(
                                                            width: 20,
                                                            padding:
                                                                EdgeInsets.only(
                                                                    bottom:
                                                                        10.0),
                                                            child: Image.asset(
                                                              nodePersonalityPin
                                                                  ? theme_dark!
                                                                      ? Constants
                                                                              .ASSET_IMAGES +
                                                                          'dropdown_icon.png'
                                                                      : Constants
                                                                              .ASSET_IMAGES_LIGHT +
                                                                          'dropdown.png'
                                                                  : theme_dark!
                                                                      ? Constants
                                                                              .ASSET_IMAGES +
                                                                          'next_bttn.png'
                                                                      : Constants
                                                                              .ASSET_IMAGES_LIGHT +
                                                                          'next_bttn.png',
                                                              width: 6,
                                                              height: 10,
                                                            ),
                                                          ),
                                                          Container(
                                                            //width: MediaQuery.of(context).size.width / 2 - 40,
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 8.0,
                                                                    top: 0,
                                                                    bottom:
                                                                        12.0),
                                                            child: Text(
                                                              Utils.getTranslated(
                                                                  context,
                                                                  'probe_finder_personalitypins')!,
                                                              style: AppFonts.robotoRegular(
                                                                  16,
                                                                  color: theme_dark!
                                                                      ? AppColors
                                                                          .appPrimaryWhite()
                                                                      : AppColorsLightMode
                                                                          .appPrimaryWhite(),
                                                                  decoration:
                                                                      TextDecoration
                                                                          .none),
                                                            ),
                                                          ),
                                                          Container(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 8.0,
                                                                    top: 0,
                                                                    bottom:
                                                                        12.0),
                                                            child: Text(
                                                              '(' +
                                                                  nodeDetailDataDTO
                                                                      .personalityPin!
                                                                      .length
                                                                      .toString() +
                                                                  ')',
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),

                                                  divider(context),
                                                  SizedBox(
                                                    height: 12,
                                                  ),
                                                  //Prode Detail
                                                  nodePersonalityPin
                                                      ? Column(
                                                          children: [
                                                            for (var i = 0;
                                                                i <
                                                                    nodeDetailDataDTO
                                                                        .personalityPin!
                                                                        .length;
                                                                i++)
                                                              dataItem(
                                                                  context,
                                                                  nodeDetailDataDTO
                                                                      .personalityPin![i])
                                                          ],
                                                        )
                                                      : Container(),
                                                ],
                                              )
                                            : Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 30.0),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      width: 20,
                                                      padding: EdgeInsets.only(
                                                          bottom: 10.0),
                                                      child: Image.asset(
                                                        theme_dark!
                                                            ? Constants
                                                                    .ASSET_IMAGES +
                                                                'dropdown_icon.png'
                                                            : Constants
                                                                    .ASSET_IMAGES_LIGHT +
                                                                'dropdown.png',
                                                        width: 6,
                                                        height: 10,
                                                      ),
                                                    ),
                                                    Container(
                                                      //width: MediaQuery.of(context).size.width / 2 - 40,
                                                      padding: EdgeInsets.only(
                                                          left: 8.0,
                                                          top: 0,
                                                          bottom: 12.0),
                                                      child: Text(
                                                        Utils.getTranslated(
                                                            context,
                                                            'probe_finder_personality')!,
                                                        style: AppFonts.robotoRegular(
                                                            16,
                                                            color: theme_dark!
                                                                ? AppColors
                                                                    .appPrimaryWhite()
                                                                : AppColorsLightMode
                                                                    .appPrimaryWhite(),
                                                            decoration:
                                                                TextDecoration
                                                                    .none),
                                                      ),
                                                    ),
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          left: 8.0,
                                                          top: 0,
                                                          bottom: 12.0),
                                                      child: Text('(0)'),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                        nodeDetailDataDTO.transferPin != null
                                            ? Column(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        nodeTransferPin =
                                                            !nodeTransferPin;
                                                      });
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 30.0),
                                                      child: Row(
                                                        children: [
                                                          Container(
                                                            width: 20,
                                                            padding:
                                                                EdgeInsets.only(
                                                                    bottom:
                                                                        10.0),
                                                            child: Image.asset(
                                                              nodeTransferPin
                                                                  ? theme_dark!
                                                                      ? Constants
                                                                              .ASSET_IMAGES +
                                                                          'dropdown_icon.png'
                                                                      : Constants
                                                                              .ASSET_IMAGES_LIGHT +
                                                                          'dropdown.png'
                                                                  : theme_dark!
                                                                      ? Constants
                                                                              .ASSET_IMAGES +
                                                                          'next_bttn.png'
                                                                      : Constants
                                                                              .ASSET_IMAGES_LIGHT +
                                                                          'next_bttn.png',
                                                              width: 6,
                                                              height: 10,
                                                            ),
                                                          ),
                                                          Container(
                                                            //width: MediaQuery.of(context).size.width / 2 - 40,
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 8.0,
                                                                    top: 0,
                                                                    bottom:
                                                                        12.0),
                                                            child: Text(
                                                              Utils.getTranslated(
                                                                  context,
                                                                  'probe_finder_transferpins')!,
                                                              style: AppFonts.robotoRegular(
                                                                  16,
                                                                  color: theme_dark!
                                                                      ? AppColors
                                                                          .appPrimaryWhite()
                                                                      : AppColorsLightMode
                                                                          .appPrimaryWhite(),
                                                                  decoration:
                                                                      TextDecoration
                                                                          .none),
                                                            ),
                                                          ),
                                                          Container(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 8.0,
                                                                    top: 0,
                                                                    bottom:
                                                                        12.0),
                                                            child: Text(
                                                              '(' +
                                                                  nodeDetailDataDTO
                                                                      .transferPin!
                                                                      .length
                                                                      .toString() +
                                                                  ')',
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),

                                                  divider(context),
                                                  SizedBox(
                                                    height: 12,
                                                  ),
                                                  //Prode Detail
                                                  nodeTransferPin
                                                      ? Column(
                                                          children: [
                                                            for (var i = 0;
                                                                i <
                                                                    nodeDetailDataDTO
                                                                        .transferPin!
                                                                        .length;
                                                                i++)
                                                              dataItem(
                                                                  context,
                                                                  nodeDetailDataDTO
                                                                      .transferPin![i])
                                                          ],
                                                        )
                                                      : Container(),
                                                ],
                                              )
                                            : Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 30.0),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      width: 20,
                                                      padding: EdgeInsets.only(
                                                          bottom: 10.0),
                                                      child: Image.asset(
                                                        theme_dark!
                                                            ? Constants
                                                                    .ASSET_IMAGES +
                                                                'dropdown_icon.png'
                                                            : Constants
                                                                    .ASSET_IMAGES_LIGHT +
                                                                'dropdown.png',
                                                        width: 6,
                                                        height: 10,
                                                      ),
                                                    ),
                                                    Container(
                                                      //width: MediaQuery.of(context).size.width / 2 - 40,
                                                      padding: EdgeInsets.only(
                                                          left: 8.0,
                                                          top: 0,
                                                          bottom: 12.0),
                                                      child: Text(
                                                        Utils.getTranslated(
                                                            context,
                                                            'probe_finder_transferpins')!,
                                                        style: AppFonts.robotoRegular(
                                                            16,
                                                            color: theme_dark!
                                                                ? AppColors
                                                                    .appPrimaryWhite()
                                                                : AppColorsLightMode
                                                                    .appPrimaryWhite(),
                                                            decoration:
                                                                TextDecoration
                                                                    .none),
                                                      ),
                                                    ),
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          left: 8.0,
                                                          top: 0,
                                                          bottom: 12.0),
                                                      child: Text('(0)'),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                      ],
                                    )
                                  : Container(),
                            ],
                          ),
                        ),
                      ]),
                )),
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

  Widget dataItem(BuildContext ctx, String e) {
    return Container(
      padding: EdgeInsets.only(left: 0, top: 0, bottom: 10.0),
      child: Column(
        children: [
          Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 2,
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 2 - 24,
                  child: Text(
                    e,
                  ),
                ),
              ]),
          SizedBox(
            height: 12,
          ),
          divider(ctx),
        ],
      ),
    );
  }
}
