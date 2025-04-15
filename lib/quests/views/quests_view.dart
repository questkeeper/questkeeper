import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:questkeeper/quests/views/desktop_quests_view.dart';
import 'package:questkeeper/quests/views/mobile_quests_view.dart';
import 'package:questkeeper/shared/providers/window_size_provider.dart';
import 'package:questkeeper/shared/utils/analytics/analytics.dart';

class QuestsView extends ConsumerStatefulWidget {
  const QuestsView({super.key});

  @override
  ConsumerState<QuestsView> createState() => _QuestsViewState();
}

class _QuestsViewState extends ConsumerState<QuestsView> {
  @override
  void initState() {
    super.initState();

    // Track quests screen view
    Analytics.instance.trackScreen(
      screenName: 'quests',
      properties: {
        'is_mobile': ref.read(isMobileProvider),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
