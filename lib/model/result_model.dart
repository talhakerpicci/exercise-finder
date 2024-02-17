import 'package:exercise_finder/model/alert_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'result_model.freezed.dart';

@freezed
class Result<T> with _$Result<T> {
  const factory Result.success(T data) = Success<T>;
  const factory Result.failure(AlertModel error) = Failure<T>;
}
