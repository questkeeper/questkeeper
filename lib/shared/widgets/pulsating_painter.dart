import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:math' show pi, sin;

class PulsatingPainter extends CustomPainter {
  final Color color;
  final double progress;

  PulsatingPainter({required this.color, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.6)
      ..style = PaintingStyle.fill
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 10);

    final center = Offset(size.width * 1, size.height);
    final radius = size.width * 1.2 * (0.6 + 0.4 * sin(progress * pi));

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(PulsatingPainter oldDelegate) =>
      color != oldDelegate.color || progress != oldDelegate.progress;
}
