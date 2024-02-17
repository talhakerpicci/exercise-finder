import 'package:exercise_finder/model/exercise_model.dart';
import 'package:exercise_finder/model/result_model.dart';
import 'package:exercise_finder/utils/api_client/api_client.dart';
import 'package:exercise_finder/utils/exceptions/exceptions.dart';
import 'package:exercise_finder/utils/extensions/extensions.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ClientRepository {
  ClientRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<Result<List<ExerciseModel>>> searchExercise({
    String? name,
    Muscle? muscle,
    ExerciseType? type,
  }) async {
    return exceptionHandler(() async {
      final response = await _apiClient.get(
        '/v1/exercises',
        queryParameters: {
          if (name != null) 'name': name,
          if (muscle != null) 'muscle': muscle.name.camelCaseToSnakeCase(),
          if (type != null) 'type': type.name.camelCaseToSnakeCase(),
        },
      );

      final exercises = (response.data as List<dynamic>)
          .map(
            (dynamic e) => ExerciseModel.fromJson(e as Map<String, dynamic>),
          )
          .toList();

      return Result.success(exercises);
    });
  }
}
