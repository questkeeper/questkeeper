import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:questkeeper/shared/utils/hex_color.dart';
import 'package:questkeeper/shared/utils/shared_preferences_keys.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:questkeeper/shared/utils/shared_preferences_manager.dart';
import 'package:questkeeper/task_list/providers/tasks_provider.dart';

part 'home_widget_settings_provider.g.dart';

/// Model for home widget settings
class HomeWidgetSettings {
  final int? pinnedTaskId;
  final Color? backgroundColor;

  const HomeWidgetSettings({
    this.pinnedTaskId,
    this.backgroundColor,
  });

  HomeWidgetSettings copyWith({
    int? pinnedTaskId,
    Color? backgroundColor,
    bool clearPinnedTask = false,
    bool clearBackgroundColor = false,
  }) {
    return HomeWidgetSettings(
      pinnedTaskId: clearPinnedTask ? null : pinnedTaskId ?? this.pinnedTaskId,
      backgroundColor:
          clearBackgroundColor ? null : backgroundColor ?? this.backgroundColor,
    );
  }
}

/// Provider for managing home widget settings
@riverpod
class HomeWidgetSettingsManager extends _$HomeWidgetSettingsManager {
  final prefs = SharedPreferencesManager.instance;
  @override
  HomeWidgetSettings build() {
    return _loadSettings();
  }

  /// Load settings from SharedPreferences
  HomeWidgetSettings _loadSettings() {
    final pinnedTaskId =
        prefs.getInt(SharedPreferencesKeys.homeWidgetPinnedTaskId.key);
    final backgroundColorValue =
        prefs.getString(SharedPreferencesKeys.homeWidgetBackgroundColor.key);

    Color? backgroundColor;
    if (backgroundColorValue != null) {
      backgroundColor = HexColor(backgroundColorValue);
    }

    return HomeWidgetSettings(
      pinnedTaskId: pinnedTaskId,
      backgroundColor: backgroundColor,
    );
  }

  Future<void> setPinnedTaskId(int? taskId) async {
    if (taskId != null) {
      await prefs.setInt(
          SharedPreferencesKeys.homeWidgetPinnedTaskId.key, taskId);
    } else {
      await prefs.remove(SharedPreferencesKeys.homeWidgetPinnedTaskId.key);
    }

    state = state.copyWith(pinnedTaskId: taskId);
    ref.read(tasksManagerProvider.notifier).refreshHomeWidget();
  }

  /// Update the background color
  Future<void> setBackgroundColor(Color? color) async {
    if (color != null) {
      await prefs.setString(
          SharedPreferencesKeys.homeWidgetBackgroundColor.key, "#${color.hex}");
    } else {
      await prefs.remove(SharedPreferencesKeys.homeWidgetBackgroundColor.key);
    }

    state = state.copyWith(backgroundColor: color);
    ref.read(tasksManagerProvider.notifier).refreshHomeWidget();
  }

  /// Clear the pinned task
  Future<void> clearPinnedTask() async {
    await prefs.remove(SharedPreferencesKeys.homeWidgetPinnedTaskId.key);
    state = state.copyWith(clearPinnedTask: true);
    ref.read(tasksManagerProvider.notifier).refreshHomeWidget();
  }

  /// Clear the background color
  Future<void> clearBackgroundColor() async {
    await prefs.remove(SharedPreferencesKeys.homeWidgetBackgroundColor.key);
    state = state.copyWith(clearBackgroundColor: true);
    ref.read(tasksManagerProvider.notifier).refreshHomeWidget();
  }

  /// Reset all settings to default
  Future<void> resetSettings() async {
    await clearPinnedTask();
    await clearBackgroundColor();
  }
}
