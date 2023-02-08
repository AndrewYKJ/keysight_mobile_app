import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:keysight_pma/dio/dio_repo.dart';

class ChangeLanguageApi extends DioRepo {
  var bodyData;

  ChangeLanguageApi(BuildContext context, {bodyData}) {
    dioContext = context;
    this.bodyData = bodyData;
  }

  Future<Response> call() async {
    try {
      Response response = await mDio.put("languages", data: this.bodyData);
      return response;
    } catch (e) {
      throw e;
    }
  }
}
