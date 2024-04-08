// freezed classes for assignments model

import 'package:freezed_annotation/freezed_annotation.dart';

part 'assignments_model.freezed.dart';
part 'assignments_model.g.dart';

@freezed
class Assignment with _$Assignment {
  const factory Assignment({
    int? id,
    required DateTime createdAt,
    required DateTime updatedAt,
    required String title,
    required DateTime dueDate,
    String? description,
    @Default(false) bool completed,
    @Default(false) bool starred,
    @Default(false) bool deleted,
  }) = _Assignment;

  factory Assignment.fromJson(Map<String, dynamic> json) =>
      _$AssignmentFromJson(json);
}
