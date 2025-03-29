// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:questkeeper/quests/models/badge_model.dart';

class UserBadge {
  final int id;
  final int progress;
  final String monthYear;
  final Badge badge;
  final bool redeemed;
  final String? earnedAt;
  final int redemptionCount;

  UserBadge({
    required this.id,
    required this.progress,
    required this.monthYear,
    required this.badge,
    this.redeemed = false,
    this.earnedAt,
    required this.redemptionCount,
  });

  UserBadge copyWith({
    int? id,
    int? progress,
    String? monthYear,
    Badge? badge,
    bool? redeemed,
    String? earnedAt,
    int? redemptionCount,
  }) {
    return UserBadge(
      id: id ?? this.id,
      progress: progress ?? this.progress,
      monthYear: monthYear ?? this.monthYear,
      badge: badge ?? this.badge,
      redeemed: redeemed ?? this.redeemed,
      earnedAt: earnedAt ?? this.earnedAt,
      redemptionCount: redemptionCount ?? this.redemptionCount,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'progress': progress,
      'monthYear': monthYear,
      'badge': badge.toMap(),
      'redeemed': redeemed,
      'earnedAt': earnedAt,
      'redemptionCount': redemptionCount,
    };
  }

  factory UserBadge.fromMap(Map<String, dynamic> map) {
    return UserBadge(
      id: map['id'] as int,
      progress: map['progress'] as int,
      monthYear: map['monthYear'] as String,
      badge: Badge.fromMap(map['badge'] as Map<String, dynamic>),
      redeemed: map['redeemed'] as bool,
      earnedAt: map['earnedAt'] != null ? map['earnedAt'] as String : null,
      redemptionCount: map['redemptionCount'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserBadge.fromJson(String source) =>
      UserBadge.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserBadge(id: $id, progress: $progress, monthYear: $monthYear, badge: $badge, redeemed: $redeemed, earnedAt: $earnedAt, redemptionCount: $redemptionCount)';
  }

  @override
  bool operator ==(covariant UserBadge other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.progress == progress &&
        other.monthYear == monthYear &&
        other.badge == badge &&
        other.redeemed == redeemed &&
        other.earnedAt == earnedAt &&
        other.redemptionCount == redemptionCount;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        progress.hashCode ^
        monthYear.hashCode ^
        badge.hashCode ^
        redeemed.hashCode ^
        earnedAt.hashCode ^
        redemptionCount.hashCode;
  }
}
