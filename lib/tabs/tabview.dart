import 'package:assigngo_rewrite/assignments/assignment/views/assignment_screen.dart';
import 'package:assigngo_rewrite/assignments/assignment_form/views/assignment_form_screen.dart';
import 'package:assigngo_rewrite/assignments/providers/assignments_provider.dart';
import 'package:assigngo_rewrite/assignments/views/home_screen.dart';
import 'package:assigngo_rewrite/assignments/views/priority_screen.dart';
import 'package:assigngo_rewrite/assignments/views/completed_screen.dart';
import 'package:assigngo_rewrite/settings/views/settings_screen.dart';
import 'package:assigngo_rewrite/subjects/providers/subjects_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TabView extends ConsumerStatefulWidget {
  const TabView({super.key});

  @override
  ConsumerState<TabView> createState() => _TabViewState();
}

class _TabViewState extends ConsumerState<TabView> {
  @override
  void initState() {
    super.initState();
    // Fetch the assignments when the screen is initialized
    ref.read(assignmentsProvider.notifier).fetchAssignments();
    ref.read(subjectsProvider.notifier).fetchSubjects();
  }

  int _selectedIndex = 0;

  void _onItemTapped(int index) async {
    if (index == 2) {
      // Call the assignModal function when the add button is tapped
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const AssignmentFormScreen(),
          fullscreenDialog: true,
        ),
      );
    } else {
      // Update the selected index for other buttons
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final assignments = ref.watch(assignmentsProvider);
    final List<Widget> pages = [
      HomeScreen(assignments: assignments),
      StarScreen(assignments: assignments),
      HomeScreen(assignments: assignments),
      CompletedScreen(assignments: assignments),
      const SettingsScreen(),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        if (MediaQuery.of(context).size.width < 800) {
          // Mobile layout
          return Scaffold(
            body: pages[_selectedIndex],
            persistentFooterButtons: [
              ElevatedButton(
                onPressed: () {},
                child: const Row(
                  children: [
                    Icon(Icons.search),
                    Text("Search"),
                  ],
                ),
              ),
            ],
            bottomNavigationBar: NavigationBar(
              onDestinationSelected: _onItemTapped,
              selectedIndex: _selectedIndex,
              indicatorColor: Colors.purple,
              destinations: const [
                NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
                NavigationDestination(
                    icon: Icon(Icons.star), label: "Prioritized"),
                NavigationDestination(icon: Icon(Icons.add), label: "Add"),
                NavigationDestination(
                  icon: Icon(Icons.check_box),
                  label: "Completed",
                ),
                NavigationDestination(
                  icon: Icon(Icons.settings),
                  label: "Settings",
                ),
              ],
            ),
          );
        } else {
          // Desktop layout
          return Scaffold(
            body: Row(
              children: [
                NavigationRail(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: _onItemTapped,
                  labelType: NavigationRailLabelType.all,
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.home),
                      label: Text('Home'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.star),
                      label: Text("Prioritized"),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.add),
                      label: Text("Add"),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.check_box),
                      label: Text("Completed"),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.settings),
                      label: Text("Settings"),
                    ),
                  ],
                ),
                Expanded(
                  flex: 3,
                  child: pages[_selectedIndex],
                ),
                const Expanded(flex: 2, child: AssignmentScreen()),
              ],
            ),
            persistentFooterButtons: [
              ElevatedButton(
                onPressed: () {},
                child: const Row(
                  children: [
                    Icon(Icons.search),
                    Text("Search"),
                  ],
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
