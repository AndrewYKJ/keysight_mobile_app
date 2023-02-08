class CustomServerDTO {
  String? serverName;
  String? serverIp;
  String? serverPort;
  bool? isSelected;

  CustomServerDTO(
      {this.serverName, this.serverIp, this.serverPort, this.isSelected});

  CustomServerDTO.fromJson(Map<String, dynamic> json) {
    serverName = json['serverName'];
    serverIp = json['serverIp'];
    serverPort = json['serverPort'];
    isSelected = json['isSelected'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['serverName'] = this.serverName;
    data['serverIp'] = this.serverIp;
    data['serverPort'] = this.serverPort;
    data['isSelected'] = this.isSelected;
    return data;
  }
}
