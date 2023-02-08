import 'package:keysight_pma/model/response_status.dart';

class OeeEquipmentDTO {
  ResponseStatusDTO? status;
  List<OeeEquipmentDataDTO>? data;
  int? errorCode;
  String? errorMessage;

  OeeEquipmentDTO({this.status, this.data, this.errorCode, this.errorMessage});

  OeeEquipmentDTO.fromJson(Map<String, dynamic> json) {
    status = ResponseStatusDTO.fromJson(json['status']);
    errorCode = json['errorCode'];
    errorMessage = json['errorMessage'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data!.add(OeeEquipmentDataDTO.fromJson(v));
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

class OeeEquipmentDataDTO {
  String? equipmentName;
  String? date;
  String? projectId;
  int? count;
  double? oee;

  OeeEquipmentDataDTO(
      {this.equipmentName, this.date, this.projectId, this.count});

  OeeEquipmentDataDTO.fromJson(Map<String, dynamic> json) {
    equipmentName = json['equipmentName'];
    date = json['date'];
    projectId = json['projectId'];
    count = json['count'];
    oee = json['oee'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['equipmentName'] = this.equipmentName;
    data['date'] = this.date;
    data['count'] = this.count;
    data['projectId'] = this.projectId;
    data['oee'] = this.oee;
    return data;
  }
}
