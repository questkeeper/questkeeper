import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:questkeeper/auth/providers/auth_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:questkeeper/constants.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  Future<PackageInfo> _getPackageInfo() {
    return PackageInfo.fromPlatform();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            AppBar(
              surfaceTintColor: Colors.transparent,
              title: Text(
                'About',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      child: Text(
                        'QK',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'QuestKeeper',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ],
                ),
              ),
            ),
            FutureBuilder<PackageInfo>(
              future: _getPackageInfo(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  return Column(
                    children: [
                      ListTile(
                        title: Text(
                            'v${snapshot.data!.version}+${snapshot.data!.buildNumber}'),
                      ),
                    ],
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
            ListTile(
              title: const Text("Website"),
              textColor: primaryColor,
              leading: const Icon(LucideIcons.globe),
              onTap: () {
                final uri = Uri.parse("https://questkeeper.app");

                launchUrl(uri);
              },
            ),
            ListTile(
              title: const Text("View privacy policy"),
              textColor: primaryColor,
              leading: const Icon(LucideIcons.shield_alert),
              onTap: () {
                final uri = Uri.parse("https://questkeeper.app/privacy");

                launchUrl(uri);
              },
            ),
            ListTile(
              title: const Text("View licenses"),
              textColor: secondaryColor,
              leading: const Icon(LucideIcons.info),
              onTap: () {
                showLicensePage(
                  context: context,
                );
              },
            ),
            ListTile(
              title: const Text("Clear local data"),
              onTap: () async {
                AuthNotifier().clearToken();
              },
            ),
            const ListTile(
              title: Text('© 2024 Ishan Misra'),
              subtitle: Text('All rights reserved'),
            ),
          ],
        ),
      ),
    );
  }
}
