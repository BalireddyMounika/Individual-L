// To parse this JSON data, do
//
//     final appointmentRequest = appointmentRequestFromMap(jsonString);

import 'dart:convert';

class AppointmentRequest {
  AppointmentRequest({
    this.date,
    this.time,
    this.specialization,
    this.status,
    this.appointmentType,
    this.fees,
    this.userId,
    this.doctorId,
    this.scheduleId,
    this.familyMemberId,
    this.familyMemberAge,
    this.familyMemberGender,
    this.prescriptionId,
    this.transactionId,
    this.fromSubscription,
    this.symptoms,

  });

  String? date;
  String? time;
  String? specialization;
  String? status;
  String? appointmentType;
  int? fees;
  int? userId;
  int? doctorId;
  int? scheduleId;
  int? familyMemberId;
  int? familyMemberAge;
  int? familyMemberGender;
  int? prescriptionId;
  String? transactionId;
  bool? fromSubscription;
  Symptoms? symptoms;

  factory AppointmentRequest.fromJson(String str) => AppointmentRequest.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AppointmentRequest.fromMap(Map<String, dynamic> json) => AppointmentRequest(
    date: json["Date"] == null ? null : json["Date"],
    time: json["Time"] == null ? null : json["Time"],
    specialization: json["Specialization"] == null ? null : json["Specialization"],
    status: json["Status"] == null ? null : json["Status"],
    appointmentType: json["AppointmentType"] == null ? null : json["AppointmentType"],
    fees: json["Fees"] == null ? null : json["Fees"],
    userId: json["UserId"] == null ? null : json["UserId"],
    doctorId: json["DoctorId"] == null ? null : json["DoctorId"],
    scheduleId: json["ScheduleId"] == null ? null : json["ScheduleId"],
    familyMemberId: json["FamilyMemberId"] == null ? null : json["FamilyMemberId"],
    familyMemberAge: json["FamilyMemberAge"] == null ? null : json["FamilyMemberAge"],
    familyMemberGender: json["FamilyMemberGender"] == null ? null : json["FamilyMemberGender"],
    prescriptionId: json["PrescriptionId"] == null ? null : json["PrescriptionId"],
    symptoms: json["symptoms"] == null ? null : Symptoms.fromMap(json["symptoms"]),
    transactionId : json["TransactionId"] == null ? null :json["TransactionId"],
    fromSubscription: json["FromSubscription"] == null ? null :  json["FromSubscription"]
  );

  Map<String, dynamic> toMap() => {
    "Date": date == null ? null : date,
    "Time": time == null ? null : time,
    "Specialization": specialization == null ? null : specialization,
    "Status": status == null ? null : status,
    "AppointmentType": appointmentType == null ? null : appointmentType,
    "Fees": fees == null ? null : fees,
    "UserId": userId == null ? null : userId,
    "DoctorId": doctorId == null ? null : doctorId,
    "ScheduleId": scheduleId == null ? null : scheduleId,
    "FamilyMemberId": familyMemberId == null ? null : familyMemberId,
    "FamilyMemberAge": familyMemberAge == null ? null : familyMemberAge,
    "FamilyMemberGender": familyMemberGender == null ? null : familyMemberGender,
    "PrescriptionId": prescriptionId == null ? null : prescriptionId,
    "TransactionId" : transactionId ==null ? null :transactionId,
    "symptoms": symptoms == null ? null : symptoms!.toMap(),
    "FromSubscription" :fromSubscription ==null ? null : fromSubscription

  };
}

class Symptoms {
  Symptoms({
    this.symptom,
    this.comments,
  });

  String? symptom;
  String? comments;

  factory Symptoms.fromJson(String str) => Symptoms.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Symptoms.fromMap(Map<String, dynamic> json) => Symptoms(
    symptom: json["Symptom"] == null ? null : json["Symptom"],
    comments: json["comments"] == null ? null : json["comments"],
  );

  Map<String, dynamic> toMap() => {
    "Symptom": symptom == null ? null : symptom,
    "comments": comments == null ? null : comments,
  };
}
