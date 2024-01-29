// To parse this JSON data, do
//
//     final registrationResponseModel = registrationResponseModelFromMap(jsonString);

import 'dart:convert';

class RegistrationResponseModel {
  RegistrationResponseModel({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.username,
    this.mobileNumber,
  });

  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? username;
  String? mobileNumber;

  factory RegistrationResponseModel.fromJson(String str) => RegistrationResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory RegistrationResponseModel.fromMap(Map<String, dynamic> json) => RegistrationResponseModel(
    id: json["id"] == null ? null : json["id"],
    firstName: json["Firstname"] == null ? null : json["Firstname"],
    lastName: json["Lastname"] == null ? null : json["Lastname"],
    email: json["Email"] == null ? null : json["Email"],
    username: json["Username"] == null ? null : json["Username"],
    mobileNumber: json["MobileNumber"] == null ? null : json["MobileNumber"],
  );

  Map<String, dynamic> toMap() => {
    "id": id == null ? null : id,
    "Firstname": firstName == null ? null : firstName,
    "Lastname": lastName == null ? null : lastName,
    "Email": email == null ? null : email,
    "Username": username == null ? null : username,
    "MobileNumber": mobileNumber == null ? null : mobileNumber,
  };
}
