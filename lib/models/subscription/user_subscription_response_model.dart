// To parse this JSON data, do
//
//     final userSubscriptionResponseModel = userSubscriptionResponseModelFromMap(jsonString);

import 'dart:convert';

class UserSubscriptionResponseModel {
  UserSubscriptionResponseModel({
    this.subscriptionId,
    this.userId,
    this.transactionId,
    this.expired,
  });

  SubscriptionId? subscriptionId;
  int? userId;
  String? transactionId;
  String? expired;

  factory UserSubscriptionResponseModel.fromJson(String str) => UserSubscriptionResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UserSubscriptionResponseModel.fromMap(Map<String, dynamic> json) => UserSubscriptionResponseModel(
    subscriptionId: json["SubscriptionId"] == null ? null : SubscriptionId.fromMap(json["SubscriptionId"]),
    userId: json["UserId"] == null ? null : json["UserId"],
    transactionId: json["TransactionId"] == null ? null : json["TransactionId"],
    expired: json["Expired"] == null ? null : json["Expired"],
  );

  Map<String, dynamic> toMap() => {
    "SubscriptionId": subscriptionId == null ? null : subscriptionId?.toMap(),
    "UserId": userId == null ? null : userId,
    "TransactionId": transactionId == null ? null : transactionId,
    "Expired": expired == null ? null : expired,
  };
}

class SubscriptionId {
  SubscriptionId({
    this.id,
    this.subscriptionName,
    this.subscriptionDetails,
    this.subscriptionValidity,
    this.subscriptionPrice,
    this.numberOfAppointment,
    this.subscriptionDiscount,
    this.applicablePartner,
    this.firstTimeUser,
    this.repeatedSubscription,
    this.subscriptionApplicableFor,
  });

  int? id;
  String? subscriptionName;
  String? subscriptionDetails;
  int? subscriptionValidity;
  int? subscriptionPrice;
  int? numberOfAppointment;
  String? subscriptionDiscount;
  String? applicablePartner;
  String? firstTimeUser;
  String? repeatedSubscription;
  String? subscriptionApplicableFor;

  factory SubscriptionId.fromJson(String str) => SubscriptionId.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SubscriptionId.fromMap(Map<String, dynamic> json) => SubscriptionId(
    id: json["id"] == null ? null : json["id"],
    subscriptionName: json["SubscriptionName"] == null ? null : json["SubscriptionName"],
    subscriptionDetails: json["SubscriptionDetails"] == null ? null : json["SubscriptionDetails"],
    subscriptionValidity: json["SubscriptionValidity"] == null ? null : json["SubscriptionValidity"],
    subscriptionPrice: json["SubscriptionPrice"] == null ? null : json["SubscriptionPrice"],
    numberOfAppointment: json["NumberOfAppointment"] == null ? null : json["NumberOfAppointment"],
    subscriptionDiscount: json["SubscriptionDiscount"] == null ? null : json["SubscriptionDiscount"],
    applicablePartner: json["ApplicablePartner"] == null ? null : json["ApplicablePartner"],
    firstTimeUser: json["FirstTimeUser"] == null ? null : json["FirstTimeUser"],
    repeatedSubscription: json["RepeatedSubscription"] == null ? null : json["RepeatedSubscription"],
    subscriptionApplicableFor: json["SubscriptionApplicableFor"] == null ? null : json["SubscriptionApplicableFor"],
  );

  Map<String, dynamic> toMap() => {
    "id": id == null ? null : id,
    "SubscriptionName": subscriptionName == null ? null : subscriptionName,
    "SubscriptionDetails": subscriptionDetails == null ? null : subscriptionDetails,
    "SubscriptionValidity": subscriptionValidity == null ? null : subscriptionValidity,
    "SubscriptionPrice": subscriptionPrice == null ? null : subscriptionPrice,
    "NumberOfAppointment": numberOfAppointment == null ? null : numberOfAppointment,
    "SubscriptionDiscount": subscriptionDiscount == null ? null : subscriptionDiscount,
    "ApplicablePartner": applicablePartner == null ? null : applicablePartner,
    "FirstTimeUser": firstTimeUser == null ? null : firstTimeUser,
    "RepeatedSubscription": repeatedSubscription == null ? null : repeatedSubscription,
    "SubscriptionApplicableFor": subscriptionApplicableFor == null ? null : subscriptionApplicableFor,
  };
}
