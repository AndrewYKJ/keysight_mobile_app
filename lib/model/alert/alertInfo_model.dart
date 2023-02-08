class AlertInfo {
  String? alertID;
  String? equipment;
  String? project;
  String? scoring;
  String? status;
  String? message;
  String? company;
  String? site;
  String? timeStamp;
  String? startTime;
  String? endTime;
  String? createdBy;
  String? modifiedBy;
  String? modifiedDate;
  String? recentUpdate;
  String? workflow;
  String? createdOn;
  String? alertDate;
  String? subject;
  String? description;
  String? assignedTo;
  String? tag;
  bool? isLong;

  AlertInfo(
      {this.alertID,
      this.equipment,
      this.timeStamp,
      this.project,
      this.startTime,
      this.endTime,
      this.scoring,
      this.status,
      this.message,
      this.company,
      this.site,
      this.tag,
      this.createdBy,
      this.modifiedBy,
      this.modifiedDate,
      this.recentUpdate,
      this.workflow,
      this.createdOn,
      this.alertDate,
      this.subject,
      this.description,
      this.assignedTo,
      this.isLong});

  AlertInfo.fromJson(Map<String, dynamic> json) {
    alertID = json['alertID'];
    equipment = json['equipment'];
    project = json['project'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    timeStamp = json['timeStamp'];
    scoring = json['scoring'];
    status = json['status'];
    tag = json['tag'];
    message = json['message'];
    company = json['company'];
    site = json['site'];
    createdBy = json['createdBy'];
    modifiedBy = json['modifiedBy'];
    modifiedDate = json['modifiedDate'];
    recentUpdate = json['recentUpdate'];
    workflow = json['workflow'];
    createdOn = json['createdOn'];
    alertDate = json['alertDate'];
    subject = json['subject'];
    description = json['description'];
    assignedTo = json['assignedTo'];
    isLong = json['isLong'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['alertID'] = this.alertID;
    data['equipment'] = this.equipment;
    data['project'] = this.project;
    data['scoring'] = this.scoring;
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    data['timeStamp'] = this.timeStamp;
    data['status'] = this.status;
    data['message'] = this.message;
    data['company'] = this.company;
    data['tag'] = this.tag;
    data['site'] = this.site;
    data['createdBy'] = this.createdBy;
    data['modifiedBy'] = this.modifiedBy;
    data['modifiedDate'] = this.modifiedDate;
    data['recentUpdate'] = this.recentUpdate;
    data['workflow'] = this.workflow;
    data['createdOn'] = this.createdOn;
    data['alertDate'] = this.alertDate;
    data['subject'] = this.subject;
    data['description'] = this.description;
    data['assignedTo'] = this.assignedTo;
    data['isLong'] = this.isLong;
    return data;
  }
}
