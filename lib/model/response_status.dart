class ResponseStatusDTO {
  int? statusCode;
  String? statusMessage;

  ResponseStatusDTO({
    this.statusCode,
    this.statusMessage,
  });

  ResponseStatusDTO.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    statusMessage = json['statusMessage'] as String;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['statusMessage'] = this.statusMessage;
    return data;
  }
}
