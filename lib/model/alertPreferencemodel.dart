// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

import 'package:keysight_pma/model/response_status.dart';

class AlertPreferenceGroupDTO {
  AlertPreferenceGroupDTO(
      {this.status, this.data, this.errorCode, this.errorMessage});

  ResponseStatusDTO? status;
  List<AlertPreferenceGroupDataDTO>? data;
  int? errorCode;
  String? errorMessage;

  factory AlertPreferenceGroupDTO.fromJson(Map<String, dynamic> json) =>
      AlertPreferenceGroupDTO(
        status: ResponseStatusDTO.fromJson(json["status"]),
        data: List<AlertPreferenceGroupDataDTO>.from(
            json["data"].map((x) => AlertPreferenceGroupDataDTO.fromJson(x))),
        errorCode: json["errorCode"],
        errorMessage: json["errorMessage"],
      );

  Map<String, dynamic> toJson() => {
        "status": status!.toJson(),
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
        "errorCode": errorCode,
        "errorMessage": errorMessage
      };
}

class AlertPreferenceGroupDataDTO {
  AlertPreferenceGroupDataDTO({
    this.groupId,
    this.groupName,
    this.groupDescription,
    this.groupVisibility,
    this.createdBy,
    this.createdTimestamp,
    this.updatedBy,
    this.updatedTimestamp,
    this.groupOwner,
    this.groupOwnerName,
    this.alertPrefAlertList,
    this.groupUsers,
    this.groupParameters,
    this.groupParametersDisplay,
    this.history,
    this.paramCompSite,
    this.paramCompSiteEqui,
    this.paramCompSiteEquiFixt,
    this.paramCompSiteProj,
    this.paramCompSiteShif,
  });

  int? groupId;
  String? groupName;
  String? groupDescription;
  bool? groupVisibility;
  int? createdBy;
  DateTime? createdTimestamp;
  int? updatedBy;
  String? updatedTimestamp;
  int? groupOwner;
  String? groupOwnerName;
  List<AlertPrefAlertList>? alertPrefAlertList;
  List<GroupUser>? groupUsers;
  String? groupParameters;
  List<GroupParametersDisplay>? groupParametersDisplay;
  String? history;
  String? paramCompSite;
  String? paramCompSiteEqui;
  String? paramCompSiteEquiFixt;
  String? paramCompSiteProj;
  String? paramCompSiteShif;

  factory AlertPreferenceGroupDataDTO.fromJson(Map<String, dynamic> json) =>
      AlertPreferenceGroupDataDTO(
        groupId: json["groupId"],
        groupName: json["groupName"],
        groupDescription: json["groupDescription"],
        groupVisibility: json["groupVisibility"],
        createdBy: json["createdBy"],
        createdTimestamp: DateTime.parse(json["createdTimestamp"]),
        updatedBy: json["updatedBy"],
        updatedTimestamp: json["updatedTimestamp"],
        groupOwner: json["groupOwner"],
        groupOwnerName: json["groupOwnerName"],
        alertPrefAlertList: List<AlertPrefAlertList>.from(
            json["alertPrefAlertList"]
                .map((x) => AlertPrefAlertList.fromJson(x))),
        groupUsers: List<GroupUser>.from(
            json["groupUsers"].map((x) => GroupUser.fromJson(x))),
        groupParameters: json["groupParameters"],
        groupParametersDisplay: List<GroupParametersDisplay>.from(
            json["groupParametersDisplay"]
                .map((x) => GroupParametersDisplay.fromJson(x))),
        history: json["history"],
        paramCompSite: json["paramCompSite"],
        paramCompSiteEqui: json["paramCompSiteEqui"],
        paramCompSiteEquiFixt: json["paramCompSiteEquiFixt"],
        paramCompSiteProj: json["paramCompSiteProj"],
        paramCompSiteShif: json["paramCompSiteShif"],
      );

  Map<String, dynamic> toJson() => {
        "groupId": groupId,
        "groupName": groupName,
        "groupDescription": groupDescription,
        "groupVisibility": groupVisibility,
        "createdBy": createdBy,
        "createdTimestamp": createdTimestamp,
        "updatedBy": updatedBy,
        "updatedTimestamp": updatedTimestamp,
        "groupOwner": groupOwner,
        "groupOwnerName": groupOwnerName,
        "alertPrefAlertList":
            List<dynamic>.from(alertPrefAlertList!.map((x) => x.toJson())),
        "groupUsers": List<dynamic>.from(groupUsers!.map((x) => x.toJson())),
        "groupParameters": groupParameters,
        "groupParametersDisplay":
            List<dynamic>.from(groupParametersDisplay!.map((x) => x.toJson())),
        "history": history,
        "paramCompSite": paramCompSite,
        "paramCompSiteEqui": paramCompSiteEqui,
        "paramCompSiteEquiFixt": paramCompSiteEquiFixt,
        "paramCompSiteProj": paramCompSiteProj,
        "paramCompSiteShif": paramCompSiteShif,
      };
}

