import 'package:assigngo_rewrite/constants.dart';
import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.all(kDefaultFontSize),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppBar(
              title: Text(
                'Account',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),

            // Display sessions
            Text(
              'Sessions',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Card(
              margin: const EdgeInsets.all(kDefaultFontSize),
              child: FutureBuilder(
                  future: account.listSessions(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data?.sessions.length ?? 0,
                        itemBuilder: (context, index) {
                          final clientName =
                              snapshot.data!.sessions[index].clientName;
                          final id = snapshot.data!.sessions[index].$id;
                          final device = snapshot.data!.sessions[index].osName;
                          late final Icon deviceIcon;
                          final isCurrent =
                              snapshot.data!.sessions[index].current;

                          if (device == "iOS" || device == "Mac") {
                            deviceIcon =
                                const Icon(Icons.apple, color: Colors.blueGrey);
                          } else if (device == "Windows") {
                            deviceIcon =
                                const Icon(Icons.window, color: Colors.blue);
                          } else if (device == "Android") {
                            deviceIcon =
                                const Icon(Icons.android, color: Colors.green);
                          } else {
                            deviceIcon =
                                Icon(Icons.devices_other, color: primaryColor);
                          }

                          return ListTile(
                            trailing: const Icon(Icons.logout_rounded),
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Logout'),
                                    content: const Text(
                                        'Are you sure you want to logout from this device?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          account.deleteSession(sessionId: id);
                                          Navigator.pop(context);

                                          if (isCurrent) {
                                            Navigator.pushNamedAndRemoveUntil(
                                                context,
                                                '/signin',
                                                (route) => false);
                                          }
                                        },
                                        child: const Text('Logout'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            iconColor: Colors.redAccent,
                            leading: deviceIcon,
                            title: Text(
                                "$device ${clientName.isEmpty ? "" : '— $clientName'}"),
                            subtitle:
                                isCurrent ? const Text("Current Device") : null,
                            visualDensity: VisualDensity.standard,
                          );
                        });
                  }),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(right: kDefaultFontSize),
                  child: ElevatedButton.icon(
                      onPressed: () async {
                        await account.deleteSessions();

                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('All sessions have been deleted.'),
                            ),
                          );

                          Navigator.pushNamedAndRemoveUntil(
                              context, '/signin', (route) => false);
                        }
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.redAccent,
                      ),
                      label: const Text('Delete all sessions')),
                ),

                // Ask if the user wants to delete their account
                Container(
                  margin: const EdgeInsets.only(left: kDefaultFontSize),
                  child: ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Delete Account'),
                            content: const Text(
                                'Are you sure you want to delete your account?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Not yet implemented...'),
                                    ),
                                  );
                                  Navigator.pop(context);
                                },
                                child: const Text('Delete'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: const Text('Delete Account'),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    ));
  }
}
