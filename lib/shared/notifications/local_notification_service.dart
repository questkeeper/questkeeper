import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:questkeeper/auth/providers/auth_provider.dart';

/// A service that handles local notifications for platforms that don't support FCM
/// or when FCM is not available (e.g., no Play Services).
///
/// This service is implemented as a singleton to ensure only one instance manages
/// notifications across the app. It handles:
/// - Initialization of the notification system
/// - Scheduling notifications
/// - Syncing notifications with the server
/// - Managing notification lifecycle
class LocalNotificationService {
  static final LocalNotificationService _instance =
      LocalNotificationService._internal();

  /// Factory constructor that returns the singleton instance
  factory LocalNotificationService() => _instance;

  /// Private constructor for singleton pattern
  LocalNotificationService._internal();

  /// Flag to prevent multiple sync operations from running simultaneously
  bool _isSyncing = false;

  /// Flag to track if the notification service has been initialized
  bool _isInitialized = false;

  /// The platform-specific notification plugin instance
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// Supabase client for database operations
  final supabase = Supabase.instance.client;

  /// Whether the notification service has been successfully initialized
  bool get isInitialized => _isInitialized;

  /// Initializes the notification service with platform-specific settings.
  ///
  /// This should be called before any other notification operations.
  /// If already initialized, returns true without reinitializing.
  ///
  /// Returns:
  /// - true if initialization was successful
  /// - false if initialization failed
  Future<bool> initialize() async {
    // If already initialized, return true
    if (_isInitialized) {
      return true;
    }

    const androidSettings =
        AndroidInitializationSettings('@mipmap/launcher_icon');
    final darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    final linuxSettings = LinuxInitializationSettings(
      defaultActionName: 'Open notification',
      defaultIcon: AssetsLinuxIcon('assets/icon/icon.png'),
    );
    final windowsSettings = WindowsInitializationSettings(
      appName: 'QuestKeeper',
      appUserModelId: 'app.questkeeper',
      guid: '02389193-8715-4a4e-adb6-b4dd213e3167',
      iconPath: 'assets/icon/icon.png',
    );

    final initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
      macOS: darwinSettings,
      linux: linuxSettings,
      windows: windowsSettings,
    );

    debugPrint('Initializing local notifications');

    try {
      final success = await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
          debugPrint('Notification clicked: ${response.payload}');
        },
      );

      // Request exact alarms permission on Android if needed
      if (Platform.isAndroid) {
        final androidPlugin = flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>();
        await androidPlugin?.requestExactAlarmsPermission();
      }

      _isInitialized = success ?? false;
      return _isInitialized;
    } catch (e) {
      debugPrint('Failed to initialize local notifications: $e');
      _isInitialized = false;
      return false;
    }
  }

  /// Schedules a single notification to be delivered at a specific time.
  ///
  /// Parameters:
  /// - id: Unique identifier for the notification
  /// - title: Title text of the notification
  /// - body: Main content text of the notification
  /// - scheduledDate: When the notification should be delivered
  ///
  /// The notification will be cancelled and rescheduled if one with the same ID
  /// already exists. Notifications scheduled in the past will be ignored.
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
      enableVibration: true,
      playSound: true,
    );

    const darwinDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const linuxDetails = LinuxNotificationDetails(
      urgency: LinuxNotificationUrgency.normal,
    );

    const windowsDetails = WindowsNotificationDetails();

    final platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: darwinDetails,
      macOS: darwinDetails,
      linux: linuxDetails,
      windows: windowsDetails,
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      platformDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  /// Cancels all pending notifications.
  ///
  /// This is typically used when switching to FCM or when cleaning up notifications
  /// that are no longer needed.
  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  /// Syncs local notifications with the server's notification schedule.
  ///
  /// This method:
  /// 1. Prevents multiple syncs from running simultaneously
  /// 2. Checks if local notifications should be used (no FCM support)
  /// 3. Cancels all existing notifications
  /// 4. Fetches and schedules upcoming notifications from the server
  ///
  /// Only schedules notifications that:
  /// - Haven't been sent yet
  /// - Are scheduled for the future
  /// - Are within the next batch (limited to 25 notifications)
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

  /// Returns a list of all pending notification requests.
  ///
  /// Useful for debugging and verifying notification schedules.
  Future<List<PendingNotificationRequest>> getAllLocalNotifications() async {
    final notifications =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    return notifications;
  }
}
