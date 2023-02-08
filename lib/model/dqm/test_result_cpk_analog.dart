import 'package:keysight_pma/model/response_status.dart';

class TestResultCpkAnalogDTO {
  ResponseStatusDTO? status;
  List<TestResultCpkAnalogDataDTO>? data;
  int? errorCode;
  String? errorMessage;

  TestResultCpkAnalogDTO(
      {this.status, this.data, this.errorCode, this.errorMessage});

  TestResultCpkAnalogDTO.fromJson(Map<String, dynamic> json) {
    status = ResponseStatusDTO.fromJson(json['status']);
    errorCode = json['errorCode'];
    errorMessage = json['errorMessage'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data!.add(TestResultCpkAnalogDataDTO.fromJson(v));
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

class TestResultCpkAnalogDataDTO {
  String? companyId;
  String? siteId;
  String? projectId;
  String? testName;
  String? incremental_std_dev;
  String? count;
  String? incremental_cpk;
  String? mean;
  String? upperLimit;
  String? incremental_mean;
  String? lowerLimit;
  String? node;
  String? type;
  String? panel;
  String? testType;
  dynamic nominal;
  dynamic tolerance_positive;
  dynamic tolerance_negative;
  dynamic new_tolerance_positive;
  dynamic new_tolerance_negative;
  String? measClass;
  String? measType;
  bool? hasFailure;
  dynamic cpu;
  dynamic cpl;
  dynamic cp;
  dynamic target_mean;
  dynamic upper_threshold;
  dynamic lower_threshold;
  dynamic threshold;
  dynamic min;
  dynamic max;
  dynamic cpk;
  dynamic stdDeviation;
  int? failureCount;

  TestResultCpkAnalogDataDTO(
      {this.companyId,
      this.siteId,
      this.projectId,
      this.testName,
      this.stdDeviation,
      this.incremental_std_dev,
      this.cpk,
      this.count,
      this.incremental_cpk,
      this.mean,
      this.max,
      this.upperLimit,
      this.incremental_mean,
      this.min,
      this.lowerLimit,
      this.threshold,
      this.node,
      this.type,
      this.panel,
      this.testType,
      this.nominal,
      // this.tolerance_positive,
      // this.tolerance_negative,
      this.cpu,
      this.cpl,
      this.cp,
      this.target_mean,
      this.upper_threshold,
      this.lower_threshold,
      this.new_tolerance_positive,
      // this.new_tolerance_negative,
      this.measClass,
      this.measType,
      this.hasFailure,
      this.failureCount});

  TestResultCpkAnalogDataDTO.fromJson(Map<String, dynamic> json) {
    companyId = json['companyId'];
    siteId = json['siteId'];
    projectId = json['projectId'];
    testName = json['testName'];
    stdDeviation = json['stdDeviation'];
    incremental_std_dev = json['incremental_std_dev'];
    cpk = json['cpk'];
    count = json['count'];
    incremental_cpk = json['incremental_cpk'];
    mean = json['mean'];
    max = json['max'];
    upperLimit = json['upperLimit'];
    incremental_mean = json['incremental_mean'];
    min = json['min'];
    lowerLimit = json['lowerLimit'];
    threshold = json['threshold'];
    node = json['node'];
    type = json['type'];
    panel = json['panel'];
    testType = json['testType'];
    nominal = json['nominal'];
    // tolerance_positive = json['tolerance_positive'];
    // tolerance_negative = json['tolerance_negative'];
    cpu = json['cpu'];
    cpl = json['cpl'];
    cp = json['cp'];
    target_mean = json['target_mean'];
    upper_threshold = json['upper_threshold'];
    lower_threshold = json['lower_threshold'];
    new_tolerance_positive = json['new_tolerance_positive'];
    // new_tolerance_negative = json['new_tolerance_negative'];
    measClass = json['measClass'];
    measType = json['measType'];
    hasFailure = json['hasFailure'];
    failureCount = json['failureCount'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['companyId'] = this.companyId;
    data['siteId'] = this.siteId;
    data['projectId'] = this.projectId;
    data['testName'] = this.testName;
    data['stdDeviation'] = this.stdDeviation;
    data['incremental_std_dev'] = this.incremental_std_dev;
    data['cpk'] = this.cpk;
    data['count'] = this.count;
    data['incremental_cpk'] = this.incremental_cpk;
    data['mean'] = this.mean;
    data['max'] = this.max;
    data['upperLimit'] = this.upperLimit;
    data['incremental_mean'] = this.incremental_mean;
    data['min'] = this.min;
    data['lowerLimit'] = this.lowerLimit;
    data['threshold'] = this.threshold;
    data['node'] = this.node;
    data['type'] = this.type;
    data['panel'] = this.panel;
    data['testType'] = this.testType;
    data['nominal'] = this.nominal;
    // data['tolerance_positive'] = this.tolerance_positive;
    // data['tolerance_negative'] = this.tolerance_negative;
    data['cpu'] = this.cpu;
    data['cpl'] = this.cpl;
    data['cp'] = this.cp;
    data['target_mean'] = this.target_mean;
    data['upper_threshold'] = this.upper_threshold;
    data['lower_threshold'] = this.lower_threshold;
    data['new_tolerance_positive'] = this.new_tolerance_positive;
    // data['new_tolerance_negative'] = this.new_tolerance_negative;
    data['measClass'] = this.measClass;
    data['measType'] = this.measType;
    data['hasFailure'] = this.hasFailure;
    data['failureCount'] = this.failureCount;
    return data;
  }
}
