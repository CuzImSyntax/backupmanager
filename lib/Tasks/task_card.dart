import 'package:backupmanager/button_provider.dart';
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
      child: Container(
        margin: const EdgeInsets.only(left: 5),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Dismissible(
            onDismissed: ((direction) {
              context.read<DataProvider>().deleteTask(task);
            }),
            direction: DismissDirection.endToStart,
            key: ValueKey(task),
            background: Container(
              padding: const EdgeInsets.only(right: 20),
              alignment: Alignment.centerRight,
              color: Colors.red,
              child: const Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
            child: Container(
              color: const Color(0xFF52796F),
              child: taskCardContainer(context),
            ),
          ),
        ),
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
          leading: GestureDetector(
            onTap: () async {
              await taskExecutor.run();
            },
            child: const Icon(
              Icons.play_arrow,
              color: Colors.greenAccent,
            ),
          ),
          trailing: Stack(
            alignment: Alignment.topCenter,
            children: [
              Text(
                "Dry run",
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Container(
                padding: const EdgeInsets.only(top: 5),
                child: Switch(
                  value: context
                      .watch<ButtonProvider>()
                      .getDryRunMapItem(task.id!),
                  onChanged: (value) {
                    taskExecutor.dryRun = value;
                    context
                        .read<ButtonProvider>()
                        .changeDryRunMap(task.id!, value);
                  },
                ),
              ),
            ],
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
