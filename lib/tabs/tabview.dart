import 'package:questkeeper/auth/providers/auth_provider.dart';
import 'package:questkeeper/constants.dart';
import 'package:questkeeper/quests/views/quests_view.dart';
import 'package:questkeeper/friends/views/friends_main_leaderboard.dart';
import 'package:questkeeper/shared/notifications/points_notification_provider.dart';
import 'package:questkeeper/spaces/views/all_spaces_screen.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:questkeeper/settings/views/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:questkeeper/task_list/views/edit_task_bottom_sheet.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    final pointsBadge = ref.watch(pointsNotificationManagerProvider);
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
                    // The bottom is only for future reference
                    // icon: Builder(
                    //   builder: (context) => AnimatedSwitcher(
                    //     duration: const Duration(milliseconds: 300),
                    //     transitionBuilder:
                    //         (Widget child, Animation<double> animation) {
                    //       return ScaleTransition(
                    //         scale: animation,
                    //         child: FadeTransition(
                    //           opacity: animation,
                    //           child: child,
                    //         ),
                    //       );
                    //     },
                    //     child: pointsBadge["showBadge"] == true &&
                    //             pointsBadge["points"] > 0
                    //         ? Text(
                    //             '+${pointsBadge["points"]}',
                    //             key: ValueKey(pointsBadge["points"]),
                    //             style: const TextStyle(
                    //               color: Colors.green,
                    //             ),
                    //           )
                    //         : const Icon(LucideIcons.handshake,
                    //             key: ValueKey('handshake')),
                    //   ),
                    // ),
                    // label:
                    //     pointsBadge["showBadge"] == true ? "Points" : "Friends",
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
            if (pointsBadge["showBadge"] == true && pointsBadge["points"] > 0)
              PointsOverlay(points: pointsBadge["points"]),
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

class PointsOverlay extends ConsumerStatefulWidget {
  final int points;

  const PointsOverlay({
    super.key,
    required this.points,
  });

  @override
  ConsumerState<PointsOverlay> createState() => _PointsOverlayState();
}

class _PointsOverlayState extends ConsumerState<PointsOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _positionAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500), // Total duration
      vsync: this,
    );

    // Position animation: slide up -> hold -> slide down
    _positionAnimation = TweenSequence<Offset>([
      TweenSequenceItem(
        tween: Tween(
          begin: Offset(0.0, 1.0), // Off-screen at the bottom
          end: Offset(0.0, 0.0), // Fully visible
        ).chain(CurveTween(curve: Curves.easeInOut)), // Slide up
        weight: 20.0,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: Offset(0.0, 0.0), // Fully visible
          end: Offset(0.0, 0.0), // Hold position
        ),
        weight: 60.0,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: Offset(0.0, 0.0), // Fully visible
          end: Offset(0.0, 1.0), // Off-screen at the bottom
        ).chain(CurveTween(curve: Curves.easeInOut)), // Slide down
        weight: 20.0,
      ),
    ]).animate(_controller);

    // Start the animation and trigger badge management after completion
    _controller.forward().then(
      (_) {
        if (mounted) {
          ref
              .read(pointsNotificationManagerProvider.notifier)
              .showBadgeTemporarily(widget.points);
        }
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Calculate the position of the badge based on the selected tab
    final tabWidth = MediaQuery.of(context).size.width / 2;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Positioned(
          bottom:
              kBottomNavigationBarHeight + 8, // Position relative to bottom nav
          left: tabWidth - 30, // This is only while quests is not shown.
          // left: tabWidth * 2.5 - 30, // Center horizontally over the third tab
          child: SlideTransition(
            position: _positionAnimation,
            child: Opacity(
              opacity:
                  // On the animation being done, set opacity to 0
                  _controller.status == AnimationStatus.completed ? 0.0 : 1.0,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '+${widget.points}',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white,
                      ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
