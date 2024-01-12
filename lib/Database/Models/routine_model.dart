import 'package:sqflite_common/sqlite_api.dart';

import 'package:backupmanager/Database/Models/model_database_base.dart';

class Routine extends Object {
  final int? id;
  final String title;

  const Routine({
    this.id,
    required this.title,
  });

  Map<String, dynamic> toMap() {
    return {"title": title};
  }
}

mixin RoutineDatabaseOptions implements ModelDatabaseBase {
  Future<Routine> insertRoutine(Routine routine) async {
    Database database = await init();
    int id = await database.insert("routines", routine.toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore);
    await close(database);
    return Routine(id: id, title: routine.title);
  }

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

  Future<void> deleteRoutine(Routine routine) async {
    Database database = await init();
    await database.delete("routines", where: "id = ?", whereArgs: [routine.id]);
    await close(database);
  }
}
