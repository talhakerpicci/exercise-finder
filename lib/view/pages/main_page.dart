import 'package:exercise_finder/utils/di/di.dart';
import 'package:exercise_finder/utils/haptic_feedback/haptic_feedback.dart';
import 'package:exercise_finder/view/pages/home/home_page.dart';
import 'package:exercise_finder/view/pages/program/my_programs_page.dart';
import 'package:exercise_finder/viewmodel/bottom_navigation_bar_provider.dart';
import 'package:exercise_finder/viewmodel/home_viewmodel.dart';
import 'package:exercise_finder/viewmodel/my_programs_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BottomNavigationBarProvider()),
        ChangeNotifierProvider(create: (_) => getIt<HomeViewModel>()..searchExercises()),
        ChangeNotifierProvider(create: (_) => getIt<MyProgramsViewModel>()..loadCategories()),
      ],
      builder: (context, child) {
        var provider = Provider.of<BottomNavigationBarProvider>(context);

        return Consumer<MyProgramsViewModel>(
          builder: (context, model, child) {
            if (model.dynamicMessage != null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(model.dynamicMessage!)),
                );
                model.clearError();
              });
            }

            return Scaffold(
              appBar: AppBar(
                title: Center(
                  child: Text(
                    provider.pageName,
                  ),
                ),
              ),
              body: IndexedStack(
                index: provider.currentIndex,
                children: const [
                  HomePage(),
                  MyProgramsPage(),
                ],
              ),
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: provider.currentIndex,
                onTap: (index) {
                  HapticFeedbackManager.mediumImpact();
                  provider.currentIndex = index;
                },
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.fitness_center),
                    label: 'My Programs',
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
