import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:questkeeper/shared/notifications/notification_service.dart';

class NotificationHandler {
  static void initialize() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.data.isNotEmpty) {
        final notificationService = NotificationService();
        notificationService.showMessage(message.data['message'] ?? '');
      }
    });
  }
}
