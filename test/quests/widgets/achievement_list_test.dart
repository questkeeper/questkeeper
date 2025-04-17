// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mocktail/mocktail.dart';
// import 'package:questkeeper/quests/models/badge_model.dart' as models;
// import 'package:questkeeper/quests/models/user_badge_model.dart';
// import 'package:questkeeper/quests/providers/badges_provider.dart';
// import 'package:questkeeper/quests/widgets/achievement_list.dart';

// import '../../helpers/mock_helpers.dart';

// // Mock the BadgesManager class instead of the generic AsyncNotifier
// class MockBadgesManager extends Mock implements BadgesManager {}

// void main() {
//   late MockBadgesManager mockBadgesManager;

//   setUpAll(() {
//     // Register fallback values
//     registerFallbackValue(UserBadge(
//       id: 1,
//       progress: 1,
//       monthYear: '1-2023',
//       badge: testBadges[0],
//       redemptionCount: 0,
//     ));
//   });

//   setUp(() {
//     mockBadgesManager = MockBadgesManager();
//   });

//   testWidgets('AchievementList should render loading state correctly',
//       (WidgetTester tester) async {
//     // Build a widget that displays the skeleton loading UI
//     await tester.pumpWidget(
//       MaterialApp(
//         home: Scaffold(
//           body: AchievementList(
//             achievements: [],
//             loading: true,
//           ),
//         ),
//       ),
//     );

//     // Verify loading skeleton is displayed
//     expect(find.byType(AchievementList), findsOneWidget);
//     // Skeletonizer is being used for loading state
//     expect(find.textContaining('Loading'), findsWidgets);
//   });

//   testWidgets('AchievementList should render empty state when no achievements',
//       (WidgetTester tester) async {
//     // Build widget with empty achievements
//     await tester.pumpWidget(
//       MaterialApp(
//         home: Scaffold(
//           body: AchievementList(
//             achievements: [],
//             loading: false,
//           ),
//         ),
//       ),
//     );

//     // Verify empty state is displayed
//     expect(find.text('No achievements available yet'), findsOneWidget);
//   });

//   testWidgets('AchievementList should render achievements correctly',
//       (WidgetTester tester) async {
//     // Sample achievement data
//     final achievements = [
//       (
//         testBadges[0],
//         UserBadge(
//           id: 1,
//           progress: 1,
//           monthYear: '8-2023',
//           badge: testBadges[0],
//           redeemed: true,
//           earnedAt: '2023-08-15T10:00:00.000Z',
//           redemptionCount: 1,
//         )
//       ),
//       (
//         testBadges[1],
//         UserBadge(
//           id: 2,
//           progress: 5,
//           monthYear: '8-2023',
//           badge: testBadges[1],
//           redeemed: false,
//           earnedAt: null,
//           redemptionCount: 0,
//         )
//       ),
//     ];

//     // Build widget with achievements
//     await tester.pumpWidget(
//       MaterialApp(
//         home: Scaffold(
//           body: AchievementList(
//             achievements: achievements,
//             loading: false,
//           ),
//         ),
//       ),
//     );

//     // Verify all achievements are displayed
//     expect(find.text('First Task'), findsOneWidget);
//     expect(find.text('Task Master'), findsOneWidget);
//     expect(find.text('Complete your first task'), findsOneWidget);
//     expect(find.text('Complete 10 tasks'), findsOneWidget);

//     // Verify progress states
//     expect(find.text('Completed'), findsOneWidget); // Redeemed badge
//     expect(find.text('Progress'), findsOneWidget); // Non-redeemed badge
//     expect(find.text('1/1'), findsOneWidget); // First badge progress
//     expect(find.text('5/10'), findsOneWidget); // Second badge progress

//     // Verify points are displayed
//     expect(find.text('100 points'), findsOneWidget);
//     expect(find.text('200 points'), findsOneWidget);

//     // Verify monthly badge label is displayed for the second badge
//     expect(find.text('Monthly'), findsOneWidget);
//   });

//   testWidgets(
//       'AchievementList should show redeem button for completed but unredeemed badges',
//       (WidgetTester tester) async {
//     // Sample badge that is completed but not redeemed
//     final achievements = [
//       (
//         testBadges[0],
//         UserBadge(
//           id: 1,
//           progress: 1, // Matches requirementCount but not redeemed
//           monthYear: '8-2023',
//           badge: testBadges[0],
//           redeemed: false,
//           earnedAt: null,
//           redemptionCount: 0,
//         )
//       ),
//     ];

