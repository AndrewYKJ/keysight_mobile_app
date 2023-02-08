import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_api_availability/google_api_availability.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:keysight_pma/cache/appcache.dart';
import 'package:keysight_pma/const/constants.dart';
import 'package:keysight_pma/const/localization.dart';
import 'package:keysight_pma/model/custom_server/server.dart';
import 'package:keysight_pma/model/customize.dart';
import 'package:keysight_pma/model/dqm/custom.dart';
import 'package:keysight_pma/model/sortAndFilter/equipment.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:umeng_common_sdk/umeng_common_sdk.dart';

class Utils {
  static printInfo(Object object) {
    if (Constants.isDebug) {
      print(object);
    }
  }

  static void showAlertDialog(
      BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) => new CupertinoAlertDialog(
        title: new Text(title),
        content: new Text(message),
        actions: <Widget>[
          CupertinoDialogAction(
            child: Text("OK"),
            onPressed: () {
              Navigator.pop(dialogContext);
            },
          ),
        ],
      ),
    );
  }

  static Locale mylocale(String languageCode) {
    switch (languageCode) {
      case Constants.LANGUAGE_CODE_EN:
        return Locale(Constants.ENGLISH);
      case Constants.LANGUAGE_CODE_CN:
        return Locale(Constants.CHINESE);
      default:
        return Locale(Constants.ENGLISH);
    }
  }

  static String? appLanguage(BuildContext context, String languageCode) {
    switch (languageCode) {
      case Constants.LANGUAGE_CODE_EN:
        return getTranslated(context, "setting_language_en");
      case Constants.LANGUAGE_CODE_CN:
        return getTranslated(context, "setting_language_zh");
      default:
        return "";
    }
  }

  static String capitalize(String string) {
    if (string.isEmpty) {
      return string;
    }

    return string[0].toUpperCase() + string.substring(1);
  }

  static String? getTranslated(BuildContext context, String key) {
    return MyLocalization.of(context)!.translate(key);
  }

  static String convertToAgo(String dateTime, numericDates) {
    DateTime input = DateTime.parse(dateTime);
    Duration difference = DateTime.now().difference(input);
    // print(input);
    // print(DateTime.now());

    if ((difference.inDays > 365)) {
      if ((difference.inDays / 365).floor() > 1) {
        return '${(difference.inDays / 365).floor()}years ago';
      } else {
        return (numericDates) ? '1year ago' : 'Last year';
      }
    } else if ((difference.inDays / 7).floor() == 1) {
      return (numericDates) ? '1week ago' : 'Last week';
    } else if (difference.inDays >= 2) {
      return '${difference.inDays}days ago';
    } else if (difference.inDays == 1) {
      return (numericDates) ? '1day ago' : 'Yesterday';
    } else if (difference.inHours >= 2) {
      return '${difference.inHours}hours ago';
    } else if (difference.inHours >= 1) {
      return (numericDates) ? '1hour ago' : 'An hour ago';
    } else if (difference.inMinutes >= 2) {
      return '${difference.inMinutes}mins ago';
    } else if (difference.inMinutes >= 1) {
      return (numericDates) ? '1min ago' : 'A min ago';
    } else if (difference.inSeconds >= 3) {
      return '${difference.inSeconds}seconds ago';
    } else {
      return 'Just now';
    }
  }

  static bool isNotEmpty(String? text) {
    return text != null && text.length > 0;
  }

  static DateTime sortFilterStartDate(String preferredDays) {
    if (isNotEmpty(preferredDays)) {
      DateTime now = new DateTime.now();
      if (preferredDays == Constants.PREFERRED_DAYS_MONTH) {
        return DateTime(now.year, now.month, 1);
      } else if (preferredDays == Constants.PREFERRED_DAYS_WEEK) {
        return now.subtract(Duration(days: now.weekday - 1));
      } else if (preferredDays == Constants.PREFERRED_DAYS_TODAY) {
        return now;
      } else if (preferredDays == Constants.PREFERRED_DAYS_YESTERDAY) {
        return now.subtract(Duration(days: 1));
      } else {
        int day = int.parse(preferredDays);
        return now.subtract(Duration(days: day));
      }
    }

    return DateTime.now();
  }

  static String prefixConversion(dynamic number, int decimalPoint) {
    // Checking is a string
    if (number.runtimeType == String && num.parse(number).isNaN) {
      return number;
    }
    double numbers =
        number.runtimeType == String ? double.parse(number) : number;

    bool isNegative = false;
    if (numbers < 0) {
      isNegative = true;
      numbers = numbers * -1;
    }

    if (numbers > 1) {
      return convertPositiveE(numbers, decimalPoint, isNegative);
    } else {
      return convertNegativeE(numbers, decimalPoint, isNegative);
    }
  }

  static String convertPositiveE(
      double numbers, int decimalPoint, bool isNegative) {
    const prefix = ['', 'k', 'M', 'G', 'T', 'P', 'E', 'Z', 'Y'];
    int ii = 0;
    double convertNumber = 0;

    int currentPow = 1;
    bool overflow = true;
    for (int i = 0; i <= 8; i++) {
      double numberPow = numbers / pow(10, currentPow * 3);
      if (numberPow < 1) {
        convertNumber = numberPow;
        ii = i;
        overflow = false;
        break;
      }
      currentPow++;
    }

    if (overflow) {
      return convertToExponential(numbers, decimalPoint, isNegative);
    } else {
      String value;
      if (isNegative) {
        value = (-convertNumber * 1000).toStringAsFixed(decimalPoint);
      } else {
        value = (convertNumber * 1000).toStringAsFixed(decimalPoint);
      }

      return value + prefix[ii];
    }
  }

  static String convertNegativeE(
      double numbers, int decimalPoint, bool isNegative) {
    const prefix = ['', 'm', 'µ', 'n', 'p', 'f', 'a', 'z', 'y'];
    int ii = 0;
    double convertNumber = 0;

    int currentPow = 1;
    bool overflow = true;

    for (int i = 0; i <= 8; i++) {
      double numberPow = numbers * pow(10, currentPow * 3);
      if (numberPow >= 1000) {
        convertNumber = numberPow;
        ii = i;
        overflow = false;
        break;
      }
      currentPow++;
    }

    if (overflow) {
      return convertToExponential(numbers, decimalPoint, isNegative);
    } else {
      String value;
      if (isNegative) {
        value = (-convertNumber / 1000).toStringAsFixed(decimalPoint);
      } else {
        value = (convertNumber / 1000).toStringAsFixed(decimalPoint);
      }

      return value + prefix[ii];
    }
  }

  static String convertToExponential(
      double numbers, int decimalPoint, bool isNegative) {
    double convertNumber = numbers / 1;
    if (convertNumber == 0) {
      return "0";
    } else if (isNegative) {
      return "-" + (convertNumber.toStringAsExponential(decimalPoint));
    } else {
      return convertNumber.toStringAsExponential(decimalPoint);
    }
  }

  static Future<bool> download(
      {Uint8List? bytes,
      int? width,
      int? height,
      String? equipmentName,
      String? projectName,
      int? chartFrom,
      String? fileName,
      String? downloadType,
      String? csv}) async {
    Directory directory;

    try {
      if (Platform.isAndroid) {
        if (await _requestPermission(Permission.storage) &&
            await _requestPermission(Permission.manageExternalStorage)) {
          directory = (await getExternalStorageDirectory())!;
          String newPath = "";
          Utils.printInfo(directory);
          List<String> paths = directory.path.split("/");
          for (int x = 1; x < paths.length; x++) {
            String folder = paths[x];
            if (folder != "Android") {
              newPath += "/" + folder;
            } else {
              break;
            }
          }
          if (downloadType == Constants.DOWNLOAD_AS_IMAGE) {
            if (chartFrom == 1100) {
              if (equipmentName != null) {
                newPath = newPath +
                    "/KeysightApp/Image/summaryDQM/" +
                    '$equipmentName';
              } else if (projectName != null) {
                newPath =
                    newPath + "/KeysightApp/Image/summaryDQM" + '$projectName';
              } else {
                newPath = newPath + "/KeysightApp/Image/summaryDQM";
              }
            } else if (chartFrom == 1200) {
              if (equipmentName != null) {
                newPath = newPath +
                    "/KeysightApp/Image/summaryOEE/" +
                    '$equipmentName';
              } else if (projectName != null) {
                newPath =
                    newPath + "/KeysightApp/Image/summaryOEE" + '$projectName';
              } else {
                newPath = newPath + "/KeysightApp/Image/summaryOEE";
              }
            } else
              newPath = newPath + "/KeysightApp/IMAGE";
            print('########### dojjjne');
          } else if (downloadType == Constants.DOWNLOAD_AS_PDF) {
            if (chartFrom == 1100) {
              if (equipmentName != null) {
                newPath =
                    newPath + "/KeysightApp/PDF/summaryDQM/" + '$equipmentName';
              } else if (projectName != null) {
                newPath =
                    newPath + "/KeysightApp/PDF/summaryDQM" + '$projectName';
              } else {
                newPath = newPath + "/KeysightApp/PDF/summaryDQM";
              }
            } else if (chartFrom == 1200) {
              if (equipmentName != null) {
                newPath =
                    newPath + "/KeysightApp/PDF/summaryOEE/" + '$equipmentName';
              } else if (projectName != null) {
                newPath =
                    newPath + "/KeysightApp/PDF/summaryOEE" + '$projectName';
              } else {
                newPath = newPath + "/KeysightApp/PDF/summaryOEE";
              }
            } else
              newPath = newPath + "/KeysightApp/PDF";
            print('########### dojjjne');
          } else {
            if (chartFrom == 1100) {
              if (equipmentName != null) {
                newPath =
                    newPath + "/KeysightApp/CSV/summaryDQM/" + '$equipmentName';
              } else if (projectName != null) {
                newPath =
                    newPath + "/KeysightApp/CSV/summaryDQM" + '$projectName';
              } else {
                newPath = newPath + "/KeysightApp/CSV/summaryDQM";
              }
            } else if (chartFrom == 1200) {
              if (equipmentName != null) {
                newPath =
                    newPath + "/KeysightApp/CSV/summaryOEE/" + '$equipmentName';
              } else if (projectName != null) {
                newPath =
                    newPath + "/KeysightApp/CSV/summaryOEE" + '$projectName';
              } else {
                newPath = newPath + "/KeysightApp/CSV/summaryOEE";
              }
            } else
              newPath = newPath + "/KeysightApp/CSV";
          }
          print('########### done');

          directory = Directory(newPath);
          print(directory);
        } else {
          return false;
        }
      } else {
        if (downloadType == Constants.DOWNLOAD_AS_IMAGE) {
          if (await _requestPermission(Permission.storage)) {
            print('########## ios image');
            if (chartFrom == 1100) {
              if (equipmentName != null) {
                directory = Directory(
                    (await getApplicationDocumentsDirectory()).path +
                        '/image/summaryDQM/' +
                        '$equipmentName');
              } else if (projectName != null) {
                directory = Directory(
                    (await getApplicationDocumentsDirectory()).path +
                        '/image/summaryDQM/' +
                        '$projectName');
              } else {
                directory = Directory(
                    (await getApplicationDocumentsDirectory()).path +
                        '/image/summaryDQM');
              }
            } else if (chartFrom == 1200) {
              if (equipmentName != null) {
                directory = Directory(
                    (await getApplicationDocumentsDirectory()).path +
                        '/image/summaryOEE/' +
                        '$equipmentName');
              } else if (projectName != null) {
                directory = Directory(
                    (await getApplicationDocumentsDirectory()).path +
                        '/image/summaryOEE/' +
                        '$projectName');
              } else {
                directory = Directory(
                    (await getApplicationDocumentsDirectory()).path +
                        '/image/summaryOEE');
              }
            } else
              directory = Directory(
                  (await getApplicationDocumentsDirectory()).path + '/image');
          } else {
            return false;
          }
        } else if (downloadType == Constants.DOWNLOAD_AS_PDF) {
          if (await _requestPermission(Permission.storage)) {
            print('########## ios pdf');
            if (chartFrom == 1100) {
              if (equipmentName != null) {
                directory = Directory(
                    (await getApplicationDocumentsDirectory()).path +
                        '/pdf/summaryDQM/' +
                        '$equipmentName');
              } else if (projectName != null) {
                directory = Directory(
                    (await getApplicationDocumentsDirectory()).path +
                        '/pdf/summaryDQM/' +
                        '$projectName');
              } else {
                directory = Directory(
                    (await getApplicationDocumentsDirectory()).path +
                        '/pdf/summaryDQM');
              }
            } else if (chartFrom == 1200) {
              if (equipmentName != null) {
                directory = Directory(
                    (await getApplicationDocumentsDirectory()).path +
                        '/pdf/summaryOEE/' +
                        '$equipmentName');
              } else if (projectName != null) {
                directory = Directory(
                    (await getApplicationDocumentsDirectory()).path +
                        '/pdf/summaryOEE/' +
                        '$projectName');
              } else {
                directory = Directory(
                    (await getApplicationDocumentsDirectory()).path +
                        '/pdf/summaryOEE');
              }
            } else
              directory = Directory(
                  (await getApplicationDocumentsDirectory()).path + '/pdf');
          } else {
            return false;
          }
        } else {
          if (await _requestPermission(Permission.storage)) {
            print('########## ios csv');
            if (chartFrom == 1100) {
              if (equipmentName != null) {
                directory = Directory(
                    (await getApplicationDocumentsDirectory()).path +
                        '/csv/summaryDQM/' +
                        '$equipmentName');
              } else if (projectName != null) {
                directory = Directory(
                    (await getApplicationDocumentsDirectory()).path +
                        '/csv/summaryDQM/' +
                        '$projectName');
              } else {
                directory = Directory(
                    (await getApplicationDocumentsDirectory()).path +
                        '/csv/summaryDQM');
              }
            } else if (chartFrom == 1200) {
              if (equipmentName != null) {
                directory = Directory(
                    (await getApplicationDocumentsDirectory()).path +
                        '/csv/summaryOEE/' +
                        '$equipmentName');
              } else if (projectName != null) {
                directory = Directory(
                    (await getApplicationDocumentsDirectory()).path +
                        '/csv/summaryOEE/' +
                        '$projectName');
              } else {
                directory = Directory(
                    (await getApplicationDocumentsDirectory()).path +
                        '/csv/summaryOEE');
              }
            } else
              directory = Directory(
                  (await getApplicationDocumentsDirectory()).path + '/csv');
          } else {
            return false;
          }
        }
      }

      var status = await Permission.storage.status;
      if (!status.isGranted) {
        await Permission.storage.request();
      }

      File saveFile = File(directory.path + "/$fileName");
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

      if (await directory.exists()) {
        print('########### exists');
        print(directory.path);
        print(saveFile);
        if (isNotEmpty(csv)) {
          print('########### done test csv');
          saveFile.writeAsString(csv!);
          // print(csv);
          print(directory);
          print(saveFile);
        } else {
          print('########### savefile');
          saveFile.writeAsBytesSync(bytes!);
        }

        if (Platform.isIOS) {
          if (downloadType == Constants.DOWNLOAD_AS_IMAGE) {
            print('############ directory exist');
            saveFile.writeAsBytesSync(bytes!);
            // await ImageGallerySaver.saveFile(saveFile.path,
            //     isReturnPathOfIOS: true);

          } else if (downloadType == Constants.DOWNLOAD_AS_PDF) {
            print('############ directory exist pdf');
            print(directory);
            print(saveFile);

            await saveFile.writeAsBytes(bytes!, flush: true);

            print('########### done saving pdf');
          } else {}
        }
        print('########### done saving');
        return true;
      }
    } catch (e) {
      printInfo(e);
    }
    return false;
  }

  static Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }

  static bool isSelectAll(
      {List<CustomDqmSortFilterItemSelectionDTO>? itemList,
      List<CustomDqmSortFilterProjectsDTO>? otherItemList,
      List<DqmXaxisRangeDTO>? caseHistoryItem,
      List<EquipmentDataDTO>? eqList}) {
    if (itemList != null) {
      return (itemList
              .where((element) => element.isSelected!)
              .toList()
              .length ==
          itemList.length);
    } else if (otherItemList != null) {
      return (otherItemList
              .where((element) => element.isSelected!)
              .toList()
              .length ==
          otherItemList.length);
    } else if (caseHistoryItem != null) {
      return (caseHistoryItem
              .where((element) => element.isSelected!)
              .toList()
              .length ==
          caseHistoryItem.length);
    } else if (eqList != null) {
      return (eqList.where((element) => element.isSelected!).toList().length ==
          eqList.length);
    }

    return false;
  }

  static String serverDomain() {
    String domain = '';
    AppCache.getStringValue(AppCache.CUSTOM_SERVER_PREF).then((value) {
      if (Utils.isNotEmpty(value)) {
        List<dynamic> cacheServerList = jsonDecode(value);
        if (cacheServerList.length > 0) {
          cacheServerList.forEach((element) {
            if (CustomServerDTO.fromJson(element).isSelected!) {
              CustomServerDTO customServerDTO =
                  CustomServerDTO.fromJson(element);
              if (isNotEmpty(customServerDTO.serverPort)) {
                domain =
                    '${customServerDTO.serverIp}:${customServerDTO.serverPort}/';
              } else {
                domain = '${customServerDTO.serverIp}/';
              }
            }
          });
        }
      }
    });

    return domain;
  }

  static String ammendSentences(String str) {
    if (str.startsWith("DUT")) {
      str = str.substring(3);
    }

    final beforeNonLeadingCapitalLetter = RegExp(r"(?=(?!^)[A-Z])");
    List<String> splitPascalCase = str.split(beforeNonLeadingCapitalLetter);
    return splitPascalCase.join(" ").trim();
  }

  static Future<int> checkPlayServices({bool showDialog = false}) async {
    GooglePlayServicesAvailability playStoreAvailability;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      playStoreAvailability = await GoogleApiAvailability.instance
          .checkGooglePlayServicesAvailability(showDialog);
    } on PlatformException {
      playStoreAvailability = GooglePlayServicesAvailability.unknown;
    }

    return playStoreAvailability.value;
  }

  static void setFirebaseAnalyticsCurrentScreen(String curScreenName) {
    if (Constants.IS_SUPPORT_GOOGLE) {
      FirebaseAnalytics.instance.setCurrentScreen(screenName: curScreenName);
    }
  }

  static String getExportFilename(String keyword,
      {String? companyId,
      String? siteId,
      String? projectId,
      String? equipmentId,
      String? fixtureId,
      String? fromDate,
      String? toDate,
      String? currentDate,
      String? expType}) {
    Map<String, String> mapKeyswords = {
      "daily": 'Dly',
      "equipment": 'Eqp',
      "project": 'Proj',
      "first": 'Frst',
      "yield": 'Yild',
      "volume": 'Vol',
      "name": 'Nm',
      "testname": 'Tnm',
      "component": 'Comp',
      "components": 'Comp',
      "Variation": 'Var',
      "chart": 'Chrt',
      "measurement": 'Measuremnt',
      "anomaly": 'Anmly',
      "information": 'Info',
      "result": 'Rst',
      "fixture": 'Fxt',
      "test": 'Tst',
      "time": 'Tm',
      "disposition": 'Dispst',
      "distribution": 'Distbt',
      "fail": 'Fl',
      "final": 'Fnl',
      "count": 'Cnt',
      "type": 'Typ',
      "worst": 'Wst',
      "board": 'Brd',
      "limit": 'Lmt',
      "change": 'Chg',
      "alert": 'Alrt',
      "statistic": 'Stst',
      "accuracy": 'Acrcy',
      "status": 'Sts',
      "temperature": 'Temp',
      "blower": 'Blw',
      "pressure": 'Prusr',
      "vacuum": 'Vacm',
      "compress": 'Compr',
      "output": 'Otpt',
      "utilization": 'Util',
      "summary": 'Smry',
      "detail": 'Dtl',
      "breakdown": 'Brkdwn',
      "scheduled": 'schdl',
      "For": 'Fr',
      "Non": 'Non',
      "oee": 'OEE',
      "availability": 'Avblty',
      "performance": 'Pfmce',
      "quality": 'Qlty',
      "metric": 'Mtrc',
      "total": 'Ttl',
      "retest": 'Rtst',
      "power": 'Pwr',
      "real": 'Rl',
      "voltage": 'Vlt',
      "current": 'Crnt',
      "apparent": 'Aprt',
      "false": 'Fls',
      "failure": 'Flre',
      "rate": 'Rt',
      "list": 'Lst',
      "boards": 'Brds',
      "history": 'Hist',
      "probe": 'Prb',
      "finder": 'Fndr',
      "histogram": 'Htgrm',
      "heatmap": 'Htmp',
      "waveform": 'wf',
      "source": 'src',
      "file": 'fl',
      "gross": 'Grs',
      "batch": 'Btch',
      "jobs": 'Jbs',
      "comparison": 'Cmprsn',
      "trend": 'Trnd',
      "contribution": 'Ctrbtn',
      "pass": 'Ps',
      "process": 'Prs',
      "checkpoint": 'Chkp',
      "review": 'Revw'
    };
    String filename = '';
    String delimiter = '_';
    String title = '';

    if (isNotEmpty(keyword)) {
      if (isNotEmpty(mapKeyswords[keyword])) {
        title = mapKeyswords[keyword]!;
      } else {
        title = keyword;
      }
    } else {
      title = keyword;
    }

    if (isNotEmpty(companyId)) {
      filename += (companyId! + delimiter);
    }

    if (isNotEmpty(siteId)) {
      filename += (siteId! + delimiter);
    }

    if (isNotEmpty(projectId)) {
      filename += (projectId! + delimiter);
    }

    if (isNotEmpty(equipmentId)) {
      filename += (equipmentId! + delimiter);
    }

    if (isNotEmpty(fixtureId)) {
      filename += (fixtureId! + delimiter);
    }

    filename += title + delimiter;

    if (isNotEmpty(fromDate)) {
      filename += (fromDate! + delimiter);
    }

    if (isNotEmpty(toDate)) {
      filename += (toDate! + delimiter);
    }

    if (isNotEmpty(currentDate)) {
      // #2022.08.09@17.27.17
      filename = filename.substring(0, filename.length - 1);
      filename += (currentDate! + delimiter);
    }

    printInfo("###### FILENAME: $filename");
    return filename.substring(0, filename.length - 1) + expType!;
  }
}
