import 'package:assigngo_rewrite/assignments/models/assignments_model.dart';
import 'package:assigngo_rewrite/assignments/repositories/assignments_repository.dart';
import 'package:assigngo_rewrite/assignments/subtasks/models/subtasks_model/subtasks_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentAssignmentProvider =
    ChangeNotifierProvider((ref) => CurrentAssignment());

class CurrentAssignment extends ChangeNotifier {
  Assignment? _assignment;
  Assignment? get assignment => _assignment;
  final AssignmentsRepository _repository = AssignmentsRepository();

  set assignment(Assignment? assignment) {
    _assignment = assignment;
    notifyListeners();
  }

  setCurrentAssignment(Assignment? assignment) {
    _assignment = assignment;
    notifyListeners();
  }

  updateCurrentAssignment(Assignment assignment) async {
    _assignment = await _repository.getAssignment(assignment.$id);
    notifyListeners();
  }

  void updateAssignment(Assignment assignment) {
    // Locally update the assignment
    _assignment = assignment;
    notifyListeners();
  }

  void updateAssignmentSubject(Assignment assignment) {
    _assignment = _assignment?.copyWith(subject: assignment.subject);
    notifyListeners();
  }

  void updateSubtask(Subtask subtask) {
    _assignment = _assignment?.copyWith(
      subtasks: _assignment?.subtasks?.map((oldSubtask) {
        if (oldSubtask.$id == subtask.$id) {
          return subtask;
        }
        return oldSubtask;
      }).toList(),
    );

    notifyListeners();
  }
}
