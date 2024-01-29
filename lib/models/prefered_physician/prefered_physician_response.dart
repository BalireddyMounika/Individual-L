// To parse this JSON data, do
//
//     final preferedPhysicianResponse = preferedPhysicianResponseFromMap(jsonString);

import 'dart:convert';

class PreferedPhysicianResponse {
  PreferedPhysicianResponse({
    this.id,
    this.userId,
    this.preferredPhysician,
  });
 int? id;
 int? userId;
  PreferredPhysician? preferredPhysician;

  factory PreferedPhysicianResponse.fromJson(String str) => PreferedPhysicianResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PreferedPhysicianResponse.fromMap(Map<String, dynamic> json) => PreferedPhysicianResponse(
    id: json["id"],
    userId: json["UserId"],
    preferredPhysician: json["PreferredPhysician"] == null ? null: PreferredPhysician.fromMap(json["PreferredPhysician"]),
  );

  Map<String, dynamic> toMap() => {
    "id":id,
    "UserId": userId,
    "PreferredPhysician": preferredPhysician!.toMap(),
  };
}

class PreferredPhysician {
  PreferredPhysician({
    this.id,
    this.firstname,
    this.lastname,
    this.email,
    this.username,
    this.mobileNumber,
  });

  int? id;
  String? firstname;
  String? lastname;
  String? email;
  String? username;
  String? mobileNumber;

  factory PreferredPhysician.fromJson(String str) => PreferredPhysician.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PreferredPhysician.fromMap(Map<String, dynamic> json) => PreferredPhysician(
    firstname: json["Firstname"],
    lastname: json["Lastname"],
    email: json["Email"],
    username: json["Username"],
    mobileNumber: json["MobileNumber"],
    //id: json["Id"],
  );

  Map<String, dynamic> toMap() => {
    "Firstname": firstname,
    "Lastname": lastname,
    "Email": email,
    "Username": username,
    "MobileNumber": mobileNumber,
    "Id":id,
  };
}
