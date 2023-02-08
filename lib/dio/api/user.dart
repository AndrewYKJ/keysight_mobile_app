import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:keysight_pma/cache/appcache.dart';
import 'package:keysight_pma/dio/dio_repo.dart';
import 'package:keysight_pma/model/alert/alert.dart';
import 'package:keysight_pma/model/updateUserPrefModel.dart';
import 'package:keysight_pma/model/user.dart';

class UserApi extends DioRepo {
  UserApi(BuildContext context) {
    dioContext = context;
  }

  Future<UserDTO> getUserDetail() async {
    try {
      Response response = await mDio.get("admin/userDetails");
      AppCache.me = UserDTO.fromJson(response.data);
      return UserDTO.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

  Future<UserDTO> updateUserDetail() async {
    try {
      Response response = await mDio.get("admin/userDetails");
      AppCache.me = UserDTO.fromJson(response.data);
      return UserDTO.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

  Future<updatePreferenceSettingDTO> updatePreferenceSetting(
      {required updatePreferenceSettingDataDTO bodyData}) async {
    try {
      Response response =
          await mDio.put("admin/updateUserPreferenceSettings", data: bodyData);
      return updatePreferenceSettingDTO.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

  Future<SiteLoadProjectDTO> getSiteProject(
      String companyId, String siteId) async {
    try {
      Map<String, dynamic> params = {
        "companyId": companyId,
        "siteId": siteId,
      };
      Response response =
          await mDio.get("projects/load", queryParameters: params);
      return SiteLoadProjectDTO.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

  Future<UpdatePreferredLanguageDTO> updatePreferredLanguages(
      String languageCode) async {
    try {
      Map<String, dynamic> params = {"preferredLanguageCode": languageCode};
      Response response =
          await mDio.put("admin/updatePreferredLanguage", data: params);
      return UpdatePreferredLanguageDTO.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

  Future<PushTokenDTO> savePushToken(
      String token, String platform, String tokenType) async {
    try {
      Map<String, dynamic> params = {
        "platformType": platform,
        "tokenType": tokenType,
        "tokenValue": token
      };
      Response response =
          await mDio.post("admin/saveMobileToken", data: params);
      return PushTokenDTO.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

  Future<AlertDTO> getAlert(
      String alertId, String companyId, String siteId) async {
    try {
      Map<String, dynamic> params = {
        "alertId": alertId,
        "companyId": companyId,
        "siteId": siteId
      };
      Response response =
          await mDio.get("admin/saveMobileToken", queryParameters: params);
      return AlertDTO.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }
}
