import 'package:questkeeper/quests/models/badge_model.dart';
import 'package:questkeeper/quests/models/user_badge_model.dart';

List<(Badge, UserBadge?)> groupAchievements(
    (List<Badge> badges, List<UserBadge> userBadges) data) {
  final (badges, userBadges) = data;
  return badges.map((badge) {
    final userBadge =
        userBadges.where((ub) => ub.badge.id == badge.id).firstOrNull;
    return (badge, userBadge);
  }).toList();
}
