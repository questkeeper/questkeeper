import 'package:freezed_annotation/freezed_annotation.dart';

part 'categories_model.freezed.dart';
part 'categories_model.g.dart';

@freezed
class Categories with _$Categories {
  const factory Categories({
    required String id,
    required String title,
    DateTime? $createdAt,
    DateTime? $updatedAt,
    String? color,
    String? spaceId,
    @Default(false) bool archived,
  }) = _Categories;

  factory Categories.fromJson(Map<String, dynamic> json) =>
      _$CategoriesFromJson(json);
}
