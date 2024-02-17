import 'package:dio/dio.dart';
import 'package:exercise_finder/utils/exceptions/exceptions.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class BadNetworkErrorInterceptor extends Interceptor {
  final connectionChecker = InternetConnection();

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response == null && !await connectionChecker.hasInternetAccess) {
      return handler.reject(
        BadNetworkException(
          requestOptions: err.requestOptions,
        ),
      );
    }

    return handler.next(err);
  }

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    return handler.next(options);
  }
}
