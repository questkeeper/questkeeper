import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:questkeeper/auth/providers/auth_provider.dart';
import 'package:questkeeper/settings/widgets/settings_card.dart';
import 'package:questkeeper/settings/widgets/settings_switch_tile.dart';
import 'package:questkeeper/shared/utils/format_date.dart';
import 'package:questkeeper/shared/utils/shared_preferences_keys.dart';
import 'package:questkeeper/shared/utils/shared_preferences_manager.dart';
import 'package:questkeeper/shared/widgets/snackbar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen>
    with TickerProviderStateMixin {
  final supabaseClient = Supabase.instance.client;
  var selected = _NotificationType.previous;
  bool _isLocalNotificationsEnabled = false;
  bool _isLoadingToggle = false;
  final AuthNotifier _authNotifier = AuthNotifier();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadLocalNotificationPreference();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadLocalNotificationPreference() {
    final prefs = SharedPreferencesManager.instance;
    setState(() {
      _isLocalNotificationsEnabled = prefs.getBool(
            SharedPreferencesKeys.localNotificationsEnabled.key,
          ) ??
          false;
    });
  }

  Future<void> _toggleLocalNotifications(bool value) async {
    setState(() {
      _isLoadingToggle = true;
    });

    try {
      if (value) {
        await _authNotifier.enableLocalNotifications();
        if (mounted) {
          SnackbarService.showSuccessSnackbar(
            "Local notifications enabled",
          );
        }
      } else {
        await _authNotifier.disableLocalNotifications();
        if (mounted) {
          SnackbarService.showSuccessSnackbar(
            "Local notifications disabled",
          );
        }
      }

      setState(() {
        _isLocalNotificationsEnabled = value;
      });
    } catch (e) {
      if (mounted) {
        SnackbarService.showErrorSnackbar(
          "Failed to update notification settings",
        );
      }
    } finally {
      setState(() {
        _isLoadingToggle = false;
      });
    }
  }

  Future<void> dismissNotification(int id) async {
    try {
      await supabaseClient
          .from("notifications")
          .update({"read": true}).eq("id", id);
      mounted
          ? SnackbarService.showSuccessSnackbar(
              "Notification dismissed",
            )
          : null;
    } catch (e) {
      mounted
          ? SnackbarService.showErrorSnackbar(
              "Failed to dismiss notification",
            )
          : null;
    }
  }

  Future<List<Map<String, dynamic>>> supabaseQueryBuilder() async {
    switch (selected) {
      case _NotificationType.previous:
        return await supabaseClient
            .from("notifications")
            .select()
            .eq("read", false)
            .order("created_at", ascending: false)
            .limit(25);
      case _NotificationType.upcoming:
        return await supabaseClient
            .from("notification_schedule")
            .select()
            .order("scheduled_at", ascending: true)
            .limit(25);
    }
  }

  Widget _buildSettingsSection() {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  LucideIcons.settings,
                  size: 20,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  "Notification Settings",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Local Notifications Toggle
            if (_authNotifier.isLocalNotificationsSupported)
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Theme.of(context)
                        .colorScheme
                        .outline
                        .withValues(alpha: 0.2),
                  ),
                ),
                child: Column(
                  children: [
                    SettingsSwitchTile(
                      title: "Local Notifications",
                      description:
                          "Use local notifications instead of push notifications",
                      isEnabled: _isLocalNotificationsEnabled,
                      onTap: _isLoadingToggle
                          ? (_) {}
                          : (_) {
                              if (!_isLocalNotificationsEnabled) {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text("Disable Push Notifications?"),
                                    content: Text(
                                      'Disabling push notifications will disable notifications for friend requests, nudge notifications, and others. Use this if you prefer local/offline notifications, or are having consistency issues with push notifications.',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text("Cancel"),
                                      ),
                                      FilledButton(
                                        onPressed: () =>
                                            _toggleLocalNotifications(true),
                                        child: Text("Confirm"),
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                _toggleLocalNotifications(false);
                              }
                            },
                      icon: LucideIcons.bell,
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 12),

            // FCM Status Info
            FutureBuilder<bool>(
              future: _authNotifier.isFCMSupported,
              builder: (context, snapshot) {
                if (snapshot.hasData && !snapshot.data!) {
                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.errorContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          LucideIcons.info,
                          size: 16,
                          color: Theme.of(context).colorScheme.onErrorContainer,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "Push notifications are not supported on this device. Consider enabling local notifications.",
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onErrorContainer,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistorySection() {
    return Expanded(
      child: Card(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          children: [
            // Fixed header with tabs
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerLow,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        LucideIcons.clock,
                        size: 20,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Notification History",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      onTap: (index) {
                        setState(() {
                          selected = _NotificationType.values[index];
                        });
                      },
                      tabs: _NotificationType.values.map((type) {
                        return Tab(
                          text: type.display,
                        );
                      }).toList(),
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      labelColor: Theme.of(context).colorScheme.onPrimary,
                      unselectedLabelColor:
                          Theme.of(context).colorScheme.onSurface,
                      dividerColor: Colors.transparent,
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable content
            Expanded(
              child: FutureBuilder(
                future: supabaseQueryBuilder(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  }

                  if (snapshot.hasError) {
                    return _buildErrorState(snapshot.error.toString());
                  }

                  if (snapshot.hasData) {
                    final data = snapshot.data as List<Map<String, dynamic>>;

                    if (data.isEmpty) {
                      return _buildEmptyState();
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 8,
                      ),
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final notification = data.elementAt(index);
                        final isLast = index == data.length - 1;

                        switch (selected) {
                          case _NotificationType.previous:
                            return Padding(
                              padding: EdgeInsets.only(
                                bottom: isLast ? 0 : 8,
                              ),
                              child: PreviousNotification(
                                index: index,
                                data: notification,
                                onDismiss: () async {
                                  await dismissNotification(
                                      notification["id"] as int);
                                },
                              ),
                            );
                          case _NotificationType.upcoming:
                            return Padding(
                              padding: EdgeInsets.only(
                                bottom: isLast ? 0 : 8,
                              ),
                              child: UpcomingNotification(
                                index: index,
                                data: notification,
                              ),
                            );
                        }
                      },
                    );
                  }

                  return const Center(
                    child: Text("No notifications"),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.errorContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                LucideIcons.info,
                size: 32,
                color: Theme.of(context).colorScheme.onErrorContainer,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Error loading notifications",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                shape: BoxShape.circle,
              ),
              child: Icon(
                LucideIcons.bell,
                size: 32,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "No ${selected.display.toLowerCase()} notifications",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              "When you receive notifications, they'll appear here.",
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: Column(
        children: [
          _buildSettingsSection(),
          _buildHistorySection(),
        ],
      ),
    );
  }
}

enum _NotificationType {
  previous("Previous", "notifications"),
  upcoming("Upcoming", "notification_schedule");

  const _NotificationType(this.display, this.table);

  final String display;

  /// Supabase table name
  final String table;
}

abstract class Notification extends StatelessWidget {
  const Notification({
    super.key,
    required this.data,
    required this.index,
  });

  final Map<String, dynamic> data;
  final int index;

  @override
  Widget build(BuildContext context);
}

class PreviousNotification extends Notification {
  const PreviousNotification({
    super.key,
    required super.index,
    required super.data,
    required this.onDismiss,
  });

  final Future<void> Function() onDismiss;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(data["id"]),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          await onDismiss();
          return true;
        }
        return false;
      },
      direction: DismissDirection.endToStart,
      background: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.error,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              "Mark as read",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onError,
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 8.0),
            Icon(
              LucideIcons.check,
              color: Theme.of(context).colorScheme.onError,
              size: 24.0,
            ),
          ],
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
        child: SettingsCard(
          key: ValueKey(data["id"]),
          title: data["message"],
          description: notificationTypeDisplay[data["type"]] ?? "Unknown",
          onTap: () {},
          backgroundColor: Colors.transparent,
        ),
      ),
    );
  }
}

class UpcomingNotification extends Notification {
  const UpcomingNotification({
    super.key,
    required super.index,
    required super.data,
  });

  @override
  Widget build(BuildContext context) {
    var title = data["title"] as String?;
    final scheduledAt = data["scheduled_at"] as String;
    final scheduledAtDateTime = formatDate(DateTime.parse(scheduledAt));

    if (title == null || title.isEmpty) {
      title = "Missing title";
    }

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: SettingsCard(
        title: title,
        description: scheduledAtDateTime,
        onTap: () {},
        backgroundColor: Colors.transparent,
      ),
    );
  }
}

const notificationTypeDisplay = {
  "friendRequest": "Friend Request",
  "nudge": "Nudge",
  "badgeEarned": "Badge Earned",
  "pointsEarned": "Points Earned",
};
