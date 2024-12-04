import 'package:feedback_sentry/feedback_sentry.dart';
import 'package:questkeeper/auth/providers/auth_provider.dart';
import 'package:questkeeper/constants.dart';
import 'package:questkeeper/quests/views/quests_view.dart';
import 'package:questkeeper/friends/views/friends_main_leaderboard.dart';
import 'package:questkeeper/shared/extensions/platform_extensions.dart';
import 'package:questkeeper/shared/utils/mixpanel/mixpanel_manager.dart';
import 'package:questkeeper/spaces/views/all_spaces_screen.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:questkeeper/settings/views/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:questkeeper/task_list/views/edit_task_bottom_sheet.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TabView extends ConsumerStatefulWidget {
  const TabView({super.key});

  @override
  ConsumerState<TabView> createState() => _TabViewState();
}

class _TabViewState extends ConsumerState<TabView> {
  int _selectedIndex = isDebug ? 1 : 0;
  static const List<Widget> pages = [
    if (isDebug) QuestsView(),
    AllSpacesScreen(),
    FriendsList(), // Placeholder for arcade
    SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();

    AuthNotifier().setFirebaseMessaging();
  }

  void _onItemTapped(int index) async {
    setState(() {
      _selectedIndex = index;
    });

    if (PlatformExtensions.isMobile) {
      MixpanelManager.instance.track("TabView", properties: {
        "tab": index,
        "tabName": pages[index].runtimeType.toString(),
        "action": "Tab change",
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        if (width < 800) {
          // Mobile layout
          return Stack(children: [
            Scaffold(
              body: pages[_selectedIndex],
              bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                items: const <BottomNavigationBarItem>[
                  if (isDebug)
                    BottomNavigationBarItem(
                      icon: Icon(LucideIcons.trophy),
                      label: 'Quests',
                    ),
                  BottomNavigationBarItem(
                    icon: Icon(LucideIcons.eclipse),
                    label: 'Spaces',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(LucideIcons.handshake),
                    label: 'Friends',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(LucideIcons.user_cog),
                    label: 'Settings',
                  ),
                ],
                backgroundColor:
                    Theme.of(context).colorScheme.surfaceContainerLow,
                currentIndex: _selectedIndex,
                onTap: _onItemTapped,
              ),
            ),
            Positioned(
              top: 60, // Adjust this value to position the button vertically
              right:
                  16, // Adjust this value to position the button horizontally
              child: FloatingActionButton(
                key: const Key('feedback_button'),
                heroTag: 'feedback_button',
                onPressed: () async {
                  var user = Supabase.instance.client.auth.currentUser;
                  if (!context.mounted) {
                    return;
                  }
                  BetterFeedback.of(context).showAndUploadToSentry(
                    name: user?.id,
                    email: user?.email,
                  );
                },
                enableFeedback: true,
                mini: true,
                child: const Icon(LucideIcons.bug),
              ),
            ),
          ]);
        } else {
          // Tablet layout
          return Scaffold(
            body: Row(
              children: [
                NavigationRail(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: _onItemTapped,
                  labelType: NavigationRailLabelType.all,
                  destinations: const <NavigationRailDestination>[
                    if (isDebug)
                      NavigationRailDestination(
                          icon: Icon(LucideIcons.trophy),
                          label: Text('Quests')),
                    NavigationRailDestination(
                        icon: Icon(LucideIcons.eclipse), label: Text('Spaces')),
                    NavigationRailDestination(
                        icon: Icon(LucideIcons.handshake),
                        label: Text('Friends')),
                    NavigationRailDestination(
                        icon: Icon(LucideIcons.user_cog),
                        label: Text('Settings')),
                  ],
                ),
                const VerticalDivider(thickness: 1, width: 1),
                Expanded(
                  child: Scaffold(
                    body: pages[_selectedIndex],
                    floatingActionButton: FloatingActionButton(
                      key: const Key('add_task_button'),
                      heroTag: 'add_task_button',
                      onPressed: () => {
                        showTaskBottomSheet(
                          context: context,
                          ref: ref,
                          existingTask: null,
                        ),
                      },
                      child: const Icon(LucideIcons.plus),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
