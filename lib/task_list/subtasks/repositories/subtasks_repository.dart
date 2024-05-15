import 'package:assigngo_rewrite/task_list/subtasks/models/subtasks_model/subtasks_model.dart';
import 'package:assigngo_rewrite/shared/models/return_model/return_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SubtasksRepository {
  SubtasksRepository();
  final supabase = Supabase.instance.client;

  Future<ReturnModel> createSubtask(Subtask subtask) async {
    try {
      final subtaskJson = subtask.toJson();
      subtaskJson.remove("id");

      final newSubtask =
          await supabase.from("subtasks").insert(subtaskJson).select();

      return ReturnModel(
          success: true,
          data: Subtask.fromJson(newSubtask.first),
          message: "Subtask created successfully");
    } catch (error) {
      return ReturnModel(success: false, message: error.toString());
    }
  }

  Future<ReturnModel> updateSubtask(Subtask subtask) async {
    try {
      final updatedSubtask = await supabase
          .from("subtasks")
          .update(subtask.toJson())
          .eq("id", subtask.id!)
          .select();

      return ReturnModel(
          success: true,
          data: Subtask.fromJson(updatedSubtask.first),
          message: "Subtask updated successfully");
    } catch (error) {
      return ReturnModel(success: false, message: error.toString());
    }
  }
}
