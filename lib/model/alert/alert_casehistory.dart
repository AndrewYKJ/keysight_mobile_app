// To parse this JSON data, do
//
//     final AlertCaseHistoryDTO = AlertCaseHistoryDTOFromJson(jsonString);

import 'dart:convert';

import 'package:keysight_pma/model/alert/alert_detail.dart';
import 'package:keysight_pma/model/response_status.dart';

class AlertCaseHistoryDTO {
  AlertCaseHistoryDTO(
      {this.status, this.data, this.errorCode, this.errorMessage});

  ResponseStatusDTO? status;
  List<AlertCaseHistoryDataDTO>? data;
  int? errorCode;
  String? errorMessage;

  AlertCaseHistoryDTO.fromJson(Map<String, dynamic> json) {
    errorCode = json['errorCode'];
    errorMessage = json['errorMessage'];
    status = ResponseStatusDTO.fromJson(json['status']);
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data!.add(AlertCaseHistoryDataDTO.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['data'] = this.data;
    data['errorCode'] = this.errorCode;
    data['errorMessage'] = this.errorMessage;
    return data;
  }
}

class AlertCaseHistoryDataDTO {
  AlertCaseHistoryDataDTO({
    this.alertId,
    this.companyId,
    this.siteId,
    this.event,
    this.companyName,
    this.siteName,
    this.equipmentId,
    this.equipmentName,
    this.moduleId,
    this.timestamp,
    this.sender,
    this.status,
    this.severity,
    this.measuredValue,
    this.projectId,
    this.fixtureId,
    this.testName,
    this.dateTimestamp,
    this.alertScoring,
    this.alertSeverity,
    this.alertIdName,
    this.rowIdentifier,
    this.subject,
    this.description,
    this.assignedTo,
    this.assignedToName,
    this.workFlow,
    this.modifiedBy,
    this.modifiedTimestamp,
    this.createdTimestamp,
    this.createdBy,
    this.histories,
    this.priority,
    this.alertRowKey,
    this.caseId,
    this.startDate,
    this.endDate,
    this.createdByName,
    this.modifiedByName,
  });

  String? alertId;
  String? companyId;
  String? siteId;
  String? event;
  String? companyName;
  String? siteName;
  String? equipmentId;
  String? equipmentName;
  String? moduleId;
  String? timestamp;
  String? sender;
  String? status;
  String? severity;
  String? measuredValue;
  String? projectId;
  String? fixtureId;
  String? testName;
  String? dateTimestamp;
  String? alertScoring;
  String? alertSeverity;
  String? alertIdName;
  String? rowIdentifier;
  String? subject;
  String? description;
  String? assignedTo;
  String? assignedToName;
  String? workFlow;
  String? modifiedBy;
  String? modifiedTimestamp;
  String? createdTimestamp;
  String? createdBy;
  List<AlertDetailHistoriesDTO>? histories;
  String? priority;
  String? alertRowKey;
  String? caseId;
  String? startDate;
  String? endDate;
  String? createdByName;
  String? modifiedByName;

  AlertCaseHistoryDataDTO.fromJson(Map<String, dynamic> json) {
    alertId = json["alertId"];
    companyId = json["companyId"];
    siteId = json["siteId"];
    event = json["event"];
    companyName = json["companyName"];
    siteName = json["siteName"];
    equipmentId = json["equipmentId"];
    equipmentName = json["equipmentName"];
    moduleId = json["moduleId"];
    timestamp = json["timestamp"];
    sender = json["sender"];
    status = json["status"];
    severity = json["severity"];
    measuredValue = json["measuredValue"];
    projectId = json["projectId"];
    fixtureId = json["fixtureId"];
    testName = json["testName"];
    dateTimestamp = json["dateTimestamp"];
    alertScoring = json["alertScoring"];
    alertSeverity = json["alertSeverity"];
    alertIdName = json["alertIdName"];
    rowIdentifier = json["rowIdentifier"];
    subject = json["subject"];
    description = json["description"];
    assignedTo = json["assignedTo"];
    assignedToName = json["assignedToName"];
    workFlow = json["workFlow"];
    modifiedBy = json["modifiedBy"];
    modifiedTimestamp = json["modifiedTimestamp"];
    createdTimestamp = json["createdTimestamp"];
    createdBy = json["createdBy"];
    priority = json["priority"];
    alertRowKey = json["alertRowKey"];
    caseId = json["caseId"];
    startDate = json["startDate"];
    endDate = json["endDate"];
    createdByName = json["createdByName"];
    modifiedByName = json["modifiedByName"];
    if (json['histories'] != null) {
      histories = [];
      json['histories'].forEach((v) {
        histories!.add(AlertDetailHistoriesDTO.fromJson(v));
      });
    }
    ;
  }

