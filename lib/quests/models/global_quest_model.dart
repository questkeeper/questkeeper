import 'package:freezed_annotation/freezed_annotation.dart';

part 'global_quest_model.freezed.dart';
part 'global_quest_model.g.dart';

@freezed
abstract class GlobalQuest with _$GlobalQuest {
  const GlobalQuest._();

  const factory GlobalQuest({
    required String id,
    required String title,
    required String description,
    required int goalValue,
    required int currentValue,
    required int participantCount,
    required int rewardPoints,
    required String startDate,
    required String endDate,
    @Default(false) bool completed,
  }) = _GlobalQuest;

  double get progress => currentValue / goalValue;

  factory GlobalQuest.fromJson(Map<String, dynamic> json) =>
      _$GlobalQuestFromJson(json);
}
