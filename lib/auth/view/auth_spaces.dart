import 'package:questkeeper/auth/providers/auth_page_controller_provider.dart';
import 'package:questkeeper/auth/widgets/auth_space_card.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:questkeeper/auth/widgets/space_screens/auth_screen.dart';
import 'package:questkeeper/auth/widgets/space_screens/username_screen.dart';
import 'package:questkeeper/shared/extensions/color_extensions.dart';
import 'package:questkeeper/shared/extensions/string_extensions.dart';

class AuthSpaces extends ConsumerWidget {
  const AuthSpaces({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: PageView(
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.horizontal,
          dragStartBehavior: DragStartBehavior.down,
          controller: ref.read(authPageControllerProvider),
          children: [
            AuthSpaceCard(
              currentSpaceScreen: AuthScreen(),
              colors: Color.fromARGB(255, 126, 84, 223).toCardGradientColor(),
            ),
            AuthSpaceCard(
              currentSpaceScreen: UsernameScreen(),
              colors: ["34a0a4","168aad","1a759f","1e6091","184e77"].map((it) => it.toColor()).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
