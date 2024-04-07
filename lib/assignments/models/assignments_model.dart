// freezed classes for assignments model

import 'package:freezed_annotation/freezed_annotation.dart';

part 'assignments_model.freezed.dart';
part 'assignments_model.g.dart';

@freezed
class Assignment with _$Assignment {
  const factory Assignment({
    required int id,
    required String title,
    required String description,
    required DateTime dueDate,
    required bool completed,
    required bool starred,
    required bool deleted,
  }) = _Assignment;

  factory Assignment.fromJson(Map<String, dynamic> json) =>
      _$AssignmentFromJson({
        ...json
          ..addAll({
            'dueDate': json['due_date'],
          })
          ..remove('due_date')
      });

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson()
          ..addAll({
            'due_date': dueDate.toIso8601String(),
          })
          ..remove('dueDate')
      };
}
