import 'package:keysight_pma/model/response_status.dart';

class AlertFixtureMaintenanceDTO {
  ResponseStatusDTO? status;
  List<AlertFixtureMaintenanceDataDTO>? data;
  int? errorCode;
  String? errorMessage;

  AlertFixtureMaintenanceDTO(
      {this.status, this.data, this.errorCode, this.errorMessage});

  AlertFixtureMaintenanceDTO.fromJson(Map<String, dynamic> json) {
    status = ResponseStatusDTO.fromJson(json['status']);
    errorCode = json['errorCode'];
    errorMessage = json['errorMessage'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data!.add(AlertFixtureMaintenanceDataDTO.fromJson(v));
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

class AlertFixtureMaintenanceDataDTO {
  String? alertId;
  String? alertRowKey;
  String? anomaly;
  String? anomalyType;
  String? caseDescription;
  String? caseId;
  String? caseRowKey;
  String? companyId;
  String? endDate;
  String? equipmentId;
  String? fixtureId;
  String? lowerDate;
  String? lower_bound;
  String? pinChange;
  String? projectId;
  String? siteId;
  String? startDate;
  String? testName;
  String? testType;
  String? timestamp;
  String? upperDate;
  String? upper_bound;
  String? zscore;

  AlertFixtureMaintenanceDataDTO(
      {this.alertId,
      this.alertRowKey,
      this.anomaly,
      this.anomalyType,
      this.caseDescription,
      this.caseId,
      this.caseRowKey,
      this.companyId,
      this.endDate,
      this.equipmentId,
      this.fixtureId,
      this.lowerDate,
      this.lower_bound,
      this.pinChange,
      this.projectId,
      this.siteId,
      this.startDate,
      this.testName,
      this.testType,
      this.timestamp,
      this.upperDate,
      this.upper_bound,
      this.zscore});

  AlertFixtureMaintenanceDataDTO.fromJson(Map<String, dynamic> json) {
    alertId = json['alertId'];
    alertRowKey = json['alertRowKey'];
    anomaly = json['anomaly'];
    anomalyType = json['anomalyType'];
    caseDescription = json['caseDescription'];
    caseId = json['caseId'];
    caseRowKey = json['caseRowKey'];
    companyId = json['companyId'];
    endDate = json['endDate'];
    equipmentId = json['equipmentId'];
    fixtureId = json['fixtureId'];
    lowerDate = json['lowerDate'];
    lower_bound = json['lower_bound'];
    pinChange = json['pinChange'];
    projectId = json['projectId'];
    siteId = json['siteId'];
    startDate = json['startDate'];
    testName = json['testName'];
    testType = json['testType'];
    timestamp = json['timestamp'];
    upperDate = json['upperDate'];
    upper_bound = json['upper_bound'];
    zscore = json['zscore'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['alertId'] = this.alertId;
    data['alertRowKey'] = this.alertRowKey;
    data['anomaly'] = this.anomaly;
    data['anomalyType'] = this.anomalyType;
    data['caseDescription'] = this.caseDescription;
    data['caseId'] = this.caseId;
    data['caseRowKey'] = this.caseRowKey;
    data['companyId'] = this.companyId;
    data['endDate'] = this.endDate;
    data['equipmentId'] = this.equipmentId;
    data['fixtureId'] = this.fixtureId;
    data['lowerDate'] = this.lowerDate;
    data['lower_bound'] = this.lower_bound;
    data['pinChange'] = this.pinChange;
    data['projectId'] = this.projectId;
    data['siteId'] = this.siteId;
    data['startDate'] = this.startDate;
    data['testName'] = this.testName;
    data['testType'] = this.testType;
    data['timestamp'] = this.timestamp;
    data['upperDate'] = this.upperDate;
    data['upper_bound'] = this.upper_bound;
    data['zscore'] = this.zscore;
    return data;
  }
}
