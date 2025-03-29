import 'dart:io';

import 'package:feedback_sentry/feedback_sentry.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:questkeeper/constants.dart';
import 'package:questkeeper/settings/views/about/about_screen.dart';
import 'package:questkeeper/settings/views/account/account_management_screen.dart';
import 'package:questkeeper/settings/views/debug/debug_settings.dart';
import 'package:questkeeper/settings/views/notifications/notifications_screen.dart';
import 'package:questkeeper/settings/views/privacy/privacy_screen.dart';
import 'package:questkeeper/settings/views/profile/profile_settings_screen.dart';
import 'package:questkeeper/settings/views/theme/theme_screen.dart';
import 'package:questkeeper/settings/views/experiments/experiments_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shorebird_code_push/shorebird_code_push.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:questkeeper/auth/providers/auth_provider.dart';
import 'package:questkeeper/profile/model/profile_model.dart';
import 'package:questkeeper/profile/providers/profile_provider.dart';
import 'package:questkeeper/settings/widgets/settings_card.dart';
import 'package:questkeeper/shared/widgets/avatar_widget.dart';
import 'package:questkeeper/shared/widgets/snackbar.dart';
import 'package:questkeeper/shared/providers/window_size_provider.dart';
import 'package:questkeeper/shared/utils/analytics/analytics.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  Widget? _currentContent;
  final debugCheck = isDebug ||
      (Supabase.instance.client.auth.currentUser?.email
              ?.endsWith("@questkeeper.app") ??
          false);
  final updater = ShorebirdUpdater();
  bool _needsUpdate = false;

  Future<void> _checkForUpdates() async {
    // Check whether a new update is available.
    final status = await updater.checkForUpdate();
    setState(() {
      _needsUpdate = status == UpdateStatus.outdated;
    });
  }

  Future<void> _performUpdate() async {
    try {
      await updater.update();
    } on UpdateException catch (error) {
      SnackbarService.showErrorSnackbar('Could not update the app');
      Sentry.captureException(error);
    }
  }

  @override
  void initState() {
    super.initState();
    _checkForUpdates();
  }

  void _navigateToContent(Widget content) {
    final isMobile = ref.read(isMobileProvider);

    if (isMobile) {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => content,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;
            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);
            return SlideTransition(position: offsetAnimation, child: child);
          },
        ),
      );
    } else {
      setState(() {
        _currentContent = content;
      });
    }
  }

  Widget _buildSettingsList(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    final platform = Platform.isIOS
        ? 'iOS'
        : (Platform.isMacOS
            ? 'macOS'
            : (Platform.isAndroid ? 'Android' : 'Unknown'));

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
                // Profile & Account Group
                SettingsCard(
                  title: 'Profile',
                  description: 'Manage your profile settings',
                  icon: LucideIcons.user,
                  onTap: () =>
                      _navigateToContent(const ProfileSettingsScreen()),
                ),
                SettingsCard(
                  title: 'Account Management',
                  description: 'Manage your account settings and data',
                  icon: LucideIcons.user_cog,
                  onTap: () =>
                      _navigateToContent(const AccountManagementScreen()),
                ),
                const Divider(),
                // App Preferences Group
                SettingsCard(
                  title: 'Theme',
                  description: 'Change the app theme',
                  icon: LucideIcons.palette,
                  onTap: () => _navigateToContent(const ThemeScreen()),
                ),
                SettingsCard(
                  title: 'Notifications',
                  description: 'Manage your notifications',
                  icon: LucideIcons.bell_ring,
                  onTap: () => _navigateToContent(const NotificationsScreen()),
                ),
                SettingsCard(
                  title: 'Privacy',
                  description: 'Manage privacy and data settings',
                  icon: LucideIcons.shield,
                  onTap: () => _navigateToContent(const PrivacyScreen()),
                ),
                const Divider(),
                // Support & Feedback Group
                SettingsCard(
                  title: 'Feedback',
                  description: 'Send us your feedback',
                  icon: LucideIcons.bug,
                  onTap: () async {
                    if (!context.mounted) return;
                    BetterFeedback.of(context).showAndUploadToSentry(
                      name: user?.id ?? 'Unknown',
                      email: user?.email ?? 'Unknown@questkeeper.app',
                    );
                  },
                ),
                platform != "unknown"
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
                const Divider(),
                // App Information Group
                SettingsCard(
                  title: 'About',
                  description: 'About the app',
                  icon: LucideIcons.info,
                  onTap: () => _navigateToContent(const AboutScreen()),
                ),
                SettingsCard(
                  title: 'Experiments',
                  description: 'Enable features that may be unstable',
                  icon: LucideIcons.flask_conical,
                  onTap: () => _navigateToContent(const ExperimentsScreen()),
                ),
                if (debugCheck)
                  SettingsCard(
                    title: "Super Secret Debug Menu",
                    description: "Only for debug purposes lol",
                    icon: LucideIcons.bug_off,
                    onTap: () =>
                        _navigateToContent(const SuperSecretDebugSettings()),
                    iconColor: Colors.amber,
                  ),
                const Divider(),
                if (debugCheck)
                  SettingsCard(
                    title: 'Shorebird',
                    description:
                        'This should only appear after shorebird push is successful',
                    icon: LucideIcons.trophy,
                    onTap: () => SnackbarService.showSuccessSnackbar(
                        "Hello from the other side"),
                  ),
                const Divider(),
                if (_needsUpdate)
                  SettingsCard(
                    title: 'Update',
                    description: 'Update the app',
                    icon: LucideIcons.trophy,
                    onTap: () => _performUpdate(),
                  ),
                // Sign Out (at the bottom)
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

  @override
  Widget build(BuildContext context) {
    final isMobile = ref.watch(isMobileProvider);

    if (isMobile) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
        ),
        body: _buildSettingsList(context),
      );
    }

    return Scaffold(
      body: Row(
        children: [
          Container(
            width: 350,
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(
                  color: Theme.of(context).dividerColor,
                  width: 1,
                ),
              ),
            ),
            child: Column(
              children: [
                Expanded(
                  child: _buildSettingsList(context),
                ),
              ],
            ),
          ),
          Expanded(
            child: _currentContent != null
                ? _currentContent!
                : const Center(
                    child: Text(
                      'Select a setting from the left to view or edit',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ),
          ),
        ],
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

  Analytics.instance.reset();

  await Supabase.instance.client.auth.signOut().then(
        (value) => {
          if (context.mounted)
            Navigator.pushReplacementNamed(context, "/signin"),
        },
      );
}
