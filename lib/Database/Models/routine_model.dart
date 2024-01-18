import 'package:backupmanager/Database/Models/database_object.dart';
import 'package:sqflite_common/sqlite_api.dart';

import 'package:backupmanager/Database/Models/model_database_base.dart';

/// Represents a Routine model from the database.
class Routine extends DatabaseObject {
  /// The id of the routine.
  final int? id;

  /// The title of the routine.
  final String title;

  Routine({
    this.id,
    required this.title,
  });

  @override
  Map<String, dynamic> toMap() {
    return {"title": title};
  }
}

/// Mixin to get, insert, delete routines from the database.
mixin RoutineDatabaseOptions implements ModelDatabaseBase {
  /// Inserts a given [routine] to the database.
  Future<Routine> insertRoutine(Routine routine) async {
    Database database = await init();
    int id = await database.insert("routines", routine.toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore);
    await close(database);
    return Routine(id: id, title: routine.title);
  }

  /// Returns a list of all [Routine]s saved in the database.
  Future<List<Routine>> getRoutines() async {
    Database database = await init();
    final List<Map<String, dynamic>> maps = await database.query("routines");
    await close(database);

    return List.generate(maps.length, (index) {
      return Routine(
        id: maps[index]["id"],
        title: maps[index]["title"],
      );
    });
  }

  /// Deletes a given [routine] from the database.
  Future<void> deleteRoutine(Routine routine) async {
    Database database = await init();
    await database.delete("routines", where: "id = ?", whereArgs: [routine.id]);
    await close(database);
  }
}
