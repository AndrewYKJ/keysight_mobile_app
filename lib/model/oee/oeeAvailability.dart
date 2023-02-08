import 'package:keysight_pma/model/response_status.dart';

class OeeAvailabilityDTO {
  ResponseStatusDTO? status;
  List<OeeAvailabilityDataDTO>? data;
  int? errorCode;
  String? errorMessage;

  OeeAvailabilityDTO(
      {this.status, this.data, this.errorCode, this.errorMessage});

  OeeAvailabilityDTO.fromJson(Map<String, dynamic> json) {
    status = ResponseStatusDTO.fromJson(json['status']);
    errorCode = json['errorCode'];
    errorMessage = json['errorMessage'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data!.add(OeeAvailabilityDataDTO.fromJson(v));
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

class OeeAvailabilityDataDTO {
  String? date;
  double? utilizationTime;
  double? plannedDownTime;
  double? availableTime;
  double? downTime;
  String? companyId;
  String? siteId;
  String? equipmentName;
  double? availability;
  String? equipmentId;

  OeeAvailabilityDataDTO(
      {this.date,
      this.utilizationTime,
      this.plannedDownTime,
      this.availableTime,
      this.downTime,
      this.companyId,
      this.siteId,
      this.equipmentId,
      this.equipmentName,
      this.availability});

  OeeAvailabilityDataDTO.fromJson(Map<String, dynamic> json) {
    utilizationTime = json['utilizationTime'];
    date = json['date'];
    plannedDownTime = json['plannedDownTime'];
    availableTime = json['availableTime'];
    downTime = json['downTime'];
    companyId = json['companyId'];
    siteId = json['siteId'];
    equipmentId = json['equipmentId'];
    equipmentName = json['equipmentName'];
    availability = json['availability'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['utilizationTime'] = this.utilizationTime;
    data['date'] = this.date;
    data['plannedDownTime'] = this.plannedDownTime;
    data['availableTime'] = this.availableTime;
    data['downTime'] = this.downTime;
    data['companyId'] = this.companyId;
    data['siteId'] = this.siteId;
    data['equipmentId'] = this.equipmentId;
    data['equipmentName'] = this.equipmentName;
    data['availability'] = this.availability;
    return data;
  }
}
