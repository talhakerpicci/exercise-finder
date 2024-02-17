// Custom converter for ExerciseType
import 'package:exercise_finder/model/exercise_model.dart';
import 'package:exercise_finder/utils/extensions/extensions.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

class ExerciseTypeConverter implements JsonConverter<ExerciseType, String> {
  const ExerciseTypeConverter();

  @override
  ExerciseType fromJson(String json) {
    return ExerciseType.values.firstWhere(
      (e) => e.toString().split('.').last == json.replaceAll('_', ''),
      orElse: () => throw ArgumentError('Invalid exercise type: $json'),
    );
  }

  @override
  String toJson(ExerciseType exerciseType) => exerciseType.toString().split('.').last;
}

class MuscleConverter implements JsonConverter<Muscle, String> {
  const MuscleConverter();

  @override
  Muscle fromJson(String json) {
    return Muscle.values.firstWhere(
      (e) => e.toString().split('.').last.camelCaseToSnakeCase() == json,
      orElse: () => throw ArgumentError('Invalid muscle type: $json'),
    );
  }

  @override
  String toJson(Muscle muscle) => muscle.toString().split('.').last.camelCaseToSnakeCase();
}
