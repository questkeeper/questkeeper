import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final supabaseClient = Supabase.instance.client;
  var selected = _NotificationType.previous;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
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
                    selected = _NotificationType.values.firstWhere((it) => it.name == selections.first);
                  });
                },
              ),
              Expanded(
                child: FutureBuilder(
                  future: supabaseClient.from(selected.table).select(),
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
                      final data = snapshot.data as List<Map<String, dynamic>>;
                      return ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          final notification = data.elementAt(index);

                          switch (selected) {
                            case _NotificationType.previous:
                              return PreviousNotification(data: notification);

                            case _NotificationType.upcoming:
                              return UpcomingNotification(data: notification);
                          }
                        },
                      );
                    }

                    return const Text("No notifications");
                  },
                ),
              ),
            ],
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
  });

  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context);
}

class PreviousNotification extends Notification {
  const PreviousNotification({
    super.key,
    required super.data,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(data["message"]),
      subtitle: Text(data["type"]),
    );
  }
}

class UpcomingNotification extends Notification {
  const UpcomingNotification({
    super.key,
    required super.data,
  });

  @override
  Widget build(BuildContext context) {
    var title = data["title"] as String?;
    var subtitle = data["message"] as String?;

    if (title == null || title.isEmpty) {
      title = "Missing title";
    }

    if (subtitle == null || subtitle.isEmpty) {
      subtitle = "Missing subtitle";
    }

    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
    );
  }
}