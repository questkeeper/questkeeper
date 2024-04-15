import 'package:assigngo_rewrite/assignments/assignment/views/assignment_screen.dart';
import 'package:assigngo_rewrite/assignments/assignment_form/views/assignment_form_screen.dart';
import 'package:assigngo_rewrite/assignments/providers/assignments_provider.dart';
import 'package:assigngo_rewrite/assignments/views/home_screen.dart';
import 'package:assigngo_rewrite/assignments/views/priority_screen.dart';
import 'package:assigngo_rewrite/assignments/views/completed_screen.dart';
import 'package:assigngo_rewrite/main.dart';
import 'package:assigngo_rewrite/settings/views/settings_screen.dart';
import 'package:assigngo_rewrite/subjects/providers/subjects_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

    supabase.auth.onAuthStateChange.listen((event) async {
      // TODO: This should be changed, atm this only gets initalSession because this is not the root component. Pls fix soon, bad practice.
      if (event.event == AuthChangeEvent.signedIn ||
          event.event == AuthChangeEvent.initialSession) {
        await FirebaseMessaging.instance.requestPermission();

        await FirebaseMessaging.instance.getAPNSToken();

        final fcmToken = await FirebaseMessaging.instance.getToken();
        print('FCM token: $fcmToken');
        if (fcmToken != null) {
          await _updateFcmToken(fcmToken);
        }
      }
    });

    FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) async {
      await _updateFcmToken(fcmToken);
    });
  }

  Future<void> _updateFcmToken(String fcmToken) async {
    print(
        'Updating FCM token: $fcmToken, with user ${supabase.auth.currentUser!.id}');
    await supabase.from('profiles').upsert({
      'id': supabase.auth.currentUser!.id,
      'fcm_token': fcmToken,
    });
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
            body: RefreshIndicator(
                onRefresh: () => ref
                    .refresh(assignmentsProvider.notifier)
                    .fetchAssignments(),
                child: pages[_selectedIndex]),
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
            body: RefreshIndicator(
              onRefresh: () =>
                  ref.refresh(assignmentsProvider.notifier).fetchAssignments(),
              child: Row(
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
            ),
          );
        }
      },
    );
  }
}
