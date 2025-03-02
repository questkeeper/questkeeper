import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:questkeeper/settings/widgets/settings_switch_tile.dart';
import 'package:questkeeper/shared/experiments/providers/experiments_provider.dart';

class ExperimentsScreen extends ConsumerWidget {
  const ExperimentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final experiments = ref.watch(experimentsManagerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Experiments'),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  '⚠️ Warning: These experimental features may cause app instability. Use with caution. These may not even be implemented yet, and may make no change to your QuestKeeper experience.',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Expanded(
            child: experiments.when(
              data: (enabledExperiments) => ListView.builder(
                itemCount: Experiments.values.length,
                itemBuilder: (context, index) {
                  final experiment = Experiments.values[index];
                  final isEnabled = enabledExperiments.contains(experiment);

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: SettingsSwitchTile(
                      title: experiment.name,
                      isEnabled: isEnabled,
                      onTap: (value) async {
                        if (value) {
                          await ref
                              .read(experimentsManagerProvider.notifier)
                              .enableExperiment(experiment);
                        } else {
                          await ref
                              .read(experimentsManagerProvider.notifier)
                              .disableExperiment(experiment);
                        }
                      },
                    ),
                  );
                },
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Error: $error')),
            ),
          ),
        ],
      ),
    );
  }
}
