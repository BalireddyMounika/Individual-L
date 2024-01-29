// To parse this JSON data, do
//
//     final paymentTransactionResponse = paymentTransactionResponseFromMap(jsonString);

import 'dart:convert';

class PaymentTransactionResponse {
  PaymentTransactionResponse(
      {this.transactionId,
      this.date,
      this.amount,
      this.doctorId,
      this.userId,
      this.appointmentType,
      this.maskTransactionId,
      this.transactionFor});

  final String? transactionId;
  final String? date;
  final int? amount;
  final String? doctorId;
  final int? userId;
  final String? appointmentType;
  final String? maskTransactionId;
  final String? transactionFor;

  factory PaymentTransactionResponse.fromJson(String str) =>
      PaymentTransactionResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PaymentTransactionResponse.fromMap(Map<String, dynamic> json) =>
      PaymentTransactionResponse(
        transactionId:
            json["TransactionId"] == null ? null : json["TransactionId"],
        date: json["Date"] == null ? null : json["Date"],
        amount: json["Amount"] == null ? null : json["Amount"],
        doctorId: json["DoctorId"] == null ? null : json["DoctorId"],
        userId: json["UserId"] == null ? null : json["UserId"],
        appointmentType:
            json["AppointmentType"] == null ? null : json["AppointmentType"],
        maskTransactionId: json["MaskTransactionId"] == null
            ? null
            : json["MaskTransactionId"],
        transactionFor:
            json["TransactionFor"] == null ? null : json["TransactionFor"],
      );

  Map<String, dynamic> toMap() => {
        "TransactionId": transactionId == null ? null : transactionId,
        "Date": date == null ? null : date,
        "Amount": amount == null ? null : amount,
        "DoctorId": doctorId == null ? null : doctorId,
        "UserId": userId == null ? null : userId,
        "AppointmentType": appointmentType == null ? null : appointmentType,
        "MaskTransactionId":
            maskTransactionId == null ? null : maskTransactionId,
        "TransactionFor": transactionFor == null ? null : transactionFor
      };
}
