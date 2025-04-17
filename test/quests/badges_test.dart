import 'package:flutter_test/flutter_test.dart';

import 'models/badge_model_test.dart' as badge_model_test;
import 'models/user_badge_model_test.dart' as user_badge_model_test;
// import 'providers/badges_provider_test.dart' as badges_provider_test;
// import 'repositories/badges_repository_test.dart' as badges_repository_test;
// import 'widgets/achievement_list_test.dart' as achievement_list_test;

void main() {
  group('Badge Model Tests', badge_model_test.main);
  group('UserBadge Model Tests', user_badge_model_test.main);
  // group('BadgesRepository Tests', badges_repository_test.main);
  // group('BadgesManager Provider Tests', badges_provider_test.main);
  // group('AchievementList Widget Tests', achievement_list_test.main);
}
