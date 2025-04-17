// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Badge {
  final String id;
  final String name;
  final String description;
  final int points;
  final int requirementCount;
  final String category;
  final int tier;
  final bool resetMonthly;

  Badge({
    required this.id,
    required this.name,
    required this.description,
    required this.points,
    required this.requirementCount,
    required this.category,
    required this.tier,
    required this.resetMonthly,
  });

  Badge copyWith({
    String? id,
    String? name,
    String? description,
    int? points,
    int? requirementCount,
    String? category,
    int? tier,
    bool? resetMonthly,
  }) {
    return Badge(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      points: points ?? this.points,
      requirementCount: requirementCount ?? this.requirementCount,
      category: category ?? this.category,
      tier: tier ?? this.tier,
      resetMonthly: resetMonthly ?? this.resetMonthly,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'points': points,
      'requirementCount': requirementCount,
      'category': category,
      'tier': tier,
      'resetMonthly': resetMonthly,
    };
  }

  factory Badge.fromMap(Map<String, dynamic> map) {
    return Badge(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      points: map['points'] as int,
      requirementCount: map['requirementCount'] as int,
      category: map['category'] as String,
      tier: map['tier'] as int,
      resetMonthly: map['resetMonthly'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory Badge.fromJson(String source) =>
      Badge.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Badge(id: $id, name: $name, description: $description, points: $points, requirementCount: $requirementCount, category: $category, tier: $tier, resetMonthly: $resetMonthly)';
  }

  @override
  bool operator ==(covariant Badge other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.description == description &&
        other.points == points &&
        other.requirementCount == requirementCount &&
        other.category == category &&
        other.tier == tier &&
        other.resetMonthly == resetMonthly;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        description.hashCode ^
        points.hashCode ^
        requirementCount.hashCode ^
        category.hashCode ^
        tier.hashCode ^
        resetMonthly.hashCode;
  }
}
