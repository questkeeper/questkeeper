// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserGlobalQuestContribution {
  final int id;
  final String globalQuestId;
  final int contributionValue;
  final String lastContributedAt;

  UserGlobalQuestContribution({
    required this.id,
    required this.globalQuestId,
    required this.contributionValue,
    required this.lastContributedAt,
  });

  UserGlobalQuestContribution copyWith({
    int? id,
    String? globalQuestId,
    int? contributionValue,
    String? lastContributedAt,
  }) {
    return UserGlobalQuestContribution(
      id: id ?? this.id,
      globalQuestId: globalQuestId ?? this.globalQuestId,
      contributionValue: contributionValue ?? this.contributionValue,
      lastContributedAt: lastContributedAt ?? this.lastContributedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'globalQuestId': globalQuestId,
      'contributionValue': contributionValue,
      'lastContributedAt': lastContributedAt,
    };
  }

  factory UserGlobalQuestContribution.fromMap(Map<String, dynamic> map) {
    return UserGlobalQuestContribution(
      id: map['id'] as int,
      globalQuestId: map['globalQuestId'] as String,
      contributionValue: map['contributionValue'] as int,
      lastContributedAt: map['lastContributedAt'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserGlobalQuestContribution.fromJson(String source) =>
      UserGlobalQuestContribution.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserGlobalQuestContribution(id: $id, globalQuestId: $globalQuestId, contributionValue: $contributionValue, lastContributedAt: $lastContributedAt)';
  }

  @override
  bool operator ==(covariant UserGlobalQuestContribution other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.globalQuestId == globalQuestId &&
        other.contributionValue == contributionValue &&
        other.lastContributedAt == lastContributedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        globalQuestId.hashCode ^
        contributionValue.hashCode ^
        lastContributedAt.hashCode;
  }
}
