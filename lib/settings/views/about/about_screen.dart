import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:questkeeper/constants.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

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
                      backgroundColor: secondaryColor,
                      child: Text(
                        'AG',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      // child: const Icon(
                      //   Icons.info,
                      //   size: 50,
                      //   color: Colors.white,),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Quest Keeper',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              child: Column(
                children: [
                  const ListTile(
                    title: Text('Quest Keeper'),
                    // subtitle: Text('Version 1.0.0'),
                  ),
                  const ListTile(
                    title: Text('© 2024 Ishan Misra'),
                    subtitle: Text('All rights reserved'),
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
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
