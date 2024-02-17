import 'package:exercise_finder/model/exercise_model.dart';
import 'package:exercise_finder/utils/di/di.dart';
import 'package:exercise_finder/utils/extensions/extensions.dart';
import 'package:exercise_finder/viewmodel/home_viewmodel.dart';
import 'package:flutter/material.dart';

class FilterDialog extends StatelessWidget {
  const FilterDialog({super.key});

  String _enumToString(dynamic enumValue) {
    return enumValue.toString().split('.').last.replaceAll('_', ' ').capitalize();
  }

  @override
  Widget build(BuildContext context) {
    ExerciseType? selectedExerciseType = getIt<HomeViewModel>().selectedExerciseFilter;
    Muscle? selectedMuscle = getIt<HomeViewModel>().selectedMuscleFilter;

    return StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        title: const Text('Select Filters'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(left: 8, bottom: 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Exercise Type',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              Wrap(
                spacing: 8.0,
                children: ExerciseType.values.map((type) {
                  return ChoiceChip(
                    label: Text(_enumToString(type)),
                    selected: selectedExerciseType == type,
                    onSelected: (bool selected) {
                      setState(() {
                        selectedExerciseType = selected ? type : null;
                      });
                    },
                  );
                }).toList(),
              ),
              const Divider(height: 20, thickness: 1),
              const Padding(
                padding: EdgeInsets.only(left: 8, bottom: 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Muscle Group',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              Wrap(
                spacing: 8.0,
                children: Muscle.values.map((muscle) {
                  return ChoiceChip(
                    label: Text(_enumToString(muscle)),
                    selected: selectedMuscle == muscle,
                    onSelected: (bool selected) {
                      setState(() {
                        selectedMuscle = selected ? muscle : null;
                      });
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Clear Filters'),
            onPressed: () {
              getIt<HomeViewModel>().setFilters(
                muscle: null,
                exerciseType: null,
              );
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Apply'),
            onPressed: () {
              getIt<HomeViewModel>().setFilters(
                muscle: selectedMuscle,
                exerciseType: selectedExerciseType,
              );
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
