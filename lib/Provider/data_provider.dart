import 'package:backupmanager/Database/Models/preset_model.dart';
import 'package:backupmanager/Database/Models/routine_backups_model.dart';
import 'package:backupmanager/Database/Models/task_backup_model.dart';
import 'package:backupmanager/Tasks/task_executor.dart';
import 'package:flutter/foundation.dart';

import 'package:backupmanager/Database/database_manager.dart';
import 'package:backupmanager/Database/Models/routine_model.dart';
import 'package:backupmanager/Database/Models/task_model.dart';

class DataProvider with ChangeNotifier, DiagnosticableTreeMixin {
  bool _intitialized = false;
  final DatabaseManager db = DatabaseManager();

  late List<Routine> routines;
  late List<Task> tasks;
  late List<Preset> presets;
  late List<RoutineBackup> routineBackups;
  late List<TaskBackup> taskBackups;
  List<TaskExecutor> taskExecutors = [];

  Future<bool> init() async {
    if (!_intitialized) {
      routines = await db.getRoutines();
      tasks = await db.getTasks();
      presets = await db.getPresets();
      routineBackups = await db.getRoutineBackups();
      taskBackups = await db.getTaskBackups();

      // Cache the taskExecutors
      initTaskExecutors();

      _intitialized = true;
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

  Future<RoutineBackup> insertRoutineBackup(RoutineBackup routineBackup) async {
    RoutineBackup newRoutineBackup =
        await db.insertRoutineBackup(routineBackup);
    routineBackups.add(newRoutineBackup);
    notifyListeners();
    return newRoutineBackup;
  }

  Future<bool> insertTaskBackup(TaskBackup taskBackup) async {
    TaskBackup newTaskBackup = await db.insertTaskBackup(taskBackup);
    taskBackups.add(newTaskBackup);
    notifyListeners();
    return true;
  }

  RoutineBackup? getLatestRoutineBackup(Routine routine) {
    List<RoutineBackup> backupsByRoutine = routineBackups
        .where((element) => element.routineId == routine.id!)
        .toList();

    backupsByRoutine.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    return backupsByRoutine.isEmpty ? null : backupsByRoutine.last;
  }

  TaskBackup? getLatestTaskBackup(Task task) {
    List<TaskBackup> backupsByTask = taskBackups
        .where((element) => element.taskId == task.id! && element.success)
        .toList();

    backupsByTask.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    return backupsByTask.isEmpty ? null : backupsByTask.last;
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

  // We are caching all taskExecutors as we lose state after finishing a Backup, as the TaskCard is rebuilding.
  // Therefore the indicators of the Backups aren't showing after a Backup.
  // We now set an indicator after popping to refresh the taskExecutor, when openin the view again.
  void initTaskExecutors() {
    for (Task task in tasks) {
      taskExecutors.add(TaskExecutor(task));
    }
  }

  TaskExecutor getTaskExecutor(Task task) {
    return taskExecutors.firstWhere((element) => element.task.id == task.id);
  }

  void replaceTaskExecutor(TaskExecutor _taskExecutor) {
    taskExecutors
        .removeWhere((element) => element.task.id == _taskExecutor.task.id);
  }
}
