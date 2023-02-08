import 'package:keysight_pma/model/response_status.dart';

class YieldBySiteDTO {
  ResponseStatusDTO? status;
  List<YieldBySiteDataDTO>? data;
  int? errorCode;
  String? errorMessage;

  YieldBySiteDTO({this.status, this.data, this.errorCode, this.errorMessage});

  YieldBySiteDTO.fromJson(Map<String, dynamic> json) {
    status = ResponseStatusDTO.fromJson(json['status']);
    errorCode = json['errorCode'];
    errorMessage = json['errorMessage'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data!.add(YieldBySiteDataDTO.fromJson(v));
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

class YieldBySiteDataDTO {
  String? projectId;
  String? date;
  double? failed;
  double? firstPass;
  double? rework;
  double? utilizationTime;
  String? dailyProjectKey;

  YieldBySiteDataDTO(
      {this.projectId,
      this.date,
      this.failed,
      this.firstPass,
      this.rework,
      this.utilizationTime,
      this.dailyProjectKey});

  YieldBySiteDataDTO.fromJson(Map<String, dynamic> json) {
    projectId = json['projectId'];
    date = json['date'];
    failed = json['failed'];
    firstPass = json['firstPass'];
    rework = json['rework'];
    utilizationTime = json['utilizationTime'];
    dailyProjectKey = json['dailyProjectKey'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['projectId'] = this.projectId;
    data['date'] = this.date;
    data['failed'] = this.failed;
    data['firstPass'] = this.firstPass;
    data['rework'] = this.rework;
    data['utilizationTime'] = this.utilizationTime;
    data['dailyProjectKey'] = this.dailyProjectKey;
    return data;
  }
}
