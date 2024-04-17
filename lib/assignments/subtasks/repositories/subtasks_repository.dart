import 'package:assigngo_rewrite/assignments/subtasks/models/subtasks_model/subtasks_model.dart';
import 'package:assigngo_rewrite/constants.dart';
import 'package:assigngo_rewrite/shared/models/return_model/return_model.dart';

class SubtasksRepository {
  SubtasksRepository();

  Future<ReturnModel> updateSubtask(Subtask subtask) async {
    try {
      final updatedSubtask = await database.updateDocument(
          databaseId: publicDb,
          collectionId: "subtasks",
          documentId: subtask.$id,
          data: subtask.toJson());

      return ReturnModel(
          success: true,
          data: updatedSubtask.data,
          message: "Subtask updated successfully");
    } catch (error) {
      return ReturnModel(success: false, message: error.toString());
    }
  }
}
