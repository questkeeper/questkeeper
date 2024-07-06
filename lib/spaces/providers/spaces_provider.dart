import 'package:assigngo_rewrite/categories/models/categories_model.dart';
import 'package:assigngo_rewrite/categories/providers/categories_provider.dart';
import 'package:assigngo_rewrite/spaces/models/spaces_model.dart';
import 'package:assigngo_rewrite/spaces/repositories/spaces_repository.dart';
import 'package:assigngo_rewrite/task_list/models/tasks_model.dart';
import 'package:assigngo_rewrite/task_list/providers/tasks_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'spaces_provider.g.dart';

@riverpod
class SpacesManager extends _$SpacesManager {
  final SpacesRepository _repository;

  SpacesManager() : _repository = SpacesRepository();

  @override
  FutureOr<List<Spaces>> build() async {
    final categories = await ref.watch(categoriesManagerProvider.future);
    final tasks = await ref.watch(tasksManagerProvider.future);
    return fetchSpaces(categories, tasks);
  }

  Future<List<Spaces>> fetchSpaces(
      List<Categories> categories, List<Tasks> tasks) async {
    try {
      final spaces = await _repository.getSpaces();
      return _updateSpacesWithCategoriesAndTasks(spaces, categories, tasks);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      throw Exception("Error fetching spaces: $e");
    }
  }

  List<Spaces> _updateSpacesWithCategoriesAndTasks(
      List<Spaces> spaces, List<Categories> categories, List<Tasks> tasks) {
    List<Spaces> updatedSpaces = [
      ...spaces,
      const Spaces(title: "Uncategorized", id: -1)
    ];

    return updatedSpaces.map((space) {
      final spaceCategories = categories
          .where((category) => category.spaceId == null
              ? space.id == -1
              : category.spaceId == space.id)
          .map((category) {
        final categoryTasks = tasks
            .where((task) =>
                task.categoryId == category.id &&
                (task.spaceId == null
                    ? space.id == -1
                    : task.spaceId == space.id))
            .toList();
        return category.copyWith(tasks: categoryTasks);
      }).toList();

      final uncategorizedTasks = tasks
          .where((task) =>
              task.categoryId == null &&
              (task.spaceId == null
                  ? space.id == -1
                  : task.spaceId == space.id))
          .toList();

      return space.copyWith(
          categories: spaceCategories, tasks: uncategorizedTasks);
    }).toList();
  }

  void updateTaskInSpace(Tasks updatedTask) {
    state.whenData((spaces) {
      final updatedSpaces = spaces.map((space) {
        if (space.id != updatedTask.spaceId && space.id != -1) {
          return space; // Skip spaces that don't contain the updated task
        }

        final updatedCategories = space.categories?.map((category) {
          if (category.id != updatedTask.categoryId) {
            return category; // Skip categories that don't contain the updated task
          }

          final updatedTasks = category.tasks?.map((task) {
            return task.id == updatedTask.id ? updatedTask : task;
          }).toList();
          return category.copyWith(tasks: updatedTasks);
        }).toList();

        final updatedUncategorizedTasks = space.tasks?.map((task) {
          return task.id == updatedTask.id ? updatedTask : task;
        }).toList();

        return space.copyWith(
          categories: updatedCategories,
          tasks: updatedUncategorizedTasks,
        );
      }).toList();

      state = AsyncValue.data(updatedSpaces);
    });
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

  Future<void> refreshSpaces() async {
    state = const AsyncValue.loading();
    try {
      state = AsyncValue.data(await ref.refresh(spacesManagerProvider.future));
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}
