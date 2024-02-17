import 'package:exercise_finder/utils/exceptions/exceptions.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'alert_model.freezed.dart';

enum AlertType { info, error, exception, quiet }

@freezed
class AlertModel with _$AlertModel {
  const factory AlertModel({
    required String message,
    required AlertType type,
    int? code,
  }) = _AlertModel;

  factory AlertModel.alert({
    required String message,
    required AlertType type,
    int? code,
  }) {
    return AlertModel(
      message: message,
      type: type,
      code: code,
    );
  }

  factory AlertModel.exception({
    required Exception exception,
    int? code,
    StackTrace? stackTrace,
  }) {
    String message;

    if (exception is BadNetworkException) {
      message = 'Internet connectivity is not available.';
    } else if (exception is InternalServerException) {
      message = 'Server failure encountered.';
    } else if (exception is InvalidJsonFormatException) {
      message = 'There was an error with our communication with the servers.';
    } else if (exception is ApiException) {
      message = exception.errorMessage;
    } else {
      message = exception.toString();
    }

    return AlertModel(
      message: message,
      type: AlertType.exception,
      code: code,
    );
  }
}
