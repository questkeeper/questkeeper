import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class CanvasApiClient {
  final Dio _dio;
  final String domain;
  final String token;

  CanvasApiClient({required this.domain, required this.token})
      : _dio = Dio(BaseOptions(
          baseUrl: 'https://$domain/api/v1',
          headers: {'Authorization': 'Bearer $token'},
        ));

  Future<List<Map<String, dynamic>>> getActiveCourses() async {
    try {
      final response = await _dio.get('/courses', queryParameters: {
        'enrollment_state': 'active',
        'include[]': [
          'term',
          'total_scores',
          'course_progress',
        ],
      });

      return List<Map<String, dynamic>>.from(response.data);
    } catch (e) {
      debugPrint('Error fetching courses: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getCourseAssignments(
      String courseId) async {
    try {
      final response =
          await _dio.get('/courses/$courseId/assignments', queryParameters: {
        'order_by': 'due_at',
        'include[]': ['submission', 'can_edit'],
      });

      return List<Map<String, dynamic>>.from(response.data);
    } catch (e) {
      debugPrint('Error fetching assignments for course $courseId: $e');
      rethrow;
    }
  }
}
