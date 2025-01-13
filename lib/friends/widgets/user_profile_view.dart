import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:questkeeper/profile/model/profile_model.dart';
import 'package:questkeeper/profile/providers/profile_provider.dart';
import 'package:questkeeper/shared/widgets/avatar_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';

class UserProfileView extends StatelessWidget {
  const UserProfileView({
    super.key,
    required this.theme,
  });

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Consumer(
        builder: (context, ref, _) {
          final asyncValue = ref.watch(profileManagerProvider);
          return Skeletonizer(
            enabled: asyncValue is AsyncLoading || !asyncValue.hasValue,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    asyncValue is AsyncData
                        ? AvatarWidget(
                            seed: (asyncValue.value as Profile).user_id)
                        : const CircleAvatar(radius: 50),
                    const SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              asyncValue is AsyncData
                                  ? (asyncValue.value as Profile).username
                                  : 'Username Loading',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            if (asyncValue is AsyncData &&
                                (asyncValue.value as Profile).isPro == true)
                              const Text('PRO',
                                  style: TextStyle(color: Colors.greenAccent))
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
                          asyncValue is AsyncData
                              ? 'Account since ${(asyncValue.value as Profile).created_at.split("T")[0]}'
                              : 'Account since 2024-01-01',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.onSurface
                                        .withValues(alpha: 0.6),
                                  ),
                        ),
                        Text(
                          "Nudge Limit: 3",
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.onSurface
                                        .withValues(alpha: 0.6),
                                  ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
