import 'package:backupmanager/Database/Models/database_object.dart';
import 'package:sqflite_common/sqlite_api.dart';

import 'package:backupmanager/Database/Models/model_database_base.dart';

/// Represents a Task model from the database.
class Task extends DatabaseObject {
  /// The id of the task.
  int? id;

  /// The id of the routine the task belongs to.
  int routineId;

  /// The name of the task.
  String name;

  /// The command string of the task.
  String command;

  Task({
    this.id,
    required this.routineId,
    required this.name,
    required this.command,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      "routineId": routineId,
      "name": name,
      "command": command,
    };
  }
}

/// Mixin to get, insert, delete tasks from the database.
mixin TaskDatabaseOptions implements ModelDatabaseBase {
  /// Inserts a given [task] to the database.
  Future<Task> insertTask(Task task) async {
    Database database = await init();
    int id = await database.insert("tasks", task.toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore);
    await close(database);
    return Task(
      id: id,
      routineId: task.routineId,
      name: task.name,
      command: task.command,
    );
  }

  /// Returns a list of all [Task]s saved in the database.
  Future<List<Task>> getTasks() async {
    Database database = await init();
    final List<Map<String, dynamic>> maps = await database.query("tasks");
    await close(database);

    return List.generate(maps.length, (index) {
      return Task(
        id: maps[index]["id"],
        routineId: maps[index]["routineId"],
        name: maps[index]["name"],
        command: maps[index]["command"],
      );
    });
  }

  /// Deletes a given [task] from the database.
  Future<void> deleteTask(Task task) async {
    Database database = await init();
    await database.delete("tasks", where: "id = ?", whereArgs: [task.id]);
    await close(database);
  }
}
