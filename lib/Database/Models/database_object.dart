/// Base class for all classes representing a database object.
abstract class DatabaseObject extends Object {
  /// Converts the object to a map.
  Map<String, dynamic> toMap();
}
