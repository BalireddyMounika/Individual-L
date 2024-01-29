// To parse this JSON data, do
//
//     final userProfileAdressRequest = userProfileAdressRequestFromMap(jsonString);

import 'dart:convert';

class UserProfileAdressRequest {
  UserProfileAdressRequest({
    this.address,
    this.country,
    this.state,
    this.city,
    this.zipCode,
    this.primaryNumber,
    this.userId,
  });

  String? address;
  String? country;
  String? state;
  String? city;
  int? zipCode;
  String? primaryNumber;
  int? userId;

  factory UserProfileAdressRequest.fromJson(String str) => UserProfileAdressRequest.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UserProfileAdressRequest.fromMap(Map<String, dynamic> json) => UserProfileAdressRequest(
    address: json["Address"],
    country: json["Country"],
    state: json["State"],
    city: json["City"],
    zipCode: json["ZipCode"],
    primaryNumber: json["PrimaryNumber"],
    userId: json["UserId"],
  );

  Map<String, dynamic> toMap() => {
    "Address": address,
    "Country": country,
    "State": state,
    "City": city,
    "ZipCode": zipCode,
    "PrimaryNumber": primaryNumber,
    "UserId": userId,
  };
}
