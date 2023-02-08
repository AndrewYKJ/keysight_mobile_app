import 'package:keysight_pma/model/response_status.dart';

class TestResultCpkPinsShortsDTO {
  ResponseStatusDTO? status;
  List<TestResultCpkPinsShortsTestJetDataDTO>? data;
  int? errorCode;
  String? errorMessage;

  TestResultCpkPinsShortsDTO({this.status, this.data});

  TestResultCpkPinsShortsDTO.fromJson(Map<String, dynamic> json) {
    status = ResponseStatusDTO.fromJson(json['status']);
    errorCode = json['errorCode'];
    errorMessage = json['errorMessage'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data!.add(TestResultCpkPinsShortsTestJetDataDTO.fromJson(v));
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

class TestResultCpkPinsShortsTestJetDataDTO {
  num? brcc;
  String? companyId;
  num? count;
  num? cp;
  num? cpk;
  num? cpl;
  num? cpu;
  String? description;
  String? destination;
  List<String>? equipments;
  num? failureCount;
  bool? hasFailure;
  dynamic heatMapDTOList;
  num? incremental_cpk;
  String? incremental_mean;
  num? incremental_std_dev;
  String? lowerLimit;
  num? lower_threshold;
  num? max;
  String? mean;
  String? measClass;
  String? measType;
  num? min;
  dynamic new_tolerance_negative;
  dynamic new_tolerance_positive;
  String? node;
  num? nominal;
  String? open;
  String? panel;
  String? projectId;
  String? siteId;
  String? source;
  num? stdDeviation;
  num? target_mean;
  String? testName;
  String? testType;
  num? threshold;
  dynamic tolerance_negative;
  dynamic tolerance_positive;
  String? type;
  String? upperLimit;
  num? upper_threshold;

  TestResultCpkPinsShortsTestJetDataDTO(
      {this.brcc,
      this.companyId,
      this.count,
      this.cp,
      this.cpk,
      this.cpl,
      this.cpu,
      this.description,
      this.destination,
      this.equipments,
      this.failureCount,
      this.hasFailure,
      this.heatMapDTOList,
      this.incremental_cpk,
      this.incremental_mean,
      this.incremental_std_dev,
      this.lowerLimit,
      this.lower_threshold,
      this.max,
      this.mean,
      this.measClass,
      this.measType,
      this.min,
      this.new_tolerance_negative,
      this.new_tolerance_positive,
      this.node,
      this.nominal,
      this.open,
      this.panel,
      this.projectId,
      this.siteId,
      this.source,
      this.stdDeviation,
      this.target_mean,
      this.testName,
      this.testType,
      this.threshold,
      this.tolerance_negative,
      this.tolerance_positive,
      this.type,
      this.upperLimit,
      this.upper_threshold});

  TestResultCpkPinsShortsTestJetDataDTO.fromJson(Map<String, dynamic> json) {
    brcc = json['brcc'];
    companyId = json['companyId'];
    count = json['count'];
    cp = json['cp'];
    cpk = json['cpk'];
    cpl = json['cpl'];
    cpu = json['cpu'];
    description = json['description'];
    destination = json['destination'];
    if (json['equipments'] != null) {
      equipments = [];
      json['equipments'].forEach((v) {
        equipments!.add(v);
      });
    }
    failureCount = json['failureCount'];
    hasFailure = json['hasFailure'];
    heatMapDTOList = json['heatMapDTOList'];
    incremental_cpk = json['incremental_cpk'];
    incremental_mean = json['incremental_mean'];
    incremental_std_dev = json['incremental_std_dev'];
    lowerLimit = json['lowerLimit'];
    lower_threshold = json['lower_threshold'];
    max = json['max'];
    mean = json['mean'];
    measClass = json['measClass'];
    measType = json['measType'];
    min = json['min'];
    new_tolerance_negative = json['new_tolerance_negative'];
    new_tolerance_positive = json['new_tolerance_positive'];
    node = json['node'];
    nominal = json['nominal'];
    open = json['open'];
    panel = json['panel'];
    projectId = json['projectId'];
    siteId = json['siteId'];
    source = json['source'];
    stdDeviation = json['stdDeviation'];
    target_mean = json['target_mean'];
    testName = json['testName'];
    testType = json['testType'];
    threshold = json['threshold'];
    tolerance_negative = json['tolerance_negative'];
    tolerance_positive = json['tolerance_positive'];
    type = json['type'];
    upperLimit = json['upperLimit'];
    upper_threshold = json['upper_threshold'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['brcc'] = this.brcc;
    data['companyId'] = this.companyId;
    data['count'] = this.count;
    data['cp'] = this.cp;
    data['cpk'] = this.cpk;
    data['cpl'] = this.cpl;
    data['cpu'] = this.cpu;
    data['description'] = this.description;
    data['destination'] = this.destination;
    data['equipments'] = this.equipments;
    data['failureCount'] = this.failureCount;
    data['hasFailure'] = this.hasFailure;
    data['heatMapDTOList'] = this.heatMapDTOList;
    data['incremental_cpk'] = this.incremental_cpk;
    data['incremental_mean'] = this.incremental_mean;
    data['incremental_std_dev'] = this.incremental_std_dev;
    data['lowerLimit'] = this.lowerLimit;
    data['lower_threshold'] = this.lower_threshold;
    data['max'] = this.max;
    data['mean'] = this.mean;
    data['measClass'] = this.measClass;
    data['measType'] = this.measType;
    data['min'] = this.min;
    data['new_tolerance_negative'] = this.new_tolerance_negative;
    data['new_tolerance_positive'] = this.new_tolerance_positive;
    data['node'] = this.node;
    data['nominal'] = this.nominal;
    data['open'] = this.open;
    data['panel'] = this.panel;
    data['projectId'] = this.projectId;
    data['siteId'] = this.siteId;
    data['source'] = this.source;
    data['stdDeviation'] = this.stdDeviation;
    data['target_mean'] = this.target_mean;
    data['testName'] = this.testName;
    data['testType'] = this.testType;
    data['threshold'] = this.threshold;
    data['tolerance_negative'] = this.tolerance_negative;
    data['tolerance_positive'] = this.tolerance_positive;
    data['type'] = this.type;
    data['upperLimit'] = this.upperLimit;
    data['upper_threshold'] = this.upper_threshold;
    return data;
  }
}
