import 'package:keysight_pma/model/response_status.dart';

class CompanyDTO {
  ResponseStatusDTO? status;
  List<CompanyDataDTO>? data;
  int? errorCode;
  String? errorMessage;

  CompanyDTO({this.status, this.data, this.errorCode, this.errorMessage});

  CompanyDTO.fromJson(Map<String, dynamic> json) {
    status = ResponseStatusDTO.fromJson(json['status']);
    errorCode = json['errorCode'];
    errorMessage = json['errorMessage'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data!.add(CompanyDataDTO.fromJson(v));
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

class CompanyDataDTO {
  String? companyId;
  String? companyName;
  String? isActive;

  CompanyDataDTO({this.companyId, this.companyName, this.isActive});

  CompanyDataDTO.fromJson(Map<String, dynamic> json) {
    companyId = json['companyId'] as String;
    companyName = json['companyName'] as String;
    isActive = json['isActive'] as String;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['companyId'] = this.companyId;
    data['companyName'] = this.companyName;
    data['isActive'] = this.isActive;
    return data;
  }
}
