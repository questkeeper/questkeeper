import 'dart:io';

import 'package:feedback_sentry/feedback_sentry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:posthog_flutter/posthog_flutter.dart';
import 'package:questkeeper/constants.dart';
import 'package:questkeeper/settings/views/debug/debug_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:questkeeper/auth/providers/auth_provider.dart';
import 'package:questkeeper/profile/model/profile_model.dart';
import 'package:questkeeper/profile/providers/profile_provider.dart';
import 'package:questkeeper/settings/widgets/settings_card.dart';
import 'package:questkeeper/shared/widgets/avatar_widget.dart';
import 'package:questkeeper/shared/widgets/snackbar.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = Supabase.instance.client.auth.currentUser;
    final platform = Platform.isIOS
        ? 'iOS'
        : (
            Platform.isMacOS
                ? 'macOS'
                : (Platform.isAndroid ? 'Android' : 'Unknown'),
          );

    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            FutureBuilder(
              future: ref.watch(profileManagerProvider.future),
              builder: (context, snapshot) {
                return Skeletonizer(
                  enabled: !snapshot.hasData,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      snapshot.hasData
                          ? AvatarWidget(
                              seed: (snapshot.data as Profile).user_id)
                          : const CircleAvatar(radius: 50),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  snapshot.hasData
                                      ? (snapshot.data as Profile).username
                                      : 'Username Loading',
                                  style: Theme.of(context).textTheme.titleLarge,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                if (snapshot.hasData &&
                                    (snapshot.data as Profile).isPro == true)
                                  const Text('PRO',
                                      style:
                                          TextStyle(color: Colors.greenAccent))
                              ],
                            ),
                            const SizedBox(height: 5),
                            Text(
                              snapshot.hasData
                                  ? '${(snapshot.data as Profile).points} points'
                                  : '0 points',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            Text(
                              snapshot.hasData
                                  ? 'Account since ${(snapshot.data as Profile).created_at.split("T")[0]}'
                                  : 'Account since 2024-01-01',
                              style: Theme.of(context).textTheme.bodyMedium,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            Column(
              children: [
                const SizedBox(height: 10),
                const Divider(),
                SettingsCard(
                    title: 'Profile',
                    description: 'Manage your profile settings',
                    icon: LucideIcons.user,
                    onTap: () =>
                        Navigator.pushNamed(context, '/settings/profile')),
                SettingsCard(
                    title: 'Notifications',
                    description: 'Manage your notifications',
                    icon: LucideIcons.bell_ring,
                    onTap: () => Navigator.pushNamed(
                        context, '/settings/notifications')),
                isDebug
                    ? SettingsCard(
                        title: 'Theme',
                        description: 'Change the app theme',
                        icon: LucideIcons.palette,
                        onTap: () =>
                            Navigator.pushNamed(context, '/settings/theme'))
                    : const SizedBox(),
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
                    title: 'Privacy',
                    description: 'Manage privacy and data settings',
                    icon: LucideIcons.shield,
                    onTap: () =>
                        Navigator.pushNamed(context, '/settings/privacy')),
                SettingsCard(
                    title: 'About',
                    description: 'About the app',
                    icon: LucideIcons.info,
                    onTap: () =>
                        Navigator.pushNamed(context, '/settings/about')),
                platform != "unkown"
                    ? SettingsCard(
                        title: 'Review the app',
                        description:
                            'Review us on the ${platform == 'iOS' || platform == 'macOS' ? 'App Store' : 'Play Store'}',
                        icon: LucideIcons.star,
                        onTap: () async {
                          try {
                            final url = platform == 'iOS' || platform == 'macOS'
                                ? 'https://apps.apple.com/us/app/questkeeper/id6651824308'
                                : 'https://play.google.com/store/apps/details?id=app.questkeeper';
                            if (await canLaunchUrl(Uri.parse(url))) {
                              await launchUrl(Uri.parse(url));
                            } else {
                              throw 'Could not launch $url';
                            }
                          } catch (e) {
                            SnackbarService.showErrorSnackbar(
                              'Could not open the store page',
                            );
                          }
                        },
                      )
                    : const SizedBox(),
                SettingsCard(
                    title: 'Experiments',
                    description: 'Enable features that may be unstable',
                    icon: LucideIcons.flask_conical,
                    onTap: () =>
                        Navigator.pushNamed(context, '/settings/experiments')),
                if (isDebug ||
                    (Supabase.instance.client.auth.currentUser?.email
                            ?.endsWith("@questkeeper.app") ??
                        false))
                  SettingsCard(
                    title: "Super Secret Debug Menu",
                    description: "Only for debug purposes lol",
                    icon: LucideIcons.bug_off,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SuperSecretDebugSettings(),
                      ),
                    ),
                    iconColor: Colors.amber,
                  ),
                SettingsCard(
                  title: 'Account Management',
                  description: 'Manage your account settings and data',
                  icon: LucideIcons.user_cog,
                  onTap: () =>
                      Navigator.pushNamed(context, '/settings/account'),
                ),
                SettingsCard(
                  title: 'Sign out',
                  description: 'Sign out and remove local data',
                  icon: LucideIcons.log_out,
                  iconColor: Colors.redAccent,
                  onTap: () => signOut(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void signOut(BuildContext context) async {
  AuthNotifier().clearToken();
  await SharedPreferences.getInstance().then((prefs) {
    prefs.clear();
  });

  // Clear cache manager
  final CacheManager cacheManager = DefaultCacheManager();
  await cacheManager.emptyCache();

  Posthog().reset();

  await Supabase.instance.client.auth.signOut().then(
        (value) => {
          if (context.mounted)
            Navigator.pushReplacementNamed(context, "/signin"),
        },
      );
}
