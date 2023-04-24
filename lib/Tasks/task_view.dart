import 'package:flutter/material.dart';

import 'package:backupmanager/Database/Models/task_model.dart';
import 'package:backupmanager/Tasks/task_card.dart';
import 'package:backupmanager/Tasks/task_executor.dart';

class TaskView extends StatelessWidget {
  final Task task;
  final TaskExecutor taskExecutor;

  const TaskView(
    this.task, {
    required this.taskExecutor,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        taskExecutor.rebuildNeeded = true;
        return Future.value(true);
      },
      child: StreamBuilder(
        stream: taskExecutor.stream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          Widget statusWidget = const Icon(
            Icons.schedule,
            color: Colors.white,
          );
          if (snapshot.connectionState == ConnectionState.active) {
            statusWidget = const CircularProgressIndicator(
              color: Colors.white,
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            statusWidget = const Icon(
              Icons.done,
              color: Colors.greenAccent,
            );
          }
          if (snapshot.hasError) {
            statusWidget = const Icon(
              Icons.close,
              color: Colors.red,
            );
          }
          if (snapshot.hasError) {
            return taskRow(statusWidget, text: snapshot.error.toString());
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return taskRow(statusWidget, text: snapshot.data);
          }
          return taskRow(statusWidget);
        },
      ),
    );
  }

  Widget taskRow(Widget statusWidget, {String? text}) {
    return Container(
      margin: const EdgeInsets.only(top: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          taskIcon(statusWidget),
          TaskCard(
            task,
            taskExecutor: taskExecutor,
            text: text,
          ),
        ],
      ),
    );
  }

  Widget taskIcon(Widget statusWidget) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: const Color(0xFF52796F),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(10),
      child: statusWidget,
    );
  }
}
