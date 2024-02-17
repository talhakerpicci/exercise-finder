import 'package:freezed_annotation/freezed_annotation.dart';

part 'exercise_model.freezed.dart';
part 'exercise_model.g.dart';

enum ExerciseType {
  cardio,
  @JsonValue('olympic_weightlifting')
  olympicWeightlifting,
  plyometrics,
  powerlifting,
  strength,
  stretching,
  strongman,
}

enum Muscle {
  abdominals,
  abductors,
  adductors,
  biceps,
  calves,
  chest,
  forearms,
  glutes,
  hamstrings,
  lats,
  @JsonValue('lower_back')
  lowerBack,
  @JsonValue('middle_back')
  middleBack,
  neck,
  quadriceps,
  traps,
  triceps,
  shoulders,
}

enum ExerciseDifficulty {
  beginner,
  intermediate,
  expert,
}

@freezed
class ExerciseModel with _$ExerciseModel {
  const factory ExerciseModel({
    required String name,
    required String equipment,
    required Muscle muscle,
    required ExerciseType type,
    required ExerciseDifficulty difficulty,
  }) = _ExerciseModel;

  factory ExerciseModel.fromJson(Map<String, dynamic> json) => _$ExerciseModelFromJson(json);
}
