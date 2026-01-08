import 'dart:convert';
import 'dart:math';

import 'package:bede_flutter_sdk/enum/app_type.dart';
import 'package:bede_flutter_sdk/enum/db_request_type.dart';
import 'package:bede_flutter_sdk/enum/environment.dart';
import 'package:bede_flutter_sdk/enum/payment_methods.dart';
import 'package:bede_flutter_sdk/models/check_status_response.dart';
import 'package:bede_flutter_sdk/models/payment_method_model.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../api/bede_api.dart';
import '../models/check_status_request.dart';
import '../models/initiate_payment_request.dart';
import '../models/initiate_payment_response.dart';
import '../models/payment_response.dart';

class BedeFlutter {
  late AppInfo _appInfo;
  late BedeApi _bedeApi;
  late MerchantDetails _merchantDetails;
  late String _secretKey;

  /// Initialize
  Future<void> initialize({required Environment env, required MerchantDetails merchantDetails, required String secretKey}) async {
    late String version;

    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      version = packageInfo.version;
    } catch (e) {
      if (kDebugMode) print("Failed to get package info: $e");
      version = '0.0';
    }

    _bedeApi = BedeApi(env: env);
    _secretKey = secretKey;
    _appInfo = AppInfo(appTyp: AppType.mobile.value, appVer: version, apiVer: '1.0', os: defaultTargetPlatform.name);
    _merchantDetails = merchantDetails;
  }

  /// Request Payment Link
  Future<PaymentResponse> requestPaymentLink({
    required PaymentMethods paymentMethod,
    required num amount,
    MoreDetails? moreDetails,
    PayerDetails? payerDetails,
    void Function(String message)? onError,
  }) async {
    /// transaction ID
    String txnID = _getRandom();

    /// transaction Header
    String txnHDR = _getRandom();

    /// hashMac
    String hashMac = await _generateHashMac(amount: amount, transactionID: txnID, transactionHDR: txnHDR);

    /// request
    InitiatePaymentRequest request = InitiatePaymentRequest(
      dbRqst: DbRequestType.paymentEcommerce.value,
      doAppinfo: _appInfo,
      doMerchDtl: _merchantDetails,
      doMoreDtl: moreDetails ?? MoreDetails(),
      doPyrDtl: payerDetails ?? PayerDetails(),
      doTxnDtl: [TransactionDetails(subMerchUid: _merchantDetails.merchantID, txnAmt: amount)],
      doTxnHdr: TransactionHeader(merchTxnUid: txnID, payFor: "ECom", payMethod: paymentMethod.value, txnHdr: txnHDR, hashMac: hashMac),
    );

    /// Api
    InitiatePaymentResponse res = await _bedeApi.requestPayment(request: request);

    /// On Error
    if (onError != null && res.errorMessage != "Success") {
      onError(res.errorMessage);
    }

    return PaymentResponse(paymentLink: res.payUrl, hashMac: hashMac, transactionId: txnID);
  }

  /// Get Payment Methods
  Future<List<PaymentMethods>> getPaymentMethods() async {
    List<PaymentMethodModel> methods = await _bedeApi.getMethods(merchantId: _merchantDetails.merchantID);
    List<String> methodIds = methods.map((e) => e.id.toLowerCase()).toList();
    List<PaymentMethods> paymentMethods = [];
    for (var element in PaymentMethods.values) {
      if (methodIds.contains(element.value.toLowerCase())) {
        paymentMethods.add(element);
      }
    }
    if (defaultTargetPlatform == TargetPlatform.android) {
      paymentMethods = paymentMethods.where((method) => method != PaymentMethods.applePay).toList();
    }
    return paymentMethods;
  }

  /// Check Payment Status
  Future<PaymentStatus> checkPaymentStatus({required String hashMac, required String transactionId}) async {
    CheckStatusResponse response = await _bedeApi.checkStatus(
      request: CheckStatusRequest(mid: _merchantDetails.merchantID, merchantTxnRefNo: [transactionId], hashMac: hashMac),
    );
    return response.paymentStatus.first;
  }

  String _getRandom() {
    final random = Random();
    return (10000000 + random.nextInt(90000000)).toString();
  }

  Future<String> _generateHashMac({required num amount, required String transactionID, required String transactionHDR}) async {
    /// create hash String
    String hashMacValue;
    if (amount is int || ((amount - amount.toInt()) == 0)) {
      hashMacValue =
          "${_merchantDetails.merchantID}|$transactionID|${_merchantDetails.successUrl}|${_merchantDetails.failureUrl}|${amount.toInt()}|GEN|$_secretKey|$transactionHDR";
    } else {
      hashMacValue =
          "${_merchantDetails.merchantID}|$transactionID|${_merchantDetails.successUrl}|${_merchantDetails.failureUrl}|$amount|GEN|$_secretKey|$transactionHDR";
    }

    /// encode
    final bytes = utf8.encode(hashMacValue); // Encode input to bytes
    final digest = sha512.convert(bytes); // Perform SHA-512 hashing
    final hashMac = digest.toString(); // Convert digest to hex string
    return hashMac;
  }
}
