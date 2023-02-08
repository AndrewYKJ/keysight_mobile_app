import 'package:keysight_pma/model/response_status.dart';

class AnomalyCompanyDTO {
  ResponseStatusDTO? status;
  List<AnomalyCompanyDataDTO>? data;
  int? errorCode;
  String? errorMessage;

  AnomalyCompanyDTO(
      {this.status, this.data, this.errorCode, this.errorMessage});

  AnomalyCompanyDTO.fromJson(Map<String, dynamic> json) {
    status = ResponseStatusDTO.fromJson(json['status']);
    errorCode = json['errorCode'];
    errorMessage = json['errorMessage'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data!.add(AnomalyCompanyDataDTO.fromJson(v));
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

class AnomalyCompanyDataDTO {
  String? companyId;
  String? siteId;
  String? serialNumber;
  String? equipmentId;
  String? projectId;
  String? timestamp;
  String? retest;
  String? startTime;
  String? endTime;
  String? status;
  String? fixtureId;
  String? companyName;
  String? siteName;
  String? equipmentName;
  String? equipmentType;
  String? derivedBoardName;
  String? machineSerialNumber;
  String? boardSerialNumber;
  String? alignmentTime;
  String? surfaceMapTime;
  String? rptcadName;
  String? resultHashFileName;
  String? statusMachine;
  String? statusOperator;
  String? statusPrediction;
  String? numPinsDefective;
  String? numPinsProcessed;
  String? numDefects;
  String? boardWidth;
  String? boardLength;
  String? boardRotation;
  String? panelWidth;
  String? panelLength;
  String? panelRotation;
  String? tfProbability;
  String? tfAlgorithmVersion;
  String? oprNumPinsFalse;
  String? oprNumPinsTrue;
  String? oprNumDefectsFalse;
  String? oprNumDefectsTrue;
  String? tfNumPinsFalse;
  String? tfNumPinsTrue;
  String? tfNumDefectsFalse;
  String? tfNumDefectsTrue;
  String? highconfidencetruedefects;
  String? highconfidencefalsedefects;
  String? lowconfidencetruedefects;
  String? lowconfidencefalsedefects;
  String? statusPma;
  bool? isAXI;

  AnomalyCompanyDataDTO(
      {this.companyId,
      this.siteId,
      this.serialNumber,
      this.equipmentId,
      this.projectId,
      this.timestamp,
      this.retest,
      this.startTime,
      this.endTime,
      this.status,
      this.fixtureId,
      this.companyName,
      this.siteName,
      this.equipmentName,
      this.equipmentType,
      this.derivedBoardName,
      this.machineSerialNumber,
      this.boardSerialNumber,
      this.alignmentTime,
      this.surfaceMapTime,
      this.rptcadName,
      this.resultHashFileName,
      this.statusMachine,
      this.statusOperator,
      this.statusPrediction,
      this.numPinsDefective,
      this.numPinsProcessed,
      this.numDefects,
      this.boardWidth,
      this.boardLength,
      this.boardRotation,
      this.panelWidth,
      this.panelLength,
      this.panelRotation,
      this.tfProbability,
      this.tfAlgorithmVersion,
      this.oprNumPinsFalse,
      this.oprNumPinsTrue,
      this.oprNumDefectsFalse,
      this.oprNumDefectsTrue,
      this.tfNumPinsFalse,
      this.tfNumPinsTrue,
      this.tfNumDefectsFalse,
      this.tfNumDefectsTrue,
      this.highconfidencetruedefects,
      this.highconfidencefalsedefects,
      this.lowconfidencetruedefects,
      this.lowconfidencefalsedefects,
      this.statusPma,
      this.isAXI});

  AnomalyCompanyDataDTO.fromJson(Map<String, dynamic> json) {
    companyId = json['companyId'];
    siteId = json['siteId'];
    serialNumber = json['serialNumber'];
    equipmentId = json['equipmentId'];
    projectId = json['projectId'];
    timestamp = json['timestamp'];
    retest = json['retest'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    status = json['status'];
    fixtureId = json['fixtureId'];
    companyName = json['companyName'];
    siteName = json['siteName'];
    equipmentName = json['equipmentName'];
    equipmentType = json['equipmentType'];
    derivedBoardName = json['derivedBoardName'];
    machineSerialNumber = json['machineSerialNumber'];
    boardSerialNumber = json['boardSerialNumber'];
    alignmentTime = json['alignmentTime'];
    surfaceMapTime = json['surfaceMapTime'];
    rptcadName = json['rptcadName'];
    resultHashFileName = json['resultHashFileName'];
    statusMachine = json['statusMachine'];
    statusOperator = json['statusOperator'];
    statusPrediction = json['statusPrediction'];
    numPinsDefective = json['numPinsDefective'];
    numPinsProcessed = json['numPinsProcessed'];
    numDefects = json['numDefects'];
    boardWidth = json['boardWidth'];
    boardLength = json['boardLength'];
    boardRotation = json['boardRotation'];
    panelWidth = json['panelWidth'];
    panelLength = json['panelLength'];
    panelRotation = json['panelRotation'];
    tfProbability = json['tfProbability'];
    tfAlgorithmVersion = json['tfAlgorithmVersion'];
    oprNumPinsFalse = json['oprNumPinsFalse'];
    oprNumPinsTrue = json['oprNumPinsTrue'];
    oprNumDefectsFalse = json['oprNumDefectsFalse'];
    oprNumDefectsTrue = json['oprNumDefectsTrue'];
    tfNumPinsFalse = json['tfNumPinsFalse'];
    tfNumPinsTrue = json['tfNumPinsTrue'];
    tfNumDefectsFalse = json['tfNumDefectsFalse'];
    tfNumDefectsTrue = json['tfNumDefectsTrue'];
    highconfidencetruedefects = json['highconfidencetruedefects'];
    highconfidencefalsedefects = json['highconfidencefalsedefects'];
    lowconfidencetruedefects = json['lowconfidencetruedefects'];
    lowconfidencefalsedefects = json['lowconfidencefalsedefects'];
    statusPma = json['statusPma'];
    isAXI = json['isAXI'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['companyId'] = this.companyId;
    data['siteId'] = this.siteId;
    data['serialNumber'] = this.serialNumber;
    data['equipmentId'] = this.equipmentId;
    data['projectId'] = this.projectId;
    data['timestamp'] = this.timestamp;
    data['retest'] = this.retest;
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    data['status'] = this.status;
    data['fixtureId'] = this.fixtureId;
    data['companyName'] = this.companyName;
    data['siteName'] = this.siteName;
    data['equipmentName'] = this.equipmentName;
    data['equipmentType'] = this.equipmentType;
    data['derivedBoardName'] = this.derivedBoardName;
    data['machineSerialNumber'] = this.machineSerialNumber;
    data['boardSerialNumber'] = this.boardSerialNumber;
    data['alignmentTime'] = this.alignmentTime;
    data['surfaceMapTime'] = this.surfaceMapTime;
    data['rptcadName'] = this.rptcadName;
    data['resultHashFileName'] = this.resultHashFileName;
    data['statusMachine'] = this.statusMachine;
    data['statusOperator'] = this.statusOperator;
    data['statusPrediction'] = this.statusPrediction;
    data['numPinsDefective'] = this.numPinsDefective;
    data['numPinsProcessed'] = this.numPinsProcessed;
    data['numDefects'] = this.numDefects;
    data['boardWidth'] = this.boardWidth;
    data['boardLength'] = this.boardLength;
    data['boardRotation'] = this.boardRotation;
    data['panelWidth'] = this.panelWidth;
    data['panelLength'] = this.panelLength;
    data['panelRotation'] = this.panelRotation;
    data['tfProbability'] = this.tfProbability;
    data['tfAlgorithmVersion'] = this.tfAlgorithmVersion;
    data['oprNumPinsFalse'] = this.oprNumPinsFalse;
    data['oprNumPinsTrue'] = this.oprNumPinsTrue;
    data['oprNumDefectsFalse'] = this.oprNumDefectsFalse;
    data['oprNumDefectsTrue'] = this.oprNumDefectsTrue;
    data['tfNumPinsFalse'] = this.tfNumPinsFalse;
    data['tfNumPinsTrue'] = this.tfNumPinsTrue;
    data['tfNumDefectsFalse'] = this.tfNumDefectsFalse;
    data['tfNumDefectsTrue'] = this.tfNumDefectsTrue;
    data['highconfidencetruedefects'] = this.highconfidencetruedefects;
    data['highconfidencefalsedefects'] = this.highconfidencefalsedefects;
    data['lowconfidencetruedefects'] = this.lowconfidencetruedefects;
    data['lowconfidencefalsedefects'] = this.lowconfidencefalsedefects;
    data['statusPma'] = this.statusPma;
    data['isAXI'] = this.isAXI;
    return data;
  }
}
