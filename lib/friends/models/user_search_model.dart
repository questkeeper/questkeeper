import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_search_model.freezed.dart';
part 'user_search_model.g.dart';

@freezed
abstract class UserSearchResult with _$UserSearchResult {
  const factory UserSearchResult({
    required String userId,
    required String username,
    String? status,
    bool? sent,
  }) = _UserSearchResult;

  factory UserSearchResult.fromJson(Map<String, dynamic> json) =>
      _$UserSearchResultFromJson(json);
}
