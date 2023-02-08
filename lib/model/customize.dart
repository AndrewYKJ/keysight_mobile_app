import 'package:keysight_pma/model/sortAndFilter/equipment.dart';
import 'package:keysight_pma/model/sortAndFilter/project_version_by_category.dart';

class SortFilterCacheDTO {
  String? preferredDays;
  String? preferredCompany;
  String? preferredSite;
  String? preferredProjectId;
  DateTime? startDate;
  DateTime? endDate;
  DateTime? preferredStartDate;
  DateTime? preferredEndDate;
  String? defaultProjectId;
  String? defaultVersion;
  String? dtmPreferredRange;
  String? casehistorydatetype;
  String? displayProjectName;
  List<EquipmentDataDTO>? defaultEquipments;
  EquipmentDataDTO? preferredEquipments;
  ProjectVersionDataDTO? projectVersionObj;
  String? preferredFixturesId;
  String? preferredHeatMapMode;
  bool? currentTheme;
  SortFilterCacheDTO(
      {this.preferredDays,
      this.preferredCompany,
      this.preferredSite,
      this.preferredProjectId,
      this.startDate,
      this.currentTheme,
      this.endDate,
      this.preferredStartDate,
      this.preferredEndDate,
      this.casehistorydatetype,
      this.defaultProjectId,
      this.defaultVersion,
      this.preferredHeatMapMode,
      this.displayProjectName,
      this.defaultEquipments,
      this.preferredEquipments,
      this.dtmPreferredRange,
      this.preferredFixturesId,
      this.projectVersionObj});
}

class CustomDqmSortFilterProjectsDTO {
  String? projectId;
  bool? isSelected;

  CustomDqmSortFilterProjectsDTO(this.projectId, this.isSelected);

  CustomDqmSortFilterProjectsDTO.fromJson(Map<String, dynamic> json) {
    projectId = json['projectId'];
    isSelected = json['isSelected'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['projectId'] = this.projectId;
    data['isSelected'] = this.isSelected;
    return data;
  }
}

class CustomPreferredSortFilterProjectsDTO {
  String? name;
  String? id;

  CustomPreferredSortFilterProjectsDTO(this.name, this.id);

  CustomPreferredSortFilterProjectsDTO.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['id'] = this.id;
    return data;
  }
}

class CustomSummaryMetricSortFilterDTO {
  String? item;

  int? count;

  CustomSummaryMetricSortFilterDTO(this.item, this.count);

  CustomSummaryMetricSortFilterDTO.fromJson(Map<String, dynamic> json) {
    item = json['item'];

    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['projectId'] = this.item;

    data['count'] = this.count;
    return data;
  }
}

class CustomDqmSortFilterItemSelectionDTO {
  String? item;
  bool? isSelected;

  CustomDqmSortFilterItemSelectionDTO(this.item, this.isSelected);

  CustomDqmSortFilterItemSelectionDTO.fromJson(Map<String, dynamic> json) {
    item = json['item'];
    isSelected = json['isSelected'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['item'] = this.item;
    data['isSelected'] = this.isSelected;
    return data;
  }
}

class CustomDTO {
  String? displayName;
  String? value;
  String? appBarTitle;
  String? mode;
  bool? isEdl;
  String? testName;
  bool? status;

  CustomDTO(
      {this.displayName,
      this.value,
      this.appBarTitle,
      this.mode,
      this.isEdl,
      this.testName,
      this.status});
}
