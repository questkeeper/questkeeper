import 'package:questkeeper/shared/extensions/color_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthSpaceCard extends ConsumerWidget {
  final Widget currentSpaceScreen;
  final Color? baseColor;

  const AuthSpaceCard(
      {super.key, required this.currentSpaceScreen, this.baseColor});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localBaseColor = baseColor ?? const Color.fromARGB(255, 126, 84, 223);
    return Card(
      margin: const EdgeInsets.all(12),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: localBaseColor.toCardGradientColor(),
            begin: Alignment.topLeft,
            end: Alignment.bottomCenter,
          ),
        ),
        child: currentSpaceScreen,
      ),
    );
  }
}
