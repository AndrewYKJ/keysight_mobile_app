import 'package:keysight_pma/model/response_status.dart';

class BoardResultCountsDTO {
  ResponseStatusDTO? status;
  List<BoardResultCountsDataDTO>? data;
  int? errorCode;
  String? errorMessage;

  BoardResultCountsDTO(
      {this.status, this.data, this.errorCode, this.errorMessage});

  BoardResultCountsDTO.fromJson(Map<String, dynamic> json) {
    status = ResponseStatusDTO.fromJson(json['status']);
    errorCode = json['errorCode'];
    errorMessage = json['errorMessage'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data!.add(BoardResultCountsDataDTO.fromJson(v));
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

class BoardResultCountsDataDTO {
  String? equipmentName;
  num? failed;
  num? firstPass;
  num? rework;
  String? date;
  num? pass;
  num? fail;
  String? fixtureId;
  num? firstPassYield;
  num? finalYield;
  num? volume;
  num? totBoardSerialNumber;

  BoardResultCountsDataDTO(
      {this.equipmentName,
      this.failed,
      this.firstPass,
      this.rework,
      this.date,
      this.pass,
      this.fail,
      this.fixtureId,
      this.firstPassYield,
      this.finalYield,
      this.volume,
      this.totBoardSerialNumber});

  BoardResultCountsDataDTO.fromJson(Map<String, dynamic> json) {
    equipmentName = json['equipmentName'];
    failed = json['failed'];
    firstPass = json['firstPass'];
    rework = json['rework'];
    date = json['date'];
    pass = json['pass'];
    fail = json['fail'];
    fixtureId = json['fixtureId'];
    firstPassYield = json['firstPassYield'];
    finalYield = json['finalYield'];
    volume = json['volume'];
    totBoardSerialNumber = json['totBoardSerialNumber'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['equipmentName'] = this.equipmentName;
    data['failed'] = this.failed;
    data['firstPass'] = this.firstPass;
    data['rework'] = this.rework;
    data['date'] = this.date;
    data['pass'] = this.pass;
    data['fail'] = this.fail;
    data['fixtureId'] = this.fixtureId;
    data['firstPassYield'] = this.firstPassYield;
    data['finalYield'] = this.finalYield;
    data['volume'] = this.volume;
    data['totBoardSerialNumber'] = this.totBoardSerialNumber;
    return data;
  }
}
