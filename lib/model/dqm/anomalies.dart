import 'package:keysight_pma/model/response_status.dart';

class AnomaliesDTO {
  ResponseStatusDTO? status;
  AnomaliesDataDTO? data;
  int? errorCode;
  String? errorMessage;

  AnomaliesDTO({this.status, this.data, this.errorCode, this.errorMessage});

  AnomaliesDTO.fromJson(Map<String, dynamic> json) {
    status = ResponseStatusDTO.fromJson(json['status']);
    data = AnomaliesDataDTO.fromJson(json['data']);
    errorCode = json['errorCode'];
    errorMessage = json['errorMessage'];
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

class AnomaliesDataDTO {
  List<MeasurementAnomalyDataDTO>? measurementAnomaly;
  List<LimitChangeAnomalyDataDTO>? limitChangeAnomaly;
  List<FailureComponentDataDTO>? failureComponents;
  List<AnomalyInformationDataDTO>? anomalyInformation;

  AnomaliesDataDTO(
      {this.measurementAnomaly,
      this.limitChangeAnomaly,
      this.failureComponents,
      this.anomalyInformation});

  AnomaliesDataDTO.fromJson(Map<String, dynamic> json) {
    if (json['measurementAnomaly'] != null) {
      measurementAnomaly = [];
      json['measurementAnomaly'].forEach((v) {
        measurementAnomaly!.add(MeasurementAnomalyDataDTO.fromJson(v));
      });
    }

    if (json['limitChangeAnomaly'] != null) {
      limitChangeAnomaly = [];
      json['limitChangeAnomaly'].forEach((v) {
        limitChangeAnomaly!.add(LimitChangeAnomalyDataDTO.fromJson(v));
      });
    }

    if (json['failureComponents'] != null) {
      failureComponents = [];
      json['failureComponents'].forEach((v) {
        failureComponents!.add(FailureComponentDataDTO.fromJson(v));
      });
    }

    if (json['anomalyInformation'] != null) {
      anomalyInformation = [];
      json['anomalyInformation'].forEach((v) {
        anomalyInformation!.add(AnomalyInformationDataDTO.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['measurementAnomaly'] = this.measurementAnomaly;
    data['limitChangeAnomaly'] = this.limitChangeAnomaly;
    data['failureComponents'] = this.failureComponents;
    data['anomalyInformation'] = this.anomalyInformation;
    return data;
  }
}

class MeasurementAnomalyDataDTO {
  String? companyId;
  String? siteId;
  String? serialNumber;
  String? equipmentId;
  String? projectId;
  String? timestamp;
  num? populationMAD;
  num? distanceFromLimit;
  String? fixtureId;
  num? populationMedian;
  String? testType;
  String? testName;
  String? testUnit;
  num? distanceFromMedian;
  String? status;
  String? populationStdDev;
  String? endDate;
  String? startDate;
  num? lowerBound;
  num? upperBound;

  MeasurementAnomalyDataDTO(
      {this.companyId,
      this.siteId,
      this.serialNumber,
      this.equipmentId,
      this.projectId,
      this.timestamp,
      this.populationMAD,
      this.distanceFromLimit,
      this.fixtureId,
      this.populationMedian,
      this.testType,
      this.testName,
      this.testUnit,
      this.distanceFromMedian,
      this.status,
      this.populationStdDev,
      this.endDate,
      this.startDate,
      this.lowerBound,
      this.upperBound});

  MeasurementAnomalyDataDTO.fromJson(Map<String, dynamic> json) {
    companyId = json['companyId'];
    siteId = json['siteId'];
    serialNumber = json['serialNumber'];
    equipmentId = json['equipmentId'];
    projectId = json['projectId'];
    timestamp = json['timestamp'];
    populationMAD = json['populationMAD'];
    distanceFromLimit = json['distanceFromLimit'];
    fixtureId = json['fixtureId'];
    populationMedian = json['populationMedian'];
    testType = json['testType'];
    testName = json['testName'];
    testUnit = json['testUnit'];
    distanceFromMedian = json['distanceFromMedian'];
    status = json['status'];
    populationStdDev = json['populationStdDev'];
    endDate = json['endDate'];
    startDate = json['startDate'];
    lowerBound = json['lowerBound'];
    upperBound = json['upperBound'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['companyId'] = this.companyId;
    data['siteId'] = this.siteId;
    data['serialNumber'] = this.serialNumber;
    data['equipmentId'] = this.equipmentId;
    data['projectId'] = this.projectId;
    data['timestamp'] = this.timestamp;
    data['populationMAD'] = this.populationMAD;
    data['distanceFromLimit'] = this.distanceFromLimit;
    data['fixtureId'] = this.fixtureId;
    data['populationMedian'] = this.populationMedian;
    data['testType'] = this.testType;
    data['testName'] = this.testName;
    data['testUnit'] = this.testUnit;
    data['distanceFromMedian'] = this.distanceFromMedian;
    data['status'] = this.status;
    data['populationStdDev'] = this.populationStdDev;
    data['endDate'] = this.endDate;
    data['startDate'] = this.startDate;
    data['lowerBound'] = this.lowerBound;
    data['upperBound'] = this.upperBound;
    return data;
  }
}

class LimitChangeAnomalyDataDTO {
  String? companyId;
  String? siteId;
  String? equipmentId;
  String? projectId;
  String? timestamp;
  String? testName;
  num? oldUpperLimit;
  num? oldLowerLimit;
  num? newUpperLimit;
  num? newLowerLimit;
  String? oldLimitTimestamp;
  String? boardTestedTimestamp;

  LimitChangeAnomalyDataDTO(
      {this.companyId,
      this.siteId,
      this.equipmentId,
      this.projectId,
      this.timestamp,
      this.testName,
      this.oldUpperLimit,
      this.oldLowerLimit,
      this.newUpperLimit,
      this.newLowerLimit,
      this.oldLimitTimestamp,
      this.boardTestedTimestamp});

  LimitChangeAnomalyDataDTO.fromJson(Map<String, dynamic> json) {
    companyId = json['companyId'];
    siteId = json['siteId'];
    equipmentId = json['equipmentId'];
    projectId = json['projectId'];
    timestamp = json['timestamp'];
    testName = json['testName'];
    oldUpperLimit = json['oldUpperLimit'];
    oldLowerLimit = json['oldLowerLimit'];
    newUpperLimit = json['newUpperLimit'];
    newLowerLimit = json['newLowerLimit'];
    oldLimitTimestamp = json['oldLimitTimestamp'];
    boardTestedTimestamp = json['boardTestedTimestamp'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['companyId'] = this.companyId;
    data['siteId'] = this.siteId;
    data['equipmentId'] = this.equipmentId;
    data['projectId'] = this.projectId;
    data['timestamp'] = this.timestamp;
    data['testName'] = this.testName;
    data['oldUpperLimit'] = this.oldUpperLimit;
    data['oldLowerLimit'] = this.oldLowerLimit;
    data['newUpperLimit'] = this.newUpperLimit;
    data['newLowerLimit'] = this.newLowerLimit;
    data['oldLimitTimestamp'] = this.oldLimitTimestamp;
    data['boardTestedTimestamp'] = this.boardTestedTimestamp;
    return data;
  }
}

class FailureComponentDataDTO {
  String? companyId;
  String? siteId;
  String? serialNumber;
  String? equipmentId;
  String? projectId;
  String? timestamp;
  String? fixtureId;
  String? testType;
  String? testName;
  String? testUnit;
  String? status;

  FailureComponentDataDTO(
      {this.companyId,
      this.siteId,
      this.serialNumber,
      this.equipmentId,
      this.projectId,
      this.timestamp,
      this.fixtureId,
      this.testType,
      this.testName,
      this.testUnit,
      this.status});

  FailureComponentDataDTO.fromJson(Map<String, dynamic> json) {
    companyId = json['companyId'];
    siteId = json['siteId'];
    serialNumber = json['serialNumber'];
    equipmentId = json['equipmentId'];
    projectId = json['projectId'];
    timestamp = json['timestamp'];
    fixtureId = json['fixtureId'];
    testType = json['testType'];
    testName = json['testName'];
    testUnit = json['testUnit'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['companyId'] = this.companyId;
    data['siteId'] = this.siteId;
    data['serialNumber'] = this.serialNumber;
    data['equipmentId'] = this.equipmentId;
    data['projectId'] = this.projectId;
    data['timestamp'] = this.timestamp;
    data['fixtureId'] = this.fixtureId;
    data['testType'] = this.testType;
    data['testName'] = this.testName;
    data['testUnit'] = this.testUnit;
    data['status'] = this.status;
    return data;
  }
}

class AnomalyInformationDataDTO {
  String? type;
  String? testName;

  AnomalyInformationDataDTO({this.type, this.testName});

  AnomalyInformationDataDTO.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    testName = json['testName'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['testName'] = this.testName;
    return data;
  }
}
