import 'package:appwrite/appwrite.dart';
import 'package:assigngo_rewrite/assignments/models/assignments_model.dart';
import 'package:assigngo_rewrite/assignments/subtasks/models/subtasks_model/subtasks_model.dart';
import 'package:assigngo_rewrite/constants.dart';
import 'package:assigngo_rewrite/shared/models/return_model/return_model.dart';
import 'package:assigngo_rewrite/subjects/repositories/subjects_repository.dart';

class AssignmentsRepository {
  AssignmentsRepository();
  final SubjectsRepository _repository = SubjectsRepository();

  Future<List<Assignment>> getAssignments() async {
    final assignments = await database.listDocuments(
        databaseId: publicDb,
        collectionId: "assignments",
        queries: [
          Query.orderAsc("dueDate"),
        ]);

    final List<Assignment> assignmentList =
        assignments.documents.map((e) => Assignment.fromJson(e.data)).toList();

    return assignmentList;
  }

  Future<Assignment> getAssignment(String id) async {
    final assignment = await database.getDocument(
        databaseId: publicDb, collectionId: "assignments", documentId: id);

    return Assignment.fromJson(assignment.data);
  }

  Future<ReturnModel> createAssignment(Assignment assignment) async {
    final subtasks = assignment.subtasks?.map((e) => e.toJson()).toList();
    final subject = assignment.subject?.toJson();
    final Map<String, dynamic> jsonAssignment = assignment.toJson();
    jsonAssignment['subtasks'] = subtasks;
    final assignmentId = ID.unique();

    jsonAssignment.remove("\$id");
    jsonAssignment.remove("\$updatedAt");
    jsonAssignment.remove("\$createdAt");
    jsonAssignment.remove("subject");

    final userNotificationTimes = [12, 24, 48];
    final notifications = [];

    for (final time in userNotificationTimes) {
      final notificationTime =
          assignment.dueDate.subtract(Duration(hours: time));

      if (notificationTime.isAfter(assignment.dueDate) ||
          notificationTime.isBefore(DateTime.now())) {
        continue;
      }

      // Issue was due to not converting times to UTC when creating notifications
      notifications.add({
        "notificationTime": notificationTime.toUtc().toIso8601String(),
        "activated": false,
      });
    }

    jsonAssignment['notifications'] = notifications;

    try {
      final newAssignment = await database.createDocument(
        databaseId: publicDb,
        collectionId: "assignments",
        documentId: assignmentId,
        data: jsonAssignment,
      );

      if (subject != null) {
        await _repository.updateSubjectWithAssignment(
            Assignment.fromJson(newAssignment.data), subject['\$id']);
      }

      return ReturnModel(
          data: Assignment.fromJson(newAssignment.data),
          message: "Assignment created successfully",
          success: true);
    } catch (error) {
      return ReturnModel(
          message: "Error creating assignment",
          success: false,
          error: error.toString());
    }
  }

  Future<ReturnModel> toggleStar(Assignment assignment) async {
    try {
      await database.updateDocument(
          databaseId: publicDb,
          collectionId: "assignments",
          documentId: assignment.$id,
          data: {'starred': !assignment.starred});
      return const ReturnModel(
          message: "Assignment starred successfully", success: true);
    } catch (error) {
      return ReturnModel(
          message: "Error starring assignment",
          success: false,
          error: error.toString());
    }
  }

  Future<ReturnModel> toggleComplete(Assignment assignment) async {
    try {
      await database.updateDocument(
          databaseId: publicDb,
          collectionId: "assignments",
          documentId: assignment.$id,
          data: {'completed': !assignment.completed});

      return const ReturnModel(
          message: "Assignment completed successfully", success: true);
    } catch (error) {
      return ReturnModel(
          message: "Error completing assignment",
          success: false,
          error: error.toString());
    }
  }

  Future<ReturnModel> deleteAssignment(Assignment assignment) async {
    try {
      await database.deleteDocument(
          databaseId: publicDb,
          collectionId: "assignments",
          documentId: assignment.$id);

      return ReturnModel(
          message: "Successfully deleted ${assignment.title}", success: true);
    } catch (error) {
      return ReturnModel(
          message: "Error deleting assignment",
          success: false,
          error: error.toString());
    }
  }

  Future<ReturnModel> updateAssignmentSubject(Assignment assignment) async {
    final Map<String, dynamic> jsonAssignment = assignment.toJson();

    try {
      await database.updateDocument(
          databaseId: publicDb,
          collectionId: "assignments",
          documentId: assignment.$id,
          data: jsonAssignment);

      return const ReturnModel(
          message: "Assignment updated successfully", success: true);
    } catch (error) {
      return ReturnModel(
          message: "Error updating assignment",
          success: false,
          error: error.toString());
    }
  }

  Future<ReturnModel> updateAssignment(Assignment assignment) async {
    final Map<String, dynamic> jsonAssignment = assignment.toJson();
    jsonAssignment.remove("subject");

    try {
      await database.updateDocument(
          databaseId: publicDb,
          collectionId: "assignments",
          documentId: assignment.$id,
          data: jsonAssignment);

      return const ReturnModel(
          message: "Assignment updated successfully", success: true);
    } catch (error) {
      return ReturnModel(
          message: "Error updating assignment",
          success: false,
          error: error.toString());
    }
  }

  Future<ReturnModel> createSubtask(Assignment assignment) async {
    final newSubtask = const Subtask(
      $id: '',
      title: "New subtask",
      completed: false,
    ).toJson();

    newSubtask.remove("\$id");

    try {
      await database.updateDocument(
          databaseId: publicDb,
          collectionId: "assignments",
          documentId: assignment.$id,
          data: {
            "subtasks": assignment.subtasks == null
                ? [newSubtask]
                : assignment.subtasks!.map((e) => e.toJson()).toList()
              ..add(newSubtask)
          });

      return const ReturnModel(
          message: "Subtask created successfully", success: true);
    } catch (error) {
      return ReturnModel(
          message: "Error creating subtask",
          success: false,
          error: error.toString());
    }
  }
}
