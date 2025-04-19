// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:questkeeper/quests/models/user_badge_model.dart';

class FriendBadgesProfileModel {
  final List<UserBadge> badges;
  final Map<String, dynamic>? stats;

  FriendBadgesProfileModel({
    required this.badges,
    this.stats,
  });

  FriendBadgesProfileModel copyWith({
    List<UserBadge>? badges,
    Map<String, dynamic>? stats,
  }) {
    return FriendBadgesProfileModel(
      badges: badges ?? this.badges,
      stats: stats ?? this.stats,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'badges': badges.map((x) => x.toMap()).toList(),
      'stats': stats,
    };
  }

  factory FriendBadgesProfileModel.fromMap(Map<String, dynamic> map) {
    return FriendBadgesProfileModel(
      badges: List<UserBadge>.from(
        (map['badges'] as List).map<UserBadge>(
          (x) => UserBadge.fromMap(x as Map<String, dynamic>),
        ),
      ),
      stats: map['stats'] != null
          ? Map<String, dynamic>.from((map['stats'] as Map<String, dynamic>))
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory FriendBadgesProfileModel.fromJson(String source) =>
      FriendBadgesProfileModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'FriendBadgesProfileModel(badges: $badges, stats: $stats)';

  @override
  bool operator ==(covariant FriendBadgesProfileModel other) {
    if (identical(this, other)) return true;

    return listEquals(other.badges, badges) && mapEquals(other.stats, stats);
  }

  @override
  int get hashCode => badges.hashCode ^ stats.hashCode;
}
