import 'package:freezed_annotation/freezed_annotation.dart';

part 'tasks_model.freezed.dart';
part 'tasks_model.g.dart';

@freezed
abstract class Tasks with _$Tasks {
  const factory Tasks({
    int? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    required String title,
    required DateTime dueDate,
    int? categoryId,
    int? spaceId,
    String? description,
    @Default(false) bool completed,
    @Default(false) bool starred,
  }) = _Tasks;

  factory Tasks.fromJson(Map<String, dynamic> json) => _$TasksFromJson(json);
}
