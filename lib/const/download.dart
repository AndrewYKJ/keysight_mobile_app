import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:keysight_pma/const/constants.dart';
import 'package:keysight_pma/const/utils.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

class PdfApi {
  static Future<bool> generatePDF(
      String chartSvg, int width, int height, String filename,
      {bool isDarkTheme = true, bool isChineseLng = false}) async {
    final pdf = Document();
    ByteData? picBytes;

    if (isChineseLng) {
      DrawableRoot svgDrawableRoot =
          await svg.fromSvgString(chartSvg, chartSvg);
      Picture picture = svgDrawableRoot.toPicture();
      final mImage = await picture.toImage(width, height.round());
      picBytes = await mImage.toByteData(format: ImageByteFormat.png);
    }

    final pageTheme = PageTheme(
      pageFormat: PdfPageFormat.a4,
    );

    pdf.addPage(
      MultiPage(
        pageTheme: pageTheme,
        build: (context) => [
          isChineseLng
              ? Container(
                  height: height.toDouble(),
                  decoration: BoxDecoration(
                    color: isDarkTheme
                        ? PdfColor.fromHex('1B1C1F')
                        : PdfColor.fromHex('ffffff'),
                    image: DecorationImage(
                      fit: BoxFit.contain,
                      image: MemoryImage(
                        picBytes!.buffer.asUint8List(),
                      ),
                    ),
                  ),
                )
              : SvgImage(svg: chartSvg),
        ],
      ),
    );

    final mBytes = await pdf.save();
    await Utils.download(
        bytes: mBytes,
        width: width,
        height: height.round(),
        fileName: filename,
        downloadType: Constants.DOWNLOAD_AS_PDF);
    return true;
  }

  static Future<bool> generateSummaryPDF(
      String chartSvg,
      int width,
      int height,
      int? from,
      String? equipmentName,
      String? projectId,
      String filename) async {
    final pdf = Document();

    final pageTheme = PageTheme(
      pageFormat: PdfPageFormat.a4,
    );

    pdf.addPage(
      MultiPage(
        pageTheme: pageTheme,
        build: (context) => [
          SvgImage(svg: chartSvg),
        ],
      ),
    );

    final mBytes = await pdf.save();
    await Utils.download(
        bytes: mBytes,
        width: width,
        height: height,
        fileName: filename,
        chartFrom: from,
        equipmentName: equipmentName,
        projectName: projectId,
        downloadType: Constants.DOWNLOAD_AS_PDF);
    return true;
  }
}

class ImageApi {
  static Future<bool> generateImage(
      String chartSvg, int width, int height, String filename) async {
    DrawableRoot svgDrawableRoot = await svg.fromSvgString(chartSvg, chartSvg);

    Picture picture = svgDrawableRoot.toPicture();

    final mImage = await picture.toImage(width, height);
    ByteData? mBytes = await mImage.toByteData(format: ImageByteFormat.png);

    return await Utils.download(
        bytes: mBytes!.buffer.asUint8List(),
        width: width,
        height: height,
        fileName: filename,
        downloadType: Constants.DOWNLOAD_AS_IMAGE);
    //}
  }

  static Future<bool> generateSummaryImage(
      String chartSvg,
      int width,
      int height,
      int? from,
      String? equipmentName,
      String? projectId,
      String filename) async {
    DrawableRoot svgDrawableRoot = await svg.fromSvgString(chartSvg, chartSvg);

    Picture picture = svgDrawableRoot.toPicture();

    final mImage = await picture.toImage(width, height);
    ByteData? mBytes = await mImage.toByteData(format: ImageByteFormat.png);

    await Utils.download(
        bytes: mBytes!.buffer.asUint8List(),
        width: width,
        height: height,
        fileName: filename,
        chartFrom: from,
        equipmentName: equipmentName,
        projectName: projectId,
        downloadType: Constants.DOWNLOAD_AS_IMAGE);
    return true;
  }
}

class CSVApi {
  static Future<bool> generateCSV(
      List<dynamic> objectList, String filename) async {
    List<List<dynamic>> list = [];
    List<String> keys = [];

    int initial = 0;

    // ...

    objectList.forEach((element) {
      List<dynamic> row = List.empty(growable: true);
      List value = [];
      var test = json.encode(element);

      Map<String, dynamic> res = jsonDecode(test);

      if (initial == 0) {
        // res.forEach((key, value) {
        //   print("33333333333");
        //   if (keys.length == 0) {
        //     keys.add(key);
        //   } else {
        //     keys.forEach((element) {element != key}{})
        //   }
        // });

        for (var colour in res.keys) {
          res[colour] != null ? keys.add(colour) : null;
        }
        list.add(keys);
        initial = 1;
      }

      keys.forEach((key) {
        if (res[key] != null)
          value.add(res[key].toString());
        else {
          value.add('');
        }
      });

      row = (value);
      //  Utils.printInfo(value);
      list.add((row));
    });

    String csv = const ListToCsvConverter().convert(list);
    await Utils.download(
        downloadType: Constants.DOWNLOAD_AS_CSV, csv: csv, fileName: filename);
    return true;
  }

