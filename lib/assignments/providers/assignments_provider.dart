import 'package:assigngo_rewrite/assignments/models/assignments_model.dart';
import 'package:assigngo_rewrite/assignments/repositories/assignments_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final assignmentsProvider =
    StateNotifierProvider<AssignmentsNotifier, List<Assignment>>(
  (ref) => AssignmentsNotifier([]),
);

class AssignmentsNotifier extends StateNotifier<List<Assignment>> {
  final AssignmentsRepository _repository = AssignmentsRepository();

  AssignmentsNotifier(super._state);

  Future<void> fetchAssignments() async {
    final assignments = await _repository.getAssignments();
    state = assignments;
  }

  Future<void> fetchAssignment(int id) async {
    final assignment = await _repository.getAssignment(id);
    state = [assignment];
  }

  Future<void> createAssignment(Assignment assignment) async {
    try {
      await _repository.createAssignment(assignment);
      await fetchAssignments();
    } catch (error) {
      debugPrint("Error creating assignment: $error");
    }
  }

  Future<void> toggleStar(Assignment assignment) async {
    try {
      await _repository.toggleStar(assignment);
      await fetchAssignments();

      state = state.map((a) {
        if (a.id == assignment.id) {
          return a.copyWith(starred: assignment.starred);
        }
        return a;
      }).toList();
    } catch (error) {
      debugPrint("Error starring assignment: $error");
    }
  }

  Future<void> toggleComplete(Assignment assignment) async {
    try {
      await _repository.toggleComplete(assignment);
      await fetchAssignments();

      state = state.map((a) {
        if (a.id == assignment.id) {
          return a.copyWith(completed: assignment.completed);
        }
        return a;
      }).toList();
    } catch (error) {
      debugPrint("Error completing assignment: $error");
    }
  }

  Future<void> getAssignment(int id) async {
    try {
      await _repository.getAssignment(id);
    } catch (error) {
      debugPrint("Error getting assignment: $error");
    }
  }

  void deleteAssignment(int i) {}
}
