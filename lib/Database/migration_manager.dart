import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

/// Manages incremental database changes.
class MigrationManager {
  /// Returns the current migration index.
  Future<int> getMigrationIndex() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int index = prefs.getInt("migrationIndex") ?? -1;
    return index;
  }

  /// Sets the migration index to the given [index].
  Future<void> setMigrationIndex(int index) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt("migrationIndex", index);
  }

  /// Returns all migrations.
  ///
  /// The migrations are returned as a Map.
  /// The key is the index of the migration and the value the SQL string(s).
  Future<Map<int, List<String>>> getMigrations() async {
    Map<int, List<String>> migrations = {};
    RegExp migrationRegex = RegExp(r"(\d+)_(.+)\.sql");

    // Fetch all files from the migrations dir
    final Directory migrationsDirectory = Directory("sql/migrations/");
    final List<FileSystemEntity> migrationFiles =
        await migrationsDirectory.list().toList();

    // Check if file is valid migration and add the content to the migrations map.
    for (FileSystemEntity file in migrationFiles) {
      RegExpMatch? migrationRegexMatch = migrationRegex.firstMatch(file.path);

      if (migrationRegexMatch != null) {
        String migrationContent = await File(file.path).readAsString();
        List<String> migrationData = [migrationContent.replaceAll("\n", "")];
        migrations[int.parse(migrationRegexMatch.group(1)!)] = migrationData;
      }
    }
    return migrations;
  }
}
