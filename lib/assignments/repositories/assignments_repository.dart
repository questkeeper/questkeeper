import 'package:assigngo_rewrite/assignments/models/assignments_model.dart';
import 'package:assigngo_rewrite/shared/models/return_model/return_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AssignmentsRepository {
  final SupabaseClient supabase = Supabase.instance.client;

  AssignmentsRepository();

  Future<List<Assignment>> getAssignments() async {
    final assignments =
        await supabase.from('assignments').select().eq("deleted", false).order(
              'dueDate',
              ascending: true,
            );

    final List<Assignment> assignmentList =
        assignments.map((e) => Assignment.fromJson(e)).toList();

    return assignmentList;
  }

  Future<Assignment> getAssignment(int id) async {
    final assignment =
        await supabase.from('assignments').select().eq('id', id).single();

    return Assignment.fromJson(assignment);
  }

  Future<ReturnModel> createAssignment(Assignment assignment) async {
    final Map<String, dynamic> jsonAssignment = assignment.toJson();
    jsonAssignment.remove('id');
    jsonAssignment.remove('createdAt');
    jsonAssignment.remove('updatedAt');
    jsonAssignment.remove('subject');
    try {
      final assignment =
          await supabase.from('assignments').insert(jsonAssignment).select();
      return ReturnModel(
          data: Assignment.fromJson(assignment.first),
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
      await supabase
          .from('assignments')
          .update({'starred': !assignment.starred}).eq('id', assignment.id!);
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
      await supabase.from('assignments').update(
          {'completed': !assignment.completed}).eq('id', assignment.id!);

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
      await supabase
          .from("assignments")
          .update({"deleted": true}).eq("id", assignment.id!);
      return ReturnModel(
          message: "Successfully deleted ${assignment.title}", success: true);
    } catch (error) {
      return ReturnModel(
          message: "Error deleting assignment",
          success: false,
          error: error.toString());
    }
  }

  Future<ReturnModel> updateAssignment(Assignment assignment) async {
    final Map<String, dynamic> jsonAssignment = assignment.toJson();
    jsonAssignment.remove('columns');
    jsonAssignment.remove('subject');
    jsonAssignment.remove('createdAt');

    try {
      await supabase
          .from('assignments')
          .update(jsonAssignment)
          .eq('id', assignment.id!);

      return const ReturnModel(
          message: "Assignment updated successfully", success: true);
    } catch (error) {
      return ReturnModel(
          message: "Error updating assignment",
          success: false,
          error: error.toString());
    }
  }
}
