import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:questkeeper/constants.dart';
import 'package:questkeeper/settings/widgets/settings_card.dart';
import 'package:questkeeper/shared/utils/http_service.dart';
import 'package:questkeeper/shared/widgets/snackbar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:questkeeper/settings/views/settings_screen.dart';
import 'package:questkeeper/profile/providers/profile_provider.dart';

class AccountManagementScreen extends ConsumerStatefulWidget {
  const AccountManagementScreen({super.key});

  @override
  ConsumerState<AccountManagementScreen> createState() =>
      _AccountManagementScreenState();
}

class _AccountManagementScreenState
    extends ConsumerState<AccountManagementScreen> {
  List<UserIdentity>? _userIdentities;
  bool _isLoadingIdentities = true;

  @override
  void initState() {
    super.initState();
    _loadUserIdentities();
  }

  Future<void> _loadUserIdentities() async {
    try {
      final identities =
          await Supabase.instance.client.auth.getUserIdentities();
      setState(() {
        _userIdentities = identities;
        _isLoadingIdentities = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingIdentities = false;
      });
      if (mounted) {
        SnackbarService.showErrorSnackbar('Failed to load account information');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDeactivated =
        ModalRoute.of(context)?.settings.arguments as bool? ?? false;
    final currentUser = Supabase.instance.client.auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Management'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isDeactivated) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.orange),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Account Deactivated',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Your account is currently deactivated. You can reactivate it to regain access to all features.',
                      ),
                      const SizedBox(height: 16),
                      FilledButton.icon(
                        onPressed: () => _showReactivateDialog(context),
                        icon: const Icon(LucideIcons.user_check),
                        label: const Text('Reactivate Account'),
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
              ],

              // Account Linking Section (only show if not deactivated)
              if (!isDeactivated && currentUser != null) ...[
                _buildAccountLinkingSection(context),
                const SizedBox(height: 32),
              ],

              if (!isDeactivated) ...[
                Text(
                  'Danger Zone',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.redAccent,
                      ),
                ),
                const SizedBox(height: 16),
                SettingsCard(
                  title: 'Deactivate Account',
                  description: 'Temporarily disable your account',
                  icon: LucideIcons.user_minus,
                  iconColor: Colors.orange,
                  onTap: () => _showDeactivateDialog(context),
                ),
                SettingsCard(
                  title: 'Delete Account',
                  description: 'Permanently delete your account and all data',
                  icon: LucideIcons.user_x,
                  iconColor: Colors.redAccent,
                  onTap: () => _showDeleteDialog(context),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAccountLinkingSection(BuildContext context) {
    if (_isLoadingIdentities) {
      return const Center(child: CircularProgressIndicator());
    }

    final linkedIdentities = _userIdentities ?? [];
    final currentUser = Supabase.instance.client.auth.currentUser;
    final isEmailUser = currentUser?.appMetadata['provider'] == 'email';
    final hasEmailIdentity =
        linkedIdentities.any((identity) => identity.provider == 'email');
    final hasOAuthIdentity =
        linkedIdentities.any((identity) => identity.provider != 'email');

    final availableProviders = <ProviderData>[];

    // if email user then push to available providers
    if (isEmailUser) {
      availableProviders.add(ProviderData(
        name: 'Email',
        icon: LucideIcons.mail,
        iconColor: primaryColor,
      ));
    }

    availableProviders.addAll(providersData(
      filteredProviders:
          linkedIdentities.map((i) => i.provider.toLowerCase()).toList(),
      isIOS: Platform.isIOS,
      isMacOS: Platform.isMacOS,
    ));

    // Show linking options if user signed up with email or if they want to link more providers
    final showLinkingOptions = isEmailUser || hasEmailIdentity;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Account Security',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),

        if (showLinkingOptions && !hasOAuthIdentity) ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.amber.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.amber),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(LucideIcons.shield_alert,
                        color: Colors.amber[700], size: 20),
                    const SizedBox(width: 8),
                    const Text(
                      'Secure Your Account',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Email accounts are being deprecated. Link a social account to keep your account secure and avoid losing access.',
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],

        // Current linked accounts
        Text(
          'Linked Accounts',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),

        ...availableProviders
            .mapIndexed((index, provider) => _buildLinkedIdentityCard(
                  context,
                  provider,
                  identity: linkedIdentities[index],
                  canUnlink: linkedIdentities.length >
                      1, // Can't unlink if it's the only identity
                )),

        if (linkedIdentities.isEmpty) ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(LucideIcons.info, size: 20),
                SizedBox(width: 12),
                Text('No linked accounts found'),
              ],
            ),
          ),
        ],

        const SizedBox(height: 16),

        // Available providers to link
        Text(
          'Link Additional Accounts',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        _buildAvailableProvidersSection(context, linkedIdentities),
      ],
    );
  }

  Widget _buildLinkedIdentityCard(BuildContext context, ProviderData provider,
      {required bool canUnlink, required UserIdentity identity}) {
    return SettingsCard(
      svgIconPath: provider.svgIconPath,
      title: provider.name,
      description: identity.identityData?['email'] as String? ?? '',
      icon: provider.icon,
      onTap: () => {
        if (provider.provider != null)
          _showUnlinkDialog(context, identity, provider.name)
      },
      iconColor: provider.iconColor,
    );
  }

  Widget _buildAvailableProvidersSection(
      BuildContext context, List<UserIdentity> linkedIdentities) {
    final linkedProviders = linkedIdentities.map((i) => i.provider).toSet();
    final availableProviders = providersData(
      filteredProviders: linkedProviders.toList(),
      showInvereseFilter: true,
      isIOS: Platform.isIOS,
      isMacOS: Platform.isMacOS,
    );

    if (availableProviders.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Row(
          children: [
            Icon(LucideIcons.check, color: Colors.green, size: 20),
            SizedBox(width: 12),
            Text('All available accounts are linked'),
          ],
        ),
      );
    }

    return Column(
      children: availableProviders.map((providerData) {
        return SettingsCard(
          title: 'Link ${providerData.name}',
          description: 'Connect your account for secure sign-in',
          svgIconPath: providerData.svgIconPath,
          onTap: () => {
            if (providerData.provider != null)
              _linkOAuthProvider(context, providerData.provider!)
          },
          iconColor: providerData.iconColor,
          backgroundColor: providerData.backgroundColor,
        );
      }).toList(),
    );
  }

  Future<void> _linkOAuthProvider(
      BuildContext context, OAuthProvider provider) async {
    try {
      await Supabase.instance.client.auth.linkIdentity(
        provider,
        redirectTo:
            kIsWeb ? "${Uri.base.toString()}/signin" : 'questkeeper://signin',
      );

      SnackbarService.showInfoSnackbar(
          'Complete the linking process in your browser');
    } catch (e) {
      if (context.mounted) {
        SnackbarService.showErrorSnackbar(
            'Failed to link ${provider.name} account: ${e.toString()}');
      }
    }
  }

  void _showUnlinkDialog(
      BuildContext context, UserIdentity identity, String providerName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Unlink $providerName'),
        content: Text(
          'Are you sure you want to unlink your $providerName account?\n\n'
          'You will no longer be able to sign in using $providerName.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => _unlinkIdentity(context, identity, providerName),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Unlink'),
          ),
        ],
      ),
    );
  }

  Future<void> _unlinkIdentity(
      BuildContext context, UserIdentity identity, String providerName) async {
    try {
      await Supabase.instance.client.auth.unlinkIdentity(identity);

      if (context.mounted) {
        Navigator.pop(context); // Close dialog
        SnackbarService.showSuccessSnackbar(
            '$providerName account unlinked successfully');

        // Refresh the identities
        await _loadUserIdentities();
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context); // Close dialog
        SnackbarService.showErrorSnackbar('Failed to unlink $providerName');
      }
    }
  }

  void _showReactivateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => _ConfirmationDialog(
        title: 'Reactivate Account',
        message:
            'Are you sure you want to reactivate your account?\n\nType "REACTIVATE" to confirm:',
        confirmText: 'REACTIVATE',
        onConfirm: () async {
          try {
            final httpService = HttpService();
            await httpService.post('/core/auth/reactivate');

            // Force refresh profile and auth state
            if (context.mounted) {
              final ref = ProviderScope.containerOf(context);
              // Invalidate profile to force refresh
              ref.invalidate(profileManagerProvider);
              // Wait for profile to be refetched
              await ref.read(profileManagerProvider.notifier).fetchProfile();

              context.mounted
                  ? Navigator.of(context)
                      .pushNamedAndRemoveUntil('/home', (route) => false)
                  : null;
              SnackbarService.showSuccessSnackbar(
                  'Account reactivated successfully');
            }
          } catch (e) {
            if (context.mounted) {
              Navigator.pop(context);
              SnackbarService.showErrorSnackbar('Failed to reactivate account');
            }
          }
        },
      ),
    );
  }

  void _showDeactivateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => _ConfirmationDialog(
        title: 'Deactivate Account',
        message:
            'Your account will be temporarily disabled. You can reactivate it at any time by signing in again.\n\nType "DEACTIVATE" to confirm:',
        confirmText: 'DEACTIVATE',
        onConfirm: () async {
          try {
            final httpService = HttpService();
            await httpService.post('/core/auth/deactivate');

            if (context.mounted) {
              SnackbarService.showSuccessSnackbar(
                  'Account deactivated successfully');
              signOut(context);
            }
          } catch (e) {
            if (context.mounted) {
              Navigator.pop(context);
              SnackbarService.showErrorSnackbar('Failed to deactivate account');
            }
          }
        },
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => _ConfirmationDialog(
        title: 'Delete Account',
        message:
            'This action cannot be undone. All your data will be permanently deleted.\n\nType "DELETE" to confirm:',
        confirmText: 'DELETE',
        onConfirm: () async {
          try {
            final httpService = HttpService();
            await httpService.delete('/core/auth/delete');
            await Supabase.instance.client.auth.signOut();

            if (context.mounted) {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/signin', (route) => false);
              SnackbarService.showSuccessSnackbar(
                  'Account deleted successfully');
            }
          } catch (e) {
            if (context.mounted) {
              Navigator.pop(context);
              SnackbarService.showErrorSnackbar('Failed to delete account');
            }
          }
        },
      ),
    );
  }
}

