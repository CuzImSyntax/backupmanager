import 'package:sqflite_common/sqlite_api.dart';

import 'package:backupmanager/Database/Models/model_database_base.dart';

class TaskBackup extends Object {
  final int? id;
  final int? routineBackupId;
  final int taskId;
  final int timestamp;
  final bool success;

  const TaskBackup({
    this.id,
    this.routineBackupId,
    required this.taskId,
    required this.timestamp,
    required this.success,
  });

  Map<String, dynamic> toMap() {
    return {
      "routineBackupId": routineBackupId,
      "taskId": taskId,
      "timestamp": timestamp,
      "success": success ? 1 : 0,
    };
  }
}

mixin TaskBackupDatabaseOptions implements ModelDatabaseBase {
  Future<TaskBackup> insertTaskBackup(TaskBackup taskBackup) async {
    Database database = await init();
    int id = await database.insert("task_backups", taskBackup.toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore);
    await close(database);
    return TaskBackup(
      id: id,
      routineBackupId: taskBackup.routineBackupId,
      taskId: taskBackup.taskId,
      timestamp: taskBackup.timestamp,
      success: taskBackup.success,
    );
  }

  Future<List<TaskBackup>> getTaskBackups() async {
    Database database = await init();
    final List<Map<String, dynamic>> maps =
        await database.query("task_backups");
    await close(database);

    return List.generate(maps.length, (index) {
      return TaskBackup(
        id: maps[index]["id"],
        routineBackupId: maps[index]["routineBackupId"],
        taskId: maps[index]["taskId"],
        timestamp: maps[index]["timestamp"],
        success: maps[index]["success"] == 1 ? true : false,
      );
    });
  }
}
