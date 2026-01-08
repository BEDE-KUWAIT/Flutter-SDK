enum DbRequestType {
  // refundRequest("ReFnd_Req"),
  // refundStatus("ReFnd_Sts"),
  // requestNew("Req_New"),
  paymentEcommerce("PY_ECom");

  final String value;

  const DbRequestType(this.value);
}
