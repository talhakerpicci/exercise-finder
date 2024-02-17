import 'package:exercise_finder/utils/haptic_feedback/haptic_feedback.dart';
import 'package:exercise_finder/view/widgets/category_exercise_list_widget.dart';
import 'package:exercise_finder/view/widgets/category_selector_widget.dart';
import 'package:exercise_finder/viewmodel/my_programs_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyProgramsPage extends StatelessWidget {
  const MyProgramsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MyProgramsViewModel>(
      builder: (context, model, child) {
        return model.categories.isEmpty
            ? const Center(
                child: Text(
                  'No Category Found\n\nPlease create and add an exercise first',
                  textAlign: TextAlign.center,
                ),
              )
            : Column(
                children: [
                  CategorySelectorWidget(
                    categories: model.categories,
                    selectedCategory: model.selectedCategory!,
                    onCategorySelected: (category) => model.setSelectedCategory(category),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: model.exercises.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'No Exercise Found\n\nPlease add an exercise first',
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                ElevatedButton(
                                  child: const Text('Delete This Category'),
                                  onPressed: () {
                                    HapticFeedbackManager.mediumImpact();
                                    model.deleteCategory(model.selectedCategory!);
                                  },
                                ),
                              ],
                            ),
                          )
                        : CategoryExerciseListWidget(
                            exercises: model.exercises,
                            category: model.selectedCategory!,
                          ),
                  ),
                ],
              );
      },
    );
  }
}
