import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:questkeeper/quests/models/badge_model.dart';

part 'user_badge_model.freezed.dart';
part 'user_badge_model.g.dart';

@freezed
abstract class UserBadge with _$UserBadge {
  const factory UserBadge({
    required int id,
    required int progress,
    required String monthYear,
    required Badge badge,
    @Default(false) bool redeemed,
    String? earnedAt,
    required int redemptionCount,
  }) = _UserBadge;

  factory UserBadge.fromJson(Map<String, dynamic> json) =>
      _$UserBadgeFromJson(json);
}
