import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:keysight_pma/cache/appcache.dart';
import 'package:keysight_pma/dio/dio_repo.dart';
import 'package:keysight_pma/model/alertPreferencemodel.dart';
import 'package:keysight_pma/model/user.dart';

class AlertPreferenceApi extends DioRepo {
  AlertPreferenceApi(BuildContext context) {
    dioContext = context;
  }

  Future<AlertPreferenceGroupDTO> getAlertPrefGroup(
      String alertPrefGroupType) async {
    try {
      Map<String, dynamic> params = {
        "alertPrefGroupType": alertPrefGroupType,
      };

      Response response = await mDio.get("alertPref/getAlertPrefGroupList",
          queryParameters: params);
      return AlertPreferenceGroupDTO.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }
}
