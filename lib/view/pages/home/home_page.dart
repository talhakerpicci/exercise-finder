import 'package:exercise_finder/view/pages/home/filter_dialog.dart';
import 'package:exercise_finder/view/widgets/custom_text_field_widget.dart';
import 'package:exercise_finder/view/widgets/search_suggestions_widget.dart';
import 'package:exercise_finder/view/widgets/sliver_exercise_list_widget.dart';
import 'package:exercise_finder/viewmodel/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final viewModel = Provider.of<HomeViewModel>(context, listen: false);
    viewModel.setQuery(_controller.text);
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const FilterDialog();
      },
    );
  }

  @override
  void dispose() {
    _controller.removeListener(_onSearchChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(
      builder: (context, model, child) {
        if (model.errorMessage != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(model.errorMessage!)),
            );
            model.clearError();
          });
        }
        return Stack(
          children: [
            CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  floating: true,
                  pinned: true,
                  collapsedHeight: 80.0,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: CustomTextFieldWidget(
                              controller: _controller,
                              labelText: 'Search',
                              hintText: 'Enter a search term',
                              onSubmitted: (value) {
                                model.clearSuggestions();
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(Icons.filter_list),
                            onPressed: _showFilterDialog,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverExerciseListWidget(
                  model: model,
                ),
              ],
            ),
            SearchSuggestionWidget(
              suggestions: model.suggestions,
              onTap: (index) {
                _controller.text = model.suggestions[index];
                model.clearSuggestions();
              },
            ),
          ],
        );
      },
    );
  }
}
