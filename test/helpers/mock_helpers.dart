import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:questkeeper/quests/models/badge_model.dart' as models;
import 'package:questkeeper/quests/models/user_badge_model.dart';
import 'package:questkeeper/quests/repositories/badges_repository.dart';
import 'package:questkeeper/shared/models/return_model/return_model.dart';
import 'package:questkeeper/shared/utils/http_service.dart';

// Mock classes
class MockBadgesRepository extends Mock implements BadgesRepository {}

class MockHttpService extends Mock implements HttpService {}

// Test badge data
final testBadges = [
  models.Badge(
    id: 'badge1',
    name: 'First Task',
    description: 'Complete your first task',
    points: 100,
    requirementCount: 1,
    category: 'beginner',
    tier: 1,
    resetMonthly: false,
  ),
  models.Badge(
    id: 'badge2',
    name: 'Task Master',
    description: 'Complete 10 tasks',
    points: 200,
    requirementCount: 10,
    category: 'tasks',
    tier: 2,
    resetMonthly: true,
  ),
];

// Test user badge data
final testUserBadges = [
  UserBadge(
    id: 1,
    progress: 1,
    monthYear: '8-2023',
    badge: testBadges[0],
    redeemed: true,
    earnedAt: '2023-08-15T10:00:00.000Z',
    redemptionCount: 1,
  ),
  UserBadge(
    id: 2,
    progress: 5,
    monthYear: '8-2023',
    badge: testBadges[1],
    redeemed: false,
    earnedAt: null,
    redemptionCount: 0,
  ),
];

// Helper to wrap widgets with necessary providers for testing
class TestProviderScope extends StatelessWidget {
  final Widget child;
  final List<Override> overrides;

  const TestProviderScope({
    Key? key,
    required this.child,
    this.overrides = const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: overrides,
      child: MaterialApp(
        home: Scaffold(body: child),
      ),
    );
  }
}

// Mock ReturnModel for badge redemption
final mockSuccessReturnModel = ReturnModel(
  data: {'pointsAwarded': 100, 'success': true},
  message: '100',
  success: true,
  error: null,
);

final mockFailureReturnModel = ReturnModel(
  data: {'success': false, 'error': 'Failed to redeem badge'},
  message: 'Failed to redeem badge',
  success: false,
  error: 'Failed to redeem badge',
);
