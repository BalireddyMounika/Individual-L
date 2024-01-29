// To parse this JSON data, do
//
//     final getProfileResponse = getProfileResponseFromMap(jsonString);

import 'dart:convert';

class GetProfileResponse {
  GetProfileResponse({
    this.firstname,
    this.lastname,
    this.email,
    this.username,
    this.mobileNumber,
    this.deviceToken,
    this.profile,
    this.address,
    this.authorizedCode
  });

  String? firstname;
  String? lastname;
  String? authorizedCode;
  String? email;
  String? username;
  String? mobileNumber;
  String? deviceToken;
  Profile? profile;
  Address? address;

  factory GetProfileResponse.fromJson(String str) => GetProfileResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetProfileResponse.fromMap(Map<String, dynamic> json) => GetProfileResponse(
    firstname: json["Firstname"],
    lastname: json["Lastname"],
    authorizedCode: json["AuthorizedCode"],
    email: json["Email"],
    username: json["Username"],
    mobileNumber: json["MobileNumber"],
    deviceToken: json["DeviceToken"],
    profile: json["Profile"] == null ? null: Profile?.fromMap(json["Profile"]),
    address:json["Address"]==null? null: Address?.fromMap(json["Address"]),
  );

  Map<String, dynamic> toMap() => {
    "Firstname": firstname,
    "Lastname": lastname,
    "AuthorizedCode" : authorizedCode,
    "Email": email,
    "Username": username,
    "MobileNumber": mobileNumber,
    "DeviceToken": deviceToken,
    "Profile": profile?.toMap(),
    "Address": address?.toMap(),
  };
}

class Address {
  Address({
    this.id,
    this.address,
    this.country,
    this.state,
    this.city,
    this.zipCode,
    this.primaryNumber,
    this.userId,
  });

  int? id;
  String? address;
  String? country;
  String? state;
  String? city;
  int? zipCode;
  String? primaryNumber;
  int? userId;


  factory Address.fromJson(String str) => Address.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Address.fromMap(Map<String, dynamic> json) => Address(
    id: json["id"],
    address: json["Address"],
    country: json["Country"],
    state: json["State"],
    city: json["City"],
    zipCode: json["ZipCode"],
    primaryNumber: json["PrimaryNumber"],
    userId: json["UserId"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "Address": address,
    "Country": country,
    "State": state,
    "City": city,
    "ZipCode": zipCode,
    "PrimaryNumber": primaryNumber,
    "UserId": userId,
  };
}

class Profile {
  Profile({
    this.userId,
    this.title,
    this.gender,
    this.dob,
    this.martialStatus,
    this.bloodGroup,
    this.preferredPhysician,
    this.preferredPhysicianSpecialization,
    this.profilePicture,
    this.id
  });

  int? id;
  int? userId;
  String? title;
  String? gender;
  String? dob;
  String? martialStatus;
  String? bloodGroup;
  String? preferredPhysician;
  String? preferredPhysicianSpecialization;
  String? profilePicture;

  factory Profile.fromJson(String str) => Profile.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Profile.fromMap(Map<String, dynamic> json) => Profile(
    id: json["id"] == null ? null : json["id"],
    userId: json["UserId"],
    title: json["Title"],
    gender: json["Gender"],
    dob: json["DOB"],
    martialStatus: json["MartialStatus"],
    bloodGroup: json["BloodGroup"],
    preferredPhysician: json["PreferredPhysician"],
    preferredPhysicianSpecialization: json["PreferredPhysicianSpecialization"],
    profilePicture: json["ProfilePicture"] == null ? null : json["ProfilePicture"]
  );

  Map<String, dynamic> toMap() => {
    "UserId": userId,
    "Title": title,
    "Gender": gender,
    "DOB": dob,
    "MartialStatus": martialStatus,
    "BloodGroup": bloodGroup,
    "PreferredPhysician": preferredPhysician,
    "PreferredPhysicianSpecialization": preferredPhysicianSpecialization,
    "ProfilePicture" :profilePicture??null
  };
}
