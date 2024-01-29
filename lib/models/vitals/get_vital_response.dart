import 'dart:convert';

GetVitalResponse getVitalResponseFromMap(String str) =>
    GetVitalResponse.fromMap(json.decode(str));

String getVitalResponseToMap(GetVitalResponse data) =>
    json.encode(data.toMap());

class GetVitalResponse {
  GetVitalResponse({
    this.id,
    this.userId,
    this.familyId,
    this.height,
    this.weight,
    this.bmi,
    this.temperature,
    this.spo2,
    this.systolic,
    this.diastolic,
    this.bp,
    this.pulse,
    this.updatedOn,
  });

  int? id;
  Profile? userId;
  int? familyId;
  int? height;
  double? weight;
  double? bmi;
  String? temperature;
  int? spo2;
  int? systolic;
  int? diastolic;
  double? bp;
  int? pulse;
  String? updatedOn;

  factory GetVitalResponse.fromMap(Map<String, dynamic> json) =>
      GetVitalResponse(
          id: json["id"] == null ? null : json["id"],
          userId:
              json["UserId"] == null ? null : Profile.fromMap(json["UserId"]),
          familyId:
              json["FamilyMemberId"] == null ? null : json["FamilyMemberId"],
          height: json["Height"] == null ? null : json["Height"],
          weight: json["Weight"] == null ? null : json["Weight"],
          bmi: json["BMI"] == null ? null : json["BMI"],
          temperature: json["Temperature"] == null ? null : json["Temperature"],
          spo2: json["Spo2"] == null ? null : json["Spo2"],
          systolic: json["systolic"] == null ? null : json["systolic"],
          diastolic: json["diastolic"] == null ? null : json["diastolic"],
          bp: json["BP"] == null ? null : json["BP"],
          pulse: json["Pulse"] == null ? null : json["Pulse"],
          updatedOn: json["UpdatedOn"] == null ? null : json["UpdatedOn"]);

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "UserId": userId == null ? null : userId!.toMap(),
        "FamilyMemberId": familyId == null ? null : familyId,
        "Height": height == null ? null : height,
        "Weight": weight == null ? null : weight,
        "BMI": bmi == null ? null : bmi,
        "Temperature": temperature == null ? null : temperature,
        "Spo2": spo2 == null ? null : spo2,
        "BP": bp == null ? null : bp,
        "Pulse": pulse == null ? null : pulse,
        "UpdatedOn": updatedOn == null ? null : updatedOn
      };
}

class Profile {
  Profile({
    this.profile,
  });

  ProfileClass? profile;

  factory Profile.fromJson(String str) => Profile.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Profile.fromMap(Map<String, dynamic> json) => Profile(
        profile: json["Profile"] == null
            ? null
            : ProfileClass.fromMap(json["Profile"]),
      );

  Map<String, dynamic> toMap() => {
        "Profile": profile == null ? null : profile!.toMap(),
      };
}

class ProfileClass {
  ProfileClass({
    this.userId,
    this.dob,
  });

  int? userId;
  String? dob;

  factory ProfileClass.fromJson(String str) =>
      ProfileClass.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ProfileClass.fromMap(Map<String, dynamic> json) => ProfileClass(
        userId: json["UserId"] == null ? null : json["UserId"],
        dob: json["DOB"] == null ? null : json["DOB"],
      );

  Map<String, dynamic> toMap() => {
        "UserId": userId == null ? null : userId,
        "DOB": dob == null ? null : dob,
      };
}
