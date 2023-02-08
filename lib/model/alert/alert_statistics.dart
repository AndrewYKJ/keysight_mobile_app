import 'package:keysight_pma/model/response_status.dart';

class AlertStatisticsDTO {
  ResponseStatusDTO? status;
  List<AlertStatisticsDataDTO>? data;
  int? errorCode;
  String? errorMessage;

  AlertStatisticsDTO(
      {this.status, this.data, this.errorCode, this.errorMessage});

  AlertStatisticsDTO.fromJson(Map<String, dynamic> json) {
    status = ResponseStatusDTO.fromJson(json['status']);
    errorCode = json['errorCode'];
    errorMessage = json['errorMessage'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data!.add(AlertStatisticsDataDTO.fromJson(v));
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

class AlertStatisticsDataDTO {
  String? event;
  String? code;
  String? companyId;
  String? companyName;
  String? siteId;
  String? siteName;
  String? equipmentId;
  String? equipmentName;
  String? moduleId;
  String? cardId;
  String? partId;
  String? timestamp;
  String? alertId;
  String? sender;
  String? status;
  String? msgType;
  String? scope;
  String? category;
  String? urgency;
  String? severity;
  String? certainty;
  String? probability;
  String? timeToFailure;
  String? caseRowKey;
  String? measuredValue;
  String? projectId;
  String? fixtureId;
  String? testName;
  String? startDate;
  String? endDate;
  num? dateTimestampLog;
  String? dateTimestamp;
  String? caseStatus;
  String? caseId;
  String? alertIndex;
  String? alertRowKey;
  String? alertScoring;
  String? alertSeverity;
  String? alertIdName;
  String? url;
  String? message;
  String? shift;
  String? projectName;

  AlertStatisticsDataDTO(
      {this.event,
      this.code,
      this.companyId,
      this.companyName,
      this.siteId,
      this.siteName,
      this.equipmentId,
      this.equipmentName,
      this.moduleId,
      this.cardId,
      this.partId,
      this.timestamp,
      this.alertId,
      this.sender,
      this.status,
      this.msgType,
      this.scope,
      this.category,
      this.urgency,
      this.severity,
      this.certainty,
      this.probability,
      this.timeToFailure,
      this.caseRowKey,
      this.measuredValue,
      this.projectId,
      this.fixtureId,
      this.testName,
      this.startDate,
      this.endDate,
      this.dateTimestampLog,
      this.dateTimestamp,
      this.caseStatus,
      this.caseId,
      this.alertIndex,
      this.alertRowKey,
      this.alertScoring,
      this.alertSeverity,
      this.alertIdName,
      this.url,
      this.message,
      this.shift,
      this.projectName});

  AlertStatisticsDataDTO.fromJson(Map<String, dynamic> json) {
    event = json['event'];
    code = json['code'];
    companyId = json['companyId'];
    companyName = json['companyName'];
    siteId = json['siteId'];
    siteName = json['siteName'];
    equipmentId = json['equipmentId'];
    equipmentName = json['equipmentName'];
    moduleId = json['moduleId'];
    cardId = json['cardId'];
    partId = json['partId'];
    timestamp = json['timestamp'];
    alertId = json['alertId'];
    sender = json['sender'];
    status = json['status'];
    msgType = json['msgType'];
    scope = json['scope'];
    category = json['category'];
    urgency = json['urgency'];
    severity = json['severity'];
    certainty = json['certainty'];
    probability = json['probability'];
    timeToFailure = json['timeToFailure'];
    caseRowKey = json['caseRowKey'];
    measuredValue = json['measuredValue'];
    projectId = json['projectId'];
    fixtureId = json['fixtureId'];
    testName = json['testName'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    dateTimestampLog = json['dateTimestampLog'];
    dateTimestamp = json['dateTimestamp'];
    caseStatus = json['caseStatus'];
    caseId = json['caseId'];
    alertIndex = json['alertIndex'];
    alertRowKey = json['alertRowKey'];
    alertScoring = json['alertScoring'];
    alertSeverity = json['alertSeverity'];
    alertIdName = json['alertIdName'];
    url = json['url'];
    message = json['message'];
    shift = json['shift'];
    projectName = json['projectName'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['event'] = this.event;
    data['code'] = this.code;
    data['companyId'] = this.companyId;
    data['companyName'] = this.companyName;
    data['siteId'] = this.siteId;
    data['siteName'] = this.siteName;
    data['equipmentId'] = this.equipmentId;
    data['equipmentName'] = this.equipmentName;
    data['moduleId'] = this.moduleId;
    data['cardId'] = this.cardId;
    data['partId'] = this.partId;
    data['timestamp'] = this.timestamp;
    data['alertId'] = this.alertId;
    data['sender'] = this.sender;
    data['status'] = this.status;
    data['msgType'] = this.msgType;
    data['scope'] = this.scope;
    data['category'] = this.category;
    data['urgency'] = this.urgency;
    data['severity'] = this.severity;
    data['certainty'] = this.certainty;
    data['probability'] = this.probability;
    data['timeToFailure'] = this.timeToFailure;
    data['caseRowKey'] = this.caseRowKey;
    data['measuredValue'] = this.measuredValue;
    data['projectId'] = this.projectId;
    data['fixtureId'] = this.fixtureId;
    data['testName'] = this.testName;
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    data['dateTimestampLog'] = this.dateTimestampLog;
    data['dateTimestamp'] = this.dateTimestamp;
    data['caseStatus'] = this.caseStatus;
    data['caseId'] = this.caseId;
    data['alertIndex'] = this.alertIndex;
    data['alertRowKey'] = this.alertRowKey;
    data['alertScoring'] = this.alertScoring;
    data['alertSeverity'] = this.alertSeverity;
    data['alertIdName'] = this.alertIdName;
    data['url'] = this.url;
    data['message'] = this.message;
    data['shift'] = this.shift;
    data['projectName'] = this.projectName;
    return data;
  }
}
