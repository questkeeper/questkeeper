import 'package:supabase_flutter/supabase_flutter.dart';

class AssignmentsRepository {
  final SupabaseClient supabase = Supabase.instance.client;

  AssignmentsRepository();

  Future<List<Map<String, dynamic>>> getAssignments() async {
    return await supabase.from('assignments').select();
  }

  Future<Map<String, dynamic>> getAssignment(int id) async {
    return await supabase.from('assignments').select().eq('id', id).single();
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
