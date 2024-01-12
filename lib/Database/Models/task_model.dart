import 'package:sqflite_common/sqlite_api.dart';

import 'package:backupmanager/Database/Models/model_database_base.dart';

class Task {
  int? id;
  int routineId;
  String name;
  String command;

  Task({
    this.id,
    required this.routineId,
    required this.name,
    required this.command,
  });

  Map<String, dynamic> toMap() {
    return {
      "routineId": routineId,
      "name": name,
      "command": command,
    };
  }
}

mixin TaskDatabaseOptions implements ModelDatabaseBase {
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

  Future<void> deleteTask(Task task) async {
    Database database = await init();
    await database.delete("tasks", where: "id = ?", whereArgs: [task.id]);
    await close(database);
  }
}
