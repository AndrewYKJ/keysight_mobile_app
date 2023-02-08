class OeeChartReturnDTO {
  String? id;
  List<OeeChartReturnDataDTO>? data;

  OeeChartReturnDTO({this.id, this.data});

  OeeChartReturnDTO.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(OeeChartReturnDataDTO.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['data'] = this.data;
    return data;
  }
}

class OeeChartReturnDataDTO {
  String? equipmentName;
  String? color;
  int? count;
  String? oee;

  OeeChartReturnDataDTO({this.equipmentName, this.color, this.count, this.oee});

  OeeChartReturnDataDTO.fromJson(Map<String, dynamic> json) {
    equipmentName = json['equipmentName'];
    count = json['count'];
    color = json['color'];
    oee = json['oee'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['equipmentName'] = this.equipmentName;
    data['color'] = this.color;
    data['count'] = this.count;
    data['oee'] = this.oee;

    return data;
  }
}

class OeeChartVOEReturnDTO {
  String? equipmentName;
  int? count;
  String? color;

  OeeChartVOEReturnDTO({this.equipmentName, this.count, this.color});

  OeeChartVOEReturnDTO.fromJson(Map<String, dynamic> json) {
    equipmentName = json['equipmentName'];
    count = json['count'];
    color = json['color'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['equipmentName'] = this.equipmentName;
    data['count'] = this.count;
    data['color'] = this.color;
    return data;
  }
}
