import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:questkeeper/profile/model/profile_model.dart';
import 'package:questkeeper/profile/providers/profile_provider.dart';
import 'package:questkeeper/shared/providers/window_size_provider.dart';
import 'package:questkeeper/shared/widgets/avatar_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';

class UserProfileView extends ConsumerWidget {
  const UserProfileView({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMobile = ref.watch(isMobileProvider);
    return Padding(
      padding: EdgeInsets.all(8),
      child: Consumer(
        builder: (context, ref, _) {
          final asyncValue = ref.watch(profileManagerProvider);
          return Skeletonizer(
            enabled: asyncValue is AsyncLoading || !asyncValue.hasValue,
            child: !isMobile
                ? Padding(
                    padding: const EdgeInsets.all(8),
                    child: _buildMainContent(context, ref),
                  )
                : Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: _buildMainContent(context, ref),
                    ),
                  ),
          );
        },
      ),
    );
  }

  Widget _buildMainContent(BuildContext context, WidgetRef ref) {
    final asyncValue = ref.watch(profileManagerProvider);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        asyncValue is AsyncData
            ? AvatarWidget(seed: (asyncValue.value as Profile).user_id)
            : const CircleAvatar(radius: 50),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      asyncValue is AsyncData
                          ? (asyncValue.value as Profile).username
                          : 'Username Loading',
                      style: Theme.of(context).textTheme.titleLarge,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (asyncValue is AsyncData &&
                      (asyncValue.value as Profile).isPro == true)
                    const Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Text(
                        'PRO',
                        style: TextStyle(color: Colors.greenAccent),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 5),
              Text(
                asyncValue is AsyncData
                    ? '${(asyncValue.value as Profile).points} points'
                    : '0 points',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Text(
                "Nudge Limit: 3",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.6),
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
