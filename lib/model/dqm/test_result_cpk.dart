import 'package:keysight_pma/model/response_status.dart';

class TestResultCpkDTO {
  ResponseStatusDTO? status;
  List<TestResultCpkDataDTO>? data;
  int? errorCode;
  String? errorMessage;

  TestResultCpkDTO({this.status, this.data, this.errorCode, this.errorMessage});

  TestResultCpkDTO.fromJson(Map<String, dynamic> json) {
    status = ResponseStatusDTO.fromJson(json['status']);
    errorCode = json['errorCode'];
    errorMessage = json['errorMessage'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data!.add(TestResultCpkDataDTO.fromJson(v));
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

class TestResultCpkDataDTO {
  String? companyId;
  String? siteId;
  String? projectId;
  String? equipmentId;
  String? timestamp;
  String? latestTimeStamp;
  String? testName;
  String? stdDeviation;
  String? incremental_std_dev;
  String? cpk;
  String? count;
  String? incremental_cpk;
  String? fixtureId;
  String? mean;
  String? max;
  String? total_count;
  String? upperLimit;
  String? incremental_mean;
  String? min;
  String? lowerLimit;
  String? passCount;
  String? failCount;
  String? testType;
  String? nominal;

  TestResultCpkDataDTO({
    this.companyId,
    this.siteId,
    this.projectId,
    this.equipmentId,
    this.timestamp,
    this.latestTimeStamp,
    this.testName,
    this.stdDeviation,
    this.incremental_std_dev,
    this.cpk,
    this.count,
    this.incremental_cpk,
    this.fixtureId,
    this.mean,
    this.max,
    this.total_count,
    this.upperLimit,
    this.incremental_mean,
    this.min,
    this.lowerLimit,
    this.passCount,
    this.failCount,
    this.testType,
    this.nominal,
  });

  TestResultCpkDataDTO.fromJson(Map<String, dynamic> json) {
    companyId = json['companyId'];
    siteId = json['siteId'];
    projectId = json['projectId'];
    equipmentId = json['equipmentId'];
    timestamp = json['timestamp'];
    latestTimeStamp = json['latestTimeStamp'];
    testName = json['testName'];
    stdDeviation = json['stdDeviation'];
    incremental_std_dev = json['incremental_std_dev'];
    cpk = json['cpk'];
    count = json['count'];
    incremental_cpk = json['incremental_cpk'];
    fixtureId = json['fixtureId'];
    mean = json['mean'];
    max = json['max'];
    total_count = json['total_count'];
    upperLimit = json['upperLimit'];
    incremental_mean = json['incremental_mean'];
    min = json['min'];
    lowerLimit = json['lowerLimit'];
    passCount = json['passCount'];
    failCount = json['failCount'];
    testType = json['testType'];
    nominal = json['nominal'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['companyId'] = this.companyId;
    data['siteId'] = this.siteId;
    data['projectId'] = this.projectId;
    data['equipmentId'] = this.equipmentId;
    data['timestamp'] = this.timestamp;
    data['latestTimeStamp'] = this.latestTimeStamp;
    data['testName'] = this.testName;
    data['stdDeviation'] = this.stdDeviation;
    data['incremental_std_dev'] = this.incremental_std_dev;
    data['cpk'] = this.cpk;
    data['count'] = this.count;
    data['incremental_cpk'] = this.incremental_cpk;
    data['fixtureId'] = this.fixtureId;
    data['mean'] = this.mean;
    data['max'] = this.max;
    data['total_count'] = this.total_count;
    data['upperLimit'] = this.upperLimit;
    data['incremental_mean'] = this.incremental_mean;
    data['min'] = this.min;
    data['lowerLimit'] = this.lowerLimit;
    data['passCount'] = this.passCount;
    data['failCount'] = this.failCount;
    data['testType'] = this.testType;
    data['nominal'] = this.nominal;
    return data;
  }
}
