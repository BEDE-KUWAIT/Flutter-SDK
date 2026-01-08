enum Environment {
  test("https://demo.bookeey.com/pgapi/api/payment/"),
  production("https://pg.bookeey.com/internalapi/api/payment/");

  final String baseUrl;

  const Environment(this.baseUrl);
}
