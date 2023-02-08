import 'package:keysight_pma/model/oee/oeeAvailability.dart';
import 'package:keysight_pma/model/oee/oeeDowntime.dart';
import 'package:keysight_pma/model/oee/oeeEquipment.dart';
import 'package:keysight_pma/model/sortAndFilter/equipment.dart';

class OeeChartDetailArguments {
  String? chartName;
  String? dataType;
  OeeAvailabilityDTO? availableDTO;
  OeeEquipmentDTO? equipmentDTO;
  DownTimeMonitoringDTO? detailBreakdownData;
  DownTimeMonitoringDTO2? summaryUtilAndNonUtilData;
  int? currentTab;
  String? selectedCompany;
  String? selectedSite;
  String? selectedEquipment;
  List<EquipmentDataDTO>? selectedEquipmentList;
  OeeChartDetailArguments(
      {this.chartName,
      this.currentTab,
      this.dataType,
      this.equipmentDTO,
      this.detailBreakdownData,
      this.summaryUtilAndNonUtilData,
      this.availableDTO,
      this.selectedCompany,
      this.selectedSite,
      this.selectedEquipment,
      this.selectedEquipmentList});
}
