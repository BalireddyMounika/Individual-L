import 'dart:convert';

class SubscriptionModelRequest {
  SubscriptionModelRequest({
    this.subscriptionId,
    this.userId,
    this.transactionId,
    this.expired,
  });

  int? subscriptionId;
  int? userId;
  String? transactionId;
  String? expired;

  factory SubscriptionModelRequest.fromJson(String str) => SubscriptionModelRequest.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SubscriptionModelRequest.fromMap(Map<String, dynamic> json) => SubscriptionModelRequest(
    subscriptionId: json["SubscriptionId"] == null ? null : json["SubscriptionId"],
    userId: json["UserId"] == null ? null : json["UserId"],
    transactionId: json["TransactionId"] == null ? null : json["TransactionId"],
    expired: json["Expired"] == null ? null : json["Expired"],
  );

  Map<String, dynamic> toMap() => {
    "SubscriptionId": subscriptionId == null ? null : subscriptionId,
    "UserId": userId == null ? null : userId,
    "TransactionId": transactionId == null ? null : transactionId,
    "Expired": expired == null ? null : expired,
  };
}