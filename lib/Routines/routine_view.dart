import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:backupmanager/templates/default_view.dart';
import 'package:backupmanager/Database/Models/routine_model.dart';
import 'package:backupmanager/Database/Models/task_model.dart';
import 'package:backupmanager/Provider/data_provider.dart';
import 'package:backupmanager/Tasks/task_view.dart';
import 'package:backupmanager/Tasks/task_executor.dart';

class RoutineView extends StatelessWidget {
  static const String route = "/routine";

  const RoutineView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Routine routine =
        ModalRoute.of(context)!.settings.arguments as Routine;

    List<TaskView> children = [];
    for (Task task in context.watch<DataProvider>().tasks) {
      if (task.routineId == routine.id) {
        children.add(TaskView(
          task,
          taskExecutor: TaskExecutor(task.command),
        ));
      }
    }

    return DefaultContainerWrapper(
      title: routine.title,
      body: Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              routineActionBar(context, children, routine),
              Column(children: children),
            ],
          ),
        ),
      ),
    );
  }

  Widget routineActionBar(
      BuildContext context, List<TaskView> children, Routine routine) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          width: 100,
          height: 50,
          child: GestureDetector(
            onTap: () => Navigator.pushNamed(
              context,
              "/task/create",
              arguments: routine,
            ),
            child: const Card(
              color: Color(0xFF52796F),
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ),
        ),
        SizedBox(
          width: 100,
          height: 50,
          child: GestureDetector(
            onTap: (() async {
              for (TaskView taskView in children) {
                await taskView.taskExecutor.run();
              }
            }),
            child: const Card(
              color: Color(0xFF52796F),
              child: Icon(
                Icons.play_arrow,
                color: Colors.greenAccent,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
