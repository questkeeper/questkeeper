import 'package:assigngo_rewrite/assignments/models/assignments_model.dart';
import 'package:assigngo_rewrite/assignments/repositories/assignments_repository.dart';
import 'package:assigngo_rewrite/subjects/models/subjects_model.dart';
import 'package:assigngo_rewrite/subjects/providers/subjects_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final assignmentsProvider =
    StateNotifierProvider<AssignmentsNotifier, List<Assignment>>(
  (ref) {
    final subjectsNotifier = ref.watch(subjectsProvider.notifier);
    return AssignmentsNotifier([], subjectsNotifier);
  },
);

class AssignmentsNotifier extends StateNotifier<List<Assignment>> {
  final AssignmentsRepository _repository = AssignmentsRepository();
  final SubjectsNotifier _subjectsNotifier;

  AssignmentsNotifier(super._state, this._subjectsNotifier);

  Future<void> fetchAssignments() async {
    await _subjectsNotifier.fetchSubjects();
    final assignments = await _repository.getAssignments();
    final subjects = _subjectsNotifier.state;

    state = assignments.map((assignment) {
      final subject = subjects.firstWhere(
        (subject) => subject.id == assignment.subjectId,
        orElse: () => Subject(
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            name: "Uncategorized"),
      );
      return assignment.copyWith(subject: subject);
    }).toList();
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

      state = state.map((a) {
        if (a.id == assignment.id) {
          return a.copyWith(starred: !a.starred);
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

      state = state.map((a) {
        if (a.id == assignment.id) {
          return a.copyWith(completed: !a.completed);
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

  Future<void> deleteAssignment(Assignment assignment) async {
    try {
      await _repository.deleteAssignment(assignment);
    } catch (error) {
      debugPrint("Error deleting assignment: $error");
    }
  }
}
