import 'package:assigngo_rewrite/subjects/models/subjects_model.dart';
import 'package:assigngo_rewrite/subjects/repositories/subjects_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final subjectsProvider = StateNotifierProvider<SubjectsNotifier, List<Subject>>(
  (ref) => SubjectsNotifier([]),
);

class SubjectsNotifier extends StateNotifier<List<Subject>> {
  final SubjectsRepository _repository = SubjectsRepository();

  SubjectsNotifier(super._state);

  Future<void> fetchSubjects() async {
    final subjects = await _repository.getSubjects();
    state = subjects;
  }

  Future<void> createSubject(Subject subject) async {
    await _repository.createSubject(subject);

    await fetchSubjects();
  }
}
