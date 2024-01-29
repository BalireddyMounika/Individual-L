// To parse this JSON data, do
//
//     final agoraToken = agoraTokenFromMap(jsonString);

import 'dart:convert';

class AgoraTokenRequest {
  AgoraTokenRequest({
    this.channelName,
  });

  String? channelName;

  factory AgoraTokenRequest.fromJson(String str) => AgoraTokenRequest.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AgoraTokenRequest.fromMap(Map<String, dynamic> json) => AgoraTokenRequest(
    channelName: json["channelName"],
  );

  Map<String, dynamic> toMap() => {
    "channelName": channelName,
  };
}
