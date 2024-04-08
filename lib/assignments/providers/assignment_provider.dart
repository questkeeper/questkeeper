// Define a ChangeNotifier
import 'package:assigngo_rewrite/assignments/models/assignments_model.dart';
import 'package:assigngo_rewrite/assignments/repositories/assignments_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
}

// Provide it using Riverpod
final currentAssignmentProvider =
    ChangeNotifierProvider((ref) => CurrentAssignment());
