import 'package:assigngo_rewrite/tabs/home.dart';
import 'package:assigngo_rewrite/tabs/star.dart';
import 'package:assigngo_rewrite/tabs/completed.dart';
import 'package:flutter/material.dart';

class TabView extends StatefulWidget {
  const TabView({super.key});

  @override
  TabViewState createState() => TabViewState();
}

class TabViewState extends State<TabView> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const Home(),
    const Star(),
    const Home(),
    const Completed(),
    // Settings(),
  ];

  void _onItemTapped(int index) async {
    if (index == 2) {
      // Call the assignModal function when the add button is tapped
    } else {
      // Update the selected index for other buttons
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _pages[_selectedIndex],
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
              NavigationDestination(
                  icon: Icon(Icons.star), label: "Prioritized"),
              NavigationDestination(icon: Icon(Icons.add), label: "Add"),
              NavigationDestination(
                  icon: Icon(Icons.check_box), label: "Completed"),
              NavigationDestination(
                  icon: Icon(Icons.settings), label: "Settings"),
            ]));
  }
}
