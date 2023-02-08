import 'dart:convert';

import 'package:keysight_pma/model/response_status.dart';
import 'package:keysight_pma/model/user.dart';

class updatePreferenceSettingDTO {
  updatePreferenceSettingDTO(
      {this.status, this.data, this.errorCode, this.errorMessage});

  ResponseStatusDTO? status;
  updatePreferenceSettingDataDTO? data;
  int? errorCode;
  String? errorMessage;

  factory updatePreferenceSettingDTO.fromJson(Map<String, dynamic> json) =>
      updatePreferenceSettingDTO(
          status: ResponseStatusDTO.fromJson(json["status"]),
          data: updatePreferenceSettingDataDTO.fromJson(json["data"]),
          errorCode: json['errorCode'],
          errorMessage: json['errorMessage']);

  Map<String, dynamic> toJson() => {
        "status": status!.toJson(),
        "data": data!.toJson(),
        "errorCode": errorCode,
        "errorMessage": errorMessage
      };
}

class updatePreferenceSettingDataDTO {
  updatePreferenceSettingDataDTO({
    this.analyticsConsent,
    this.preferredLanguage,
    this.preferredLandingPageDto,
    this.preferredDaysDto,
    this.projectVersionDTO,
  });

  bool? analyticsConsent;
  PreferredLanguage? preferredLanguage;
  PreferredLandingPageDto? preferredLandingPageDto;
  PreferredDaysDto? preferredDaysDto;
  ProjectVersionDTO? projectVersionDTO;

  factory updatePreferenceSettingDataDTO.fromJson(Map<String, dynamic> json) =>
      updatePreferenceSettingDataDTO(
        analyticsConsent: json["analyticsConsent"],
        preferredLanguage:
            PreferredLanguage.fromJson(json["preferredLanguage"]),
        preferredLandingPageDto:
            PreferredLandingPageDto.fromJson(json["preferredLandingPageDTO"]),
        preferredDaysDto: PreferredDaysDto.fromJson(json["preferredDaysDTO"]),
        projectVersionDTO:
            ProjectVersionDTO.fromJson(json["preferredProjectVersionsDTO"]),
      );

  Map<String, dynamic> toJson() => {
        "analyticsConsent": analyticsConsent,
        "preferredLanguage": preferredLanguage!.toJson(),
        "preferredLandingPageDTO": preferredLandingPageDto!.toJson(),
        "preferredDaysDTO": preferredDaysDto!.toJson(),
        "preferredProjectVersionsDTO": projectVersionDTO!.toJson(),
      };
}

class PreferredDaysDto {
  PreferredDaysDto({
    this.preferredDays,
  });

  String? preferredDays;

  factory PreferredDaysDto.fromJson(Map<String, dynamic> json) =>
      PreferredDaysDto(
        preferredDays: json["preferredDays"],
      );

  Map<String, dynamic> toJson() => {
        "preferredDays": preferredDays,
      };
}

class PreferredLandingPageDto {
  PreferredLandingPageDto({
    this.preferredLandingPage,
  });

  String? preferredLandingPage;

  factory PreferredLandingPageDto.fromJson(Map<String, dynamic> json) =>
      PreferredLandingPageDto(
        preferredLandingPage: json["preferredLandingPage"],
      );

  Map<String, dynamic> toJson() => {
        "preferredLandingPage": preferredLandingPage,
      };
}

class PreferredLanguage {
  PreferredLanguage({
    this.preferredLanguageCode,
  });

  String? preferredLanguageCode;

  factory PreferredLanguage.fromJson(Map<String, dynamic> json) =>
      PreferredLanguage(
        preferredLanguageCode: json["preferredLanguageCode"],
      );

  Map<String, dynamic> toJson() => {
        "preferredLanguageCode": preferredLanguageCode,
      };
}

class UpdateLoadProject {
  String? siteId;
  String? defaultProjectId;
  List<ProjectVersionListDataDTO>? projectVersionList;
  UpdateLoadProject(
      {this.siteId, this.defaultProjectId, this.projectVersionList});

  UpdateLoadProject.fromJson(Map<String, dynamic> json) {
    siteId = json['siteId'];
    defaultProjectId = json['defaultProjectId'];
    if (json['projectVersionList'] != null) {
      projectVersionList = [];
      json['projectVersionList'].forEach((v) {
        projectVersionList!.add(ProjectVersionListDataDTO.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['siteId'] = this.siteId;
    data['defaultProjectId'] = this.defaultProjectId;
    data['projectVersionList'] = this.projectVersionList;
    return data;
  }
}

class SiteLoadProjectDTO {
  SiteLoadProjectDTO(
      {this.status, this.data, this.errorCode, this.errorMessage});

  ResponseStatusDTO? status;
  List<SiteLoadProjectDataDTO>? data;
  int? errorCode;
  String? errorMessage;

  factory SiteLoadProjectDTO.fromJson(Map<String, dynamic> json) =>
      SiteLoadProjectDTO(
        status: ResponseStatusDTO.fromJson(json["status"]),
        data: List<SiteLoadProjectDataDTO>.from(
            json["data"].map((x) => SiteLoadProjectDataDTO.fromJson(x))),
        errorCode: json["errorCode"],
        errorMessage: json["errorMessage"],
      );

  Map<String, dynamic> toJson() => {
        "status": status!.toJson(),
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class SiteLoadProjectDataDTO {
  SiteLoadProjectDataDTO({
    this.siteId,
    this.projectId,
    this.companyId,
    this.isPanelBoard,
    this.projectNameKey,
    this.equipmentType,
    this.hasEdl,
    this.hasXvtep,
    this.isPreferred,
  });

  String? siteId;
  String? projectId;
  String? companyId;
  String? isPanelBoard;
  String? projectNameKey;
  String? equipmentType;
  String? hasEdl;
  String? hasXvtep;
  bool? isPreferred;

  factory SiteLoadProjectDataDTO.fromJson(Map<String, dynamic> json) =>
      SiteLoadProjectDataDTO(
        siteId: json["siteId"],
        projectId: json["projectId"],
        companyId: json["companyId"],
        isPanelBoard: json["isPanelBoard"],
        projectNameKey: json["projectNameKey"],
        equipmentType: json["equipmentType"],
        hasEdl: json["hasEDL"],
        hasXvtep: json["hasXVTEP"],
        isPreferred: json["isPreferred"],
      );

  Map<String, dynamic> toJson() => {
        "siteId": siteId,
        "projectId": projectId,
        "companyId": companyId,
        "isPanelBoard": isPanelBoard,
        "projectNameKey": projectNameKey,
        "equipmentType": equipmentType,
        "hasEDL": hasEdl,
        "hasXVTEP": hasXvtep,
        "isPreferred": isPreferred,
      };
}
