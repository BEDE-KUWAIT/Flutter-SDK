class CheckStatusResponse {
  final List<PaymentStatus> paymentStatus;

  CheckStatusResponse({required this.paymentStatus});

  factory CheckStatusResponse.fromJson(Map<String, dynamic> json) =>
      CheckStatusResponse(paymentStatus: List<PaymentStatus>.from(json["PaymentStatus"].map((x) => PaymentStatus.fromJson(x))));

  Map<String, dynamic> toJson() => {"PaymentStatus": List<dynamic>.from(paymentStatus.map((x) => x.toJson()))};
}

class PaymentStatus {
  final String merchantTxnRefNo;
  final String paymentId;
  final dynamic processDate;
  final String statusDescription;
  final String bookeeyTrackId;
  final String bankRefNo;
  final String paymentType;
  final String errorCode;
  final String productType;
  final String finalStatus;
  final dynamic cardNo;
  final dynamic authCode;
  final String paymentLink;
  final dynamic merchTxnRefno;

  PaymentStatus({
    required this.merchantTxnRefNo,
    required this.paymentId,
    required this.processDate,
    required this.statusDescription,
    required this.bookeeyTrackId,
    required this.bankRefNo,
    required this.paymentType,
    required this.errorCode,
    required this.productType,
    required this.finalStatus,
    required this.cardNo,
    required this.authCode,
    required this.paymentLink,
    required this.merchTxnRefno,
  });

  factory PaymentStatus.fromJson(Map<String, dynamic> json) => PaymentStatus(
    merchantTxnRefNo: json["MerchantTxnRefNo"],
    paymentId: json["PaymentId"],
    processDate: json["ProcessDate"],
    statusDescription: json["StatusDescription"],
    bookeeyTrackId: json["BookeeyTrackId"],
    bankRefNo: json["BankRefNo"],
    paymentType: json["PaymentType"],
    errorCode: json["ErrorCode"],
    productType: json["ProductType"],
    finalStatus: json["finalStatus"],
    cardNo: json["CardNo"],
    authCode: json["AuthCode"],
    paymentLink: json["PaymentLink"],
    merchTxnRefno: json["merchTxnRefno"],
  );

  Map<String, dynamic> toJson() => {
    "MerchantTxnRefNo": merchantTxnRefNo,
    "PaymentId": paymentId,
    "ProcessDate": processDate,
    "StatusDescription": statusDescription,
    "BookeeyTrackId": bookeeyTrackId,
    "BankRefNo": bankRefNo,
    "PaymentType": paymentType,
    "ErrorCode": errorCode,
    "ProductType": productType,
    "finalStatus": finalStatus,
    "CardNo": cardNo,
    "AuthCode": authCode,
    "PaymentLink": paymentLink,
    "merchTxnRefno": merchTxnRefno,
  };
}
