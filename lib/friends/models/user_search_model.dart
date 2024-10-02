// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserSearchResult {
  final String userId;
  final String username;
  final String? status;
  final bool? sent;
  UserSearchResult({
    required this.userId,
    required this.username,
    this.status,
    this.sent,
  });

  UserSearchResult copyWith({
    String? userId,
    String? username,
    String? status,
    bool? sent,
  }) {
    return UserSearchResult(
      userId: userId ?? this.userId,
      username: username ?? this.username,
      status: status ?? this.status,
      sent: sent ?? this.sent,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'username': username,
      'status': status,
      'sent': sent,
    };
  }

  factory UserSearchResult.fromMap(Map<String, dynamic> map) {
    return UserSearchResult(
      userId: map['userId'] as String,
      username: map['username'] as String,
      status: map['status'] != null ? map['status'] as String : null,
      sent: map['sent'] != null ? map['sent'] as bool : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserSearchResult.fromJson(String source) =>
      UserSearchResult.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserSearchResult(userId: $userId, username: $username, status: $status, sent: $sent)';
  }

  @override
  bool operator ==(covariant UserSearchResult other) {
    if (identical(this, other)) return true;

    return other.userId == userId &&
        other.username == username &&
        other.status == status &&
        other.sent == sent;
  }

  @override
  int get hashCode {
    return userId.hashCode ^
        username.hashCode ^
        status.hashCode ^
        sent.hashCode;
  }
}
