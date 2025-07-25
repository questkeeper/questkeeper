import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:questkeeper/friends/views/desktop_friends_leaderboard.dart';
import 'package:questkeeper/layout/desktop_layout.dart';
import 'package:questkeeper/quests/views/quests_view.dart';
import 'package:questkeeper/shared/widgets/snackbar.dart';
import 'package:questkeeper/spaces/views/desktop_spaces_screen.dart';
import 'package:questkeeper/auth/providers/auth_provider.dart';
import 'package:questkeeper/layout/utils/state_providers.dart';
import 'package:questkeeper/shared/utils/analytics/analytics.dart';

import 'package:questkeeper/friends/views/friends_main_leaderboard.dart';
import 'package:questkeeper/friends/widgets/friend_search.dart';
import 'package:questkeeper/settings/views/settings_screen.dart';
import 'package:questkeeper/shared/notifications/points_notification_provider.dart';
import 'package:questkeeper/shared/widgets/show_drawer.dart';
import 'package:questkeeper/spaces/views/all_spaces_screen.dart';
import 'package:questkeeper/tabs/modern_bottom_bar.dart';
import 'package:questkeeper/task_list/views/edit_task_drawer.dart';
import 'package:questkeeper/shared/providers/window_size_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:questkeeper/auth/providers/auth_state_provider.dart';

class TabView extends ConsumerStatefulWidget {
  const TabView({super.key});

  @override
  ConsumerState<TabView> createState() => _TabViewState();
}

class _TabViewState extends ConsumerState<TabView> {
  final supabase = Supabase.instance.client;
  int _selectedIndex = 0;
  bool _hasInitialized = false;
  bool _oauthLinkPromptShown = false;

  static final List<Widget> _mobilePages = [
    AllSpacesScreen(),
    FriendsList(),
    QuestsView(),
  ];

  static final List<Widget> _desktopPages = [
    DesktopSpacesScreen(),
    DesktopFriendsLeaderboard(),
    QuestsView(),
    SettingsScreen(),
  ];

  // Tab name mapping for analytics
  static final List<String> _tabNames = [
    'spaces',
    'friends',
    'quests',
    'settings',
  ];

  @override
  void initState() {
    super.initState();

    AuthNotifier().setFirebaseMessaging();

    // Try registering the user
    if (supabase.auth.currentUser != null) {
      Analytics.instance.identify(
        userId: supabase.auth.currentUser!.id,
        userPropertiesSetOnce: {
          "created_at": supabase.auth.currentUser!.createdAt,
        },
        userProperties: {
          'email': supabase.auth.currentUser?.email ?? "",
          'username':
              supabase.auth.currentUser?.userMetadata?['username'] ?? "",
          'provider': supabase.auth.currentUser?.appMetadata['provider'] ?? "",
        },
      );
    }

    Analytics.instance.trackEvent(
      eventName: 'app_launched',
    );

    // Track initial screen view
    Analytics.instance.trackScreen(
      screenName: _tabNames[_selectedIndex],
    );
  }

  void _onItemTapped(int index) async {
    // Don't track if it's the same tab
    if (index != _selectedIndex) {
      // Track tab change
      Analytics.instance.trackEvent(
        eventName: 'tab_changed',
        properties: {
          'from': _tabNames[_selectedIndex],
          'to': _tabNames[index],
        },
      );

      // Track new screen view
      Analytics.instance.trackScreen(
        screenName: _tabNames[index],
      );
    }

    setState(() {
      _selectedIndex = index;
    });

    // Update the context pane provider when tab changes
    ref.read(contextPaneProvider.notifier).state = _buildContextualPane(index);
  }

