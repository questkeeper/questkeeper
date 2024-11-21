import 'dart:math' as math;
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class ClockComponent extends PositionComponent {
  late Paint _hourHandPaint;
  late Paint _minuteHandPaint;
  late DateTime _currentTime;
  // Timer? _timer;

  ClockComponent({
    super.position,
    super.size,
  }) {
    _hourHandPaint = Paint()
      ..color = const Color(0xff494F69)
      ..strokeWidth = 3.0;
    _minuteHandPaint = Paint()
      ..color = const Color(0xff494F69)
      ..strokeWidth = 2.0;
    _currentTime = DateTime.now();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final center = size / 2;
    final radius = size.x / 2;

    // Draw hands
    _drawHands(canvas, center, radius);
  }

  void _drawHands(Canvas canvas, Vector2 center, double radius) {
    final hour = _currentTime.hour % 12;
    final minute = _currentTime.minute;

    // Hour hand
    final hourAngle = (hour + minute / 60) * (2 * math.pi / 12) - math.pi / 2;
    // _drawHand(canvas, center, hourAngle, radius * 0.5, _hourHandPaint);

    // Minute hand
    final minuteAngle = minute * (2 * math.pi / 60) - math.pi / 2;
    // _drawHand(canvas, center, minuteAngle, radius * 0.7, _minuteHandPaint);
  }

  void _drawHand(
      Canvas canvas, Vector2 center, double angle, double length, Paint paint) {
    canvas.drawLine(
      Offset(center.x, center.y),
      Offset(
        center.x + length * math.cos(angle),
        center.y + length * math.sin(angle),
      ),
      paint,
    );
  }
}
