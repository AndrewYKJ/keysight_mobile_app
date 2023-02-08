import 'package:keysight_pma/model/response_status.dart';

class DqmFailureComponentDTO {
  ResponseStatusDTO? status;
  List<DqmFailureComponentDataDTO>? data;
  int? errorCode;
  String? errorMessage;

  DqmFailureComponentDTO(
      {this.status, this.data, this.errorCode, this.errorMessage});

  DqmFailureComponentDTO.fromJson(Map<String, dynamic> json) {
    status = ResponseStatusDTO.fromJson(json['status']);
    errorCode = json['errorCode'];
    errorMessage = json['errorMessage'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data!.add(DqmFailureComponentDataDTO.fromJson(v));
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

class DqmFailureComponentDataDTO {
  String? testType;
  num? failureCount;
  String? fixtureId;
  String? date;
  String? equipmentId;
  String? passCount;
  String? testName;
  String? measType;
  String? measClass;

  DqmFailureComponentDataDTO(
      {this.testType,
      this.failureCount,
      this.fixtureId,
      this.date,
      this.equipmentId,
      this.passCount,
      this.testName,
      this.measType,
      this.measClass});

  DqmFailureComponentDataDTO.fromJson(Map<String, dynamic> json) {
    testType = json['testType'];
    failureCount = json['failureCount'];
    fixtureId = json['fixtureId'];
    date = json['date'];
    equipmentId = json['equipmentId'];
    passCount = json['passCount'];
    testName = json['testName'];
    measType = json['measType'];
    measClass = json['measClass'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['testType'] = this.testType;
    data['failureCount'] = this.failureCount;
    data['fixtureId'] = this.fixtureId;
    data['date'] = this.date;
    data['equipmentId'] = this.equipmentId;
    data['passCount'] = this.passCount;
    data['testName'] = this.testName;
    data['measType'] = this.measType;
    data['measClass'] = this.measClass;
    return data;
  }
}
