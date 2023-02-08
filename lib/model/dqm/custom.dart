class DqmXaxisRangeDTO {
  String? rangeName;
  String? rangeValue;
  bool? isSelected;
  bool? isAvailable;

  DqmXaxisRangeDTO(
      {this.rangeName,
      this.rangeValue,
      this.isSelected,
      this.isAvailable,
      route});
}

class DqmTestResultSelectionDTO {
  String? dataName;
  String? dataValue;
  bool? isSelected;

  DqmTestResultSelectionDTO({this.dataName, this.dataValue, this.isSelected});
}

class DqmCustomDTO {
  String? customDataName;
  String? customDataValue;
  bool? customDataIsSelected;

  DqmCustomDTO(
      {this.customDataName, this.customDataValue, this.customDataIsSelected});
}
