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

  Future<Map<String, dynamic>> createAssignment(Assignment assignment) async {
    final Map<String, dynamic> jsonAssignment = assignment.toJson();
    jsonAssignment.remove('id');
    jsonAssignment.remove('createdAt');
    jsonAssignment.remove('updatedAt');
    try {
      await supabase.from('assignments').insert(jsonAssignment);
      return {
        "success": true,
        "message": "Assignment created successfully",
        "error": false,
      };
    } catch (error) {
      return {
        "error": true,
        "message": "Error creating assignment",
        "success": false
      };
    }
  }

  Future<Map<String, dynamic>> starAssignment(int id) async {
    try {
      await supabase.from('assignments').update({'starred': true}).eq('id', id);
      return {
        "success": true,
        "message": "Assignment prioritized successfully",
        "error": false,
      };
    } catch (error) {
      return {
        "error": true,
        "message": "Error prioritized assignment",
        "success": false
      };
    }
  }

  Future<Map<String, dynamic>> completeAssignment(int id) async {
    try {
      print("Completing assignment with id: $id");
      await supabase
          .from('assignments')
          .update({'completed': true}).eq('id', id);

      print("Assignment completed successfully");
      return {
        "success": true,
        "message": "Assignment completed successfully",
        "error": false,
      };
    } catch (error) {
      return {
        "error": true,
        "message": "Error completing assignment",
        "success": false
      };
    }
  }
}
