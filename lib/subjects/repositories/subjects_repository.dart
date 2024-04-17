import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
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

  Future<ReturnModel> createSubject(Subject subject) async {
    final jsonSubject = subject.toJson();
    final User user = await account.get();

    jsonSubject.remove('id');

    try {
      final Document result = await database.createDocument(
          databaseId: publicDb,
          collectionId: "subjects",
          documentId: ID.unique(),
          data: jsonSubject,
          permissions: getPermissions(user.$id));

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
}
