import 'package:assigngo_rewrite/task_list/models/tasks_model.dart';
import 'package:assigngo_rewrite/task_list/repositories/assignments_repository.dart';
import 'package:assigngo_rewrite/task_list/subtasks/models/subtasks_model/subtasks_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentTaskProvider = ChangeNotifierProvider((ref) => CurrentTask());

class CurrentTask extends ChangeNotifier {
  Tasks? _task;
  Tasks? get task => _task;
  final TasksRepository _repository = TasksRepository();

  set task(Tasks? task) {
    _task = task;
    notifyListeners();
  }

  setCurrentTask(Tasks? task) {
    _task = task;
    notifyListeners();
  }

  updateCurrentTask(Tasks task) async {
    _task = await _repository.getTask(task.id!);
    notifyListeners();
  }

  void updateTask(Tasks task) {
    // Locally update the task
    _task = task;
    notifyListeners();
  }

  void updateTaskSubject(Tasks task) {
    // _task = _task?.copyWith(subject: task.subject);
    notifyListeners();
  }

  void updateSubtask(Subtask subtask) {
    // _task = _task?.copyWith(
    //   subtasks: _task?.subtasks?.map((oldSubtask) {
    //     if (oldSubtask.$id == subtask.$id) {
    //       return subtask;
    //     }
    //     return oldSubtask;
    //   }).toList(),
    // );

    notifyListeners();
  }
}
