import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:questkeeper/shared/widgets/pulsating_painter.dart';

class AuthSpaceCard extends ConsumerStatefulWidget {
  final Widget currentSpaceScreen;
  final Color? baseColor;

  const AuthSpaceCard({
    super.key,
    required this.currentSpaceScreen,
    this.baseColor,
  });

  @override
  AuthSpaceCardState createState() => AuthSpaceCardState();
}

class AuthSpaceCardState extends ConsumerState<AuthSpaceCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 60),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localBaseColor =
        widget.baseColor ?? const Color.fromARGB(255, 126, 84, 223);

    return Card(
      margin: const EdgeInsets.all(12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return CustomPaint(
                  painter: PulsatingPainter(
                    color: localBaseColor,
                    progress: _controller.value,
                  ),
                  child: Container(),
                );
              },
            ),
            widget.currentSpaceScreen,
          ],
        ),
      ),
    );
  }
}
