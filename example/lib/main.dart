import 'package:bede_flutter_sdk/bede_flutter_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'payment_webview_screen.dart';

part 'input_field.dart';
part 'payment_method_widget.dart';
part 'payment_methods.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme:
          ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
            fontFamily: "Lalezar",
          ).copyWith(
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final String surl = "https://www.google.com/search?q=success";
  final String furl = "https://www.google.com/search?q=failure";
  final _formKey = GlobalKey<FormState>();
  final BedeFlutter bedeFlutter = BedeFlutter();
  List<PaymentMethods> paymentMethods = [];
  PaymentMethods? selectedMethod;
  num amount = 0;
  bool isLoadingMethods = false;
  bool isPaying = false;
  bool isCheckingStatus = false;
  PaymentResponse? paymentResponse;

  @override
  void initState() {
    /// Initialize Merchant details
    bedeFlutter.initialize(
      env: Environment.test,
      merchantDetails: MerchantDetails(merchantID: "mer2500011", successUrl: surl, failureUrl: furl),
      secretKey: "7483493",
    );

    super.initState();
  }

  Future<void> _getMethods() async {
    setState(() {
      isLoadingMethods = true;
    });
    try {
      List<PaymentMethods> temp = await bedeFlutter.getPaymentMethods();
      setState(() {
        paymentMethods = temp;
        if (temp.isNotEmpty) {
          selectedMethod = temp.first;
        }
        isLoadingMethods = false;
      });
    } catch (e) {
      setState(() {
        isLoadingMethods = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to load payment methods: $e")));
    }
  }

  Future<void> _getUrl() async {
    setState(() {
      isPaying = true;
    });
    try {
      paymentResponse = await bedeFlutter.requestPaymentLink(paymentMethod: selectedMethod!, amount: amount, onError: (msg) => debugPrint(msg));
      if (paymentResponse != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentWebViewScreen(paymentUrl: paymentResponse!.paymentLink, surl: surl, furl: furl),
          ),
        ).then((value) {
          if (value != null && value) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Payment Success"), backgroundColor: Colors.green.shade400));
          } else if (value != null && !value) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Payment Failed'),
                  content: const Text('Your payment could not be processed. Please try again.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('OK'),
                    ),
                  ],
                );
              },
            );
          }
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to process payment: $e")));
    } finally {
      setState(() {
        isPaying = false;
      });
    }
  }

  Future<void> _checkPaymentStatus() async {
    if (paymentResponse == null) return;

    setState(() {
      isCheckingStatus = true;
    });
    try {
      PaymentStatus status = await bedeFlutter.checkPaymentStatus(hashMac: paymentResponse!.hashMac, transactionId: paymentResponse!.transactionId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            status.statusDescription,
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18),
          ),
          backgroundColor: getSnackBarColor(status.finalStatus),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to check payment status: $e")));
    } finally {
      setState(() {
        isCheckingStatus = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(title: Text("Payment methods", style: TextStyle(fontSize: 24))),
        body: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              spacing: 16,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _InputField(
                  onChanged: (String value) {
                    setState(() {
                      if (value.isEmpty) {
                        amount = 0;
                      } else {
                        amount = num.parse(value);
                      }
                    });
                  },
                ),
                if (paymentMethods.isNotEmpty) ...[
                  _PaymentMethods(
                    paymentMethods: paymentMethods,
                    selectedMethod: selectedMethod,
                    onTap: (method) {
                      setState(() {
                        selectedMethod = method;
                      });
                    },
                  ),
                  ElevatedButton(
                    onPressed: isPaying || isCheckingStatus || isLoadingMethods
                        ? null
                        : () {
                            if (selectedMethod == null) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please select a payment method")));
                            } else if (!_formKey.currentState!.validate()) {
                              return;
                            } else {
                              _getUrl();
                            }
                          },
                    child: isPaying
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                          )
                        : Text("Pay"),
                  ),
                  if (paymentResponse != null)
                    ElevatedButton(
                      onPressed: isPaying || isCheckingStatus || isLoadingMethods ? null : _checkPaymentStatus,
                      child: isCheckingStatus
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                            )
                          : Text("Check Status"),
                    ),
                ],
                ElevatedButton(
                  onPressed: isLoadingMethods || isPaying || isCheckingStatus ? null : _getMethods,
                  child: isLoadingMethods
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                        )
                      : Text("Get Payment Methods"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color getSnackBarColor(String finalStatus) {
    switch (finalStatus) {
      case "success":
        return Colors.green;
      case "failed":
        return Colors.red;
      case "cancelled":
        return Colors.orange;
      case "initiated":
        return Colors.yellow;
      default:
        return Colors.grey;
    }
  }
}
