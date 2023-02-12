import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:backupmanager/Database/Models/routine_model.dart';
import 'package:backupmanager/Provider/data_provider.dart';

class RoutineCard extends StatelessWidget {
  final Routine routine;

  const RoutineCard(this.routine, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (() {
        Navigator.pushNamed(context, "/routine", arguments: routine);
      }),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: Dismissible(
          onDismissed: ((direction) {
            context.read<DataProvider>().deleteRoutine(routine);
          }),
          direction: DismissDirection.endToStart,
          key: ValueKey(routine),
          background: Container(
            padding: const EdgeInsets.only(right: 40),
            alignment: Alignment.centerRight,
            color: Colors.red,
            child: const Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
          child: Container(
            color: const Color(0xFF52796F),
            child: Center(
              child: Text(routine.title),
            ),
          ),
        ),
      ),
    );
  }
}
