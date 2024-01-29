// To parse this JSON data, do
//
//     final getAllPharmacyListResponse = getAllPharmacyListResponseFromMap(jsonString);

import 'dart:convert';

class GetAllPharmacyListResponse {
  GetAllPharmacyListResponse({
    this.id,
    this.professionalId,
    this.pharmacyName,
    this.pharmacyRegistrationNumber,
    this.pharmacyEmailId,
    this.pharmacyContactNumber,
    this.pharmacyWebsiteUrl,
    this.pharmacyOpenTime,
    this.pharmacyCloseTime,
    this.uploadPharmacyImages,
    this.uploadRegisterationDocuments,
    this.authorizedLicenseNumber,
    this.authorizedFirstName,
    this.authorizedLastName,
    this.authorizedEmailId,
    this.authorizedMobileNumber,
    this.pharmacyAdd,
    this.address,
  });

  int? id;
  int? professionalId;
  String? pharmacyName;
  String? pharmacyRegistrationNumber;
  String? pharmacyEmailId;
  String? pharmacyContactNumber;
  String? pharmacyWebsiteUrl;
  String? pharmacyOpenTime;
  String? pharmacyCloseTime;
  String? uploadPharmacyImages;
  String? uploadRegisterationDocuments;
  String? authorizedLicenseNumber;
  String? authorizedFirstName;
  String? authorizedLastName;
  String? authorizedEmailId;
  String? authorizedMobileNumber;
  String? pharmacyAdd;
  Address? address;

  factory GetAllPharmacyListResponse.fromJson(String str) => GetAllPharmacyListResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetAllPharmacyListResponse.fromMap(Map<String, dynamic> json) => GetAllPharmacyListResponse(
    id: json["id"] == null ? null : json["id"],
    professionalId : json["ProfessionalId"] ==null ? null :json["ProfessionalId"],
    pharmacyName: json["PharmacyName"] == null ? null : json["PharmacyName"],
    pharmacyRegistrationNumber: json["PharmacyRegistrationNumber"] == null ? null : json["PharmacyRegistrationNumber"],
    pharmacyEmailId: json["PharmacyEmailId"] == null ? null : json["PharmacyEmailId"],
    pharmacyContactNumber: json["PharmacyContactNumber"] == null ? null : json["PharmacyContactNumber"],
    pharmacyWebsiteUrl: json["PharmacyWebsiteUrl"] == null ? null : json["PharmacyWebsiteUrl"],
    pharmacyOpenTime: json["Pharmacy_OpenTime"] == null ? null : json["Pharmacy_OpenTime"],
    pharmacyCloseTime: json["Pharmacy_CloseTime"] == null ? null : json["Pharmacy_CloseTime"],
    uploadPharmacyImages: json["UploadPharmacyImages"] == null ? null : json["UploadPharmacyImages"],
    uploadRegisterationDocuments: json["UploadRegisterationDocuments"] == null ? null : json["UploadRegisterationDocuments"],
    authorizedLicenseNumber: json["Authorized_LicenseNumber"] == null ? null : json["Authorized_LicenseNumber"],
    authorizedFirstName: json["Authorized_FirstName"] == null ? null : json["Authorized_FirstName"],
    authorizedLastName: json["Authorized_LastName"] == null ? null : json["Authorized_LastName"],
    authorizedEmailId: json["Authorized_EmailId"] == null ? null : json["Authorized_EmailId"],
    authorizedMobileNumber: json["Authorized_MobileNumber"] == null ? null : json["Authorized_MobileNumber"],
    pharmacyAdd: json["Pharmacy_Address"] == null ? null : json["Pharmacy_Address"],
    address: json["address"] == null ? null : Address.fromMap(json["address"]),
  );

  Map<String, dynamic> toMap() => {
    "id": id == null ? null : id,
    "ProfessionalId" : professionalId == null ? null :professionalId,
    "PharmacyName": pharmacyName == null ? null : pharmacyName,
    "PharmacyRegistrationNumber": pharmacyRegistrationNumber == null ? null : pharmacyRegistrationNumber,
    "PharmacyEmailId": pharmacyEmailId == null ? null : pharmacyEmailId,
    "PharmacyContactNumber": pharmacyContactNumber == null ? null : pharmacyContactNumber,
    "PharmacyWebsiteUrl": pharmacyWebsiteUrl == null ? null : pharmacyWebsiteUrl,
    "Pharmacy_OpenTime": pharmacyOpenTime == null ? null : pharmacyOpenTime,
    "Pharmacy_CloseTime": pharmacyCloseTime == null ? null : pharmacyCloseTime,
    "UploadPharmacyImages": uploadPharmacyImages == null ? null : uploadPharmacyImages,
    "UploadRegisterationDocuments": uploadRegisterationDocuments == null ? null : uploadRegisterationDocuments,
    "Authorized_LicenseNumber": authorizedLicenseNumber == null ? null : authorizedLicenseNumber,
    "Authorized_FirstName": authorizedFirstName == null ? null : authorizedFirstName,
    "Authorized_LastName": authorizedLastName == null ? null : authorizedLastName,
    "Authorized_EmailId": authorizedEmailId == null ? null : authorizedEmailId,
    "Authorized_MobileNumber": authorizedMobileNumber == null ? null : authorizedMobileNumber,
    "Pharmacy_Address" : pharmacyAdd == null ? null :pharmacyAdd,
    "address": address == null ? null : address!.toMap(),
  };
}

class Address {
  Address({
    this.state,
    this.city,
    this.country,
    this.zipcode,
    this.address,
    this.primaryContactNumber,
    this.pharmacyId,
  });

  String? state;
  String? city;
  String? country;
  int? zipcode;
  String? address;
  String? primaryContactNumber;
  int? pharmacyId;

  factory Address.fromJson(String str) => Address.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Address.fromMap(Map<String, dynamic> json) => Address(
    state: json["State"] == null ? null : json["State"],
    city: json["City"] == null ? null : json["City"],
    country: json["Country"] == null ? null : json["Country"],
    zipcode: json["Zipcode"] == null ? null : json["Zipcode"],
    address: json["Address"] == null ? null : json["Address"],
    primaryContactNumber: json["PrimaryContactNumber"] == null ? null : json["PrimaryContactNumber"],
    pharmacyId: json["PharmacyId"] == null ? null : json["PharmacyId"],
  );

  Map<String, dynamic> toMap() => {
    "State": state == null ? null : state,
    "City": city == null ? null : city,
    "Country": country == null ? null : country,
    "Zipcode": zipcode == null ? null : zipcode,
    "Address": address == null ? null : address,
    "PrimaryContactNumber": primaryContactNumber == null ? null : primaryContactNumber,
    "PharmacyId": pharmacyId == null ? null : pharmacyId,
  };
}