//     // Mock the redeemBadge method
//     when(() => mockBadgesManager.redeemBadge(any())).thenAnswer((_) async {});

//     // Build app with ProviderScope to handle the badge redemption
//     await tester.pumpWidget(
//       ProviderScope(
//         overrides: [
//           // Override the provider to use our mock manager
//           badgesManagerProvider.overrideWith(() => mockBadgesManager),
//         ],
//         child: MaterialApp(
//           home: Scaffold(
//             body: AchievementList(
//               achievements: achievements,
//               loading: false,
//             ),
//           ),
//         ),
//       ),
//     );

//     // Verify redeem button is displayed
//     expect(find.text('Redeem'), findsOneWidget);
//     expect(find.byType(FilledButton), findsOneWidget);

//     // Tap the redeem button
//     await tester.tap(find.text('Redeem'));
//     await tester.pump();

//     // Verify the redeem method was called
//     verify(() => mockBadgesManager.redeemBadge(1)).called(1);
//   });

//   testWidgets('AchievementList should respect limit parameter',
//       (WidgetTester tester) async {
//     // Create more achievements than the limit
//     final achievements = List.generate(
//       5,
//       (index) => (
//         models.Badge(
//           id: 'badge_$index',
//           name: 'Badge $index',
//           description: 'Description $index',
//           points: 100 * (index + 1),
//           requirementCount: 10,
//           category: 'test',
//           tier: 1,
//           resetMonthly: false,
//         ),
//         UserBadge(
//           id: index,
//           progress: 5,
//           monthYear: '8-2023',
//           badge: models.Badge(
//             id: 'badge_$index',
//             name: 'Badge $index',
//             description: 'Description $index',
//             points: 100 * (index + 1),
//             requirementCount: 10,
//             category: 'test',
//             tier: 1,
//             resetMonthly: false,
//           ),
//           redeemed: false,
//           redemptionCount: 0,
//         )
//       ),
//     );

//     // Build widget with a limit of 3
//     await tester.pumpWidget(
//       MaterialApp(
//         home: Scaffold(
//           body: AchievementList(
//             achievements: achievements,
//             loading: false,
//             limit: 3,
//             showLimit: true,
//           ),
//         ),
//       ),
//     );

//     // Only first 3 badges should be shown
//     expect(find.text('Badge 0'), findsOneWidget);
//     expect(find.text('Badge 1'), findsOneWidget);
//     expect(find.text('Badge 2'), findsOneWidget);
//     expect(find.text('Badge 3'), findsNothing);
//     expect(find.text('Badge 4'), findsNothing);
//   });

//   testWidgets(
//       'AchievementList should display all badges when showLimit is false',
//       (WidgetTester tester) async {
//     // Create achievements
//     final achievements = List.generate(
//       5,
//       (index) => (
//         models.Badge(
//           id: 'badge_$index',
//           name: 'Badge $index',
//           description: 'Description $index',
//           points: 100 * (index + 1),
//           requirementCount: 10,
//           category: 'test',
//           tier: 1,
//           resetMonthly: false,
//         ),
//         UserBadge(
//           id: index,
//           progress: 5,
//           monthYear: '8-2023',
//           badge: models.Badge(
//             id: 'badge_$index',
//             name: 'Badge $index',
//             description: 'Description $index',
//             points: 100 * (index + 1),
//             requirementCount: 10,
//             category: 'test',
//             tier: 1,
//             resetMonthly: false,
//           ),
//           redeemed: false,
//           redemptionCount: 0,
//         )
//       ),
//     );

//     // Build widget with showLimit set to false
//     await tester.pumpWidget(
//       MaterialApp(
//         home: Scaffold(
//           body: AchievementList(
//             achievements: achievements,
//             loading: false,
//             limit: 3,
//             showLimit: false,
//           ),
//         ),
//       ),
//     );

//     // All badges should be shown
//     expect(find.text('Badge 0'), findsOneWidget);
//     expect(find.text('Badge 1'), findsOneWidget);
//     expect(find.text('Badge 2'), findsOneWidget);
//     expect(find.text('Badge 3'), findsOneWidget);
//     expect(find.text('Badge 4'), findsOneWidget);
//   });
// }
