import 'package:keysight_pma/model/response_status.dart';

class WorstTestByProjectDTO {
  ResponseStatusDTO? status;
  List<WorstTestByProjectDataDTO>? data;
  int? errorCode;
  String? errorMessage;

  WorstTestByProjectDTO(
      {this.status, this.data, this.errorCode, this.errorMessage});

  WorstTestByProjectDTO.fromJson(Map<String, dynamic> json) {
    status = ResponseStatusDTO.fromJson(json['status']);
    errorCode = json['errorCode'];
    errorMessage = json['errorMessage'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data!.add(WorstTestByProjectDataDTO.fromJson(v));
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

class WorstTestByProjectDataDTO {
  String? siteId;
  String? equipmentId;
  String? projectId;
  String? timestamp;
  String? testName;
  String? testType;
  String? companyId;
  String? projectIdAndTestName;
  String? measClass;
  String? measType;
  int? failedCount;

  WorstTestByProjectDataDTO(
      {this.siteId,
      this.equipmentId,
      this.projectId,
      this.timestamp,
      this.testName,
      this.testType,
      this.companyId,
      this.projectIdAndTestName,
      this.measClass,
      this.measType,
      this.failedCount});

  WorstTestByProjectDataDTO.fromJson(Map<String, dynamic> json) {
    siteId = json['siteId'];
    equipmentId = json['equipmentId'];
    projectId = json['projectId'];
    timestamp = json['timestamp'];
    testName = json['testName'];
    testType = json['testType'];
    companyId = json['companyId'];
    projectIdAndTestName = json['projectIdAndTestName'];
    measClass = json['measClass'];
    measType = json['measType'];
    failedCount = json['failedCount'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['siteId'] = this.siteId;
    data['equipmentId'] = this.equipmentId;
    data['projectId'] = this.projectId;
    data['timestamp'] = this.timestamp;
    data['testName'] = this.testName;
    data['testType'] = this.testType;
    data['companyId'] = this.companyId;
    data['projectIdAndTestName'] = this.projectIdAndTestName;
    data['measClass'] = this.measClass;
    data['measType'] = this.measType;
    data['failedCount'] = this.failedCount;
    return data;
  }
}
