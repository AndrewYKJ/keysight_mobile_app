import 'package:keysight_pma/model/response_status.dart';

class AlertCpkDTO {
  ResponseStatusDTO? status;
  List<AlertCpkDataDTO>? data;
  int? errorCode;
  String? errorMessage;

  AlertCpkDTO({this.status, this.data, this.errorCode, this.errorMessage});

  AlertCpkDTO.fromJson(Map<String, dynamic> json) {
    status = ResponseStatusDTO.fromJson(json['status']);
    errorCode = json['errorCode'];
    errorMessage = json['errorMessage'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data!.add(AlertCpkDataDTO.fromJson(v));
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

class AlertCpkDataDTO {
  String? companyId;
  String? siteId;
  String? projectId;
  String? startDate;
  String? endDate;
  String? testName;
  String? fixtureId;
  String? equipmentId;
  String? cpk;
  String? threshold;
  bool? isFunctional;
  bool? isEDL;
  String? testType;
  bool? isAxi;
  bool? isIct;
  String? testTypeCategory;

  AlertCpkDataDTO(
      {this.companyId,
      this.siteId,
      this.projectId,
      this.startDate,
      this.endDate,
      this.testName,
      this.fixtureId,
      this.equipmentId,
      this.cpk,
      this.threshold,
      this.isFunctional,
      this.isEDL,
      this.testType,
      this.isAxi,
      this.isIct,
      this.testTypeCategory});

  AlertCpkDataDTO.fromJson(Map<String, dynamic> json) {
    companyId = json['companyId'];
    siteId = json['siteId'];
    projectId = json['projectId'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    testName = json['testName'];
    fixtureId = json['fixtureId'];
    equipmentId = json['equipmentId'];
    cpk = json['cpk'];
    threshold = json['threshold'];
    isFunctional = json['isFunctional'];
    isEDL = json['isEDL'];
    testType = json['testType'];
    isAxi = json['isAxi'];
    isIct = json['isIct'];
    testTypeCategory = json['testTypeCategory'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['companyId'] = this.companyId;
    data['siteId'] = this.siteId;
    data['projectId'] = this.projectId;
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    data['testName'] = this.testName;
    data['fixtureId'] = this.fixtureId;
    data['equipmentId'] = this.equipmentId;
    data['cpk'] = this.cpk;
    data['threshold'] = this.threshold;
    data['isFunctional'] = this.isFunctional;
    data['isEDL'] = this.isEDL;
    data['testType'] = this.testType;
    data['isAxi'] = this.isAxi;
    data['isIct'] = this.isIct;
    data['testTypeCategory'] = this.testTypeCategory;
    return data;
  }
}
