import 'package:keysight_pma/model/response_status.dart';

class AlertCreateCaseDTO {
  ResponseStatusDTO? status;
  int? errorCode;
  String? errorMessage;
  AlertCreateCaseDataDTO? data;

  AlertCreateCaseDTO(
      {this.status, this.data, this.errorCode, this.errorMessage});

  AlertCreateCaseDTO.fromJson(Map<String, dynamic> json) {
    errorCode = json['errorCode'];
    errorMessage = json['errorMessage'];
    status = ResponseStatusDTO.fromJson(json['status']);
    data = AlertCreateCaseDataDTO.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['errorCode'] = this.errorCode;
    data['errorMessage'] = this.errorMessage;
    data['data'] = this.data;
    return data;
  }
}

class AlertCreateCaseDataDTO {
  String? actions;
  List<BulkAlertInfoDTO>? bulkAlertInfo;

  AlertCreateCaseDataDTO({this.actions, this.bulkAlertInfo});

  AlertCreateCaseDataDTO.fromJson(Map<String, dynamic> json) {
    actions = json['actions'];
    if (json['bulkAlertInfo'] != null) {
      bulkAlertInfo = [];
      json['bulkAlertInfo'].forEach((v) {
        bulkAlertInfo!.add(BulkAlertInfoDTO.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['actions'] = this.actions;
    data['bulkAlertInfo'] = this.bulkAlertInfo;
    return data;
  }
}

class BulkAlertInfoDTO {
  String? alertRowKey;
  String? statusMessage;
  String? status;
  String? alertId;
  String? alertIdName;

  BulkAlertInfoDTO(
      {this.alertRowKey,
      this.statusMessage,
      this.status,
      this.alertId,
      this.alertIdName});

  BulkAlertInfoDTO.fromJson(Map<String, dynamic> json) {
    alertRowKey = json['alertRowKey'];
    statusMessage = json['statusMessage'];
    status = json['status'];
    alertId = json['alertId'];
    alertIdName = json['alertIdName'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['alertRowKey'] = this.alertRowKey;
    data['statusMessage'] = this.statusMessage;
    data['status'] = this.status;
    data['alertId'] = this.alertId;
    data['alertIdName'] = this.alertIdName;
    return data;
  }
}
