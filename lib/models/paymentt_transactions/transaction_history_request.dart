// To parse this JSON data, do
//
//     final transactionHistoryRequest = transactionHistoryRequestFromMap(jsonString);

import 'dart:convert';

class TransactionHistoryRequest {
  TransactionHistoryRequest({
    this.transactionId,
    this.date,
    this.amount,
    this.userId,
    this.transactionFor,
    this.transactionStatus,
    this.maskTransactionId,
  });

  String? transactionId;
  String? date;
  int? amount;
  int? userId;
  String? transactionFor;
  String? transactionStatus;
  String? maskTransactionId;

  factory TransactionHistoryRequest.fromJson(String str) => TransactionHistoryRequest.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TransactionHistoryRequest.fromMap(Map<String, dynamic> json) => TransactionHistoryRequest(
    transactionId: json["TransactionId"] == null ? null : json["TransactionId"],
    date: json["Date"] == null ? null : json["Date"],
    amount: json["Amount"] == null ? null : json["Amount"],
    userId: json["UserId"] == null ? null : json["UserId"],
    transactionFor: json["TransactionFor"] == null ? null : json["TransactionFor"],
    transactionStatus: json["TransactionStatus"] == null ? null : json["TransactionStatus"],
    maskTransactionId: json["MaskTransactionId"] == null ? null : json["MaskTransactionId"],
  );

  Map<String, dynamic> toMap() => {
    "TransactionId": transactionId == null ? null : transactionId,
    "Date": date == null ? null : date,
    "Amount": amount == null ? null : amount,
    "UserId": userId == null ? null : userId,
    "TransactionFor": transactionFor == null ? null : transactionFor,
    "TransactionStatus": transactionStatus == null ? null : transactionStatus,
    "MaskTransactionId": maskTransactionId == null ? null : maskTransactionId,
  };
}
