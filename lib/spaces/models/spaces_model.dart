import 'package:assigngo_rewrite/categories/models/categories_model.dart';
import 'package:assigngo_rewrite/task_list/models/tasks_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'spaces_model.freezed.dart';
part 'spaces_model.g.dart';

@freezed
class Spaces with _$Spaces {
  const factory Spaces({
    int? id,
    required String title,
    DateTime? updatedAt,
    String? color,
    List<Tasks>? tasks,
    List<Categories>? categories,
  }) = _Spaces;

  factory Spaces.fromJson(Map<String, dynamic> json) => _$SpacesFromJson(json);
}
