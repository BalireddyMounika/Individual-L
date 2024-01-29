// To parse this JSON data, do
//
//     final preferedPhysicianRequest = preferedPhysicianRequestFromMap(jsonString);

import 'dart:convert';

class PreferedPhysicianRequest {
  PreferedPhysicianRequest({
    this.userId,
    this.preferredPhysician,
  });

  int? userId;
  int? preferredPhysician;

  factory PreferedPhysicianRequest.fromJson(String str) => PreferedPhysicianRequest.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PreferedPhysicianRequest.fromMap(Map<String, dynamic> json) => PreferedPhysicianRequest(
    userId: json["UserId"],
    preferredPhysician: json["PreferredPhysician"],
  );

  Map<String, dynamic> toMap() => {
    "UserId": userId,
    "PreferredPhysician": preferredPhysician,
  };
}
