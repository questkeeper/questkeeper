import 'package:flutter/material.dart';

enum NotificationDotType { warning, danger }

class TaskNotificationDot extends StatelessWidget {
  final NotificationDotType notificationType;
  const TaskNotificationDot({super.key, required this.notificationType});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      maxRadius: 6.0,
      backgroundColor: switch (notificationType) {
        NotificationDotType.warning => Colors.amberAccent,
        NotificationDotType.danger => Colors.redAccent,
      },
    );
  }
}
