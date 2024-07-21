import 'package:questkeeper/spaces/providers/spaces_provider.dart';
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
  // Tabs for "Home", "Game", "Add task"
  int _selectedIndex = 1;

  void _onItemTapped(int index) async {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const AllSpacesScreen(),
      const AllSpacesScreen(),
      const AllSpacesScreen(),
      const SettingsScreen(),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        if (width < 800) {
          // Mobile layout
          return Scaffold(
            body: RefreshIndicator(
                onRefresh: () {
                  if (ref.read(spacesManagerProvider).isLoading ||
                      ref.read(spacesManagerProvider).isRefreshing) {
                    return Future
                        .value(); // Do nothing if already loading or refreshing
                  } else {
                    return ref
                        .read(spacesManagerProvider.notifier)
                        .refreshSpaces();
                  }
                },
                child: pages[_selectedIndex]),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.miniCenterDocked,
            floatingActionButton: FloatingActionButton(
              onPressed: () => {
                showTaskBottomSheet(
                  context: context,
                  ref: ref,
                  existingTask: null,
                ),
              },
              child: const Icon(LucideIcons.plus),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(LucideIcons.list_start),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(LucideIcons.eclipse),
                  label: 'Spaces',
                ),
                BottomNavigationBarItem(
                  icon: Icon(LucideIcons.trophy),
                  label: 'Arcade',
                ),
                BottomNavigationBarItem(
                    icon: Icon(LucideIcons.user_cog), label: 'Profile'),
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: Colors.accents.first,
              onTap: _onItemTapped,
            ),
          );
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
                    NavigationRailDestination(
                        icon: Icon(LucideIcons.list_start),
                        label: Text('Home')),
                    NavigationRailDestination(
                        icon: Icon(LucideIcons.eclipse), label: Text('Spaces')),
                    NavigationRailDestination(
                        icon: Icon(LucideIcons.trophy), label: Text('Arcade')),
                    NavigationRailDestination(
                        icon: Icon(LucideIcons.user_cog),
                        label: Text('Profile')),
                  ],
                ),
                const VerticalDivider(thickness: 1, width: 1),
                Expanded(
                  child: Scaffold(
                    body: RefreshIndicator(
                        onRefresh: () {
                          if (ref.read(spacesManagerProvider).isLoading ||
                              ref.read(spacesManagerProvider).isRefreshing) {
                            return Future
                                .value(); // Do nothing if already loading or refreshing
                          } else {
                            return ref
                                .read(spacesManagerProvider.notifier)
                                .refreshSpaces();
                          }
                        },
                        child: pages[_selectedIndex]),
                    floatingActionButton: FloatingActionButton(
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
