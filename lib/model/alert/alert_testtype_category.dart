import 'package:keysight_pma/model/response_status.dart';

class AlertTestTypeCategoryDTO {
  ResponseStatusDTO? status;
  AlertTestTypeCategoryDataDTO? data;
  int? errorCode;
  String? errorMessage;

  AlertTestTypeCategoryDTO(
      {this.status, this.data, this.errorCode, this.errorMessage});

  AlertTestTypeCategoryDTO.fromJson(Map<String, dynamic> json) {
    status = ResponseStatusDTO.fromJson(json['status']);
    data = AlertTestTypeCategoryDataDTO.fromJson(json['data']);
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

class AlertTestTypeCategoryDataDTO {
  String? companyId;
  String? siteId;
  String? projectId;
  String? testName;
  String? testType;
  String? testTypeCategory;
  bool? isfunctional;
  bool? isEdl;
  String? version;
  String? description;
  bool? ict;
  bool? axi;

  AlertTestTypeCategoryDataDTO(
      {this.companyId,
      this.siteId,
      this.projectId,
      this.testName,
      this.testType,
      this.testTypeCategory,
      this.isfunctional,
      this.isEdl,
      this.version,
      this.description,
      this.ict,
      this.axi});

  AlertTestTypeCategoryDataDTO.fromJson(Map<String, dynamic> json) {
    companyId = json['companyId'];
    siteId = json['siteId'];
    projectId = json['projectId'];
    testName = json['testName'];
    testType = json['testType'];
    testTypeCategory = json['testTypeCategory'];
    isfunctional = json['isfunctional'];
    isEdl = json['isEdl'];
    version = json['version'];
    description = json['description'];
    ict = json['ict'];
    axi = json['axi'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['companyId'] = this.companyId;
    data['siteId'] = this.siteId;
    data['projectId'] = this.projectId;
    data['testName'] = this.testName;
    data['testType'] = this.testType;
    data['testTypeCategory'] = this.testTypeCategory;
    data['isfunctional'] = this.isfunctional;
    data['isEdl'] = this.isEdl;
    data['version'] = this.version;
    data['description'] = this.description;
    data['ict'] = this.ict;
    data['axi'] = this.axi;
    return data;
  }
}
