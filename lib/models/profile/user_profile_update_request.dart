// To parse this JSON data, do
//
//     final userProfileRequest = userProfileRequestFromMap(jsonString);

// import 'dart:convert';
//
// class UserProfileRequest {
//   UserProfileRequest({
//     this.userId,
//     this.title,
//     this.gender,
//     this.profilePicture,
//     this.dob,
//     this.martialStatus,
//     this.bloodGroup,
//   });
//
//   UserId? userId;
//   String? title;
//   String? gender;
//   String?profilePicture;
//   String? dob;
//   String?martialStatus;
//   String? bloodGroup;
//
//   factory UserProfileRequest.fromJson(String str) => UserProfileRequest.fromMap(json.decode(str));
//
//   String toJson() => json.encode(toMap());
//
//   factory UserProfileRequest.fromMap(Map<String, dynamic> json) => UserProfileRequest(
//     userId: json["UserId"] == null ? null : UserId.fromMap(json["UserId"]),
//     title: json["Title"] == null ? null : json["Title"],
//     gender: json["Gender"] == null ? null : json["Gender"],
//     profilePicture: json["ProfilePicture"] == null ? null : json["ProfilePicture"],
//     dob: json["DOB"] == null ? null : json["DOB"],
//     martialStatus: json["MartialStatus"] == null ? null : json["MartialStatus"],
//     bloodGroup: json["BloodGroup"] == null ? null : json["BloodGroup"],
//   );
//
//   Map<String, dynamic> toMap() => {
//     "UserId": userId == null ? null : userId!.toMap(),
//     "Title": title == null ? null : title,
//     "Gender": gender == null ? null : gender,
//     "ProfilePicture": profilePicture == null ? null : profilePicture,
//     "DOB": dob == null ? null : dob,
//     "MartialStatus": martialStatus == null ? null : martialStatus,
//     "BloodGroup": bloodGroup == null ? null : bloodGroup,
//   };
// }
//
// class UserId {
//   UserId({
//     this.firstname,
//     this.lastname,
//     this.email,
//   });
//
//   String? firstname;
//   String? lastname;
//   String? email;
//
//   factory UserId.fromJson(String str) => UserId.fromMap(json.decode(str));
//
//   String toJson() => json.encode(toMap());
//
//   factory UserId.fromMap(Map<String, dynamic> json) => UserId(
//     firstname: json["Firstname"] == null ? null : json["Firstname"],
//     lastname: json["Lastname"] == null ? null : json["Lastname"],
//     email: json["Email"] == null ? null : json["Email"],
//   );
//
//   Map<String, dynamic> toMap() => {
//     "Firstname": firstname == null ? null : firstname,
//     "Lastname": lastname == null ? null : lastname,
//     "Email": email == null ? null : email,
//   };
// }
// To parse this JSON data, do
//
//     final userProfileUpdateRequest = userProfileUpdateRequestFromMap(jsonString);

import 'dart:convert';

class UserProfileUpdateRequest {
  UserProfileUpdateRequest({
    this.userId,
    this.title,
    this.gender,
    this.profilePicture,
    this.dob,
    this.martialStatus,
    this.bloodGroup,
  });

  UserId? userId;
  String? title;
  String? gender;
  String? profilePicture;
  String? dob;
  String?martialStatus;
  String? bloodGroup;

  factory UserProfileUpdateRequest.fromJson(String str) => UserProfileUpdateRequest.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UserProfileUpdateRequest.fromMap(Map<String, dynamic> json) => UserProfileUpdateRequest(
    userId: json["UserId"] == null ? null : UserId.fromMap(json["UserId"]),
    title: json["Title"] == null ? null : json["Title"],
    gender: json["Gender"] == null ? null : json["Gender"],
    profilePicture: json["ProfilePicture"] == null ? null : json["ProfilePicture"],
    dob: json["DOB"] == null ? null : json["DOB"],
    martialStatus: json["MartialStatus"] == null ? null : json["MartialStatus"],
    bloodGroup: json["BloodGroup"] == null ? null : json["BloodGroup"],
  );

  Map<String, dynamic> toMap() => {
    "UserId": userId == null ? null : userId!.toMap(),
    "Title": title == null ? null : title,
    "Gender": gender == null ? null : gender,
    "ProfilePicture": profilePicture == null ? null : profilePicture,
    "DOB": dob == null ? null : dob,
    "MartialStatus": martialStatus == null ? null : martialStatus,
    "BloodGroup": bloodGroup == null ? null : bloodGroup,
  };
}

class UserId {
  UserId({
    this.firstname,
    this.lastname,
    this.email,
  });

  String? firstname;
  String? lastname;
  String? email;

  factory UserId.fromJson(String str) => UserId.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UserId.fromMap(Map<String, dynamic> json) => UserId(
    firstname: json["Firstname"] == null ? null : json["Firstname"],
    lastname: json["Lastname"] == null ? null : json["Lastname"],
    email: json["Email"] == null ? null : json["Email"],
  );

  Map<String, dynamic> toMap() => {
    "Firstname": firstname == null ? null : firstname,
    "Lastname": lastname == null ? null : lastname,
    "Email": email == null ? null : email,
  };
}

