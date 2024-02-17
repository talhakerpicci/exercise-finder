import 'package:flutter/material.dart';

class SearchSuggestionWidget extends StatelessWidget {
  const SearchSuggestionWidget({
    required this.onTap,
    required this.suggestions,
    super.key,
  });

  final Function(int) onTap;
  final List<String> suggestions;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 70,
      left: 0,
      right: 0,
      child: Visibility(
        visible: suggestions.isNotEmpty,
        child: Card(
          margin: const EdgeInsets.all(8),
          child: ListView.builder(
            padding: const EdgeInsets.all(8),
            shrinkWrap: true,
            itemCount: suggestions.length,
            itemBuilder: (context, index) => ListTile(
              title: Text(suggestions[index]),
              onTap: () => onTap(index),
            ),
          ),
        ),
      ),
    );
  }
}
