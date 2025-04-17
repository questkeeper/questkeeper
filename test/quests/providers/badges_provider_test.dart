// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mocktail/mocktail.dart';
// import 'package:questkeeper/quests/models/badge_model.dart';
// import 'package:questkeeper/quests/models/user_badge_model.dart';
// import 'package:questkeeper/quests/providers/badges_provider.dart';
// import 'package:questkeeper/quests/repositories/badges_repository.dart';
// import 'package:questkeeper/shared/models/return_model/return_model.dart';

// import '../../helpers/mock_helpers.dart';

// void main() {
//   late MockBadgesRepository mockRepository;
//   late ProviderContainer container;

//   setUp(() {
//     mockRepository = MockBadgesRepository();

//     // Create a provider that returns our test implementation
//     final testProvider = Provider<BadgesRepository>((ref) => mockRepository);

//     // Setup the provider container with overrides
//     container = ProviderContainer(
//       overrides: [
//         // Override the provider to use our test provider
//         badgesManagerProvider
//             .overrideWith(() => TestBadgesManager(mockRepository)),
//       ],
//     );

//     // Required for Riverpod to properly dispose providers between tests
//     addTearDown(container.dispose);
//   });

//   group('BadgesManager Provider', () {
//     test('initial state is loading', () {
//       expect(container.read(badgesManagerProvider), isA<AsyncLoading>());
//     });

//     test('fetchBadges success should update state with badges and user badges',
//         () async {
//       // Arrange
//       when(() => mockRepository.getBadges())
//           .thenAnswer((_) async => testBadges);
//       when(() => mockRepository.getUserBadges())
//           .thenAnswer((_) async => testUserBadges);

//       // Act - get the provider and wait for it to load
//       final future = container.read(badgesManagerProvider.future);

//       // Assert
//       final result = await future;

//       expect(result, isA<(List<Badge>, List<UserBadge>)>());
//       expect(result.$1, testBadges);
//       expect(result.$2, testUserBadges);

//       // Verify calls to the repository
//       verify(() => mockRepository.getBadges()).called(1);
//       verify(() => mockRepository.getUserBadges()).called(1);
//     });

//     test('fetchBadges failure should set error state', () async {
//       // Arrange
//       final error = Exception('Failed to fetch badges');
//       when(() => mockRepository.getBadges()).thenThrow(error);

//       // Act - get the provider and wait for it to complete
//       final future = container.read(badgesManagerProvider.future);

//       // Assert
//       expect(future, throwsA(isA<Exception>()));

//       // Wait for the provider to settle
//       await expectLater(
//           container.read(badgesManagerProvider), isA<AsyncError>());
//     });

//     test('refreshBadges should update state with new badges data', () async {
//       // Arrange
//       when(() => mockRepository.getBadges())
//           .thenAnswer((_) async => testBadges);
//       when(() => mockRepository.getUserBadges())
//           .thenAnswer((_) async => testUserBadges);

//       // Act - wait for the initial load
//       await container.read(badgesManagerProvider.future);

//       // Update the mock to return different badges
//       final updatedBadges = [
//         Badge(
//           id: 'badge3',
//           name: 'New Badge',
//           description: 'New badge for testing',
//           points: 300,
//           requirementCount: 5,
//           category: 'testing',
//           tier: 3,
//           resetMonthly: true,
//         ),
//       ];

//       when(() => mockRepository.getBadges())
//           .thenAnswer((_) async => updatedBadges);

//       // Call refresh
//       await container.read(badgesManagerProvider.notifier).refreshBadges();

//       // Assert
//       final result = container.read(badgesManagerProvider).valueOrNull;
//       expect(result, isNotNull);
//       expect(result!.$1, updatedBadges);

//       // Verify repository calls - called once during setup and once during refresh
//       verify(() => mockRepository.getBadges()).called(2);
//       verify(() => mockRepository.getUserBadges()).called(2);
//     });

//     test('redeemBadge should update user badge to redeemed', () async {
//       // Arrange - setup initial state
//       when(() => mockRepository.getBadges())
//           .thenAnswer((_) async => testBadges);
//       when(() => mockRepository.getUserBadges())
//           .thenAnswer((_) async => testUserBadges);

//       // Success response for redeeming
//       when(() => mockRepository.redeemBadge(any())).thenAnswer(
//         (_) async => mockSuccessReturnModel,
//       );

//       // Wait for the initial load
//       await container.read(badgesManagerProvider.future);

//       // Act - redeem the badge
//       await container
//           .read(badgesManagerProvider.notifier)
//           .redeemBadge(testUserBadges[1].id);

//       // Assert
//       final result = container.read(badgesManagerProvider).valueOrNull;
//       expect(result, isNotNull);

//       // The second badge should now be redeemed
//       final updatedUserBadges = result!.$2;
//       expect(updatedUserBadges[1].redeemed, true);

//       // The first badge should remain unchanged
//       expect(updatedUserBadges[0], testUserBadges[0]);

//       // Verify the repository call
//       verify(() => mockRepository.redeemBadge(testUserBadges[1].id)).called(1);
//     });

//     test('redeemBadge should handle failure', () async {
//       // Arrange - setup initial state
//       when(() => mockRepository.getBadges())
//           .thenAnswer((_) async => testBadges);
//       when(() => mockRepository.getUserBadges())
//           .thenAnswer((_) async => testUserBadges);

//       // Failure response for redeeming
//       when(() => mockRepository.redeemBadge(any())).thenAnswer(
//         (_) async => mockFailureReturnModel,
//       );

//       // Wait for the initial load
//       await container.read(badgesManagerProvider.future);

//       // Act - attempt to redeem the badge
//       await container
//           .read(badgesManagerProvider.notifier)
//           .redeemBadge(testUserBadges[1].id);

//       // Assert
//       final state = container.read(badgesManagerProvider);
//       expect(state, isA<AsyncError>());
//       expect(state.error, 'Failed to redeem badge');

//       // Verify the repository call
//       verify(() => mockRepository.redeemBadge(testUserBadges[1].id)).called(1);
//     });
//   });
// }

// // Test implementation of BadgesManager that uses the mock repository
// class TestBadgesManager extends BadgesManager {
//   final BadgesRepository _mockRepository;

//   TestBadgesManager(this._mockRepository);

//   @override
//   BadgesRepository get _repository => _mockRepository;
// }
