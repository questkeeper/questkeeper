import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:questkeeper/shared/providers/connectivity_provider.dart';
import 'package:questkeeper/shared/widgets/network_error_screen.dart';

class ConnectivityWrapper extends ConsumerWidget {
  final Widget child;

  const ConnectivityWrapper({
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(connectivityProvider.select(
      (value) => value.when(
        data: (hasConnection) {
          if (!hasConnection) {
            return const NetworkErrorScreen();
          }
          return child;
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => const NetworkErrorScreen(),
      ),
    ));
  }
}
