// To parse this JSON data, do
//
//     final doctorDetailResponse = doctorDetailResponseFromMap(jsonString);

import 'dart:convert';

class DoctorDetailResponse {
  DoctorDetailResponse({
    this.id,
    this.firstname,
    this.lastname,
    this.email,
    this.username,
    this.mobileNumber,
    this.deviceToken,
    this.authorizedCode,
    this.address,
    this.profile,
    this.tag,
    this.professional,
    this.schedule,
    this.appointments,
  });
  int? id;
  String? firstname;
  String? lastname;
  String? email;
  String? username;
  String? mobileNumber;
  String? deviceToken;
  String? authorizedCode;
  String? tag;
  Profile? profile;
  Address? address;
  Professional? professional;
  List<AppointmentDateTime>? appointments;

  Schedule? schedule;

  factory DoctorDetailResponse.fromJson(String str) =>
      DoctorDetailResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DoctorDetailResponse.fromMap(Map<String, dynamic> json) =>
      DoctorDetailResponse(
          id: json["id"] == null ? null : json["id"],
          firstname: json["Firstname"] == null ? null : json["Firstname"],
          lastname: json["Lastname"] == null ? null : json["Lastname"],
          email: json["Email"] == null ? null : json["Email"],
          username: json["Username"] == null ? null : json["Username"],
          tag: json["Tag"] == null ? null : json["Tag"],
          mobileNumber:
              json["MobileNumber"] == null ? null : json["MobileNumber"],
          deviceToken: json["DeviceToken"] == null ? null : json["DeviceToken"],
          authorizedCode:
              json["AuthorizedCode"] == null ? null : json["AuthorizedCode"],
          profile:
              json["Profile"] == null ? null : Profile.fromMap(json["Profile"]),
          address:
              json["Address"] == null ? null : Address.fromMap(json["Address"]),
          professional: json["Professional"] == null
              ? null
              : Professional.fromMap(json["Professional"]),
          schedule: json["Schedule"] == null
              ? null
              : Schedule.fromMap(json["Schedule"]),
          appointments: json["Appointments"] == null
              ? null
              : List<AppointmentDateTime>.from(json["Appointments"]
                  .map((x) => AppointmentDateTime.fromMap(x))));

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "Firstname": firstname == null ? null : firstname,
        "Lastname": lastname == null ? null : lastname,
        "Tag": tag == null ? null : tag,
        "Email": email == null ? null : email,
        "Username": username == null ? null : username,
        "MobileNumber": mobileNumber == null ? null : mobileNumber,
        "DeviceToken": deviceToken == null ? null : deviceToken,
        "AuthorizedCode": authorizedCode == null ? null : authorizedCode,
        "Profile": profile == null ? null : profile!.toMap(),
        "Address": address == null ? null : address!.toMap(),
        "Professional": professional == null ? null : professional!.toMap(),
        "Schedule": schedule == null ? null : schedule!.toMap(),
      };
}

class Address {
  Address({
    this.degree,
    this.collegeUniversity,
    this.yearOfEducation,
    this.educationalLocation,
    this.hcpId,
  });

  String? degree;
  String? collegeUniversity;
  int? yearOfEducation;
  String? educationalLocation;
  int? hcpId;

  factory Address.fromJson(String str) => Address.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Address.fromMap(Map<String, dynamic> json) => Address(
        degree: json["Degree"] == null ? null : json["Degree"],
        collegeUniversity: json["CollegeUniversity"] == null
            ? null
            : json["CollegeUniversity"],
        yearOfEducation:
            json["YearOfEducation"] == null ? null : json["YearOfEducation"],
        educationalLocation: json["EducationalLocation"] == null
            ? null
            : json["EducationalLocation"],
        hcpId: json["HcpId"] == null ? null : json["HcpId"],
      );

  Map<String, dynamic> toMap() => {
        "Degree": degree == null ? null : degree,
        "CollegeUniversity":
            collegeUniversity == null ? null : collegeUniversity,
        "YearOfEducation": yearOfEducation == null ? null : yearOfEducation,
        "EducationalLocation":
            educationalLocation == null ? null : educationalLocation,
        "HcpId": hcpId == null ? null : hcpId,
      };
}

class Professional {
  Professional({
    this.professionalId,
    this.professionalExperienceInYears,
    this.currentStatus,
    this.mciNumber,
    this.mciStateCouncil,
    this.specialization,
    this.areaFocusOn,
    this.patientsHandledPerDay,
    this.patientsHandledPerSlot,
    this.appointmentType,
    this.signature,
    this.hcpId,
  });

  String? professionalId;
  int? professionalExperienceInYears;
  dynamic currentStatus;
  int? mciNumber;
  String? mciStateCouncil;
  String? specialization;
  String? areaFocusOn;
  int? patientsHandledPerDay;
  int? patientsHandledPerSlot;
  List<String>? appointmentType;
  String? signature;
  int? hcpId;

  factory Professional.fromJson(String str) =>
      Professional.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Professional.fromMap(Map<String, dynamic> json) => Professional(
        professionalId:
            json["ProfessionalId"] == null ? null : json["ProfessionalId"],
        professionalExperienceInYears:
            json["ProfessionalExperienceInYears"] == null
                ? null
                : json["ProfessionalExperienceInYears"],
        currentStatus:
            json["CurrentStatus"] == null ? null : json["CurrentStatus"],
        mciNumber: json["MciNumber"] == null ? null : json["MciNumber"],
        mciStateCouncil:
            json["MciStateCouncil"] == null ? null : json["MciStateCouncil"],
        specialization:
            json["Specialization"] == null ? null : json["Specialization"],
        areaFocusOn: json["AreaFocusOn"] == null ? null : json["AreaFocusOn"],
        patientsHandledPerDay: json["PatientsHandledPerDay"] == null
            ? null
            : json["PatientsHandledPerDay"],
        patientsHandledPerSlot: json["PatientsHandledPerSlot"] == null
            ? null
            : json["PatientsHandledPerSlot"],
        appointmentType: json["AppointmentType"] == null
            ? null
            : List<String>.from(json["AppointmentType"].map((x) => x)),
        signature: json["Signature"] == null ? null : json["Signature"],
        hcpId: json["HcpId"] == null ? null : json["HcpId"],
      );

