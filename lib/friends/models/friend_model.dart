// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Friend {
  final String userId;
  final String username;
  final String points;
  Friend({
    required this.userId,
    required this.username,
    required this.points,
  });

  Friend copyWith({
    String? userId,
    String? username,
    String? points,
  }) {
    return Friend(
      userId: userId ?? this.userId,
      username: username ?? this.username,
      points: points ?? this.points,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'username': username,
      'points': points,
    };
  }

  factory Friend.fromMap(Map<String, dynamic> map) {
    return Friend(
      userId: map['userId'] as String,
      username: map['username'] as String,
      points: map['points'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Friend.fromJson(String source) =>
      Friend.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'Friend(userId: $userId, username: $username, points: $points)';

  @override
  bool operator ==(covariant Friend other) {
    if (identical(this, other)) return true;

    return other.userId == userId &&
        other.username == username &&
        other.points == points;
  }

  @override
  int get hashCode => userId.hashCode ^ username.hashCode ^ points.hashCode;
}
