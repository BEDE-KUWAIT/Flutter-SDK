import 'package:bede_flutter_sdk/bede_flutter_sdk.dart';
import 'package:dio/dio.dart';

import '../models/check_status_request.dart';
import '../models/check_status_response.dart';
import '../models/initiate_payment_request.dart';
import '../models/initiate_payment_response.dart';
import '../models/payment_method_model.dart';
import '../utils/api_handler.dart';
import '../utils/dio_config.dart';

class BedeApi extends ApiHandler {
  final Environment env;
  BedeApi({required this.env});

  late final Dio dio = DioConfig(env: env).dio;

  Future<InitiatePaymentResponse> requestPayment({required InitiatePaymentRequest request}) async {
    final InitiatePaymentResponse data = await processRequest<InitiatePaymentResponse>(
      () async {
        return await dio.post("requestLink", data: request.toJson());
      },
      (rawData) {
        return InitiatePaymentResponse.fromJson(rawData);
      },
    );
    return data;
  }

  Future<List<PaymentMethodModel>> getMethods({required String merchantId}) async {
    final List<PaymentMethodModel> data = await processRequest<List<PaymentMethodModel>>(
      () async {
        return await dio.post("paymethods", data: {"MerchantId": merchantId});
      },
      (rawData) {
        return List<PaymentMethodModel>.from(rawData["PayOptions"].map((x) => PaymentMethodModel.fromJson(x)));
      },
    );
    return data;
  }

  Future<CheckStatusResponse> checkStatus({required CheckStatusRequest request}) async {
    final CheckStatusResponse response = await processRequest<CheckStatusResponse>(
      () async {
        return await dio.get("paymentstatus", data: request.toJson());
      },
      (rawData) {
        return CheckStatusResponse.fromJson(rawData);
      },
    );
    return response;
  }
}
