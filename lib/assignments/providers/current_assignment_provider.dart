import 'package:assigngo_rewrite/assignments/models/assignments_model.dart';
import 'package:assigngo_rewrite/assignments/subtasks/models/subtasks_model/subtasks_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentAssignmentProvider =
    ChangeNotifierProvider((ref) => CurrentAssignment());

class CurrentAssignment extends ChangeNotifier {
  Assignment? _assignment;
  Assignment? get assignment => _assignment;

  set assignment(Assignment? assignment) {
    _assignment = assignment;
    notifyListeners();
  }

  setCurrentAssignment(Assignment? assignment) {
    _assignment = assignment;
    notifyListeners();
  }

  void updateAssignment(Assignment assignment) {
    // Locally update the assignment
    _assignment = assignment;
    notifyListeners();
  }

  void updateSubtask(Subtask subtask) {
    // Locally update the subtask
    final index = _assignment!.subtasks!
        .indexWhere((element) => element.$id == subtask.$id);
    _assignment!.subtasks![index] = subtask;
    notifyListeners();
  }
}
