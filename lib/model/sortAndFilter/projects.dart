import 'package:keysight_pma/model/response_status.dart';

class ProjectsDTO {
  ResponseStatusDTO? status;
  List<ProjectDataDTO>? data;
  int? errorCode;
  String? errorMessage;

  ProjectsDTO({this.status, this.data, this.errorCode, this.errorMessage});

  ProjectsDTO.fromJson(Map<String, dynamic> json) {
    status = ResponseStatusDTO.fromJson(json['status']);
    errorCode = json['errorCode'];
    errorMessage = json['errorMessage'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data!.add(ProjectDataDTO.fromJson(v));
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

class ProjectDataDTO {
  String? projectId;
  bool? isPreferred;
  String? projectName;
  bool? status;
  bool? isSelected;

  ProjectDataDTO(
      {this.projectId,
      this.isPreferred,
      this.projectName,
      this.status,
      this.isSelected});

  ProjectDataDTO.fromJson(Map<String, dynamic> json) {
    projectId = json['projectId'];
    isPreferred = json['isPreferred'];
    projectName = json['projectName'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['projectId'] = this.projectId;
    data['isPreferred'] = this.isPreferred;
    data['projectName'] = this.projectName;
    data['status'] = this.status;
    return data;
  }
}
