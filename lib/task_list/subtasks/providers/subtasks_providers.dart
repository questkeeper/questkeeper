import 'package:questkeeper/shared/models/return_model/return_model.dart';
import 'package:questkeeper/task_list/subtasks/models/subtasks_model/subtasks_model.dart';
import 'package:questkeeper/task_list/subtasks/repositories/subtasks_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final subtasksProvider = ChangeNotifierProvider((ref) => SubtasksNotifier());

class SubtasksNotifier extends ChangeNotifier {
  final SubtasksRepository _subtasksRepository = SubtasksRepository();

  List<Subtask> subtasks = [];

  Future<ReturnModel> createSubtask(Subtask subtask) async {
    final result = await _subtasksRepository.createSubtask(subtask);
    if (!result.success) {
      subtasks.remove(subtask);
      notifyListeners();
    }
    return result;
  }

  Future<ReturnModel> createBatchSubtasks(List<Subtask> subtasks) async {
    final result = await _subtasksRepository.createBatchSubtasks(subtasks);
    if (!result.success) {
      this.subtasks.removeWhere((subtask) => subtasks.contains(subtask));
      notifyListeners();
    }
    return result;
  }

  static _updateSubtaskState(Subtask subtask, List<Subtask> subtasks) {
    return subtasks.map((oldSubtask) {
      if (oldSubtask.id == subtask.id) {
        return subtask;
      }
      return oldSubtask;
    }).toList();
  }

  Future<ReturnModel> updateSubtask(Subtask subtask) async {
    subtasks = _updateSubtaskState(subtask, subtasks);
    notifyListeners();

    final result = await _subtasksRepository.updateSubtask(subtask);
    if (!result.success) {
      subtasks = _updateSubtaskState(subtask, subtasks);
      notifyListeners();
    }
    return result;
  }

  Future<ReturnModel> toggleSubtaskDone(Subtask subtask) async {
    _updateSubtaskState(
        subtask.copyWith(completed: !subtask.completed), subtasks);
    notifyListeners();

    final result = await _subtasksRepository.updateSubtask(subtask);
    if (!result.success) {
      _updateSubtaskState(
          subtask.copyWith(completed: !subtask.completed), subtasks);
      notifyListeners();
    }

    return result;
  }
}
