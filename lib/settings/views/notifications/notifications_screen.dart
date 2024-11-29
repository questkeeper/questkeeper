import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final supabaseClient = Supabase.instance.client;
  Set<dynamic> selected = {0};
  String tableName = "notifications";

  @override
  void initState() {
    super.initState();
  }

  void onUpdate(Set<dynamic> p0) {
    setState(() {
      selected = p0;
      if (selected.contains(0)) {
        tableName = "notifications";
      } else if (selected.contains(1)) {
        tableName = "notification_schedule";
      }
    });
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
                multiSelectionEnabled: false,
                segments: [
                  ButtonSegment(
                    value: 0,
                    label: Text("Previous"),
                  ),
                  ButtonSegment(
                    value: 1,
                    label: Text("Unread"),
                  ),
                ],
                selected: selected,
                onSelectionChanged: onUpdate,
              ),
              Expanded(
                child: FutureBuilder(
                  future: supabaseClient.from(tableName).select(),
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
                          return ListTile(
                            title: Text(notification["message"]),
                            subtitle: Text(notification["type"]),
                          );
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
