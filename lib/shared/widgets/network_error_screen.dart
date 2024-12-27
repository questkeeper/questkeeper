import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:questkeeper/shared/widgets/red_panda_sleep.dart';

class NetworkErrorScreen extends ConsumerWidget {
  const NetworkErrorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Network Error Icon
              Icon(
                LucideIcons.wifi_off,
                size: 96,
                color: colorScheme.primary,
              ),
              const SizedBox(height: 32),
              SizedBox(
                height: 64,
                child: GameWidget(
                  game: RedPandaGame(),
                  backgroundBuilder: (BuildContext context) {
                    return Container(
                      color: colorScheme.surface,
                    );
                  },
                ),
              ),
              // Error Message
              Text(
                'No Internet Connection',
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Please check your internet connection and try again',
                style: textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
