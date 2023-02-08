import 'package:keysight_pma/model/response_status.dart';

class ProjectVersionByCategoryDTO {
  ResponseStatusDTO? status;
  List<ProjectVersionDataDTO>? data;
  int? errorCode;
  String? errorMessage;

  ProjectVersionByCategoryDTO(
      {this.status, this.data, this.errorCode, this.errorMessage});

  ProjectVersionByCategoryDTO.fromJson(Map<String, dynamic> json) {
    status = ResponseStatusDTO.fromJson(json['status']);
    errorCode = json['errorCode'];
    errorMessage = json['errorMessage'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data!.add(ProjectVersionDataDTO.fromJson(v));
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

class ProjectVersionDataDTO {
  bool? isfunctional;
  bool? isEdl;
  String? version;
  bool? isAxi;
  bool? isIct;
  bool? isXvtep;
  bool? isPreferred;

  ProjectVersionDataDTO(
      {this.isfunctional,
      this.isEdl,
      this.version,
      this.isAxi,
      this.isIct,
      this.isXvtep,
      this.isPreferred});

  ProjectVersionDataDTO.fromJson(Map<String, dynamic> json) {
    isfunctional = json['isfunctional'];
    isEdl = json['isEdl'];
    version = json['version'] as String;
    isAxi = json['isAxi'];
    isIct = json['isIct'];
    isXvtep = json['isXvtep'];
    isPreferred = json['isPreferred'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['isfunctional'] = this.isfunctional;
    data['isEdl'] = this.isEdl;
    data['version'] = this.version;
    data['isAxi'] = this.isAxi;
    data['isIct'] = this.isIct;
    data['isXvtep'] = this.isXvtep;
    data['isPreferred'] = this.isPreferred;
    return data;
  }
}
