import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:keysight_pma/dio/dio_repo.dart';
import 'package:keysight_pma/model/sortAndFilter/company.dart';
import 'package:keysight_pma/model/sortAndFilter/equipment.dart';
import 'package:keysight_pma/model/sortAndFilter/project_version_by_category.dart';
import 'package:keysight_pma/model/sortAndFilter/projects.dart';
import 'package:keysight_pma/model/sortAndFilter/sites.dart';

class SortFilterApi extends DioRepo {
  SortFilterApi(BuildContext context) {
    dioContext = context;
  }

  Future<CompanyDTO> loadCompanys() async {
    try {
      Response response = await mDio.get("companys/load");
      return CompanyDTO.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

  Future<SiteDTO> loadSites(String companyId) async {
    try {
      Map<String, dynamic> params = {"companyId": companyId};
      Response response = await mDio.get("sites/load", queryParameters: params);
      return SiteDTO.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

  Future<ProjectsDTO> loadProjectList(String companyId, String siteId) async {
    try {
      Map<String, dynamic> params = {"companyId": companyId, "siteId": siteId};
      Response response =
          await mDio.get("pinsshortvtep/listProject", queryParameters: params);
      return ProjectsDTO.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

  Future<ProjectVersionByCategoryDTO> loadProjectVersionByCategory(
      String companyId, String siteId, String projectId) async {
    try {
      Map<String, dynamic> params = {
        "companyId": companyId,
        "siteId": siteId,
        "projectId": projectId
      };
      Response response = await mDio.get(
          "projects/listProjectVersionByCategory",
          queryParameters: params);
      return ProjectVersionByCategoryDTO.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

  Future<EquipmentDTO> loadEquipments(String companyId, String siteId) async {
    try {
      Map<String, dynamic> params = {"companyId": companyId, "siteId": siteId};
      Response response =
          await mDio.get("equipments/load", queryParameters: params);
      return EquipmentDTO.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }
}
