import 'package:questkeeper/task_list/subtasks/models/subtasks_model/subtasks_model.dart';
import 'package:questkeeper/shared/models/return_model/return_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SubtasksRepository {
  SubtasksRepository();
  final supabase = Supabase.instance.client;

  Future<ReturnModel> getSubtasks(int taskId) async {
    try {
      final subtasks =
          await supabase.from("subtasks").select().eq("taskId", taskId);

      final subtasksList = subtasks.map((e) => Subtask.fromJson(e)).toList();

      return ReturnModel(
          success: true, data: subtasksList, message: "Subtasks fetched");
    } catch (error) {
      return ReturnModel(success: false, message: error.toString());
    }
  }

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

  Future<ReturnModel> upsertBulkSubtasks(List<Subtask> subtasks) async {
    try {
      final batchDeleteSubtasks = [];
      final batchInsertSubtasks = [];
      final returnValue = [];
      final batchUpdateSubtasks = [];

      subtasks
          .map((subtask) {
            final subtaskJson = subtask.toJson();
            if (subtaskJson["title"] == null || subtaskJson["title"] == "") {
              return null;
            }

            if (subtaskJson["id"] == null) {
              subtaskJson.remove("id");
              batchInsertSubtasks.add(subtaskJson);
              return null;
            }

            if (subtask.priority == -1) {
              batchDeleteSubtasks.add(subtask.id);
              return null;
            }

            batchUpdateSubtasks.add(subtaskJson);
            return subtaskJson;
          })
          .whereType<Map<String, dynamic>>() // get rid of null vals
          .toList();

      if (batchDeleteSubtasks.isNotEmpty) {
        for (var element in batchDeleteSubtasks) {
          await supabase.from("subtasks").delete().eq("id", element);
        }
      }

      if (batchUpdateSubtasks.isNotEmpty) {
        returnValue.addAll(await supabase
            .from("subtasks")
            .upsert(batchUpdateSubtasks)
            .select());
      }

      if (batchInsertSubtasks.isNotEmpty) {
        returnValue.addAll(await supabase
            .from("subtasks")
            .insert(batchInsertSubtasks)
            .select());
      }

      return ReturnModel(
          success: true,
          data: returnValue.map((e) => Subtask.fromJson(e)).toList(),
          message: "Subtasks created successfully");
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
