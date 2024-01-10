import 'package:flutter/material.dart';

import 'package:backupmanager/Tasks/TaskOptions/task_options.dart';

class TaskOptionUtils {
  static String buildCommandString({
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
