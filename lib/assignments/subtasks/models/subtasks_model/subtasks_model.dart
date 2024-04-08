import 'package:freezed_annotation/freezed_annotation.dart';

part 'subtasks_model.freezed.dart';
part 'subtasks_model.g.dart';

@freezed
class Subtask with _$Subtask {
  const factory Subtask({
    int? id,
    required DateTime createdAt,
    required DateTime updatedAt,
    required String title,
    required int assignmentId,
    int? priority,
    @Default(false) bool completed,
  }) = _Subtask;

  factory Subtask.fromJson(Map<String, dynamic> json) =>
      _$SubtaskFromJson(json);
}
