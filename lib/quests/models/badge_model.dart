import 'package:freezed_annotation/freezed_annotation.dart';

part 'badge_model.freezed.dart';
part 'badge_model.g.dart';

@freezed
abstract class Badge with _$Badge {
  const factory Badge({
    required String id,
    required String name,
    required String description,
    required int points,
    required int requirementCount,
    required String category,
    required int tier,
    required bool resetMonthly,
  }) = _Badge;

  factory Badge.fromJson(Map<String, dynamic> json) => _$BadgeFromJson(json);
}
