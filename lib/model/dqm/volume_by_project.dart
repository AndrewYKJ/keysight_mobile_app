import 'package:keysight_pma/model/response_status.dart';

class VolumeByProjectDTO {
  ResponseStatusDTO? status;
  List<VolumeByProjectDataDTO>? data;
  int? errorCode;
  String? errorMessage;

  VolumeByProjectDTO(
      {this.status, this.data, this.errorCode, this.errorMessage});

  VolumeByProjectDTO.fromJson(Map<String, dynamic> json) {
    status = ResponseStatusDTO.fromJson(json['status']);
    errorCode = json['errorCode'];
    errorMessage = json['errorMessage'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data!.add(VolumeByProjectDataDTO.fromJson(v));
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

class VolumeByProjectDataDTO {
  int? firstPass;
  int? rework;
  int? pass;
  int? fail;
  String? projectId;
  int? failed;

  VolumeByProjectDataDTO(
      {this.firstPass,
      this.rework,
      this.pass,
      this.fail,
      this.projectId,
      this.failed});

  VolumeByProjectDataDTO.fromJson(Map<String, dynamic> json) {
    firstPass = json['firstPass'];
    rework = json['rework'];
    pass = json['pass'];
    fail = json['fail'];
    projectId = json['projectId'];
    failed = json['failed'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['firstPass'] = this.firstPass;
    data['rework'] = this.rework;
    data['pass'] = this.pass;
    data['fail'] = this.fail;
    data['projectId'] = this.projectId;
    data['failed'] = this.failed;
    return data;
  }
}
