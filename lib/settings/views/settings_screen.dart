import 'package:appwrite/models.dart';
import 'package:assigngo_rewrite/constants.dart';
import 'package:assigngo_rewrite/settings/widgets/settings_card.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future<User?> currentAccount = account.get();

    void notYetImplemented() {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Not yet implemented'),
          duration: Duration(seconds: 1),
          backgroundColor: Colors.redAccent,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        toolbarHeight: 100,
        title: Text(
          'Settings',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: secondaryColor,
                child: const Icon(
                  Icons.account_circle,
                  size: 50,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              FutureBuilder(
                  future: currentAccount,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text(
                        snapshot.data!.email
                            .substring(0, snapshot.data!.email.indexOf('@')),
                        style: Theme.of(context).textTheme.headlineSmall,
                      );
                    } else {
                      return Text(
                        'John Doe',
                        style: Theme.of(context).textTheme.headlineSmall,
                      );
                    }
                  }),
              const SizedBox(height: 10),
              Column(
                children: [
                  const Divider(),
                  SettingsCard(
                      backgroundColor: primaryColor,
                      title: 'Subjects',
                      description: 'Add, delete, or archive your subjects',
                      icon: Icons.subject,
                      onTap: () => Navigator.pushNamed(context, '/subjects')),
                  const Divider(),
                  SettingsCard(
                      title: 'Notifications',
                      description: 'Manage your notifications',
                      icon: Icons.notifications,
                      // onTap: () => Navigator.pushNamed(
                      //     context, '/settings/notifications')),
                      onTap: notYetImplemented),
                  SettingsCard(
                      title: 'Theme',
                      description: 'Change the app theme',
                      icon: Icons.info,
                      onTap: notYetImplemented),
                  // onTap: () =>
                  //     Navigator.pushNamed(context, '/settings/theme')),
                  const Divider(),
                  SettingsCard(
                      title: 'Account',
                      description: 'Manage your account',
                      icon: Icons.account_circle,
                      onTap: () =>
                          Navigator.pushNamed(context, '/settings/account')),
                  SettingsCard(
                      title: 'Feedback',
                      description: 'Send us your feedback',
                      icon: Icons.info,
                      onTap: notYetImplemented),
                  // onTap: () =>
                  //     Navigator.pushNamed(context, '/settings/feedback')),
                  const Divider(),
                  SettingsCard(
                      title: 'About',
                      description: 'About the app',
                      icon: Icons.info,
                      onTap: () =>
                          Navigator.pushNamed(context, '/settings/about')),
                  SettingsCard(
                      title: 'Sign out',
                      description: 'Sign out',
                      icon: Icons.logout,
                      backgroundColor: Colors.red,
                      onTap: () async {
                        await account
                            .deleteSession(sessionId: "current")
                            .then((value) => {
                                  Navigator.pushReplacementNamed(
                                      context, "/signin"),
                                });
                      }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