class AlertPrefAlertList {
  AlertPrefAlertList({
    this.id,
    this.alertType,
    this.alertDescription,
    this.priority,
    this.groupId,
  });

  int? id;
  String? alertType;
  String? alertDescription;
  String? priority;
  int? groupId;

  factory AlertPrefAlertList.fromJson(Map<String, dynamic> json) =>
      AlertPrefAlertList(
        id: json["id"],
        alertType: json["alertType"],
        alertDescription: json["alertDescription"],
        priority: json["priority"],
        groupId: json["groupId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "alertType": alertType,
        "alertDescription": alertDescription,
        "priority": priority,
        "groupId": groupId,
      };
}

class GroupParametersDisplay {
  GroupParametersDisplay({
    this.companyId,
    this.companyName,
    this.siteId,
    this.siteName,
    this.shiftList,
    this.projectList,
    this.equipmentList,
  });

  String? companyId;
  String? companyName;
  String? siteId;
  String? siteName;
  List<ShiftList>? shiftList;
  List<ProjectList>? projectList;
  List<EquipmentList>? equipmentList;

  factory GroupParametersDisplay.fromJson(Map<String, dynamic> json) =>
      GroupParametersDisplay(
        companyId: json["companyId"],
        companyName: json["companyName"],
        siteId: json["siteId"],
        siteName: json["siteName"],
        shiftList: List<ShiftList>.from(
            json["shiftList"].map((x) => ShiftList.fromJson(x))),
        projectList: List<ProjectList>.from(
            json["projectList"].map((x) => ProjectList.fromJson(x))),
        equipmentList: List<EquipmentList>.from(
            json["equipmentList"].map((x) => EquipmentList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "companyId": companyId,
        "companyName": companyName,
        "siteId": siteId,
        "siteName": siteName,
        "shiftList": List<dynamic>.from(shiftList!.map((x) => x.toJson())),
        "projectList": List<dynamic>.from(projectList!.map((x) => x.toJson())),
        "equipmentList":
            List<dynamic>.from(equipmentList!.map((x) => x.toJson())),
      };
}

class EquipmentList {
  EquipmentList({
    this.equipmentId,
    this.equipmentName,
  });

  String? equipmentId;
  String? equipmentName;

  factory EquipmentList.fromJson(Map<String, dynamic> json) => EquipmentList(
        equipmentId: json["equipmentId"],
        equipmentName: json["equipmentName"],
      );

  Map<String, dynamic> toJson() => {
        "equipmentId": equipmentId,
        "equipmentName": equipmentName,
      };
}

class ProjectList {
  ProjectList({
    this.projectId,
    this.projectName,
  });

  String? projectId;
  String? projectName;

  factory ProjectList.fromJson(Map<String, dynamic> json) => ProjectList(
        projectId: json["projectId"],
        projectName: json["projectName"] == null ? null : json["projectName"],
      );

  Map<String, dynamic> toJson() => {
        "projectId": projectId,
        "projectName": projectName == null ? null : projectName,
      };
}

class ShiftList {
  ShiftList({
    this.shiftId,
    this.shiftName,
  });

  String? shiftId;
  String? shiftName;

  factory ShiftList.fromJson(Map<String, dynamic> json) => ShiftList(
        shiftId: json["shiftId"],
        shiftName: json["shiftName"],
      );

  Map<String, dynamic> toJson() => {
        "shiftId": shiftId,
        "shiftName": shiftName,
      };
}

class SelectedGroup {
  SelectedGroup({
    this.groupId,
    this.groupName,
    this.isSelected,
  });

  String? groupId;
  String? groupName;
  bool? isSelected;
}

class GroupUser {
  GroupUser({
    this.userName,
    this.emailId,
    this.groupId,
    this.userId,
    this.moderator,
  });

  String? userName;
  String? emailId;
  String? groupId;
  int? userId;
  bool? moderator;

  factory GroupUser.fromJson(Map<String, dynamic> json) => GroupUser(
        userName: json["userName"],
        emailId: json["emailId"],
        groupId: json["groupId"],
        userId: json["userId"],
        moderator: json["moderator"],
      );

  Map<String, dynamic> toJson() => {
        "userName": userName,
        "emailId": emailId,
        "groupId": groupId,
        "userId": userId,
        "moderator": moderator,
      };
}
