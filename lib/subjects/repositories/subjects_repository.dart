import 'package:assigngo_rewrite/shared/models/return_model/return_model.dart';
import 'package:assigngo_rewrite/subjects/models/subjects_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SubjectsRepository {
  final SupabaseClient supabase = Supabase.instance.client;

  SubjectsRepository();

  Future<List<Subject>> getSubjects() async {
    final subjects = await supabase.from('subjects').select();

    final List<Subject> subjectsList =
        subjects.map((e) => Subject.fromJson(e)).toList();

    return subjectsList;
  }

  Future<ReturnModel> createSubject(Subject subject) async {
    final jsonSubject = subject.toJson();

    jsonSubject.remove('id');
    jsonSubject.remove('createdAt');
    jsonSubject.remove('updatedAt');

    try {
      await supabase.from("subjects").insert(jsonSubject);
      return const ReturnModel(
          message: "Subject created successfully", success: true);
    } catch (error) {
      return ReturnModel(
          message: "Error creating subject",
          success: false,
          error: error.toString());
    }
  }
}
