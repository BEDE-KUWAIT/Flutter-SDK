import 'dart:convert';

class CheckStatusRequest {
  final String mid;
  final List<String> merchantTxnRefNo;
  final String hashMac;

  CheckStatusRequest({required this.mid, required this.merchantTxnRefNo, required this.hashMac});

  CheckStatusRequest copyWith({String? mid, List<String>? merchantTxnRefNo, String? hashMac}) =>
      CheckStatusRequest(mid: mid ?? this.mid, merchantTxnRefNo: merchantTxnRefNo ?? this.merchantTxnRefNo, hashMac: hashMac ?? this.hashMac);

  factory CheckStatusRequest.fromRawJson(String str) => CheckStatusRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CheckStatusRequest.fromJson(Map<String, dynamic> json) =>
      CheckStatusRequest(mid: json["Mid"], merchantTxnRefNo: List<String>.from(json["MerchantTxnRefNo"].map((x) => x)), hashMac: json["HashMac"]);

  Map<String, dynamic> toJson() => {"Mid": mid, "MerchantTxnRefNo": List<dynamic>.from(merchantTxnRefNo.map((x) => x)), "HashMac": hashMac};
}
