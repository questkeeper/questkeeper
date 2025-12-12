import 'package:freezed_annotation/freezed_annotation.dart';

part 'subtasks_model.freezed.dart';
part 'subtasks_model.g.dart';

@freezed
abstract class Subtask with _$Subtask {
  const factory Subtask({
    int? id,
    required String title,
    @Default(1) int priority,
    @Default(false) bool completed,
    required int taskId,
  }) = _Subtask;

  factory Subtask.fromJson(Map<String, dynamic> json) =>
      _$SubtaskFromJson(json);
}
