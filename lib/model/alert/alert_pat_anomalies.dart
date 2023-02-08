import 'package:keysight_pma/model/response_status.dart';

class AlertPatAnomaliesDTO {
  ResponseStatusDTO? status;
  List<AlertPatAnomaliesDataDTO>? data;
  int? errorCode;
  String? errorMessage;

  AlertPatAnomaliesDTO(
      {this.status, this.data, this.errorCode, this.errorMessage});

  AlertPatAnomaliesDTO.fromJson(Map<String, dynamic> json) {
    errorCode = json['errorCode'];
    errorMessage = json['errorMessage'];
    status = ResponseStatusDTO.fromJson(json['status']);
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data!.add(AlertPatAnomaliesDataDTO.fromJson(v));
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

class AlertPatAnomaliesDataDTO {
  String? companyId;
  String? endDate;
  String? equipmentId;
  String? fixtureId;
  String? patlowerLimit;
  String? patupperLimit;
  String? pinChange;
  String? projectId;
  String? siteId;
  String? startDate;
  String? testName;
  String? testType;
  String? timestamp;

  AlertPatAnomaliesDataDTO(
      {this.companyId,
      this.endDate,
      this.equipmentId,
      this.fixtureId,
      this.patlowerLimit,
      this.patupperLimit,
      this.pinChange,
      this.projectId,
      this.siteId,
      this.startDate,
      this.testName,
      this.testType,
      this.timestamp});

  AlertPatAnomaliesDataDTO.fromJson(Map<String, dynamic> json) {
    companyId = json['companyId'];
    endDate = json['endDate'];
    equipmentId = json['equipmentId'];
    fixtureId = json['fixtureId'];
    patlowerLimit = json['patlowerLimit'];
    patupperLimit = json['patupperLimit'];
    pinChange = json['pinChange'];
    projectId = json['projectId'];
    siteId = json['siteId'];
    startDate = json['startDate'];
    testName = json['testName'];
    testType = json['testType'];
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['companyId'] = this.companyId;
    data['endDate'] = this.endDate;
    data['equipmentId'] = this.equipmentId;
    data['fixtureId'] = this.fixtureId;
    data['patlowerLimit'] = this.patlowerLimit;
    data['patupperLimit'] = this.patupperLimit;
    data['pinChange'] = this.pinChange;
    data['projectId'] = this.projectId;
    data['siteId'] = this.siteId;
    data['startDate'] = this.startDate;
    data['testName'] = this.testName;
    data['testType'] = this.testType;
    data['timestamp'] = this.timestamp;
    return data;
  }
}
