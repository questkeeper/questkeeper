import 'dart:convert';

import 'package:assigngo_rewrite/assignments/models/assignments_model.dart';
import 'package:assigngo_rewrite/assignments/repositories/assignments_repository.dart';
import 'package:assigngo_rewrite/shared/models/return_model/return_model.dart';
import 'package:assigngo_rewrite/shared/utils/format_date.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_widget/home_widget.dart';

final assignmentsProvider =
    StateNotifierProvider<AssignmentsNotifier, List<Assignment>>(
  (ref) {
    return AssignmentsNotifier([]);
    // final subjectsNotifier = ref.watch(subjectsProvider.notifier);
    // return AssignmentsNotifier([], subjectsNotifier);
  },
);

class AssignmentsNotifier extends StateNotifier<List<Assignment>> {
  final AssignmentsRepository _repository = AssignmentsRepository();
  // final SubjectsNotifier _subjectsNotifier;

  // AssignmentsNotifier(super._state, this._subjectsNotifier);
  AssignmentsNotifier(super.state);

  void updateHomeWidget(List<Assignment> state) {
    final assignemntJson = state
        .map((assignment) => {
              'id': assignment.$id,
              'title': assignment.title,
              'description': assignment.description,
              'dueDate': formatDate(assignment.dueDate),
              'starred': assignment.starred,
            })
        .toList();

    HomeWidget.saveWidgetData<String>(
        "assignments", const JsonEncoder().convert(assignemntJson));

    HomeWidget.updateWidget(
      name: 'AssignGoWidgets',
      iOSName: 'AssignGoWidgets',
      androidName: 'AssignGo',
      // androidPackageName: 'com.example.assigngo_rewrite',
    );
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
