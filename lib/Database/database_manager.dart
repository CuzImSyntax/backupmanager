import 'dart:io';
import 'package:backupmanager/Database/migration_manager.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:backupmanager/Database/Models/routine_model.dart';
import 'package:backupmanager/Database/Models/task_model.dart';
import 'package:backupmanager/Database/Models/preset_model.dart';
import 'package:backupmanager/Database/Models/routine_backups_model.dart';
import 'package:backupmanager/Database/Models/task_backup_model.dart';

/// This class bundles all DatabaseOption mixins to one point.
class DatabaseManager
    with
        RoutineDatabaseOptions,
        TaskDatabaseOptions,
        PresetDatabaseOptions,
        RoutineBackupDatabaseOptions,
        TaskBackupDatabaseOptions {
  /// Initializes the database.
  ///
  /// Intially creates the database and applies all migrations to it.
  @override
  Future<Database> init() async {
    sqfliteFfiInit();
    Directory dir = await getApplicationDocumentsDirectory();
    var databaseFactory = databaseFactoryFfi;
    await MigrationManager().getMigrations();
    Database database = await databaseFactory
        .openDatabase(join(dir.path, 'backupmanager/db/database.db'));

    // Enable FOREIGN KEYs
    await database.execute("PRAGMA foreign_keys = ON");

    MigrationManager migrationManager = MigrationManager();

    int index = await migrationManager.getMigrationIndex();
    Map<int, List<String>> migrations = await migrationManager.getMigrations();

    migrations.forEach(
      (key, value) async {
        if (key > index) {
          for (String query in value) {
            await database.execute(query);
          }
          await migrationManager.setMigrationIndex(key);
        }
      },
    );
    return database;
  }

  /// Closes the connection to the database.
  @override
  Future<void> close(Database database) async {
    await database.close();
  }
}
