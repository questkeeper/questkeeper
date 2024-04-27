import 'dart:io';

import 'package:assigngo_rewrite/assignments/models/assignments_model.dart';
import 'package:assigngo_rewrite/assignments/repositories/assignments_repository.dart';
import 'package:assigngo_rewrite/shared/models/return_model/return_model.dart';
import 'package:assigngo_rewrite/shared/utils/home_widget/home_widget_mobile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final assignmentsProvider =
    StateNotifierProvider<AssignmentsNotifier, List<Assignment>>(
  (ref) {
    return AssignmentsNotifier([]);
  },
);

class AssignmentsNotifier extends StateNotifier<List<Assignment>> {
  final AssignmentsRepository _repository = AssignmentsRepository();
  AssignmentsNotifier(super.state);

  void updateHomeWidget(List<Assignment> state) {
    try {
      if (Platform.isIOS || Platform.isAndroid) {
        HomeWidgetMobile().updateHomeWidget(state);
      }
    } catch (e) {
      debugPrint("Platform implementation error: $e");
    }
  }

  Future<void> fetchAssignments() async {
    try {
      final assignments = await _repository.getAssignments();

      state = assignments;
      updateHomeWidget(assignments);
    } catch (error) {
      debugPrint("Error fetching assignments: $error");
    }
  }

  Future<ReturnModel> createAssignment(Assignment assignment) async {
    try {
      final data = await _repository.createAssignment(assignment);
      await fetchAssignments();

      return data;
    } catch (error) {
      debugPrint("Error creating assignment: $error");

      return ReturnModel(
        success: false,
        message: "Error creating assignment: $error",
        error: error.toString(),
      );
    }
  }

  Future<void> toggleStar(Assignment assignment) async {
    try {
      state = state.map((a) {
        if (a.$id == assignment.$id) {
          return a.copyWith(starred: !a.starred);
        }
        return a;
      }).toList();
      await _repository.toggleStar(assignment);
    } catch (error) {
      state = state.map((a) {
        if (a.$id == assignment.$id) {
          return a.copyWith(starred: !a.starred);
        }
        return a;
      }).toList();
      debugPrint("Error starring assignment: $error");
    }
  }

  Future<void> toggleComplete(Assignment assignment) async {
    try {
      await _repository.toggleComplete(assignment);

      state = state.map((a) {
        if (a.$id == assignment.$id) {
          return a.copyWith(completed: !a.completed);
        }
        return a;
      }).toList();
    } catch (error) {
      debugPrint("Error completing assignment: $error");
    }
  }

  Future<void> getAssignment(String id) async {
    try {
      await _repository.getAssignment(id);
    } catch (error) {
      debugPrint("Error getting assignment: $error");
    }
  }

  Future<void> deleteAssignment(Assignment assignment) async {
    try {
      await _repository.deleteAssignment(assignment);

      state = state.where((a) => a.$id != assignment.$id).toList();
    } catch (error) {
      debugPrint("Error deleting assignment: $error");
    }
  }

  Future<void> updateAssignment(Assignment assignment) async {
    try {
      await _repository.updateAssignment(assignment);
      state = state.map((a) {
        if (a.$id == assignment.$id) {
          return assignment;
        }
        return a;
      }).toList();
    } catch (error) {
      debugPrint("Error updating assignment: $error");
    }
  }
}
