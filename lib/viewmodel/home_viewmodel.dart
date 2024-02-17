import 'dart:async';
import 'package:exercise_finder/model/alert_model.dart';
import 'package:exercise_finder/model/exercise_model.dart';
import 'package:exercise_finder/services/api_service.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class HomeViewModel extends ChangeNotifier {
  final ClientRepository _clientRepository;

  HomeViewModel(this._clientRepository);

  List<ExerciseModel> _searchResults = [];
  List<String> _suggestions = [];
  Muscle? _selectedMuscleFilter;
  ExerciseType? _selectedExerciseFilter;
  String? _errorMessage;
  String _query = '';

  bool _isLoading = false;

  Timer? _debounce;

  List<ExerciseModel> get searchResults => _searchResults;
  List<String> get suggestions => _suggestions;
  Muscle? get selectedMuscleFilter => _selectedMuscleFilter;
  ExerciseType? get selectedExerciseFilter => _selectedExerciseFilter;
  String? get errorMessage => _errorMessage;
  String get query => _query;
  bool get isLoading => _isLoading;

  void setSearchResults(List<ExerciseModel> results) {
    _searchResults = results;
    notifyListeners();
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void setQuery(String newQuery) {
    if (_query != newQuery) {
      _query = newQuery;
      notifyListeners();
      if (_debounce?.isActive ?? false) _debounce!.cancel();
      _debounce = Timer(const Duration(milliseconds: 300), () {
        searchExercises(
          name: _query,
          muscle: selectedMuscleFilter,
          type: selectedExerciseFilter,
        );
      });
    }
  }

  void clearSuggestions() {
    _suggestions.clear();
    notifyListeners();
  }

  void setSuggestions(String text) {
    if (searchResults.isNotEmpty && text.isNotEmpty) {
      List<String> matches = searchResults.map((e) => e.name).toList().where((item) {
        return item.toLowerCase().contains(text.toLowerCase());
      }).toList();

      _suggestions = matches;
    } else {
      _suggestions.clear();
      notifyListeners();
    }
  }

  void setFilters({required Muscle? muscle, required ExerciseType? exerciseType}) {
    _selectedMuscleFilter = muscle;
    _selectedExerciseFilter = exerciseType;
    notifyListeners();

    searchExercises(
      name: _query,
      muscle: _selectedMuscleFilter,
      type: _selectedExerciseFilter,
      showSuggestions: false,
    );
  }

  void setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void searchExercises({
    String? name,
    Muscle? muscle,
    ExerciseType? type,
    bool showSuggestions = true,
  }) async {
    setLoading(true);
    final result = await _clientRepository.searchExercise(
      name: name,
      muscle: muscle,
      type: type,
    );

    result.when(
      success: (List<ExerciseModel> data) {
        setSearchResults(data);
        if (showSuggestions) {
          setSuggestions(query);
        }

        setLoading(false);
      },
      failure: (AlertModel error) {
        setError(error.message);
        setLoading(false);
      },
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
