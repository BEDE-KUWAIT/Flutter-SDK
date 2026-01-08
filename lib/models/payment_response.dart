class PaymentResponse {
  final String paymentLink;
  final String hashMac;
  final String transactionId;

  PaymentResponse({required this.paymentLink, required this.hashMac, required this.transactionId});
}
