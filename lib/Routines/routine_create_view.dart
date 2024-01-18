import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:backupmanager/utils/templates/default_view.dart';
import 'package:backupmanager/Provider/data_provider.dart';
import 'package:backupmanager/Database/Models/routine_model.dart';
import 'package:backupmanager/utils/text_field_widget.dart';

/// The view shown when creating a new [Routine].
class RoutineCreateView extends StatelessWidget {
  static const String route = "/routine/create";

  const RoutineCreateView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultContainerWrapper(
      title: "Add a new routine",
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: TextFieldWidget(
          "Name",
          onSubmitted: (value) async {
            await context.read<DataProvider>().insertRoutine(
                  Routine(title: value),
                );
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
