import 'package:questkeeper/quests/models/badge_model.dart';
import 'package:questkeeper/quests/models/user_badge_model.dart';
import 'package:questkeeper/quests/repositories/badges_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'badges_provider.g.dart';

@riverpod
class BadgesManager extends _$BadgesManager {
  final BadgesRepository _repository;

  BadgesManager() : _repository = BadgesRepository();

  @override
  FutureOr<(List<Badge>, List<UserBadge>)> build() {
    return fetchBadges();
  }

  Future<(List<Badge>, List<UserBadge>)> fetchBadges() async {
    try {
      final badges = await _repository.getBadges();
      final userBadges = await _repository.getUserBadges();
      return (badges, userBadges);
    } catch (error) {
      state = AsyncValue.error(error, StackTrace.current);
      throw Exception("Failed to fetch badges: $error");
    }
  }

  Future<void> refreshBadges() async {
    state = const AsyncValue.loading();
    try {
      final (badges, userBadges) = await fetchBadges();
      state = AsyncValue.data((badges, userBadges));
    } catch (error) {
      state = AsyncValue.error(error, StackTrace.current);
    }
  }
}
