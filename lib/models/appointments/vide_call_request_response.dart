// To parse this JSON data, do
//
//     final videoCallRequestResponse = videoCallRequestResponseFromMap(jsonString);

import 'dart:convert';

class VideoCallRequestResponse {
  VideoCallRequestResponse({
    this.id,
    this.userId,
    this.appointmentId,
    this.title,
    this.body,
    this.channelName,
  });

  int? id;
  int? userId;
  AppointmentId? appointmentId;
  String? title;
  String? body;
  String? channelName;

  factory VideoCallRequestResponse.fromJson(String str) => VideoCallRequestResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory VideoCallRequestResponse.fromMap(Map<String, dynamic> json) => VideoCallRequestResponse(
    id: json["id"] == null ? null : json["id"],
    userId: json["UserId"] == null ? null : json["UserId"],
    appointmentId: json["AppointmentId"] == null ? null : AppointmentId.fromMap(json["AppointmentId"]),
    title: json["Title"] == null ? null : json["Title"],
    body: json["Body"] == null ? null : json["Body"],
    channelName: json["ChannelName"] == null ? null : json["ChannelName"],
  );

  Map<String, dynamic> toMap() => {
    "id": id == null ? null : id,
    "UserId": userId == null ? null : userId,
    "AppointmentId": appointmentId == null ? null : appointmentId!.toMap(),
    "Title": title == null ? null : title,
    "Body": body == null ? null : body,
    "ChannelName": channelName == null ? null : channelName,
  };
}

class AppointmentId {
  AppointmentId({
    this.id,
    this.userId,
    this.doctorId,
    this.scheduleId,
    this.familyMemberAge,
    this.familyMemberGender,
    this.familyMemberId,
    this.date,
    this.appointmentType,
    this.fees,
    this.time,
    this.specialization,
    this.status,
    this.currentDate,
  });

  int? id;
  int? userId;
  DoctorId? doctorId;
  dynamic scheduleId;
  dynamic familyMemberAge;
  dynamic familyMemberGender;
  dynamic familyMemberId;
  String? date;
  String? appointmentType;
  int? fees;
  String? time;
  String? specialization;
  String? status;
  String? currentDate;

  factory AppointmentId.fromJson(String str) => AppointmentId.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AppointmentId.fromMap(Map<String, dynamic> json) => AppointmentId(
    id: json["id"] == null ? null : json["id"],
    userId: json["UserId"] == null ? null : json["UserId"],
    doctorId: json["DoctorId"] == null ? null : DoctorId.fromMap(json["DoctorId"]),
    scheduleId: json["ScheduleId"],
    familyMemberAge: json["FamilyMemberAge"],
    familyMemberGender: json["FamilyMemberGender"],
    familyMemberId: json["FamilyMemberId"],
    date: json["Date"] == null ? null : json["Date"],
    appointmentType: json["AppointmentType"] == null ? null : json["AppointmentType"],
    fees: json["Fees"] == null ? null : json["Fees"],
    time: json["Time"] == null ? null : json["Time"],
    specialization: json["Specialization"] == null ? null : json["Specialization"],
    status: json["Status"] == null ? null : json["Status"],
    currentDate: json["CurrentDate"] == null ? null : json["CurrentDate"],
  );

  Map<String, dynamic> toMap() => {
    "id": id == null ? null : id,
    "UserId": userId == null ? null : userId,
    "DoctorId": doctorId == null ? null : doctorId!.toMap(),
    "ScheduleId": scheduleId,
    "FamilyMemberAge": familyMemberAge,
    "FamilyMemberGender": familyMemberGender,
    "FamilyMemberId": familyMemberId,
    "Date": date == null ? null : date,
    "AppointmentType": appointmentType == null ? null : appointmentType,
    "Fees": fees == null ? null : fees,
    "Time": time == null ? null : time,
    "Specialization": specialization == null ? null : specialization,
    "Status": status == null ? null : status,
    "CurrentDate": currentDate == null ? null : currentDate,
  };
}

class DoctorId {
  DoctorId({
    this.firstname,
    this.lastname,
    this.email,
    this.username,
    this.password,
    this.mobileNumber,
  });

  String? firstname;
  String? lastname;
  String? email;
  String? username;
  String? password;
  String? mobileNumber;

  factory DoctorId.fromJson(String str) => DoctorId.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DoctorId.fromMap(Map<String, dynamic> json) => DoctorId(
    firstname: json["Firstname"] == null ? null : json["Firstname"],
    lastname: json["Lastname"] == null ? null : json["Lastname"],
    email: json["Email"] == null ? null : json["Email"],
    username: json["Username"] == null ? null : json["Username"],
    password: json["Password"] == null ? null : json["Password"],
    mobileNumber: json["MobileNumber"] == null ? null : json["MobileNumber"],
  );

  Map<String, dynamic> toMap() => {
    "Firstname": firstname == null ? null : firstname,
    "Lastname": lastname == null ? null : lastname,
    "Email": email == null ? null : email,
    "Username": username == null ? null : username,
    "Password": password == null ? null : password,
    "MobileNumber": mobileNumber == null ? null : mobileNumber,
  };
}
