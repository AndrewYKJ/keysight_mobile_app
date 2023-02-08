import 'package:keysight_pma/model/response_status.dart';

class OeeSummaryDTO {
  ResponseStatusDTO? status;
  List<OeeSummaryDataDTO>? data;
  int? errorCode;
  String? errorMessage;

  OeeSummaryDTO({this.status, this.data, this.errorCode, this.errorMessage});

  OeeSummaryDTO.fromJson(Map<String, dynamic> json) {
    status = ResponseStatusDTO.fromJson(json['status']);
    errorCode = json['errorCode'];
    errorMessage = json['errorMessage'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data!.add(OeeSummaryDataDTO.fromJson(v));
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

class OeeSummaryDataDTO {
  OeeSummaryDataDTO({
    this.date,
    this.companyId,
    this.companyName,
    this.performance,
    this.siteId,
    this.availability,
    this.equipmentName,
    this.equipmentId,
    this.oee,
    this.siteName,
    this.availableTime,
    this.downTime,
    this.utilizationTime,
    this.plannedDownTime,
    this.quality,
    this.projectId,
    this.averageUtilizationTime,
    this.totalUtilizationTime,
  });

  String? date;
  String? companyId;
  String? companyName;
  double? performance;
  String? siteId;
  double? availability;
  String? equipmentName;
  String? equipmentId;
  double? availableTime;
  double? oee;
  String? projectId;
  String? siteName;
  double? downTime;
  double? utilizationTime;
  double? quality;
  double? plannedDownTime;
  double? totalUtilizationTime;
  double? averageUtilizationTime;

  OeeSummaryDataDTO.fromJson(Map<String, dynamic> json) {
    date = json["date"];
    companyId = json["companyId"];
    companyName = json["companyName"];
    performance = json["performance"];
    siteId = json["siteId"];
    availability = json["availability"];
    equipmentName = json["equipmentName"];
    equipmentId = json["equipmentId"];
    availableTime = json["availableTime"];
    downTime = json["downTime"];
    utilizationTime = json["utilizationTime"];
    oee = json["oee"];
    siteName = json["siteName"];
    quality = json['quality'];
    plannedDownTime = json['plannedDownTime'];
    projectId = json['projectId'];
    totalUtilizationTime = json['totalUtilizationTime'];
    averageUtilizationTime = json['averageUtilizationTime'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['companyId'] = this.companyId;
    data['companyName'] = this.companyName;
    data['performance'] = this.performance;
    data['siteId'] = this.siteId;
    data['availability'] = this.availability;
    data['equipmentName'] = this.equipmentName;
    data["availableTime"] = this.availableTime;
    data["downTime"] = this.downTime;
    data["utilizationTime"] = this.utilizationTime;
    data['equipmentId'] = this.equipmentId;
    data['oee'] = this.oee;
    data['siteName'] = this.siteName;
    data['quality'] = this.quality;
    data['plannedDownTime'] = this.plannedDownTime;
    data['projectId'] = this.projectId;
    data['totalUtilizationTime'] = this.totalUtilizationTime;
    data['averageUtilizationTime'] = this.averageUtilizationTime;

    return data;
  }
}
