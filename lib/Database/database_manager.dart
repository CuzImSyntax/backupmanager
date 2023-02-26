import 'dart:io';
import 'package:backupmanager/Database/Models/preset_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:backupmanager/Database/Models/routine_model.dart';
import 'package:backupmanager/Database/Models/task_model.dart';

class DatabaseManager
    with RoutineDatabaseOptions, TaskDatabaseOptions, PresetDatabaseOptions {
  @override
  Future<Database> init() async {
    sqfliteFfiInit();
    Directory dir = await getApplicationDocumentsDirectory();
    var databaseFactory = databaseFactoryFfi;
    Database database = await databaseFactory
        .openDatabase(join(dir.path, 'backupmanager/db/database.db'));
    await database.execute(
        "CREATE TABLE IF NOT EXISTS routines (id INTEGER PRIMARY KEY, title TEXT)");
    await database.execute(
        "CREATE TABLE IF NOT EXISTS tasks (id INTEGER PRIMARY KEY, routineId INTEGER, name TEXT, command TEXT, FOREIGN KEY(routineId) REFERENCES routines(id))");
    await database.execute(
        "CREATE TABLE IF NOT EXISTS presets (id INTEGER PRIMARY KEY, commandString TEXT)");
    return database;
  }

  @override
  void close(Database database) async {
    await database.close();
  }
}
