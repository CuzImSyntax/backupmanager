import 'package:flutter/material.dart';

import 'package:backupmanager/Tasks/TaskOptions/task_options.dart';

/// Utils used for Task creation.
class TaskCreationUtils {
  /// Builds a command string that gets saved in the db.
  ///
  /// The String is created based on the [sourceController],[destinationController], [backupdDirController] and the [excludePaths].
  /// The String is a rsync command, where every argument is seperated by a `;`.
  static String buildCommandString({
    /// Whether the source and destination should be included.
    ///
    /// This is included as presets are saved without the paths.
    bool includePaths = true,
    TextEditingController? sourceController,
    TextEditingController? destinationController,
    required TextEditingController backupDirController,
    required List<String> excludePaths,
  }) {
    String commandString = "";

    //Add source and destination if includePaths is true
    if (includePaths) {
      if (sourceController == null || destinationController == null) {
        throw Exception(
            "sourceController and destinationController cannot be null when includePaths is true");
      }
      commandString += "${sourceController.text};";
      commandString += "${destinationController.text};";
    }

    //Add all the normal options
    for (TaskOption taskOption in taskOptions) {
      if (taskOption.isSelected) {
        commandString += "${taskOption.name};";
      }
    }
    //Add the backupDir if existing
    if (backupDirController.text.isNotEmpty) {
      commandString += "--backup-dir=${backupDirController.text};";
    }

    //Add all the paths to exlcude
    if (excludePaths.isNotEmpty) {
      for (String path in excludePaths) {
        commandString += "--exclude=$path;";
      }
    }
    if (commandString.endsWith(";")) {
      commandString = commandString.substring(0, commandString.length - 1);
    }
    return commandString;
  }
}
