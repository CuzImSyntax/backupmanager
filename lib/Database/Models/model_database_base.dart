import 'package:sqflite/sqlite_api.dart';

abstract class ModelDatabaseBase {
  external Future<Database> init();
  external void close(Database database);
}
