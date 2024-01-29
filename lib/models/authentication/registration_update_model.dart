// To parse this JSON data, do
//
//     final registrationUpdateModel = registrationUpdateModelFromMap(jsonString);

import 'dart:convert';

class RegistrationUpdateModel {
  RegistrationUpdateModel({
    this.firstname,
    this.lastname,
    this.email,
    this.username,
    this.mobileNumber,
  });

  String? firstname;
  String? lastname;
  String? email;
  String? username;
  String? mobileNumber;

  factory RegistrationUpdateModel.fromJson(String str) => RegistrationUpdateModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory RegistrationUpdateModel.fromMap(Map<String, dynamic> json) => RegistrationUpdateModel(
    firstname: json["Firstname"] == null ? null : json["Firstname"],
    lastname: json["Lastname"] == null ? null : json["Lastname"],
    email: json["Email"] == null ? null : json["Email"],
    username: json["Username"] == null ? null : json["Username"],
    mobileNumber: json["MobileNumber"] == null ? null : json["MobileNumber"],
  );

  Map<String, dynamic> toMap() => {
    "Firstname": firstname == null ? null : firstname,
    "Lastname": lastname == null ? null : lastname,
    "Email": email == null ? null : email,
    "Username": username == null ? null : username,
    "MobileNumber": mobileNumber == null ? null : mobileNumber,
  };
}
