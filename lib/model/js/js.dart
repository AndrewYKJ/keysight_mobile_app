import 'package:keysight_pma/model/dqm/test_result_change_limit.dart';

class JSDailyBoardVolumeDataDTO {
  String? date;
  int? failed;
  int? firstPass;
  int? rework;

  JSDailyBoardVolumeDataDTO(
      {this.date, this.failed, this.firstPass, this.rework});

  JSDailyBoardVolumeDataDTO.fromJson(Map<String, dynamic> json) {
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

class JSFirstPassYieldDataDTO {
  String? date;
  double? firstPassYield;

  JSFirstPassYieldDataDTO({this.date, this.firstPassYield});

  JSFirstPassYieldDataDTO.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    firstPassYield = json['firstPassYield'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['firstPassYield'] = this.firstPassYield;
    return data;
  }
}

class JSYieldDataByProjectDTO {
  String? date;
  List<JSYieldDataByProjectDataDTO>? data;

  JSYieldDataByProjectDTO({this.date, this.data});

  JSYieldDataByProjectDTO.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data!.add(JSYieldDataByProjectDataDTO.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['data'] = this.data;

    return data;
  }
}

class JSYieldDataByProjectDataDTO {
  num? yieldValue;
  String? projectName;
  String? colorCode;

  JSYieldDataByProjectDataDTO(
      {this.yieldValue, this.projectName, this.colorCode});

  JSYieldDataByProjectDataDTO.fromJson(Map<String, dynamic> json) {
    yieldValue = json['yieldValue'];
    projectName = json['projectName'];
    colorCode = json['colorCode'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['yieldValue'] = this.yieldValue;
    data['projectName'] = this.projectName;
    data['colorCode'] = this.colorCode;
    return data;
  }
}

class JSWorstTestNameByProjectDTO {
  String? projectName;
  List<JSWorstTestNameByProjectDataDTO>? data;

  JSWorstTestNameByProjectDTO({this.projectName, this.data});

  JSWorstTestNameByProjectDTO.fromJson(Map<String, dynamic> json) {
    projectName = json['projectName'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data!.add(JSWorstTestNameByProjectDataDTO.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['projectName'] = this.projectName;
    data['data'] = this.data;
    return data;
  }
}

class JSWorstTestNameByProjectDataDTO {
  String? testname;
  num? failedCount;
  String? colorCode;
  String? testtype;
  String? projectId;

  JSWorstTestNameByProjectDataDTO(
      {this.testname,
      this.failedCount,
      this.colorCode,
      this.testtype,
      this.projectId});

  JSWorstTestNameByProjectDataDTO.fromJson(Map<String, dynamic> json) {
    testname = json['testname'];
    failedCount = json['failedCount'];
    colorCode = json['colorCode'];
    testtype = json['testtype'];
    projectId = json['projectId'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['testname'] = this.testname;
    data['failedCount'] = this.failedCount;
    data['colorCode'] = this.colorCode;
    data['testtype'] = this.testtype;
    data['projectId'] = this.projectId;
    return data;
  }
}

class JSMetricQualityDataDTO {
  String? date;
  num? failed;
  num? firstPass;
  num? finalYield;
  num? volume;

  JSMetricQualityDataDTO(
      {this.date, this.failed, this.firstPass, this.finalYield, this.volume});

  JSMetricQualityDataDTO.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    failed = json['failed'];
    firstPass = json['firstPass'];
    finalYield = json['finalYield'];
    volume = json['volume'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['failed'] = this.failed;
    data['firstPass'] = this.firstPass;
    data['finalYield'] = this.finalYield;
    data['volume'] = this.volume;
    return data;
  }
}

class JSMetricQualityByProjectDataDTO {
  String? projectId;
  num? value;

  JSMetricQualityByProjectDataDTO({this.projectId, this.value});

  JSMetricQualityByProjectDataDTO.fromJson(Map<String, dynamic> json) {
    projectId = json['projectId'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['projectId'] = this.projectId;
    data['value'] = this.value;
    return data;
  }
}

class JSMetricQualityByEquipmentDataDTO {
  String? equipmentName;
  num? value;

  JSMetricQualityByEquipmentDataDTO({this.equipmentName, this.value});

  JSMetricQualityByEquipmentDataDTO.fromJson(Map<String, dynamic> json) {
    equipmentName = json['equipmentName'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['equipmentName'] = this.equipmentName;
    data['value'] = this.value;
    return data;
  }
}

class JSTestResultVolumeDataDTO {
  String? equipmentName;
  num? fail;
  num? firstPass;
  num? rework;
  num? firstPassYield;
  num? finalYield;

  JSTestResultVolumeDataDTO(
      {this.equipmentName,
      this.fail,
      this.firstPass,
      this.rework,
      this.firstPassYield,
      this.finalYield});

  JSTestResultVolumeDataDTO.fromJson(Map<String, dynamic> json) {
    equipmentName = json['equipmentName'];
    fail = json['fail'];
    firstPass = json['firstPass'];
    rework = json['rework'];
    firstPassYield = json['firstPassYield'];
    finalYield = json['finalYield'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['equipmentName'] = this.equipmentName;
    data['fail'] = this.fail;
    data['firstPass'] = this.firstPass;
    data['rework'] = this.rework;
    data['firstPassYield'] = this.firstPassYield;
    data['finalYield'] = this.finalYield;
    return data;
  }
}

class JSTestResultTestTimeDataDTO {
  String? name;
  num? high;
  num? q3;
  num? median;
  num? q1;
  num? low;
  num? x;
  num? y;
  List<String>? outliers;
  num? numberOfOutliers;
  bool? isClickScatter;

  JSTestResultTestTimeDataDTO(
      {this.name,
      this.high,
      this.q3,
      this.median,
      this.q1,
      this.low,
      this.x,
      this.y,
      this.outliers,
      this.numberOfOutliers,
      this.isClickScatter});

  JSTestResultTestTimeDataDTO.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    high = json['high'];
    q3 = json['q3'];
    median = json['median'];
    q1 = json['q1'];
    low = json['low'];
    x = json['x'];
    y = json['y'];
    numberOfOutliers = json['numberOfOutliers'];
    isClickScatter = json['isClickScatter'];

    if (json['outliers'] != null) {
      outliers = [];
      json['outliers'].forEach((v) {
        outliers!.add(v as String);
      });
    }
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['high'] = this.high;
    data['q3'] = this.q3;
    data['median'] = this.median;
    data['q1'] = this.q1;
    data['low'] = this.low;
    data['x'] = this.x;
    data['y'] = this.y;
    data['outliers'] = this.outliers;
    data['numberOfOutliers'] = this.numberOfOutliers;
    data['isClickScatter'] = this.isClickScatter;
    return data;
  }
}

class JSFinalDistributionDataDTO {
  String? firstStatus;
  num? count;
  String? lastStatus;
  String? colorCode;

  JSFinalDistributionDataDTO(
      {this.firstStatus, this.count, this.lastStatus, this.colorCode});

  JSFinalDistributionDataDTO.fromJson(Map<String, dynamic> json) {
    firstStatus = json['firstStatus'];
    count = json['count'];
    lastStatus = json['lastStatus'];
    colorCode = json['colorCode'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['firstStatus'] = this.firstStatus;
    data['count'] = this.count;
    data['lastStatus'] = this.lastStatus;
    data['colorCode'] = this.colorCode;
    return data;
  }
}

class JSTestTypeWorstTestNameDataDTO {
  String? testType;
  String? fixtureId;

  JSTestTypeWorstTestNameDataDTO({this.testType, this.fixtureId});

  JSTestTypeWorstTestNameDataDTO.fromJson(Map<String, dynamic> json) {
    testType = json['testType'];
    fixtureId = json['fixtureId'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['testType'] = this.testType;
    data['fixtureId'] = this.fixtureId;
    return data;
  }
}

class JSCpkDataDTO {
  String? date;
  num? cpkValue;

  JSCpkDataDTO({this.date, this.cpkValue});

  JSCpkDataDTO.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    cpkValue = json['cpkValue'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['cpkValue'] = this.cpkValue;
    return data;
  }
}

class JSCpkSigmaDataDTO {
  String? sixSigma;
  String? sixSigmaValue;
  String? fiveSigma;
  String? fiveSigmaValue;
  String? fourSigma;
  String? fourSigmaValue;
  String? threeSigma;
  String? threeSigmaValue;
  String? otherSigma;
  String? otherSigmaValue;

  JSCpkSigmaDataDTO(
      {this.sixSigma,
      this.sixSigmaValue,
      this.fiveSigma,
      this.fiveSigmaValue,
      this.fourSigma,
      this.fourSigmaValue,
      this.threeSigma,
      this.threeSigmaValue,
      this.otherSigma,
      this.otherSigmaValue});

  JSCpkSigmaDataDTO.fromJson(Map<String, dynamic> json) {
    sixSigma = json['sixSigma'];
    sixSigmaValue = json['sixSigmaValue'];
    fiveSigma = json['fiveSigma'];
    fiveSigmaValue = json['fiveSigmaValue'];
    fourSigma = json['fourSigma'];
    fourSigmaValue = json['fourSigmaValue'];
    threeSigma = json['threeSigma'];
    threeSigmaValue = json['threeSigmaValue'];
    otherSigma = json['otherSigma'];
    otherSigmaValue = json['otherSigmaValue'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['sixSigma'] = this.sixSigma;
    data['sixSigmaValue'] = this.sixSigmaValue;
    data['fiveSigma'] = this.fiveSigma;
    data['fiveSigmaValue'] = this.fiveSigmaValue;
    data['fourSigma'] = this.fourSigma;
    data['fourSigmaValue'] = this.fourSigmaValue;
    data['threeSigma'] = this.threeSigma;
    data['threeSigmaValue'] = this.threeSigmaValue;
    data['otherSigma'] = this.otherSigma;
    data['otherSigmaValue'] = this.otherSigmaValue;
    return data;
  }
}

class JSTestNameCpkDataDTO {
  String? testname;
  String? sigmaType;
  num? value;
  String? colorCode;

  JSTestNameCpkDataDTO(
      {this.testname, this.sigmaType, this.value, this.colorCode});

  JSTestNameCpkDataDTO.fromJson(Map<String, dynamic> json) {
    testname = json['testname'];
    sigmaType = json['sigmaType'];
    value = json['value'];
    colorCode = json['colorCode'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['testname'] = this.testname;
    data['sigmaType'] = this.sigmaType;
    data['value'] = this.value;
    data['colorCode'] = this.colorCode;
    return data;
  }
}

class JSHistogramDataDTO {
  num? binStart;
  num? binValue;
  String? name;
  num? value;
  String? colorCode;

  JSHistogramDataDTO(
      {this.binStart, this.binValue, this.name, this.value, this.colorCode});

  JSHistogramDataDTO.fromJson(Map<String, dynamic> json) {
    binStart = json['binStart'];
    binValue = json['binValue'];
    name = json['name'];
    value = json['value'];
    colorCode = json['colorCode'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['binStart'] = this.binStart;
    data['binValue'] = this.binValue;
    data['name'] = this.name;
    data['value'] = this.value;
    data['colorCode'] = this.colorCode;
    return data;
  }
}

class JSAlertAccuracyStatusDTO {
  String? status;
  num? highTotal;
  num? medTotal;
  num? lowTotal;
  num? otherTotal;
  String? colorCode;

  JSAlertAccuracyStatusDTO(
      {this.status,
      this.highTotal,
      this.medTotal,
      this.lowTotal,
      this.otherTotal,
      this.colorCode});

  JSAlertAccuracyStatusDTO.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    highTotal = json['highTotal'];
    medTotal = json['medTotal'];
    lowTotal = json['lowTotal'];
    otherTotal = json['otherTotal'];
    colorCode = json['colorCode'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['highTotal'] = this.highTotal;
    data['medTotal'] = this.medTotal;
    data['lowTotal'] = this.lowTotal;
    data['otherTotal'] = this.otherTotal;
    data['colorCode'] = this.colorCode;
    return data;
  }
}

class JSLimitChangeDTO {
  bool? isLimiChange;
  TestResultChangeLimitDataDTO? changeLimitDataDTO;

  JSLimitChangeDTO({
    this.isLimiChange,
    this.changeLimitDataDTO,
  });

  JSLimitChangeDTO.fromJson(Map<String, dynamic> json) {
    isLimiChange = json['isLimiChange'];
    changeLimitDataDTO =
        TestResultChangeLimitDataDTO.fromJson(json['changeLimitDataDTO']);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['isLimiChange'] = this.isLimiChange;
    data['changeLimitDataDTO'] = this.changeLimitDataDTO;
    return data;
  }
}