  Map<String, dynamic> toJson() => {
        "alertId": alertId,
        "companyId": companyId,
        "siteId": siteId,
        "event": event,
        "companyName": companyName,
        "siteName": siteName,
        "equipmentId": equipmentId,
        "equipmentName": equipmentName,
        "moduleId": moduleId,
        "timestamp": timestamp,
        "sender": sender,
        "status": status,
        "severity": severity,
        "measuredValue": measuredValue,
        "projectId": projectId,
        "fixtureId": fixtureId,
        "testName": testName,
        "dateTimestamp": dateTimestamp,
        "alertScoring": alertScoring,
        "alertSeverity": alertSeverity,
        "alertIdName": alertIdName,
        "rowIdentifier": rowIdentifier,
        "subject": subject,
        "description": description,
        "assignedTo": assignedTo,
        "assignedToName": assignedToName,
        "workFlow": workFlow,
        "modifiedBy": modifiedBy,
        "modifiedTimestamp": modifiedTimestamp,
        "createdTimestamp": createdTimestamp,
        "createdBy": createdBy,
        "histories": histories,
        // List<AlertDetailHistoriesDTO>.from(
        //     histories!.map((x) => x.toJson())),
        "priority": priority,
        "alertRowKey": alertRowKey,
        "caseId": caseId,
        "startDate": startDate,
        "endDate": endDate,
        "createdByName": createdByName,
        "modifiedByName": modifiedByName,
      };
}

class PatRecommendDTO {
  PatRecommendDTO({this.status, this.data, this.errorCode, this.errorMessage});

  ResponseStatusDTO? status;
  List<PatRecommendDataDTO>? data;
  int? errorCode;
  String? errorMessage;

