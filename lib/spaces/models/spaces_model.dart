import 'package:freezed_annotation/freezed_annotation.dart';

part 'spaces_model.freezed.dart';
part 'spaces_model.g.dart';

@freezed
abstract class Spaces with _$Spaces {
  const factory Spaces({
    int? id,
    required String title,
    DateTime? updatedAt,
    required String spaceType,
    required Map<String, List<int>> notificationTimes,
  }) = _Spaces;

  factory Spaces.fromJson(Map<String, dynamic> json) => _$SpacesFromJson(json);
}
