import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:backupmanager/Routines/routine_create_view.dart';
import 'package:backupmanager/Tasks/task_create_view.dart';
import 'package:backupmanager/Routines/routine_grid_view.dart';
import 'package:backupmanager/Routines/routine_view.dart';
import 'package:backupmanager/data_provider.dart';

Map<int, Color> colorMap = {
  50: const Color(0xFF354f52).withOpacity(.1),
  100: const Color(0xFF354f52).withOpacity(.2),
  200: const Color(0xFF354f52).withOpacity(.3),
  300: const Color(0xFF354f52).withOpacity(.4),
  400: const Color(0xFF354f52).withOpacity(.5),
  500: const Color(0xFF354f52).withOpacity(.6),
  600: const Color(0xFF354f52).withOpacity(.7),
  700: const Color(0xFF354f52).withOpacity(.8),
  800: const Color(0xFF354f52).withOpacity(.9),
  900: const Color(0xFF354f52).withOpacity(1),
};

void main() async {
  DataProvider dataProvider = DataProvider();
  await dataProvider.init();
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(
        create: (_) => dataProvider,
      ),
    ], child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BackupManager',
      theme: ThemeData(
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: Colors.white,
              displayColor: Colors.white,
            ),
        primarySwatch: MaterialColor(0xFF354f52, colorMap),
        scaffoldBackgroundColor: const Color(0xFF2f3e46),
      ),
      home: const MyHomePage(),
      routes: {
        RoutineView.route: (context) => const RoutineView(),
        RoutineCreateView.route: (context) => const RoutineCreateView(),
        TaskCreateView.route: (context) => const TaskCreateView(),
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const RoutineGridView();
  }
}
