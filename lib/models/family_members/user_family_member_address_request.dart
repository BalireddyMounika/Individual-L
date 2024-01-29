// To parse this JSON data, do
//
//     final userFamilyMemberAddressRequest = userFamilyMemberAddressRequestFromMap(jsonString);

import 'dart:convert';

class UserFamilyMemberAddressRequest {
  UserFamilyMemberAddressRequest({
    this.address,
    this.country,
    this.state,
    this.city,
    this.zipCode,
    this.primaryNumber,
    this.familyMemberId,
  });

  String? address;
  String? country;
  String? state;
  String? city;
  int? zipCode;
  String? primaryNumber;
  int? familyMemberId;

  factory UserFamilyMemberAddressRequest.fromJson(String str) => UserFamilyMemberAddressRequest.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UserFamilyMemberAddressRequest.fromMap(Map<String, dynamic> json) => UserFamilyMemberAddressRequest(
    address: json["Address"],
    country: json["Country"],
    state: json["State"],
    city: json["City"],
    zipCode: json["ZipCode"],
    primaryNumber: json["PrimaryNumber"],
    familyMemberId: json["FamilyId"],
  );

  Map<String, dynamic> toMap() => {
    "Address": address,
    "Country": country,
    "State": state,
    "City": city,
    "ZipCode": zipCode,
    "PrimaryNumber": primaryNumber,
    "FamilyId": familyMemberId,
  };
}
