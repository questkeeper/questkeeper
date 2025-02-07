import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:questkeeper/auth/providers/auth_provider.dart';

class LocalNotificationService {
  static final LocalNotificationService _instance =
      LocalNotificationService._internal();
  factory LocalNotificationService() => _instance;
  LocalNotificationService._internal();

  bool _isSyncing = false;
  bool _isInitialized = false;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final supabase = Supabase.instance.client;

  bool get isInitialized => _isInitialized;

  Future<bool> initialize() async {
    // If already initialized, return true
    if (_isInitialized) {
      return true;
    }

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    final linuxSettings = LinuxInitializationSettings(
      defaultActionName: 'Open notification',
      defaultIcon: AssetsLinuxIcon('assets/app_icon.png'),
    );

    final initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
      macOS: darwinSettings,
      linux: linuxSettings,
    );

    debugPrint('Initializing local notifications');

    try {
      final success = await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
          debugPrint('Notification clicked: ${response.payload}');
        },
      );

      _isInitialized = success ?? false;
      return _isInitialized;
    } catch (e) {
      debugPrint('Failed to initialize local notifications: $e');
      _isInitialized = false;
      return false;
    }
  }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {
    tz.initializeTimeZones();

    // Cancel any existing notification with this ID
    await flutterLocalNotificationsPlugin.cancel(id);

    // Only schedule if the date is in the future
    if (scheduledDate.isBefore(DateTime.now())) {
      return;
    }

    const androidDetails = AndroidNotificationDetails(
      'task_notifications',
      'Task Notifications',
      channelDescription: 'Notifications for task reminders',
      importance: Importance.max,
      priority: Priority.high,
    );

    const darwinDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const linuxDetails = LinuxNotificationDetails(
      urgency: LinuxNotificationUrgency.normal,
    );

    final platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: darwinDetails,
      macOS: darwinDetails,
      linux: linuxDetails,
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      platformDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<void> syncNotificationsFromSchedule() async {
    if (_isSyncing) return;

    _isSyncing = true;

    final AuthNotifier authNotifier = AuthNotifier();
    if (!authNotifier.isLocalNotificationsSupported ||
        await authNotifier.isFCMSupported) {
      return;
    }

    debugPrint('Syncing notifications from schedule');

    try {
      // First cancel all existing notifications
      await cancelAllNotifications();

      // Get all upcoming notifications from Supabase
      final response = await supabase
          .from('notification_schedule')
          .select()
          .eq('sent', false)
          .gte('scheduled_at', DateTime.now().toUtc())
          .order('scheduled_at')
          .limit(25);

      if (response.isEmpty) return;

      for (final notification in response) {
        final scheduledAt = DateTime.parse(notification['scheduled_at']);
        debugPrint(
            'Scheduling notification for task ${notification['taskId']}: $scheduledAt');
        await scheduleNotification(
          id: notification['id'],
          title: notification['title'] ?? 'Task Reminder',
          body: notification['message'] ?? 'You have a task due soon',
          scheduledDate: scheduledAt,
        );
      }
    } catch (e) {
      debugPrint('Error syncing notifications: $e');
    } finally {
      _isSyncing = false;
    }
  }

  Future<List<PendingNotificationRequest>> getAllLocalNotifications() async {
    final notifications =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    return notifications;
  }
}
