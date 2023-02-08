import 'package:keysight_pma/model/response_status.dart';

class OeeInstallbaseNotifDTO {
  ResponseStatusDTO? status;
  OeeInstallbaseNotifDataDTO? data;
  int? errorCode;
  String? errorMessage;

  OeeInstallbaseNotifDTO(
      {this.status, this.data, this.errorCode, this.errorMessage});

  OeeInstallbaseNotifDTO.fromJson(Map<String, dynamic> json) {
    status = ResponseStatusDTO.fromJson(json['status']);
    data = OeeInstallbaseNotifDataDTO.fromJson(json['data']);
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

class OeeInstallbaseNotifDataDTO {
  // ignore: non_constant_identifier_names
  int? DUTCpkAlertAnomalies;
  // ignore: non_constant_identifier_names
  int? DUTGoldenBoard;
  // ignore: non_constant_identifier_names
  int? DUTLimitChangeAnomaly;
  // ignore: non_constant_identifier_names
  int? DUTComponentAnomaly;
  // ignore: non_constant_identifier_names
  int? DUTPatLimitAnomalies;
  int? fanRegression;
  // ignore: non_constant_identifier_names
  int? DUTAnomalyDetection;
  // ignore: non_constant_identifier_names
  int? DUTPatLimitRecommendation;
  // ignore: non_constant_identifier_names
  int? DUTDegradationAnomaly;
  // ignore: non_constant_identifier_names
  int? Sensor;

  OeeInstallbaseNotifDataDTO(
      // ignore: non_constant_identifier_names
      {this.DUTCpkAlertAnomalies,
      // ignore: non_constant_identifier_names
      this.DUTGoldenBoard,
      // ignore: non_constant_identifier_names
      this.DUTLimitChangeAnomaly,
      // ignore: non_constant_identifier_names
      this.DUTComponentAnomaly,
      // ignore: non_constant_identifier_names
      this.DUTPatLimitAnomalies,
      this.fanRegression,
      // ignore: non_constant_identifier_names
      this.DUTAnomalyDetection,
      // ignore: non_constant_identifier_names
      this.DUTPatLimitRecommendation,
      // ignore: non_constant_identifier_names
      this.DUTDegradationAnomaly,
      // ignore: non_constant_identifier_names
      this.Sensor});

  OeeInstallbaseNotifDataDTO.fromJson(Map<String, dynamic> json) {
    DUTCpkAlertAnomalies = json['DUTCpkAlertAnomalies'] as int;
    DUTGoldenBoard = json['DUTGoldenBoard'] as int;
    DUTLimitChangeAnomaly = json['DUTLimitChangeAnomaly'] as int;
    DUTComponentAnomaly = json['DUTComponentAnomaly'] as int;
    DUTPatLimitAnomalies = json['DUTPatLimitAnomalies'] as int;
    fanRegression = json['fanRegression'] as int;
    DUTAnomalyDetection = json['DUTAnomalyDetection'] as int;
    DUTPatLimitRecommendation = json['DUTPatLimitRecommendation'] as int;
    DUTDegradationAnomaly = json['DUTDegradationAnomaly'] as int;
    Sensor = json['Sensor'] as int;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['DUTCpkAlertAnomalies'] = this.DUTCpkAlertAnomalies;
    data['DUTGoldenBoard'] = this.DUTGoldenBoard;
    data['DUTLimitChangeAnomaly'] = this.DUTLimitChangeAnomaly;
    data['DUTComponentAnomaly'] = this.DUTComponentAnomaly;
    data['DUTPatLimitAnomalies'] = this.DUTPatLimitAnomalies;
    data['fanRegression'] = this.fanRegression;
    data['DUTAnomalyDetection'] = this.DUTAnomalyDetection;
    data['DUTPatLimitRecommendation'] = this.DUTPatLimitRecommendation;
    data['DUTDegradationAnomaly'] = this.DUTDegradationAnomaly;
    data['Sensor'] = this.Sensor;
    return data;
  }
}
