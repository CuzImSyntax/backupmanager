import 'package:backupmanager/Tasks/TaskOptions/task_options.dart';
import 'package:flutter/material.dart';

const double taskOptionSelectorWidth = 140;
const double taskOptionSelectorHeight = 32;

class TaskOptionSelector extends StatefulWidget {
  final TaskOption taskOption;
  const TaskOptionSelector(
    this.taskOption, {
    Key? key,
  }) : super(key: key);

  @override
  _TaskOptionSelectorState createState() => _TaskOptionSelectorState();
}

class _TaskOptionSelectorState extends State<TaskOptionSelector> {
  late TaskOption taskOption;

  @override
  void initState() {
    taskOption = widget.taskOption;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: taskOptionSelectorWidth,
      height: taskOptionSelectorHeight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Checkbox(
            value: taskOption.isSelected,
            onChanged: (value) {
              setState(() {
                taskOption.isSelected = !taskOption.isSelected;
              });
            },
          ),
          Tooltip(
            message: taskOption.description,
            child: Text(taskOption.name),
            waitDuration: const Duration(milliseconds: 300),
          ),
        ],
      ),
    );
  }
}
