import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:questkeeper/shared/utils/shared_preferences_manager.dart';

class CategoryCollapseState extends StateNotifier<AsyncValue<Map<int, bool>>> {
  static final SharedPreferencesManager prefs =
      SharedPreferencesManager.instance;

  CategoryCollapseState() : super(const AsyncValue.loading()) {
    loadState();
  }

  Future<void> loadState() async {
    state = const AsyncValue.loading();
    try {
      final savedState = prefs.getStringList('categoryCollapseStateIds');
      if (savedState != null) {
        final collapsedState = savedState.map((e) => int.parse(e)).toList();
        final newState = {
          for (final id in collapsedState) id: true,
        };
        state = AsyncValue.data(newState);
      } else {
        state = const AsyncValue.data({});
      }
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  void toggleCategory(int categoryId) {
    state.whenData((currentState) {
      final newState = Map<int, bool>.from(currentState);
      newState[categoryId] = !(newState[categoryId] ?? false);
      state = AsyncValue.data(newState);
      _saveState();
    });
  }

  Future<void> _saveState() async {
    state.whenData((currentState) async {
      final collapsedState = currentState.entries
          .where((element) => element.value == true)
          .map((e) => e.key)
          .toList();
      await prefs.setStringList('categoryCollapseStateIds',
          collapsedState.map((e) => e.toString()).toList());
    });
  }
}

final categoryCollapseStateProvider =
    StateNotifierProvider<CategoryCollapseState, AsyncValue<Map<int, bool>>>(
        (ref) {
  return CategoryCollapseState();
});
