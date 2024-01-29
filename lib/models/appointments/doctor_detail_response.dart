// To parse this JSON data, do
//
//     final doctorDetailsResponse = doctorDetailsResponseFromMap(jsonString);

import 'dart:convert';

class DoctorDetailsResponse {
  DoctorDetailsResponse({
    this.id,
    this.firstname,
    this.lastname,
    this.email,
    this.username,
    this.password,
    this.mobileNumber,
    this.tag,
    this.deviceToken,
    this.profile,
    this.hcpIdScheduleV2,
    this.professional,
    this.education,
  });

  int? id;
  String? firstname;
  String? lastname;
  String? email;
  String? username;
  String? password;
  String? mobileNumber;
  String? tag;
  String? deviceToken;
  Profile? profile;
  List<HcpIdScheduleV2>? hcpIdScheduleV2;
  Professional? professional;
  Education? education;

  factory DoctorDetailsResponse.fromJson(String str) =>
      DoctorDetailsResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DoctorDetailsResponse.fromMap(Map<String, dynamic> json) =>
      DoctorDetailsResponse(
        id: json["id"],
        firstname: json["Firstname"],
        lastname: json["Lastname"],
        email: json["Email"],
        username: json["Username"],
        password: json["Password"],
        mobileNumber: json["MobileNumber"],
        tag: json["Tag"],
        deviceToken: json["DeviceToken"],
        profile:
            json["Profile"] == null ? null : Profile.fromMap(json["Profile"]),
        hcpIdScheduleV2: json["HcpIdScheduleV2"] == null
            ? []
            : List<HcpIdScheduleV2>.from(json["HcpIdScheduleV2"]!
                .map((x) => HcpIdScheduleV2.fromMap(x))),
        professional: json["Professional"] == null
            ? null
            : Professional.fromMap(json["Professional"]),
        education: json["Education"] == null
            ? null
            : Education.fromMap(json["Education"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "Firstname": firstname,
        "Lastname": lastname,
        "Email": email,
        "Username": username,
        "Password": password,
        "MobileNumber": mobileNumber,
        "Tag": tag,
        "DeviceToken": deviceToken,
        "Profile": profile?.toMap(),
        "HcpIdScheduleV2": hcpIdScheduleV2 == null
            ? []
            : List<dynamic>.from(hcpIdScheduleV2!.map((x) => x.toMap())),
        "Professional": professional?.toMap(),
        "Education": education?.toMap(),
      };
}

class Education {
  Education({
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

  factory Education.fromJson(String str) => Education.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Education.fromMap(Map<String, dynamic> json) => Education(
        degree: json["Degree"],
        collegeUniversity: json["CollegeUniversity"],
        yearOfEducation: json["YearOfEducation"],
        educationalLocation: json["EducationalLocation"],
        hcpId: json["HcpId"],
      );

  Map<String, dynamic> toMap() => {
        "Degree": degree,
        "CollegeUniversity": collegeUniversity,
        "YearOfEducation": yearOfEducation,
        "EducationalLocation": educationalLocation,
        "HcpId": hcpId,
      };
}

class HcpIdScheduleV2 {
  HcpIdScheduleV2({
    this.id,
    this.scheduleV2Id,
    this.hcpId,
    this.scheduleName,
    this.slotTimings,
    this.fees,
    this.fromTime,
    this.toTime,
  });

  int? id;
  ScheduleV2Id? scheduleV2Id;
  int? hcpId;
  String? scheduleName;
  int? slotTimings;
  int? fees;
  String? fromTime;
  String? toTime;

  factory HcpIdScheduleV2.fromJson(String str) =>
      HcpIdScheduleV2.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory HcpIdScheduleV2.fromMap(Map<String, dynamic> json) => HcpIdScheduleV2(
        id: json["id"],
        scheduleV2Id: json["ScheduleV2Id"] == null
            ? null
            : ScheduleV2Id.fromMap(json["ScheduleV2Id"]),
        hcpId: json["HcpId"],
        scheduleName: json["ScheduleName"],
        slotTimings: json["SlotTimings"],
        fees: json["Fees"],
        fromTime: json["FromTime"],
        toTime: json["ToTime"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "ScheduleV2Id": scheduleV2Id?.toMap(),
        "HcpId": hcpId,
        "ScheduleName": scheduleName,
        "SlotTimings": slotTimings,
        "Fees": fees,
        "FromTime": fromTime,
        "ToTime": toTime,
      };
}

class ScheduleV2Id {
  ScheduleV2Id({
    this.id,
    this.hcpId,
    this.clinicId,
    this.typeConsultation,
    this.fromDate,
    this.toDate,
  });

  int? id;
  int? hcpId;
  ClinicId? clinicId;
  String? typeConsultation;
  DateTime? fromDate;
  DateTime? toDate;

  factory ScheduleV2Id.fromJson(String str) =>
      ScheduleV2Id.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ScheduleV2Id.fromMap(Map<String, dynamic> json) => ScheduleV2Id(
        id: json["id"],
        hcpId: json["HcpId"],
        clinicId: json["ClinicId"] == null
            ? null
            : ClinicId.fromMap(json["ClinicId"]),
        typeConsultation: json["TypeConsultation"],
        fromDate:
            json["FromDate"] == null ? null : DateTime.parse(json["FromDate"]),
        toDate: json["ToDate"] == null ? null : DateTime.parse(json["ToDate"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "HcpId": hcpId,
        "ClinicId": clinicId?.toMap(),
        "TypeConsultation": typeConsultation,
        "FromDate":
            "${fromDate!.year.toString().padLeft(4, '0')}-${fromDate!.month.toString().padLeft(2, '0')}-${fromDate!.day.toString().padLeft(2, '0')}",
        "ToDate":
            "${toDate!.year.toString().padLeft(4, '0')}-${toDate!.month.toString().padLeft(2, '0')}-${toDate!.day.toString().padLeft(2, '0')}",
      };
}

class ClinicId {
  ClinicId({
    this.id,
    this.clinicName,
  });

  int? id;
  String? clinicName;

  factory ClinicId.fromJson(String str) => ClinicId.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ClinicId.fromMap(Map<String, dynamic> json) => ClinicId(
        id: json["id"],
        clinicName: json["ClinicName"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "ClinicName": clinicName,
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
    this.signature,
    this.hcpId,
  });

  String? professionalId;
  int? professionalExperienceInYears;
  String? currentStatus;
  int? mciNumber;
  String? mciStateCouncil;
  String? specialization;
  String? areaFocusOn;
  String? signature;
  int? hcpId;

  factory Professional.fromJson(String str) =>
      Professional.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Professional.fromMap(Map<String, dynamic> json) => Professional(
        professionalId: json["ProfessionalId"],
        professionalExperienceInYears: json["ProfessionalExperienceInYears"],
        currentStatus: json["CurrentStatus"],
        mciNumber: json["MciNumber"],
        mciStateCouncil: json["MciStateCouncil"],
        specialization: json["Specialization"],
        areaFocusOn: json["AreaFocusOn"],
        signature: json["Signature"],
        hcpId: json["HcpId"],
      );

  Map<String, dynamic> toMap() => {
        "ProfessionalId": professionalId,
        "ProfessionalExperienceInYears": professionalExperienceInYears,
        "CurrentStatus": currentStatus,
        "MciNumber": mciNumber,
        "MciStateCouncil": mciStateCouncil,
        "Specialization": specialization,
        "AreaFocusOn": areaFocusOn,
        "Signature": signature,
        "HcpId": hcpId,
      };
}

class Profile {
  Profile({
    this.id,
    this.hcpId,
    this.state,
    this.city,
    this.address,
    this.pincode,
    this.timezone,
    this.profilePicture,
  });

  int? id;
  int? hcpId;
  String? state;
  String? city;
  String? address;
  String? pincode;
  String? timezone;
  String? profilePicture;

  factory Profile.fromJson(String str) => Profile.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Profile.fromMap(Map<String, dynamic> json) => Profile(
        id: json["id"],
        hcpId: json["HcpId"],
        state: json["State"],
        city: json["City"],
        address: json["Address"],
        pincode: json["Pincode"],
        timezone: json["Timezone"],
        profilePicture: json["ProfilePicture"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "HcpId": hcpId,
        "State": state,
        "City": city,
        "Address": address,
        "Pincode": pincode,
        "Timezone": timezone,
        "ProfilePicture": profilePicture,
      };
}
