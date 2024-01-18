import 'package:sqflite/sqlite_api.dart';

/// Base class for all DatabaseOptions mixins.
///
/// This abstract class injects the two external functions [init] and [close] in the mixins.
/// The implementation of these functions are in the [DatabaseManager].
abstract class ModelDatabaseBase {
  /// Initialize the connection to the database
  ///
  /// Returns the [Database] object.
  external Future<Database> init();

  /// Close the connection to the given [database].
  external Future<void> close(Database database);
}
