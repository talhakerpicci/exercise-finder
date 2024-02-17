import 'package:exercise_finder/utils/haptic_feedback/haptic_feedback.dart';
import 'package:flutter/material.dart';

class AddCategoryDialog extends StatelessWidget {
  const AddCategoryDialog({
    super.key,
    required this.onAdd,
  });

  final Function(String) onAdd;

  @override
  Widget build(BuildContext context) {
    final TextEditingController textFieldController = TextEditingController();

    return AlertDialog(
      title: const Text('Add To New Category'),
      content: TextField(
        controller: textFieldController,
        decoration: const InputDecoration(hintText: "Category Name"),
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
          child: const Text('Add To Category'),
          onPressed: () {
            HapticFeedbackManager.lightImpact();
            String categoryName = textFieldController.text.trim();
            if (categoryName.isNotEmpty) {
              onAdd(categoryName);
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
}
