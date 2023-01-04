import 'package:flutter/foundation.dart';

class TaskStatistics {
  final String filesTotal;
  final String files;
  final String directories;
  final String createdFiles;
  final String deletedFiles;
  final String regularTransferredFiles;
  final String literalData;
  final String matchedData;

  @factory
  TaskStatistics fromOutput(String output) {
    RegExp fileNumberRegExp =
        RegExp(r"/Number of files: (\d+) \(reg: (\d+), dir: (\d+)/");
    RegExp createdFilesRegExp = RegExp(r"/Number of created files: (\d+)/");
    RegExp deletedFilesRegExp = RegExp(r"/Number of deleted files: (\d+)/");
    RegExp regularTransferredFilesRegExp =
        RegExp(r"/Number of regular files transferred: (\d+)/");
    RegExp literalDataRegExp = RegExp(r"/Literal data: (\d+)/");
    RegExp matchedDataRegExp = RegExp(r"/Matched data: (\d+)/");

    Iterable<Match> filesNumbers = fileNumberRegExp.allMatches(output);

    return TaskStatistics(
      filesNumbers.elementAt(0).toString(),
      filesNumbers.elementAt(1).toString(),
      filesNumbers.elementAt(2).toString(),
      createdFilesRegExp.firstMatch(output).toString(),
      deletedFilesRegExp.firstMatch(output).toString(),
      regularTransferredFilesRegExp.firstMatch(output).toString(),
      literalDataRegExp.firstMatch(output).toString(),
      matchedDataRegExp.firstMatch(output).toString(),
    );
  }

  TaskStatistics(
    this.filesTotal,
    this.files,
    this.directories,
    this.createdFiles,
    this.deletedFiles,
    this.regularTransferredFiles,
    this.literalData,
    this.matchedData,
  );
}
