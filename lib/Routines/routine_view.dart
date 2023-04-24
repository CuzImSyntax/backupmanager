import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:backupmanager/utils/templates/default_view.dart';
import 'package:backupmanager/utils/templates/last_backup_indicator.dart';
import 'package:backupmanager/Database/Models/routine_model.dart';
import 'package:backupmanager/Database/Models/task_model.dart';
import 'package:backupmanager/Database/Models/routine_backups_model.dart';
import 'package:backupmanager/Database/Models/task_backup_model.dart';
import 'package:backupmanager/Provider/data_provider.dart';
import 'package:backupmanager/Tasks/task_view.dart';
import 'package:backupmanager/Tasks/task_executor.dart';

class TaskBackupInfo {
  TaskView taskView;
  int time;

  TaskBackupInfo(this.taskView, this.time);
}

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
    RoutineBackup? latestBackup =
        context.watch<DataProvider>().getLatestRoutineBackup(routine);
    return Column(
      children: [
        Row(
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
                  // ToDo Do we still want to insert a Backup when all of the Backups are set to DryRun?
                  RoutineBackup routineBackup = await context
                      .read<DataProvider>()
                      .insertRoutineBackup(
                        RoutineBackup(
                            routineId: routine.id!,
                            timestamp: DateTime.now().millisecondsSinceEpoch),
                      );

                  for (TaskView taskView in children) {
                    await taskView.taskExecutor.run();

                    if (!taskView.taskExecutor.dryRun) {
                      await context.read<DataProvider>().insertTaskBackup(
                            TaskBackup(
                              routineBackupId: routineBackup.id,
                              taskId: taskView.task.id!,
                              timestamp: DateTime.now().millisecondsSinceEpoch,
                              success: taskView.taskExecutor.success,
                            ),
                          );
                    }
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
        ),
        SizedBox(
          width: 250,
          height: 40,
          child: Card(
            color: const Color(0xFF52796F),
            child: LastBackupIndicator(latestBackup?.timestamp),
          ),
        ),
      ],
    );
  }
}
