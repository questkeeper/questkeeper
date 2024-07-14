import 'dart:convert';

import 'package:questkeeper/shared/utils/format_date.dart';
import 'package:questkeeper/shared/utils/home_widget/home_widget_stub.dart';
import 'package:questkeeper/task_list/models/tasks_model.dart';
import 'package:flutter/foundation.dart';
import 'package:home_widget/home_widget.dart';

class HomeWidgetMobile implements HomeWidgetInterface {
  @override
  void initHomeWidget(String appGroupId) {
    HomeWidget.setAppGroupId(appGroupId);
  }

  @override
  void updateHomeWidget(List<Tasks> state) {
    final tasksJson = state
        .where((task) => task.starred)
        .map((task) => {
              'id': task.id,
              'title': task.title,
              'description': task.description,
              'dueDate': formatDate(task.dueDate),
            })
        .toList();

    try {
      HomeWidget.saveWidgetData<String>(
          "assignments", const JsonEncoder().convert(tasksJson));

      HomeWidget.updateWidget(
        name: 'Quest Keeper',
        iOSName: 'Quest Keeper',
        androidName: 'Quest Keeper',
        qualifiedAndroidName: 'app.questkeeper',
      );
    } catch (e) {
      debugPrint("Error updating home widget: $e");
    }
  }
}
