// This file exists to abstrack the logic for multiplatform purposes.

import 'package:questkeeper/task_list/models/tasks_model.dart';

abstract class HomeWidgetInterface {
  void initHomeWidget(String appGroupId);
  void updateHomeWidget(List<Tasks> state);
}
