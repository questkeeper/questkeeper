import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _tagViewEnabledKey = 'isTagViewEnabled';

final tagViewProvider = StateNotifierProvider<TagViewNotifier, bool>((ref) {
  return TagViewNotifier();
});

class TagViewNotifier extends StateNotifier<bool> {
  TagViewNotifier() : super(false) {
    _loadPreference();
  }

  Future<void> _loadPreference() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getBool(_tagViewEnabledKey) ?? false;
  }

  Future<void> toggleTagView() async {
    final prefs = await SharedPreferences.getInstance();
    state = !state;
    await prefs.setBool(_tagViewEnabledKey, state);
  }
}
