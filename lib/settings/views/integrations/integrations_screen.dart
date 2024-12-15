import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:questkeeper/settings/services/canvas_api_client.dart';
import 'package:questkeeper/settings/widgets/settings_card.dart';
import 'package:questkeeper/shared/widgets/snackbar.dart';

class IntegrationsScreen extends ConsumerWidget {
  IntegrationsScreen({super.key});
  final TextEditingController _courseIdController = TextEditingController();

  // State
  final ValueNotifier<List<Map<String, dynamic>>> _assignmentsNotifier =
      ValueNotifier([]);

  Future<void> _testCanvasIntegration(CanvasApiClient client) async {
    try {
      // First get active courses
      final courses = await client.getActiveCourses();
      debugPrint('Found ${courses.length} active courses');

      // For each course, get assignments
      for (final course in courses) {
        final courseId = course['id'].toString();
        final courseName = course['name'];
        debugPrint('\nFetching assignments for course: $courseName');

        final assignments = await client.getCourseAssignments(courseId);
        debugPrint('Found ${assignments.length} assignments');

        // Print each assignment's name and due date
        for (final assignment in assignments) {
          final name = assignment['name'];
          final dueAt = assignment['due_at'];
          debugPrint('- $name (Due: $dueAt)');
        }
      }
    } catch (e) {
      debugPrint('Error testing Canvas integration: $e');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // For testing with personal access token
    const token =
        '6948~ka6Y9ekfG8hY2v2DBE8ARCJNAXNDeCzn2A986Aw2FLAXM6AHnFDyUztHNumXyfh9';
    const domain = 'rutgers.instructure.com'; // Replace with your Canvas domain
    final client = CanvasApiClient(domain: domain, token: token);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Integrations'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                SettingsCard(
                  title: 'Canvas',
                  description: 'Sync your assignments from Canvas',
                  icon: LucideIcons.school,
                  onTap: () async {
                    try {
                      await _testCanvasIntegration(client);
                      if (context.mounted) {
                        SnackbarService.showSuccessSnackbar(
                          'Successfully fetched Canvas data - check debug console',
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        SnackbarService.showErrorSnackbar(
                          'Error fetching Canvas data: ${e.toString()}',
                        );
                      }
                    }
                  },
                ),
                // Search based on course id passed in
                Row(
                  children: [
                    Flexible(
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: 'Course ID',
                        ),
                        controller: _courseIdController,
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        final courseId = _courseIdController.text;
                        final assignments =
                            await client.getCourseAssignments(courseId);
                        _assignmentsNotifier.value = assignments;
                      },
                      icon: Icon(LucideIcons.search),
                    ),
                  ],
                ),

                // Display assignments
                ValueListenableBuilder(
                  valueListenable: _assignmentsNotifier,
                  builder: (context, assignments, child) {
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          assignments.isNotEmpty
                              ? Text(
                                  'Assignments: ${assignments.length} for course name ${assignments[0]['course_name']}',
                                )
                              : const SizedBox.shrink(),
                          ...assignments.map(
                            (assignment) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListTile(
                                  style: ListTileStyle.list,
                                  minLeadingWidth: 0,
                                  // Curved corners
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  tileColor: Theme.of(context)
                                      .colorScheme
                                      .surfaceContainerHigh,
                                  title: Text(assignment['name']),
                                  subtitle: Text(
                                    "Due: ${assignment['due_at'].toString().split('T')[0]}\n"
                                    "Assignment type: ${assignment['submission_types']}",
                                  ),
                                ),
                              );
                              // return Wrap(
                              //   children: [
                              //     Text(
                              //       assignment['name'],
                              //     ),
                              //     Text("Due: ${assignment['due_at']}"),
                              //     // Assignment type
                              //     Text(
                              //       "Assignment type: ${assignment['submission_types']}",
                              //     ),
                              //   ],
                              // );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
