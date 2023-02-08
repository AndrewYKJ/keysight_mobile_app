class AlertDetailDTO {
  String? alertID;
  String? alertIdName;
  String? alertRowKey;
  String? alertScoring;
  String? alertSeverity;
  String? assignedTo;
  String? assignedToName;
  String? caseId;
  String? companyId;
  String? companyName;
  String? createdBy;
  String? createdByName;
  String? createdTimestamp;
  String? dateTimestamp;
  String? description;
  String? endDate;
  String? equipmentId;
  String? equipmentName;
  String? event;
  String? fixtureId;
  String? measuredValue;
  String? modifiedBy;
  String? modifiedByName;
  String? modifiedTimestamp;
  String? moduleId;
  String? priority;
  String? projectId;
  String? rowIdentifier;
  String? sender;
  String? severity;
  String? siteId;
  String? siteName;
  String? startDate;
  String? status;
  String? subject;
  String? testName;
  String? timestamp;
  String? workFlow;
  List<AlertDetailHistoriesDTO>? histories;

  AlertDetailDTO(
      {this.alertID,
      this.alertIdName,
      this.alertRowKey,
      this.alertScoring,
      this.alertSeverity,
      this.assignedTo,
      this.assignedToName,
      this.caseId,
      this.companyId,
      this.companyName,
      this.createdBy,
      this.createdByName,
      this.createdTimestamp,
      this.dateTimestamp,
      this.description,
      this.endDate,
      this.equipmentId,
      this.equipmentName,
      this.event,
      this.fixtureId,
      this.measuredValue,
      this.modifiedBy,
      this.modifiedByName,
      this.modifiedTimestamp,
      this.moduleId,
      this.priority,
      this.projectId,
      this.rowIdentifier,
      this.sender,
      this.severity,
      this.siteId,
      this.siteName,
      this.startDate,
      this.status,
      this.subject,
      this.testName,
      this.timestamp,
      this.workFlow,
      this.histories});

  AlertDetailDTO.fromJson(Map<String, dynamic> json) {
    alertID = json['alertID'];
    alertIdName = json['alertIdName'];
    alertRowKey = json['alertRowKey'];
    alertScoring = json['alertScoring'];
    alertSeverity = json['alertSeverity'];
    assignedTo = json['assignedTo'];
    assignedToName = json['assignedToName'];
    caseId = json['caseId'];
    companyId = json['companyId'];
    companyName = json['companyName'];
    createdBy = json['createdBy'];
    createdByName = json['createdByName'];
    createdTimestamp = json['createdTimestamp'];
    dateTimestamp = json['dateTimestamp'];
    description = json['description'];
    endDate = json['endDate'];
    equipmentId = json['equipmentId'];
    equipmentName = json['equipmentName'];
    event = json['event'];
    fixtureId = json['fixtureId'];
    measuredValue = json['measuredValue'];
    modifiedBy = json['modifiedBy'];
    modifiedByName = json['modifiedByName'];
    modifiedTimestamp = json['modifiedTimestamp'];
    moduleId = json['moduleId'];
    priority = json['priority'];
    projectId = json['projectId'];
    rowIdentifier = json['rowIdentifier'];
    sender = json['sender'];
    severity = json['severity'];
    siteId = json['siteId'];
    siteName = json['siteName'];
    startDate = json['startDate'];
    status = json['status'];
    subject = json['subject'];
    testName = json['testName'];
    timestamp = json['timestamp'];
    workFlow = json['workFlow'];

    if (json['histories'] != null) {
      histories = [];
      json['histories'].forEach((v) {
        histories!.add(AlertDetailHistoriesDTO.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['alertID'] = this.alertID;
    data['alertIdName'] = this.alertIdName;
    data['alertRowKey'] = this.alertRowKey;
    data['alertScoring'] = this.alertScoring;
    data['alertSeverity'] = this.alertSeverity;
    data['assignedTo'] = this.assignedTo;
    data['assignedToName'] = this.assignedToName;
    data['caseId'] = this.caseId;
    data['companyId'] = this.companyId;
    data['companyName'] = this.companyName;
    data['createdBy'] = this.createdBy;
    data['createdByName'] = this.createdByName;
    data['createdTimestamp'] = this.createdTimestamp;
    data['dateTimestamp'] = this.dateTimestamp;
    data['description'] = this.description;
    data['endDate'] = this.endDate;
    data['equipmentId'] = this.equipmentId;
    data['equipmentName'] = this.equipmentName;
    data['event'] = this.event;
    data['fixtureId'] = this.fixtureId;
    data['measuredValue'] = this.measuredValue;
    data['modifiedBy'] = this.modifiedBy;
    data['modifiedByName'] = this.modifiedByName;
    data['modifiedTimestamp'] = this.modifiedTimestamp;
    data['moduleId'] = this.moduleId;
    data['priority'] = this.priority;
    data['projectId'] = this.projectId;
    data['rowIdentifier'] = this.rowIdentifier;
    data['sender'] = this.sender;
    data['severity'] = this.severity;
    data['siteId'] = this.siteId;
    data['siteName'] = this.siteName;
    data['startDate'] = this.startDate;
    data['status'] = this.status;
    data['subject'] = this.subject;
    data['testName'] = this.testName;
    data['timestamp'] = this.timestamp;
    data['workFlow'] = this.workFlow;
    data['histories'] = this.histories;
    return data;
  }
}

class AlertDetailHistoriesDTO {
  String? Id;
  String? alertRowKey;
  String? createdBy;
  String? createdByName;
  String? dateCreated;
  String? historyType;
  String? message;
  String? rowIdentifier;

  AlertDetailHistoriesDTO(
      {this.Id,
      this.alertRowKey,
      this.createdBy,
      this.createdByName,
      this.dateCreated,
      this.historyType,
      this.message,
      this.rowIdentifier});

  AlertDetailHistoriesDTO.fromJson(Map<String, dynamic> json) {
    Id = json['Id'];
    alertRowKey = json['alertRowKey'];
    createdBy = json['createdBy'];
    createdByName = json['createdByName'];
    dateCreated = json['dateCreated'];
    historyType = json['historyType'];
    message = json['message'];
    rowIdentifier = json['rowIdentifier'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.Id;
    data['alertRowKey'] = this.alertRowKey;
    data['createdBy'] = this.createdBy;
    data['createdByName'] = this.createdByName;
    data['dateCreated'] = this.dateCreated;
    data['historyType'] = this.historyType;
    data['message'] = this.message;
    data['rowIdentifier'] = this.rowIdentifier;
    return data;
  }
}
