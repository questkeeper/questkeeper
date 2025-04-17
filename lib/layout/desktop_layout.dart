// ignore_for_file: deprecated_member_use
// This is because of rawbeyboardlistener, if the regular kb listener worked
// we'd use that instead..

import 'dart:io' show Platform, exit;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:questkeeper/categories/providers/categories_provider.dart';
import 'package:questkeeper/friends/providers/friends_provider.dart';
import 'package:questkeeper/layout/utils/command_palette_list.dart';
import 'package:questkeeper/layout/utils/state_providers.dart';
import 'package:questkeeper/layout/widgets/nav_rail_item.dart';
import 'package:questkeeper/layout/widgets/resizable_pane_container.dart';
import 'package:questkeeper/profile/providers/profile_provider.dart';
import 'package:questkeeper/shared/providers/window_size_provider.dart';
import 'package:questkeeper/shared/utils/analytics/analytics.dart';
import 'package:questkeeper/shared/widgets/avatar_widget.dart';
import 'package:questkeeper/shared/widgets/command_palette.dart';
import 'package:questkeeper/spaces/providers/spaces_provider.dart';
import 'package:questkeeper/task_list/providers/tasks_provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class DesktopLayout extends ConsumerStatefulWidget {
  final Widget mainContent;
  final Widget? contextPane;
  final int selectedIndex;
  final Function(int) onTabSelected;

  const DesktopLayout({
    super.key,
    required this.mainContent,
    this.contextPane,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  @override
  ConsumerState<DesktopLayout> createState() => _DesktopLayoutState();
}

class _DesktopLayoutState extends ConsumerState<DesktopLayout> {
  final FocusNode _focusNode = FocusNode(
    debugLabel: 'command_palete_keyboard_listener',
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });

    // Track desktop layout loaded
    Analytics.instance.trackEvent(
      eventName: 'desktop_layout_loaded',
      properties: {
        'with_context_pane': widget.contextPane != null,
      },
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _toggleCommandPalette() {
    final isVisible = ref.read(commandPaletteVisibleProvider);
    final willBeVisible = !isVisible;

    Analytics.instance.trackEvent(
      eventName:
          willBeVisible ? 'command_palette_opened' : 'command_palette_closed',
      properties: {
        'from_tab_index': widget.selectedIndex,
        'via': 'button_click',
      },
    );

    ref.read(commandPaletteVisibleProvider.notifier).state = willBeVisible;
  }

  void _handleKeyEvent(RawKeyEvent event) {
    // Only handle key down events to avoid double-triggering
    if (event is! RawKeyDownEvent) return;
    final isModifierPressed =
        Platform.isMacOS ? event.isMetaPressed : event.isControlPressed;

    if (isModifierPressed) {
      if (event.logicalKey == LogicalKeyboardKey.keyQ) {
        Analytics.instance.trackEvent(
          eventName: 'app_quit',
          properties: {
            'via': 'keyboard_shortcut',
          },
        );
        exit(0);
      }

      // Handle Escape key
      if (event.logicalKey == LogicalKeyboardKey.escape &&
          ref.read(commandPaletteVisibleProvider)) {
        Analytics.instance.trackEvent(
          eventName: 'command_palette_closed',
          properties: {
            'via': 'escape_key',
          },
        );
        ref.read(commandPaletteVisibleProvider.notifier).state = false;
      }

      switch (event.logicalKey) {
        case LogicalKeyboardKey.digit1:
          Analytics.instance.trackEvent(
            eventName: 'tab_changed',
            properties: {
              'from': widget.selectedIndex,
              'to': 0,
              'via': 'keyboard_shortcut',
            },
          );
          widget.onTabSelected(0);
          break;
        case LogicalKeyboardKey.digit2:
          Analytics.instance.trackEvent(
            eventName: 'tab_changed',
            properties: {
              'from': widget.selectedIndex,
              'to': 1,
              'via': 'keyboard_shortcut',
            },
          );
          widget.onTabSelected(1);
          break;
        case LogicalKeyboardKey.digit3:
          Analytics.instance.trackEvent(
            eventName: 'tab_changed',
            properties: {
              'from': widget.selectedIndex,
              'to': 2,
              'via': 'keyboard_shortcut',
            },
          );
          widget.onTabSelected(2);
          break;
        case LogicalKeyboardKey.digit4:
          Analytics.instance.trackEvent(
            eventName: 'tab_changed',
            properties: {
              'from': widget.selectedIndex,
              'to': 3,
              'via': 'keyboard_shortcut',
            },
          );
          widget.onTabSelected(3);
          break;
        case LogicalKeyboardKey.keyR:
          Analytics.instance.trackEvent(
            eventName: 'data_refreshed',
            properties: {
              'via': 'keyboard_shortcut',
            },
          );
          ref.invalidate(
            spacesManagerProvider,
          );
          ref.invalidate(
            profileManagerProvider,
          );
          ref.invalidate(
            tasksManagerProvider,
          );
          ref.invalidate(
            categoriesManagerProvider,
          );
          ref.invalidate(
            friendsManagerProvider,
          );
          break;
        case LogicalKeyboardKey.keyP:
          Analytics.instance.trackEvent(
            eventName: 'command_palette_toggled',
            properties: {
              'via': 'keyboard_shortcut',
              'from_tab': widget.selectedIndex,
            },
          );
          _toggleCommandPalette();
          break;
        default:
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isNavRailExpanded = ref.watch(navRailExpandedProvider);
    final isCompact = ref.watch(isCompactProvider);
    final isCommandPaletteVisible = ref.watch(commandPaletteVisibleProvider);

    return RawKeyboardListener(
      focusNode: _focusNode,
      onKey: _handleKeyEvent,
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: colorScheme.surface,
            body: SafeArea(
              child: Column(
                children: [
                  // Command Palette Bar with Window Controls
                  Container(
                    height: 48, // Adding fixed height for the title bar
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 800),
                        child: InkWell(
                          onTap: _toggleCommandPalette,
                          borderRadius: BorderRadius.circular(6),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.surfaceContainerLow,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: colorScheme.outlineVariant,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  LucideIcons.search,
                                  size: 16,
                                  color: colorScheme.onSurface.withOpacity(0.5),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Search or type a command...',
                                  style: TextStyle(
                                    color:
                                        colorScheme.onSurface.withOpacity(0.5),
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: colorScheme.surfaceContainerHigh,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    Platform.isMacOS ? '⌘P' : 'Ctrl+P',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: colorScheme.onSurface
                                          .withOpacity(0.5),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Main Content
                  Expanded(
                    child: Row(
                      children: [
                        // Floating Nav Rail with expansion
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: isNavRailExpanded ? 200 : 72,
                            decoration: BoxDecoration(
                              color: colorScheme.surfaceContainerLow,
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(12),
                                bottomRight: Radius.circular(12),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: colorScheme.shadow.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Custom Nav Rail
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12.0),
                                    child: Column(
                                      children: [
                                        NavRailItem(
                                          icon: LucideIcons.eclipse,
                                          label: 'Spaces',
                                          isSelected: widget.selectedIndex == 0,
                                          isExpanded: isNavRailExpanded,
                                          onTap: () {
                                            Analytics.instance.trackEvent(
                                              eventName: 'tab_changed',
                                              properties: {
                                                'from': widget.selectedIndex,
                                                'to': 0,
                                                'via': 'nav_rail',
                                              },
                                            );
                                            widget.onTabSelected(0);
                                          },
                                        ),
                                        NavRailItem(
                                          icon: LucideIcons.handshake,
                                          label: 'Friends',
                                          isSelected: widget.selectedIndex == 1,
                                          isExpanded: isNavRailExpanded,
                                          onTap: () {
                                            Analytics.instance.trackEvent(
                                              eventName: 'tab_changed',
                                              properties: {
                                                'from': widget.selectedIndex,
                                                'to': 1,
                                                'via': 'nav_rail',
                                              },
                                            );
                                            widget.onTabSelected(1);
                                          },
                                        ),
                                        NavRailItem(
                                          icon: LucideIcons.trophy,
                                          label: 'Quests',
                                          isSelected: widget.selectedIndex == 2,
                                          isExpanded: isNavRailExpanded,
                                          onTap: () {
                                            Analytics.instance.trackEvent(
                                              eventName: 'tab_changed',
                                              properties: {
                                                'from': widget.selectedIndex,
                                                'to': 2,
                                                'via': 'nav_rail',
                                              },
                                            );
                                            widget.onTabSelected(2);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                const Divider(indent: 12, endIndent: 12),

                                NavRailItem(
                                  icon: LucideIcons.settings,
                                  label: 'Settings',
                                  isSelected: widget.selectedIndex == 3,
                                  isExpanded: isNavRailExpanded,
                                  onTap: () {
                                    Analytics.instance.trackEvent(
                                      eventName: 'tab_changed',
                                      properties: {
                                        'from': widget.selectedIndex,
                                        'to': 3,
                                        'via': 'nav_rail',
                                      },
                                    );
                                    widget.onTabSelected(3);
                                  },
                                ),

                                NavRailItem(
                                  icon: isNavRailExpanded
                                      ? LucideIcons.panel_left
                                      : LucideIcons.panel_right,
                                  label: 'Shrink',
                                  isSelected: !isNavRailExpanded,
                                  isExpanded: isNavRailExpanded,
                                  onTap: () {
                                    final willExpand = !isNavRailExpanded;
                                    Analytics.instance.trackEvent(
                                      eventName: willExpand
                                          ? 'nav_rail_expanded'
                                          : 'nav_rail_collapsed',
                                    );
                                    ref
                                        .read(navRailExpandedProvider.notifier)
                                        .state = willExpand;
                                  },
                                ),

                                _buildProfileView(colorScheme),
                              ],
                            ),
                          ),
                        ),

                        // Main Content Area with Resizable Panes
                        Expanded(
                          child: widget.contextPane != null
                              ? ResizablePaneContainer(
                                  mainContent: widget.mainContent,
                                  contextPane: widget.contextPane,
                                  isCompact: isCompact,
                                )
                              : widget.mainContent,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isCommandPaletteVisible)
            CommandPalette(
              commands:
                  buildCommandPaletteList(context, ref, widget.onTabSelected),
            ),
        ],
      ),
    );
  }

  Widget _buildProfileView(ColorScheme colorScheme) {
    final isNavRailExpanded = ref.watch(navRailExpandedProvider);
    return Consumer(
      builder: (context, ref, child) => ref.watch(profileManagerProvider).when(
            error: (error, stack) {
              Sentry.captureException(
                error,
                stackTrace: stack,
              );

              return const Center(
                child: Text("Failed to fetch friends list"),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            data: (profileData) {
              return NavRailItem(
                leading: AvatarWidget(
                  seed: profileData.user_id,
                  radius: 14,
                ),
                label: "@${profileData.username}",
                isSelected: false,
                isExpanded: isNavRailExpanded,
                onTap: () => {
                  debugPrint("tapped"),
                },
              );
            },
          ),
    );
  }
}
