// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

enum NotificationType {
  friendRequest,
  friendAccepted,
  questCompleted,
  badgeEarned,
  pointsEarned,
  nudge,
}

class Notification {
  final String message;
  final String type;
  final int id;
  final bool read;
  final bool silent;
  final int senderId;
  final int userId;

  Notification({
    required this.message,
    required this.type,
    required this.id,
    required this.read,
    required this.silent,
    required this.senderId,
    required this.userId,
  });

  Notification copyWith({
    String? message,
    String? type,
    int? id,
    bool? read,
    bool? silent,
    int? senderId,
    int? userId,
  }) {
    return Notification(
      message: message ?? this.message,
      type: type ?? this.type,
      id: id ?? this.id,
      read: read ?? this.read,
      silent: silent ?? this.silent,
      senderId: senderId ?? this.senderId,
      userId: userId ?? this.userId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'message': message,
      'type': type,
      'id': id,
      'read': read,
      'silent': silent,
      'senderId': senderId,
      'userId': userId,
    };
  }

  factory Notification.fromMap(Map<String, dynamic> map) {
    return Notification(
      message: map['message'] as String,
      type: map['type'] as String,
      id: map['id'] as int,
      read: map['read'] as bool,
      silent: map['silent'] as bool,
      senderId: map['senderId'] as int,
      userId: map['userId'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Notification.fromJson(String source) =>
      Notification.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Notification(message: $message, type: $type, id: $id, read: $read, silent: $silent, senderId: $senderId, userId: $userId)';
  }

  @override
  bool operator ==(covariant Notification other) {
    if (identical(this, other)) return true;

    return other.message == message &&
        other.type == type &&
        other.id == id &&
        other.read == read &&
        other.silent == silent &&
        other.senderId == senderId &&
        other.userId == userId;
  }

  @override
  int get hashCode {
    return message.hashCode ^
        type.hashCode ^
        id.hashCode ^
        read.hashCode ^
        silent.hashCode ^
        senderId.hashCode ^
        userId.hashCode;
  }
}
