import 'package:assigngo_rewrite/categories/providers/categories_provider.dart';
import 'package:assigngo_rewrite/spaces/models/spaces_model.dart';
import 'package:assigngo_rewrite/spaces/repositories/spaces_repository.dart';
import 'package:assigngo_rewrite/task_list/providers/tasks_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'spaces_provider.g.dart';

@riverpod
class SpacesManager extends _$SpacesManager {
  late final SpacesRepository _repository;

  @override
  FutureOr<List<Spaces>> build() {
    _repository = SpacesRepository();
    return fetchSpaces();
  }

  Future<List<Spaces>> fetchSpaces() async {
    try {
      final spaces = await _repository.getSpaces();
      final categories = ref.read(categoriesProvider);
      final tasks = ref.read(tasksProvider);

      List<Spaces> updatedSpaces = [...spaces];

      // Add special spaces
      updatedSpaces.addAll([
        const Spaces(title: "Uncategorized", id: -1),
        const Spaces(title: "Create New Space", id: -2)
      ]);

      updatedSpaces = updatedSpaces.map((space) {
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
          categories: spaceCategories,
          tasks: uncategorizedTasks,
        );
      }).toList();

      return updatedSpaces;
    } catch (e) {
      throw Exception("Error fetching spaces: $e");
    }
  }

  Future<void> createSpace(Spaces space) async {
    state = const AsyncValue.loading();
    try {
      await _repository.createSpace(space);
      state = AsyncValue.data(await fetchSpaces());
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> updateSpace(Spaces space) async {
    state = const AsyncValue.loading();
    try {
      await _repository.updateSpace(space);
      state = AsyncValue.data(await fetchSpaces());
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> refreshSpaces() async {
    state = const AsyncValue.loading();
    try {
      final updatedSpaces = await fetchSpaces();
      state = AsyncValue.data(updatedSpaces);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}
