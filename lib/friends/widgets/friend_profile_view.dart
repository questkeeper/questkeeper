import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:questkeeper/friends/models/friend_model.dart';
import 'package:questkeeper/friends/repositories/friend_repository.dart';
import 'package:questkeeper/quests/models/user_badge_model.dart';
import 'package:questkeeper/shared/utils/format_date.dart';
import 'package:questkeeper/shared/widgets/avatar_widget.dart';
import 'package:questkeeper/shared/widgets/points_badge.dart';
import 'package:questkeeper/shared/widgets/show_drawer.dart';
import 'package:questkeeper/shared/widgets/snackbar.dart';

/// A widget that displays a friend's profile information, including their
/// badges, stats, and other relevant data.
class FriendProfileView extends StatefulWidget {
  final Friend friend;
  final Function(Friend friend)? onRemoveFriend;
  final bool isMobile;

  const FriendProfileView({
    super.key,
    required this.friend,
    this.onRemoveFriend,
    this.isMobile = false,
  });

  /// Shows the friend profile view in a drawer
  static void show(BuildContext context, Friend friend,
      {Function(Friend friend)? onRemoveFriend, bool isMobile = false}) {
    showDrawer(
      context: context,
      key: 'friend_profile_${friend.userId}',
      widthOffsetLeftLean: true,
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: FriendProfileView(
          friend: friend,
          onRemoveFriend: onRemoveFriend,
          isMobile: isMobile,
        ),
      ),
    );
  }

  @override
  State<FriendProfileView> createState() => _FriendProfileViewState();
}

class _FriendProfileViewState extends State<FriendProfileView> {
  final FriendRepository _repository = FriendRepository();
  bool _isLoading = true;
  bool _invalidateCache = false;
  List<UserBadge> _badges = [];
  Map<String, dynamic> _stats = {};
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadFriendData();
  }

  Future<void> _loadFriendData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final friendBadgesProfile = await _repository.getFriendBadgesByUserId(
        widget.friend.userId,
        ignoreCache: _invalidateCache,
      );

      if (mounted) {
        setState(() {
          _badges = friendBadgesProfile.badges;
          _stats = friendBadgesProfile.stats ?? {};
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    } finally {
      setState(() {
        _invalidateCache = !_invalidateCache; // Toggle the cache state
      });
    }
  }

  Future<void> _nudgeFriend() async {
    try {
      final response = await _repository.nudgeFriend(widget.friend.username);

      if (mounted) {
        if (response.success) {
          SnackbarService.showSuccessSnackbar(response.message);
        } else {
          SnackbarService.showErrorSnackbar(response.message);
        }
      }
    } catch (e) {
      if (mounted) {
        SnackbarService.showErrorSnackbar(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator.adaptive(
      onRefresh: _loadFriendData,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_error != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Column(
                    children: [
                      Text(
                        'Failed to load friend data',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: _loadFriendData,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              )
            else
              _buildProfileContent(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outlineVariant,
            width: 1.0,
          ),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(LucideIcons.x),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          AvatarWidget(
            seed: widget.friend.userId,
            radius: 40,
          ),
          const SizedBox(height: 12),
          Text(
            widget.friend.username,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 4),
          PointsBadge(
            points: widget.friend.points,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: _nudgeFriend,
                icon: const Icon(LucideIcons.redo),
                label: const Text('Nudge'),
              ),
              const SizedBox(width: 12),
              if (widget.onRemoveFriend != null)
                OutlinedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                    widget.onRemoveFriend!(widget.friend);
                  },
                  icon: const Icon(LucideIcons.user_minus,
                      color: Colors.redAccent),
                  label: const Text('Remove Friend',
                      style: TextStyle(color: Colors.redAccent)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.redAccent),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatsSection(context),
          const SizedBox(height: 24),
          _buildBadgesSection(context),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getStatsWithIcons() {
    return [
      {
        'icon': LucideIcons.trophy,
        'title': 'Completed Achievements this month',
        'value': _stats['completedAchievements']?.toString() ?? '0',
        'subtitle': 'Achievements',
      },
      {
        'icon': LucideIcons.medal,
        'title': 'Lifetime Achievements',
        'value': _stats['totalAchievements']?.toString() ?? '0',
        'subtitle': 'Achievements',
      },
      if (_stats['joinedAt'] != null) ...[
        {
          'icon': LucideIcons.calendar,
          'title': 'Member Since',
          'value': formatDateDifference(DateTime.parse(_stats['joinedAt'])),
        },
      ],
    ];
  }

  Widget _buildStatsSection(BuildContext context) {
    final stats = _getStatsWithIcons();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Stats',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        Card(
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: widget.isMobile
                ? Column(
                    children: [
                      ...stats.map((stat) => _buildMobileStat(
                            context,
                            icon: stat['icon'],
                            title: stat['title'],
                            value: "${stat['value']} ${stat['subtitle'] ?? ''}",
                          )),
                    ],
                  )
                : Column(
                    children: [
                      ...stats.map((stat) => _buildStatRow(
                            context,
                            icon: stat['icon'],
                            title: stat['title'],
                            value: stat['value'],
                            subtitle: stat['subtitle'],
                          )),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileStat(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    String? subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon,
                  size: 28, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatRow(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    String? subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
          if (subtitle != null) ...[
            const SizedBox(width: 4),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBadgesSection(BuildContext context) {
    if (_badges.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Achievements',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          Card(
            color: Theme.of(context).colorScheme.surfaceContainerLow,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'No badges earned yet',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Achievements',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        if (widget.isMobile)
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: _badges.length,
            itemBuilder: (context, index) {
              final badge = _badges[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: _buildBadgeCard(context, badge),
              );
            },
          )
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: _badges.length,
            itemBuilder: (context, index) {
              final badge = _badges[index];
              return _buildBadgeCard(context, badge);
            },
          ),
      ],
    );
  }

  Widget _buildBadgeCard(BuildContext context, UserBadge badge) {
    final bool isCompleted = badge.progress >= badge.badge.requirementCount;

    return Card(
      color: isCompleted
          ? Theme.of(context)
              .colorScheme
              .primaryContainer
              .withValues(alpha: 0.3)
          : Theme.of(context).colorScheme.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    badge.badge.name,
                    style: Theme.of(context).textTheme.titleMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (isCompleted)
                  Icon(
                    LucideIcons.check,
                    color: Theme.of(context).colorScheme.primary,
                    size: 18,
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              badge.badge.description,
              style: Theme.of(context).textTheme.bodyMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: badge.progress / badge.badge.requirementCount,
              backgroundColor:
                  Theme.of(context).colorScheme.surfaceContainerLow,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 4),
            Text(
              '${badge.progress}/${badge.badge.requirementCount}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
