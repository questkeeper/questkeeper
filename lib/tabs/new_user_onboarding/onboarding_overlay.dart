import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:questkeeper/categories/views/edit_category_bottom_sheet.dart';
import 'package:questkeeper/spaces/providers/page_provider.dart';
import 'package:questkeeper/spaces/providers/spaces_provider.dart';
import 'package:questkeeper/tabs/new_user_onboarding/providers/onboarding_provider.dart';
import 'package:questkeeper/task_list/views/edit_task_drawer.dart';
import 'package:rive/rive.dart';

class OnboardingOverlay extends ConsumerWidget {
  const OnboardingOverlay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardingState = ref.watch(onboardingProvider);

    if (onboardingState.isOnboardingComplete) {
      return const SizedBox.shrink();
    }

    return Card(
      child: InkWell(
        onTap: () => _showOnboardingModal(context, ref),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              onboardingState.playIsCompletingAnimation
                  ? SizedBox.shrink()
                  : const Icon(LucideIcons.circle_help),
              const SizedBox(width: 8),
              Text(
                onboardingState.playIsCompletingAnimation
                    ? 'Nice job!'
                    : 'Getting Started',
              ),
              const SizedBox(width: 8),
              onboardingState.playIsCompletingAnimation
                  ? SizedBox(
                      width: 36,
                      height: 36,
                      child: RiveAnimation.asset(
                        'assets/rive/check.riv',
                        fit: BoxFit.fill,
                      ),
                    )
                  : CircularProgressIndicator(
                      value: onboardingState.completedSteps / 4,
                      strokeWidth: 2,
                    ),
            ],
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

    return ref.watch(spacesManagerProvider).when(
          error: (error, stack) => Text('Error: $error'),
          loading: () => const Center(child: CircularProgressIndicator()),
          data: (spaces) => SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Getting Started with QuestKeeper',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  _OnboardingStep(
                    isCompleted: onboardingState.hasCreatedSpace,
                    title: 'Create your first space',
                    description:
                        'A space is an area where you can organize your tasks',
                    onTap: () async {
                      Navigator.pop(context);
                      if (spaces.isNotEmpty) {
                        ref.read(pageControllerProvider).jumpToPage(
                              spaces.length, // Accounts for the "creation" page
                            );
                      }
                    },
                  ),
                  _OnboardingStep(
                    isCompleted: onboardingState.hasCreatedCategory,
                    title: 'Create your first category',
                    description: 'A category helps you group related tasks',
                    onTap: () async {
                      // Get current space
                      final currentSpace = getCurrentSpace(ref);

                      if (currentSpace == null) return;
                      showCategoryBottomSheet(
                        context: context,
                        ref: ref,
                        existingSpace: currentSpace,
                        openedFrom: "onboarding_overlay",
                      );
                    },
                  ),
                  _OnboardingStep(
                    isCompleted: onboardingState.hasCreatedTask,
                    title: 'Create your first task',
                    description: 'A task is an action you need to complete',
                    onTap: () async {
                      showTaskDrawer(context: context, ref: ref);
                    },
                  ),
                  _OnboardingStep(
                    isCompleted: onboardingState.hasCompletedTask,
                    title: 'Complete your first task',
                    description:
                        'Complete your first task by swiping left on a task',
                    onTap: () async {
                      Navigator.pop(context);
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        icon: Icon(LucideIcons.arrow_right),
                        onPressed: () {
                          Navigator.pop(context);
                          ref
                              .read(onboardingProvider.notifier)
                              .markAllTasksAsDone();
                        },
                        label: const Text('Mark all as done'),
                        iconAlignment: IconAlignment.end,
                      ),
                    ],
                  ),
                ],
              ),
            ),
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
