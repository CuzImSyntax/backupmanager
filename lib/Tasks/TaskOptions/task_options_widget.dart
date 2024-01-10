import 'package:backupmanager/utils/task_option_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:backupmanager/Database/Models/preset_model.dart';
import 'package:backupmanager/Provider/data_provider.dart';
import 'package:backupmanager/Tasks/TaskOptions/task_option_selector.dart';
import 'package:backupmanager/Tasks/TaskOptions/task_options.dart';
import 'package:backupmanager/utils/text_field_widget.dart';

class TaskOptionsWidget extends StatefulWidget {
  final TextEditingController backupDirController;
  final TextEditingController excludeDirController;
  final List<String> excludePaths;

  const TaskOptionsWidget({
    Key? key,
    required this.backupDirController,
    required this.excludeDirController,
    required this.excludePaths,
  }) : super(key: key);

  @override
  _TaskOptionsWidgetState createState() => _TaskOptionsWidgetState();
}

class _TaskOptionsWidgetState extends State<TaskOptionsWidget> {
  late final TextEditingController backupDirController;
  late final TextEditingController excludeDirController;
  late List<String> excludePaths;

  @override
  void initState() {
    backupDirController = widget.backupDirController;
    excludeDirController = widget.excludeDirController;
    excludePaths = widget.excludePaths;
    super.initState();
  }

  Future<void> saveCurrentState() async {
    String commandString = TaskOptionUtils.buildCommandString(
      includePaths: false,
      backupDirController: backupDirController,
      excludePaths: excludePaths,
    );
    await context
        .read<DataProvider>()
        .insertPreset(Preset(commandString: commandString));
  }

  void retrieveSavedState() {
    setState(() {
      List<Preset> presets = context.read<DataProvider>().presets;
      if (presets.isEmpty) {
        return; // No preset saved yet
      }
      Preset preset = presets.first;
      for (TaskOption taskOption in taskOptions) {
        if (preset.commandsOptions.contains(taskOption.name)) {
          taskOption.isSelected = true;
        }
      }
      String backupDir = preset.commandsOptions
          .where((element) => element.contains("--backup-dir"))
          .first;
      backupDirController.text = backupDir.replaceFirst("--backup-dir=", "");
      Iterable<String> extractedExcludePaths = preset.commandsOptions
          .where((element) => element.contains("--exclude"));
      for (String path in extractedExcludePaths) {
        excludePaths.add(path.replaceFirst("--exclude=", ""));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Options",
          textAlign: TextAlign.left,
        ),
        Container(
          margin: const EdgeInsets.only(top: 10, bottom: 10),
          child: Row(
            children: [
              ElevatedButton(
                  onPressed: () async {
                    //Save the current state of options to the database
                    await saveCurrentState();
                  },
                  child: const Text("Save preset")),
              const SizedBox(
                width: 10,
              ),
              ElevatedButton(
                  onPressed: () {
                    //Retrieve the saved state of options from the database
                    retrieveSavedState();
                  },
                  child: const Text("Load preset")),
            ],
          ),
        ),
        Center(
          child: SizedBox(
            width: 450,
            height: 240,
            child: GridView.count(
              primary: false,
              childAspectRatio:
                  (taskOptionSelectorWidth / taskOptionSelectorHeight),
              crossAxisCount: 3,
              children: (taskOptions).map(
                (taskOption) {
                  return TaskOptionSelector(taskOption);
                },
              ).toList(),
            ),
          ),
        ),
        TextFieldWidget("Backup Directory", controller: backupDirController),
        SizedBox(
          width: 500,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: (excludePaths).map(
                (path) {
                  return Container(
                    margin: const EdgeInsets.only(right: 5),
                    child: RawChip(
                      label: Text(path),
                      deleteIcon: const Icon(Icons.close),
                      onDeleted: () {
                        setState(
                          () {
                            excludePaths.remove(path);
                          },
                        );
                      },
                    ),
                  );
                },
              ).toList(),
            ),
          ),
        ),
        TextFieldWidget(
          "Exclude Directories",
          controller: excludeDirController,
          onSubmitted: (text) {
            setState(() {
              excludePaths.add(text);
              excludeDirController.text = "";
            });
          },
        ),
      ],
    );
  }
}
