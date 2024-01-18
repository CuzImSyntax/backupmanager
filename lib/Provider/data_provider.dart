import 'package:backupmanager/Database/Models/preset_model.dart';
import 'package:backupmanager/Database/Models/routine_backups_model.dart';
import 'package:backupmanager/Database/Models/task_backup_model.dart';
import 'package:backupmanager/Tasks/task_executor.dart';
import 'package:flutter/foundation.dart';

import 'package:backupmanager/Database/database_manager.dart';
import 'package:backupmanager/Database/Models/routine_model.dart';
import 'package:backupmanager/Database/Models/task_model.dart';

/// Interface for interaction with the database.
///
/// This also caches the items from the db, to reduce calls to the DB.
/// The [DataProvider] should be used for any interaction with the DB to also update the cache.
class DataProvider with ChangeNotifier, DiagnosticableTreeMixin {
  final DatabaseManager db = DatabaseManager();

  late List<Routine> routines;
  late List<Task> tasks;
  late List<Preset> presets;
  late List<RoutineBackup> routineBackups;
  late List<TaskBackup> taskBackups;
  List<TaskExecutor> taskExecutors = [];

  /// Initialize the cache of the dataProvider.
  ///
  /// This should only be called once at the startup of the application.
  /// We also need to call this after deleting a Routine / Task
  /// Otherwise when something gets deleted through FOREIGN KEYs, they are still present in the Data Provider.
  Future<bool> init() async {
    routines = await db.getRoutines();
    tasks = await db.getTasks();
    presets = await db.getPresets();
    routineBackups = await db.getRoutineBackups();
    taskBackups = await db.getTaskBackups();

    // Cache the taskExecutors
    initTaskExecutors();

    notifyListeners();

    return true;
  }

  /// Inserts a given [routine] to the database.
  Future<void> insertRoutine(Routine routine) async {
    Routine newRoutine = await db.insertRoutine(routine);
    routines.add(newRoutine);
    notifyListeners();
  }

  /// Deletes a given [routine] from the database.
  Future<void> deleteRoutine(Routine routine) async {
    await db.deleteRoutine(routine);
    routines.remove(routine);
    await init();
    notifyListeners();
  }

  /// Deletes a given [routine] from the database.
  Future<Task> insertTask(Task task) async {
    Task newTask = await db.insertTask(task);
    tasks.add(newTask);
    notifyListeners();
    return newTask;
  }

  /// Deletes a given [task] from the database.
  Future<void> deleteTask(Task task) async {
    await db.deleteTask(task);
    tasks.remove(task);
    deleteTaskExecutor(task);
    await init();
    notifyListeners();
  }

  /// Inserts a given [routineBackup] to the database.
  Future<RoutineBackup> insertRoutineBackup(RoutineBackup routineBackup) async {
    RoutineBackup newRoutineBackup =
        await db.insertRoutineBackup(routineBackup);
    routineBackups.add(newRoutineBackup);
    notifyListeners();
    return newRoutineBackup;
  }

  /// Update the given [routineBackup] in the database.
  Future<void> updateRoutineBackup(RoutineBackup routineBackup) async {
    await db.updateRoutineBackup(routineBackup);
    notifyListeners();
  }

  /// Inserts a given [taskBackup] to the database.
  Future<bool> insertTaskBackup(TaskBackup taskBackup) async {
    TaskBackup newTaskBackup = await db.insertTaskBackup(taskBackup);
    taskBackups.add(newTaskBackup);
    notifyListeners();
    return true;
  }

  /// Returns the latest successful routine backup for a given [routine].
  RoutineBackup? getLatestRoutineBackup(Routine routine) {
    List<RoutineBackup> backupsByRoutine = routineBackups
        .where((element) => element.routineId == routine.id! && element.success)
        .toList();

    backupsByRoutine.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    return backupsByRoutine.isEmpty ? null : backupsByRoutine.last;
  }

  /// Returns the latest successful task backup for a given [routine].
  TaskBackup? getLatestTaskBackup(Task task) {
    List<TaskBackup> backupsByTask = taskBackups
        .where((element) => element.taskId == task.id! && element.success)
        .toList();

    backupsByTask.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    return backupsByTask.isEmpty ? null : backupsByTask.last;
  }

  /// Replaces the currently saved [Preset] with the given [preset].
  Future<void> insertPreset(Preset preset) async {
    if (presets.isNotEmpty) {
      await deletePreset(presets.first);
    }
    Preset newPreset = await db.insertPreset(preset);

    presets.add(newPreset);
    notifyListeners();
  }

  /// Deletes a given [preset] from the database.
  Future<void> deletePreset(Preset preset) async {
    await db.deletePreset(preset);
    presets.remove(preset);
    notifyListeners();
  }

  /// Caches a [TaskExecutor] for every [Task] present in cache.
  ///
  /// We are caching all taskExecutors as we lose state after finishing a Backup, as the TaskCard is rebuilding.
  /// Therefore the indicators of the Backups aren't showing after a Backup.
  /// We now set an indicator after popping to refresh the taskExecutor, when openin the view again.
  void initTaskExecutors() {
    for (Task task in tasks) {
      taskExecutors.add(TaskExecutor(task));
    }
  }

  /// Returns the [TaskExecutor] of the given [task].
  TaskExecutor getTaskExecutor(Task task) {
    return taskExecutors.firstWhere((element) => element.task.id == task.id);
  }

  /// Adds a [TaskExecutor] to the cache for the given [task].
  void addTaskExecutor(Task task) {
    taskExecutors.add(TaskExecutor(task));
    notifyListeners();
  }

  /// Deletes the [TaskExecutor] for the given [task].
  void deleteTaskExecutor(Task task) {
    taskExecutors.removeWhere((element) => element.task.id == task.id);
    notifyListeners();
  }
}
