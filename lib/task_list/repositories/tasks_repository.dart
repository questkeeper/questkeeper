import 'dart:convert';

import 'package:questkeeper/task_list/models/tasks_model.dart';
import 'package:questkeeper/shared/models/return_model/return_model.dart';
import 'package:questkeeper/shared/utils/http_service.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TasksRepository {
  TasksRepository();

  final supabase = Supabase.instance.client;
  final HttpService _httpService = HttpService();

  Future<List<Tasks>> getTasks({bool isCompleted = false}) async {
    try {
      final response = await _httpService.dio.get(
        '/core/tasks',
        queryParameters: {'isCompleted': isCompleted},
      );

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        final tasks = data.map((json) => Tasks.fromJson(json)).toList();

        return tasks;
      } else {
        throw Exception('Failed to load tasks: ${response.data}');
      }
    } catch (error) {
      Sentry.captureException(error);
      return [];
    }
  }

  Future<Tasks> getTask(int id) async {
    try {
      final task = await _httpService.dio.get(
        '/core/tasks/$id',
      );

      return Tasks.fromJson(task.data);
    } catch (error) {
      Sentry.captureException(error);
      return Tasks(
        id: id,
        title: "Error",
        description: "Error getting task",
        dueDate: DateTime.now(),
      );
    }
  }

  Future<ReturnModel> createTask(Tasks task) async {
    final Map<String, dynamic> jsonTask = task.toJson();
    jsonTask.remove("id");
    jsonTask.remove("createdAt");
    jsonTask.remove("updatedAt");
    jsonTask["userId"] = Supabase.instance.client.auth.currentUser!.id;

    jsonTask["dueDate"] =
        DateTime.parse(jsonTask["dueDate"]).toUtc().toIso8601String();

    try {
      final newTask = await _httpService.dio.post(
        '/core/tasks',
        data: json.encode(jsonTask),
      );

      return ReturnModel(
          data: Tasks.fromJson(newTask.data),
          message: "Task created successfully",
          success: true);
    } catch (error) {
      Sentry.captureException(error);
      return ReturnModel(
          message: "Error creating task item",
          success: false,
          error: error.toString());
    }
  }

  Future<ReturnModel> toggleStar(Tasks task) async {
    try {
      final response = await _httpService.dio.patch(
        '/core/tasks/${task.id}/toggleStar',
      );

      if (response.statusCode == 200) {
        return const ReturnModel(
            message: "Task starred successfully", success: true);
      } else {
        throw Exception('Failed to star task');
      }
    } catch (error) {
      return ReturnModel(
          message: "Error starring task item",
          success: false,
          error: error.toString());
    }
  }

  Future<ReturnModel> toggleComplete(Tasks task) async {
    try {
      final response = await _httpService.dio.patch(
        '/core/tasks/${task.id}/toggleComplete',
      );

      if (response.statusCode == 200) {
        return const ReturnModel(
            message: "Task completed successfully", success: true);
      } else {
        throw Exception('Failed to complete task');
      }
    } catch (error) {
      return ReturnModel(
          message: "Error completing task item",
          success: false,
          error: error.toString());
    }
  }

  Future<ReturnModel> deleteTask(Tasks task) async {
    try {
      final response = await _httpService.dio.delete(
        '/core/tasks/${task.id}',
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to delete task');
      }

      return ReturnModel(
          message: "Successfully deleted ${task.title}", success: true);
    } catch (error) {
      return ReturnModel(
          message: "Error deleting task item",
          success: false,
          error: error.toString());
    }
  }

  Future<ReturnModel> updateTask(Tasks task) async {
    final jsonTask = task.toJson();
    jsonTask.remove("createdAt");
    jsonTask.remove("updatedAt");
    jsonTask["userId"] = Supabase.instance.client.auth.currentUser!.id;

    jsonTask["dueDate"] =
        DateTime.parse(jsonTask["dueDate"]).toUtc().toIso8601String();
    try {
      final response = await _httpService.dio.put(
        '/core/tasks/${task.id}',
        data: json.encode(jsonTask),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update task');
      }

      return const ReturnModel(
          message: "Task updated successfully", success: true);
    } catch (error) {
      return ReturnModel(
          message: "Error updating task item",
          success: false,
          error: error.toString());
    }
  }
}
