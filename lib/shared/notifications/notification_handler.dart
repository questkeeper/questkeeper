import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:questkeeper/shared/notifications/notification_service.dart';
import 'package:flutter/services.dart';

class NotificationHandler {
  static const platform = MethodChannel('app.questkeeper/data');

  static Future<void> initialize() async {
    // Handle regular foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.data.isNotEmpty) {
        NotificationService().showMessage(message.data['message'] ?? '');
      }
    });

    // Set up platform channel listener for iOS data messages
    platform.setMethodCallHandler((call) async {
      if (call.method == 'onDataMessage') {
        final data = Map<String, dynamic>.from(call.arguments);
        if (data.containsKey('message')) {
          NotificationService().showMessage(data['message']);
        }
      }
    });
  }
}
