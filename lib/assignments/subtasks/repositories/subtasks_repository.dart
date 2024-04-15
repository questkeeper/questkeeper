import 'package:assigngo_rewrite/assignments/subtasks/models/subtasks_model/subtasks_model.dart';
import 'package:assigngo_rewrite/shared/models/return_model/return_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SubtasksRepository {
  final SupabaseClient supabase = Supabase.instance.client;

  SubtasksRepository();

  Future<List<Subtask>> getAssignmentSubtasks(int assignmentId) async {
    final subtask = await supabase
        .from('subtasks')
        .select()
        .eq('assignmentId', assignmentId)
        .order('priority', ascending: true);

    return subtask.map((e) => Subtask.fromJson(e)).toList();
  }

  Future<ReturnModel> createBatchSubtasks(List<Subtask> subtasks) async {
    final List<Map<String, dynamic>> jsonSubtasks =
        subtasks.map((e) => e.toJson()).toList();

    for (var element in jsonSubtasks) {
      element.remove('id');
      element.remove('createdAt');
      element.remove('updatedAt');
    }

    try {
      await supabase.from('subtasks').insert(jsonSubtasks);
      return const ReturnModel(
          message: "Subtasks created successfully", success: true);
    } catch (error) {
      return ReturnModel(
          message: "Error creating subtasks",
          success: false,
          error: error.toString());
    }
  }

  Future<ReturnModel> createSubtask(Subtask subtask) async {
    final Map<String, dynamic> jsonSubtask = subtask.toJson();
    jsonSubtask.remove('id');

    try {
      await supabase.from('subtasks').insert(jsonSubtask);
      return const ReturnModel(
          message: "Subtask created successfully", success: true);
    } catch (error) {
      return ReturnModel(
          message: "Error creating subtask",
          success: false,
          error: error.toString());
    }
  }

  Future<ReturnModel> toggleComplete(Subtask subtask) async {
    try {
      await supabase
          .from('subtasks')
          .update({'completed': !subtask.completed}).eq('id', subtask.id!);
      return const ReturnModel(
          message: "Subtask completed successfully", success: true);
    } catch (error) {
      return ReturnModel(
          message: "Error completing subtask",
          success: false,
          error: error.toString());
    }
  }
}
