// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserBadge {
  final String id;
  final String userId;
  final String badgeId;
  final int progress;
  final String monthYear;
  final String earnedAt;

  UserBadge({
    required this.id,
    required this.userId,
    required this.badgeId,
    required this.progress,
    required this.monthYear,
    required this.earnedAt,
  });

  UserBadge copyWith({
    String? id,
    String? userId,
    String? badgeId,
    int? progress,
    String? monthYear,
    String? earnedAt,
  }) {
    return UserBadge(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      badgeId: badgeId ?? this.badgeId,
      progress: progress ?? this.progress,
      monthYear: monthYear ?? this.monthYear,
      earnedAt: earnedAt ?? this.earnedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'badgeId': badgeId,
      'progress': progress,
      'monthYear': monthYear,
      'earnedAt': earnedAt,
    };
  }

  factory UserBadge.fromMap(Map<String, dynamic> map) {
    return UserBadge(
      id: map['id'] as String,
      userId: map['userId'] as String,
      badgeId: map['badgeId'] as String,
      progress: map['progress'] as int,
      monthYear: map['monthYear'] as String,
      earnedAt: map['earnedAt'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserBadge.fromJson(String source) =>
      UserBadge.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserBadge(id: $id, userId: $userId, badgeId: $badgeId, progress: $progress, monthYear: $monthYear, earnedAt: $earnedAt)';
  }

  @override
  bool operator ==(covariant UserBadge other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.userId == userId &&
        other.badgeId == badgeId &&
        other.progress == progress &&
        other.monthYear == monthYear &&
        other.earnedAt == earnedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        badgeId.hashCode ^
        progress.hashCode ^
        monthYear.hashCode ^
        earnedAt.hashCode;
  }
}
