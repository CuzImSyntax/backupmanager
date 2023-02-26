import 'package:sqflite_common/sqlite_api.dart';

import 'package:backupmanager/Database/Models/model_database_base.dart';

class Preset extends Object {
  final int? id;
  final String commandString;
  List<String> commandsOptions = [];

  Preset({this.id, required this.commandString}) {
    for (String option in commandString.split(";")) {
      commandsOptions.add(option);
    }
  }

  Map<String, dynamic> toMap() {
    return {"commandString": commandString};
  }
}

mixin PresetDatabaseOptions implements ModelDatabaseBase {
  Future<Preset> insertPreset(Preset preset) async {
    Database database = await init();
    int id = await database.insert("presets", preset.toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore);
    close(database);
    return Preset(id: id, commandString: preset.commandString);
  }

  Future<List<Preset>> getPresets() async {
    Database database = await init();
    final List<Map<String, dynamic>> maps = await database.query("presets");
    close(database);

    return List.generate(maps.length, (index) {
      return Preset(
        id: maps[index]["id"],
        commandString: maps[index]["commandString"],
      );
    });
  }

  Future<void> deletePreset(Preset preset) async {
    Database database = await init();
    await database.delete("presets", where: "id = ?", whereArgs: [preset.id]);
    close(database);
  }
}
