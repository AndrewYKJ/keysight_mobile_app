import 'package:keysight_pma/model/response_status.dart';

class TestResultFixtureDTO {
  ResponseStatusDTO? status;
  List<TestResultFixtureDataDTO>? data;
  int? errorCode;
  String? errorMessage;

  TestResultFixtureDTO(
      {this.status, this.data, this.errorCode, this.errorMessage});

  TestResultFixtureDTO.fromJson(Map<String, dynamic> json) {
    status = ResponseStatusDTO.fromJson(json['status']);
    errorCode = json['errorCode'];
    errorMessage = json['errorMessage'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data!.add(TestResultFixtureDataDTO.fromJson(v));
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

class TestResultFixtureDataDTO {
  String? companyId;
  String? siteId;
  String? equipmentId;
  String? timestamp;
  String? testName;
  String? serialNumber;
  String? subTestName;
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
  String? isFalseFailure;
  String? isAnomaly;
  String? description;
  String? lotId;
  String? panelSerialNumber;
  String? boardNumber;
  String? statusJointMachine;
  String? statusJointOperator;
  String? statusJointPrediction;
  String? statusJoint;
  String? statusDefectMachine;
  String? statusDefectOperator;
  String? statusDefectPrediction;
  String? referenceDesignator;
  String? componentName;
  String? pinName;
  String? jointTypeName;
  String? defectName;
  String? sliceName;
  String? isPanelized;
  String? jsonMeasurement;
  String? roix1;
  String? roiy1;
  String? roix2;
  String? roiy2;
  String? pinRotation;
  String? imageName;
  String? nearestNeighbor;
  String? imagePath;
  String? imageFileType;
  String? imageSize;
  String? tfPrediction;
  String? tfProbability;
  String? tfAlgorithmVersion;
  String? rtFeedback;
  String? pmaFeedback;
  String? rtComments;
  String? pmaComments;
  String? defectType;
  String? defectTypeIndex;
  String? equipmentName;

  TestResultFixtureDataDTO(
      {this.companyId,
      this.siteId,
      this.equipmentId,
      this.timestamp,
      this.testName,
      this.serialNumber,
      this.subTestName,
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
      this.isFalseFailure,
      this.isAnomaly,
      this.description,
      this.lotId,
      this.panelSerialNumber,
      this.boardNumber,
      this.statusJointMachine,
      this.statusJointOperator,
      this.statusJointPrediction,
      this.statusJoint,
      this.statusDefectMachine,
      this.statusDefectOperator,
      this.statusDefectPrediction,
      this.referenceDesignator,
      this.componentName,
      this.pinName,
      this.jointTypeName,
      this.defectName,
      this.sliceName,
      this.isPanelized,
      this.jsonMeasurement,
      this.roix1,
      this.roiy1,
      this.roix2,
      this.roiy2,
      this.pinRotation,
      this.imageName,
      this.nearestNeighbor,
      this.imagePath,
      this.imageFileType,
      this.imageSize,
      this.tfPrediction,
      this.tfProbability,
      this.tfAlgorithmVersion,
      this.rtFeedback,
      this.pmaFeedback,
      this.rtComments,
      this.pmaComments,
      this.defectType,
      this.defectTypeIndex,
      this.equipmentName});

  TestResultFixtureDataDTO.fromJson(Map<String, dynamic> json) {
    companyId = json['companyId'];
    siteId = json['siteId'];
    equipmentId = json['equipmentId'];
    timestamp = json['timestamp'];
    testName = json['testName'];
    serialNumber = json['serialNumber'];
    subTestName = json['subTestName'];
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
    isFalseFailure = json['isFalseFailure'];
    isAnomaly = json['isAnomaly'];
    description = json['description'];
    lotId = json['lotId'];
    panelSerialNumber = json['panelSerialNumber'];
    boardNumber = json['boardNumber'];
    statusJointMachine = json['statusJointMachine'];
    statusJointOperator = json['statusJointOperator'];
    statusJointPrediction = json['statusJointPrediction'];
    statusJoint = json['statusJoint'];
    statusDefectMachine = json['statusDefectMachine'];
    statusDefectOperator = json['statusDefectOperator'];
    statusDefectPrediction = json['statusDefectPrediction'];
    referenceDesignator = json['referenceDesignator'];
    componentName = json['componentName'];
    pinName = json['pinName'];
    jointTypeName = json['jointTypeName'];
    defectName = json['defectName'];
    sliceName = json['sliceName'];
    isPanelized = json['isPanelized'];
    jsonMeasurement = json['jsonMeasurement'];
    roix1 = json['roix1'];
    roiy1 = json['roiy1'];
    roix2 = json['roix2'];
    roiy2 = json['roiy2'];
    pinRotation = json['pinRotation'];
    imageName = json['imageName'];
    nearestNeighbor = json['nearestNeighbor'];
    imagePath = json['imagePath'];
    imageFileType = json['imageFileType'];
    imageSize = json['imageSize'];
    tfPrediction = json['tfPrediction'];
    tfProbability = json['tfProbability'];
    tfAlgorithmVersion = json['tfAlgorithmVersion'];
    rtFeedback = json['rtFeedback'];
    pmaFeedback = json['pmaFeedback'];
    rtComments = json['rtComments'];
    pmaComments = json['pmaComments'];
    defectType = json['defectType'];
    defectTypeIndex = json['defectTypeIndex'];
    equipmentName = json['equipmentName'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['companyId'] = this.companyId;
    data['siteId'] = this.siteId;
    data['equipmentId'] = this.equipmentId;
    data['timestamp'] = this.timestamp;
    data['testName'] = this.testName;
    data['serialNumber'] = this.serialNumber;
    data['subTestName'] = this.subTestName;
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
    data['isFalseFailure'] = this.isFalseFailure;
    data['isAnomaly'] = this.isAnomaly;
    data['description'] = this.description;
    data['lotId'] = this.lotId;
    data['panelSerialNumber'] = this.panelSerialNumber;
    data['boardNumber'] = this.boardNumber;
    data['statusJointMachine'] = this.statusJointMachine;
    data['statusJointOperator'] = this.statusJointOperator;
    data['statusJointPrediction'] = this.statusJointPrediction;
    data['statusJoint'] = this.statusJoint;
    data['statusDefectMachine'] = this.statusDefectMachine;
    data['statusDefectOperator'] = this.statusDefectOperator;
    data['statusDefectPrediction'] = this.statusDefectPrediction;
    data['referenceDesignator'] = this.referenceDesignator;
    data['componentName'] = this.componentName;
    data['pinName'] = this.pinName;
    data['jointTypeName'] = this.jointTypeName;
    data['defectName'] = this.defectName;
    data['sliceName'] = this.sliceName;
    data['isPanelized'] = this.isPanelized;
    data['jsonMeasurement'] = this.jsonMeasurement;
    data['roix1'] = this.roix1;
    data['roiy1'] = this.roiy1;
    data['roix2'] = this.roix2;
    data['roiy2'] = this.roiy2;
    data['pinRotation'] = this.pinRotation;
    data['imageName'] = this.imageName;
    data['nearestNeighbor'] = this.nearestNeighbor;
    data['imagePath'] = this.imagePath;
    data['compaimageFileTypenyId'] = this.imageFileType;
    data['imageSize'] = this.imageSize;
    data['tfPrediction'] = this.tfPrediction;
    data['tfProbability'] = this.tfProbability;
    data['tfAlgorithmVersion'] = this.tfAlgorithmVersion;
    data['rtFeedback'] = this.rtFeedback;
    data['pmaFeedback'] = this.pmaFeedback;
    data['rtComments'] = this.rtComments;
    data['pmaComments'] = this.pmaComments;
    data['defectType'] = this.defectType;
    data['defectTypeIndex'] = this.defectTypeIndex;
    data['equipmentName'] = this.equipmentName;
    return data;
  }
}

class FixturesList {
  ResponseStatusDTO? status;
  List<String>? data;
  int? errorCode;
  String? errorMessage;

  FixturesList({this.status, this.data, this.errorCode, this.errorMessage});

  FixturesList.fromJson(Map<String, dynamic> json) {
    status = ResponseStatusDTO.fromJson(json['status']);
    errorCode = json['errorCode'];
    errorMessage = json['errorMessage'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data!.add((v));
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
