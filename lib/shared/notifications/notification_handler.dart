import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:questkeeper/profile/providers/profile_provider.dart';
import 'package:questkeeper/shared/notifications/notification_service.dart';
import 'package:flutter/services.dart';
import 'package:questkeeper/shared/notifications/points_notification_provider.dart';

class NotificationHandler {
  static const platform = MethodChannel('app.questkeeper/data');

  static Future<void> initialize(WidgetRef ref) async {
    // Handle regular foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      if (message.data.isNotEmpty) {
        final data = Map<String, dynamic>.from(message.data);
        debugPrint(data.toString());
        if (data.containsKey('message')) {
          if (data.containsKey("messageType")) {
            switch (data['messageType']) {
              case "quest":
                NotificationService().showMessage(data['message']);
                break;
              case "points_rewarded":
                debugPrint("points_rewarded");
                ref
                    .read(pointsNotificationManagerProvider.notifier)
                    .showBadgeTemporarily(
                      int.tryParse(data['pointsValue']) ?? 0,
                    );

                // Update the profile cache on device
                await ref.read(profileManagerProvider.notifier).fetchProfile();
                break;
              default:
                NotificationService().showMessage(data['message']);
            }
          } else {
            NotificationService().showMessage(data['message']);
          }
        }
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
