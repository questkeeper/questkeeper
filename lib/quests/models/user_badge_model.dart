// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:questkeeper/quests/models/badge_model.dart';

class UserBadge {
  final int id;
  final int progress;
  final String earnedAt;
  final String monthYear;
  final Badge badge;
  UserBadge({
    required this.id,
    required this.progress,
    required this.earnedAt,
    required this.monthYear,
    required this.badge,
  });

  UserBadge copyWith({
    int? id,
    int? progress,
    String? earnedAt,
    String? monthYear,
    Badge? badge,
  }) {
    return UserBadge(
      id: id ?? this.id,
      progress: progress ?? this.progress,
      earnedAt: earnedAt ?? this.earnedAt,
      monthYear: monthYear ?? this.monthYear,
      badge: badge ?? this.badge,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'progress': progress,
      'earnedAt': earnedAt,
      'monthYear': monthYear,
      'badge': badge.toMap(),
    };
  }

  factory UserBadge.fromMap(Map<String, dynamic> map) {
    return UserBadge(
      id: map['id'] as int,
      progress: map['progress'] as int,
      earnedAt: map['earnedAt'] as String,
      monthYear: map['monthYear'] as String,
      badge: Badge.fromMap(map['badge'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserBadge.fromJson(String source) =>
      UserBadge.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserBadge(id: $id, progress: $progress, earnedAt: $earnedAt, monthYear: $monthYear, badge: $badge)';
  }

  @override
  bool operator ==(covariant UserBadge other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.progress == progress &&
        other.earnedAt == earnedAt &&
        other.monthYear == monthYear &&
        other.badge == badge;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        progress.hashCode ^
        earnedAt.hashCode ^
        monthYear.hashCode ^
        badge.hashCode;
  }
}
