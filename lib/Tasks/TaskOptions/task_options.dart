class TaskOption {
  final String name;
  final String description;
  final bool enabledByDefault;
  bool isSelected = false;

  TaskOption(this.name, this.description, {this.enabledByDefault = false}) {
    if (enabledByDefault) {
      isSelected = true;
    }
  }
}

final List<TaskOption> taskOptions = [
  TaskOption("-a", "archive mode; equals -rlptgoD", enabledByDefault: true),
  TaskOption("-v", "increase verbosity", enabledByDefault: true),
  TaskOption("-u", "skip files that are newer on the receiver"),
  TaskOption("-x", "don't cross filesystem boundaries"),
  TaskOption("-P", "same as --partial --progress"),
  TaskOption("--ignore-existing", "skip updating files that exist on receiver"),
  TaskOption("-z", "compress file data during the transfer"),
  TaskOption("-E", "preserve executability"),
  TaskOption("-p", "preserve permissions"),
  TaskOption("--delete", "delete extraneous files from dest dirs"),
  TaskOption("-c", "skip based on checksum, not mod-time & size"),
  TaskOption("-h", "output numbers in a human-readable format"),
  TaskOption("-H", "preserve hard links"),
  TaskOption("--stats", "give some file-transfer stats"),
  TaskOption("--size-only", "skip files that match in size"),
  TaskOption("--progress", "show progress during transfer"),
  //ToDo is this needed for Backup Dir Path?
  TaskOption("-b", "make backups (see --suffix & --backup-dir)"),
  // ToDo Those needs params
  // TaskOption("--bwlimit", "tbd"),
  // TaskOption("--iconv", "tbd"),
  // TaskOption("-e", "tbd"),
];
