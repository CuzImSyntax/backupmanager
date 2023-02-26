import 'package:backupmanager/Database/Models/preset_model.dart';
import 'package:flutter/foundation.dart';

import 'package:backupmanager/Database/database_manager.dart';
import 'package:backupmanager/Database/Models/routine_model.dart';
import 'package:backupmanager/Database/Models/task_model.dart';

class DataProvider with ChangeNotifier, DiagnosticableTreeMixin {
  final DatabaseManager db = DatabaseManager();
  late List<Routine> routines;
  bool _initialsfsd = false;
  late List<Task> tasks;
  late List<Preset> presets;

  Future<bool> init() async {
    if (!_initialsfsd) {
      routines = await db.getRoutines();
      tasks = await db.getTasks();
      presets = await db.getPresets();
      _initialsfsd = true;
      notifyListeners();
    }
    return true;
  }

  Future<void> insertRoutine(Routine routine) async {
    Routine newRoutine = await db.insertRoutine(routine);
    routines.add(newRoutine);
    notifyListeners();
  }

  Future<void> deleteRoutine(Routine routine) async {
    await db.deleteRoutine(routine);
    routines.remove(routine);
    notifyListeners();
  }

  Future<void> insertTask(Task task) async {
    Task newTask = await db.insertTask(task);
    tasks.add(newTask);
    notifyListeners();
  }

  Future<void> deleteTask(Task task) async {
    await db.deleteTask(task);
    tasks.remove(task);
    notifyListeners();
  }

  Future<void> insertPreset(Preset preset) async {
    if (presets.isNotEmpty) {
      await deletePreset(presets.first);
    }
    Preset newPreset = await db.insertPreset(preset);

    presets.add(newPreset);
    notifyListeners();
  }

  Future<void> deletePreset(Preset preset) async {
    await db.deletePreset(preset);
    presets.remove(preset);
    notifyListeners();
  }
}
