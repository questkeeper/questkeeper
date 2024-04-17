import 'package:assigngo_rewrite/assignments/models/assignments_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'subjects_model.freezed.dart';
part 'subjects_model.g.dart';

@freezed
class Subject with _$Subject {
  const factory Subject({
    required String $id,
    required String name,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? color,
    List<Assignment>? assignments,
    @Default(false) bool archived,
  }) = _Subject;

  factory Subject.fromJson(Map<String, dynamic> json) =>
      _$SubjectFromJson(json);
}
