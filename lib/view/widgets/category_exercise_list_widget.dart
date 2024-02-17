import 'package:exercise_finder/model/exercise_model.dart';
import 'package:exercise_finder/utils/di/di.dart';
import 'package:exercise_finder/utils/haptic_feedback/haptic_feedback.dart';
import 'package:exercise_finder/view/widgets/exercise_widget.dart';
import 'package:exercise_finder/viewmodel/my_programs_viewmodel.dart';
import 'package:flutter/material.dart';

class CategoryExerciseListWidget extends StatelessWidget {
  const CategoryExerciseListWidget({
    super.key,
    required this.exercises,
    required this.category,
  });

  final String category;
  final List<ExerciseModel> exercises;

  @override
  Widget build(BuildContext context) {
    return ReorderableListView.builder(
      itemCount: exercises.length,
      itemBuilder: (context, index) {
        return ExerciseWidget(
          key: ValueKey(exercises[index].name),
          exerciseModel: exercises[index],
          showAddIcon: false,
          shouldBeDismissible: true,
          onDismiss: (context) {
            HapticFeedbackManager.heavyImpact();
            getIt<MyProgramsViewModel>().deleteExercise(category, exercises[index].name);
          },
        );
      },
      onReorder: (oldIndex, newIndex) {
        HapticFeedbackManager.heavyImpact();
        getIt<MyProgramsViewModel>().reorderExercises(oldIndex, newIndex);
      },
    );
  }
}
