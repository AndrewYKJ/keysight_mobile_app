import 'package:keysight_pma/model/response_status.dart';

class TestTimeDistributionDTO {
  ResponseStatusDTO? status;
  TestTimeDistributionDataDTO? data;
  int? errorCode;
  String? errorMessage;

  TestTimeDistributionDTO(
      {this.status, this.data, this.errorCode, this.errorMessage});

  TestTimeDistributionDTO.fromJson(Map<String, dynamic> json) {
    status = ResponseStatusDTO.fromJson(json['status']);
    data = TestTimeDistributionDataDTO.fromJson(json['data']);
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

class TestTimeDistributionDataDTO {
  DataDTO? pass;
  DataDTO? all;
  DataDTO? fail;

  TestTimeDistributionDataDTO({this.pass, this.all, this.fail});

  TestTimeDistributionDataDTO.fromJson(Map<String, dynamic> json) {
    pass = DataDTO.fromJson(json['pass']);
    all = DataDTO.fromJson(json['all']);
    fail = DataDTO.fromJson(json['fail']);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['pass'] = this.pass;
    data['all'] = this.all;
    data['fail'] = this.fail;
    return data;
  }
}

class DataDTO {
  String? label;
  List<BoxPlotDataDTO>? boxPlotData;
  List<PointDataDTO>? pointData;

  DataDTO({this.label, this.boxPlotData, this.pointData});

  DataDTO.fromJson(Map<String, dynamic> json) {
    label = json['label'];

    if (json['boxPlotData'] != null) {
      boxPlotData = [];
      json['boxPlotData'].forEach((v) {
        boxPlotData!.add(BoxPlotDataDTO.fromJson(v));
      });
    }

    if (json['pointData'] != null) {
      pointData = [];
      json['pointData'].forEach((v) {
        pointData!.add(PointDataDTO.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this.label;
    data['boxPlotData'] = this.boxPlotData;
    data['pointData'] = this.pointData;
    return data;
  }
}

class BoxPlotDataDTO {
  String? name;
  num? x;
  num? q1;
  num? q3;
  num? low;
  num? high;
  num? mean;
  num? median;

  BoxPlotDataDTO(
      {this.name,
      this.x,
      this.q1,
      this.q3,
      this.low,
      this.high,
      this.mean,
      this.median});

  BoxPlotDataDTO.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    x = json['x'];
    q1 = json['q1'];
    q3 = json['q3'];
    low = json['low'];
    high = json['high'];
    mean = json['mean'];
    median = json['median'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['x'] = this.x;
    data['q1'] = this.q1;
    data['q3'] = this.q3;
    data['low'] = this.low;
    data['high'] = this.high;
    data['mean'] = this.mean;
    data['median'] = this.median;
    return data;
  }
}

class PointDataDTO {
  num? x;
  num? y;
  List<String>? outliers;
  num? numberOfOutliers;

  PointDataDTO({this.x, this.y, this.outliers, this.numberOfOutliers});

  PointDataDTO.fromJson(Map<String, dynamic> json) {
    x = json['x'];
    y = json['y'];
    numberOfOutliers = json['numberOfOutliers'];

    if (json['outliers'] != null) {
      outliers = [];
      json['outliers'].forEach((v) {
        outliers!.add(v);
      });
    }
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['x'] = this.x;
    data['y'] = this.y;
    data['outliers'] = this.outliers;
    data['numberOfOutliers'] = this.numberOfOutliers;
    return data;
  }
}
