import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:backupmanager/templates/default_view.dart';
import 'package:backupmanager/data_provider.dart';
import 'package:backupmanager/Database/Models/task_model.dart';
import 'package:backupmanager/Database/Models/routine_model.dart';

class TaskCreateView extends StatefulWidget {
  static const String route = "/task/create";
  const TaskCreateView({Key? key}) : super(key: key);

  @override
  _RoutineCreateViewState createState() => _RoutineCreateViewState();
}

class _RoutineCreateViewState extends State<TaskCreateView> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController commandController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    commandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Routine routine =
        ModalRoute.of(context)!.settings.arguments as Routine;

    return DefaultContainerWrapper(
      title: "Add a new task",
      body: Column(
        children: [
          textFieldWidget(nameController, "Name"),
          textFieldWidget(commandController, "Command"),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.isNotEmpty &&
                  commandController.text.isNotEmpty) {
                await context.read<DataProvider>().insertTask(
                      Task(
                          routineId: routine.id!,
                          name: nameController.text,
                          command: commandController.text),
                    );
                Navigator.pop(
                  context,
                );
              }
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  Widget textFieldWidget(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: TextField(
        controller: controller,
        style: Theme.of(context).textTheme.bodyText1,
        cursorColor: Colors.white,
        decoration: InputDecoration(
          labelStyle: Theme.of(context).textTheme.bodyText1,
          border: const OutlineInputBorder(),
          labelText: label,
        ),
      ),
    );
  }
}
