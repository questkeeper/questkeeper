import 'package:assigngo_rewrite/task_list/repositories/assignments_repository.dart';
import 'package:assigngo_rewrite/subjects/models/subjects_model.dart';
import 'package:assigngo_rewrite/subjects/repositories/subjects_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final subjectsProvider = StateNotifierProvider<SubjectsNotifier, List<Subject>>(
  (ref) => SubjectsNotifier([]),
);

class SubjectsNotifier extends StateNotifier<List<Subject>> {
  final SubjectsRepository _repository = SubjectsRepository();
  final AssignmentsRepository _assignmentsRepository = AssignmentsRepository();

  SubjectsNotifier(super._state);

  Future<void> fetchSubjects() async {
    final subjects = await _repository.getSubjects();
    state = subjects;
  }

  Future<void> createSubject(Subject subject) async {
    await _repository.createSubject(subject);

    await fetchSubjects();
  }

  Future<void> updateSubject(Subject subject) async {
    await _repository.updateSubject(subject);
    await fetchSubjects();
  }

  Future<void> deleteSubject(Subject subject) async {
    final result = await _repository.deleteSubject(subject);

    if (result.success) {
      state = state.where((e) => e.$id != subject.$id).toList();
      _assignmentsRepository.getAssignments();
    }
  }
}
