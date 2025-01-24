import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:questkeeper/settings/widgets/settings_card.dart';
import 'package:questkeeper/shared/utils/http_service.dart';
import 'package:questkeeper/shared/widgets/snackbar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:questkeeper/settings/views/settings_screen.dart';
import 'package:questkeeper/profile/providers/profile_provider.dart';

class AccountManagementScreen extends ConsumerWidget {
  const AccountManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDeactivated =
        ModalRoute.of(context)?.settings.arguments as bool? ?? false;

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
              Text(
                'Account Actions',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              SettingsCard(
                title: 'Change Email',
                description: 'Update your account email address',
                icon: LucideIcons.mail,
                onTap: () {
                  // TODO: Implement email change
                  SnackbarService.showInfoSnackbar('Coming soon');
                },
              ),
              if (!isDeactivated) ...[
                const SizedBox(height: 32),
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
