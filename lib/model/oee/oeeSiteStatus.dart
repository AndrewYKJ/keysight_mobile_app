import 'package:keysight_pma/model/response_status.dart';

class OeeSiteStatus {
  ResponseStatusDTO? status;
  OeeSiteStatusDataDTO? data;
  int? errorCode;
  String? errorMessage;

  OeeSiteStatus({this.status, this.data, this.errorCode, this.errorMessage});

  OeeSiteStatus.fromJson(Map<String, dynamic> json) {
    status = ResponseStatusDTO.fromJson(json['status']);
    data = OeeSiteStatusDataDTO.fromJson(json['data']);
    errorCode = json['errorCode'];
    errorMessage = json['errorMessage'];
  }
}

class OeeSiteStatusDataDTO {
  OeeSiteStatusDataDTO({
    this.companyId,
    this.siteId,
    this.latitude,
    this.longitude,
    this.country,
    this.siteName,
    this.regionName,
    this.timeZone,
    this.timeToUtc,
    this.alertEmails,
    this.userName,
    this.password,
    this.equipmentcount,
    this.clientId,
    this.paymentMode,
    this.pdmStatus,
  });

  String? companyId;
  String? siteId;
  String? latitude;
  String? longitude;
  String? country;
  String? siteName;
  String? regionName;
  String? timeZone;
  String? timeToUtc;
  String? alertEmails;
  String? userName;
  String? password;
  String? equipmentcount;
  String? clientId;
  String? paymentMode;
  String? pdmStatus;

  OeeSiteStatusDataDTO.fromJson(Map<String, dynamic> json) {
    companyId = json["companyId"];
    siteId = json["siteId"];
    latitude = json["latitude"];
    longitude = json["longitude"];
    country = json["country"];
    siteName = json["siteName"];
    password = json["password"];
    regionName = json["regionName"];
    equipmentcount = json["equipmentcount"];
    timeZone = json["timeZone"];
    clientId = json["clientId"];
    timeToUtc = json["timeToUtc"];
    paymentMode = json["paymentMode"];
    alertEmails = json["alertEmails"];
    pdmStatus = json["pdmStatus"];
    userName = json["userName"];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['clientId'] = this.clientId;
    data['companyId'] = this.companyId;
    data['country'] = this.country;
    data['paymentMode'] = this.paymentMode;
    data['timeToUtc'] = this.timeToUtc;
    data['timeZone'] = this.timeZone;
    data['equipmentcount'] = this.equipmentcount;
    data['regionName'] = this.regionName;
    data['password'] = this.password;
    data['siteName'] = this.siteName;
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    data['siteId'] = this.siteId;
    data['pdmStatus'] = this.pdmStatus;
    data['alertEmails'] = this.alertEmails;
    data['userName'] = this.userName;

    return data;
  }
}
