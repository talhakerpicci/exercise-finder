import 'package:exercise_finder/model/exercise_model.dart';
import 'package:exercise_finder/utils/di/di.dart';
import 'package:exercise_finder/utils/haptic_feedback/haptic_feedback.dart';
import 'package:exercise_finder/view/pages/program/add_category_dailog.dart';
import 'package:exercise_finder/viewmodel/my_programs_viewmodel.dart';
import 'package:flutter/material.dart';

class SelectCategoryDialog extends StatelessWidget {
  const SelectCategoryDialog({
    super.key,
    required this.categories,
    required this.onSelect,
    required this.exerciseModel,
  });

  final List<String> categories;
  final Function(String) onSelect;
  final ExerciseModel exerciseModel;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select a Category'),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: categories.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(categories[index]),
              onTap: () {
                HapticFeedbackManager.mediumImpact();
                onSelect(categories[index]);
                Navigator.of(context).pop();
              },
            );
          },
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            HapticFeedbackManager.lightImpact();
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Add To New Category'),
          onPressed: () {
            HapticFeedbackManager.lightImpact();
            Navigator.of(context).pop();
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AddCategoryDialog(
                  onAdd: (category) {
                    HapticFeedbackManager.mediumImpact();
                    getIt<MyProgramsViewModel>().addExerciseToCategory(
                      category,
                      exerciseModel,
                    );
                  },
                );
              },
            );
          },
        ),
      ],
    );
  }
}
