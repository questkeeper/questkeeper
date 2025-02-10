import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:questkeeper/friends/widgets/friend_search.dart';
import 'package:questkeeper/layout/utils/state_providers.dart';
import 'package:questkeeper/shared/widgets/command_palette.dart';
import 'package:questkeeper/shared/widgets/show_drawer.dart';
import 'package:questkeeper/task_list/views/edit_task_drawer.dart';
import 'package:questkeeper/task_list/providers/tasks_provider.dart';
import 'package:questkeeper/task_list/models/tasks_model.dart';
import 'package:questkeeper/shared/widgets/search_dialog.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:feedback_sentry/feedback_sentry.dart';
import 'package:questkeeper/settings/views/settings_screen.dart';
import 'package:questkeeper/shared/providers/theme_notifier.dart'
    show themeNotifier;
import 'package:questkeeper/spaces/providers/spaces_provider.dart';
import 'package:questkeeper/spaces/providers/page_provider.dart';

List<Command> buildCommandPaletteList(
    BuildContext context, WidgetRef ref, dynamic Function(int) onTabSelected) {
  final isDarkMode = Theme.of(context).brightness == Brightness.dark;
  final textScale = themeNotifier.textScaleNotifier.value;

  return [
    // Main Quick Actions (Always visible at top)
    Command(
      title: 'Find Task',
      description: 'Search and edit existing tasks',
      icon: LucideIcons.search,
      onExecute: () async {
        // First switch to spaces tab
        await onTabSelected(0);

        if (!context.mounted) return;

        if (context.mounted) {
          await showDialog(
            context: context,
            builder: (context) => Consumer(
              builder: (context, dialogRef, _) {
                final tasks = dialogRef.watch(tasksManagerProvider);
                return tasks.when(
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  error: (error, stack) => Center(
                    child: Text('Error loading tasks: $error'),
                  ),
                  data: (currentTasks) => SearchDialog<Tasks>(
                    items: currentTasks,
                    getTitle: (task) => task.title,
                    getDescription: (task) => task.description,
                    hintText: 'Search tasks...',
                    searchFilter: (task, query) {
                      final titleMatch =
                          task.title.toLowerCase().contains(query);
                      final descriptionMatch =
                          task.description?.toLowerCase().contains(query) ??
                              false;
                      return titleMatch || descriptionMatch;
                    },
                    onItemSelected: (Tasks task) async {
                      if (context.mounted) {
                        final parentContext = Navigator.of(context).context;
                        dialogRef
                            .read(commandPaletteVisibleProvider.notifier)
                            .state = false;

                        final spacesList = dialogRef
                                .read(spacesManagerProvider)
                                .asData
                                ?.value ??
                            [];
                        final spaceIndex = spacesList
                            .indexWhere((space) => space.id == task.spaceId);

                        if (spaceIndex != -1) {
                          final pageController =
                              dialogRef.read(pageControllerProvider);
                          await pageController.animateToPage(
                            spaceIndex,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }

                        // Use the parent context ref after animation
                        if (parentContext.mounted) {
                          showTaskDrawer(
                            context: parentContext,
                            ref: ref,
                            existingTask: task,
                          );
                        }
                      }
                    },
                  ),
                );
              },
            ),
          );
        }
      },
      searchTerms: 'find search task edit modify update',
    ),
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
      title: 'Zen mode',
      description: 'Enter zen mode and remove all distractions',
      icon: LucideIcons.menu,
      onExecute: () {
        if (ref.read(zenModeProvider.notifier).state == false) {
          ref.read(navRailExpandedProvider.notifier).state = false;
          ref.read(zenModeProvider.notifier).state = true;
        } else {
          ref.read(zenModeProvider.notifier).state = false;
          ref.read(navRailExpandedProvider.notifier).state =
              !ref.watch(navRailExpandedProvider);
        }
      },
    ),

    // Navigation Commands
    Command(
      title: 'Go to Spaces',
      description: 'Switch to the Spaces tab',
      icon: LucideIcons.eclipse,
      onExecute: () => onTabSelected(0),
      searchTerms: 'spaces home dashboard main',
    ),
    Command(
      title: 'Go to Friends',
      description: 'Switch to the Friends tab',
      icon: LucideIcons.handshake,
      onExecute: () => onTabSelected(1),
      searchTerms: 'friends social leaderboard',
    ),
    Command(
      title: 'Go to Settings',
      description: 'Switch to the Settings tab',
      icon: LucideIcons.settings,
      onExecute: () => onTabSelected(2),
      searchTerms: 'settings preferences configuration',
    ),

    // Theme Controls
    Command(
      title: 'Toggle Dark Mode',
      description: isDarkMode ? 'Switch to light mode' : 'Switch to dark mode',
      icon: isDarkMode ? LucideIcons.sun : LucideIcons.moon,
      onExecute: () {
        themeNotifier.themeModeNotifier.value =
            isDarkMode ? ThemeMode.light : ThemeMode.dark;
      },
      searchTerms: 'theme dark light mode appearance color switch toggle',
    ),
    Command(
      title: 'System Theme',
      description: 'Use system theme settings',
      icon: LucideIcons.monitor,
      onExecute: () {
        themeNotifier.themeModeNotifier.value = ThemeMode.system;
      },
      searchTerms: 'theme system auto appearance color mode',
    ),
    Command(
      title: 'Increase Text Size',
      description: 'Make text larger',
      icon: LucideIcons.plus,
      onExecute: () {
        themeNotifier.textScaleNotifier.value = textScale + 0.1;
      },
      searchTerms: 'text size larger bigger font increase scale',
    ),
    Command(
      title: 'Decrease Text Size',
      description: 'Make text smaller',
      icon: LucideIcons.minus,
      onExecute: () {
        themeNotifier.textScaleNotifier.value = textScale - 0.1;
      },
      searchTerms: 'text size smaller font decrease scale',
    ),
    Command(
      title: 'Reset Text Size',
      description: 'Reset text size to default',
      icon: LucideIcons.undo,
      onExecute: () {
        themeNotifier.textScaleNotifier.value = 1.0;
      },
      searchTerms: 'text size reset default font scale',
    ),

    // Profile & Account Settings
    Command(
      title: 'Edit Profile',
      description: 'Change your profile settings',
      icon: LucideIcons.user,
      onExecute: () => Navigator.pushNamed(context, '/settings/profile'),
      searchTerms: 'profile account user settings avatar username',
    ),
    Command(
      title: 'Account Management',
      description: 'Manage your account settings and data',
      icon: LucideIcons.user_cog,
      onExecute: () => Navigator.pushNamed(context, '/settings/account'),
      searchTerms: 'account management data delete settings',
    ),

    // App Preferences
    Command(
      title: 'Change Theme',
      description: 'Customize app appearance',
      icon: LucideIcons.palette,
      onExecute: () => Navigator.pushNamed(context, '/settings/theme'),
      searchTerms: 'theme dark light appearance color mode customize',
    ),
    Command(
      title: 'Notification Settings',
      description: 'Manage your notifications',
      icon: LucideIcons.bell_ring,
      onExecute: () => Navigator.pushNamed(context, '/settings/notifications'),
      searchTerms: 'notifications alerts settings push',
    ),
    Command(
      title: 'Privacy Settings',
      description: 'Manage privacy and data settings',
      icon: LucideIcons.shield,
      onExecute: () => Navigator.pushNamed(context, '/settings/privacy'),
      searchTerms: 'privacy security data tracking settings',
    ),

    // Support & Information
    Command(
      title: 'Send Feedback',
      description: 'Report bugs or suggest features',
      icon: LucideIcons.bug,
      onExecute: () {
        if (context.mounted) {
          BetterFeedback.of(context).showAndUploadToSentry(
            name: Supabase.instance.client.auth.currentUser?.id ?? 'Unknown',
            email: Supabase.instance.client.auth.currentUser?.email ??
                'Unknown@questkeeper.app',
          );
        }
      },
      searchTerms: 'feedback bug report issue help support',
    ),
    Command(
      title: 'About QuestKeeper',
      description: 'View app information',
      icon: LucideIcons.info,
      onExecute: () => Navigator.pushNamed(context, '/settings/about'),
      searchTerms: 'about info version information app',
    ),
    Command(
      title: 'Experimental Features',
      description: 'Enable experimental features',
      icon: LucideIcons.flask_conical,
      onExecute: () => Navigator.pushNamed(context, '/settings/experiments'),
      searchTerms: 'experiments beta features testing',
    ),

    // Sign Out
    Command(
      title: 'Sign Out',
      description: 'Sign out and remove local data',
      icon: LucideIcons.log_out,
      onExecute: () => signOut(context),
      searchTerms: 'sign out logout exit quit',
    ),
  ];
}
