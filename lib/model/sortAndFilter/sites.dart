import 'package:keysight_pma/model/response_status.dart';

class SiteDTO {
  ResponseStatusDTO? status;
  List<SiteDataDTO>? data;
  int? errorCode;
  String? errorMessage;

  SiteDTO({this.status, this.data, this.errorCode, this.errorMessage});

  SiteDTO.fromJson(Map<String, dynamic> json) {
    status = ResponseStatusDTO.fromJson(json['status']);
    errorCode = json['errorCode'];
    errorMessage = json['errorMessage'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data!.add(SiteDataDTO.fromJson(v));
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

class SiteDataDTO {
  String? siteId;
  String? siteName;

  SiteDataDTO({this.siteId, this.siteName});

  SiteDataDTO.fromJson(Map<String, dynamic> json) {
    siteId = json['siteId'] as String;
    siteName = json['siteName'] as String;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['siteId'] = this.siteId;
    data['siteName'] = this.siteName;
    return data;
  }
}
