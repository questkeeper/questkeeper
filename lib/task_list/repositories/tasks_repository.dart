import 'package:questkeeper/task_list/models/tasks_model.dart';
import 'package:questkeeper/shared/models/return_model/return_model.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TasksRepository {
  TasksRepository();

  final supabase = Supabase.instance.client;

  Future<List<Tasks>> getTasks() async {
    final tasks = await supabase.from("tasks").select().order("dueDate");

    final List<Tasks> tasksList = tasks.map((e) => Tasks.fromJson(e)).toList();

    return tasksList;
  }

  Future<Tasks> getTask(int id) async {
    final task = await supabase.from("tasks").select().eq("id", id).single();

    return Tasks.fromJson(task);
  }

  Future<ReturnModel> createTask(Tasks task) async {
    final Map<String, dynamic> jsonTask = task.toJson();
    jsonTask.remove("id");
    jsonTask.remove("createdAt");
    jsonTask.remove("updatedAt");

    try {
      final newTask = await supabase.from("tasks").insert(jsonTask).select();

      debugPrint("New task: $newTask");

      return ReturnModel(
          data: Tasks.fromJson(newTask.first),
          message: "Task created successfully",
          success: true);
    } catch (error) {
      debugPrint("Error creating task: $error");
      return ReturnModel(
          message: "Error creating task item",
          success: false,
          error: error.toString());
    }
  }

  Future<ReturnModel> toggleStar(Tasks task) async {
    try {
      await supabase
          .from("tasks")
          .update({"starred": !task.starred}).eq("id", task.id!);
      return const ReturnModel(
          message: "Task starred successfully", success: true);
    } catch (error) {
      return ReturnModel(
          message: "Error starring task item",
          success: false,
          error: error.toString());
    }
  }

  Future<ReturnModel> toggleComplete(Tasks task) async {
    try {
      await supabase
          .from("tasks")
          .update({"completed": !task.completed}).eq("id", task.id!);

      return const ReturnModel(
          message: "Task completed successfully", success: true);
    } catch (error) {
      return ReturnModel(
          message: "Error completing task item",
          success: false,
          error: error.toString());
    }
  }

  Future<ReturnModel> deleteTask(Tasks task) async {
    try {
      await supabase.from("tasks").delete().eq("id", task.id.toString());

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
    try {
      await supabase
          .from("tasks")
          .update(task.toJson())
          .eq("id", task.id.toString());

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
