import 'package:intl/intl.dart';

String convert2BackupTime(int? timestamp) {
  if (timestamp == null) {
    return "Never";
  }
  DateTime time = DateTime.fromMillisecondsSinceEpoch(timestamp);
  return DateFormat("dd.MM.yyyy HH:mm").format(time);
}

bool isBackupNeeded(int? timestamp) {
  if (timestamp == null) {
    return true;
  }
  int minimumTime =
      DateTime.now().subtract(const Duration(days: 5)).millisecondsSinceEpoch;
  return minimumTime > timestamp;
}
