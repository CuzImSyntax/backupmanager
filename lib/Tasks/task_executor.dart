import 'dart:async';
import 'dart:io';

class TaskExecutor {
  String commandString;
  bool dryRun = false;
  late Future<ProcessResult> command;
  final _controller = StreamController<String>();

  TaskExecutor(this.commandString);

  Future<void> run() async {
    _controller.add("Starting");
    convertCommand();
    await for (ProcessResult result in command.asStream()) {
      _controller.sink.add(result.stdout);
      if (result.stderr != "") {
        _controller.sink.addError(result.stderr);
      }
    }
    _controller.sink.close();
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
