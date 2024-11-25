import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:questkeeper/quests/models/badge.dart' as badge_model;
import 'package:questkeeper/quests/providers/badge_providers.dart';
import 'package:questkeeper/shared/extensions/color_extensions.dart';

class QuestsView extends ConsumerWidget {
  const QuestsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: Colors.purple.toCardGradientColor(),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Badges",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ref.watch(badgeManagerProvider).when(
                    data: (badges) {
                      return Row(
                        children: badges
                            .map(
                              (badge) => badgeCard(context, badge),
                            )
                            .toList(),
                      );
                    },
                    loading: () => CircularProgressIndicator(),
                    error: (error, stackTrace) => Text("Error: $error"),
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget badgeCard(BuildContext context, badge_model.Badge badge) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            Text(badge.name, style: Theme.of(context).textTheme.headlineSmall),
            Text(badge.description),
            Text(badge.tier.toString()),
            Text(badge.resetMonthly ? "Monthly" : "One time"),
          ],
        ),
      ),
    );
  }
}
