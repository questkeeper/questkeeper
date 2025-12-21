import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:questkeeper/shared/utils/shared_preferences_manager.dart';

class CategoryCollapseState extends AsyncNotifier<Map<int, bool>> {
  static final SharedPreferencesManager prefs =
      SharedPreferencesManager.instance;

  @override
  Future<Map<int, bool>> build() async {
    return _loadState();
  }

  Future<Map<int, bool>> _loadState() async {
    try {
      final savedState = prefs.getStringList('categoryCollapseStateIds');
      if (savedState != null) {
        final collapsedState = savedState.map((e) => int.parse(e)).toList();
        return {
          for (final id in collapsedState) id: true,
        };
      } else {
        return {};
      }
    } catch (e) {
      rethrow;
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
    AsyncNotifierProvider.autoDispose<CategoryCollapseState, Map<int, bool>>(
        CategoryCollapseState.new);
