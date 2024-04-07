import 'package:assigngo_rewrite/assignments/models/assignments_model.dart';
import 'package:assigngo_rewrite/assignments/repositories/assignments_repository.dart';
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

  Future<void> createOrUpdateAssignment(Assignment assignment) async {
    final updatedAssignment =
        await _repository.createOrUpdateAssignment(assignment.toJson());
    state = [...state, Assignment.fromJson(updatedAssignment)];
  }

  // ... other methods for CRUD operations
}
