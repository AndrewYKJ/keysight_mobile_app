import 'package:keysight_pma/model/response_status.dart';

class EquipmentDTO {
  ResponseStatusDTO? status;
  List<EquipmentDataDTO>? data;
  int? errorCode;
  String? errorMessage;

  EquipmentDTO({this.status, this.data, this.errorCode, this.errorMessage});

  EquipmentDTO.fromJson(Map<String, dynamic> json) {
    status = ResponseStatusDTO.fromJson(json['status']);
    errorCode = json['errorCode'];
    errorMessage = json['errorMessage'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data!.add(EquipmentDataDTO.fromJson(v));
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

class EquipmentDataDTO {
  String? equipmentId;
  String? equipmentName;
  bool? isSelected;

  EquipmentDataDTO({this.equipmentId, this.equipmentName, this.isSelected});

  EquipmentDataDTO.fromJson(Map<String, dynamic> json) {
    equipmentId = json['equipmentId'] as String;
    equipmentName = json['equipmentName'] as String;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['equipmentId'] = this.equipmentId;
    data['equipmentName'] = this.equipmentName;
    return data;
  }
}
