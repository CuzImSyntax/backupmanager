import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:backupmanager/Database/Models/routine_model.dart';
import 'package:backupmanager/Database/Models/task_model.dart';

class DatabaseManager with RoutineDatabaseOptions, TaskDatabaseOptions {
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
    return database;
  }

  @override
  void close(Database database) async {
    await database.close();
  }
}
