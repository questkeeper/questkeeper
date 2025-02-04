// ignore_for_file: deprecated_member_use
// This is because of rawbeyboardlistener, if the regular kb listener worked
// we'd use that instead..

import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:questkeeper/profile/providers/profile_provider.dart';
import 'package:questkeeper/shared/providers/window_size_provider.dart';
import 'package:questkeeper/shared/widgets/avatar_widget.dart';
import 'package:questkeeper/shared/widgets/command_palette.dart';
import 'package:questkeeper/shared/widgets/show_drawer.dart';
import 'package:questkeeper/task_list/views/edit_task_drawer.dart';
import 'package:questkeeper/friends/widgets/friend_search.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

final navRailExpandedProvider = StateProvider<bool>((ref) => false);
final commandPaletteVisibleProvider = StateProvider<bool>((ref) => false);

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
  final ValueNotifier<bool> commandPaletteVisibleNotifier =
      ValueNotifier(false);
  final FocusNode _focusNode = FocusNode(
    debugLabel: 'command_palete_keyboard_listener',
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  List<Command> get _commands => [
        Command(
          title: 'New Task',
          description: 'Create a new task',
          icon: LucideIcons.plus,
          onExecute: () {
            showDrawer(
              context: context,
              key: 'new_task_drawer',
              child: getTaskDrawerContent(
                context: context,
                ref: ref,
                existingTask: null,
              ),
            );
          },
        ),
        Command(
          title: 'Search Friends',
          description: 'Find and add new friends',
          icon: LucideIcons.users,
          onExecute: () {
            showDrawer(
              context: context,
              key: 'friend_search_drawer',
              child: FriendSearchView(),
            );
          },
        ),
        Command(
          title: 'Toggle Navigation',
          description: 'Expand or collapse the navigation rail',
          icon: LucideIcons.menu,
          onExecute: () {
            ref.read(navRailExpandedProvider.notifier).state =
                !ref.watch(navRailExpandedProvider);
          },
        ),
        Command(
          title: 'Go to Spaces',
          description: 'Switch to the Spaces tab',
          icon: LucideIcons.eclipse,
          onExecute: () => widget.onTabSelected(0),
        ),
        Command(
          title: 'Go to Friends',
          description: 'Switch to the Friends tab',
          icon: LucideIcons.handshake,
          onExecute: () => widget.onTabSelected(1),
        ),
      ];

  void _toggleCommandPalette() {
    commandPaletteVisibleNotifier.value = !commandPaletteVisibleNotifier.value;
  }

  void _handleKeyEvent(RawKeyEvent event) {
    // Only handle key down events to avoid double-triggering
    if (event is! RawKeyDownEvent) return;

    // Check for Cmd+P (macOS) or Ctrl+P (Windows/Linux)
    if (event.logicalKey == LogicalKeyboardKey.keyP) {
      final isModifierPressed =
          Platform.isMacOS ? event.isMetaPressed : event.isControlPressed;

      if (isModifierPressed) {
        _toggleCommandPalette();
      }
    }

    // Handle Escape key
    if (event.logicalKey == LogicalKeyboardKey.escape &&
        commandPaletteVisibleNotifier.value) {
      commandPaletteVisibleNotifier.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isNavRailExpanded = ref.watch(navRailExpandedProvider);
    final isCompact = ref.watch(isCompactProvider);

    return RawKeyboardListener(
      focusNode: _focusNode,
      onKey: _handleKeyEvent,
      child: ValueListenableBuilder<bool>(
        valueListenable: commandPaletteVisibleNotifier,
        builder: (context, isCommandPaletteVisible, _) {
          return Stack(
            children: [
              Scaffold(
                backgroundColor: colorScheme.surface,
                body: Column(
                  children: [
                    // Command Palette Bar
                    Container(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 800),
                          child: InkWell(
                            onTap: _toggleCommandPalette,
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: colorScheme.surfaceContainerLow,
                                borderRadius: BorderRadius.circular(8),
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
                                    color:
                                        colorScheme.onSurface.withOpacity(0.5),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Search or type a command...',
                                    style: TextStyle(
                                      color: colorScheme.onSurface
                                          .withOpacity(0.5),
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
                            padding: const EdgeInsets.fromLTRB(16, 16, 0, 16),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: isNavRailExpanded ? 200 : 80,
                              decoration: BoxDecoration(
                                color: colorScheme.surfaceContainerLow,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: colorScheme.shadow.withOpacity(0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  // Custom Nav Rail
                                  Expanded(
                                    child: Column(
                                      children: [
                                        _NavRailItem(
                                          icon: LucideIcons.eclipse,
                                          label: 'Spaces',
                                          isSelected: widget.selectedIndex == 0,
                                          isExpanded: isNavRailExpanded,
                                          onTap: () => widget.onTabSelected(0),
                                        ),
                                        _NavRailItem(
                                          icon: LucideIcons.handshake,
                                          label: 'Friends',
                                          isSelected: widget.selectedIndex == 1,
                                          isExpanded: isNavRailExpanded,
                                          onTap: () => widget.onTabSelected(1),
                                        ),
                                      ],
                                    ),
                                  ),

                                  const Divider(indent: 16, endIndent: 16),

                                  _NavRailItem(
                                    icon: LucideIcons.settings,
                                    label: 'Settings',
                                    isSelected: false,
                                    isExpanded: isNavRailExpanded,
                                    onTap: () => widget.onTabSelected(2),
                                  ),

                                  _NavRailItem(
                                    icon: isNavRailExpanded
                                        ? LucideIcons.panel_left
                                        : LucideIcons.panel_right,
                                    label: 'Shrink',
                                    isSelected: !isNavRailExpanded,
                                    isExpanded: isNavRailExpanded,
                                    onTap: () => ref
                                        .read(navRailExpandedProvider.notifier)
                                        .state = !isNavRailExpanded,
                                  ),

                                  Consumer(
                                    builder: (context, ref, child) => ref
                                        .watch(profileManagerProvider)
                                        .when(
                                          error: (error, stack) {
                                            Sentry.captureException(
                                              error,
                                              stackTrace: stack,
                                            );

                                            return const Center(
                                              child: Text(
                                                  "Failed to fetch friends list"),
                                            );
                                          },
                                          loading: () => Center(
                                              child:
                                                  CircularProgressIndicator()),
                                          data: (profileData) => Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: colorScheme
                                                            .shadow
                                                            .withValues(
                                                                alpha: 0.1),
                                                        blurRadius: 8,
                                                        offset:
                                                            const Offset(0, 2),
                                                      ),
                                                    ],
                                                  ),
                                                  child: AvatarWidget(
                                                    seed: profileData.user_id,
                                                    radius: 16,
                                                  ),
                                                ),
                                                if (isNavRailExpanded) ...[
                                                  const SizedBox(width: 12),
                                                  Expanded(
                                                    child: Text(
                                                      "@${profileData.username}",
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyLarge
                                                          ?.copyWith(
                                                            color: colorScheme
                                                                .onSurface
                                                                .withValues(
                                                                    alpha: 0.8),
                                                          ),
                                                    ),
                                                  ),
                                                ],
                                              ],
                                            ),
                                          ),
                                        ),
                                  ),
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
                                  )
                                : widget.mainContent,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                floatingActionButton: isCompact ? _buildContextualFAB() : null,
              ),
              if (isCommandPaletteVisible) CommandPalette(commands: _commands),
            ],
          );
        },
      ),
    );
  }

  Widget? _buildContextualFAB() {
    switch (widget.selectedIndex) {
      case 0: // Spaces tab
        return FloatingActionButton(
          heroTag: 'add_task_button_desktop',
          onPressed: () {
            showDrawer(
              context: context,
              key: 'new_task_drawer',
              child: getTaskDrawerContent(
                context: context,
                ref: ref,
                existingTask: null,
              ),
            );
          },
          child: const Icon(LucideIcons.plus),
        );
      case 1: // Friends tab
        return FloatingActionButton(
          heroTag: 'friend_search_button',
          onPressed: () {
            showDrawer(
              context: context,
              key: 'friend_search_drawer',
              child: FriendSearchView(),
            );
          },
          child: const Icon(LucideIcons.users),
        );
      default:
        return null;
    }
  }
}

