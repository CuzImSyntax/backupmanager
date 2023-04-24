import 'package:sqflite_common/sqlite_api.dart';

import 'package:backupmanager/Database/Models/model_database_base.dart';

class RoutineBackup extends Object {
  final int? id;
  final int routineId;
  final int timestamp;

  const RoutineBackup({
    this.id,
    required this.routineId,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      "routineId": routineId,
      "timestamp": timestamp,
    };
  }
}

mixin RoutineBackupDatabaseOptions implements ModelDatabaseBase {
  Future<RoutineBackup> insertRoutineBackup(RoutineBackup routineBackup) async {
    Database database = await init();
    int id = await database.insert("routine_backups", routineBackup.toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore);
    close(database);
    return RoutineBackup(
      id: id,
      routineId: routineBackup.routineId,
      timestamp: routineBackup.timestamp,
    );
  }

  Future<List<RoutineBackup>> getRoutineBackups() async {
    Database database = await init();
    final List<Map<String, dynamic>> maps =
        await database.query("routine_backups");
    close(database);

    return List.generate(maps.length, (index) {
      return RoutineBackup(
        id: maps[index]["id"],
        routineId: maps[index]["routineId"],
        timestamp: maps[index]["timestamp"],
      );
    });
  }
}
