// ignore_for_file: deprecated_member_use
// This is because of rawbeyboardlistener, if the regular kb listener worked
// we'd use that instead..

import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:questkeeper/layout/utils/command_palette_list.dart';
import 'package:questkeeper/layout/utils/state_providers.dart';
import 'package:questkeeper/layout/widgets/nav_rail_item.dart';
import 'package:questkeeper/layout/widgets/resizable_pane_container.dart';
import 'package:questkeeper/profile/providers/profile_provider.dart';
import 'package:questkeeper/shared/providers/window_size_provider.dart';
import 'package:questkeeper/shared/widgets/avatar_widget.dart';
import 'package:questkeeper/shared/widgets/command_palette.dart';
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

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

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
                appBar: AppBar(
                  toolbarHeight: MediaQuery.of(context).padding.top,
                  backgroundColor: colorScheme.surface,
                ),
                backgroundColor: colorScheme.surface,
                body: Column(
                  children: [
                    // Command Palette Bar
                    Container(
                      padding: EdgeInsets.fromLTRB(12, 12, 12, 0),
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
                            padding: const EdgeInsets.fromLTRB(12, 12, 0, 12),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: isNavRailExpanded ? 180 : 72,
                              decoration: BoxDecoration(
                                color: colorScheme.surfaceContainerLow,
                                borderRadius: BorderRadius.circular(12),
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
                                            isSelected:
                                                widget.selectedIndex == 0,
                                            isExpanded: isNavRailExpanded,
                                            onTap: () =>
                                                widget.onTabSelected(0),
                                          ),
                                          NavRailItem(
                                            icon: LucideIcons.handshake,
                                            label: 'Friends',
                                            isSelected:
                                                widget.selectedIndex == 1,
                                            isExpanded: isNavRailExpanded,
                                            onTap: () =>
                                                widget.onTabSelected(1),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  const Divider(indent: 12, endIndent: 12),

                                  NavRailItem(
                                    icon: LucideIcons.settings,
                                    label: 'Settings',
                                    isSelected: widget.selectedIndex == 2,
                                    isExpanded: isNavRailExpanded,
                                    onTap: () => widget.onTabSelected(2),
                                  ),

                                  NavRailItem(
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

                                  _buildProfileView(
                                      isNavRailExpanded, colorScheme),
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
              if (isCommandPaletteVisible)
                CommandPalette(
                  commands: buildCommandPaletteList(
                      context, ref, widget.onTabSelected),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProfileView(bool isNavRailExpanded, ColorScheme colorScheme) {
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
            loading: () => Center(child: CircularProgressIndicator()),
            data: (profileData) => Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.shadow.withValues(alpha: 0.1),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: AvatarWidget(
                      seed: profileData.user_id,
                      radius: 14,
                    ),
                  ),
                  if (isNavRailExpanded) ...[
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "@${profileData.username}",
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color:
                                  colorScheme.onSurface.withValues(alpha: 0.8),
                            ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
    );
  }
}
