import 'package:exercise_finder/utils/di/di.dart';
import 'package:exercise_finder/view/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Configures dependency injection to init modules and singletons.
  await configureDependencyInjection();

  // Sets up allowed device orientations for the app.
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  );

  return runApp(
    const AppMain(),
  );
}

class AppMain extends StatelessWidget {
  const AppMain({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Exercise App',
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      home: MainPage(),
    );
  }
}
