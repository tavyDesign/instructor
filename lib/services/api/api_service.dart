import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:instructor_auto/services/api/dio_client.dart';

class ApiService {
  final Dio _dio = DioClient().dio;

  Future<Response> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
        options: options ??
            Options(
              followRedirects: true,
              validateStatus: (status) => status != null && status < 500,
            ),
      );
      return response;
    } catch (e) {
      debugPrint('GET Error: ${e.toString()}');
      if (e is DioException) {
        debugPrint('GET DioError Type: ${e.type}');
        debugPrint('GET DioError Message: ${e.message}');
        debugPrint('GET DioError Response: ${e.response}');
      }
      rethrow;
    }
  }

  Future<Response> post(String endpoint, {dynamic data}) async {
    try {
      return await _dio.post(endpoint, data: data);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> put(String endpoint, {dynamic data}) async {
    try {
      return await _dio.put(endpoint, data: data);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> delete(String endpoint) async {
    try {
      return await _dio.delete(endpoint);
    } catch (e) {
      rethrow;
    }
  }
}
