import 'dart:convert';

import 'package:questkeeper/shared/utils/home_widget/home_widget_stub.dart';
import 'package:questkeeper/shared/utils/shared_preferences_keys.dart';
import 'package:questkeeper/task_list/models/tasks_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home_widget/home_widget.dart';
import 'package:questkeeper/shared/utils/shared_preferences_manager.dart';

class HomeWidgetMobile implements HomeWidgetInterface {
  static const MethodChannel _channel = MethodChannel('app.questkeeper/data');

  @override
  void initHomeWidget(String appGroupId) {
    HomeWidget.setAppGroupId(appGroupId);
  }

  @override
  void updateHomeWidget(List<Tasks> state) {
    final prefs = SharedPreferencesManager.instance;

    // Get settings from SharedPreferences
    final pinnedTaskId =
        prefs.getInt(SharedPreferencesKeys.homeWidgetPinnedTaskId.key);
    final backgroundColorValue =
        prefs.getString(SharedPreferencesKeys.homeWidgetBackgroundColor.key);

    Tasks? selectedTask;

    // First, try to use the pinned task if it exists and is in the current state
    if (pinnedTaskId != null) {
      try {
        selectedTask = state.firstWhere(
          (task) => task.id == pinnedTaskId && !task.completed,
        );
        debugPrint("Using pinned task: ${selectedTask.title}");
      } catch (e) {
        debugPrint(
            "Pinned task not found or completed, falling back to next upcoming task");
        selectedTask = null;
      }
    }

    // If no pinned task or pinned task not found, use the next upcoming task
    if (selectedTask == null) {
      final upcomingTasks = state.where((task) => !task.completed).toList()
        ..sort((a, b) => a.dueDate.compareTo(b.dueDate));
      selectedTask = upcomingTasks.isNotEmpty ? upcomingTasks.first : null;
    }

    // Create task JSON data
    final taskJson = selectedTask != null
        ? {
            'id': selectedTask.id,
            'title': selectedTask.title,
            'dueDate': selectedTask.dueDate.toIso8601String(),
            'backgroundColor': backgroundColorValue,
            'isPinned': pinnedTaskId != null && selectedTask.id == pinnedTaskId,
          }
        : {
            'id': 0,
            'title': 'No upcoming tasks',
            'dueDate': DateTime.now().toIso8601String(),
            'backgroundColor': backgroundColorValue,
            'isPinned': false,
          };

    try {
      HomeWidget.saveWidgetData<String>(
          "data", const JsonEncoder().convert(taskJson));

      HomeWidget.updateWidget(
        name: 'HomeWidgets',
        iOSName: 'HomeWidgets',
        androidName: 'HomeWidgets',
        qualifiedAndroidName: 'app.questkeeper.HomeWidgets',
      );

      // Force widget refresh on iOS
      _forceWidgetRefresh();
    } catch (e) {
      debugPrint("Error updating home widget: $e");
    }
  }

  /// Force widget refresh on iOS by calling native method
  Future<void> _forceWidgetRefresh() async {
    try {
      await _channel.invokeMethod('reloadWidgets');
      debugPrint("Widget refresh triggered");
    } catch (e) {
      debugPrint("Error triggering widget refresh: $e");
    }
  }
}
