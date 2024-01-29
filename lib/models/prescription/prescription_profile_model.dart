// To parse this JSON data, do
//
//     final profileDetail = profileDetailFromMap(jsonString);

import 'dart:convert';

class ProfileDetail {
  ProfileDetail({
    this.id,
    this.firstname,
    this.lastname,
    this.email,
    this.username,
    this.password,
    this.mobileNumber,
    this.deviceToken,
  });

  int? id;
  String? firstname;
  String? lastname;
  String? email;
  String? username;
  String? password;
  String? mobileNumber;
  String? deviceToken;

  factory ProfileDetail.fromJson(String str) => ProfileDetail.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ProfileDetail.fromMap(Map<String, dynamic> json) => ProfileDetail(
    id: json["id"] == null ? null : json["id"],
    firstname: json["Firstname"] == null ? null : json["Firstname"],
    lastname: json["Lastname"] == null ? null : json["Lastname"],
    email: json["Email"] == null ? null : json["Email"],
    username: json["Username"] == null ? null : json["Username"],
    password: json["Password"] == null ? null : json["Password"],
    mobileNumber: json["MobileNumber"] == null ? null : json["MobileNumber"],
    deviceToken: json["DeviceToken"] == null ? null : json["DeviceToken"],
  );

  Map<String, dynamic> toMap() => {
    "id": id == null ? null : id,
    "Firstname": firstname == null ? null : firstname,
    "Lastname": lastname == null ? null : lastname,
    "Email": email == null ? null : email,
    "Username": username == null ? null : username,
    "Password": password == null ? null : password,
    "MobileNumber": mobileNumber == null ? null : mobileNumber,
    "DeviceToken": deviceToken == null ? null : deviceToken,
  };
}
