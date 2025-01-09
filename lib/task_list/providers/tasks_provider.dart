import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:questkeeper/shared/utils/undo_manager_mixin.dart';
import 'package:questkeeper/shared/widgets/snackbar.dart';
import 'package:questkeeper/task_list/models/tasks_model.dart';
import 'package:questkeeper/task_list/repositories/tasks_repository.dart';
import 'package:questkeeper/shared/utils/home_widget/home_widget_mobile.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:toastification/toastification.dart';

part 'tasks_provider.g.dart';

@riverpod
class TasksManager extends _$TasksManager with UndoManagerMixin<List<Tasks>> {
  final TasksRepository _repository;

  TasksManager() : _repository = TasksRepository();

  @override
  FutureOr<List<Tasks>> build() {
    return fetchTasks();
  }

  void updateHomeWidget(List<Tasks> tasks) {
    try {
      if (!kIsWeb && (Platform.isIOS || Platform.isAndroid)) {
        HomeWidgetMobile().updateHomeWidget(
          tasks,
        );
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

      return createdTask.data.id;
    } catch (error) {
      // Handle error
      return null;
    }
  }

  Future<void> toggleComplete(Tasks task) async {
    _repository.toggleComplete(task);
    // Remove it from the list
    state = AsyncValue.data(
      (state.value ?? []).where((a) => a.id != task.id).toList(),
    );
    ToastificationItem? toastItem;
    void undoCallback() {
      // Undo the removal
      state = AsyncValue.data([...state.value ?? [], task]);
      _repository.toggleComplete(task);
      if (toastItem != null) {
        SnackbarService.dismissToast(toastItem);
      }

      SnackbarService.showSuccessSnackbar(
        "Task updated",
      );
    }

    toastItem = SnackbarService.showSuccessSnackbar(
      "Task completed successfully",
      callback: undoCallback,
      callbackIcon: const Icon(LucideIcons.undo_2),
      callbackText: "Tap to undo",
    );
  }

  Future<void> toggleStar(Tasks task) async {
    final updatedTask = task.copyWith(starred: !task.starred);
    _updateTask(updatedTask, () => _repository.toggleStar(task));
  }

  Future<void> updateTask(Tasks task) async {
    _updateTask(task, () => _repository.updateTask(task));
  }

  void _updateTask(
      Tasks updatedTask, Future<void> Function() repositoryAction) async {
    final oldState = state.value ?? [];
    final taskIndex = oldState.indexWhere((t) => t.id == updatedTask.id);
    if (taskIndex == -1) return;

    final newState = List<Tasks>.from(oldState);
    newState[taskIndex] = updatedTask;

    state = AsyncValue.data(newState);

    try {
      await repositoryAction();
    } catch (error) {
      // Handle error and possibly revert state
    }
  }

  Future<void> deleteTask(Tasks task) async {
    try {
      performActionWithUndo(UndoAction(
        previousState: state.value ?? [],
        newState: (state.value ?? []).where((a) => a.id != task.id).toList(),
        repositoryAction: () => _repository.deleteTask(task),
        successMessage: "Task deleted successfully",
      ));
    } catch (error) {
      // Handle error
    }
  }
}
