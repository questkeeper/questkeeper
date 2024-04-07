import 'package:assigngo_rewrite/assignments/repositories/assignments_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final assignmentsProvider =
    StateNotifierProvider<AssignmentsNotifier, List<Map<String, dynamic>>>(
  (ref) => AssignmentsNotifier([]),
);

class AssignmentsNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  final AssignmentsRepository _repository = AssignmentsRepository();

  AssignmentsNotifier(super._state);

  Future<void> fetchAssignments() async {
    final assignments = await _repository.getAssignments();
    state = assignments;
  }

  Future<void> createOrUpdateAssignment(Map<String, dynamic> assignment) async {
    final updatedAssignment =
        await _repository.createOrUpdateAssignment(assignment);
    state = [...state, updatedAssignment];
  }

  // ... other methods for CRUD operations
}
