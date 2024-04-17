import 'package:freezed_annotation/freezed_annotation.dart';

part 'subtasks_model.freezed.dart';
part 'subtasks_model.g.dart';

@freezed
class Subtask with _$Subtask {
  const factory Subtask({
    required String $id,
    required String title,
    @Default(1) int priority,
    @Default(false) bool completed,
  }) = _Subtask;

  factory Subtask.fromJson(Map<String, dynamic> json) =>
      _$SubtaskFromJson(json);
}
