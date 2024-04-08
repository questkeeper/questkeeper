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

  Future<void> createAssignment(Assignment assignment) async {
    try {
      await _repository.createAssignment(assignment);
      await fetchAssignments();
    } catch (error) {
      debugPrint("Error creating assignment: $error");
    }
  }
}
