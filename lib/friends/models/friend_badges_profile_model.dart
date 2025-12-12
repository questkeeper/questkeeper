import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:questkeeper/quests/models/user_badge_model.dart';

part 'friend_badges_profile_model.freezed.dart';
part 'friend_badges_profile_model.g.dart';

@freezed
abstract class FriendBadgesProfileModel with _$FriendBadgesProfileModel {
  const factory FriendBadgesProfileModel({
    required List<UserBadge> badges,
    Map<String, dynamic>? stats,
  }) = _FriendBadgesProfileModel;

  factory FriendBadgesProfileModel.fromJson(Map<String, dynamic> json) =>
      _$FriendBadgesProfileModelFromJson(json);
}
