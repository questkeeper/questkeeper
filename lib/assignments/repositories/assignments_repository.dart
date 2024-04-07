import 'package:assigngo_rewrite/assignments/models/assignments_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AssignmentsRepository {
  final SupabaseClient supabase = Supabase.instance.client;

  AssignmentsRepository();

  Future<List<Assignment>> getAssignments() async {
    final List<Assignment> assignmentList;
    final assignments = await supabase.from('assignments').select();

    assignmentList = assignments.map((e) => Assignment.fromJson(e)).toList();
    return assignmentList;
  }

  Future<Assignment> getAssignment(int id) async {
    final assignment =
        await supabase.from('assignments').select().eq('id', id).single();

    return Assignment.fromJson(assignment);
  }

  Future<Map<String, dynamic>> createOrUpdateAssignment(
      Map<String, dynamic> assignment) async {
    print(assignment);
    // Convert datetime obj to datetime for supabase
    assignment['due_date'] = assignment['due_date'].toIso8601String();
    try {
      await supabase.from('assignments').upsert(assignment);
      return {
        "success": true,
        "message": "Assignment created successfully",
        "error": false
      };
    } catch (error) {
      return {
        "error": true,
        "message": "Error creating assignment",
        "success": false
      };
    }
  }
}
