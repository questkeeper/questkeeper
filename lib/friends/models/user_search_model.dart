// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserSearchResult {
  final String userId;
  final String username;
  final String? status;
  UserSearchResult({
    required this.userId,
    required this.username,
    this.status,
  });

  UserSearchResult copyWith({
    String? userId,
    String? username,
    String? status,
  }) {
    return UserSearchResult(
      userId: userId ?? this.userId,
      username: username ?? this.username,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'username': username,
      'status': status,
    };
  }

  factory UserSearchResult.fromMap(Map<String, dynamic> map) {
    return UserSearchResult(
      userId: map['userId'] as String,
      username: map['username'] as String,
      status: map['status'] != null ? map['status'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserSearchResult.fromJson(String source) =>
      UserSearchResult.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'UserSearchResult(userId: $userId, username: $username, status: $status)';

  @override
  bool operator ==(covariant UserSearchResult other) {
    if (identical(this, other)) return true;

    return other.userId == userId &&
        other.username == username &&
        other.status == status;
  }

  @override
  int get hashCode => userId.hashCode ^ username.hashCode ^ status.hashCode;
}
