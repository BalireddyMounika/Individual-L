// To parse this JSON data, do
//
//     final getImmunizationResponse = getImmunizationResponseFromMap(jsonString);

import 'dart:convert';

class GetImmunizationResponse {
  GetImmunizationResponse({
    this.id,
    this.personType,
    this.vaccine,
    this.duedateofvaccineindaysStartswith,
    this.duedateofvaccineindaysEndswith,
    this.whentogive,
    this.dose,
    this.route,
    this.site,
    this.followedByHealthAuthority,
    this.immunizationId,
    this.referenceDocument,
  });

  int? id;
  String? personType;
  String? vaccine;
  int? duedateofvaccineindaysStartswith;
  int? duedateofvaccineindaysEndswith;
  String? whentogive;
  String? dose;
  String? route;
  String? site;
  String? referenceDocument;
  dynamic followedByHealthAuthority;
  List<ImmunisationProfileModel>? immunizationId;

  factory GetImmunizationResponse.fromJson(String str) => GetImmunizationResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetImmunizationResponse.fromMap(Map<String, dynamic> json) => GetImmunizationResponse(
    id: json["id"] == null ? null : json["id"],
    personType: json["PersonType"] == null ? null : json["PersonType"],
    vaccine: json["Vaccine"] == null ? null : json["Vaccine"],
    duedateofvaccineindaysStartswith: json["Duedateofvaccineindays_startswith"] == null ? null : json["Duedateofvaccineindays_startswith"],
    duedateofvaccineindaysEndswith: json["Duedateofvaccineindays_endswith"] == null ? null : json["Duedateofvaccineindays_endswith"],
    whentogive: json["Whentogive"] == null ? null : json["Whentogive"],
    dose: json["Dose"] == null ? null : json["Dose"],
    route: json["Route"] == null ? null : json["Route"],
    site: json["Site"] == null ? null : json["Site"],
    followedByHealthAuthority: json["Followed_By_Health_Authority"],
    immunizationId: json["immunization_id"] == null ? null : List<ImmunisationProfileModel>.from(json["immunization_id"].map((x) => ImmunisationProfileModel.fromMap(x))),
    referenceDocument: json["ReferenceDocument"] == null ? null : json["ReferenceDocument"],  );

  Map<String, dynamic> toMap() => {
    "id": id == null ? null : id,
    "PersonType": personType == null ? null : personType,
    "Vaccine": vaccine == null ? null : vaccine,
    "Duedateofvaccineindays_startswith": duedateofvaccineindaysStartswith == null ? null : duedateofvaccineindaysStartswith,
    "Duedateofvaccineindays_endswith": duedateofvaccineindaysEndswith == null ? null : duedateofvaccineindaysEndswith,
    "Whentogive": whentogive == null ? null : whentogive,
    "Dose": dose == null ? null : dose,
    "Route": route == null ? null : route,
    "Site": site == null ? null : site,
    "Followed_By_Health_Authority": followedByHealthAuthority,
    "immunization_id": immunizationId == null ? null : List<dynamic>.from(immunizationId!.map((x) => x)),
    "ReferenceDocument": referenceDocument == null ? null : referenceDocument,

  };

//
  // factory ReferenceDocument.fromJson(String str) => ReferenceDocument.fromMap(json.decode(str));
  //
  // String toJson() => json.encode(toMap());

 // factory ReferenceDocument.fromMap(Map<String, dynamic> json) => ReferenceDocument(
//  referenceDocument: json["ReferenceDocument"] == null ? null : json["ReferenceDocument"],
 // );

  //Map<String, dynamic> toMap() => {
 // "ReferenceDocument": referenceDocument == null ? null : referenceDocument,
 // };
 // }

}







class ImmunisationProfileModel {
  ImmunisationProfileModel({
    this.userId,
    this.familyId,
    this.immunizationId,
    this.dateOfImmunization,
    this.doseTaken,
    this.uploadDocument,
    this.helpContent,
    this.createdOn,
    this.updatedOn,
  });

  UserId? userId;
  int? familyId;
  int? immunizationId;
  String? dateOfImmunization;
  String? doseTaken;
  String? uploadDocument;
  String? helpContent;
  String? createdOn;
  String? updatedOn;

  factory ImmunisationProfileModel.fromJson(String str) => ImmunisationProfileModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ImmunisationProfileModel.fromMap(Map<String, dynamic> json) => ImmunisationProfileModel(
    userId: json["UserId"] == null ? null : UserId.fromMap(json["UserId"]),
    familyId: json["FamilyId"] == null ? null : json["FamilyId"],
    immunizationId: json["ImmunizationId"] == null ? null : json["ImmunizationId"],
    dateOfImmunization: json["Date_Of_Immunization"] == null ? null : json["Date_Of_Immunization"],
    doseTaken: json["Dose_Taken"] == null ? null : json["Dose_Taken"],
    uploadDocument: json["Upload_document"] == null ? null : json["Upload_document"],
    helpContent: json["Help_Content"] == null ? null : json["Help_Content"],
    createdOn: json["CreatedOn"] == null ? null : json["CreatedOn"],
    updatedOn: json["UpdatedOn"] == null ? null : json["UpdatedOn"],
  );

  Map<String, dynamic> toMap() => {
    "UserId": userId == null ? null : userId!.toMap(),
    "FamilyId": familyId == null ? null : familyId,
    "ImmunizationId": immunizationId == null ? null : immunizationId,
    "Date_Of_Immunization": dateOfImmunization == null ? null : dateOfImmunization,
    "Dose_Taken": doseTaken == null ? null : doseTaken,
    "Upload_document": uploadDocument == null ? null : uploadDocument,
    "Help_Content": helpContent == null ? null : helpContent,
    "CreatedOn": createdOn == null ? null : createdOn,
    "UpdatedOn": updatedOn == null ? null : updatedOn,
  };
}

class UserId {
  UserId({
    this.profile,
  });

  Profile? profile;

  factory UserId.fromJson(String str) => UserId.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UserId.fromMap(Map<String, dynamic> json) => UserId(
    profile: json["Profile"] == null ? null : Profile.fromMap(json["Profile"]),
  );

  Map<String, dynamic> toMap() => {
    "Profile": profile == null ? null : profile!.toMap(),
  };
}

class Profile {
  Profile({
    this.userId,
    this.dob,
  });

  int? userId;
  String? dob;

  factory Profile.fromJson(String str) => Profile.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Profile.fromMap(Map<String, dynamic> json) => Profile(
    userId: json["UserId"] == null ? null : json["UserId"],
    dob: json["DOB"] == null ? null : json["DOB"],
  );

  Map<String, dynamic> toMap() => {
    "UserId": userId == null ? null : userId,
    "DOB": dob == null ? null : dob  };
}

