// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:questkeeper/quests/models/quest_model.dart';

class UserQuest {
  final int id;
  final Quest quest;
  final int progress;
  final bool completed;
  final bool redeemed;
  final String? completedAt;
  final String assignedAt;

  UserQuest({
    required this.id,
    required this.quest,
    required this.progress,
    this.completed = false,
    this.redeemed = false,
    this.completedAt,
    required this.assignedAt,
  });

  UserQuest copyWith({
    int? id,
    Quest? quest,
    int? progress,
    bool? completed,
    bool? redeemed,
    String? completedAt,
    String? assignedAt,
  }) {
    return UserQuest(
      id: id ?? this.id,
      quest: quest ?? this.quest,
      progress: progress ?? this.progress,
      completed: completed ?? this.completed,
      redeemed: redeemed ?? this.redeemed,
      completedAt: completedAt ?? this.completedAt,
      assignedAt: assignedAt ?? this.assignedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'quest': quest.toMap(),
      'progress': progress,
      'completed': completed,
      'redeemed': redeemed,
      'completedAt': completedAt,
      'assignedAt': assignedAt,
    };
  }

  factory UserQuest.fromMap(Map<String, dynamic> map) {
    return UserQuest(
      id: map['id'] as int,
      quest: Quest.fromMap(map['quest'] as Map<String, dynamic>),
      progress: map['progress'] as int,
      completed: map['completed'] as bool,
      redeemed: map['redeemed'] as bool,
      completedAt:
          map['completedAt'] != null ? map['completedAt'] as String : null,
      assignedAt: map['assignedAt'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserQuest.fromJson(String source) =>
      UserQuest.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserQuest(id: $id, quest: $quest, progress: $progress, completed: $completed, redeemed: $redeemed, completedAt: $completedAt, assignedAt: $assignedAt)';
  }

  @override
  bool operator ==(covariant UserQuest other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.quest == quest &&
        other.progress == progress &&
        other.completed == completed &&
        other.redeemed == redeemed &&
        other.completedAt == completedAt &&
        other.assignedAt == assignedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        quest.hashCode ^
        progress.hashCode ^
        completed.hashCode ^
        redeemed.hashCode ^
        completedAt.hashCode ^
        assignedAt.hashCode;
  }
}
