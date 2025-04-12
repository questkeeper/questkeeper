import 'package:questkeeper/quests/models/badge_model.dart';
import 'package:questkeeper/quests/models/user_badge_model.dart';
import 'package:questkeeper/quests/repositories/badges_repository.dart';
import 'package:questkeeper/shared/widgets/snackbar.dart';
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
      SnackbarService.showErrorSnackbar("Failed to fetch badges");
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

  Future<void> redeemBadge(int userBadgeId) async {
    try {
      // Get current state
      final currentState = state.valueOrNull;
      if (currentState == null) return;

      final (badges, userBadges) = currentState;

      // Call the API to redeem the badge
      final result = await _repository.redeemBadge(userBadgeId);

      if (result.success) {
        // Update the state with the redeemed badge
        final updatedUserBadges = userBadges.map((ub) {
          if (ub.id == userBadgeId) {
            return ub.copyWith(redeemed: true);
          }
          return ub;
        }).toList();

        state = AsyncValue.data((badges, updatedUserBadges));
      } else {
        state = AsyncValue.error(
            result.error ?? 'Unknown error', StackTrace.current);
        SnackbarService.showErrorSnackbar(result.error ?? 'Unknown error');
      }
    } catch (error) {
      state = AsyncValue.error(error, StackTrace.current);
    }
  }
}
