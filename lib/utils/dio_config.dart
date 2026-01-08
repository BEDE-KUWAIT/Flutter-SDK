import 'dart:io';

import 'package:bede_flutter_sdk/bede_flutter_sdk.dart';
import 'package:dio/dio.dart';

class DioConfig {
  final Environment env;
  late Dio dio;

  static DioConfig? _singleton;

  factory DioConfig({required Environment env}) {
    return _singleton ??= DioConfig._internal(env: env);
  }
  DioConfig._internal({required this.env}) {
    ///
    BaseOptions baseOptions = BaseOptions(
      baseUrl: env.baseUrl,
      receiveTimeout: const Duration(seconds: 30),
      connectTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      persistentConnection: false,
      headers: <String, dynamic>{
        HttpHeaders.cacheControlHeader: "no-cache",
        HttpHeaders.contentTypeHeader: ContentType.json.value,
        HttpHeaders.acceptHeader: ContentType.json.value,
        HttpHeaders.connectionHeader: "keep-alive",
        HttpHeaders.acceptEncodingHeader: "gzip, deflate, br",
      },
    );

    ///
    dio = Dio(baseOptions);
  }
}
