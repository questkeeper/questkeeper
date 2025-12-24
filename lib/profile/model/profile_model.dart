// ignore_for_file: non_constant_identifier_names — my poor decision to use
// snake_case and not camelCase while trying to understand
// correct conventions for db stuff

import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_model.freezed.dart';
part 'profile_model.g.dart';

@freezed
abstract class Profile with _$Profile {
  const factory Profile({
    required String user_id,
    required String username,
    required String created_at,
    required String updated_at,
    required int points,
    required bool isActive,
    required bool isPublic,
    bool? isPro,
  }) = _Profile;

  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);
}
