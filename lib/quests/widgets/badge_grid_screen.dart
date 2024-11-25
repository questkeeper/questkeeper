import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BadgeGridScreen extends StatefulWidget {
  const BadgeGridScreen({super.key});

  @override
  State<BadgeGridScreen> createState() => _BadgeGridScreenState();
}

class _BadgeGridScreenState extends State<BadgeGridScreen> {
  final _supabase = Supabase.instance.client;
  List<Map<String, dynamic>> badges = [];
  List<Map<String, dynamic>> userBadges = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBadges();
  }

  Future<void> _loadBadges() async {
    try {
      // Load all badge definitions
      final badgeResponse = await _supabase
          .from('badges')
          .select()
          .order('category')
          .order('tier');

      // Load user's earned badges for current month
      final String currentMonth =
          '${DateTime.now().month.toString().padLeft(2, '0')}${DateTime.now().year}';

      debugPrint('Badge response: $currentMonth');
      final userBadgeResponse = await _supabase
          .from('user_badges')
          .select()
          .eq('userId', _supabase.auth.currentUser!.id);

      debugPrint('Badge response: $userBadgeResponse');
      debugPrint(
          "supabase.auth.currentUser!.id: ${_supabase.auth.currentUser!.id}");

      setState(() {
        debugPrint('User badge response: $userBadgeResponse');
        badges = List<Map<String, dynamic>>.from(badgeResponse);
        userBadges = List<Map<String, dynamic>>.from(userBadgeResponse);
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading badges: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Achievement Badges'),
        backgroundColor: Colors.blue,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBadgeSection('tasks', 'Task Achievements'),
                    _buildBadgeSection('social', 'Social Achievements'),
                    _buildBadgeSection('engagement', 'Engagement Achievements'),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildBadgeSection(String category, String title) {
    final categoryBadges =
        badges.where((b) => b['category'] == category).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 0.8,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: categoryBadges.length,
          itemBuilder: (context, index) {
            final badge = categoryBadges[index];
            final userBadge = userBadges.firstWhere(
              (ub) => ub['badge_id'] == badge['id'],
              orElse: () => {'progress': 0},
            );

            return _BadgeCard(
              badge: badge,
              progress: userBadge['progress'] ?? 0,
              requirement: badge['requirementCount'],
            );
          },
        ),
      ],
    );
  }
}

class _BadgeCard extends StatelessWidget {
  final Map<String, dynamic> badge;
  final int progress;
  final int requirement;

  const _BadgeCard({
    required this.badge,
    required this.progress,
    required this.requirement,
  });

  @override
  Widget build(BuildContext context) {
    final double progressPercent = progress / requirement;
    final bool isEarned = progressPercent >= 1.0;

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Badge Icon
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: isEarned ? Colors.blue : Colors.grey.shade300,
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getIconForCategory(badge['category']),
                color: isEarned ? Colors.white : Colors.grey.shade600,
                size: 30,
              ),
            ),
            const SizedBox(height: 8),
            // Badge Name
            Text(
              badge['name'],
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isEarned ? Colors.blue : Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 4),
            // Progress Indicator
            LinearProgressIndicator(
              value: progressPercent,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(
                isEarned ? Colors.green : Colors.blue,
              ),
            ),
            const SizedBox(height: 4),
            // Progress Text
            Text(
              '$progress / $requirement',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForCategory(String category) {
    switch (category) {
      case 'tasks':
        return Icons.task_alt;
      case 'social':
        return Icons.people;
      case 'engagement':
        return Icons.favorite;
      default:
        return Icons.emoji_events;
    }
  }
}
