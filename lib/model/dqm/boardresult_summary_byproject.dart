import 'package:keysight_pma/model/dqm/boardresult_counts.dart';
import 'package:keysight_pma/model/response_status.dart';

class BoardResultSummaryByProjectDTO {
  ResponseStatusDTO? status;
  BoardResultSummaryByProjectDataDTO? data;
  int? errorCode;
  String? errorMessage;

  BoardResultSummaryByProjectDTO(
      {this.status, this.data, this.errorCode, this.errorMessage});

  BoardResultSummaryByProjectDTO.fromJson(Map<String, dynamic> json) {
    status = ResponseStatusDTO.fromJson(json['status']);
    data = BoardResultSummaryByProjectDataDTO.fromJson(json['data']);
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

class BoardResultSummaryByProjectDataDTO {
  List<BoardResultCountsDataDTO>? volumeByEquipmentFixture;
  List<BoardResultCountsDataDTO>? volumeByEquipment;
  ProjectSummaryDataDTO? projectSummary;
  List<FinalDispositionStructDataDTO>? finalDispositionStruct;

  BoardResultSummaryByProjectDataDTO(
      {this.volumeByEquipmentFixture,
      this.volumeByEquipment,
      this.projectSummary,
      this.finalDispositionStruct});

  BoardResultSummaryByProjectDataDTO.fromJson(Map<String, dynamic> json) {
    projectSummary = ProjectSummaryDataDTO.fromJson(json['projectSummary']);

    if (json['volumeByEquipmentFixture'] != null) {
      volumeByEquipmentFixture = [];
      json['volumeByEquipmentFixture'].forEach((v) {
        volumeByEquipmentFixture!.add(BoardResultCountsDataDTO.fromJson(v));
      });
    }

    if (json['volumeByEquipment'] != null) {
      volumeByEquipment = [];
      json['volumeByEquipment'].forEach((v) {
        volumeByEquipment!.add(BoardResultCountsDataDTO.fromJson(v));
      });
    }

    if (json['finalDispositionStruct'] != null) {
      finalDispositionStruct = [];
      json['finalDispositionStruct'].forEach((v) {
        finalDispositionStruct!.add(FinalDispositionStructDataDTO.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['volumeByEquipmentFixture'] = this.volumeByEquipmentFixture;
    data['volumeByEquipment'] = this.volumeByEquipment;
    data['projectSummary'] = this.projectSummary;
    data['finalDispositionStruct'] = this.finalDispositionStruct;
    return data;
  }
}

class ProjectSummaryDataDTO {
  num? totalVolume;
  num? totalVolumeBySerialNumber;
  num? firstPassYield;
  num? finalYield;
  num? totalEquipment;
  num? totalFixture;
  num? totalTestName;
  String? totalTestTime;
  String? program;
  String? version;
  String? dut;
  String? equipmentType;

  ProjectSummaryDataDTO(
      {this.totalVolume,
      this.totalVolumeBySerialNumber,
      this.firstPassYield,
      this.finalYield,
      this.totalEquipment,
      this.totalFixture,
      this.totalTestName,
      this.totalTestTime,
      this.program,
      this.version,
      this.dut,
      this.equipmentType});

  ProjectSummaryDataDTO.fromJson(Map<String, dynamic> json) {
    totalVolume = json['totalVolume'];
    totalVolumeBySerialNumber = json['totalVolumeBySerialNumber'];
    firstPassYield = json['firstPassYield'];
    finalYield = json['finalYield'];
    totalEquipment = json['totalEquipment'];
    totalFixture = json['totalFixture'];
    totalTestName = json['totalTestName'];
    totalTestTime = json['totalTestTime'];
    program = json['program'];
    version = json['version'];
    dut = json['dut'];
    equipmentType = json['equipmentType'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalVolume'] = this.totalVolume;
    data['totalVolumeBySerialNumber'] = this.totalVolumeBySerialNumber;
    data['firstPassYield'] = this.firstPassYield;
    data['finalYield'] = this.finalYield;
    data['totalEquipment'] = this.totalEquipment;
    data['totalFixture'] = this.totalFixture;
    data['totalTestName'] = this.totalTestName;
    data['totalTestTime'] = this.totalTestTime;
    data['program'] = this.program;
    data['version'] = this.version;
    data['dut'] = this.dut;
    data['equipmentType'] = this.equipmentType;
    return data;
  }
}

// class FinalDispositionStructDataDTO {
//   List<FinalDispositionStructData>? finalDispositionStruct;

//   FinalDispositionStructDataDTO({this.finalDispositionStruct});

//   FinalDispositionStructDataDTO.fromJson(Map<String, dynamic> json) {
//     if (json['finalDispositionStruct'] != null) {
//       finalDispositionStruct = [];
//       json['finalDispositionStruct'].forEach((v) {
//         finalDispositionStruct!.add(FinalDispositionStructData.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     Map<String, dynamic> data = new Map<String, dynamic>();
//     data['finalDispositionStruct'] = this.finalDispositionStruct;
//     return data;
//   }
// }

class FinalDispositionStructDataDTO {
  String? firstStatus;
  int? count;
  String? lastStatus;

  FinalDispositionStructDataDTO(
      {this.firstStatus, this.count, this.lastStatus});

  FinalDispositionStructDataDTO.fromJson(Map<String, dynamic> json) {
    firstStatus = json['firstStatus'];
    count = json['count'] as int;
    lastStatus = json['lastStatus'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['firstStatus'] = this.firstStatus;
    data['count'] = this.count;
    data['lastStatus'] = this.lastStatus;
    return data;
  }
}
