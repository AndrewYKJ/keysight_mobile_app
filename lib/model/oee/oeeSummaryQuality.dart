import 'package:keysight_pma/model/response_status.dart';

class OeeQualityDTO {
  ResponseStatusDTO? status;
  List<OeeQualityDataDTO>? data;
  int? errorCode;
  String? errorMessage;

  OeeQualityDTO({this.status, this.data, this.errorCode, this.errorMessage});

  OeeQualityDTO.fromJson(Map<String, dynamic> json) {
    status = ResponseStatusDTO.fromJson(json['status']);
    errorCode = json['errorCode'];
    errorMessage = json['errorMessage'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data!.add(OeeQualityDataDTO.fromJson(v));
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

class OeeQualityDataDTO {
  int? firstPassCount;
  int? totalFailedCount;
  int? totalFirstPassCount;
  int? totalRetestCount;
  double? quality;
  int? totalCount;
  String? date;
  int? retestCount;
  String? companyId;
  String? projectId;
  String? siteId;
  String? equipmentName;
  int? failedCount;
  String? equipmentId;

  OeeQualityDataDTO(
      {this.firstPassCount,
      this.totalRetestCount,
      this.companyId,
      this.failedCount,
      this.retestCount,
      this.siteId,
      this.equipmentName,
      this.totalCount,
      this.equipmentId,
      this.quality,
      this.date,
      this.projectId,
      this.totalFailedCount,
      this.totalFirstPassCount});

  OeeQualityDataDTO.fromJson(Map<String, dynamic> json) {
    firstPassCount = json['firstPassCount'];
    failedCount = json['failedCount'];
    retestCount = json['retestCount'];
    quality = json['quality'];
    companyId = json['companyId'];
    siteId = json['siteId'];
    equipmentId = json['equipmentId'];
    equipmentName = json['equipmentName'];
    totalCount = json['totalCount'];
    totalRetestCount = json['totalRetestCount'];
    date = json['date'];
    projectId = json['projectId'];
    totalFailedCount = json['totalFailedCount'];
    totalFirstPassCount = json['totalFirstPassCount'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['firstPassCount'] = this.firstPassCount;
    data['failedCount'] = this.failedCount;
    data['retestCount'] = this.retestCount;
    data['quality'] = this.quality;
    data['companyId'] = this.companyId;
    data['siteId'] = this.siteId;
    data['equipmentId'] = this.equipmentId;
    data['equipmentName'] = this.equipmentName;
    data['totalCount'] = this.totalCount;
    data['totalRetestCount'] = this.totalRetestCount;
    data['date'] = this.date;
    data['projectId'] = this.projectId;
    data['totalFailedCount'] = this.totalFailedCount;
    data['totalFirstPassCount'] = this.totalFirstPassCount;
    return data;
  }
}
