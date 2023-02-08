import 'package:keysight_pma/model/response_status.dart';

class TestResultTestNameDTO {
  ResponseStatusDTO? status;
  List<TestResultTestNameDataDTO>? data;
  int? errorCode;
  String? errorMessage;

  TestResultTestNameDTO(
      {this.status, this.data, this.errorCode, this.errorMessage});

  TestResultTestNameDTO.fromJson(Map<String, dynamic> json) {
    status = ResponseStatusDTO.fromJson(json['status']);
    errorCode = json['errorCode'];
    errorMessage = json['errorMessage'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data!.add(TestResultTestNameDataDTO.fromJson(v));
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

class TestResultTestNameDataDTO {
  String? companyId;
  String? siteId;
  String? equipmentId;
  dynamic timestamp;
  String? serialNumber;
  String? subTestName;
  String? testName;
  String? testType;
  String? testUnit;
  String? status;
  String? upperLimit;
  String? lowerLimit;
  String? day;
  String? nominal;
  String? measured;
  String? metric;
  String? failureMessage;
  String? projectId;
  String? fixtureId;
  String? failedNodes;
  dynamic dateTimestampLog;
  String? isFalseFailure;
  String? isAnomaly;
  String? equipmentName;
  String? firstTestNameLowerBound;
  String? firstTestNameUpperBound;
  String? secondTestNameLowerBound;
  String? secondTestNameUpperBound;

  TestResultTestNameDataDTO(
      {this.companyId,
      this.siteId,
      this.equipmentId,
      this.timestamp,
      this.serialNumber,
      this.subTestName,
      this.testName,
      this.testType,
      this.testUnit,
      this.status,
      this.upperLimit,
      this.lowerLimit,
      this.day,
      this.nominal,
      this.measured,
      this.metric,
      this.failureMessage,
      this.projectId,
      this.fixtureId,
      this.failedNodes,
      this.dateTimestampLog,
      this.isFalseFailure,
      this.isAnomaly,
      this.equipmentName,
      this.firstTestNameLowerBound,
      this.firstTestNameUpperBound,
      this.secondTestNameLowerBound,
      this.secondTestNameUpperBound});

  TestResultTestNameDataDTO.fromJson(Map<String, dynamic> json) {
    companyId = json['companyId'];
    siteId = json['siteId'];
    equipmentId = json['equipmentId'];
    timestamp = json['timestamp'];
    serialNumber = json['serialNumber'];
    subTestName = json['subTestName'];
    testName = json['testName'];
    testType = json['testType'];
    testUnit = json['testUnit'];
    status = json['status'];
    upperLimit = json['upperLimit'];
    lowerLimit = json['lowerLimit'];
    day = json['day'];
    nominal = json['nominal'];
    measured = json['measured'];
    metric = json['metric'];
    failureMessage = json['failureMessage'];
    projectId = json['projectId'];
    fixtureId = json['fixtureId'];
    failedNodes = json['failedNodes'];
    dateTimestampLog = json['dateTimestampLog'];
    isFalseFailure = json['isFalseFailure'];
    isAnomaly = json['isAnomaly'];
    equipmentName = json['equipmentName'];
    firstTestNameLowerBound = json['firstTestNameLowerBound'];
    firstTestNameUpperBound = json['firstTestNameUpperBound'];
    secondTestNameLowerBound = json['secondTestNameLowerBound'];
    secondTestNameUpperBound = json['secondTestNameUpperBound'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['companyId'] = this.companyId;
    data['siteId'] = this.siteId;
    data['equipmentId'] = this.equipmentId;
    data['timestamp'] = this.timestamp;
    data['serialNumber'] = this.serialNumber;
    data['subTestName'] = this.subTestName;
    data['testName'] = this.testName;
    data['testType'] = this.testType;
    data['testUnit'] = this.testUnit;
    data['status'] = this.status;
    data['upperLimit'] = this.upperLimit;
    data['lowerLimit'] = this.lowerLimit;
    data['day'] = this.day;
    data['nominal'] = this.nominal;
    data['measured'] = this.measured;
    data['metric'] = this.metric;
    data['failureMessage'] = this.failureMessage;
    data['projectId'] = this.projectId;
    data['fixtureId'] = this.fixtureId;
    data['failedNodes'] = this.failedNodes;
    data['dateTimestampLog'] = this.dateTimestampLog;
    data['isFalseFailure'] = this.isFalseFailure;
    data['isAnomaly'] = this.isAnomaly;
    data['equipmentName'] = this.equipmentName;
    data['firstTestNameLowerBound'] = this.firstTestNameLowerBound;
    data['firstTestNameUpperBound'] = this.firstTestNameUpperBound;
    data['secondTestNameLowerBound'] = this.secondTestNameLowerBound;
    data['secondTestNameUpperBound'] = this.secondTestNameUpperBound;
    return data;
  }
}
