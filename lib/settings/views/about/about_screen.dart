import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:questkeeper/auth/providers/auth_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
              leading: Icon(LucideIcons.heart),
              title: const Text("Special thanks to"),
              onTap: () => showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Special thanks to'),
                    content: Column(
                      children: [
                        ListTile(
                          title: const Text('Flero'),
                          subtitle: const Text('Developer\nTap for website'),
                          onTap: () => launchUrl(
                            Uri.parse('https://flero.dev'),
                          ),
                          isThreeLine: true,
                        ),
                        Divider(),
                        ListTile(
                          title: const Text('asifpx_'),
                          subtitle: const Text(
                              'Environments and backgrounds\nTap for X'),
                          onTap: () => launchUrl(
                            Uri.parse('https://x.com/asifpx_'),
                          ),
                          isThreeLine: true,
                        ),
                        ListTile(
                          title: const Text('Elthen'),
                          subtitle:
                              const Text('Animal sprites\nTap for Patreon'),
                          onTap: () => launchUrl(
                            Uri.parse('https://www.patreon.com/elthen'),
                          ),
                          isThreeLine: true,
                        ),
                        ListTile(
                          title: const Text('vsioneithr'),
                          subtitle: const Text('Trophy sprites\nTap for X'),
                          onTap: () => launchUrl(
                            Uri.parse('https://x.com/vsioneithr'),
                          ),
                          isThreeLine: true,
                        )
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Close'),
                      ),
                    ],
                  );
                },
              ),
            ),
            ListTile(
              leading: Icon(LucideIcons.trash),
              title: const Text(
                "Clear local data",
                style: TextStyle(
                  color: Colors.redAccent,
                ),
              ),
              onTap: () async {
                AuthNotifier().clearToken();
                await SharedPreferences.getInstance().then((prefs) {
                  prefs.clear();
                });

                // Clear cache manager
                final CacheManager cacheManager = DefaultCacheManager();
                await cacheManager.emptyCache();

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Local data cleared'),
                    ),
                  );
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/signin',
                    (route) => false,
                  );
                }
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
