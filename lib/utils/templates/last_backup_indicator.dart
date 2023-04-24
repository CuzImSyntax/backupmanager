import 'package:flutter/material.dart';

import 'package:backupmanager/utils/time_utils.dart';

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
