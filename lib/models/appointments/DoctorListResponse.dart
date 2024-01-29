// To parse this JSON data, do
//
//     final doctorListResponse = doctorListResponseFromMap(jsonString);

import 'dart:convert';

DoctorListResponse doctorListResponseFromMap(String str) =>
    DoctorListResponse.fromMap(json.decode(str));

String doctorListResponseToMap(DoctorListResponse data) =>
    json.encode(data.toMap());

class DoctorListResponse {
  DoctorListResponse({
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
    this.scheduleV2,
    this.professional,
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
  List<ScheduleV2>? scheduleV2;
  Professional? professional;

  factory DoctorListResponse.fromMap(Map<String, dynamic> json) =>
      DoctorListResponse(
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
        scheduleV2: json["ScheduleV2"] == null
            ? []
            : List<ScheduleV2>.from(
                json["ScheduleV2"]?.map((x) => ScheduleV2.fromMap(x))),
        professional: json["Professional"] == null
            ? null
            : Professional.fromMap(json["Professional"]),
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
        "ScheduleV2": scheduleV2 == null
            ? []
            : List<dynamic>.from(scheduleV2!.map((x) => x.toMap())),
        "Professional": professional?.toMap(),
      };
}

class Professional {
  Professional({
    this.specialization,
  });

  String? specialization;

  factory Professional.fromMap(Map<String, dynamic> json) => Professional(
        specialization: json["Specialization"],
      );

  Map<String, dynamic> toMap() => {
        "Specialization": specialization,
      };
}

class Profile {
  Profile({
    this.profilePicture,
  });

  String? profilePicture;

  factory Profile.fromMap(Map<String, dynamic> json) => Profile(
        profilePicture: json["ProfilePicture"],
      );

  Map<String, dynamic> toMap() => {
        "ProfilePicture": profilePicture,
      };
}

class ScheduleV2 {
  ScheduleV2({
    this.typeConsultation,
  });

  TypeConsultation? typeConsultation;

  factory ScheduleV2.fromMap(Map<String, dynamic> json) => ScheduleV2(
        typeConsultation: typeConsultationValues.map[json["TypeConsultation"]],
      );

  Map<String, dynamic> toMap() => {
        "TypeConsultation": typeConsultationValues.reverse[typeConsultation],
      };
}

enum TypeConsultation { TELECONSULTATION, HOME, INCLINIC }

final typeConsultationValues = EnumValues({
  "Home": TypeConsultation.HOME,
  "Teleconsultation": TypeConsultation.TELECONSULTATION,
  "In-clinic": TypeConsultation.INCLINIC,
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
