import 'package:exercise_finder/model/exercise_model.dart';
import 'package:exercise_finder/utils/di/di.dart';
import 'package:exercise_finder/utils/extensions/extensions.dart';
import 'package:exercise_finder/view/pages/program/add_category_dailog.dart';
import 'package:exercise_finder/view/pages/program/select_category_dialog.dart';
import 'package:exercise_finder/viewmodel/my_programs_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ExerciseWidget extends StatelessWidget {
  const ExerciseWidget({
    super.key,
    required this.exerciseModel,
    required this.showAddIcon,
    required this.shouldBeDismissible,
    this.onDismiss,
  }) : assert(!shouldBeDismissible || onDismiss != null, 'onDismiss must be provided if shouldBeDismissible is true');

  final ExerciseModel exerciseModel;
  final bool showAddIcon;
  final bool shouldBeDismissible;
  final Function(BuildContext)? onDismiss;

  void showCategorySelectionDialog(
    BuildContext context, {
    required List<String> categories,
    required Function(String) onSelect,
    required ExerciseModel exerciseModel,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SelectCategoryDialog(
          categories: categories,
          onSelect: onSelect,
          exerciseModel: exerciseModel,
        );
      },
    );
  }

  void showAddCategoryDialog(BuildContext context, {required Function(String) onAdd}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddCategoryDialog(
          onAdd: onAdd,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
      child: Slidable(
        key: ValueKey(exerciseModel.name),
        enabled: shouldBeDismissible,
        endActionPane: ActionPane(
          extentRatio: 0.25,
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              label: 'Delete',
              icon: Icons.delete,
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              onPressed: onDismiss,
            ),
          ],
        ),
        child: Card(
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exerciseModel.name,
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        exerciseModel.type.name.capitalize(),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      exerciseModel.muscle.name.capitalize(),
                    ),
                  ],
                ),
              ),
              showAddIcon
                  ? Positioned(
                      top: 2,
                      right: 0,
                      child: IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () async {
                          await getIt<MyProgramsViewModel>().loadCategories();

                          final categories = getIt<MyProgramsViewModel>().categories;

                          if (context.mounted) {
                            if (categories.isEmpty) {
                              showAddCategoryDialog(
                                context,
                                onAdd: (category) {
                                  getIt<MyProgramsViewModel>().addExerciseToCategory(
                                    category,
                                    exerciseModel,
                                  );
                                },
                              );
                            } else {
                              showCategorySelectionDialog(
                                context,
                                categories: categories,
                                exerciseModel: exerciseModel,
                                onSelect: (category) {
                                  getIt<MyProgramsViewModel>().addExerciseToCategory(
                                    category,
                                    exerciseModel,
                                  );
                                },
                              );
                            }
                          }
                        },
                        padding: const EdgeInsets.all(0),
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
