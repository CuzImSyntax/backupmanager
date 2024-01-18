import 'package:intl/intl.dart';

/// Returns a timestamp as a readable String.
///
/// The format is dd.MM.yyyy HH:mm.
String convert2BackupTime(int? timestamp) {
  if (timestamp == null) {
    return "Never";
  }
  DateTime time = DateTime.fromMillisecondsSinceEpoch(timestamp);
  return DateFormat("dd.MM.yyyy HH:mm").format(time);
}

/// Returns true when a backup is needed based on a timestamp.
///
/// Currently this means that the last successful backup is older than 5 days.
bool isBackupNeeded(int? timestamp) {
  if (timestamp == null) {
    return true;
  }
  int minimumTime =
      DateTime.now().subtract(const Duration(days: 5)).millisecondsSinceEpoch;
  return minimumTime > timestamp;
}
