import 'package:assigngo_rewrite/spaces/views/all_spaces_screen.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:assigngo_rewrite/task_list/task_create_form/views/task_form_screen.dart';
import 'package:assigngo_rewrite/task_list/providers/tasks_provider.dart';
import 'package:assigngo_rewrite/settings/views/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
      const TaskFormScreen(),
      const SettingsScreen(),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        if (width < 800) {
          // Mobile layout
          return Scaffold(
            body: RefreshIndicator(
                onRefresh: () =>
                    ref.refresh(tasksProvider.notifier).fetchTasks(),
                child: pages[_selectedIndex]),
            floatingActionButton: FloatingActionButton(
              onPressed: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TaskFormScreen(),
                  ),
                )
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
                        onRefresh: () =>
                            ref.refresh(tasksProvider.notifier).fetchTasks(),
                        child: pages[_selectedIndex]),
                    floatingActionButton: FloatingActionButton(
                      onPressed: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TaskFormScreen(),
                          ),
                        )
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
