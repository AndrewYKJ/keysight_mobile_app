import 'package:keysight_pma/model/response_status.dart';

class OeePerformanceDTO {
  ResponseStatusDTO? status;
  List<OeePerformanceDataDTO>? data;
  int? errorCode;
  String? errorMessage;

  OeePerformanceDTO(
      {this.status, this.data, this.errorCode, this.errorMessage});

  OeePerformanceDTO.fromJson(Map<String, dynamic> json) {
    status = ResponseStatusDTO.fromJson(json['status']);
    errorCode = json['errorCode'];
    errorMessage = json['errorMessage'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data!.add(OeePerformanceDataDTO.fromJson(v));
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

class OeePerformanceDataDTO {
  String? date;
  double? retestUtilizationTime;
  String? companyId;
  double? performance;
  String? siteId;

  double? firstPassUtilizationTime;
  double? failUtilizationTime;
  double? idealCycleTime;
  String? equipmentId;
  String? projectId;

  OeePerformanceDataDTO({
    this.date,
    this.retestUtilizationTime,
    this.companyId,
    this.performance,
    this.siteId,
    this.firstPassUtilizationTime,
    this.failUtilizationTime,
    this.idealCycleTime,
    this.equipmentId,
    this.projectId,
  });

  OeePerformanceDataDTO.fromJson(Map<String, dynamic> json) {
    date = json["date"];
    companyId = json["companyId"];
    retestUtilizationTime = json["retestUtilizationTime"];
    performance = json["performance"];
    siteId = json["siteId"];
    firstPassUtilizationTime = json["firstPassUtilizationTime"];
    failUtilizationTime = json["failUtilizationTime"];
    equipmentId = json["equipmentId"];
    idealCycleTime = json["idealCycleTime"];
    projectId = json["projectId"];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['companyId'] = this.companyId;
    data['retestUtilizationTime'] = this.retestUtilizationTime;
    data['performance'] = this.performance;
    data['siteId'] = this.siteId;
    data['firstPassUtilizationTime'] = this.firstPassUtilizationTime;
    data['failUtilizationTime'] = this.failUtilizationTime;
    data['equipmentId'] = this.equipmentId;
    data['idealCycleTime'] = this.idealCycleTime;
    data['projectId'] = this.projectId;

    return data;
  }
}
