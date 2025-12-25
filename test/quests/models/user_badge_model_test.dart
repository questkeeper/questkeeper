import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:questkeeper/quests/models/badge_model.dart';
import 'package:questkeeper/quests/models/user_badge_model.dart';

void main() {
  // Test badge
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

  // Test user badge
  final testUserBadge = UserBadge(
    id: 1,
    progress: 1,
    monthYear: '8-2023',
    badge: testBadge,
    redeemed: true,
    earnedAt: '2023-08-15T10:00:00.000Z',
    redemptionCount: 1,
  );

  group('UserBadge Model', () {
    test('should create a UserBadge instance with correct values', () {
      // Assert all fields have correct values
      expect(testUserBadge.id, 1);
      expect(testUserBadge.progress, 1);
      expect(testUserBadge.monthYear, '8-2023');
      expect(testUserBadge.badge, testBadge);
      expect(testUserBadge.redeemed, true);
      expect(testUserBadge.earnedAt, '2023-08-15T10:00:00.000Z');
      expect(testUserBadge.redemptionCount, 1);
    });

    test('copyWith should return a new instance with updated values', () {
      final updatedUserBadge = testUserBadge.copyWith(
        progress: 2,
        redeemed: false,
        redemptionCount: 2,
      );

      // Assert fields that were changed are updated
      expect(updatedUserBadge.progress, 2);
      expect(updatedUserBadge.redeemed, false);
      expect(updatedUserBadge.redemptionCount, 2);

      // Assert fields that weren't changed remain the same
      expect(updatedUserBadge.id, testUserBadge.id);
      expect(updatedUserBadge.monthYear, testUserBadge.monthYear);
      expect(updatedUserBadge.badge, testUserBadge.badge);
      expect(updatedUserBadge.earnedAt, testUserBadge.earnedAt);

      // Assert original is not modified
      expect(testUserBadge.progress, 1);
      expect(testUserBadge.redeemed, true);
      expect(testUserBadge.redemptionCount, 1);
    });

    test('toMap should convert UserBadge to a Map correctly', () {
      // weird decode -> encode is to normalize the map with nested maps
      expect(json.decode(json.encode(testUserBadge.toJson())), {
        'id': 1,
        'progress': 1,
        'monthYear': '8-2023',
        'badge': testBadge.toJson(),
        'redeemed': true,
        'earnedAt': '2023-08-15T10:00:00.000Z',
        'redemptionCount': 1,
      });
    });

    test('fromMap should create UserBadge from Map correctly', () {
      final map = {
        'id': 1,
        'progress': 1,
        'monthYear': '8-2023',
        'badge': {
          'id': 'badge1',
          'name': 'First Task',
          'description': 'Complete your first task',
          'points': 100,
          'requirementCount': 1,
          'category': 'beginner',
          'tier': 1,
          'resetMonthly': false,
        },
        'redeemed': true,
        'earnedAt': '2023-08-15T10:00:00.000Z',
        'redemptionCount': 1,
      };

      final userBadge = UserBadge.fromJson(map);

      expect(userBadge.id, 1);
      expect(userBadge.progress, 1);
      expect(userBadge.monthYear, '8-2023');
      expect(userBadge.badge.id, 'badge1');
      expect(userBadge.badge.name, 'First Task');
      expect(userBadge.redeemed, true);
      expect(userBadge.earnedAt, '2023-08-15T10:00:00.000Z');
      expect(userBadge.redemptionCount, 1);
    });

    test('toJson should convert UserBadge to JSON string correctly', () {
      final jsonString = json.encode(testUserBadge.toJson());
      final decodedJson = jsonDecode(jsonString);

      expect(decodedJson['id'], 1);
      expect(decodedJson['progress'], 1);
      expect(decodedJson['monthYear'], '8-2023');
      expect(decodedJson['badge']['id'], 'badge1');
      expect(decodedJson['redeemed'], true);
      expect(decodedJson['earnedAt'], '2023-08-15T10:00:00.000Z');
      expect(decodedJson['redemptionCount'], 1);
    });

    test('fromJson should create UserBadge from JSON string correctly', () {
      final jsonString = json.encode({
        'id': 1,
        'progress': 1,
        'monthYear': '8-2023',
        'badge': {
          'id': 'badge1',
          'name': 'First Task',
          'description': 'Complete your first task',
          'points': 100,
          'requirementCount': 1,
          'category': 'beginner',
          'tier': 1,
          'resetMonthly': false,
        },
        'redeemed': true,
        'earnedAt': '2023-08-15T10:00:00.000Z',
        'redemptionCount': 1,
      });

      final userBadge = UserBadge.fromJson(jsonDecode(jsonString));

      expect(userBadge.id, 1);
      expect(userBadge.progress, 1);
      expect(userBadge.monthYear, '8-2023');
      expect(userBadge.badge.id, 'badge1');
      expect(userBadge.badge.name, 'First Task');
      expect(userBadge.redeemed, true);
      expect(userBadge.earnedAt, '2023-08-15T10:00:00.000Z');
      expect(userBadge.redemptionCount, 1);
    });

    test('equals should compare UserBadge objects correctly', () {
      final sameUserBadge = UserBadge(
        id: 1,
        progress: 1,
        monthYear: '8-2023',
        badge: testBadge,
        redeemed: true,
        earnedAt: '2023-08-15T10:00:00.000Z',
        redemptionCount: 1,
      );

      final differentUserBadge = UserBadge(
        id: 2,
        progress: 1,
        monthYear: '8-2023',
        badge: testBadge,
        redeemed: true,
        earnedAt: '2023-08-15T10:00:00.000Z',
        redemptionCount: 1,
      );

      expect(testUserBadge == sameUserBadge, true);
      expect(testUserBadge == differentUserBadge, false);
    });

    test('hashCode should be consistent with equals', () {
      final sameUserBadge = UserBadge(
        id: 1,
        progress: 1,
        monthYear: '8-2023',
        badge: testBadge,
        redeemed: true,
        earnedAt: '2023-08-15T10:00:00.000Z',
        redemptionCount: 1,
      );

      expect(testUserBadge.hashCode, sameUserBadge.hashCode);
    });

    test('should handle null earnedAt field correctly', () {
      final userBadgeWithNullEarnedAt = UserBadge(
        id: 1,
        progress: 1,
        monthYear: '8-2023',
        badge: testBadge,
        redeemed: false,
        earnedAt: null,
        redemptionCount: 0,
      );

      expect(userBadgeWithNullEarnedAt.earnedAt, null);

      final map = userBadgeWithNullEarnedAt.toJson();
      expect(map['earnedAt'], null);

      final fromMap = UserBadge.fromJson(json.decode(json.encode(map)));
      expect(fromMap.earnedAt, null);
    });
  });
}
