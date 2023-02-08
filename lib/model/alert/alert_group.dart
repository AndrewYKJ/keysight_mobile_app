import 'package:keysight_pma/model/response_status.dart';

class AlertGroupDTO {
  ResponseStatusDTO? status;
  List<AlertGroupDataDTO>? data;
  int? errorCode;
  String? errorMessage;

  AlertGroupDTO({this.status, this.data, this.errorCode, this.errorMessage});

  AlertGroupDTO.fromJson(Map<String, dynamic> json) {
    status = ResponseStatusDTO.fromJson(json['status']);
    errorCode = json['errorCode'];
    errorMessage = json['errorMessage'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data!.add(AlertGroupDataDTO.fromJson(v));
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

class AlertGroupDataDTO {
  num? groupId;
  String? groupName;

  AlertGroupDataDTO({this.groupId, this.groupName});

  AlertGroupDataDTO.fromJson(Map<String, dynamic> json) {
    groupId = json['groupId'];
    groupName = json['groupName'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['groupId'] = this.groupId;
    data['groupName'] = this.groupName;
    return data;
  }
}
