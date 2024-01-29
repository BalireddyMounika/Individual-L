  // To parse this JSON data, do
//
//     final appointmentHistoryResponse = appointmentHistoryResponseFromMap(jsonString);

import 'dart:convert';

import 'package:life_eazy/models/appointments/appointment_request.dart';

import '../family_members/family_member_model.dart';

class AppointmentHistoryResponse {
  AppointmentHistoryResponse({
    this.id,
    this.userId,
    this.date,
    this.time,
    this.specialization,
    this.status,
    this.doctorId,
    this.appointmentType,
    this.bookingDate,
    this.symptoms,
    this.familyMemberId
  });


  final int? id ;
  final dynamic userId;
  final String? date;
  final String? time;
  final String? specialization;
  final String? status;
  final DoctorId? doctorId;
  final String? appointmentType;
  final String? bookingDate;
  final Symptoms? symptoms;
  final FamilyMemberModel? familyMemberId;

  factory AppointmentHistoryResponse.fromJson(String str) => AppointmentHistoryResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AppointmentHistoryResponse.fromMap(Map<String, dynamic> json) => AppointmentHistoryResponse(
    id:json["id"] ==null ?null :json["id"],
    userId: json["UserId"] == null ? null : json["UserId"],
    date: json["Date"] == null ? null : json["Date"],
    time: json["Time"] == null ? null : json["Time"],
    specialization: json["Specialization"] == null ? null : json["Specialization"],
    status: json["Status"] == null ? null : json["Status"],
    doctorId: json["DoctorId"] == null ? null : DoctorId.fromMap(json["DoctorId"]),
    appointmentType: json["AppointmentType"]  == null ?null: json["AppointmentType"],
    bookingDate: json["CurrentDate"] == null ? null :json["CurrentDate"],
    symptoms:json["symptoms"] ==null ?null : Symptoms.fromMap(json["symptoms"]),
    familyMemberId: json["FamilyMemberId"] == null ? null : FamilyMemberModel.fromMap(json["FamilyMemberId"])

  );

  Map<String, dynamic> toMap() => {
    "id" :id == null ?null :id,
    "UserId": userId == null ? null : userId,
    "Date": date == null ? null : date,
    "Time": time == null ? null : time,
    "Specialization": specialization == null ? null : specialization,
    "Status": status == null ? null : status,
    "DoctorId": doctorId == null ? null : doctorId!.toMap(),
    "AppointmentType": appointmentType == null ? null : appointmentType,
    "CurrentDate" : bookingDate == null ? null : bookingDate,
    "symptoms" : symptoms == null ? null : symptoms!.toMap(),
    "familyMemberId" : familyMemberId == null ? null : familyMemberId!.toMap()
  };
}

// To parse this JSON data, do
//
//     final doctorId = doctorIdFromMap(jsonString);



class DoctorId {
  DoctorId({
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

  factory DoctorId.fromJson(String str) => DoctorId.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DoctorId.fromMap(Map<String, dynamic> json) => DoctorId(
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



