import 'package:keysight_pma/model/response_status.dart';

class AlertReviewDTO {
  ResponseStatusDTO? status;
  AlertReviewDataDTO? data;
  int? errorCode;
  String? errorMessage;

  AlertReviewDTO({this.status, this.data, this.errorCode, this.errorMessage});

  AlertReviewDTO.fromJson(Map<String, dynamic> json) {
    status = ResponseStatusDTO.fromJson(json['status']);
    data = AlertReviewDataDTO.fromJson(json['data']);
    errorCode = json['errorCode'];
    errorMessage = json['errorMessage'];
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

class AlertReviewDataDTO {
  List<AlertAccuracyDataDTO>? alertAccuracy;
  List<AlertListDataDTO>? alertList;
  List<AlertReviewStatisticsDataDTO>? alertStatistics;

  AlertReviewDataDTO(
      {this.alertAccuracy, this.alertList, this.alertStatistics});

  AlertReviewDataDTO.fromJson(Map<String, dynamic> json) {
    if (json['alertAccuracy'] != null) {
      alertAccuracy = [];
      json['alertAccuracy'].forEach((v) {
        alertAccuracy!.add(AlertAccuracyDataDTO.fromJson(v));
      });
    }

    if (json['alertList'] != null) {
      alertList = [];
      json['alertList'].forEach((v) {
        alertList!.add(AlertListDataDTO.fromJson(v));
      });
    }

    if (json['alertStatistics'] != null) {
      alertStatistics = [];
      json['alertStatistics'].forEach((v) {
        alertStatistics!.add(AlertReviewStatisticsDataDTO.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['alertAccuracy'] = this.alertAccuracy;
    data['alertList'] = this.alertList;
    data['alertStatistics'] = this.alertStatistics;
    return data;
  }
}

class AlertAccuracyDataDTO {
  String? alertType;
  num? alertCount;
  String? alertSeverity;
  String? status;

  AlertAccuracyDataDTO(
      {this.alertType, this.alertCount, this.alertSeverity, this.status});

  AlertAccuracyDataDTO.fromJson(Map<String, dynamic> json) {
    alertType = json['alertType'];
    alertCount = json['alertCount'];
    alertSeverity = json['alertSeverity'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['alertType'] = this.alertType;
    data['alertCount'] = this.alertCount;
    data['alertSeverity'] = this.alertSeverity;
    data['status'] = this.status;
    return data;
  }
}

class AlertListDataDTO {
  String? alertId;
  String? alertIdName;
  String? alertIndex;
  String? alertRowKey;
  String? alertScoring;
  String? alertSeverity;
  String? cardId;
  String? caseId;
  String? caseRowKey;
  String? caseStatus;
  String? category;
  String? certainty;
  String? code;
  String? companyId;
  String? companyName;
  String? dateTimestamp;
  num? dateTimestampLog;
  String? endDate;
  String? equipmentId;
  String? equipmentName;
  String? event;
  String? fixtureId;
  String? measuredValue;
  String? message;
  String? moduleId;
  String? msgType;
  String? partId;
  String? probability;
  String? projectId;
  String? scope;
  String? sender;
  String? severity;
  String? siteId;
  String? siteName;
  String? startDate;
  String? status;
  String? testName;
  String? timeToFailure;
  String? timestamp;
  String? urgency;
  String? url;

  AlertListDataDTO(
      {this.alertId,
      this.alertIdName,
      this.alertIndex,
      this.alertRowKey,
      this.alertScoring,
      this.alertSeverity,
      this.cardId,
      this.caseId,
      this.caseRowKey,
      this.caseStatus,
      this.category,
      this.certainty,
      this.code,
      this.companyId,
      this.companyName,
      this.dateTimestamp,
      this.dateTimestampLog,
      this.endDate,
      this.equipmentId,
      this.equipmentName,
      this.event,
      this.fixtureId,
      this.measuredValue,
      this.message,
      this.moduleId,
      this.msgType,
      this.partId,
      this.probability,
      this.projectId,
      this.scope,
      this.sender,
      this.severity,
      this.siteId,
      this.siteName,
      this.startDate,
      this.status,
      this.testName,
      this.timeToFailure,
      this.timestamp,
      this.urgency,
      this.url});

  AlertListDataDTO.fromJson(Map<String, dynamic> json) {
    alertId = json['alertId'];
    alertIdName = json['alertIdName'];
    alertIndex = json['alertIndex'];
    alertRowKey = json['alertRowKey'];
    alertScoring = json['alertScoring'];
    alertSeverity = json['alertSeverity'];
    cardId = json['cardId'];
    caseId = json['caseId'];
    caseRowKey = json['caseRowKey'];
    caseStatus = json['caseStatus'];
    category = json['category'];
    certainty = json['certainty'];
    code = json['code'];
    companyId = json['companyId'];
    companyName = json['companyName'];
    dateTimestamp = json['dateTimestamp'];
    dateTimestampLog = json['dateTimestampLog'];
    endDate = json['endDate'];
    equipmentId = json['equipmentId'];
    equipmentName = json['equipmentName'];
    event = json['event'];
    fixtureId = json['fixtureId'];
    measuredValue = json['measuredValue'];
    message = json['message'];
    moduleId = json['moduleId'];
    msgType = json['msgType'];
    partId = json['partId'];
    probability = json['probability'];
    projectId = json['projectId'];
    scope = json['scope'];
    sender = json['sender'];
    severity = json['severity'];
    siteId = json['siteId'];
    siteName = json['siteName'];
    startDate = json['startDate'];
    status = json['status'];
    testName = json['testName'];
    timeToFailure = json['timeToFailure'];
    timestamp = json['timestamp'];
    urgency = json['urgency'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['alertId'] = this.alertId;
    data['alertIdName'] = this.alertIdName;
    data['alertIndex'] = this.alertIndex;
    data['alertRowKey'] = this.alertRowKey;
    data['alertScoring'] = this.alertScoring;
    data['alertSeverity'] = this.alertSeverity;
    data['cardId'] = this.cardId;
    data['caseId'] = this.caseId;
    data['caseRowKey'] = this.caseRowKey;
    data['caseStatus'] = this.caseStatus;
    data['category'] = this.category;
    data['certainty'] = this.certainty;
    data['code'] = this.code;
    data['companyId'] = this.companyId;
    data['companyName'] = this.companyName;
    data['dateTimestamp'] = this.dateTimestamp;
    data['dateTimestampLog'] = this.dateTimestampLog;
    data['endDate'] = this.endDate;
    data['equipmentId'] = this.equipmentId;
    data['equipmentName'] = this.equipmentName;
    data['event'] = this.event;
    data['fixtureId'] = this.fixtureId;
    data['measuredValue'] = this.measuredValue;
    data['message'] = this.message;
    data['moduleId'] = this.moduleId;
    data['msgType'] = this.msgType;
    data['partId'] = this.partId;
    data['probability'] = this.probability;
    data['projectId'] = this.projectId;
    data['scope'] = this.scope;
    data['sender'] = this.sender;
    data['severity'] = this.severity;
    data['siteId'] = this.siteId;
    data['siteName'] = this.siteName;
    data['startDate'] = this.startDate;
    data['status'] = this.status;
    data['testName'] = this.testName;
    data['timeToFailure'] = this.timeToFailure;
    data['timestamp'] = this.timestamp;
    data['urgency'] = this.urgency;
    data['url'] = this.url;
    return data;
  }
}

class AlertReviewStatisticsDataDTO {
  num? alertCount;
  String? alertSeverity;
  String? alertType;

  AlertReviewStatisticsDataDTO(
      {this.alertCount, this.alertSeverity, this.alertType});

  AlertReviewStatisticsDataDTO.fromJson(Map<String, dynamic> json) {
    alertCount = json['alertCount'];
    alertSeverity = json['alertSeverity'];
    alertType = json['alertType'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['alertCount'] = this.alertCount;
    data['alertSeverity'] = this.alertSeverity;
    data['alertType'] = this.alertType;
    return data;
  }
}
