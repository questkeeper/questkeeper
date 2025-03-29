import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:questkeeper/quests/views/desktop_quests_view.dart';
import 'package:questkeeper/quests/views/mobile_quests_view.dart';
import 'package:questkeeper/shared/providers/window_size_provider.dart';

class QuestsView extends ConsumerWidget {
  const QuestsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Check if we're on desktop
    final isMobile = ref.watch(isMobileProvider);

    // If desktop, show the desktop view
    if (!isMobile) {
      return const DesktopQuestsView();
    }

    // Otherwise show the mobile view
    return const MobileQuestsView();
  }
}
