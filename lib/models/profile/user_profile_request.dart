// To parse this JSON data, do
//
//     final userProfileRequest = userProfileRequestFromMap(jsonString);

import 'dart:convert';

class UserProfileRequest {
  UserProfileRequest({
    this.userId,
    this.title,
    this.gender,
    this.profilePicture,
    this.dob,
    this.martialStatus,
    this.bloodGroup,
  });

  int? userId;
  String ?title;
  String? gender;
  String? profilePicture;
  String ?dob;
  String ?martialStatus;
  String? bloodGroup;

  factory UserProfileRequest.fromJson(String str) => UserProfileRequest.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UserProfileRequest.fromMap(Map<String, dynamic> json) => UserProfileRequest(
    userId: json["UserId"] == null ? null :json["UserId"],
    title: json["Title"] == null ? null : json["Title"],
    gender: json["Gender"] == null ? null : json["Gender"],
    profilePicture: json["ProfilePicture"] == null ? null : json["ProfilePicture"],
    dob: json["DOB"] == null ? null : json["DOB"],
    martialStatus: json["MartialStatus"] == null ? null : json["MartialStatus"],
    bloodGroup: json["BloodGroup"] == null ? null : json["BloodGroup"],
  );

  Map<String, dynamic> toMap() => {
    "UserId": userId == null ? null : userId,
    "Title": title == null ? null : title,
    "Gender": gender == null ? null : gender,
    "ProfilePicture": profilePicture == null ? null : profilePicture,
    "DOB": dob == null ? null : dob,
    "MartialStatus": martialStatus == null ? null : martialStatus,
    "BloodGroup": bloodGroup == null ? null : bloodGroup,
  };
}

