import 'package:assigngo_rewrite/task_list/repositories/assignments_repository.dart';
import 'package:assigngo_rewrite/categories/models/categories_model.dart';
import 'package:assigngo_rewrite/categories/repositories/categories_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final categoriesProvider =
    StateNotifierProvider<CategoriesNotifier, List<Categories>>(
  (ref) => CategoriesNotifier([]),
);

class CategoriesNotifier extends StateNotifier<List<Categories>> {
  final CategoriesRepository _repository = CategoriesRepository();
  final TasksRepository _tasksRepository = TasksRepository();

  CategoriesNotifier(super._state);

  Future<void> fetchCategories() async {
    final categories = await _repository.getCategories();
    state = categories;
  }

  Future<void> createCategory(Categories category) async {
    await _repository.createCategory(category);

    await fetchCategories();
  }

  Future<void> updateCategory(Categories category) async {
    await _repository.updateCategory(category);
    await fetchCategories();
  }

  Future<void> deleteCategory(Categories category) async {
    final result = await _repository.deleteCategory(category);

    if (result.success) {
      state = state.where((e) => e.id != category.id).toList();
      _tasksRepository.getTasks();
    }
  }
}
