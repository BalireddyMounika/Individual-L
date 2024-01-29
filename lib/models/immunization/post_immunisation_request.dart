// To parse this JSON data, do
//
//     final postImmunizationRequests = postImmunizationRequestsFromMap(jsonString);

import 'dart:convert';

class PostImmunizationRequests {
  PostImmunizationRequests({
    this.userId,
    this.familyId,
    this.immunizationId,
    this.dateOfImmunization,
    this.doseTaken,
    this.uploadDocument,
    this.helpContent,
  });

  int? userId;
  int? familyId;
  int? immunizationId;
  String? dateOfImmunization;
  String? doseTaken;
  String? uploadDocument;
  String? helpContent;

  factory PostImmunizationRequests.fromJson(String str) => PostImmunizationRequests.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PostImmunizationRequests.fromMap(Map<String, dynamic> json) => PostImmunizationRequests(
    userId: json["UserId"] == null ? null : json["UserId"],
    familyId: json["FamilyId"] == null ? null : json["FamilyId"],
    immunizationId: json["ImmunizationId"] == null ? null : json["ImmunizationId"],
    dateOfImmunization: json["Date_Of_Immunization"] == null ? null : json["Date_Of_Immunization"],
    doseTaken: json["Dose_Taken"] == null ? null : json["Dose_Taken"],
    uploadDocument: json["Upload_document"] == null ? null : json["Upload_document"],
    helpContent: json["Help_Content"] == null ? null : json["Help_Content"],
  );

  Map<String, dynamic> toMap() => {
    "UserId": userId == null ? null : userId,
    "FamilyId": familyId == null ? null : familyId,
    "ImmunizationId": immunizationId == null ? null : immunizationId,
    "Date_Of_Immunization": dateOfImmunization == null ? null : dateOfImmunization,
    "Dose_Taken": doseTaken == null ? null : doseTaken,
    "Upload_document": uploadDocument == null ? null : uploadDocument,
    "Help_Content": helpContent == null ? null : helpContent,
  };
}
