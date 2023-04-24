import 'dart:async';
import 'dart:io';

class TaskExecutor {
  int id;
  String commandString;
  bool dryRun = false;
  bool success = true;
  late Future<ProcessResult> command;
  StreamController<String> _controller = StreamController<String>();
  // We need this boolean to check when to rebuild the widget, as closing is with WillPopScope will result in Backups getting inserted also when it is a DryRun.
  bool rebuildNeeded = false;

  TaskExecutor(this.id, this.commandString); //ToDo Refactor this

  Future<void> run() async {
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
  }

  void rebuild() {
    dryRun = false;
    success = true;
    _controller = StreamController<String>();
    rebuildNeeded = false;
  }

  Stream<String> get stream => _controller.stream;

  void convertCommand() {
    List<String> commandArgs = [];

    if (dryRun) {
      commandArgs.add("-n");
    }
    commandArgs = commandString.split(";");

    command = Process.run("rsync", commandArgs);
  }
}
