import 'package:keysight_pma/model/response_status.dart';

class WorstTestNameDTO {
  ResponseStatusDTO? status;
  List<WorstTestNameDataDTO>? data;
  int? errorCode;
  String? errorMessage;

  WorstTestNameDTO({this.status, this.data, this.errorCode, this.errorMessage});

  WorstTestNameDTO.fromJson(Map<String, dynamic> json) {
    status = ResponseStatusDTO.fromJson(json['status']);
    errorCode = json['errorCode'];
    errorMessage = json['errorMessage'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data!.add(WorstTestNameDataDTO.fromJson(v));
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

class WorstTestNameDataDTO {
  String? fixtureId;
  String? measClass;
  num? count;
  String? testType;
  String? measType;
  String? testName;

  WorstTestNameDataDTO(
      {this.testType,
      this.fixtureId,
      this.count,
      this.testName,
      this.measType,
      this.measClass});

  WorstTestNameDataDTO.fromJson(Map<String, dynamic> json) {
    testType = json['testType'];
    fixtureId = json['fixtureId'];
    count = json['count'];
    testName = json['testName'];
    measType = json['measType'];
    measClass = json['measClass'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['testType'] = this.testType;
    data['fixtureId'] = this.fixtureId;
    data['count'] = this.count;
    data['testName'] = this.testName;
    data['measType'] = this.measType;
    data['measClass'] = this.measClass;
    return data;
  }
}
