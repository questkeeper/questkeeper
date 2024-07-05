import 'package:assigngo_rewrite/categories/repositories/categories_repository.dart';
import 'package:assigngo_rewrite/spaces/models/spaces_model.dart';
import 'package:assigngo_rewrite/spaces/repositories/spaces_repository.dart';
import 'package:assigngo_rewrite/task_list/repositories/tasks_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'spaces_provider.g.dart';

@riverpod
class SpacesManager extends _$SpacesManager {
  late final SpacesRepository _repository;
  late final CategoriesRepository _categoriesRepository;
  late final TasksRepository _tasksRepository;

  @override
  FutureOr<List<Spaces>> build() {
    _repository = SpacesRepository();
    _categoriesRepository = CategoriesRepository();
    _tasksRepository = TasksRepository();
    return fetchSpaces();
  }

  Future<List<Spaces>> fetchSpaces() async {
    try {
      final spaces = await _repository.getSpaces();
      final tasks = await _tasksRepository.getTasks();
      final categories = await _categoriesRepository.getCategories();

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

      debugPrint("Spaces: $updatedSpaces");

      return updatedSpaces;
    } catch (e) {
      debugPrint("Error fetching spaces: $e");
      return [
        const Spaces(title: "Something went wrong", id: -1),
      ];
    }
  }

  Future<void> refreshSpaces() async {
    state = const AsyncValue.loading();
    state = AsyncValue.data(await fetchSpaces());
  }
}
  // Future<ReturnModel> createSpace(Spaces space) async {
  //   try {
  //     final result = await _repository.createSpace(space);
  //     _spacesList.add(result.data);

  //     return ReturnModel(
  //         data: result.data,
  //         message: "Space created successfully",
  //         success: true);
  //   } catch (e) {
  //     return ReturnModel(
  //         message: "Error creating space", success: false, error: e.toString());
  //   }
  // }

  // Future<ReturnModel> updateSpace(Spaces space) async {
  //   try {
  //     final result = await _repository.updateSpace(space);
  //     _spacesList[_spacesList
  //         .indexWhere((element) => element.id == result.data.id)] = result.data;

  //     return ReturnModel(
  //         data: result.data,
  //         message: "Space updated successfully",
  //         success: true);
  //   } catch (e) {
  //     return ReturnModel(
  //         message: "Error updating space", success: false, error: e.toString());
  //   }
  // }
