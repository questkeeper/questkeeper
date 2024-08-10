import 'package:flutter/material.dart';

enum NotificationDotType { warning, danger }

class NotificationDot extends StatefulWidget {
  final NotificationDotType notificationType;
  const NotificationDot({super.key, required this.notificationType});

  @override
  NotificationDotState createState() => NotificationDotState();
}

class NotificationDotState extends State<NotificationDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: _animation.value,
          child: child,
        );
      },
      child: CircleAvatar(
        maxRadius: 6.0,
        backgroundColor: switch (widget.notificationType) {
          NotificationDotType.warning => Colors.amber,
          NotificationDotType.danger => Colors.redAccent,
        },
      ),
    );
  }
}
