// ignore_for_file: unnecessary_getters_setters
// Code breaks if I change the getters/setters to public.

import 'package:questkeeper/categories/models/categories_model.dart';
import 'package:questkeeper/categories/repositories/categories_repository.dart';
import 'package:questkeeper/task_list/models/tasks_model.dart';
import 'package:questkeeper/task_list/repositories/tasks_repository.dart';
import 'package:questkeeper/task_list/subtasks/models/subtasks_model/subtasks_model.dart';
import 'package:questkeeper/task_list/subtasks/repositories/subtasks_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentTaskProvider = ChangeNotifierProvider((ref) => CurrentTask());

class CurrentTask extends ChangeNotifier {
  Tasks? _task;
  Tasks? get task => _task;

  Categories? _category;
  Categories? get category => _category;

  List<Subtask>? _subtasksList;
  List<Subtask>? get subtasks => _subtasksList;

  final TasksRepository _repository = TasksRepository();
  final CategoriesRepository _categoriesRepository = CategoriesRepository();
  final SubtasksRepository _subtasksRepository = SubtasksRepository();

  List<Categories> _categoriesList = [];
  List<Categories> get allCategories => _categoriesList;

  bool readOnly = true;

  CurrentTask() {
    debugPrint('CurrentTask created');
    _fetchAllCategories();
  }

  Future<void> _fetchAllCategories() async {
    try {
      final result = await _categoriesRepository.getCategories();
      _categoriesList = result;
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching categories: $e');
    }
  }

  Future<void> fetchSubtasksForCurrentTask() async {
    if (_task != null) {
      try {
        final result = await _subtasksRepository.getSubtasks(_task!.id!);
        _subtasksList = result.data;
        notifyListeners();
      } catch (e) {
        debugPrint('Error fetching subtasks: $e');
      }
    }
  }

  onDispose() {
    // Update all the repositories
    TasksRepository().updateTask(_task!);
    CategoriesRepository().updateCategory(_category!);

    _task = null;
    _category = null;
    _subtasksList = [];
    _categoriesList = [];
    readOnly = true;
  }

  set task(Tasks? task) {
    _task = task;
  }

  set category(Categories? category) {
    _category = category;
  }

  setCurrentTask(Tasks? task) {
    _task = task;
    category = task?.categoryId == null
        ? null
        : _categoriesList
            .firstWhere((element) => element.id == task?.categoryId);
    notifyListeners();
  }

  updateCurrentTask(Tasks task) async {
    _task = await _repository.getTask(task.id!);
    notifyListeners();
  }

  updateTask(Tasks task) {
    // Locally update the task
    _task = task;
    notifyListeners();
  }

  updateTaskCategory(int? categoryId) async {
    if (categoryId == null || categoryId == -1) {
      _category = null;
    } else {
      _category =
          _categoriesList.firstWhere((element) => element.id == categoryId);
    }

    notifyListeners();
  }

  updateSubtask(Subtask updatedSubtask) async {
    try {
      final res = await SubtasksRepository().updateSubtask(updatedSubtask);
      if (res.success) {
        // Only update the list if the server update is successful
        final updatedIndex =
            _subtasksList!.indexWhere((e) => e.id == updatedSubtask.id);
        if (updatedIndex != -1) {
          // Check if the subtask exists
          _subtasksList![updatedIndex] = res.data as Subtask;
        }
        notifyListeners();
      } else {
        debugPrint('Error updating subtask: ${res.message}');
      }
    } catch (error) {
      debugPrint('Error updating subtask: $error');
    }
  }

  addSubtask(Subtask subtask) async {
    final result = await SubtasksRepository().createSubtask(subtask);
    _subtasksList ??= [];
    _subtasksList!.add(result.data);
    notifyListeners();
  }

  deleteSubtask(Subtask subtask) {
    _subtasksList!.removeWhere((element) => element.id == subtask.id);
    notifyListeners();

    SubtasksRepository().createSubtask(subtask);
  }
}
