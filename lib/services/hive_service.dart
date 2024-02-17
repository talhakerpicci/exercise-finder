import 'dart:convert';
import 'package:exercise_finder/model/alert_model.dart';
import 'package:exercise_finder/model/exercise_model.dart';
import 'package:exercise_finder/model/result_model.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class HiveService {
  Box<String>? _exerciseBox;

  Future<void> init() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);
    _exerciseBox = await openExerciseBox();
  }

  Box<String> get exerciseBox {
    if (_exerciseBox == null) {
      throw Exception('Hive box not initialized. Ensure init() is called first.');
    }
    return _exerciseBox!;
  }

  Future<Box<String>> openExerciseBox() async {
    return await Hive.openBox<String>('exercises');
  }

  Future<List<String>> getCategories() async {
    return Hive.box<String>('exercises').keys.cast<String>().toList();
  }

  Future<Result> addExercise(String exerciseCategory, ExerciseModel exercise) async {
    final existingExercisesJson = exerciseBox.get(exerciseCategory) ?? '[]';
    final List<ExerciseModel> exerciseList = (json.decode(existingExercisesJson) as List)
        .map((e) => ExerciseModel.fromJson(e as Map<String, dynamic>))
        .toList();

    if (exerciseList.contains(exercise)) {
      return Result.failure(
        AlertModel(
          message: 'Exercise ${exercise.name} already exists in $exerciseCategory',
          type: AlertType.error,
        ),
      );
    }

    exerciseList.add(exercise);
    await exerciseBox.put(exerciseCategory, json.encode(exerciseList.map((e) => e.toJson()).toList()));

    return const Result.success(null);
  }

  Future<void> deleteExercise(String exerciseCategory, String exerciseName) async {
    final existingExercisesJson = exerciseBox.get(exerciseCategory) ?? '[]';
    final List<ExerciseModel> exerciseList = (json.decode(existingExercisesJson) as List)
        .map((e) => ExerciseModel.fromJson(e as Map<String, dynamic>))
        .toList();

    exerciseList.removeWhere((exercise) => exercise.name == exerciseName);
    await exerciseBox.put(exerciseCategory, json.encode(exerciseList.map((e) => e.toJson()).toList()));
  }

  Future<void> deleteCategory(String exerciseCategory) async {
    await exerciseBox.delete(exerciseCategory);
  }

  Future<void> saveExerciseOrder(String category, List<ExerciseModel> exercises) async {
    final exercisesJson = json.encode(exercises.map((e) => e.toJson()).toList());
    await exerciseBox.put(category, exercisesJson);
  }

  Future<List<ExerciseModel>> getExercises(String exerciseCategory) async {
    final exercisesJson = exerciseBox.get(exerciseCategory) ?? '[]';
    return (json.decode(exercisesJson) as List).map((e) => ExerciseModel.fromJson(e as Map<String, dynamic>)).toList();
  }
}
