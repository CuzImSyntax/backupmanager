import 'package:sqflite_common/sqlite_api.dart';

import 'package:backupmanager/Database/Models/model_database_base.dart';

class RoutineBackup extends Object {
  final int? id;
  final int routineId;
  final int timestamp;
  bool success;

  RoutineBackup({
    this.id,
    required this.routineId,
    required this.timestamp,
    this.success = false,
  });

  Map<String, dynamic> toMap() {
    return {
      "routineId": routineId,
      "timestamp": timestamp,
      "success": success ? 1 : 0,
    };
  }
}

mixin RoutineBackupDatabaseOptions implements ModelDatabaseBase {
  Future<RoutineBackup> insertRoutineBackup(RoutineBackup routineBackup) async {
    Database database = await init();
    int id = await database.insert("routine_backups", routineBackup.toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore);
    await close(database);
    return RoutineBackup(
      id: id,
      routineId: routineBackup.routineId,
      timestamp: routineBackup.timestamp,
      success: routineBackup.success,
    );
  }

  Future<void> updateRoutineBackup(RoutineBackup routineBackup) async {
    if (routineBackup.id == null) return;

    Database database = await init();
    await database.update("routine_backups", routineBackup.toMap(),
        where: "id = ?", whereArgs: [routineBackup.id]);
    await close(database);
  }

  Future<List<RoutineBackup>> getRoutineBackups() async {
    Database database = await init();
    final List<Map<String, dynamic>> maps =
        await database.query("routine_backups");
    await close(database);

    return List.generate(maps.length, (index) {
      return RoutineBackup(
        id: maps[index]["id"],
        routineId: maps[index]["routineId"],
        timestamp: maps[index]["timestamp"],
        success: maps[index]["success"] == 1 ? true : false,
      );
    });
  }
}
