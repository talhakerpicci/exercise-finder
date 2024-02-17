import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:exercise_finder/model/alert_model.dart';
import 'package:exercise_finder/model/result_model.dart';

typedef ApiFunction<T> = Future<Result<T>> Function();

Future<Result<T>> exceptionHandler<T>(ApiFunction<T> repositoryFunction) async {
  try {
    return await repositoryFunction();
  } on ApiException catch (e) {
    final alert = AlertModel.exception(exception: e, code: e.response?.statusCode);

    return Result.failure(alert);
  } on TimeoutException {
    final alert = AlertModel.alert(message: 'The connection has timed out', type: AlertType.error);

    return Result.failure(alert);
  } on SomethingWentWrongExpection {
    final alert = AlertModel.alert(message: 'Something went wrong', type: AlertType.error);

    return Result.failure(alert);
  } on Exception catch (e) {
    final alert = AlertModel.exception(exception: e);

    return Result.failure(alert);
  } catch (e) {
    log(e.toString());
    if (e is Error) {
      log((e.stackTrace ?? 'No stacktrace').toString());
    }

    final alert = AlertModel.alert(message: 'Something went wrong', type: AlertType.error);

    return Result.failure(alert);
  }
}

class BadNetworkException extends DioException implements Exception {
  BadNetworkException({required super.requestOptions});
}

class InternalServerException extends DioException implements Exception {
  InternalServerException({
    required super.requestOptions,
    super.response,
  });
}

class ApiException extends DioException implements Exception {
  ApiException({
    required this.errorMessage,
    required super.requestOptions,
    super.response,
    super.error,
    super.type,
  });

  final String errorMessage;
}

class InvalidJsonFormatException extends DioException implements Exception {
  InvalidJsonFormatException({required super.requestOptions});
}

class TimeoutException extends DioException implements Exception {
  TimeoutException({required super.requestOptions});
}

class SomethingWentWrongExpection extends DioException implements Exception {
  SomethingWentWrongExpection({
    required super.requestOptions,
    super.response,
    super.error,
    super.type,
  });
}