  @override
  Widget build(BuildContext context) {
    final pointsBadge = ref.watch(pointsNotificationManagerProvider);
    final authState = ref.watch(authStateProvider);

    // Prompt for OAuth linking if applicable and not yet shown
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_oauthLinkPromptShown &&
          authState.isAuthenticated == true &&
          authState.profile?.isActive == true) {
        final currentUser = supabase.auth.currentUser;
        final isEmailUser = currentUser?.appMetadata['provider'] == 'email';
        final hasLinkedOauth = currentUser?.identities
                ?.any((identity) => identity.provider != 'email') ??
            false;

        if (isEmailUser && !hasLinkedOauth) {
          SnackbarService.showErrorSnackbar(
            'Email accounts are being deprecated! Stay logged in by linking a Google or Apple account.',
            callback: () {
              Navigator.of(context).pushNamed('/settings/account');
            },
            callbackIcon: const Icon(LucideIcons.settings),
            callbackText: 'Go to Settings',
          );
          setState(() {
            _oauthLinkPromptShown = true;
          });
        }
      }
    });

    return LayoutBuilder(
      builder: (context, constraints) {
        // Schedule the size update for the next frame
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref.read(windowSizeProvider.notifier).setSize(Size(
                constraints.maxWidth,
                constraints.maxHeight,
              ));
        });

        final isMobile = ref.watch(isMobileProvider);
        if (!_hasInitialized) {
          _hasInitialized = true;

          // Track app layout
          Analytics.instance.trackEvent(
            eventName: 'app_layout_loaded',
            properties: {
              'is_mobile': isMobile,
              'width': constraints.maxWidth,
              'height': constraints.maxHeight,
            },
          );
        }

        if (isMobile) {
          // Mobile layout
          return Scaffold(
            extendBody: true,
            body: Stack(
              children: [
                Scaffold(
                  body: Stack(
                    children: List.generate(_mobilePages.length, (index) {
                      return AnimatedOpacity(
                        // FadeThrough transition
                        duration: const Duration(milliseconds: 300),
                        opacity: _selectedIndex == index ? 1.0 : 0,
                        curve: Curves.easeInToLinear,
                        child: IgnorePointer(
                          ignoring: _selectedIndex != index,
                          child: _mobilePages[index],
                        ),
                      );
                    }),
                  ),
                ),

                // Floating bottom bar
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: kBottomNavigationBarHeight - 24,
                  child: ModernBottomBar(
                    currentIndex: _selectedIndex,
                    onTap: _onItemTapped,
                    leadingAction: NavActionButton(
                      onPressed: () {
                        Analytics.instance.trackEvent(
                          eventName: 'settings_opened',
                          properties: {
                            'from_tab': _tabNames[_selectedIndex],
                          },
                        );
                        showDrawer(
                          context: context,
                          child: SettingsScreen(),
                          key: 'settings_drawer',
                          widthOffsetLeftLean: false,
                        );
                      },
                      icon: LucideIcons.settings,
                      tooltip: 'Settings',
                    ),
                    trailingAction: _buildContextualAction(
                      _selectedIndex,
                    ),
                    items: [
                      ModernBottomBarItem(
                        label: 'Spaces',
                        icon: LucideIcons.eclipse,
                      ),
                      ModernBottomBarItem(
                        label: 'Friends',
                        icon: LucideIcons.handshake,
                      ),
                      ModernBottomBarItem(
                        label: 'Quests',
                        icon: LucideIcons.trophy,
                      ),
                    ],
                  ),
                ),

                if (pointsBadge["showBadge"] == true &&
                    pointsBadge["points"] > 0)
                  PointsOverlay(points: pointsBadge["points"]),
              ],
            ),
          );
        } else {
          // Desktop layout with responsive pane behavior
          return DesktopLayout(
            selectedIndex: _selectedIndex,
            onTabSelected: _onItemTapped,
            mainContent: _desktopPages[_selectedIndex],
            contextPane: _buildContextualPane(_selectedIndex),
          );
        }
      },
    );
  }

  Widget? _buildContextualPane(int index) {
    // Original pane behavior for larger screens
    switch (index) {
      case 0:
        return getTaskDrawerContent(
          context: context,
          ref: ref,
          existingTask: null,
        );
      case 1:
        return FriendSearchView();
      default:
        return null;
    }
  }

  Widget _buildContextualAction(int index) {
    switch (index) {
      case 0: // Spaces tab
        return NavActionButton(
          key: const Key('add_task_button_mobile'),
          // heroTag: 'add_task_button_mobile',
          onPressed: () => {
            Analytics.instance.trackEvent(
              eventName: 'add_task_drawer_opened',
              properties: {
                'from_tab': _tabNames[_selectedIndex],
              },
            ),
            showTaskDrawer(
              context: context,
              ref: ref,
              existingTask: null,
            ),
          },
          icon: LucideIcons.plus,
          tooltip: 'Add Task',
          isColoredPrimary: true,
        );
      case 1: // Friends tab
        return NavActionButton(
          onPressed: () {
            Analytics.instance.trackEvent(
              eventName: 'add_friend_drawer_opened',
              properties: {
                'from_tab': _tabNames[_selectedIndex],
              },
            );
            showDrawer(
              context: context,
              key: "add_friend_drawer",
              child: FriendSearchView(),
            );
          },
          icon: LucideIcons.user_search,
          tooltip: 'Add Friend',
          isColoredPrimary: true,
        );
      default:
        return const NavActionButton(
          isEmpty: true,
        );
    }
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

    // Track points notification
    Analytics.instance.trackEvent(
      eventName: 'points_earned',
      properties: {
        'points': widget.points,
      },
    );

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
