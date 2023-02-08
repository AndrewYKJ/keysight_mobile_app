import 'package:keysight_pma/model/response_status.dart';

class DailyBoardVolumeDTO {
  ResponseStatusDTO? status;
  List<DailyBoardVolumeDataDTO>? data;
  int? errorCode;
  String? errorMessage;

  DailyBoardVolumeDTO(
      {this.status, this.data, this.errorCode, this.errorMessage});

  DailyBoardVolumeDTO.fromJson(Map<String, dynamic> json) {
    status = ResponseStatusDTO.fromJson(json['status']);
    errorCode = json['errorCode'];
    errorMessage = json['errorMessage'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data!.add(DailyBoardVolumeDataDTO.fromJson(v));
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

class DailyBoardVolumeDataDTO {
  String? date;
  double? failed;
  double? firstPass;
  double? rework;

  DailyBoardVolumeDataDTO(
      {this.date, this.failed, this.firstPass, this.rework});

  DailyBoardVolumeDataDTO.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    failed = json['failed'];
    firstPass = json['firstPass'];
    rework = json['rework'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['failed'] = this.failed;
    data['firstPass'] = this.firstPass;
    data['rework'] = this.rework;
    return data;
  }
}
