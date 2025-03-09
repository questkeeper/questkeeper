// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class QuestStats {
  final int totalCompleted;
  final int dailyCompleted;
  final int weeklyCompleted;
  final int totalPointsEarned;
  final int currentActiveCount;
  final Map<String, int> categoryCompletion;

  QuestStats({
    required this.totalCompleted,
    required this.dailyCompleted,
    required this.weeklyCompleted,
    required this.totalPointsEarned,
    required this.currentActiveCount,
    required this.categoryCompletion,
  });

  QuestStats copyWith({
    int? totalCompleted,
    int? dailyCompleted,
    int? weeklyCompleted,
    int? totalPointsEarned,
    int? currentActiveCount,
    Map<String, int>? categoryCompletion,
  }) {
    return QuestStats(
      totalCompleted: totalCompleted ?? this.totalCompleted,
      dailyCompleted: dailyCompleted ?? this.dailyCompleted,
      weeklyCompleted: weeklyCompleted ?? this.weeklyCompleted,
      totalPointsEarned: totalPointsEarned ?? this.totalPointsEarned,
      currentActiveCount: currentActiveCount ?? this.currentActiveCount,
      categoryCompletion: categoryCompletion ?? this.categoryCompletion,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'totalCompleted': totalCompleted,
      'dailyCompleted': dailyCompleted,
      'weeklyCompleted': weeklyCompleted,
      'totalPointsEarned': totalPointsEarned,
      'currentActiveCount': currentActiveCount,
      'categoryCompletion': categoryCompletion,
    };
  }

  factory QuestStats.fromMap(Map<String, dynamic> map) {
    return QuestStats(
      totalCompleted: map['totalCompleted'] as int,
      dailyCompleted: map['dailyCompleted'] as int,
      weeklyCompleted: map['weeklyCompleted'] as int,
      totalPointsEarned: map['totalPointsEarned'] as int,
      currentActiveCount: map['currentActiveCount'] as int,
      categoryCompletion: Map<String, int>.from(
        (map['categoryCompletion'] as Map<String, int>),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory QuestStats.fromJson(String source) =>
      QuestStats.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'QuestStats(totalCompleted: $totalCompleted, dailyCompleted: $dailyCompleted, weeklyCompleted: $weeklyCompleted, totalPointsEarned: $totalPointsEarned, currentActiveCount: $currentActiveCount, categoryCompletion: $categoryCompletion)';
  }

  @override
  bool operator ==(covariant QuestStats other) {
    if (identical(this, other)) return true;

    return other.totalCompleted == totalCompleted &&
        other.dailyCompleted == dailyCompleted &&
        other.weeklyCompleted == weeklyCompleted &&
        other.totalPointsEarned == totalPointsEarned &&
        other.currentActiveCount == currentActiveCount &&
        mapEquals(other.categoryCompletion, categoryCompletion);
  }

  @override
  int get hashCode {
    return totalCompleted.hashCode ^
        dailyCompleted.hashCode ^
        weeklyCompleted.hashCode ^
        totalPointsEarned.hashCode ^
        currentActiveCount.hashCode ^
        categoryCompletion.hashCode;
  }
}
