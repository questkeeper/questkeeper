import 'dart:io';

import 'package:assigngo_rewrite/task_list/models/tasks_model.dart';
import 'package:assigngo_rewrite/task_list/repositories/tasks_repository.dart';
import 'package:assigngo_rewrite/shared/models/return_model/return_model.dart';
import 'package:assigngo_rewrite/shared/utils/home_widget/home_widget_mobile.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tasks_provider.g.dart';

@riverpod
class TasksManager extends _$TasksManager {
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
      final tasks = await _repository.getTasks();
      updateHomeWidget(tasks);
      return tasks;
    } catch (error) {
      state = AsyncValue.error(error, StackTrace.current);
      throw Exception("Failed to fetch tasks: $error");
    }
  }

  Future<ReturnModel> createTask(Tasks task) async {
    try {
      final data = await _repository.createTask(task);
      state.value?.add(task);
      state = AsyncValue.data(state.value ?? []);
      return data;
    } catch (error) {
      return ReturnModel(
        success: false,
        message: "Error creating task: $error",
        error: error.toString(),
      );
    }
  }

  Future<void> toggleStar(Tasks task) async {
    _updateTask(
      task.id!,
      (t) => t.copyWith(starred: !t.starred),
      () => _repository.toggleStar(task),
    );
  }

  Future<void> toggleComplete(Tasks task) async {
    _updateTask(
      task.id!,
      (t) => t.copyWith(completed: !t.completed),
      () => _repository.toggleComplete(task),
    );
  }

  Future<void> updateTask(Tasks task) async {
    _updateTask(
      task.id!,
      (_) => task,
      () => _repository.updateTask(task),
    );
  }

  Future<void> deleteTask(Tasks task) async {
    try {
      await _repository.deleteTask(task);
      state = AsyncValue.data(
        (state.value ?? []).where((a) => a.id != task.id).toList(),
      );
    } catch (error) {
      debugPrint("Error deleting task: $error");
    }
  }

  void _updateTask(
    int taskId,
    Tasks Function(Tasks) updateFn,
    Future<void> Function() repositoryAction,
  ) async {
    final oldState = state.value ?? [];
    final taskIndex = oldState.indexWhere((t) => t.id == taskId);
    if (taskIndex == -1) return;

    final updatedTask = updateFn(oldState[taskIndex]);
    final newState = List<Tasks>.from(oldState);
    newState[taskIndex] = updatedTask;

    state = AsyncValue.data(newState);

    try {
      await repositoryAction();
    } catch (error) {
      debugPrint("Error updating task: $error");
      state = AsyncValue.data(oldState); // Revert on error
    }
  }
}
