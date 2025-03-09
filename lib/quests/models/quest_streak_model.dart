// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class QuestStreak {
  final int currentStreak;
  final int longestStreak;
  final String lastCompletedDate;
  final List<String> completedDates;

  QuestStreak({
    required this.currentStreak,
    required this.longestStreak,
    required this.lastCompletedDate,
    required this.completedDates,
  });

  QuestStreak copyWith({
    int? currentStreak,
    int? longestStreak,
    String? lastCompletedDate,
    List<String>? completedDates,
  }) {
    return QuestStreak(
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      lastCompletedDate: lastCompletedDate ?? this.lastCompletedDate,
      completedDates: completedDates ?? this.completedDates,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'lastCompletedDate': lastCompletedDate,
      'completedDates': completedDates,
    };
  }

  factory QuestStreak.fromMap(Map<String, dynamic> map) {
    return QuestStreak(
      currentStreak: map['currentStreak'] as int,
      longestStreak: map['longestStreak'] as int,
      lastCompletedDate: map['lastCompletedDate'] as String,
      completedDates: List<String>.from(
        (map['completedDates'] as List<String>),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory QuestStreak.fromJson(String source) =>
      QuestStreak.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'QuestStreak(currentStreak: $currentStreak, longestStreak: $longestStreak, lastCompletedDate: $lastCompletedDate, completedDates: $completedDates)';
  }

  @override
  bool operator ==(covariant QuestStreak other) {
    if (identical(this, other)) return true;

    return other.currentStreak == currentStreak &&
        other.longestStreak == longestStreak &&
        other.lastCompletedDate == lastCompletedDate &&
        listEquals(other.completedDates, completedDates);
  }

  @override
  int get hashCode {
    return currentStreak.hashCode ^
        longestStreak.hashCode ^
        lastCompletedDate.hashCode ^
        completedDates.hashCode;
  }
}
