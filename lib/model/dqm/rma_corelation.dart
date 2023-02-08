import 'package:keysight_pma/model/dqm/test_result_testname.dart';
import 'package:keysight_pma/model/response_status.dart';

class RmaCoRelationDTO {
  ResponseStatusDTO? status;
  RmaCoRelationDataDTO? data;
  int? errorCode;
  String? errorMessage;

  RmaCoRelationDTO({this.status, this.data, this.errorCode, this.errorMessage});

  RmaCoRelationDTO.fromJson(Map<String, dynamic> json) {
    status = ResponseStatusDTO.fromJson(json['status']);
    data = RmaCoRelationDataDTO.fromJson(json['data']);
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

class RmaCoRelationDataDTO {
  List<TestResultTestNameDataDTO>? TestOne;
  List<TestResultTestNameDataDTO>? TestTwo;

  RmaCoRelationDataDTO({this.TestOne, this.TestTwo});

  RmaCoRelationDataDTO.fromJson(Map<String, dynamic> json) {
    if (json['TestOne'] != null) {
      TestOne = [];
      json['TestOne'].forEach((v) {
        TestOne!.add(TestResultTestNameDataDTO.fromJson(v));
      });
    }

    if (json['TestTwo'] != null) {
      TestTwo = [];
      json['TestTwo'].forEach((v) {
        TestTwo!.add(TestResultTestNameDataDTO.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['TestOne'] = this.TestOne;
    data['TestTwo'] = this.TestTwo;
    return data;
  }
}