  Map<String, dynamic> toMap() => {
        "ProfessionalId": professionalId == null ? null : professionalId,
        "ProfessionalExperienceInYears": professionalExperienceInYears == null
            ? null
            : professionalExperienceInYears,
        "CurrentStatus": currentStatus == null ? null : currentStatus,
        "MciNumber": mciNumber == null ? null : mciNumber,
        "MciStateCouncil": mciStateCouncil == null ? null : mciStateCouncil,
        "Specialization": specialization == null ? null : specialization,
        "AreaFocusOn": areaFocusOn == null ? null : areaFocusOn,
        "PatientsHandledPerDay":
            patientsHandledPerDay == null ? null : patientsHandledPerDay,
        "PatientsHandledPerSlot":
            patientsHandledPerSlot == null ? null : patientsHandledPerSlot,
        "AppointmentType": appointmentType == null
            ? null
            : List<dynamic>.from(appointmentType!.map((x) => x)),
        "Signature": signature == null ? null : signature,
        "HcpId": hcpId == null ? null : hcpId,
      };
}

class Profile {
  Profile({
    this.state,
    this.city,
    this.address,
    this.pincode,
    this.timezone,
    this.hcpId,
    this.profilePicture,
  });

  String? state;
  String? city;
  String? address;
  String? pincode;
  String? timezone;
  String? profilePicture;
  int? hcpId;

  factory Profile.fromJson(String str) => Profile.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Profile.fromMap(Map<String, dynamic> json) => Profile(
        state: json["State"] == null ? null : json["State"],
        city: json["City"] == null ? null : json["City"],
        address: json["Address"] == null ? null : json["Address"],
        pincode: json["Pincode"] == null ? null : json["Pincode"],
        timezone: json["Timezone"] == null ? null : json["Timezone"],
        hcpId: json["HcpId"] == null ? null : json["HcpId"],
        profilePicture:
            json["ProfilePicture"] == null ? null : json["ProfilePicture"],
      );

  Map<String, dynamic> toMap() => {
        "State": state == null ? null : state,
        "City": city == null ? null : city,
        "Address": address == null ? null : address,
        "Pincode": pincode == null ? null : pincode,
        "Timezone": timezone == null ? null : timezone,
        "HcpId": hcpId == null ? null : hcpId,
        "ProfilePicture": profilePicture == null ? null : profilePicture,
      };
}

class Schedule {
  Schedule({
    this.id,
    this.fromDate,
    this.toDate,
    this.fromTIme,
    this.toTime,
    this.hcpId,
    this.teleconsultationFees,
    this.inclinicFees,
    this.homeFees,
  });
  int? id;
  DateTime? fromDate;
  DateTime? toDate;
  String? fromTIme;
  String? toTime;
  int? hcpId;
  int? teleconsultationFees;
  int? inclinicFees;
  int? homeFees;

  factory Schedule.fromJson(String str) => Schedule.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Schedule.fromMap(Map<String, dynamic> json) => Schedule(
        id: json["id"] == null ? null : json["id"],
        fromDate:
            json["FromDate"] == null ? null : DateTime.parse(json["FromDate"]),
        toDate: json["ToDate"] == null ? null : DateTime.parse(json["ToDate"]),
        fromTIme: json["FromTIme"] == null ? null : json["FromTIme"],
        toTime: json["ToTime"] == null ? null : json["ToTime"],
        hcpId: json["HcpId"] == null ? null : json["HcpId"],
        teleconsultationFees: json["TeleconsultationFees"] == null
            ? null
            : json["TeleconsultationFees"],
        inclinicFees:
            json["InclinicFees"] == null ? null : json["InclinicFees"],
        homeFees: json["HomeFees"] == null ? null : json["HomeFees"],
      );

  Map<String, dynamic> toMap() => {
        "FromDate": fromDate == null ? null : fromDate,
        "ToDate": toDate == null ? null : toDate,
        "FromTIme": fromTIme == null ? null : fromTIme,
        "ToTime": toTime == null ? null : toTime,
        "HcpId": hcpId == null ? null : hcpId,
        "TeleconsultationFees":
            teleconsultationFees == null ? null : teleconsultationFees,
        "InclinicFees": inclinicFees == null ? null : inclinicFees,
        "HomeFees": homeFees == null ? null : homeFees,
        "id": id == null ? null : id
      };
}

// To parse this JSON data, do
//
//     final appointmentDateTime = appointmentDateTimeFromMap(jsonString);

class AppointmentDateTime {
  AppointmentDateTime({
    this.date,
    this.time,
  });

  DateTime? date;
  String? time;

  factory AppointmentDateTime.fromJson(String str) =>
      AppointmentDateTime.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AppointmentDateTime.fromMap(Map<String, dynamic> json) =>
      AppointmentDateTime(
        date: json["Date"] == null ? null : DateTime.parse(json["Date"]),
        time: json["Time"] == null ? null : json["Time"],
      );

  Map<String, dynamic> toMap() => {
        "Date": date == null ? null : date,
        "Time": time == null ? null : time,
      };
}
