import 'package:questkeeper/categories/models/categories_model.dart';
import 'package:questkeeper/categories/repositories/categories_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'categories_provider.g.dart';

@riverpod
class CategoriesManager extends _$CategoriesManager {
  final CategoriesRepository _repository;

  CategoriesManager() : _repository = CategoriesRepository();

  @override
  FutureOr<List<Categories>> build() {
    return fetchCategories();
  }

  Future<List<Categories>> fetchCategories() async {
    try {
      return await _repository.getCategories();
    } catch (error) {
      state = AsyncValue.error(error, StackTrace.current);
      throw Exception("Failed to fetch categories: $error");
    }
  }

  Future<void> createCategory(Categories category) async {
    final oldState = state.value ?? [];
    state = const AsyncValue.loading();
    try {
      await _repository.createCategory(category);
      state = AsyncValue.data([...state.value ?? [], category]);
    } catch (error) {
      state = AsyncValue.data(oldState);
      state = AsyncValue.error(error, StackTrace.current);
    }
  }

  Future<void> updateCategory(Categories category) async {
    final oldState = state.value ?? [];
    final categoryIndex = oldState.indexWhere((c) => c.id == category.id);
    if (categoryIndex == -1) return;

    final newState = List<Categories>.from(oldState);
    newState[categoryIndex] = category;

    state = AsyncValue.data(newState);

    try {
      await _repository.updateCategory(category);
    } catch (error) {
      // Revert state
      state = AsyncValue.data(oldState);
      state = AsyncValue.error(error, StackTrace.current);
    }
  }

  Future<void> deleteCategory(Categories category) async {
    try {
      await _repository.deleteCategory(category);
      state = AsyncValue.data(
        (state.value ?? []).where((c) => c.id != category.id).toList(),
      );
    } catch (error) {
      state = AsyncValue.error(error, StackTrace.current);
    }
  }
}
