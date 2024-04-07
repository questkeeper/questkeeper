import 'package:assigngo_rewrite/assignments/providers/assignments_provider.dart';
import 'package:assigngo_rewrite/assignments/views/home_screen.dart';
import 'package:assigngo_rewrite/assignments/views/priority_screen.dart';
import 'package:assigngo_rewrite/assignments/views/completed_screen.dart';
import 'package:assigngo_rewrite/assignments/widgets/assignments_modal.dart';
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
  }

  int _selectedIndex = 0;

  void _onItemTapped(int index) async {
    if (index == 2) {
      // Call the assignModal function when the add button is tapped
      // Call modal for adding new assignment
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return const AssignmentsModal();
          });
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
      // Settings(),
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      persistentFooterButtons: [
        ElevatedButton(
          onPressed: () {
            // Get.to(() => SearchModal());
          },
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
            NavigationDestination(icon: Icon(Icons.star), label: "Prioritized"),
            NavigationDestination(icon: Icon(Icons.add), label: "Add"),
            NavigationDestination(
                icon: Icon(Icons.check_box), label: "Completed"),
            NavigationDestination(
                icon: Icon(Icons.settings), label: "Settings"),
          ]),
    );
  }
}
