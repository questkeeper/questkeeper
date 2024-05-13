import 'package:assigngo_rewrite/subjects/models/subjects_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'tasks_model.freezed.dart';
part 'tasks_model.g.dart';

@freezed
class Tasks with _$Tasks {
  const factory Tasks({
    int? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    required String title,
    required DateTime dueDate,
    String? description,
    Subject? subject,
    @Default(false) bool completed,
    @Default(false) bool starred,
    int? categoryId,
    int? spaceId,
  }) = _Tasks;

  factory Tasks.fromJson(Map<String, dynamic> json) => _$TasksFromJson(json);
}
