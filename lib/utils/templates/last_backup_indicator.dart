import 'package:flutter/material.dart';

import 'package:backupmanager/utils/time_utils.dart';

/// Widget showing the time of the last backup.
///
/// Based on a given [timestamp] this returns a widget showing the last valid backup.
/// A Icon also indicates whether a new backup is needed.
class LastBackupIndicator extends StatelessWidget {
  final int? timestamp;

  const LastBackupIndicator(this.timestamp, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.circle,
          size: 15,
          color: isBackupNeeded(timestamp) ? Colors.red : Colors.greenAccent,
        ),
        Text(
          "Last Backup: " + convert2BackupTime(timestamp),
          maxLines: 1,
        ),
      ],
    );
  }
}