  static Future<bool> generateCaseHistoryCSV(List<dynamic> objectList1,
      List<dynamic> objectList2, String filename) async {
    List<List<dynamic>> list = [];
    List<String> keys = [];

    int initial = 0;

    // ...

    objectList1.forEach((element) {
      List<dynamic> row = List.empty(growable: true);
      List value = [];
      var test = json.encode(element);

      Map<String, dynamic> res = jsonDecode(test);

      if (initial == 0) {
        // res.forEach((key, value) {
        //   print("33333333333");
        //   if (keys.length == 0) {
        //     keys.add(key);
        //   } else {
        //     keys.forEach((element) {element != key}{})
        //   }
        // });

        for (var colour in res.keys) {
          res[colour] != null ? keys.add(colour) : null;
        }
        list.add(keys);
        initial = 1;
      }

      keys.forEach((key) {
        if (res[key] != null)
          value.add(res[key].toString());
        else {
          value.add('');
        }
      });

      row = (value);
      //  Utils.printInfo(value);
      list.add((row));
    });
    List history = [];
    list.add([]);
    history.add("History");
    list.add(history);
    keys = [];

    initial = 0;
    objectList2.forEach((element) {
      List<dynamic> row = List.empty(growable: true);
      List value = [];
      var test = json.encode(element);

      Map<String, dynamic> res = jsonDecode(test);

      if (initial == 0) {
        // res.forEach((key, value) {
        //   print("33333333333");
        //   if (keys.length == 0) {
        //     keys.add(key);
        //   } else {
        //     keys.forEach((element) {element != key}{})
        //   }
        // });

        for (var colour in res.keys) {
          res[colour] != null ? keys.add(colour) : null;
        }
        list.add(keys);
        initial = 1;
      }

      keys.forEach((key) {
        if (res[key] != null)
          value.add(res[key].toString());
        else {
          value.add('');
        }
      });

      row = (value);
      //  Utils.printInfo(value);
      list.add((row));
    });
    String csv = const ListToCsvConverter().convert(list);
    await Utils.download(
        downloadType: Constants.DOWNLOAD_AS_CSV, csv: csv, fileName: filename);
    return true;
  }

  static Future<bool> generateCSVwithKey(
    List<dynamic> objectList,
    String filename,
    List objectKeys,
  ) async {
    List<List<dynamic>> list = [];

    // ...
    list.add(objectKeys);
    objectList.forEach((element) {
      List<dynamic> row = List.empty(growable: true);
      List value = [];
      var test = json.encode(element);

      Map<String, dynamic> res = jsonDecode(test);

      objectKeys.forEach((key) {
        if (res[key] != null)
          value.add(res[key].toString());
        else {
          value.add('');
        }
      });

      row = (value);
      //  Utils.printInfo(value);
      list.add((row));
    });

    String csv = const ListToCsvConverter().convert(list);
    await Utils.download(
        downloadType: Constants.DOWNLOAD_AS_CSV, csv: csv, fileName: filename);
    return true;
  }

  static Future<bool> generateSummaryCSV(
    List<dynamic> objectList,
    String filename,
    int? from,
    String? equipmentName,
    String? projectId,
  ) async {
    List<List<dynamic>> list = [];
    List<String> keys = [];

    int initial = 0;

    // ...

    objectList.forEach((element) {
      List<dynamic> row = List.empty(growable: true);
      List value = [];
      var test = json.encode(element);

      Map<String, dynamic> res = jsonDecode(test);
      if (initial == 0) {
        for (var colour in res.keys) {
          res[colour] != null ? keys.add(colour) : null;
        }
        list.add(keys);
        initial = 1;
      }

      keys.forEach((key) {
        if (res[key] != null)
          value.add(res[key].toString());
        else {
          value.add('');
        }
      });

      row = (value);
      print(value);
      list.add((row));
    });

    String csv = const ListToCsvConverter().convert(list);
    await Utils.download(
      downloadType: Constants.DOWNLOAD_AS_CSV,
      csv: csv,
      fileName: filename,
      chartFrom: from,
      equipmentName: equipmentName,
      projectName: projectId,
    );
    return true;
  }
}
