import 'dart:async';
import 'dart:io';

import 'package:backupmanager/Database/Models/task_model.dart';

/// Class used to execute the backups (tasks).
///
/// The tasks are rsync commands which get executed through a shell.
class TaskExecutor {
  /// The given [Task].
  final Task task;

  /// Whether the backup should be executed as a dry Run.
  ///
  /// This means simulating the backup.
  bool dryRun = false;

  /// Indicating whether the backup was successful.
  bool success = true;
  late Future<ProcessResult> command;

  /// The controller that is used to be listened to by the task view.
  ///
  /// This indicates whether the backup is running or was successful / failed.
  StreamController<String> _controller = StreamController<String>();
  // We need this boolean to check when to rebuild the widget, as closing is with WillPopScope will result in Backups getting inserted also when it is a DryRun.
  bool rebuildNeeded = false;

  TaskExecutor(this.task);

  /// Returns the stream of the [TaskExecutor] instance.
  Stream<String> get stream => _controller.stream;

  /// Run the task.
  ///
  /// Executes the rsync command and informs the view through the stream.
  Future<bool> run() async {
    _controller.sink.add("Starting");
    convertCommand();
    await for (ProcessResult result in command.asStream()) {
      _controller.sink.add(result.stdout);
      if (result.stderr != "") {
        _controller.sink.addError(result.stderr);
        success = false;
      }
    }
    _controller.sink.close();
    return success;
  }

  /// Rebuild the task executor to be able to run again.
  void rebuild() {
    dryRun = false;
    success = true;
    _controller = StreamController<String>();
    rebuildNeeded = false;
  }

  /// Converts the saved command string to the command being executed in the shell.
  void convertCommand() {
    List<String> commandArgs = [];

    if (dryRun) {
      commandArgs.add("-n");
    }
    commandArgs = task.command.split(";");

    command = Process.run("rsync", commandArgs);
  }
}
