// freezed classes for assignments model

import 'package:assigngo_rewrite/subjects/models/subjects_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'assignments_model.freezed.dart';
part 'assignments_model.g.dart';

// Define categories to call with Categories.Exam, etc.
enum Categories { homework, quiz, essay, exam, project, presentation }

@freezed
class Assignment with _$Assignment {
  const factory Assignment({
    required String id,
    DateTime? $createdAt,
    DateTime? $updatedAt,
    required String title,
    required DateTime dueDate,
    String? description,
    Subject? subject,
    @Default(false) bool completed,
    @Default(false) bool starred,
    @Default([Categories.homework]) List<Categories> categories,
  }) = _Assignment;

  factory Assignment.fromJson(Map<String, dynamic> json) =>
      _$AssignmentFromJson(json);
}
