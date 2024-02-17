import 'package:dio/dio.dart';
import 'package:exercise_finder/utils/exceptions/exceptions.dart';

class TimeoutInterceptor extends Interceptor {
  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout) {
      return handler.reject(TimeoutException(requestOptions: err.requestOptions));
    }

    return handler.next(err);
  }
}
