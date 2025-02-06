import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:questkeeper/settings/widgets/settings_card.dart';
import 'package:questkeeper/shared/notifications/local_notification_service.dart';
import 'package:questkeeper/shared/utils/shared_preferences_manager.dart';
import 'package:questkeeper/shared/widgets/show_drawer.dart';
import 'package:questkeeper/shared/widgets/snackbar.dart';

class SuperSecretDebugSettings extends StatelessWidget {
  const SuperSecretDebugSettings({super.key});
  static final prefs = SharedPreferencesManager.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Super Secret Debug Settings'),
      ),
      body: Column(
        children: <Widget>[
          SettingsCard(
            title: "Show me da local data",
            description: "Show me da local data",
            icon: Icons.data_object,
            onTap: () {
              showModalBottomSheet(
                  context: context, builder: (context) => _localDataStorage());
            },
          ),
          const Divider(),
          const SizedBox(height: 16),
          const Text(
            "Local Notifications",
            style: TextStyle(fontSize: 20),
          ),
          SettingsCard(
            title: "Force initalize local notifications",
            description: "Force initalize local notifications",
            icon: Icons.notifications,
            onTap: () async {
              final notificationService = LocalNotificationService();
              await notificationService.initialize();
              if (context.mounted) {
                SnackbarService.showInfoSnackbar(
                  "Local notifications initialized",
                );
              }
            },
          ),
          SettingsCard(
            title: "Send Test Notification",
            description: "Send an immediate test notification",
            icon: Icons.notification_add,
            onTap: () async {
              final notificationService = LocalNotificationService();
              await notificationService.initialize();
              await notificationService.scheduleNotification(
                id: 999999,
                title: "Test Notification",
                body: "This is a test notification sent immediately",
                scheduledDate: DateTime.now().add(const Duration(seconds: 1)),
              );
              if (context.mounted) {
                SnackbarService.showInfoSnackbar(
                  "Test notification sent",
                );
              }
            },
          ),
          SettingsCard(
            title: "Schedule Test Notification",
            description: "Schedule a notification for later",
            icon: Icons.schedule_send,
            onTap: () => _showScheduleNotificationDialog(context),
          ),
          SettingsCard(
            title: "View all upcoming notifications",
            description: "View all upcoming notifications",
            icon: Icons.notifications,
            onTap: () => _showAllNotifications(context),
          ),
        ],
      ),
    );
  }

  Future<void> _showScheduleNotificationDialog(BuildContext context) async {
    int selectedValue = 1;
    String selectedUnit = 'Minutes';
    final units = ['Minutes', 'Hours'];

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Schedule Test Notification'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Select Time from Now',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: NumberPicker(
                    value: selectedValue,
                    minValue: 1,
                    axis: Axis.horizontal,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey[500]!),
                    ),
                    itemWidth: 50,
                    textStyle: const TextStyle(fontSize: 16),
                    selectedTextStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    haptics: true,
                    maxValue: selectedUnit == "Minutes" ? 60 : 24,
                    onChanged: (value) => setState(() => selectedValue = value),
                  ),
                ),
                Wrap(
                  spacing: 8,
                  children: units.map((unit) {
                    final isSelected = selectedUnit == unit;
                    return ChoiceChip(
                      label: Text(unit),
                      selected: isSelected,
                      onSelected: (_) => setState(() {
                        if (unit == "Minutes" && selectedValue > 60) {
                          selectedValue = 60;
                        } else if (unit == "Hours" && selectedValue > 24) {
                          selectedValue = 24;
                        }
                        selectedUnit = unit;
                      }),
                    );
                  }).toList(),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () async {
                  final minutes = selectedUnit == 'Hours'
                      ? selectedValue * 60
                      : selectedValue;

                  final notificationService = LocalNotificationService();
                  await notificationService.initialize();
                  final scheduledTime =
                      DateTime.now().add(Duration(minutes: minutes));

                  await notificationService.scheduleNotification(
                    id: 999998,
                    title: "Scheduled Test Notification",
                    body:
                        "This notification was scheduled for $selectedValue $selectedUnit from now",
                    scheduledDate: scheduledTime,
                  );

                  if (context.mounted) Navigator.pop(context);
                  if (context.mounted) {
                    SnackbarService.showInfoSnackbar(
                      "Notification scheduled for ${scheduledTime.toString()}",
                    );
                  }
                },
                child: const Text('Schedule'),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _showAllNotifications(BuildContext context) async {
    final notificationService = LocalNotificationService();
    await notificationService.initialize();
    final notifications = await notificationService.getAllLocalNotifications();

    if (context.mounted) {
      showDrawer(
        context: context,
        child: ListView.builder(
          itemCount: notifications.length,
          itemBuilder: (context, index) => ListTile(
            title: Text(notifications[index].title ?? "No title"),
            subtitle: Text(notifications[index].body ?? "No body"),
            trailing: Text(notifications[index].payload ?? "No payload"),
          ),
        ),
        key: "notifications",
      );
    }
  }

  Widget _localDataStorage() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          const Text(
            "Local data cached in SharedPreferences",
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
          _distinctListTiles(
            title: "Clear primary onboarding status",
            onTap: () async => await prefs.remove('onboarded'),
            key: "onboarded",
            description:
                "Clears the primary onboarding status shown at the beginning of the app",
          ),
          _distinctListTiles(
            key: "onboard_overlay",
            title: "Clear the in-app onboarding overlay",
            onTap: () async {
              await prefs.remove('onboarding_completed_steps');
              await prefs.remove('onboarding_complete');
            },
            description:
                "Clears the onboarding overlay once logged in, resets the overlay to show again",
          ),
        ],
      ),
    );
  }

  Widget _distinctListTiles({
    required String title,
    required Function onTap,
    required String key,
    String? description,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListTile(
          title: Text(title),
          subtitle: description != null ? Text(description) : null,
          onTap: () async {
            await onTap();
            SnackbarService.showInfoSnackbar(
              "Cleared $key",
            );
          },
        ),
      ),
    );
  }
}
