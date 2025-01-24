// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
import 'dart:convert';

class Profile {
  final String user_id;
  final String username;
  final String created_at;
  final String updated_at;
  final int points;
  final bool isActive;
  final bool isPublic;
  final bool? isPro;
  Profile({
    required this.user_id,
    required this.username,
    required this.created_at,
    required this.updated_at,
    required this.points,
    required this.isActive,
    required this.isPublic,
    this.isPro,
  });

  Profile copyWith({
    String? user_id,
    String? username,
    String? created_at,
    String? updated_at,
    int? points,
    bool? isActive,
    bool? isPublic,
    bool? isPro,
  }) {
    return Profile(
      user_id: user_id ?? this.user_id,
      username: username ?? this.username,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
      points: points ?? this.points,
      isActive: isActive ?? this.isActive,
      isPublic: isPublic ?? this.isPublic,
      isPro: isPro ?? this.isPro,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'user_id': user_id,
      'username': username,
      'created_at': created_at,
      'updated_at': updated_at,
      'points': points,
      'isActive': isActive,
      'isPublic': isPublic,
      'isPro': isPro,
    };
  }

  factory Profile.fromMap(Map<String, dynamic> map) {
    return Profile(
      user_id: map['user_id'] as String,
      username: map['username'] as String,
      created_at: map['created_at'] as String,
      updated_at: map['updated_at'] as String,
      points: map['points'] as int,
      isActive: map['isActive'] as bool,
      isPublic: map['isPublic'] as bool,
      isPro: map['isPro'] != null ? map['isPro'] as bool : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Profile.fromJson(String source) =>
      Profile.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Profile(user_id: $user_id, username: $username, created_at: $created_at, updated_at: $updated_at, points: $points, isActive: $isActive, isPublic: $isPublic, isPro: $isPro)';
  }

  @override
  bool operator ==(covariant Profile other) {
    if (identical(this, other)) return true;

    return other.user_id == user_id &&
        other.username == username &&
        other.created_at == created_at &&
        other.updated_at == updated_at &&
        other.points == points &&
        other.isActive == isActive &&
        other.isPublic == isPublic &&
        other.isPro == isPro;
  }

  @override
  int get hashCode {
    return user_id.hashCode ^
        username.hashCode ^
        created_at.hashCode ^
        updated_at.hashCode ^
        points.hashCode ^
        isActive.hashCode ^
        isPublic.hashCode ^
        isPro.hashCode;
  }
}
