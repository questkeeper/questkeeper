// TODO: This should become the standard for handling keys for local store
// It's more type safe and reliable.

/// An extensible way to start managing/adding keys for shared preferences
enum SharedPreferencesKeys {
  homeWidgetPinnedTaskId,
  homeWidgetBackgroundColor,
}

extension SharedPreferencesKeysExtension on SharedPreferencesKeys {
  /// Adds the ability to get the qualified key for this enum
  /// Uses a switch statement to determine for custom scenarios and adds
  /// backwards compatibility for my previous implementation.
  ///
  /// Example:
  /// ```dart
  /// final pinnedTaskId =
  ///   prefs.getInt(SharedPreferencesKeys.homeWidgetPinnedTaskId.key);
  /// final backgroundColorValue =
  ///   prefs.getInt(SharedPreferencesKeys.homeWidgetBackgroundColor.key);
  /// ```
  String get key => switch (this) {
        _ => toString(),
      };
}
