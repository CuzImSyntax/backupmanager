import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:backupmanager/utils/templates/default_view.dart';
import 'package:backupmanager/Database/Models/routine_model.dart';
import 'package:backupmanager/Database/Models/task_model.dart';
import 'package:backupmanager/Provider/data_provider.dart';
import 'package:backupmanager/Tasks/task_view.dart';
import 'package:backupmanager/Tasks/task_executor.dart';
import 'package:backupmanager/Routines/routine_detail_view_action_bar.dart';

/// A View listing all [Task]s belonging to a specific [Routine].
///
/// This gives the opportunity to add a new task, run + delete specific tasks.
/// You can also run all tasks at once.
class RoutineDetailView extends StatelessWidget {
  static const String route = "/routine";

  const RoutineDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Routine routine =
        ModalRoute.of(context)!.settings.arguments as Routine;

    List<TaskView> children = [];
    for (Task task in context.watch<DataProvider>().tasks) {
      if (task.routineId == routine.id) {
        TaskExecutor taskExecutor =
            context.read<DataProvider>().getTaskExecutor(task);
        // Rebuild when taskExecutor was already used.
        if (taskExecutor.rebuildNeeded) {
          taskExecutor.rebuild();
        }
        children.add(TaskView(
          task,
          taskExecutor: taskExecutor,
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
              RoutineDetailViewActionBar(children, routine),
              Column(children: children),
            ],
          ),
        ),
      ),
    );
  }
}
