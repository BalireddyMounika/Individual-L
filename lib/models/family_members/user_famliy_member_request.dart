// To parse this JSON data, do
//
//     final userFamilyMemberRequest = userFamilyMemberRequestFromMap(jsonString);

import 'dart:convert';

class UserFamilyMemberRequest {
  UserFamilyMemberRequest({
    this.userId,
    this.title,
    this.firstname,
    this.lastname,
    this.email,
    this.gender,
    this.age,
    this.dob,
    this.martialStatus,
    this.bloodGroup,
    this.profilePicture,
    this.familyMemberType,
    this.relationshipToPatient,
    this.isEmergency,
  });

  int? userId;
  String? title;
  String? firstname;
  String? lastname;
  String? email;
  String? gender;
  int? age;
  String? dob;
  String? martialStatus;
  String? bloodGroup;
  String? profilePicture;
  String? familyMemberType;
  String? relationshipToPatient;
  bool? isEmergency;

  factory UserFamilyMemberRequest.fromJson(String str) => UserFamilyMemberRequest.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UserFamilyMemberRequest.fromMap(Map<String, dynamic> json) => UserFamilyMemberRequest(
    userId: json["UserId"] == null ? null : json["UserId"],
    title: json["Title"] == null ? null : json["Title"],
    firstname: json["Firstname"] == null ? null : json["Firstname"],
    lastname: json["Lastname"] == null ? null : json["Lastname"],
    email: json["Email"] == null ? null : json["Email"],
    gender: json["Gender"] == null ? null : json["Gender"],
    age: json["Age"] == null ? null : json["Age"],
    dob: json["DOB"] == null ? null : json["DOB"],
    martialStatus: json["MartialStatus"] == null ? null : json["MartialStatus"],
    bloodGroup: json["BloodGroup"] == null ? null : json["BloodGroup"],
    profilePicture: json["ProfilePicture"] == null ? null : json["ProfilePicture"],
    familyMemberType: json["FamilyMemberType"] == null ? null : json["FamilyMemberType"],
    relationshipToPatient: json["RelationshipToPatient"] == null ? null : json["RelationshipToPatient"],
    isEmergency: json["IsEmergency"] == null ? null : json["IsEmergency"],
  );

  Map<String, dynamic> toMap() => {
    "UserId": userId == null ? null : userId,
    "Title": title == null ? null : title,
    "Firstname": firstname == null ? null : firstname,
    "Lastname": lastname == null ? null : lastname,
    "Email": email == null ? null : email,
    "Gender": gender == null ? null : gender,
    "Age": age == null ? null : age,
    "DOB": dob == null ? null : dob,
    "MartialStatus": martialStatus == null ? null : martialStatus,
    "BloodGroup": bloodGroup == null ? null : bloodGroup,
    "ProfilePicture": profilePicture == null ? null : profilePicture,
    "FamilyMemberType": familyMemberType == null ? null : familyMemberType,
    "RelationshipToPatient": relationshipToPatient == null ? null : relationshipToPatient,
    "IsEmergency": isEmergency == null ? null : isEmergency,
  };
}
