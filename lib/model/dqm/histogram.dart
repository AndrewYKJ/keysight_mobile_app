import 'package:keysight_pma/model/response_status.dart';

class HistogramDTO {
  ResponseStatusDTO? status;
  HistrogramDataDTO? data;
  int? errorCode;
  String? errorMessage;

  HistogramDTO({this.status, this.data, this.errorCode, this.errorMessage});

  HistogramDTO.fromJson(Map<String, dynamic> json) {
    status = ResponseStatusDTO.fromJson(json['status']);
    data = HistrogramDataDTO.fromJson(json['data']);
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

class HistrogramDataDTO {
  num? lowerLimit;
  num? upperLimit;
  num? cpk;
  num? stdDeviation;
  num? mean;
  num? meanPlus1Std;
  num? meanPlus2Std;
  num? meanPlus3Std;
  num? meanMinus1Std;
  num? meanMinus2Std;
  num? meanMinus3Std;
  num? min;
  num? max;
  List<dynamic>? valueFrequency;
  List<BinListDataDTO>? binList;

  HistrogramDataDTO(
      {this.lowerLimit,
      this.upperLimit,
      this.cpk,
      this.stdDeviation,
      this.mean,
      this.meanPlus1Std,
      this.meanPlus2Std,
      this.meanPlus3Std,
      this.meanMinus1Std,
      this.meanMinus2Std,
      this.meanMinus3Std,
      this.min,
      this.max,
      this.valueFrequency,
      this.binList});

  HistrogramDataDTO.fromJson(Map<String, dynamic> json) {
    lowerLimit = json['lowerLimit'];
    upperLimit = json['upperLimit'];
    cpk = json['cpk'];
    stdDeviation = json['stdDeviation'];
    mean = json['mean'];
    meanPlus1Std = json['meanPlus1Std'];
    meanPlus2Std = json['meanPlus2Std'];
    meanPlus3Std = json['meanPlus3Std'];
    meanMinus1Std = json['meanMinus1Std'];
    meanMinus2Std = json['meanMinus2Std'];
    meanMinus3Std = json['meanMinus3Std'];
    min = json['min'];
    max = json['max'];
    if (json['binList'] != null) {
      binList = [];
      json['binList'].forEach((v) {
        binList!.add(BinListDataDTO.fromJson(v));
      });
    }

    // if (json['valueFrequency'] != null) {
    //   valueFrequency = [];
    //   json['valueFrequency'].forEach((v) {
    //     valueFrequency!.add(v);
    //   });
    // }
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['lowerLimit'] = this.lowerLimit;
    data['upperLimit'] = this.upperLimit;
    data['cpk'] = this.cpk;
    data['stdDeviation'] = this.stdDeviation;
    data['mean'] = this.mean;
    data['meanPlus1Std'] = this.meanPlus1Std;
    data['meanPlus2Std'] = this.meanPlus2Std;
    data['meanPlus3Std'] = this.meanPlus3Std;
    data['meanMinus1Std'] = this.meanMinus1Std;
    data['meanMinus2Std'] = this.meanMinus2Std;
    data['meanMinus3Std'] = this.meanMinus3Std;
    data['min'] = this.min;
    data['max'] = this.max;
    data['binList'] = this.binList;
    data['valueFrequency'] = this.valueFrequency;
    return data;
  }
}

class BinListDataDTO {
  num? start;
  num? end;
  num? value;

  BinListDataDTO({this.start, this.end, this.value});

  BinListDataDTO.fromJson(Map<String, dynamic> json) {
    start = json['start'];
    end = json['end'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['start'] = this.start;
    data['end'] = this.end;
    data['value'] = this.value;
    return data;
  }
}