class _NavRailItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final bool isExpanded;
  final VoidCallback onTap;

  const _NavRailItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected ? colorScheme.primaryContainer : null,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: isSelected
                      ? colorScheme.primary
                      : colorScheme.onSurface.withValues(alpha: 0.7),
                ),
                if (isExpanded) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      label,
                      style: TextStyle(
                        color: isSelected
                            ? colorScheme.primary
                            : colorScheme.onSurface.withValues(alpha: 0.8),
                        fontWeight: isSelected ? FontWeight.w600 : null,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ResizablePaneContainer extends StatefulWidget {
  final Widget mainContent;
  final Widget? contextPane;

  const ResizablePaneContainer({
    super.key,
    required this.mainContent,
    this.contextPane,
  });

  @override
  State<ResizablePaneContainer> createState() => _ResizablePaneContainerState();
}

class _ResizablePaneContainerState extends State<ResizablePaneContainer> {
  double _contextPaneWidth = 320;
  bool _isContextPaneCollapsed = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Main content
        Expanded(child: widget.mainContent),

        // Resizable context pane
        if (widget.contextPane != null) ...[
          !_isContextPaneCollapsed
              ? GestureDetector(
                  onHorizontalDragUpdate: (details) {
                    setState(() {
                      _contextPaneWidth = (_contextPaneWidth - details.delta.dx)
                          .clamp(320.0, 600.0);
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 24, 8, 24),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.resizeLeftRight,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).dividerColor.withAlpha(100),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        width: 4,
                      ),
                    ),
                  ),
                )
              : SizedBox.shrink(),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 16, 16, 16),
            child: AnimatedContainer(
              decoration: BoxDecoration(
                color: ColorScheme.of(context).surfaceContainerLow,
                borderRadius: BorderRadius.circular(12),
              ),
              duration: const Duration(milliseconds: 200),
              width: _isContextPaneCollapsed ? 48 : _contextPaneWidth,
              child: Column(
                children: [
                  // Toggle collapse button
                  IconButton(
                    icon: Icon(_isContextPaneCollapsed
                        ? LucideIcons.chevron_right
                        : LucideIcons.chevron_left),
                    onPressed: () {
                      setState(() {
                        _isContextPaneCollapsed = !_isContextPaneCollapsed;
                      });
                    },
                  ),
                  Expanded(
                    child: _isContextPaneCollapsed
                        ? GestureDetector(
                            onTap: () => {
                              setState(() {
                                _isContextPaneCollapsed = false;
                              })
                            },
                            child: RotatedBox(
                              quarterTurns: 1,
                              child: Center(
                                child: Text('Expand'),
                              ),
                            ),
                          )
                        : widget.contextPane!,
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}
