// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Spaces {
  final int? id;
  final String title;
  final DateTime? updatedAt;
  final String spaceType;

  Spaces({
    this.id,
    required this.title,
    this.updatedAt,
    required this.spaceType,
  });

  Spaces copyWith({
    int? id,
    String? title,
    DateTime? updatedAt,
    String? spaceType,
  }) {
    return Spaces(
      id: id ?? this.id,
      title: title ?? this.title,
      updatedAt: updatedAt ?? this.updatedAt,
      spaceType: spaceType ?? this.spaceType,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'updatedAt': updatedAt?.millisecondsSinceEpoch,
      'spaceType': spaceType,
    };
  }

  factory Spaces.fromMap(Map<String, dynamic> map) {
    return Spaces(
      id: map['id'] != null ? map['id'] as int : null,
      title: map['title'] as String,
      updatedAt: map['updatedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] as int)
          : null,
      spaceType: map['spaceType'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Spaces.fromJson(String source) =>
      Spaces.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Spaces(id: $id, title: $title, updatedAt: $updatedAt, spaceType: $spaceType)';
  }

  @override
  bool operator ==(covariant Spaces other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.updatedAt == updatedAt &&
        other.spaceType == spaceType;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        updatedAt.hashCode ^
        spaceType.hashCode;
  }
}
