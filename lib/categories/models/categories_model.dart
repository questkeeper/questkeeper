import 'package:assigngo_rewrite/task_list/models/tasks_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'categories_model.freezed.dart';
part 'categories_model.g.dart';

@freezed
class Categories with _$Categories {
  const factory Categories({
    int? id,
    required String title,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? color,
    int? spaceId,
    @Default(false) bool archived,
    List<Tasks>? tasks,
  }) = _Categories;

  factory Categories.fromJson(Map<String, dynamic> json) =>
      _$CategoriesFromJson(json);
}
