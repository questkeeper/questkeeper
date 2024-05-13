import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:assigngo_rewrite/task_list/models/assignments_model.dart';
import 'package:assigngo_rewrite/constants.dart';
import 'package:assigngo_rewrite/shared/models/return_model/return_model.dart';
import 'package:assigngo_rewrite/subjects/models/subjects_model.dart';

class SubjectsRepository {
  SubjectsRepository();

  Future<List<Subject>> getSubjects() async {
    final subjects = await database.listDocuments(
        databaseId: publicDb,
        collectionId: "subjects",
        queries: [
          Query.equal('archived', false),
        ]);

    final subjectsList =
        subjects.documents.map((e) => Subject.fromJson(e.data)).toList();

    return subjectsList;
  }

  Future<ReturnModel> updateSubject(Subject subject) async {
    final jsonSubject = subject.toJson();
    final String id = jsonSubject["\$id"];
    jsonSubject.remove("\$id");

    try {
      final Document result = await database.updateDocument(
          databaseId: publicDb,
          collectionId: "subjects",
          documentId: id,
          data: jsonSubject);

      return ReturnModel(
          message: "Subject updated successfully",
          success: true,
          data: result.data);
    } catch (error) {
      return ReturnModel(
          message: "Error updating subject",
          success: false,
          error: error.toString());
    }
  }

  Future<ReturnModel> updateSubjectWithAssignment(
      Assignment assignment, String subjectId) async {
    try {
      final Document subject = await database.getDocument(
          databaseId: publicDb,
          collectionId: "subjects",
          documentId: subjectId);

      final Document result = await database.updateDocument(
          databaseId: publicDb,
          collectionId: "subjects",
          documentId: subjectId,
          data: {
            "assignments": (List.from(subject.data['assignments'] ?? [])
              ..add(assignment.toJson())),
          });

      return ReturnModel(
          message: "Subject updated successfully",
          success: true,
          data: result.data);
    } catch (error) {
      return ReturnModel(
          message: "Error updating subject",
          success: false,
          error: error.toString());
    }
  }

  Future<ReturnModel> createSubject(Subject subject) async {
    final jsonSubject = subject.toJson();

    jsonSubject.remove('\$id');

    try {
      final Document result = await database.createDocument(
        databaseId: publicDb,
        collectionId: "subjects",
        documentId: subject.$id,
        data: jsonSubject,
      );

      return ReturnModel(
          message: "Subject created successfully",
          success: true,
          data: result.data);
    } catch (error) {
      return ReturnModel(
          message: "Error creating subject",
          success: false,
          error: error.toString());
    }
  }

  Future<ReturnModel> deleteSubject(Subject subject) async {
    try {
      final Document result = await database.deleteDocument(
          databaseId: publicDb,
          collectionId: "subjects",
          documentId: subject.$id);

      return ReturnModel(
          message: "Subject deleted successfully",
          success: true,
          data: result.data);
    } catch (error) {
      return ReturnModel(
          message: "Error deleting subject",
          success: false,
          error: error.toString());
    }
  }
}
