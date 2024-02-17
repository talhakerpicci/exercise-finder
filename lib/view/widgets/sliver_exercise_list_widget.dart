import 'package:exercise_finder/view/widgets/exercise_widget.dart';
import 'package:exercise_finder/viewmodel/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SliverExerciseListWidget extends StatelessWidget {
  const SliverExerciseListWidget({
    super.key,
    required this.model,
  });

  final HomeViewModel model;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        childCount: model.isLoading
            ? 10
            : model.searchResults.isEmpty
                ? 1
                : model.searchResults.length,
        (context, index) {
          if (model.isLoading) {
            return const Skeletonizer(
              enabled: true,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: Card(
                  child: ListTile(
                    title: Text('Loading...', style: TextStyle(color: Colors.transparent)),
                    subtitle: Text('Please wait', style: TextStyle(color: Colors.transparent)),
                    trailing: Icon(Icons.ac_unit, color: Colors.transparent),
                  ),
                ),
              ),
            );
          } else if (model.searchResults.isNotEmpty) {
            return ExerciseWidget(
              exerciseModel: model.searchResults[index],
              showAddIcon: true,
              shouldBeDismissible: false,
            );
          } else {
            return const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'No results found',
                textAlign: TextAlign.center,
              ),
            );
          }
        },
      ),
    );
  }
}
