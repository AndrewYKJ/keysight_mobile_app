import 'package:keysight_pma/model/response_status.dart';

class AlertProbeDTO {
  ResponseStatusDTO? status;
  AlertProbeDataDTO? data;
  int? errorCode;
  String? errorMessage;

  AlertProbeDTO({this.status, this.data, this.errorCode, this.errorMessage});

  AlertProbeDTO.fromJson(Map<String, dynamic> json) {
    status = ResponseStatusDTO.fromJson(json['status']);
    data = AlertProbeDataDTO.fromJson(json['data']);
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

class AlertProbeDataDTO {
  List<AlertFixtureMapDTO>? fixtureMaps;
  List<AlertFixtureMapDTO>? fixtureMapsAnomaly;
  List<AlertFixtureOutlineDataDTO>? fixtureOutlineDTOs;
  String? latestAnomalyTimestamp;
  num? anomalyCount;
  num? heatMapValue;

  AlertProbeDataDTO(
      {this.fixtureMaps,
      this.fixtureMapsAnomaly,
      this.fixtureOutlineDTOs,
      this.latestAnomalyTimestamp,
      this.anomalyCount,
      this.heatMapValue});

  AlertProbeDataDTO.fromJson(Map<String, dynamic> json) {
    latestAnomalyTimestamp = json['latestAnomalyTimestamp'];
    anomalyCount = json['anomalyCount'];
    heatMapValue = json['heatMapValue'];

    if (json['fixtureMaps'] != null) {
      fixtureMaps = [];
      json['fixtureMaps'].forEach((v) {
        fixtureMaps!.add(AlertFixtureMapDTO.fromJson(v));
      });
    }

    if (json['fixtureMapsAnomaly'] != null) {
      fixtureMapsAnomaly = [];
      json['fixtureMapsAnomaly'].forEach((v) {
        fixtureMapsAnomaly!.add(AlertFixtureMapDTO.fromJson(v));
      });
    }

    if (json['fixtureOutlineDTOs'] != null) {
      fixtureOutlineDTOs = [];
      json['fixtureOutlineDTOs'].forEach((v) {
        fixtureOutlineDTOs!.add(AlertFixtureOutlineDataDTO.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['fixtureMaps'] = this.fixtureMaps;
    data['fixtureMapsAnomaly'] = this.fixtureMapsAnomaly;
    data['fixtureOutlineDTOs'] = this.fixtureOutlineDTOs;
    data['latestAnomalyTimestamp'] = this.latestAnomalyTimestamp;
    data['heatMapValue'] = this.heatMapValue;
    data['anomalyCount'] = this.anomalyCount;
    return data;
  }
}

class AlertFixtureMapDTO {
  String? brcNumber;
  String? cpk;
  String? lastFailedCount;
  String? node;
  String? probeId;
  String? probeProperty;
  List<String>? testNames;
  num? value;
  String? worstTestName;
  int? x;
  int? y;

  AlertFixtureMapDTO(
      {this.brcNumber,
      this.cpk,
      this.lastFailedCount,
      this.node,
      this.probeId,
      this.probeProperty,
      this.testNames,
      this.value,
      this.worstTestName,
      this.x,
      this.y});

  AlertFixtureMapDTO.fromJson(Map<String, dynamic> json) {
    brcNumber = json['brcNumber'];
    cpk = json['cpk'];
    lastFailedCount = json['lastFailedCount'];
    node = json['node'];
    probeId = json['probeId'];
    probeProperty = json['probeProperty'];
    value = json['value'];
    worstTestName = json['worstTestName'];
    x = json['x'];
    y = json['y'];

    if (json['testNames'] != null) {
      testNames = [];
      json['testNames'].forEach((v) {
        testNames!.add(v);
      });
    }
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['brcNumber'] = this.brcNumber;
    data['cpk'] = this.cpk;
    data['lastFailedCount'] = this.lastFailedCount;
    data['node'] = this.node;
    data['probeId'] = this.probeId;
    data['probeProperty'] = this.probeProperty;
    data['testNames'] = this.testNames;
    data['value'] = this.value;
    data['worstTestName'] = this.worstTestName;
    data['x'] = this.x;
    data['y'] = this.y;
    return data;
  }
}

class AlertFixtureOutlineDataDTO {
  String? id;
  String? ratio;
  List<List<int>>? xy;
  AlertFixtureOutlineDataDTO({this.id, this.ratio, this.xy});

  factory AlertFixtureOutlineDataDTO.fromJson(Map<String, dynamic> json) =>
      AlertFixtureOutlineDataDTO(
        id: json["id"],
        ratio: json["ratio"],
        xy: List<List<int>>.from(
            json["xy"].map((x) => List<int>.from(x.map((x) => x)))),
      );
  // AlertFixtureOutlineDataDTO.fromJson(Map<String, dynamic> json) {
  //   id = json['id'];
  //   ratio = json['ratio'];

  //   if (json['xy'] != null) {
  //     xy = [];
  //     json['xy'].forEach((v) {
  //       xy!.add(int.parse(v));
  //     });
  //   }
  // }

  Map<String, dynamic> toJson() => {
        "id": id,
        "ratio": ratio,
        "xy": List<dynamic>.from(
            xy!.map((x) => List<dynamic>.from(x.map((x) => x)))),
      };
}

class AlertProbeNodeDTO {
  ResponseStatusDTO? status;
  AlertProbeNodeDataDTO? data;
  int? errorCode;
  String? errorMessage;

  AlertProbeNodeDTO(
      {this.status, this.data, this.errorCode, this.errorMessage});

  AlertProbeNodeDTO.fromJson(Map<String, dynamic> json) {
    status = ResponseStatusDTO.fromJson(json['status']);
    data = AlertProbeNodeDataDTO.fromJson(json['data']);
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

class AlertProbeNodeDataDTO {
  AlertProbeNodeDataDTO({
    this.companyId,
    this.siteId,
    this.projectId,
    this.node,
    this.pin,
    this.probeId,
    this.transferPin,
    this.personalityPin,
  });

  String? companyId;
  String? siteId;
  String? projectId;
  String? node;
  List<String>? pin;
  List<String>? probeId;
  List<String>? transferPin;
  List<String>? personalityPin;

  AlertProbeNodeDataDTO.fromJson(Map<String, dynamic> json) {
    companyId = json['companyId'];
    siteId = json['siteId'];
    node = json['node'];
    projectId = json['projectId'];

    if (json['pin'] != null) {
      pin = [];
      json['pin'].forEach((v) {
        pin!.add(v);
      });
    }

    if (json['probeId'] != null) {
      probeId = [];
      json['probeId'].forEach((v) {
        probeId!.add(v);
      });
    }

    if (json['transferPin'] != null) {
      transferPin = [];
      json['transferPin'].forEach((v) {
        transferPin!.add(v);
      });
    }

    if (json['personalityPin'] != null) {
      personalityPin = [];
      json['personalityPin'].forEach((v) {
        personalityPin!.add(v);
      });
    }
  }
}
