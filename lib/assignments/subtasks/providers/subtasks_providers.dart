import 'package:assigngo_rewrite/assignments/subtasks/models/subtasks_model/subtasks_model.dart';
import 'package:assigngo_rewrite/assignments/subtasks/repositories/subtasks_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final subtasksProvider = ChangeNotifierProvider((ref) => SubtasksNotifier());

class SubtasksNotifier extends ChangeNotifier {
  final SubtasksRepository _subtasksRepository = SubtasksRepository();

  List<Subtask> subtasks = [];

  Future<void> toggleSubtaskDone(Subtask subtask) async {
    final returnModel = await _subtasksRepository.updateSubtask(subtask);
    if (returnModel.success) {
      int index = subtasks.indexWhere((element) => element.$id == subtask.$id);

      Subtask updatedSubtask = subtask.copyWith(completed: !subtask.completed);

      subtasks[index] = updatedSubtask;
    }
  }
}
