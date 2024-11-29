import 'package:questkeeper/categories/views/edit_category_bottom_sheet.dart';
import 'package:questkeeper/shared/extensions/color_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:questkeeper/shared/extensions/string_extensions.dart';

class AuthSpaceCard extends ConsumerWidget {
  const AuthSpaceCard({
    super.key,
    required this.currentSpaceScreen,
    required this.colors
  });

  final Widget currentSpaceScreen;
  final List<Color> colors;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final localBaseColor = baseColor ?? const Color.fromARGB(255, 126, 84, 223);
    return Card(
      margin: const EdgeInsets.all(12),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomCenter,
          ),
        ),
        child: currentSpaceScreen,
      ),
    );
  }
}
