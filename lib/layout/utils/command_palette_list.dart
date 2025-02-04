import 'package:flutter/widgets.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:questkeeper/friends/widgets/friend_search.dart';
import 'package:questkeeper/layout/desktop_layout.dart';
import 'package:questkeeper/shared/widgets/command_palette.dart';
import 'package:questkeeper/shared/widgets/show_drawer.dart';
import 'package:questkeeper/task_list/views/edit_task_drawer.dart';

List<Command> buildCommandPaletteList(BuildContext context, WidgetRef ref,
        dynamic Function(int) onTabSelected) =>
    [
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
          onExecute: () => onTabSelected(0)),
      Command(
        title: 'Go to Friends',
        description: 'Switch to the Friends tab',
        icon: LucideIcons.handshake,
        onExecute: () => onTabSelected(1),
      ),
      Command(
        title: 'Go to Settings',
        description: 'Switch to the Settings tab',
        icon: LucideIcons.handshake,
        onExecute: () => onTabSelected(2),
      ),
    ];
