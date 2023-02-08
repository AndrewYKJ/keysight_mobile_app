import 'package:keysight_pma/model/response_status.dart';

class OeeSummaryPerecentageDTO {
  ResponseStatusDTO? status;
  OeeSummaryPerecentageDataDTO? data;
  int? errorCode;
  String? errorMessage;

  OeeSummaryPerecentageDTO(
      {this.status, this.data, this.errorCode, this.errorMessage});

  OeeSummaryPerecentageDTO.fromJson(Map<String, dynamic> json) {
    status = ResponseStatusDTO.fromJson(json['status']);
    data = OeeSummaryPerecentageDataDTO.fromJson(json['data']);
    errorCode = json['errorCode'];
    errorMessage = json['errorMessage'];
  }
}

class OeeSummaryPerecentageDataDTO {
  OeeSummaryPerecentageDataDTO({
    this.quality,
    this.oee,
    this.performance,
    this.availability,
  });

  double? quality;
  double? oee;
  double? performance;
  double? availability;

  OeeSummaryPerecentageDataDTO.fromJson(Map<String, dynamic> json) {
    quality = json["quality"];
    oee = json["oee"];
    performance = json["performance"];
    availability = json["availability"];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['quality'] = this.quality;
    data['oee'] = this.oee;
    data['performance'] = this.performance;
    data['availability'] = this.availability;

    return data;
  }
}
