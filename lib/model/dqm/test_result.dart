import 'package:keysight_pma/model/response_status.dart';

class TestResultDTO {
  ResponseStatusDTO? status;
  List<TestResultDataDTO>? data;
  int? errorCode;
  String? errorMessage;

  TestResultDTO({this.status, this.data});

  TestResultDTO.fromJson(Map<String, dynamic> json) {
    status = ResponseStatusDTO.fromJson(json['status']);
    errorCode = json['errorCode'];
    errorMessage = json['errorMessage'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data!.add(TestResultDataDTO.fromJson(v));
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

class TestResultDataDTO {
  String? boardNumber;
  String? companyId;
  String? componentName;
  String? day;
  String? defectName;
  String? defectType;
  String? defectTypeIndex;
  String? description;
  String? equipmentId;
  String? equipmentName;
  String? failedNodes;
  String? failureMessage;
  String? fixtureId;
  String? imageFileType;
  String? imageName;
  String? imagePath;
  String? imageSize;
  String? isAnomaly;
  String? isFalseFailure;
  String? isPanelized;
  String? jointTypeName;
  String? jsonMeasurement;
  String? lotId;
  String? lowerLimit;
  String? measured;
  String? metric;
  String? nearestNeighbor;
  String? nominal;
  String? panelSerialNumber;
  String? pinName;
  String? pinRotation;
  String? pmaComments;
  String? pmaFeedback;
  String? projectId;
  String? referenceDesignator;
  String? roix1;
  String? roix2;
  String? roiy1;
  String? roiy2;
  String? rtComments;
  String? rtFeedback;
  String? serialNumber;
  String? siteId;
  String? sliceName;
  String? status;
  String? statusDefectMachine;
  String? statusDefectOperator;
  String? statusDefectPrediction;
  String? statusJoint;
  String? statusJointMachine;
  String? statusJointOperator;
  String? statusJointPrediction;
  String? subTestName;
  String? testName;
  String? testType;
  String? testUnit;
  String? tfAlgorithmVersion;
  String? tfPrediction;
  String? tfProbability;
  String? timestamp;
  String? upperLimit;

  TestResultDataDTO(
      {this.boardNumber,
      this.companyId,
      this.componentName,
      this.day,
      this.defectName,
      this.defectType,
      this.defectTypeIndex,
      this.description,
      this.equipmentId,
      this.equipmentName,
      this.failedNodes,
      this.failureMessage,
      this.fixtureId,
      this.imageFileType,
      this.imageName,
      this.imagePath,
      this.imageSize,
      this.isAnomaly,
      this.isFalseFailure,
      this.isPanelized,
      this.jointTypeName,
      this.jsonMeasurement,
      this.lotId,
      this.lowerLimit,
      this.measured,
      this.metric,
      this.nearestNeighbor,
      this.nominal,
      this.panelSerialNumber,
      this.pinName,
      this.pinRotation,
      this.pmaComments,
      this.pmaFeedback,
      this.projectId,
      this.referenceDesignator,
      this.roix1,
      this.roix2,
      this.roiy1,
      this.roiy2,
      this.rtComments,
      this.rtFeedback,
      this.serialNumber,
      this.siteId,
      this.sliceName,
      this.status,
      this.statusDefectMachine,
      this.statusDefectOperator,
      this.statusDefectPrediction,
      this.statusJoint,
      this.statusJointMachine,
      this.statusJointOperator,
      this.statusJointPrediction,
      this.subTestName,
      this.testName,
      this.testType,
      this.testUnit,
      this.tfAlgorithmVersion,
      this.tfPrediction,
      this.tfProbability,
      this.timestamp,
      this.upperLimit});

  TestResultDataDTO.fromJson(Map<String, dynamic> json) {
    boardNumber = json['boardNumber'];
    companyId = json['companyId'];
    componentName = json['componentName'];
    day = json['day'];
    defectName = json['defectName'];
    defectType = json['defectType'];
    defectTypeIndex = json['defectTypeIndex'];
    description = json['description'];
    equipmentId = json['equipmentId'];
    equipmentName = json['equipmentName'];
    failedNodes = json['failedNodes'];
    failureMessage = json['failureMessage'];
    fixtureId = json['fixtureId'];
    imageFileType = json['imageFileType'];
    imageName = json['imageName'];
    imagePath = json['imagePath'];
    imageSize = json['imageSize'];
    isAnomaly = json['isAnomaly'];
    isFalseFailure = json['isFalseFailure'];
    isPanelized = json['isPanelized'];
    jointTypeName = json['jointTypeName'];
    jsonMeasurement = json['jsonMeasurement'];
    lotId = json['lotId'];
    lowerLimit = json['lowerLimit'];
    measured = json['measured'];
    metric = json['metric'];
    nearestNeighbor = json['nearestNeighbor'];
    nominal = json['nominal'];
    panelSerialNumber = json['panelSerialNumber'];
    pinName = json['pinName'];
    pinRotation = json['pinRotation'];
    pmaComments = json['pmaComments'];
    pmaFeedback = json['pmaFeedback'];
    projectId = json['projectId'];
    referenceDesignator = json['referenceDesignator'];
    roix1 = json['roix1'];
    roix2 = json['roix2'];
    roiy1 = json['roiy1'];
    roiy2 = json['roiy2'];
    rtComments = json['rtComments'];
    rtFeedback = json['rtFeedback'];
    serialNumber = json['serialNumber'];
    siteId = json['siteId'];
    sliceName = json['sliceName'];
    status = json['status'];
    statusDefectMachine = json['statusDefectMachine'];
    statusDefectOperator = json['statusDefectOperator'];
    statusDefectPrediction = json['statusDefectPrediction'];
    statusJoint = json['statusJoint'];
    statusJointMachine = json['statusJointMachine'];
    statusJointOperator = json['statusJointOperator'];
    statusJointPrediction = json['statusJointPrediction'];
    subTestName = json['subTestName'];
    testName = json['testName'];
    testType = json['testType'];
    testUnit = json['testUnit'];
    tfAlgorithmVersion = json['tfAlgorithmVersion'];
    tfPrediction = json['tfPrediction'];
    tfProbability = json['tfProbability'];
    timestamp = json['timestamp'];
    upperLimit = json['upperLimit'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['boardNumber'] = this.boardNumber;
    data['companyId'] = this.companyId;
    data['componentName'] = this.componentName;
    data['day'] = this.day;
    data['defectName'] = this.defectName;
    data['defectType'] = this.defectType;
    data['defectTypeIndex'] = this.defectTypeIndex;
    data['description'] = this.description;
    data['equipmentId'] = this.equipmentId;
    data['equipmentName'] = this.equipmentName;
    data['failedNodes'] = this.failedNodes;
    data['failureMessage'] = this.failureMessage;
    data['fixtureId'] = this.fixtureId;
    data['imageFileType'] = this.imageFileType;
    data['imageName'] = this.imageName;
    data['imagePath'] = this.imagePath;
    data['imageSize'] = this.imageSize;
    data['isAnomaly'] = this.isAnomaly;
    data['isFalseFailure'] = this.isFalseFailure;
    data['isPanelized'] = this.isPanelized;
    data['jointTypeName'] = this.jointTypeName;
    data['jsonMeasurement'] = this.jsonMeasurement;
    data['lotId'] = this.lotId;
    data['lowerLimit'] = this.lowerLimit;
    data['measured'] = this.measured;
    data['metric'] = this.metric;
    data['nearestNeighbor'] = this.nearestNeighbor;
    data['nominal'] = this.nominal;
    data['panelSerialNumber'] = this.panelSerialNumber;
    data['pinName'] = this.pinName;
    data['pinRotation'] = this.pinRotation;
    data['pmaComments'] = this.pmaComments;
    data['pmaFeedback'] = this.pmaFeedback;
    data['projectId'] = this.projectId;
    data['referenceDesignator'] = this.referenceDesignator;
    data['roix1'] = this.roix1;
    data['roix2'] = this.roix2;
    data['roiy1'] = this.roiy1;
    data['roiy2'] = this.roiy2;
    data['rtComments'] = this.rtComments;
    data['rtFeedback'] = this.rtFeedback;
    data['serialNumber'] = this.serialNumber;
    data['siteId'] = this.siteId;
    data['sliceName'] = this.sliceName;
    data['status'] = this.status;
    data['statusDefectMachine'] = this.statusDefectMachine;
    data['statusDefectOperator'] = this.statusDefectOperator;
    data['statusDefectPrediction'] = this.statusDefectPrediction;
    data['statusJoint'] = this.statusJoint;
    data['statusJointMachine'] = this.statusJointMachine;
    data['statusJointOperator'] = this.statusJointOperator;
    data['statusJointPrediction'] = this.statusJointPrediction;
    data['subTestName'] = this.subTestName;
    data['testName'] = this.testName;
    data['testType'] = this.testType;
    data['testUnit'] = this.testUnit;
    data['tfAlgorithmVersion'] = this.tfAlgorithmVersion;
    data['tfPrediction'] = this.tfPrediction;
    data['tfProbability'] = this.tfProbability;
    data['timestamp'] = this.timestamp;
    data['upperLimit'] = this.upperLimit;
    return data;
  }
}
