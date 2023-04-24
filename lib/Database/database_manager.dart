import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:backupmanager/Database/Models/routine_model.dart';
import 'package:backupmanager/Database/Models/task_model.dart';
import 'package:backupmanager/Database/Models/preset_model.dart';
import 'package:backupmanager/Database/Models/routine_backups_model.dart';
import 'package:backupmanager/Database/Models/task_backup_model.dart';

class DatabaseManager
    with
        RoutineDatabaseOptions,
        TaskDatabaseOptions,
        PresetDatabaseOptions,
        RoutineBackupDatabaseOptions,
        TaskBackupDatabaseOptions {
  @override
  Future<Database> init() async {
    sqfliteFfiInit();
    Directory dir = await getApplicationDocumentsDirectory();
    var databaseFactory = databaseFactoryFfi;
    Database database = await databaseFactory
        .openDatabase(join(dir.path, 'backupmanager/db/database.db'));
    await database.execute(
        "CREATE TABLE IF NOT EXISTS routines (id INTEGER PRIMARY KEY NOT NULL, title TEXT NOT NULL)");
    await database.execute(
        "CREATE TABLE IF NOT EXISTS tasks (id INTEGER PRIMARY KEY NOT NULL, routineId INTEGER NOT NULL, name TEXT NOT NULL, command TEXT NOT NULL, FOREIGN KEY(routineId) REFERENCES routines(id))");
    await database.execute(
        "CREATE TABLE IF NOT EXISTS presets (id INTEGER PRIMARY KEY NOT NULL, commandString TEXT NOT NULL)");
    await database.execute(
        "CREATE TABLE IF NOT EXISTS routine_backups (id INTEGER PRIMARY KEY NOT NULL, routineId INTEGER NOT NULL, timestamp INTEGER NOT NULL, FOREIGN KEY(routineId) REFERENCES routines(id))");
    await database.execute(
        "CREATE TABLE IF NOT EXISTS task_backups (id INTEGER PRIMARY KEY NOT NULL, routineBackupId INTEGER, taskId INTEGER NOT NULL, timestamp INTEGER NOT NULL, success INTEGER NOT NULL, FOREIGN KEY(routineBackupId) REFERENCES routine_backups(id), FOREIGN KEY(taskId) REFERENCES tasks(id))");
    return database;
  }

  @override
  void close(Database database) async {
    await database.close();
  }
}
