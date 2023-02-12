import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:backupmanager/templates/default_view.dart';
import 'package:backupmanager/Database/Models/routine_model.dart';
import 'package:backupmanager/Provider/data_provider.dart';
import 'package:backupmanager/Routines/routine_card.dart';

class RoutineGridView extends StatelessWidget {
  const RoutineGridView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<RoutineCard> children = [];
    List<Routine> routines = context.watch<DataProvider>().routines;
    for (Routine routine in routines) {
      children.add(
        RoutineCard(routine),
      );
    }

    return DefaultContainerWrapper(
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF52796F),
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, "/routine/create");
        },
      ),
      body: Center(
        child: SizedBox(
          width: 500,
          height: double.infinity,
          child: GridView.count(
            primary: false,
            padding: const EdgeInsets.all(20),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            crossAxisCount: 2,
            children: children,
          ),
        ),
      ),
    );
  }
}
