import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:backupmanager/Database/Models/routine_model.dart';
import 'package:backupmanager/data_provider.dart';

class RoutineCard extends StatefulWidget {
  final Routine routine;
  const RoutineCard(
    this.routine, {
    Key? key,
  }) : super(key: key);

  @override
  _RoutineCardState createState() => _RoutineCardState();
}

class _RoutineCardState extends State<RoutineCard> {
  Routine? routine;
  bool _first = true;

  @override
  void initState() {
    routine = widget.routine;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (() {
        if (_first) {
          Navigator.pushNamed(context, "/routine", arguments: routine);
        } else {
          context.read<DataProvider>().deleteRoutine(routine!);
        }
      }),
      onHorizontalDragEnd: ((DragEndDetails details) {
        if (details.primaryVelocity! < 0) {
          setState(() {
            _first = !_first;
          });
        }
      }),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
        ),
        color: const Color(0xFF52796F),
        child: Center(
          child: AnimatedCrossFade(
            duration: const Duration(milliseconds: 200),
            firstChild: Text(routine!.title),
            secondChild: const Icon(
              Icons.delete,
              color: Colors.red,
              size: 40,
            ),
            crossFadeState:
                _first ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          ),
        ),
      ),
    );
  }
}
