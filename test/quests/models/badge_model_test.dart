import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:questkeeper/quests/models/badge_model.dart';

void main() {
  // Test badges
  final testBadge = Badge(
    id: 'badge1',
    name: 'First Task',
    description: 'Complete your first task',
    points: 100,
    requirementCount: 1,
    category: 'beginner',
    tier: 1,
    resetMonthly: false,
  );

  group('Badge Model', () {
    test('should create a Badge instance with correct values', () {
      // Assert all fields have correct values
      expect(testBadge.id, 'badge1');
      expect(testBadge.name, 'First Task');
      expect(testBadge.description, 'Complete your first task');
      expect(testBadge.points, 100);
      expect(testBadge.requirementCount, 1);
      expect(testBadge.category, 'beginner');
      expect(testBadge.tier, 1);
      expect(testBadge.resetMonthly, false);
    });

    test('copyWith should return a new instance with updated values', () {
      final updatedBadge = testBadge.copyWith(
        name: 'New Name',
        points: 200,
        resetMonthly: true,
      );

      // Assert fields that were changed are updated
      expect(updatedBadge.name, 'New Name');
      expect(updatedBadge.points, 200);
      expect(updatedBadge.resetMonthly, true);

      // Assert fields that weren't changed remain the same
      expect(updatedBadge.id, testBadge.id);
      expect(updatedBadge.description, testBadge.description);
      expect(updatedBadge.requirementCount, testBadge.requirementCount);
      expect(updatedBadge.category, testBadge.category);
      expect(updatedBadge.tier, testBadge.tier);

      // Assert original is not modified
      expect(testBadge.name, 'First Task');
      expect(testBadge.points, 100);
      expect(testBadge.resetMonthly, false);
    });

    test('toMap should convert Badge to a Map correctly', () {
      final map = testBadge.toJson();

      expect(map, {
        'id': 'badge1',
        'name': 'First Task',
        'description': 'Complete your first task',
        'points': 100,
        'requirementCount': 1,
        'category': 'beginner',
        'tier': 1,
        'resetMonthly': false,
      });
    });

    test('fromMap should create Badge from Map correctly', () {
      final map = {
        'id': 'badge1',
        'name': 'First Task',
        'description': 'Complete your first task',
        'points': 100,
        'requirementCount': 1,
        'category': 'beginner',
        'tier': 1,
        'resetMonthly': false,
      };

      final badge = Badge.fromJson(map);

      expect(badge.id, 'badge1');
      expect(badge.name, 'First Task');
      expect(badge.description, 'Complete your first task');
      expect(badge.points, 100);
      expect(badge.requirementCount, 1);
      expect(badge.category, 'beginner');
      expect(badge.tier, 1);
      expect(badge.resetMonthly, false);
    });

    test('toJson should convert Badge to JSON string correctly', () {
      final jsonString = testBadge.toJson();
      final decodedJson = json.encode(jsonString);

      expect(decodedJson, {
        'id': 'badge1',
        'name': 'First Task',
        'description': 'Complete your first task',
        'points': 100,
        'requirementCount': 1,
        'category': 'beginner',
        'tier': 1,
        'resetMonthly': false,
      });
    });

    test('fromJson should create Badge from JSON string correctly', () {
      final jsonString = json.encode({
        'id': 'badge1',
        'name': 'First Task',
        'description': 'Complete your first task',
        'points': 100,
        'requirementCount': 1,
        'category': 'beginner',
        'tier': 1,
        'resetMonthly': false,
      });

      final badge = Badge.fromJson(jsonDecode(jsonString));

      expect(badge.id, 'badge1');
      expect(badge.name, 'First Task');
      expect(badge.description, 'Complete your first task');
      expect(badge.points, 100);
      expect(badge.requirementCount, 1);
      expect(badge.category, 'beginner');
      expect(badge.tier, 1);
      expect(badge.resetMonthly, false);
    });

    test('equals should compare Badge objects correctly', () {
      final sameBadge = Badge(
        id: 'badge1',
        name: 'First Task',
        description: 'Complete your first task',
        points: 100,
        requirementCount: 1,
        category: 'beginner',
        tier: 1,
        resetMonthly: false,
      );

      final differentBadge = Badge(
        id: 'badge2',
        name: 'Different Task',
        description: 'Complete your first task',
        points: 100,
        requirementCount: 1,
        category: 'beginner',
        tier: 1,
        resetMonthly: false,
      );

      expect(testBadge == sameBadge, true);
      expect(testBadge == differentBadge, false);
    });

    test('hashCode should be consistent with equals', () {
      final sameBadge = Badge(
        id: 'badge1',
        name: 'First Task',
        description: 'Complete your first task',
        points: 100,
        requirementCount: 1,
        category: 'beginner',
        tier: 1,
        resetMonthly: false,
      );

      expect(testBadge.hashCode, sameBadge.hashCode);
    });
  });
}
