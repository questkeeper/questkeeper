import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:questkeeper/quests/models/quest_model.dart';

part 'user_quest_model.freezed.dart';
part 'user_quest_model.g.dart';

@freezed
abstract class UserQuest with _$UserQuest {
  const factory UserQuest({
    required int id,
    required Quest quest,
    required int progress,
    @Default(false) bool completed,
    @Default(false) bool redeemed,
    String? completedAt,
    required String assignedAt,
  }) = _UserQuest;

  factory UserQuest.fromJson(Map<String, dynamic> json) =>
      _$UserQuestFromJson(json);
}
