import 'package:feedback_sentry/feedback_sentry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:questkeeper/quests/views/desktop_quests_view.dart';
import 'package:questkeeper/quests/views/mobile_quests_view.dart';
import 'package:questkeeper/shared/providers/window_size_provider.dart';
import 'package:questkeeper/shared/utils/analytics/analytics.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

    return Stack(
      children: [
        !isMobile ? const DesktopQuestsView() : const MobileQuestsView(),
        Positioned(
          top: 16,
          right: 16,
          child: IconButton.filledTonal(
            onPressed: () {
              final currentUser = Supabase.instance.client.auth.currentUser;
              BetterFeedback.of(context).showAndUploadToSentry(
                name: currentUser?.id ?? 'Unknown',
                email: currentUser?.email ?? 'Unknown@questkeeper.app',
              );
            },
            icon: Icon(LucideIcons.bug),
          ),
        ),
      ],
    );
  }
}
