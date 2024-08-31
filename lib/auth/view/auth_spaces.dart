import 'package:questkeeper/auth/providers/auth_page_controller_provider.dart';
import 'package:questkeeper/auth/widgets/auth_space_card.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:questkeeper/auth/widgets/space_screens/auth_screen.dart';
import 'package:questkeeper/auth/widgets/space_screens/pet_screen.dart';
import 'package:questkeeper/auth/widgets/space_screens/username_screen.dart';

class AuthSpaces extends ConsumerStatefulWidget {
  const AuthSpaces({super.key});

  @override
  ConsumerState<AuthSpaces> createState() => _AuthSpacesState();
}

class _AuthSpacesState extends ConsumerState<AuthSpaces> {
  int currentPageValue = 0;
  late final String username;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageView(
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.horizontal,
          dragStartBehavior: DragStartBehavior.down,
          controller: ref.read(authPageControllerProvider),
          children: const [
            AuthSpaceCard(currentSpaceScreen: AuthScreen()),
            AuthSpaceCard(
              currentSpaceScreen: UsernameScreen(),
              baseColor: Color(0xfffb8b24),
            ),
            AuthSpaceCard(
              currentSpaceScreen: PetScreen(),
              baseColor: Colors.cyan,
            ),
          ],
        ),
      ),
    );
  }
}
