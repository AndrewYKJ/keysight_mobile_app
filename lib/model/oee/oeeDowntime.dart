import 'package:keysight_pma/model/response_status.dart';

class DownTimeMonitoringDTO {
  ResponseStatusDTO? status;
  //List<DownTimeMonitoringDataDTO>? data;
  Map<String, List<DownTimeMonitoringDataDTO>>? data;
  int? errorCode;
  String? errorMessage;

  DownTimeMonitoringDTO(
      {this.status, this.data, this.errorCode, this.errorMessage});
  factory DownTimeMonitoringDTO.fromJson(Map<String, dynamic> json) =>
      DownTimeMonitoringDTO(
        status: ResponseStatusDTO.fromJson(json["status"]),
        errorCode: json['errorCode'],
        errorMessage: json['errorMessage'],
        data: Map.from(json["data"]).map((k, v) =>
            MapEntry<String, List<DownTimeMonitoringDataDTO>>(
                k,
                List<DownTimeMonitoringDataDTO>.from(
                    v.map((x) => DownTimeMonitoringDataDTO.fromJson(x))))),
      );
  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['data'] = this.data;
    data['errorCode'] = this.errorCode;
    data['errorMessage'] = this.errorMessage;
    return data;
  }
}

class DownTimeMonitoringDTO2 {
  ResponseStatusDTO? status;
  //List<DownTimeMonitoringDataDTO>? data;
  Map<String, DownTimeMonitoringDataDTO>? data;
  int? errorCode;
  String? errorMessage;

  DownTimeMonitoringDTO2(
      {this.status, this.data, this.errorCode, this.errorMessage});

  factory DownTimeMonitoringDTO2.fromJson(Map<String, dynamic> json) =>
      DownTimeMonitoringDTO2(
        status: ResponseStatusDTO.fromJson(json["status"]),
        errorCode: json['errorCode'],
        errorMessage: json['errorMessage'],
        data: Map.from(json["data"]).map((k, v) =>
            MapEntry<String, DownTimeMonitoringDataDTO>(
                k, DownTimeMonitoringDataDTO.fromJson(v))),
      );

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['data'] = this.data;
    data['errorCode'] = this.errorCode;
    data['errorMessage'] = this.errorMessage;
    return data;
  }
}

class DownTimeMonitoringDataDTO {
  DownTimeMonitoringDataDTO({
    this.scheduledNonUtilizationTime,
    this.scheduledUtilizationTime,
    this.statusTime,
    this.status,
    this.unscheduledUtilizationTime,
    this.availableTime,
    this.plannedDownTime,
  });

  double? scheduledNonUtilizationTime;
  double? scheduledUtilizationTime;
  double? statusTime;
  String? status;
  double? unscheduledUtilizationTime;
  double? availableTime;
  double? plannedDownTime;

  DownTimeMonitoringDataDTO.fromJson(Map<String, dynamic> json) {
    scheduledNonUtilizationTime = json["scheduledNonUtilizationTime"];
    scheduledUtilizationTime = json["scheduledUtilizationTime"];
    statusTime = json["statusTime"];
    status = json["status"];
    unscheduledUtilizationTime = json["unscheduledUtilizationTime"];
    availableTime = json["availableTime"];
    plannedDownTime = json["plannedDownTime"];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['scheduledNonUtilizationTime'] = this.scheduledNonUtilizationTime;
    data['scheduledUtilizationTime'] = this.scheduledUtilizationTime;
    data['statusTime'] = this.statusTime;
    data['unscheduledUtilizationTime'] = this.unscheduledUtilizationTime;
    data['availableTime'] = this.availableTime;
    data['plannedDownTime'] = this.plannedDownTime;
    data['status'] = this.status;

    return data;
  }
}
