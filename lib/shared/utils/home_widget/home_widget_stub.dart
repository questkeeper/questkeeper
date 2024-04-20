// This file exists to abstrack the logic for multiplatform purposes.

import 'package:assigngo_rewrite/assignments/models/assignments_model.dart';

abstract class HomeWidgetInterface {
  void initHomeWidget(String appGroupId);
  void updateHomeWidget(List<Assignment> state);
}
