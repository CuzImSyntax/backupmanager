import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:backupmanager/Tasks/task_view.dart';
import 'package:backupmanager/Database/Models/routine_model.dart';
import 'package:backupmanager/Database/Models/routine_backups_model.dart';
import 'package:backupmanager/Database/Models/task_backup_model.dart';
import 'package:backupmanager/Provider/data_provider.dart';
import 'package:backupmanager/utils/templates/last_backup_indicator.dart';

/// View with buttons to add a task / run all tasks + last backup indicator.
///
/// This is shown on top of the [RoutineDetailView].
class RoutineDetailViewActionBar extends StatelessWidget {
  final List<TaskView> children;
  final Routine routine;

  const RoutineDetailViewActionBar(this.children, this.routine, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                  startBackupButtonCallback(context);
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

  void startBackupButtonCallback(BuildContext context) async {
    RoutineBackup routineBackup =
        await context.read<DataProvider>().insertRoutineBackup(
              RoutineBackup(
                routineId: routine.id!,
                timestamp: DateTime.now().millisecondsSinceEpoch,
              ),
            );

    bool success = true;
    for (TaskView taskView in children) {
      bool taskStatus = await taskView.taskExecutor.run();
      if (!taskStatus) {
        success = false;
      }

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
    // Indicates whether one or more tasks are set to dryRun.
    // We only want to count a routine backup successful, when all tasks actually executed successful.
    bool hasDryRuns =
        children.any((element) => element.taskExecutor.dryRun == true);
    if (success && !hasDryRuns) {
      routineBackup.success = true;
      await context.read<DataProvider>().updateRoutineBackup(routineBackup);
    }
  }
}
