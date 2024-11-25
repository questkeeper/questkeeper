import 'package:questkeeper/quests/models/badge.dart';
import 'package:questkeeper/quests/repositories/badge_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'badge_providers.g.dart';

@riverpod
class BadgeManager extends _$BadgeManager {
  final BadgeRepository _repository;

  BadgeManager() : _repository = BadgeRepository();

  @override
  FutureOr<List<Badge>> build() async {
    return fetchBadges();
  }

  Future<List<Badge>> fetchBadges() async {
    try {
      final badges = await _repository.getBadges();

      return badges;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      throw Exception("Error fetching spaces: $e");
    }
  }

  Future<void> refreshBadges() async {
    state = const AsyncValue.loading();
    try {
      state = AsyncValue.data(await ref.refresh(badgeManagerProvider.future));
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}
