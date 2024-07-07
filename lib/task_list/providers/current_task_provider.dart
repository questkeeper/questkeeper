import 'package:assigngo_rewrite/task_list/models/tasks_model.dart';
import 'package:assigngo_rewrite/task_list/providers/tasks_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentTaskIdProvider = StateProvider<int?>((ref) => null);

// Modified currentTaskProvider
final currentTaskProvider = Provider.autoDispose<AsyncValue<Tasks?>>((ref) {
  final currentId = ref.watch(currentTaskIdProvider);
  final tasksAsyncValue = ref.watch(tasksManagerProvider);

  return tasksAsyncValue.whenData((tasks) {
    return tasks.firstWhere((task) => task.id == currentId);
  });
});
