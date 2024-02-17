import 'package:exercise_finder/model/exercise_model.dart';
import 'package:exercise_finder/services/hive_service.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class MyProgramsViewModel extends ChangeNotifier {
  final HiveService _hiveService;

  MyProgramsViewModel(this._hiveService);

  String? _selectedCategory;
  List<ExerciseModel> _exercises = [];
  List<String> _categories = [];
  String? _dynamicMessage;

  String? get selectedCategory => _selectedCategory;
  List<ExerciseModel> get exercises => _exercises;
  List<String> get categories => _categories;
  String? get dynamicMessage => _dynamicMessage;

  void clearError() {
    _dynamicMessage = null;
    notifyListeners();
  }

  void setSelectedCategory(String category) {
    _selectedCategory = category;
    loadExercises();
  }

  Future<void> loadCategories() async {
    _categories = await _hiveService.getCategories();

    if (_categories.isNotEmpty) {
      setSelectedCategory(selectedCategory ?? _categories.first);
    }

    notifyListeners();
  }

  Future<void> loadExercises() async {
    _exercises = await _hiveService.getExercises(selectedCategory!);
    notifyListeners();
  }

  Future<void> deleteExercise(String category, String exerciseName) async {
    await _hiveService.deleteExercise(category, exerciseName);
    await loadExercises();
    _dynamicMessage = 'Successfully delete $exerciseName exercise from $category category';
    notifyListeners();
  }

  Future<void> reorderExercises(int oldIndex, int newIndex) async {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    final ExerciseModel exercise = _exercises.removeAt(oldIndex);
    _exercises.insert(newIndex, exercise);
    notifyListeners();

    await _hiveService.saveExerciseOrder(_selectedCategory!, _exercises);
  }

  Future<void> deleteCategory(String category) async {
    await _hiveService.deleteCategory(category);
    _selectedCategory = null;
    loadCategories();
  }

  Future<void> addExerciseToCategory(String category, ExerciseModel exercise) async {
    try {
      final result = await _hiveService.addExercise(category, exercise);
      result.when(
        success: (data) {
          _selectedCategory = category;
          loadCategories();
          loadExercises();
          _dynamicMessage = 'Successfully added exercise to $category category';
        },
        failure: (error) {
          _dynamicMessage = error.message;
        },
      );
    } catch (e) {
      _dynamicMessage = 'Something bad happened :(';
    }

    notifyListeners();
  }
}
