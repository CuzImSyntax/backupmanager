import 'package:backupmanager/Database/Models/database_object.dart';
import 'package:sqflite_common/sqlite_api.dart';

import 'package:backupmanager/Database/Models/model_database_base.dart';

/// Represents a TaskBackup model from the database.
class TaskBackup extends DatabaseObject {
  /// The id of the task backup.
  final int? id;

  /// The optional id of the routine backup.
  ///
  /// A [TaskBackup] could belong to a [RoutineBackup] in case the Task Backup was triggered through a routine backup.
  final int? routineBackupId;

  /// The if of the task the routine backup belongs to.
  final int taskId;

  /// The timestamp of the backup.
  final int timestamp;

  /// Whether the backup was successful.
  final bool success;

  TaskBackup({
    this.id,
    this.routineBackupId,
    required this.taskId,
    required this.timestamp,
    required this.success,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      "routineBackupId": routineBackupId,
      "taskId": taskId,
      "timestamp": timestamp,
      "success": success ? 1 : 0,
    };
  }
}

/// Mixin to get and insert tasks backups from the database.
mixin TaskBackupDatabaseOptions implements ModelDatabaseBase {
  /// Inserts a given [taskBackup] to the database.
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

  /// Returns a list of all [TaskBackup]s saved in the database.
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
