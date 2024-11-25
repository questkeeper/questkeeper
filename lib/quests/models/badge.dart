// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Badge {
  final String id;
  final String name;
  final String category;
  final String description;
  final int requirementCount;
  final String createdAt;
  final bool resetMonthly;
  final int points;
  final int tier;

  Badge({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.requirementCount,
    required this.createdAt,
    required this.resetMonthly,
    required this.points,
    required this.tier,
  });

  Badge copyWith({
    String? id,
    String? name,
    String? category,
    String? description,
    int? requirementCount,
    String? createdAt,
    bool? resetMonthly,
    int? points,
    int? tier,
  }) {
    return Badge(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      description: description ?? this.description,
      requirementCount: requirementCount ?? this.requirementCount,
      createdAt: createdAt ?? this.createdAt,
      resetMonthly: resetMonthly ?? this.resetMonthly,
      points: points ?? this.points,
      tier: tier ?? this.tier,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'category': category,
      'description': description,
      'requirementCount': requirementCount,
      'createdAt': createdAt,
      'resetMonthly': resetMonthly,
      'points': points,
      'tier': tier,
    };
  }

  factory Badge.fromMap(Map<String, dynamic> map) {
    return Badge(
      id: map['id'] as String,
      name: map['name'] as String,
      category: map['category'] as String,
      description: map['description'] as String,
      requirementCount: map['requirementCount'] as int,
      createdAt: map['createdAt'] as String,
      resetMonthly: map['resetMonthly'] as bool,
      points: map['points'] as int,
      tier: map['tier'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Badge.fromJson(String source) =>
      Badge.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Badge(id: $id, name: $name, category: $category, description: $description, requirementCount: $requirementCount, createdAt: $createdAt, resetMonthly: $resetMonthly, points: $points, tier: $tier)';
  }

  @override
  bool operator ==(covariant Badge other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.category == category &&
        other.description == description &&
        other.requirementCount == requirementCount &&
        other.createdAt == createdAt &&
        other.resetMonthly == resetMonthly &&
        other.points == points &&
        other.tier == tier;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        category.hashCode ^
        description.hashCode ^
        requirementCount.hashCode ^
        createdAt.hashCode ^
        resetMonthly.hashCode ^
        points.hashCode ^
        tier.hashCode;
  }
}
