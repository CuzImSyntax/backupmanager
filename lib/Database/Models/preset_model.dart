import 'package:backupmanager/Database/Models/database_object.dart';
import 'package:sqflite_common/sqlite_api.dart';

import 'package:backupmanager/Database/Models/model_database_base.dart';

/// Represents a Preset model from the database.
class Preset extends DatabaseObject {
  /// The id of the preset.
  final int? id;

  /// The command string of the preset.
  final String commandString;

  /// The command string in a list, split by `;`.
  List<String> commandsOptions = [];

  Preset({this.id, required this.commandString}) {
    for (String option in commandString.split(";")) {
      commandsOptions.add(option);
    }
  }

  @override
  Map<String, dynamic> toMap() {
    return {"commandString": commandString};
  }
}

/// Mixin to get, insert, delete presets from the database.
mixin PresetDatabaseOptions implements ModelDatabaseBase {
  /// Inserts a given [preset] to the database.
  Future<Preset> insertPreset(Preset preset) async {
    Database database = await init();
    int id = await database.insert("presets", preset.toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore);
    await close(database);
    return Preset(id: id, commandString: preset.commandString);
  }

  /// Returns a list of all [Preset]s saved in the database.
  Future<List<Preset>> getPresets() async {
    Database database = await init();
    final List<Map<String, dynamic>> maps = await database.query("presets");
    await close(database);

    return List.generate(maps.length, (index) {
      return Preset(
        id: maps[index]["id"],
        commandString: maps[index]["commandString"],
      );
    });
  }

  /// Deletes a given [preset] from the database.
  Future<void> deletePreset(Preset preset) async {
    Database database = await init();
    await database.delete("presets", where: "id = ?", whereArgs: [preset.id]);
    await close(database);
  }
}
