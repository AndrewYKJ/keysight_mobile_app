import 'package:keysight_pma/model/response_status.dart';

class CompareCountDTO {
  ResponseStatusDTO? status;
  CompareCountDataDTO? data;
  int? errorCode;
  String? errorMessage;

  CompareCountDTO({this.status, this.data, this.errorCode, this.errorMessage});

  CompareCountDTO.fromJson(Map<String, dynamic> json) {
    status = ResponseStatusDTO.fromJson(json['status']);
    data = CompareCountDataDTO.fromJson(json['data']);
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

class CompareCountDataDTO {
  num? numberOfEquipments;
  num? numberOfFixtures;
  num? numberOfPanels;

  CompareCountDataDTO(
      {this.numberOfEquipments, this.numberOfFixtures, this.numberOfPanels});

  CompareCountDataDTO.fromJson(Map<String, dynamic> json) {
    numberOfEquipments = json['numberOfEquipments'];
    numberOfFixtures = json['numberOfFixtures'];
    numberOfPanels = json['numberOfPanels'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['numberOfEquipments'] = this.numberOfEquipments;
    data['numberOfFixtures'] = this.numberOfFixtures;
    data['numberOfPanels'] = this.numberOfPanels;
    return data;
  }
}
