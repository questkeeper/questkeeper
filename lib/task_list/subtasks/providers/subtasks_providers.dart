import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:questkeeper/shared/models/return_model/return_model.dart';
import 'package:questkeeper/task_list/subtasks/models/subtasks_model/subtasks_model.dart';
import 'package:questkeeper/task_list/subtasks/repositories/subtasks_repository.dart';

part 'subtasks_providers.g.dart';

@riverpod
class SubtasksManager extends _$SubtasksManager {
  final SubtasksRepository _subtasksRepository = SubtasksRepository();

  @override
  FutureOr<List<Subtask>> build() {
    return [];
  }

  Future<ReturnModel> createSubtask(Subtask subtask) async {
    state = AsyncValue.data([...state.value ?? [], subtask]);
    final result = await _subtasksRepository.createSubtask(subtask);
    if (!result.success) {
      state = AsyncValue.data((state.value ?? [])..remove(subtask));
    }
    return result;
  }

  Future<ReturnModel> createBatchSubtasks(List<Subtask> subtasks) async {
    state = AsyncValue.data([...state.value ?? [], ...subtasks]);
    final result = await _subtasksRepository.createBatchSubtasks(subtasks);
    if (!result.success) {
      state = AsyncValue.data((state.value ?? [])
        ..removeWhere((subtask) => subtasks.contains(subtask)));
    }
    return result;
  }

  Future<ReturnModel> updateSubtask(Subtask subtask) async {
    _updateSubtaskState(subtask);
    final result = await _subtasksRepository.updateSubtask(subtask);
    if (!result.success) {
      _updateSubtaskState(subtask);
    }
    return result;
  }

  Future<ReturnModel> toggleSubtaskDone(Subtask subtask) async {
    final updatedSubtask = subtask.copyWith(completed: !subtask.completed);
    _updateSubtaskState(updatedSubtask);
    final result = await _subtasksRepository.updateSubtask(updatedSubtask);
    if (!result.success) {
      _updateSubtaskState(subtask);
    }
    return result;
  }

  void _updateSubtaskState(Subtask subtask) {
    state = AsyncValue.data((state.value ?? []).map((oldSubtask) {
      if (oldSubtask.id == subtask.id) {
        return subtask;
      }
      return oldSubtask;
    }).toList());
  }
}
