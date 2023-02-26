import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:backupmanager/utils/templates/default_view.dart';
import 'package:backupmanager/Provider/data_provider.dart';
import 'package:backupmanager/Database/Models/task_model.dart';
import 'package:backupmanager/Database/Models/routine_model.dart';
import 'package:backupmanager/Tasks/TaskOptions/task_options.dart';
import 'package:backupmanager/Tasks/TaskOptions/task_options_widget.dart';
import 'package:backupmanager/utils/text_field_widget.dart';
import 'package:backupmanager/utils/task_option_utils.dart';

class TaskCreateView extends StatefulWidget {
  static const String route = "/task/create";
  const TaskCreateView({Key? key}) : super(key: key);

  @override
  _RoutineCreateViewState createState() => _RoutineCreateViewState();
}

class _RoutineCreateViewState extends State<TaskCreateView> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController sourceController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();
  final TextEditingController backupDirController = TextEditingController();
  final TextEditingController excludeDirController = TextEditingController();

  List<String> excludePaths = [];

  @override
  void dispose() {
    nameController.dispose();
    sourceController.dispose();
    destinationController.dispose();
    for (TaskOption taskOption in taskOptions) {
      taskOption.isSelected = taskOption.enabledByDefault;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Routine routine =
        ModalRoute.of(context)!.settings.arguments as Routine;

    return DefaultContainerWrapper(
      title: "Add a new task",
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFieldWidget("Task Name", controller: nameController),
            TextFieldWidget("Source Directory", controller: sourceController),
            TextFieldWidget("Destination Directory",
                controller: destinationController),
            TaskOptionsWidget(
              backupDirController: backupDirController,
              excludeDirController: excludeDirController,
              excludePaths: excludePaths,
            ),
            _CreateTaskButton(
              routine: routine,
              nameController: nameController,
              sourceController: sourceController,
              destinationController: destinationController,
              backupDirController: backupDirController,
              excludePaths: excludePaths,
            ),
          ],
        ),
      ),
    );
  }
}

class _CreateTaskButton extends StatelessWidget {
  final Routine routine;
  final TextEditingController nameController;
  final TextEditingController sourceController;
  final TextEditingController destinationController;
  final TextEditingController backupDirController;
  final List<String> excludePaths;

  const _CreateTaskButton({
    required this.routine,
    required this.nameController,
    required this.sourceController,
    required this.destinationController,
    required this.backupDirController,
    required this.excludePaths,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: ElevatedButton(
        onPressed: () async {
          if (nameController.text.isNotEmpty &&
              sourceController.text.isNotEmpty) {
            String command = TaskOptionUtils.buildCommandString(
              sourceController: sourceController,
              destinationController: destinationController,
              backupDirController: backupDirController,
              excludePaths: excludePaths,
            );
            await context.read<DataProvider>().insertTask(
                  Task(
                      routineId: routine.id!,
                      name: nameController.text,
                      command: command),
                );
            Navigator.pop(
              context,
            );
          }
        },
        child: const Text("Add"),
      ),
    );
  }
}
