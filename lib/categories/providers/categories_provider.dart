import 'package:questkeeper/categories/models/categories_model.dart';
import 'package:questkeeper/categories/repositories/categories_repository.dart';
import 'package:questkeeper/shared/utils/undo_manager_mixin.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'categories_provider.g.dart';

@riverpod
class CategoriesManager extends _$CategoriesManager
    with UndoManagerMixin<List<Categories>> {
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
      final createCategoryReturn = await _repository.createCategory(category);
      state = AsyncValue.data([
        ...state.value ?? [],
        Categories.fromJson(createCategoryReturn.data)
      ]);
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
    performActionWithUndo(
      UndoAction(
        previousState: state.value!,
        newState:
            state.value!.where((element) => element.id != category.id).toList(),
        repositoryAction: () async {
          await _repository.deleteCategory(category);
        },
        successMessage: "Category deleted",
        timing: ActionTiming.afterUndoPeriod,
      ),
    );
  }
}
