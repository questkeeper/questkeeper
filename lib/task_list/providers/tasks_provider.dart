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

  final _allTasks = <Tasks>[];

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

      _allTasks.clear();
      _allTasks.addAll(tasks);
      updateHomeWidget(tasks);

      return tasks;
    } catch (error) {
      state = AsyncValue.error(error, StackTrace.current);
      debugPrint("Error fetching tasks: $error");
      throw Exception("Failed to fetch tasks");
    }
  }

  Future<ReturnModel> createTask(Tasks task) async {
    try {
      final data = await _repository.createTask(task);
      await fetchTasks();

      return data;
    } catch (error) {
      debugPrint("Error creating task: $error");

      return ReturnModel(
        success: false,
        message: "Error creating task: $error",
        error: error.toString(),
      );
    }
  }

  Future<void> toggleStar(Tasks task) async {
    try {
      state = AsyncValue.data(
        state.value!.map((a) {
          if (a.id == task.id) {
            return a.copyWith(starred: !a.starred);
          }
          return a;
        }).toList(),
      );
      await _repository.toggleStar(task);
    } catch (error) {
      state = AsyncValue.data(
        state.value!.map((a) {
          if (a.id == task.id) {
            return a.copyWith(starred: !a.starred);
          }
          return a;
        }).toList(),
      );
      debugPrint("Error starring task: $error");
    }
  }

  Future<void> toggleComplete(Tasks task) async {
    try {
      await _repository.toggleComplete(task);

      state = AsyncValue.data(
        state.value!.map((a) {
          if (a.id == task.id) {
            return a.copyWith(completed: !a.completed);
          }
          return a;
        }).toList(),
      );
    } catch (error) {
      debugPrint("Error completing task: $error");
    }
  }

  Future<void> getTask(int id) async {
    try {
      await _repository.getTask(id);
    } catch (error) {
      debugPrint("Error getting task: $error");
    }
  }

  Future<void> deleteTask(Tasks task) async {
    try {
      await _repository.deleteTask(task);

      state = AsyncValue.data(
        state.value!.where((a) => a.id != task.id).toList(),
      );
    } catch (error) {
      debugPrint("Error deleting task: $error");
    }
  }

  Future<void> updateTask(Tasks task) async {
    try {
      await _repository.updateTask(task);
      state = AsyncValue.data(
        state.value!.map((a) {
          if (a.id == task.id) {
            return task;
          }
          return a;
        }).toList(),
      );
    } catch (error) {
      debugPrint("Error updating task: $error");
    }
  }

  Future<void> getBySpaceId(int id) async {
    try {
      state = AsyncValue.data(
        _allTasks.where((element) => element.spaceId == id).toList(),
      );
    } catch (error) {
      debugPrint("Error fetching tasks: $error");
    }
  }
}
