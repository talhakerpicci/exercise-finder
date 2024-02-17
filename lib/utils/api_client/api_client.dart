import 'package:dio/dio.dart';
import 'package:exercise_finder/utils/api_client/interceptors/api_error_interceptor.dart';
import 'package:exercise_finder/utils/api_client/interceptors/bad_network_error_interceptor.dart';
import 'package:exercise_finder/utils/api_client/interceptors/internal_server_error_interceptor.dart';
import 'package:exercise_finder/utils/api_client/interceptors/something_went_wrong_interceptor.dart';
import 'package:exercise_finder/utils/api_client/interceptors/timeout_interceptor.dart';
import 'package:exercise_finder/utils/env/env.dart';
import 'package:injectable/injectable.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

@lazySingleton
class ApiClient {
  final Dio _dio = Dio();
  final rapidAPIHost = 'exercises-by-api-ninjas.p.rapidapi.com';
  final baseUrl = 'https://exercises-by-api-ninjas.p.rapidapi.com';

  ApiClient() {
    _dio.options.baseUrl = baseUrl;
    _dio.options.contentType = Headers.jsonContentType;
    _dio.options.responseType = ResponseType.json;
    _dio.options.headers['X-RapidAPI-Key'] = Env.rapidApiKey;
    _dio.options.headers['X-RapidAPI-Host'] = rapidAPIHost;
    _dio.options.connectTimeout = const Duration(seconds: 20);
    _dio.options.receiveTimeout = const Duration(seconds: 20);
    _dio.interceptors.add(BadNetworkErrorInterceptor());
    _dio.interceptors.add(InternalServerErrorInterceptor());
    _dio.interceptors.add(ApiErrorInterceptor());
    _dio.interceptors.add(TimeoutInterceptor());
    _dio.interceptors.add(SomethingWentWrongInterceptor());
    _dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
      ),
    );
  }

  Future<Response<dynamic>> post(String path, dynamic data, {Options? options}) =>
      _dio.post<dynamic>(path, data: data, options: options);

  Future<Response<dynamic>> put(String path, dynamic data) => _dio.put<dynamic>(path, data: data);

  Future<Response<dynamic>> delete(String path, {dynamic data}) => _dio.delete<dynamic>(path, data: data);

  Future<Response<dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) =>
      _dio.get<dynamic>(
        path,
        queryParameters: queryParameters,
      );
}
