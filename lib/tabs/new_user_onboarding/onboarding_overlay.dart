import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:questkeeper/spaces/providers/page_provider.dart';
import 'package:questkeeper/spaces/providers/spaces_provider.dart';
import 'package:questkeeper/tabs/new_user_onboarding/providers/onboarding_provider.dart';

class OnboardingOverlay extends ConsumerWidget {
  const OnboardingOverlay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardingState = ref.watch(onboardingProvider);

    if (onboardingState.isOnboardingComplete) {
      return const SizedBox.shrink();
    }

    return Positioned(
      bottom: 80, // Position above FAB
      right: 16,
      child: Card(
        child: InkWell(
          onTap: () => _showOnboardingModal(context, ref),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(LucideIcons.circle_help),
                const SizedBox(width: 8),
                const Text('Getting Started'),
                const SizedBox(width: 8),
                CircularProgressIndicator(
                  value: onboardingState.completedSteps / 4,
                  strokeWidth: 2,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showOnboardingModal(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (context) => _OnboardingModal(),
      isScrollControlled: true,
      showDragHandle: true,
    );
  }
}

class _OnboardingModal extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardingState = ref.watch(onboardingProvider);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Getting Started with QuestKeeper',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          // Reuse your existing _OnboardingStep widgets here
          _OnboardingStep(
            isCompleted: onboardingState.hasCreatedSpace,
            title: 'Create your first space',
            description: 'A space is an area where you can organize your tasks',
            onTap: () async {
              Navigator.pop(context);
              ref.watch(spacesManagerProvider).whenData(
                    (spaces) => {
                      if (spaces.isNotEmpty)
                        {
                          ref.read(pageControllerProvider).jumpToPage(
                                spaces
                                    .length, // Accounts for the "creation" page
                              ),
                        }
                    },
                  );
            },
          ),

          _OnboardingStep(
            isCompleted: onboardingState.hasCreatedCategory,
            title: 'Create your first category',
            description: 'A category helps you group related tasks',
            onTap: () async {
              Navigator.pop(context);
              ref.watch(spacesManagerProvider).whenData(
                    (spaces) => {
                      if (spaces.isNotEmpty)
                        {
                          ref.read(pageControllerProvider).jumpToPage(
                                spaces
                                    .length, // Accounts for the "creation" page
                              ),
                        }
                    },
                  );
            },
          ),

          _OnboardingStep(
            isCompleted: onboardingState.hasCreatedTask,
            title: 'Create your first task',
            description: 'A task is an action you need to complete',
            onTap: () async {
              Navigator.pop(context);
              ref.watch(spacesManagerProvider).whenData(
                    (spaces) => {
                      if (spaces.isNotEmpty)
                        {
                          ref.read(pageControllerProvider).jumpToPage(
                                spaces
                                    .length, // Accounts for the "creation" page
                              ),
                        }
                    },
                  );
            },
          ),

          _OnboardingStep(
            isCompleted: onboardingState.hasCompletedTask,
            title: 'Complete your first task',
            description: 'Complete your first task to get some points',
            onTap: () async {
              Navigator.pop(context);
              ref.watch(spacesManagerProvider).whenData(
                    (spaces) => {
                      if (spaces.isNotEmpty)
                        {
                          ref.read(pageControllerProvider).jumpToPage(
                                spaces
                                    .length, // Accounts for the "creation" page
                              ),
                        }
                    },
                  );
            },
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                icon: Icon(LucideIcons.arrow_right),
                onPressed: () {},
                label: const Text('Mark all as done'),
                iconAlignment: IconAlignment.end,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OnboardingStep extends StatelessWidget {
  final bool isCompleted;
  final String title;
  final String description;
  final VoidCallback? onTap;

  const _OnboardingStep({
    required this.isCompleted,
    required this.title,
    required this.description,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: onTap != null ? 1.0 : 0.5,
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        child: ListTile(
          onTap: onTap,
          leading: Icon(
            isCompleted ? LucideIcons.check : LucideIcons.circle,
            color: isCompleted ? Colors.green : null,
          ),
          title: Text(title),
          subtitle: Text(description),
          trailing: onTap != null ? const Icon(Icons.arrow_forward_ios) : null,
        ),
      ),
    );
  }
}
