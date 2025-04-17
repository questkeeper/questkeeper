// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class GlobalQuest {
  final String id;
  final String title;
  final String description;
  final int goalValue;
  final int currentValue;
  final int participantCount;
  final int rewardPoints;
  final String startDate;
  final String endDate;
  final bool completed;

  GlobalQuest({
    required this.id,
    required this.title,
    required this.description,
    required this.goalValue,
    required this.currentValue,
    required this.participantCount,
    required this.rewardPoints,
    required this.startDate,
    required this.endDate,
    this.completed = false,
  });

  double get progress => currentValue / goalValue;

  GlobalQuest copyWith({
    String? id,
    String? title,
    String? description,
    int? goalValue,
    int? currentValue,
    int? participantCount,
    int? rewardPoints,
    String? startDate,
    String? endDate,
    bool? completed,
  }) {
    return GlobalQuest(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      goalValue: goalValue ?? this.goalValue,
      currentValue: currentValue ?? this.currentValue,
      participantCount: participantCount ?? this.participantCount,
      rewardPoints: rewardPoints ?? this.rewardPoints,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      completed: completed ?? this.completed,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'goalValue': goalValue,
      'currentValue': currentValue,
      'participantCount': participantCount,
      'rewardPoints': rewardPoints,
      'startDate': startDate,
      'endDate': endDate,
      'completed': completed,
    };
  }

  factory GlobalQuest.fromMap(Map<String, dynamic> map) {
    return GlobalQuest(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      goalValue: map['goalValue'] as int,
      currentValue: map['currentValue'] as int,
      participantCount: map['participantCount'] as int,
      rewardPoints: map['rewardPoints'] as int,
      startDate: map['startDate'] as String,
      endDate: map['endDate'] as String,
      completed: map['completed'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory GlobalQuest.fromJson(String source) =>
      GlobalQuest.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'GlobalQuest(id: $id, title: $title, description: $description, goalValue: $goalValue, currentValue: $currentValue, participantCount: $participantCount, rewardPoints: $rewardPoints, startDate: $startDate, endDate: $endDate, completed: $completed)';
  }

  @override
  bool operator ==(covariant GlobalQuest other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.description == description &&
        other.goalValue == goalValue &&
        other.currentValue == currentValue &&
        other.participantCount == participantCount &&
        other.rewardPoints == rewardPoints &&
        other.startDate == startDate &&
        other.endDate == endDate &&
        other.completed == completed;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        goalValue.hashCode ^
        currentValue.hashCode ^
        participantCount.hashCode ^
        rewardPoints.hashCode ^
        startDate.hashCode ^
        endDate.hashCode ^
        completed.hashCode;
  }
}