class _ConfirmationDialog extends StatefulWidget {
  final String title;
  final String message;
  final String confirmText;
  final VoidCallback onConfirm;

  const _ConfirmationDialog({
    required this.title,
    required this.message,
    required this.confirmText,
    required this.onConfirm,
  });

  @override
  State<_ConfirmationDialog> createState() => _ConfirmationDialogState();
}

class _ConfirmationDialogState extends State<_ConfirmationDialog> {
  final _controller = TextEditingController();
  bool _isConfirmEnabled = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _isConfirmEnabled = _controller.text == widget.confirmText;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.message),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
            autofocus: true,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _isConfirmEnabled ? widget.onConfirm : null,
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.disabled)) {
                return Colors.grey;
              }
              return Colors.redAccent;
            }),
          ),
          child: Text(widget.title),
        ),
      ],
    );
  }
}

class ProviderData {
  final String name;
  final String? svgIconPath;
  final OAuthProvider? provider;
  final IconData? icon;
  final Color? iconColor;
  final Color? backgroundColor;

  ProviderData({
    required this.name,
    this.provider,
    this.svgIconPath,
    this.icon,
    this.iconColor,
    this.backgroundColor,
  });
}

List<ProviderData> providersData(
    {List<String> filteredProviders = const [],
    bool showInvereseFilter = false,
    bool isIOS = false,
    bool isMacOS = false}) {
  var availableProviders = <ProviderData>[];

  availableProviders.add(ProviderData(
    provider: OAuthProvider.google,
    name: 'Google',
    svgIconPath: 'assets/auth/google_logo.svg',
  ));

  // Apple (only on iOS/macOS)
  if (isIOS || isMacOS) {
    availableProviders.add(ProviderData(
      provider: OAuthProvider.apple,
      name: 'Apple',
      svgIconPath: 'assets/auth/apple_logo.svg',
      iconColor: Colors.white,
    ));
  }

  // Discord
  availableProviders.add(ProviderData(
    provider: OAuthProvider.discord,
    name: 'Discord',
    svgIconPath: 'assets/auth/discord_logo.svg',
    iconColor: const Color(0xFF5865F2),
  ));

  // Filter out providers that are already linked
  if (showInvereseFilter) {
    availableProviders = availableProviders
        .where((provider) =>
            !filteredProviders.contains(provider.name.toString().toLowerCase()))
        .toList();
  } else {
    availableProviders = availableProviders
        .where((provider) =>
            filteredProviders.contains(provider.name.toString().toLowerCase()))
        .toList();
  }

  return availableProviders;
}
