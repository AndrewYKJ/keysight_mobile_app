import 'package:keysight_pma/model/response_status.dart';

class AlertAssigneeDTO {
  ResponseStatusDTO? status;
  List<AlertAssigneeDataDTO>? data;
  int? errorCode;
  String? errorMessage;

  AlertAssigneeDTO({this.status, this.data, this.errorCode, this.errorMessage});

  AlertAssigneeDTO.fromJson(Map<String, dynamic> json) {
    errorCode = json['errorCode'];
    errorMessage = json['errorMessage'];
    status = ResponseStatusDTO.fromJson(json['status']);
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data!.add(AlertAssigneeDataDTO.fromJson(v));
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

class AlertAssigneeDataDTO {
  String? emailId;
  String? firstName;
  String? lastName;
  num? userId;

  AlertAssigneeDataDTO(
      {this.emailId, this.firstName, this.lastName, this.userId});

  AlertAssigneeDataDTO.fromJson(Map<String, dynamic> json) {
    emailId = json['emailId'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['emailId'] = this.emailId;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['userId'] = this.userId;
    return data;
  }
}
