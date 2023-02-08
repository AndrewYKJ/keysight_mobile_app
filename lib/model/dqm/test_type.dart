import 'package:keysight_pma/model/response_status.dart';

class TestTypeDTO {
  ResponseStatusDTO? status;
  List<String>? data;
  int? errorCode;
  String? errorMessage;

  TestTypeDTO({this.status, this.data, this.errorCode, this.errorMessage});

  TestTypeDTO.fromJson(Map<String, dynamic> json) {
    status = ResponseStatusDTO.fromJson(json['status']);
    errorCode = json['errorCode'];
    errorMessage = json['errorMessage'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data!.add(v);
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
