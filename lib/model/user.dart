import 'package:keysight_pma/model/response_status.dart';

class UserDTO {
  ResponseStatusDTO? status;
  UserDataDTO? data;
  int? errorCode;
  String? errorMessage;

  UserDTO({this.status, this.data, this.errorCode, this.errorMessage});

  UserDTO.fromJson(Map<String, dynamic> json) {
    status = ResponseStatusDTO.fromJson(json['status']);
    data = UserDataDTO.fromJson(json['data']);
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

class UserDataDTO {
  int? userId;
  bool? active;
  String? userName;
  String? firstName;
  String? lastName;
  String? emailId;
  String? phoneNumber;
  String? lastLoginTime;
  String? expireDate;
  bool? expireNotification;
  bool? userAccessMobile;
  int? tokenLimit;
  bool? isSendEmailAlert;
  bool? isFederalUser;
  String? preferredLang;
  String? preferredLangCode;
  String? preferredSite;
  String? preferredCompany;
  List<int>? roleIds;
  String? preferredLandingPage;
  String? preferredDays;
  List<ProjectVersionDTO>? projectVersionsDTOs;
  List<CustomerMapDataDTO>? customerMap;

  UserDataDTO(
      {this.userId,
      this.active,
      this.userName,
      this.firstName,
      this.lastName,
      this.emailId,
      this.phoneNumber,
      this.lastLoginTime,
      this.expireDate,
      this.expireNotification,
      this.userAccessMobile,
      this.tokenLimit,
      this.isSendEmailAlert,
      this.isFederalUser,
      this.preferredLang,
      this.preferredLangCode,
      this.preferredSite,
      this.preferredCompany,
      this.roleIds,
      this.preferredLandingPage,
      this.preferredDays,
      this.projectVersionsDTOs,
      this.customerMap});

  UserDataDTO.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    active = json['active'];
    userName = json['userName'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    emailId = json['emailId'];
    phoneNumber = json['phoneNumber'];
    lastLoginTime = json['lastLoginTime'];
    expireDate = json['expireDate'];
    expireNotification = json['expireNotification'];
    userAccessMobile = json['userAccessMobile'];
    tokenLimit = json['tokenLimit'];
    isSendEmailAlert = json['isSendEmailAlert'];
    isFederalUser = json['isFederalUser'];
    preferredLang = json['preferredLang'];
    preferredLangCode = json['preferredLangCode'];
    preferredSite = json['preferredSite'];
    preferredCompany = json['preferredCompany'];
    preferredLandingPage = json['preferredLandingPage'];
    preferredDays = json['preferredDays'];

    if (json['roleIds'] != null) {
      roleIds = [];
      json['roleIds'].forEach((v) {
        roleIds!.add(v);
      });
    }

    if (json['projectVersionsDTOs'] != null) {
      projectVersionsDTOs = [];
      json['projectVersionsDTOs'].forEach((v) {
        projectVersionsDTOs!.add(ProjectVersionDTO.fromJson(v));
      });
    }

    if (json['customerMap'] != null) {
      customerMap = [];
      json['customerMap'].forEach((v) {
        customerMap!.add(CustomerMapDataDTO.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['active'] = this.active;
    data['userName'] = this.userName;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['emailId'] = this.emailId;
    data['phoneNumber'] = this.phoneNumber;
    data['lastLoginTime'] = this.lastLoginTime;
    data['expireDate'] = this.expireDate;
    data['expireNotification'] = this.expireNotification;
    data['userAccessMobile'] = this.userAccessMobile;
    data['tokenLimit'] = this.tokenLimit;
    data['isSendEmailAlert'] = this.isSendEmailAlert;
    data['isFederalUser'] = this.isFederalUser;
    data['preferredLang'] = this.preferredLang;
    data['preferredLangCode'] = this.preferredLangCode;
    data['preferredSite'] = this.preferredSite;
    data['preferredCompany'] = this.preferredCompany;
    data['preferredLandingPage'] = this.preferredLandingPage;
    data['preferredDays'] = this.preferredDays;
    data['roleIds'] = this.roleIds;
    data['projectVersionsDTOs'] = this.projectVersionsDTOs;
    data['customerMap'] = this.customerMap;
    return data;
  }
}

class ProjectVersionDTO {
  String? companyId;
  String? siteId;
  String? defaultProjectId;
  List<ProjectVersionListDataDTO>? projectVersionList;

  ProjectVersionDTO(
      {this.companyId,
      this.siteId,
      this.defaultProjectId,
      this.projectVersionList});

  ProjectVersionDTO.fromJson(Map<String, dynamic> json) {
    companyId = json['companyId'];
    siteId = json['siteId'];
    defaultProjectId = json['defaultProjectId'];

    if (json['projectVersionList'] != null) {
      projectVersionList = [];
      json['projectVersionList'].forEach((v) {
        projectVersionList!.add(ProjectVersionListDataDTO.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['companyId'] = this.companyId;
    data['siteId'] = this.siteId;
    data['defaultProjectId'] = this.defaultProjectId;
    data['projectVersionList'] = this.projectVersionList;
    return data;
  }
}

class ProjectVersionListDataDTO {
  String? projectId;

  ProjectVersionListDataDTO({this.projectId});

  ProjectVersionListDataDTO.fromJson(Map<String, dynamic> json) {
    projectId = json['projectId'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['projectId'] = this.projectId;
    return data;
  }
}

class CustomerMapDataDTO {
  String? companyId;
  String? siteId;
  String? companyName;
  String? siteName;
  bool? isCompanySiteMapped;

  CustomerMapDataDTO(
      {this.companyId,
      this.siteId,
      this.companyName,
      this.siteName,
      this.isCompanySiteMapped});

  CustomerMapDataDTO.fromJson(Map<String, dynamic> json) {
    companyId = json['companyId'];
    siteId = json['siteId'];
    companyName = json['companyName'];
    siteName = json['siteName'];
    isCompanySiteMapped = json['isCompanySiteMapped'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['companyId'] = this.companyId;
    data['siteId'] = this.siteId;
    data['companyName'] = this.companyName;
    data['siteName'] = this.siteName;
    data['isCompanySiteMapped'] = this.isCompanySiteMapped;
    return data;
  }
}

class UpdatePreferredLanguageDTO {
  ResponseStatusDTO? status;
  int? errorCode;
  String? errorMessage;

  UpdatePreferredLanguageDTO({this.status, this.errorCode, this.errorMessage});

  UpdatePreferredLanguageDTO.fromJson(Map<String, dynamic> json) {
    status = ResponseStatusDTO.fromJson(json['status']);
    errorCode = json['errorCode'];
    errorMessage = json['errorMessage'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['errorCode'] = this.errorCode;
    data['errorMessage'] = this.errorMessage;
    return data;
  }
}

class PushTokenDTO {
  ResponseStatusDTO? status;
  int? errorCode;
  String? errorMessage;
  PushTokenDataDTO? data;

  PushTokenDTO({this.status, this.errorCode, this.errorMessage});

  PushTokenDTO.fromJson(Map<String, dynamic> json) {
    status = ResponseStatusDTO.fromJson(json['status']);
    errorCode = json['errorCode'];
    errorMessage = json['errorMessage'];
    data = PushTokenDataDTO.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['errorCode'] = this.errorCode;
    data['errorMessage'] = this.errorMessage;
    data['data'] = this.data;
    return data;
  }
}

class PushTokenDataDTO {
  String? tokenValue;
  String? tokenType;
  String? platformType;

  PushTokenDataDTO({this.tokenValue, this.tokenType, this.platformType});

  PushTokenDataDTO.fromJson(Map<String, dynamic> json) {
    tokenValue = json['tokenValue'];
    tokenType = json['tokenType'];
    platformType = json['platformType'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['tokenValue'] = this.tokenValue;
    data['tokenType'] = this.tokenType;
    data['platformType'] = this.platformType;
    return data;
  }
}
