import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:backupmanager/Database/Models/task_model.dart';
import 'package:backupmanager/Tasks/task_executor.dart';
import 'package:backupmanager/data_provider.dart';

class TaskCard extends StatelessWidget {
  final String? text;
  final Task task;
  final TaskExecutor taskExecutor;

  const TaskCard(
    this.task, {
    required this.taskExecutor,
    this.text,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        color: const Color(0xFF52796F),
        child: taskCardContainer(context),
      ),
    );
  }

  Widget taskCardContainer(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(task.name),
          subtitle: SelectableText(
            task.command,
            maxLines: 1,
          ),
          trailing: SizedBox(
            width: 24 * 2,
            height: 24,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Press and hold down to delete."),
                    ),
                  ),
                  onLongPress: () async {
                    await context.read<DataProvider>().deleteTask(task);
                  },
                  child: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    await taskExecutor.run();
                  },
                  child: const Icon(
                    Icons.play_arrow,
                    color: Colors.greenAccent,
                  ),
                ),
              ],
            ),
          ),
        ),
        text != null
            ? Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFCAD2C5).withOpacity(.3),
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                padding: const EdgeInsets.all(5),
                width: double.infinity,
                height: 100,
                child: SelectableText(text!),
              )
            : const SizedBox.shrink()
      ],
    );
  }

  Widget removeContainer() {
    return const Center(
      child: SizedBox(
        height: 64,
        child: Icon(
          Icons.delete,
          color: Colors.red,
          size: 40,
        ),
      ),
    );
  }
}
