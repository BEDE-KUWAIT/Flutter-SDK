class InitiatePaymentResponse {
  final String payUrl;
  final String paymentGateway;
  final String errorMessage;

  InitiatePaymentResponse({required this.payUrl, required this.paymentGateway, required this.errorMessage});

  factory InitiatePaymentResponse.fromJson(Map<String, dynamic> json) =>
      InitiatePaymentResponse(payUrl: json["PayUrl"], paymentGateway: json["PaymentGateway"], errorMessage: json["ErrorMessage"]);

  Map<String, dynamic> toJson() => {"PayUrl": payUrl, "PaymentGateway": paymentGateway, "ErrorMessage": errorMessage};
}
