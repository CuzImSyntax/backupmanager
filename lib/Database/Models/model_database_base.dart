import 'package:sqflite/sqlite_api.dart';

abstract class ModelDatabaseBase {
  external Future<Database> init();
  external Future<void> close(Database database);
}
