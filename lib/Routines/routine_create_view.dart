import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:backupmanager/templates/default_view.dart';
import 'package:backupmanager/data_provider.dart';
import 'package:backupmanager/Database/Models/routine_model.dart';

class RoutineCreateView extends StatelessWidget {
  static const String route = "/routine/create";

  const RoutineCreateView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultContainerWrapper(
      title: "Add a new routine",
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: TextField(
          onSubmitted: (value) async {
            await context.read<DataProvider>().insertRoutine(
                  Routine(title: value),
                );
            Navigator.pop(context);
          },
          cursorColor: Colors.white,
          style: Theme.of(context).textTheme.bodyLarge,
          decoration: InputDecoration(
            labelStyle: Theme.of(context).textTheme.bodyLarge,
            border: const OutlineInputBorder(),
            labelText: "Name",
          ),
        ),
      ),
    );
  }
}
