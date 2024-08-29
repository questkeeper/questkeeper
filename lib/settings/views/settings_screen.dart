import 'package:feedback_sentry/feedback_sentry.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:questkeeper/settings/widgets/settings_card.dart';
import 'package:flutter/material.dart';
import 'package:questkeeper/shared/widgets/snackbar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    void notYetImplemented() {
      SnackbarService.showErrorSnackbar(context, 'Not yet implemented');
    }

    final user = Supabase.instance.client.auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          user?.email?.split('@')[0] ?? 'Settings',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.headlineLarge,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Column(
                children: [
                  const Divider(),
                  SettingsCard(
                      title: 'Notifications',
                      description: 'Manage your notifications',
                      icon: LucideIcons.bell_ring,
                      onTap: notYetImplemented),
                  SettingsCard(
                      title: 'Theme',
                      description: 'Change the app theme',
                      icon: LucideIcons.palette,
                      onTap: notYetImplemented),
                  const Divider(),
                  SettingsCard(
                      title: 'Feedback',
                      description: 'Send us your feedback',
                      icon: LucideIcons.bug,
                      onTap: () async {
                        if (!context.mounted) {
                          return;
                        }
                        BetterFeedback.of(context).showAndUploadToSentry(
                            name: user?.id ?? 'Unknown',
                            email: user?.email ?? 'Unknown@questkeeper.app');
                      }),
                  const Divider(),
                  SettingsCard(
                      title: 'About',
                      description: 'About the app',
                      icon: LucideIcons.info,
                      onTap: () =>
                          Navigator.pushNamed(context, '/settings/about')),
                  SettingsCard(
                      title: 'Sign out',
                      description: 'Sign out',
                      icon: LucideIcons.log_out,
                      backgroundColor: Colors.red,
                      onTap: () async {
                        await Supabase.instance.client.auth
                            .signOut()
                            .then((value) => {
                                  if (context.mounted)
                                    Navigator.pushReplacementNamed(
                                        context, "/signin"),
                                });
                      }),
                  const Divider(),
                  const Text(
                      textAlign: TextAlign.center,
                      'To delete your account, please message us at contact@questkeeper.app'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
