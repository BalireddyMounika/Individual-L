// To parse this JSON data, do
//
//     final postVitalRequest = postVitalRequestFromMap(jsonString);

import 'dart:convert';

PostVitalRequest postVitalRequestFromMap(String str) => PostVitalRequest.fromMap(json.decode(str));

String postVitalRequestToMap(PostVitalRequest data) => json.encode(data.toMap());

class PostVitalRequest {
  PostVitalRequest({
    this.height,
    this.weight,
    this.bmi,
    this.temperature,
    this.spo2,
    this.bp,
    this.pulse,
    this.userId,
    this.familyMemberId,
    this.systolic,
    this.diastolic,

  });

  int? height;
  int? weight;
  int? bmi;
  String? temperature;
  int? spo2;
  int? bp;
  int? pulse;
  int? userId;
  int? familyMemberId;
  int? systolic;
  int? diastolic;
  factory PostVitalRequest.fromJson(String str) =>
      PostVitalRequest.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PostVitalRequest.fromMap(Map<String, dynamic> json) => PostVitalRequest(
    height: json["Height"] == null ? null : json["Height"],
    weight: json["Weight"] == null ? null : json["Weight"],
    bmi: json["BMI"] == null ? null : json["BMI"],
    temperature: json["Temperature"] == null ? null : json["Temperature"],
    spo2: json["Spo2"] == null ? null : json["Spo2"],
    bp: json["BP"] == null ? null : json["BP"],
    pulse: json["Pulse"] == null ? null : json["Pulse"],
    userId: json["UserId"] == null ? null : json["UserId"],
    systolic: json["systolic"] == null ? null : json["systolic"],
    diastolic: json["diastolic"] == null ? null : json["diastolic"],
    familyMemberId: json["FamilyMemberId"] == null ? null : json["FamilyMemberId"],
  );

  Map<String, dynamic> toMap() => {
    "Height": height == null ? null : height,
    "Weight": weight == null ? null : weight,
    "BMI": bmi == null ? null : bmi,
    "Temperature": temperature == null ? null : temperature,
    "Spo2": spo2 == null ? null : spo2,
    "BP": bp == null ? null : bp,
    "Pulse": pulse == null ? null : pulse,
    "UserId": userId == null ? null : userId,
    "systolic": systolic == null ? null : systolic,
    "diastolic": diastolic == null ? null : diastolic,
    "FamilyMemberId": familyMemberId == null ? null : familyMemberId,
  };


}