  factory PatRecommendDTO.fromJson(Map<String, dynamic> json) =>
      PatRecommendDTO(
        status: ResponseStatusDTO.fromJson(json["status"]),
        errorCode: json['errorCode'],
        errorMessage: json['errorMessage'],
        data: List<PatRecommendDataDTO>.from(
            json["data"]!.map((x) => PatRecommendDataDTO.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status!.toJson(),
        "data": List<PatRecommendDataDTO>.from(data!.map((x) => x.toJson())),
        "errorMessage": this.errorMessage,
        "errorCode": this.errorCode
      };
}

class PatRecommendDataDTO {
  PatRecommendDataDTO({
    this.companyId,
    this.siteId,
    this.projectId,
    this.testName,
    this.cpk,
    this.lowerLimit,
    this.upperLimit,
    this.paul,
    this.pall,
    this.testType,
    this.startTimestampRecommend,
    this.endTimestampRecommend,
    this.timestamp,
    this.fixtureId,
    this.nominal,
    this.meanMeasured,
  });

  String? companyId;
  String? siteId;
  String? projectId;
  String? testName;
  String? cpk;
  String? lowerLimit;
  String? upperLimit;
  String? paul;
  String? pall;
  String? testType;
  String? startTimestampRecommend;
  String? endTimestampRecommend;
  String? timestamp;
  String? fixtureId;
  String? nominal;
  String? meanMeasured;

  factory PatRecommendDataDTO.fromJson(Map<String, dynamic> json) =>
      PatRecommendDataDTO(
        companyId: json["companyId"],
        siteId: json["siteId"],
        projectId: json["projectId"],
        testName: json["testName"],
        cpk: json["cpk"],
        lowerLimit: json["lowerLimit"],
        upperLimit: json["upperLimit"],
        paul: json["paul"],
        pall: json["pall"],
        testType: json["testType"],
        startTimestampRecommend: json["startTimestampRecommend"],
        endTimestampRecommend: json["endTimestampRecommend"],
        timestamp: json["timestamp"],
        fixtureId: json["fixtureId"],
        nominal: json["nominal"],
        meanMeasured: json["meanMeasured"],
      );

  Map<String, dynamic> toJson() => {
        "companyId": companyId,
        "siteId": siteId,
        "projectId": projectId,
        "testName": testName,
        "cpk": cpk,
        "lowerLimit": lowerLimit,
        "upperLimit": upperLimit,
        "paul": paul,
        "pall": pall,
        "testType": testType,
        "startTimestampRecommend": startTimestampRecommend,
        "endTimestampRecommend": endTimestampRecommend,
        "timestamp": timestamp,
        "fixtureId": fixtureId,
        "nominal": nominal,
        "meanMeasured": meanMeasured,
      };
}

class AlertOpenCaseDTO {
  AlertOpenCaseDTO({this.status, this.data, this.errorCode, this.errorMessage});

  ResponseStatusDTO? status;
  AlertOpenCaseDataDTO? data;
  int? errorCode;
  String? errorMessage;

  AlertOpenCaseDTO.fromJson(Map<String, dynamic> json) {
    errorCode = json['errorCode'];
    errorMessage = json['errorMessage'];
    status = ResponseStatusDTO.fromJson(json['status']);
    data = AlertOpenCaseDataDTO.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['data'] = this.data;
    data['errorCode'] = this.errorCode;
    data['errorMessage'] = this.errorMessage;
    return data;
  }
}

class AlertOpenCaseDataDTO {
  AlertOpenCaseDataDTO({
    this.alertId,
    this.companyId,
    this.siteId,
    this.event,
    this.companyName,
    this.siteName,
    this.equipmentId,
    this.equipmentName,
    this.moduleId,
    this.timestamp,
    this.sender,
    this.status,
    this.severity,
    this.measuredValue,
    this.projectId,
    this.fixtureId,
    this.testName,
    this.dateTimestamp,
    this.alertScoring,
    this.alertSeverity,
    this.alertIdName,
    this.rowIdentifier,
    this.subject,
    this.description,
    this.assignedTo,
    this.assignedToName,
    this.workFlow,
    this.modifiedBy,
    this.modifiedTimestamp,
    this.createdTimestamp,
    this.createdBy,
    this.histories,
    this.priority,
    this.alertRowKey,
    this.caseId,
    this.startDate,
    this.endDate,
    this.createdByName,
    this.modifiedByName,
  });

  String? alertId;
  String? companyId;
  String? siteId;
  String? event;
  String? companyName;
  String? siteName;
  String? equipmentId;
  String? equipmentName;
  String? moduleId;
  String? timestamp;
  String? sender;
  String? status;
  String? severity;
  String? measuredValue;
  String? projectId;
  String? fixtureId;
  String? testName;
  String? dateTimestamp;
  String? alertScoring;
  String? alertSeverity;
  String? alertIdName;
  String? rowIdentifier;
  String? subject;
  String? description;
  String? assignedTo;
  String? assignedToName;
  String? workFlow;
  String? modifiedBy;
  String? modifiedTimestamp;
  String? createdTimestamp;
  String? createdBy;
  List<AlertDetailHistoriesDTO>? histories;
  String? priority;
  String? alertRowKey;
  String? caseId;
  String? startDate;
  String? endDate;
  String? createdByName;
  String? modifiedByName;

  AlertOpenCaseDataDTO.fromJson(Map<String, dynamic> json) {
    alertId = json["alertId"];
    companyId = json["companyId"];
    siteId = json["siteId"];
    event = json["event"];
    companyName = json["companyName"];
    siteName = json["siteName"];
    equipmentId = json["equipmentId"];
    equipmentName = json["equipmentName"];
    moduleId = json["moduleId"];
    timestamp = json["timestamp"];
    sender = json["sender"];
    status = json["status"];
    severity = json["severity"];
    measuredValue = json["measuredValue"];
    projectId = json["projectId"];
    fixtureId = json["fixtureId"];
    testName = json["testName"];
    dateTimestamp = json["dateTimestamp"];
    alertScoring = json["alertScoring"];
    alertSeverity = json["alertSeverity"];
    alertIdName = json["alertIdName"];
    rowIdentifier = json["rowIdentifier"];
    subject = json["subject"];
    description = json["description"];
    assignedTo = json["assignedTo"];
    assignedToName = json["assignedToName"];
    workFlow = json["workFlow"];
    modifiedBy = json["modifiedBy"];
    modifiedTimestamp = json["modifiedTimestamp"];
    createdTimestamp = json["createdTimestamp"];
    createdBy = json["createdBy"];
    priority = json["priority"];
    alertRowKey = json["alertRowKey"];
    caseId = json["caseId"];
    startDate = json["startDate"];
    endDate = json["endDate"];
    createdByName = json["createdByName"];
    modifiedByName = json["modifiedByName"];
    if (json['histories'] != null) {
      histories = [];
      json['histories'].forEach((v) {
        histories!.add(AlertDetailHistoriesDTO.fromJson(v));
      });
    }
    ;
  }

  Map<String, dynamic> toJson() => {
        "alertId": alertId,
        "companyId": companyId,
        "siteId": siteId,
        "event": event,
        "companyName": companyName,
        "siteName": siteName,
        "equipmentId": equipmentId,
        "equipmentName": equipmentName,
        "moduleId": moduleId,
        "timestamp": timestamp,
        "sender": sender,
        "status": status,
        "severity": severity,
        "measuredValue": measuredValue,
        "projectId": projectId,
        "fixtureId": fixtureId,
        "testName": testName,
        "dateTimestamp": dateTimestamp,
        "alertScoring": alertScoring,
        "alertSeverity": alertSeverity,
        "alertIdName": alertIdName,
        "rowIdentifier": rowIdentifier,
        "subject": subject,
        "description": description,
        "assignedTo": assignedTo,
        "assignedToName": assignedToName,
        "workFlow": workFlow,
        "modifiedBy": modifiedBy,
        "modifiedTimestamp": modifiedTimestamp,
        "createdTimestamp": createdTimestamp,
        "createdBy": createdBy,
        "histories": histories,
        // List<AlertDetailHistoriesDTO>.from(
        //     histories!.map((x) => x.toJson())),
        "priority": priority,
        "alertRowKey": alertRowKey,
        "caseId": caseId,
        "startDate": startDate,
        "endDate": endDate,
        "createdByName": createdByName,
        "modifiedByName": modifiedByName,
      };
}

//TestResultChangeLimitDTO