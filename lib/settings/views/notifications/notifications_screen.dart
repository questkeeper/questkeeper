import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:questkeeper/auth/providers/auth_provider.dart';
import 'package:questkeeper/shared/utils/format_date.dart';
import 'package:questkeeper/shared/widgets/snackbar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final supabaseClient = Supabase.instance.client;
  var selected = _NotificationType.previous;
  late final isNotificationEnabled =
      FirebaseMessaging.instance.getNotificationSettings().then((settings) {
    return settings.authorizationStatus == AuthorizationStatus.authorized;
  });

  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
      ),
      body: SafeArea(
        child: Center(
          child: FutureBuilder(
            future: isNotificationEnabled,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              }

              if (snapshot.hasData) {
                final isEnabled = snapshot.data as bool;
                if (!isEnabled) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Text(
                            "Notifications are disabled\n"
                            "Enable notifications to receive updates",
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            await AuthNotifier().setFirebaseMessaging();
                            setState(() {});
                          },
                          child: const Text("Enable Notifications"),
                        ),
                      ],
                    ),
                  );
                }
              }

              return Column(
                children: [
                  SegmentedButton(
                    segments: _NotificationType.values.map((it) {
                      return ButtonSegment(
                        value: it.name,
                        label: Text(it.display),
                      );
                    }).toList(),
                    selected: {selected.name},
                    onSelectionChanged: (selections) {
                      setState(() {
                        selected = _NotificationType.values
                            .firstWhere((it) => it.name == selections.first);
                      });
                    },
                  ),
                  Expanded(
                    child: FutureBuilder(
                      future: supabaseQueryBuilder(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (snapshot.hasError) {
                          return Text("Error: ${snapshot.error}");
                        }

                        if (snapshot.hasData) {
                          final data =
                              snapshot.data as List<Map<String, dynamic>>;
                          return ListView.builder(
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              final notification = data.elementAt(index);

                              switch (selected) {
                                case _NotificationType.previous:
                                  return PreviousNotification(
                                      index: index,
                                      data: notification,
                                      onDismiss: () async {
                                        await dismissNotification(
                                            notification["id"] as int);
                                      });
                                case _NotificationType.upcoming:
                                  return UpcomingNotification(
                                      index: index, data: notification);
                              }
                            },
                          );
                        }

                        return const Text("No notifications");
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
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
        color: Colors.redAccent,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20.0),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              "Mark as read",
              style: TextStyle(color: Colors.black, fontSize: 16.0),
            ),
            SizedBox(width: 8.0),
            Icon(LucideIcons.check, color: Colors.black, size: 32.0),
          ],
        ),
      ),
      child: ListTile(
        title: Text(data["message"]),
        tileColor: index.isEven
            ? Colors.transparent
            : Theme.of(context).colorScheme.secondary.withOpacity(0.1),
        subtitle: Text(notificationTypeDisplay[data["type"]] ?? "Unknown"),
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

    return ListTile(
      title: Text(title),
      subtitle: Text("Scheduled for $scheduledAtDateTime"),
      tileColor: index.isEven
          ? Colors.transparent
          : Theme.of(context).colorScheme.secondary.withValues(alpha: 0.1),
    );
  }
}

const notificationTypeDisplay = {
  "friendRequest": "Friend Request",
  "nudge": "Nudge",
  "badgeEarned": "Badge Earned",
  "pointsEarned": "Points Earned",
};
