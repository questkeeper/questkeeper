import 'dart:convert';

import 'package:assigngo_rewrite/assignments/models/assignments_model.dart';
import 'package:assigngo_rewrite/shared/utils/format_date.dart';
import 'package:assigngo_rewrite/shared/utils/home_widget/home_widget_stub.dart';
import 'package:home_widget/home_widget.dart';

class HomeWidgetMobile implements HomeWidgetInterface {
  @override
  void initHomeWidget(String appGroupId) {
    HomeWidget.setAppGroupId(appGroupId);
  }

  @override
  void updateHomeWidget(List<Assignment> state) {
    final assignemntJson = state
        .map((assignment) => {
              'id': assignment.$id,
              'title': assignment.title,
              'description': assignment.description,
              'dueDate': formatDate(assignment.dueDate),
              'starred': assignment.starred,
            })
        .toList();

    HomeWidget.saveWidgetData<String>(
        "assignments", const JsonEncoder().convert(assignemntJson));

    HomeWidget.updateWidget(
      name: 'AssignGoWidgets',
      iOSName: 'AssignGoWidgets',
      androidName: 'AssignGo',
      qualifiedAndroidName: 'dev.ishanmisra.assigngo',
    );
  }
}
