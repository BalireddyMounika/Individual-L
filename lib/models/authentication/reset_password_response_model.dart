// To parse this JSON data, do
//
//     final resetPasswordResponseModel = resetPasswordResponseModelFromMap(jsonString);

import 'dart:convert';

class ResetPasswordResponseModel {
  ResetPasswordResponseModel({
    this.password,
  });

  String? password;

  factory ResetPasswordResponseModel.fromJson(String str) => ResetPasswordResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ResetPasswordResponseModel.fromMap(Map<String, dynamic> json) => ResetPasswordResponseModel(
    password: json["Password"] == null ? null : json["Password"],
  );

  Map<String, dynamic> toMap() => {
    "Password": password == null ? null : password,
  };
}
