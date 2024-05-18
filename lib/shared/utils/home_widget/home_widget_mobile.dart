import 'dart:convert';

import 'package:assigngo_rewrite/shared/utils/format_date.dart';
import 'package:assigngo_rewrite/shared/utils/home_widget/home_widget_stub.dart';
import 'package:assigngo_rewrite/task_list/models/tasks_model.dart';
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
        name: 'AssignGoWidgets',
        iOSName: 'AssignGoWidgets',
        androidName: 'AssignGo',
        qualifiedAndroidName: 'dev.ishanmisra.assigngo',
      );
    } catch (e) {
      debugPrint("Error updating home widget: $e");
    }
  }
}
