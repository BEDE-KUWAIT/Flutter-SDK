enum PaymentMethods {
  kNet("KNET"),
  amex("AMEX"),
  creditCard("CCARD"),
  bede("BOOKEEY"),
  applePay("APPLEPAY");

  final String value;

  const PaymentMethods(this.value);
}
