import 'dart:io';
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:questkeeper/shared/utils/home_widget/home_widget_mobile.dart';
import 'package:questkeeper/shared/utils/undo_manager_mixin.dart';
import 'package:questkeeper/task_list/models/tasks_model.dart';
import 'package:questkeeper/task_list/repositories/tasks_repository.dart';
import 'package:questkeeper/shared/notifications/local_notification_service.dart';

part 'tasks_provider.g.dart';

@riverpod
class TasksManager extends _$TasksManager with UndoManagerMixin<List<Tasks>> {
  final TasksRepository _repository;
  final LocalNotificationService _notificationService =
      LocalNotificationService();

  TasksManager() : _repository = TasksRepository();

  @override
  FutureOr<List<Tasks>> build() async {
    // Fetch tasks first
    final tasks = await fetchTasks();

    // Handle notifications in a microtask to avoid blocking UI
    if (!_notificationService.isInitialized) {
      unawaited(_initializeNotifications());
    }

    updateHomeWidget(tasks);

    return tasks;
  }

  void updateHomeWidget(List<Tasks> tasks) {
    try {
      if (!kIsWeb && (Platform.isIOS || Platform.isAndroid)) {
        HomeWidgetMobile().updateHomeWidget(tasks);
      }
    } catch (e) {
      debugPrint("Platform implementation error: $e");
    }
  }

  Future<List<Tasks>> fetchTasks() async {
    try {
      return await _repository.getTasks();
    } catch (error) {
      state = AsyncValue.error(error, StackTrace.current);
      throw Exception("Failed to fetch tasks: $error");
    }
  }

  Future<int?> createTask(Tasks task) async {
    try {
      final createdTask = await _repository.createTask(task);
      state = AsyncValue.data([...state.value ?? [], createdTask.data]);

      // Sync notifications after creating a task
      await _syncNotificationsIfInitialized();
      updateHomeWidget(state.value ?? []);

      return createdTask.data.id;
    } catch (error) {
      // Handle error
      return null;
    }
  }

  Future<void> toggleComplete(Tasks task) async {
    final oldState = state.value ?? [];
    final updatedTask = task.copyWith(completed: !task.completed);
    final newState =
        oldState.map((t) => t.id == task.id ? updatedTask : t).toList();

    performActionWithUndo(
      UndoAction(
        previousState: oldState,
        newState: newState,
        repositoryAction: () async {
          await _repository.toggleComplete(task);
          // Sync notifications after toggling complete
          await _syncNotificationsIfInitialized();
        },
        successMessage: "Task updated",
        timing: ActionTiming.afterUndoPeriod,
      ),
    );
  }

  Future<void> toggleStar(Tasks task) async {
    final updatedTask = task.copyWith(starred: !task.starred);
    _updateTaskInPlace(updatedTask, () => _repository.toggleStar(task));
  }

  Future<void> updateTask(Tasks task) async {
    _updateTaskInPlace(task, () => _repository.updateTask(task));
  }

  void _updateTaskInPlace(
      Tasks updatedTask, Future<void> Function() repositoryAction) async {
    final oldState = state.value ?? [];
    final taskIndex = oldState.indexWhere((t) => t.id == updatedTask.id);
    if (taskIndex == -1) return;

    final newState = List<Tasks>.from(oldState);
    newState[taskIndex] = updatedTask;

    // Update state immediately but maintain list order
    state = AsyncValue.data(newState);

    try {
      await repositoryAction();
      // Sync notifications after updating a task
      await _syncNotificationsIfInitialized();
      updateHomeWidget(newState);
    } catch (error) {
      // Revert state on error
      state = AsyncValue.data(oldState);
    }
  }

  Future<void> deleteTask(Tasks task) async {
    final oldState = state.value ?? [];
    final newState = oldState.where((t) => t.id != task.id).toList();

    try {
      performActionWithUndo(UndoAction(
        previousState: oldState,
        newState: newState,
        repositoryAction: () async {
          await _repository.deleteTask(task);
          // Sync notifications after deleting a task
          await _syncNotificationsIfInitialized();
          updateHomeWidget(newState);
        },
        successMessage: "Task deleted successfully",
      ));
    } catch (error) {
      // State will be handled by UndoManagerMixin
    }
  }

  Future<void> _initializeNotifications() async {
    final initSuccessful = await _notificationService.initialize();
    if (initSuccessful) {
      await _notificationService.syncNotificationsFromSchedule();
    }
  }

  Future<void> _syncNotificationsIfInitialized() async {
    if (_notificationService.isInitialized) {
      // Use microtask to avoid blocking UI during sync
      unawaited(Future.microtask(() async {
        // Await so that supabase has time to update the scheduled_at
        await Future.delayed(const Duration(seconds: 3));
        await _notificationService.syncNotificationsFromSchedule();
      }));
    }
  }

  void refreshHomeWidget() {
    final currentTasks = state.value ?? [];
    updateHomeWidget(currentTasks);
  }
}
