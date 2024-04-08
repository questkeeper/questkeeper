import 'package:assigngo_rewrite/assignments/models/assignments_model.dart';
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
}
