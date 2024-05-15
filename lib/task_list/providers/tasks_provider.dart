import 'package:assigngo_rewrite/task_list/models/tasks_model.dart';
import 'package:assigngo_rewrite/task_list/repositories/assignments_repository.dart';
import 'package:assigngo_rewrite/shared/models/return_model/return_model.dart';
// import 'package:assigngo_rewrite/shared/utils/home_widget/home_widget_mobile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final tasksProvider = StateNotifierProvider<TasksNotifier, List<Tasks>>(
  (ref) {
    return TasksNotifier([]);
  },
);

class TasksNotifier extends StateNotifier<List<Tasks>> {
  final TasksRepository _repository = TasksRepository();
  TasksNotifier(super.state);

  // void updateHomeWidget(List<task> state) {
  //   try {
  //     if (Platform.isIOS || Platform.isAndroid) {
  //       HomeWidgetMobile().updateHomeWidget(state);
  //     }
  //   } catch (e) {
  //     debugPrint("Platform implementation error: $e");
  //   }
  // }

  Future<void> fetchTasks() async {
    try {
      final tasks = await _repository.getTasks();

      state = tasks;
      // updateHomeWidget(tasks);
    } catch (error) {
      debugPrint("Error fetching tasks: $error");
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
      state = state.map((a) {
        if (a.id == task.id) {
          return a.copyWith(starred: !a.starred);
        }
        return a;
      }).toList();
      await _repository.toggleStar(task);
    } catch (error) {
      state = state.map((a) {
        if (a.id == task.id) {
          return a.copyWith(starred: !a.starred);
        }
        return a;
      }).toList();
      debugPrint("Error starring task: $error");
    }
  }

  Future<void> toggleComplete(Tasks task) async {
    try {
      await _repository.toggleComplete(task);

      state = state.map((a) {
        if (a.id == task.id) {
          return a.copyWith(completed: !a.completed);
        }
        return a;
      }).toList();
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

      state = state.where((a) => a.id != task.id).toList();
    } catch (error) {
      debugPrint("Error deleting task: $error");
    }
  }

  Future<void> updateTask(Tasks task) async {
    try {
      await _repository.updateTask(task);
      state = state.map((a) {
        if (a.id == task.id) {
          return task;
        }
        return a;
      }).toList();
    } catch (error) {
      debugPrint("Error updating task: $error");
    }
  }

  Future<void> createSubtask(Tasks task) async {
    try {
      await _repository.createSubtask(task);
    } catch (error) {
      debugPrint("Error creating subtask: $error");
    }
  }
}
