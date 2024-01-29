// To parse this JSON data, do
//
//     final getFamilyMemberResponse = getFamilyMemberResponseFromMap(jsonString);

import 'dart:convert';

class GetFamilyMemberResponse {
  GetFamilyMemberResponse({
    this.id,
    this.userId,
    this.firstName,
    this.lastName,
    this.title,
    this.gender,
    this.dob,
    this.martialStatus,
    this.bloodGroup,
    this.relationshipToPatient,
    this.isEmergency,
    this.familyMemberAddress,
    this.profilePicture
  });

  int? id;
  int? userId;
  String? firstName;
  String? lastName;
  String? title;
  String? gender;
  String? dob;
  String? martialStatus;
  String? bloodGroup;
  String? relationshipToPatient;
  bool? isEmergency;
  String? profilePicture;
  FamilyMemberAddress? familyMemberAddress;

  factory GetFamilyMemberResponse.fromJson(String str) => GetFamilyMemberResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetFamilyMemberResponse.fromMap(Map<String, dynamic> json) => GetFamilyMemberResponse(
    id: json["id"],
    userId: json["UserId"],
    firstName: json["Firstname"],
    lastName: json["Lastname"],
    title: json["Title"],
    gender: json["Gender"],
    dob: json["DOB"],
    martialStatus: json["MartialStatus"],
    bloodGroup: json["BloodGroup"],
    relationshipToPatient: json["RelationshipToPatient"],
    isEmergency: json["IsEmergency"],
    profilePicture: json["ProfilePicture"],
    familyMemberAddress: json["FamilyMemberAddress"] ==null ? json["FamilyMemberAddress"]: FamilyMemberAddress.fromMap(json["FamilyMemberAddress"]),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "UserId": userId,
    "FirstName": firstName,
    "LastName": lastName,
    "Title": title,
    "Gender": gender,
    "DOB": dob,
    "MartialStatus": martialStatus,
    "BloodGroup": bloodGroup,
    "ProfilePicture": profilePicture,
    "RelationshipToPatient": relationshipToPatient,
    "IsEmergency": isEmergency,
    "FamilyMemberAddress": familyMemberAddress!.toMap(),
  };
}

class FamilyMemberAddress {
  FamilyMemberAddress({
    this.id,
    this.address,
    this.country,
    this.state,
    this.city,
    this.zipCode,
    this.primaryNumber,
    this.familyMemberId,
  });

  int? id;
  String? address;
  String? country;
  String? state;
  String? city;
  int? zipCode;
  String? primaryNumber;
  int? familyMemberId;

  factory FamilyMemberAddress.fromJson(String str) => FamilyMemberAddress.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory FamilyMemberAddress.fromMap(Map<String, dynamic> json) => FamilyMemberAddress(
    id: json["id"],
    address: json["Address"],
    country: json["Country"],
    state: json["State"],
    city: json["City"],
    zipCode: json["ZipCode"],
    primaryNumber: json["PrimaryNumber"],
    familyMemberId: json["FamilyMemberId"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "Address": address,
    "Country": country,
    "State": state,
    "City": city,
    "ZipCode": zipCode,
    "PrimaryNumber": primaryNumber,
    "FamilyMemberId": familyMemberId,
  };
}
