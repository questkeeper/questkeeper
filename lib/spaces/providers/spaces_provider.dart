import 'package:questkeeper/categories/models/categories_model.dart';
import 'package:questkeeper/categories/providers/categories_provider.dart';
import 'package:questkeeper/shared/utils/undo_manager_mixin.dart';
import 'package:questkeeper/spaces/models/spaces_model.dart';
import 'package:questkeeper/spaces/repositories/spaces_repository.dart';
import 'package:questkeeper/task_list/providers/tasks_provider.dart';
import 'package:questkeeper/task_list/models/tasks_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'spaces_provider.g.dart';

@riverpod
class SpacesManager extends _$SpacesManager
    with UndoManagerMixin<List<Spaces>> {
  final SpacesRepository _repository;

  SpacesManager() : _repository = SpacesRepository();

  bool _hasUnassignedTasksOrCategories(AsyncValue<List<Tasks>> tasksState,
      AsyncValue<List<Categories>> categoriesState) {
    if (tasksState case AsyncData(value: final tasks)) {
      return tasks.any((task) => task.spaceId == null);
    }
    if (categoriesState case AsyncData(value: final categories)) {
      return categories.any((category) => category.spaceId == null);
    }
    return false;
  }

  @override
  FutureOr<List<Spaces>> build() async {
    // Watch tasks provider to automatically update when tasks change
    ref.watch(tasksManagerProvider);
    return fetchSpaces();
  }

  Future<List<Spaces>> fetchSpaces() async {
    try {
      final spaces = await _repository.getSpaces();

      // Check unassigned tasks from the tasks provider state
      final tasksState = ref.read(tasksManagerProvider);
      final categoriesState = ref.read(categoriesManagerProvider);
      if (_hasUnassignedTasksOrCategories(tasksState, categoriesState) ||
          spaces.isEmpty) {
        const defaultNotificationTimes = {
          "standard": [12, 24],
          "prioritized": [48],
        };
        spaces.add(Spaces(
          title: "Unassigned",
          id: null,
          spaceType: "office",
          notificationTimes: defaultNotificationTimes,
        ));
      }

      return spaces;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      throw Exception("Error fetching spaces: $e");
    }
  }

  Future<void> createSpace(Spaces space) async {
    state = const AsyncValue.loading();
    try {
      await _repository.createSpace(space);
      await refreshSpaces();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> updateSpace(Spaces space) async {
    state = const AsyncValue.loading();
    try {
      await _repository.updateSpace(space);
      await refreshSpaces();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> deleteSpace(Spaces space) async {
    performActionWithUndo(
      UndoAction(
        previousState: state.value!,
        newState:
            state.value!.where((element) => element.id != space.id).toList(),
        repositoryAction: () async {
          await _repository.deleteSpace(space);
          await refreshSpaces();
        },
        successMessage: "Space deleted",
        timing: ActionTiming.afterUndoPeriod,
        postUndoAction: () async {
          await refreshSpaces();
        },
      ),
    );
  }

  Future<void> refreshSpaces() async {
    state = const AsyncValue.loading();
    try {
      state = AsyncValue.data(await ref.refresh(spacesManagerProvider.future));
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}
