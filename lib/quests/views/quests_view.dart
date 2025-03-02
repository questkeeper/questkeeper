import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:questkeeper/quests/providers/badges_provider.dart';
import 'package:questkeeper/shared/extensions/color_extensions.dart';
import 'package:questkeeper/shared/widgets/filled_loading_button.dart';

class QuestsView extends ConsumerWidget {
  const QuestsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final badgesAsync = ref.watch(badgesManagerProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Quests & Badges'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Badges'),
              Tab(text: 'Quests'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Badges Tab
            badgesAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, stack) => Center(
                child: Text('Error: $error'),
              ),
              data: (data) {
                final (badges, userBadges) = data;
                return RefreshIndicator(
                  onRefresh: () async {
                    ref.read(badgesManagerProvider.notifier).refreshBadges();
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: badges.length,
                    itemBuilder: (context, index) {
                      final badge = badges[index];
                      final userBadge = userBadges
                          .where(
                            (ub) => ub.badge.id == badge.id,
                          )
                          .firstOrNull;

                      // Check if badge is completed but not redeemed
                      final bool isCompleted =
                          userBadge != null && userBadge.earnedAt != null;
                      final bool canRedeem = isCompleted && !userBadge.redeemed;
                      final redeemText = ValueNotifier('Redeem Badge');

                      return Card(
                        child: ListTile(
                          title: Text(badge.name),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(badge.description),
                              const SizedBox(height: 8),
                              if (userBadge != null)
                                LinearProgressIndicator(
                                  value: userBadge.progress /
                                      badge.requirementCount,
                                ),
                              const SizedBox(height: 4),
                              Text(
                                'Progress: ${userBadge?.progress ?? 0}/${badge.requirementCount}',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              if (userBadge != null && userBadge.redeemed)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    'Redeemed',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ),
                              if (canRedeem)
                                ValueListenableBuilder(
                                  valueListenable: redeemText,
                                  builder: (context, value, child) {
                                    if (value != 'Redeem Badge') {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Text(
                                          value,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(color: Colors.red),
                                        ),
                                      );
                                    }
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: FilledLoadingButton(
                                        onPressed: () async {
                                          try {
                                            await ref
                                                .read(badgesManagerProvider
                                                    .notifier)
                                                .redeemBadge(userBadge.id);
                                          } catch (e) {
                                            redeemText.value =
                                                'This badge is no longer available to redeem :(';
                                          }
                                        },
                                        child: Text(redeemText.value),
                                      ),
                                    );
                                  },
                                )
                            ],
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${badge.points} pts',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              if (badge.resetMonthly)
                                Text(
                                  'Monthly',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
            // Quests Tab (Coming Soon)
            Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: Colors.purple.toCardGradientColor(),
                  ),
                ),
                child: Text(
                  "Quests Coming Soon...",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
