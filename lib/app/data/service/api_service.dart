import 'package:dio/dio.dart' as dio;
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class ApiService extends GetxService {
  late dio.Dio _dio;

  // Base URL - change this to your API URL
  static const String baseUrl = 'https://api.example.com';

  @override
  void onInit() {
    super.onInit();
    _initializeDio();
  }

  void _initializeDio() {
    _dio = dio.Dio(
      dio.BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
      ),
    );

    // Add interceptors
    _dio.interceptors.add(_createLoggingInterceptor());
    _dio.interceptors.add(_createAuthInterceptor());
    _dio.interceptors.add(_createErrorInterceptor());
  }

  // Logging interceptor
  dio.InterceptorsWrapper _createLoggingInterceptor() => dio.InterceptorsWrapper(
    onRequest: (options, handler) {
      debugPrint('🚀 Request: ${options.method} ${options.uri}');
      debugPrint('📦 Data: ${options.data}');
      handler.next(options);
    },
    onResponse: (response, handler) {
      debugPrint('✅ Response: ${response.statusCode} ${response.requestOptions.uri}');
      handler.next(response);
    },
    onError: (error, handler) {
      debugPrint('❌ Error: ${error.message}');
      handler.next(error);
    },
  );

  // Auth interceptor
  dio.InterceptorsWrapper _createAuthInterceptor() => dio.InterceptorsWrapper(
    onRequest: (options, handler) async {
      // Add auth token if available
      // final token = await StorageService.getToken();
      // if (token != null) {
      //   options.headers['Authorization'] = 'Bearer $token';
      // }
      handler.next(options);
    },
  );

  // Error interceptor
  dio.InterceptorsWrapper _createErrorInterceptor() => dio.InterceptorsWrapper(
      onError: (error, handler) {
        _handleError(error);
        handler.next(error);
      },
    );

  void _handleError(dio.DioException error) {
    var message = 'An error occurred';

    switch (error.type) {
      case dio.DioExceptionType.connectionTimeout:
      case dio.DioExceptionType.sendTimeout:
      case dio.DioExceptionType.receiveTimeout:
        message = 'Connection timeout. Please check your internet connection.';
        break;
      case dio.DioExceptionType.badResponse:
        message = _handleHttpError(error.response?.statusCode);
        break;
      case dio.DioExceptionType.cancel:
        message = 'Request was cancelled';
        break;
      case dio.DioExceptionType.unknown:
        message = 'Network error. Please check your internet connection.';
        break;
      default:
        message = 'An unexpected error occurred';
    }

    // Show error message
    Get.snackbar('Error', message, snackPosition: SnackPosition.BOTTOM);
  }

  String _handleHttpError(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'Bad request';
      case 401:
        return 'Unauthorized. Please login again.';
      case 403:
        return 'Forbidden';
      case 404:
        return 'Not found';
      case 500:
        return 'Internal server error';
      default:
        return 'Server error occurred';
    }
  }

  // HTTP Methods
  Future<dio.Response> get(String path, {Map<String, dynamic>? queryParameters}) async => _dio.get(path, queryParameters: queryParameters);

  Future<dio.Response> post(String path, {dynamic data, Map<String, dynamic>? queryParameters}) async => _dio.post(path, data: data, queryParameters: queryParameters);

  Future<dio.Response> put(String path, {dynamic data, Map<String, dynamic>? queryParameters}) async => _dio.put(path, data: data, queryParameters: queryParameters);

  Future<dio.Response> delete(String path, {Map<String, dynamic>? queryParameters}) async => _dio.delete(path, queryParameters: queryParameters);

  Future<dio.Response> patch(String path, {dynamic data, Map<String, dynamic>? queryParameters}) async => _dio.patch(path, data: data, queryParameters: queryParameters);
}
