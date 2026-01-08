import 'package:dio/dio.dart';

class ApiHandler {
  Future<T> processRequest<T>(Future<Response<dynamic>> Function() request, T Function(dynamic) build) async {
    try {
      final response = await request();
      if (response.statusCode == 200) {
        return build(response.data);
      }
    } catch (error) {
      // if statusCode header of response is not 2xx. Dio throw exception
      if (error is DioException && error.response != null) {
        if (error.response!.data.toString().contains("<!DOCTYPE html>")) {
          throw Exception({error.response?.statusCode: "Something went wrong"});
        } else if (error.response!.data['errors'] != null) {
          throw Exception({error.response?.statusCode: error.response!.data['errors'][0].toString()});
        } else {
          throw Exception({error.response?.statusCode: error.response!.data['success'].toString()});
        }
      } else {
        rethrow;
      }
    }
    throw Exception("Something went wrong");
  }
}
