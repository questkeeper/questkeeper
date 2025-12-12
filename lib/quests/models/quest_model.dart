import 'package:freezed_annotation/freezed_annotation.dart';

part 'quest_model.freezed.dart';
part 'quest_model.g.dart';

@freezed
abstract class Quest with _$Quest {
  const factory Quest({
    required String id,
    required String title,
    required String description,
    required int points,
    required int requirementCount,
    required String category,
    required String type,
  }) = _Quest;

  factory Quest.fromJson(Map<String, dynamic> json) => _$QuestFromJson(json);
}
