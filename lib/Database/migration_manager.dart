import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class MigrationManager {
  Future<int> getMigrationIndex() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int index = prefs.getInt("migrationIndex") ?? -1;
    return index;
  }

  Future<void> setMigrationIndex(int index) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt("migrationIndex", index);
  }

  Future<Map<int, List<String>>> getMigrations() async {
    Map<int, List<String>> migrations = {};
    RegExp migrationRegex = RegExp(r"(\d+)_(.+)\.sql");

    final Directory migrationsDirectory = Directory("sql/migrations/");
    final List<FileSystemEntity> migrationFiles =
        await migrationsDirectory.list().toList();

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
