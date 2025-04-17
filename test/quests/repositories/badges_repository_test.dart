// import 'package:dio/dio.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mocktail/mocktail.dart';
// import 'package:questkeeper/quests/models/badge_model.dart';
// import 'package:questkeeper/quests/models/user_badge_model.dart';
// import 'package:questkeeper/quests/repositories/badges_repository.dart';
// import 'package:questkeeper/shared/models/return_model/return_model.dart';
// import 'package:questkeeper/shared/utils/http_service.dart';

// class MockHttpService extends Mock implements HttpService {}

// void main() {
//   late BadgesRepository repository;
//   late MockHttpService mockHttpService;

//   // Sample badge data
//   final sampleBadgeData = [
//     {
//       'id': 'badge1',
//       'name': 'First Task',
//       'description': 'Complete your first task',
//       'points': 100,
//       'requirementCount': 1,
//       'category': 'beginner',
//       'tier': 1,
//       'resetMonthly': false,
//     }
//   ];

//   // Sample user badge data
//   final sampleUserBadgeData = [
//     {
//       'id': 1,
//       'progress': 1,
//       'monthYear': '8-2023',
//       'badge': {
//         'id': 'badge1',
//         'name': 'First Task',
//         'description': 'Complete your first task',
//         'points': 100,
//         'requirementCount': 1,
//         'category': 'beginner',
//         'tier': 1,
//         'resetMonthly': false,
//       },
//       'redeemed': true,
//       'earnedAt': '2023-08-15T10:00:00.000Z',
//       'redemptionCount': 1,
//     }
//   ];

//   // Sample redeem badge response
//   final sampleRedeemResponse = {
//     'pointsAwarded': 100,
//     'success': true,
//   };

//   setUp(() {
//     mockHttpService = MockHttpService();

//     // Use a subclass with a custom constructor that enables using the mocked HttpService
//     repository = _TestBadgesRepository(mockHttpService);
//   });

//   group('BadgesRepository', () {
//     test('getBadges should return a list of badges', () async {
//       // Arrange
//       when(() => mockHttpService.get('/social/badges'))
//           .thenAnswer((_) async => Response(
//                 requestOptions: RequestOptions(path: '/social/badges'),
//                 data: sampleBadgeData,
//                 statusCode: 200,
//               ));

//       // Act
//       final result = await repository.getBadges();

//       // Assert
//       expect(result, isA<List<Badge>>());
//       expect(result.length, 1);
//       expect(result[0].id, 'badge1');
//       expect(result[0].name, 'First Task');

//       // Verify the HTTP call was made
//       verify(() => mockHttpService.get('/social/badges')).called(1);
//     });

//     test('getUserBadges should return a list of user badges', () async {
//       // Arrange
//       when(() => mockHttpService.get('/social/badges/me'))
//           .thenAnswer((_) async => Response(
//                 requestOptions: RequestOptions(path: '/social/badges/me'),
//                 data: sampleUserBadgeData,
//                 statusCode: 200,
//               ));

//       // Act
//       final result = await repository.getUserBadges();

//       // Assert
//       expect(result, isA<List<UserBadge>>());
//       expect(result.length, 1);
//       expect(result[0].id, 1);
//       expect(result[0].progress, 1);
//       expect(result[0].badge.id, 'badge1');

//       // Verify the HTTP call was made
//       verify(() => mockHttpService.get('/social/badges/me')).called(1);
//     });

//     test('redeemBadge should redeem a badge and return success result',
//         () async {
//       // Arrange
//       final userBadgeId = 1;
//       when(() => mockHttpService.post('/social/badges/$userBadgeId/redeem'))
//           .thenAnswer((_) async => Response(
//                 requestOptions:
//                     RequestOptions(path: '/social/badges/$userBadgeId/redeem'),
//                 data: sampleRedeemResponse,
//                 statusCode: 200,
//               ));

//       // Act
//       final result = await repository.redeemBadge(userBadgeId);

//       // Assert
//       expect(result, isA<ReturnModel>());
//       expect(result.success, true);
//       expect(result.message, '100');
//       expect(result.error, null);

//       // Verify the HTTP call was made
//       verify(() => mockHttpService.post('/social/badges/$userBadgeId/redeem'))
//           .called(1);
//     });

//     test('redeemBadge should handle failure correctly', () async {
//       // Arrange
//       final userBadgeId = 1;
//       final errorResponse = {
//         'success': false,
//         'error': 'Failed to redeem badge'
//       };

//       when(() => mockHttpService.post('/social/badges/$userBadgeId/redeem'))
//           .thenAnswer((_) async => Response(
//                 requestOptions:
//                     RequestOptions(path: '/social/badges/$userBadgeId/redeem'),
//                 data: errorResponse,
//                 statusCode: 400,
//               ));

//       // Act
//       final result = await repository.redeemBadge(userBadgeId);

//       // Assert
//       expect(result, isA<ReturnModel>());
//       expect(result.success, false);
//       expect(result.error, 'Failed to redeem badge');

//       // Verify the HTTP call was made
//       verify(() => mockHttpService.post('/social/badges/$userBadgeId/redeem'))
//           .called(1);
//     });
//   });
// }

// // Test implementation of BadgesRepository to inject mocked HttpService
// class _TestBadgesRepository extends BadgesRepository {
//   final HttpService _mockHttpService;

//   _TestBadgesRepository(this._mockHttpService);

//   @override
//   HttpService get _httpService => _mockHttpService;
// }
