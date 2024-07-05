import 'package:assigngo_rewrite/categories/models/categories_model.dart';
import 'package:assigngo_rewrite/categories/repositories/categories_repository.dart';
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
      final categories = await _repository.getCategories();
      return categories;
    } catch (e) {
      throw Exception("Failed to fetch categories");
    }
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
    state = const AsyncLoading();
    try {
      final result = await _repository.deleteCategory(category);
      if (result.error != null) {
        throw result.error!;
      }
      state = AsyncData(await fetchCategories());
    } catch (e) {
      state = AsyncError('Failed to delete category', StackTrace.current);
    }
  }
}
