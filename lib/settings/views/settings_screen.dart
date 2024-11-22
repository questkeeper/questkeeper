import 'package:feedback_sentry/feedback_sentry.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:questkeeper/profile/model/profile_model.dart';
import 'package:questkeeper/profile/providers/profile_provider.dart';
import 'package:questkeeper/settings/widgets/settings_card.dart';
import 'package:flutter/material.dart';
import 'package:questkeeper/shared/widgets/avatar_widget.dart';
import 'package:questkeeper/shared/widgets/snackbar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void notYetImplemented() {
      SnackbarService.showErrorSnackbar(context, 'Not yet implemented');
    }

    final user = Supabase.instance.client.auth.currentUser;

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                FutureBuilder(
                  future: ref.watch(profileManagerProvider.future),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final userProfile = snapshot.data as Profile;
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          AvatarWidget(
                            seed: userProfile.user_id,
                          ),
                          const SizedBox(width: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    userProfile.username,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall,
                                  ),
                                  userProfile.isPro == true
                                      ? Text('PRO',
                                          style: TextStyle(
                                              color: Colors.greenAccent))
                                      : const SizedBox(),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Text(
                                '${userProfile.points} points',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              Text(
                                'Account since ${userProfile.created_at.split("T")[0]}',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ],
                      );
                    } else {
                      return const LinearProgressIndicator();
                    }
                  },
                ),
                Column(
                  children: [
                    const SizedBox(height: 10),
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
                      },
                    ),
                    SettingsCard(
                        title: 'About',
                        description: 'About the app',
                        icon: LucideIcons.info,
                        onTap: () =>
                            Navigator.pushNamed(context, '/settings/about')),
                    SettingsCard(
                      title: 'Sign out',
                      description: 'Sign out and remove local data',
                      icon: LucideIcons.log_out,
                      iconColor: Colors.redAccent,
                      onTap: () async {
                        await Supabase.instance.client.auth.signOut().then(
                              (value) => {
                                if (context.mounted)
                                  Navigator.pushReplacementNamed(
                                      context, "/signin"),
                              },
                            );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: const Text(
                          textAlign: TextAlign.center,
                          'To delete your account, please message us at contact@questkeeper.app'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
