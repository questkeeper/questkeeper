// freezed classes for assignments model

import 'package:freezed_annotation/freezed_annotation.dart';

part 'subjects_model.freezed.dart';
part 'subjects_model.g.dart';

@freezed
class Subject with _$Subject {
  const factory Subject({
    int? id,
    required DateTime createdAt,
    required DateTime updatedAt,
    required String name,
    required String color,
    @Default(false) bool archived,
    @Default(false) bool deleted,
  }) = _Subject;

  factory Subject.fromJson(Map<String, dynamic> json) =>
      _$SubjectFromJson(json);
}
