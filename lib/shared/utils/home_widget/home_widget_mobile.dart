import 'dart:convert';

import 'package:questkeeper/shared/utils/home_widget/home_widget_stub.dart';
import 'package:questkeeper/task_list/models/tasks_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:home_widget/home_widget.dart';

class HomeWidgetMobile implements HomeWidgetInterface {
  static const MethodChannel _channel = MethodChannel('app.questkeeper/data');

  @override
  void initHomeWidget(String appGroupId) {
    HomeWidget.setAppGroupId(appGroupId);
  }

  @override
  void updateHomeWidget(List<Tasks> state) {
    // Filter incomplete tasks and sort by due date (earliest first)
    final upcomingTasks = state.where((task) => !task.completed).toList()
      ..sort((a, b) => a.dueDate.compareTo(b.dueDate));

    // Get only the most recent/upcoming task
    final nextTask = upcomingTasks.isNotEmpty ? upcomingTasks.first : null;

    final taskJson = nextTask != null
        ? {
            'id': nextTask.id,
            'title': nextTask.title,
            'dueDate': nextTask.dueDate.toIso8601String(),
          }
        : {
            'id': 0,
            'title': 'No upcoming tasks',
            'dueDate': DateTime.now().toIso8601String(),
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
