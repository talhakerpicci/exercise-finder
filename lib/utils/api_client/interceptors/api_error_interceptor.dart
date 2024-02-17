import 'package:dio/dio.dart';
import 'package:exercise_finder/utils/exceptions/exceptions.dart';

class ApiErrorInterceptor extends Interceptor {
  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response != null &&
        err.response!.statusCode != null &&
        (err.response!.statusCode! == 400 || err.response!.statusCode == 401 || err.response!.statusCode == 404)) {
      try {
        handler.reject(
          ApiException(
            errorMessage: 'Something bad happened :(',
            requestOptions: err.requestOptions,
            response: err.response,
            error: err.error,
            type: err.type,
          ),
        );
      } catch (e) {
        return handler.reject(
          InternalServerException(
            requestOptions: err.requestOptions,
            response: err.response,
          ),
        );
      }
    }

    return handler.next(err);
  }
}
