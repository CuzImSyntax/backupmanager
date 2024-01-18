import 'package:backupmanager/Database/Models/database_object.dart';
import 'package:sqflite_common/sqlite_api.dart';

import 'package:backupmanager/Database/Models/model_database_base.dart';

/// Represents a RoutineBackup model from the database.
class RoutineBackup extends DatabaseObject {
  /// The id of the routine backup.
  final int? id;

  /// The id of the routine the routine backup belongs to.
  final int routineId;

  /// The timestamp of the backup.
  final int timestamp;

  /// Whether the backup was successful.
  bool success;

  RoutineBackup({
    this.id,
    required this.routineId,
    required this.timestamp,
    this.success = false,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      "routineId": routineId,
      "timestamp": timestamp,
      "success": success ? 1 : 0,
    };
  }
}

/// Mixin to get and insert routine backups from the database.
mixin RoutineBackupDatabaseOptions implements ModelDatabaseBase {
  /// Inserts a given [routineBackup] to the database.
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

  /// Update the given [routineBackup] in the database.
  ///
  /// For that the [RoutineBackup] already needs to have an id (be existent in the DB).
  Future<void> updateRoutineBackup(RoutineBackup routineBackup) async {
    if (routineBackup.id == null) return;

    Database database = await init();
    await database.update("routine_backups", routineBackup.toMap(),
        where: "id = ?", whereArgs: [routineBackup.id]);
    await close(database);
  }

  /// Returns a list of all [RoutineBackup]s saved in the database.
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
