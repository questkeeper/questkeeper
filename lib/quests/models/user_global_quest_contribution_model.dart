import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_global_quest_contribution_model.freezed.dart';
part 'user_global_quest_contribution_model.g.dart';

@freezed
abstract class UserGlobalQuestContribution with _$UserGlobalQuestContribution {
  const factory UserGlobalQuestContribution({
    required int id,
    required String globalQuestId,
    required int contributionValue,
    required String lastContributedAt,
  }) = _UserGlobalQuestContribution;

  factory UserGlobalQuestContribution.fromJson(Map<String, dynamic> json) =>
      _$UserGlobalQuestContributionFromJson(json);
}
