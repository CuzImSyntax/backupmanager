import 'package:flutter/material.dart';

import 'package:backupmanager/Database/Models/task_model.dart';
import 'package:backupmanager/Tasks/task_card.dart';
import 'package:backupmanager/Tasks/task_executor.dart';

class TaskView extends StatelessWidget {
  final Task task;
  late TaskExecutor taskExecutor;

  TaskView(this.task, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    taskExecutor = TaskExecutor(task.command);
    return StreamBuilder(
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
    );
  }

  Widget taskRow(Widget statusWidget, {String? text}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        taskIcon(statusWidget),
        TaskCard(
          task,
          taskExecutor: taskExecutor,
          text: text,
        ),
        // taskCard(text: text),
      ],
    );
  }

  Widget taskIcon(Widget statusWidget) {
    return Container(
      margin: const EdgeInsets.only(top: 5),
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

  Widget taskCard({String? text}) {
    bool _first = true;
    return Expanded(
      child: GestureDetector(
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          color: const Color(0xFF52796F),
          child: Column(
            children: [
              ListTile(
                title: Text(task.name),
                subtitle: SelectableText(
                  task.command,
                  maxLines: 1,
                ),
                trailing: GestureDetector(
                  onTap: () async {
                    await taskExecutor.run();
                  },
                  child: const Icon(
                    Icons.play_arrow,
                    color: Colors.greenAccent,
                  ),
                ),
              ),
              text != null
                  ? Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFCAD2C5).withOpacity(.3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      margin: const EdgeInsets.only(
                          left: 20, right: 20, bottom: 20),
                      padding: const EdgeInsets.all(5),
                      width: double.infinity,
                      height: 100,
                      child: SelectableText(text),
                    )
                  : const SizedBox.shrink()
            ],
          ),
          // child: AnimatedCrossFade(
          //   duration: const Duration(milliseconds: 200),
          //   firstChild: taskCardContainer(),
          //   secondChild: removeContainer(),
          //   crossFadeState:
          //       _first ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          // ),
        ),
      ),
    );
  }
}
