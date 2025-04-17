// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Quest {
  final String id;
  final String title;
  final String description;
  final int points;
  final int requirementCount;
  final String category;
  final String type;

  Quest({
    required this.id,
    required this.title,
    required this.description,
    required this.points,
    required this.requirementCount,
    required this.category,
    required this.type,
  });

  Quest copyWith({
    String? id,
    String? title,
    String? description,
    int? points,
    int? requirementCount,
    String? category,
    String? type,
  }) {
    return Quest(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      points: points ?? this.points,
      requirementCount: requirementCount ?? this.requirementCount,
      category: category ?? this.category,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'points': points,
      'requirementCount': requirementCount,
      'category': category,
      'type': type,
    };
  }

  factory Quest.fromMap(Map<String, dynamic> map) {
    return Quest(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      points: map['points'] as int,
      requirementCount: map['requirementCount'] as int,
      category: map['category'] as String,
      type: map['type'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Quest.fromJson(String source) =>
      Quest.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Quest(id: $id, title: $title, description: $description, points: $points, requirementCount: $requirementCount, category: $category, type: $type)';
  }

  @override
  bool operator ==(covariant Quest other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.description == description &&
        other.points == points &&
        other.requirementCount == requirementCount &&
        other.category == category &&
        other.type == type;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        points.hashCode ^
        requirementCount.hashCode ^
        category.hashCode ^
        type.hashCode;
  }
}
