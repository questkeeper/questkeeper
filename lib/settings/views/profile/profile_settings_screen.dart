import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:questkeeper/profile/providers/profile_provider.dart';
import 'package:questkeeper/settings/widgets/settings_switch_tile.dart';
import 'package:questkeeper/settings/widgets/update_username_dialog.dart';
import 'package:questkeeper/shared/widgets/snackbar.dart';

class ProfileSettingsScreen extends ConsumerWidget {
  const ProfileSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileManagerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Settings'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Profile Visibility",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              profileAsync.when(
                data: (profile) => SettingsSwitchTile(
                  title: "Public Profile",
                  description:
                      "When enabled, anyone can view your profile and activity",
                  isEnabled: profile.isPublic,
                  onTap: (value) async {
                    final result = await ref
                        .read(profileManagerProvider.notifier)
                        .updateProfileVisibility(value);
                    if (context.mounted) {
                      if (result.success) {
                        SnackbarService.showSuccessSnackbar(result.message);
                      } else {
                        SnackbarService.showErrorSnackbar(result.message);
                      }
                    }
                  },
                ),
                loading: () => const CircularProgressIndicator(),
                error: (error, stack) => Text('Error: $error'),
              ),
              const SizedBox(height: 24),
              Text(
                "Username",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text('Change Username'),
                subtitle: profileAsync.when(
                  data: (profile) => Text('@${profile.username}'),
                  loading: () => const Text('Loading...'),
                  error: (error, stack) => Text('Error: $error'),
                ),
                trailing: const Icon(LucideIcons.chevron_right),
                onTap: () => showDialog(
                  context: context,
                  builder: (context) => UpdateUsernameDialog(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
