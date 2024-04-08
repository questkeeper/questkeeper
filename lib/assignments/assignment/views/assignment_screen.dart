import 'package:assigngo_rewrite/assignments/providers/assignment_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class AssignmentScreen extends ConsumerStatefulWidget {
  const AssignmentScreen({super.key});

  @override
  ConsumerState<AssignmentScreen> createState() => _AssignmentScreenState();
}

class _AssignmentScreenState extends ConsumerState<AssignmentScreen> {
  @override
  Widget build(BuildContext context) {
    final currentAssignment = ref.watch(currentAssignmentProvider).assignment;
    final platformBrightness = MediaQuery.of(context).platformBrightness;
    final size = MediaQuery.of(context).size;

    if (currentAssignment == null) {
      return Container(
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: platformBrightness == Brightness.dark
              ? CupertinoColors.darkBackgroundGray
              : CupertinoColors.lightBackgroundGray,
          borderRadius: const BorderRadius.all(Radius.circular(16.0)),
        ),
        child: const Center(
          child: Text("No assignment selected"),
        ),
      );
    }

    return Scaffold(
      body: Container(
        padding: size.width > 800
            ? const EdgeInsets.all(32.0)
            : const EdgeInsets.all(8),
        margin: size.width > 800
            ? const EdgeInsets.all(32.0)
            : const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: platformBrightness == Brightness.dark
              ? CupertinoColors.darkBackgroundGray
              : CupertinoColors.lightBackgroundGray,
          borderRadius: const BorderRadius.all(Radius.circular(16.0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    ref
                        .read(currentAssignmentProvider.notifier)
                        .setCurrentAssignment(null);
                  },
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    ref.read(currentAssignmentProvider.notifier);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.star),
                  color: Colors.amber,
                  onPressed: () {
                    ref.read(currentAssignmentProvider.notifier);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.check_box),
                  color: Colors.green,
                  onPressed: () {
                    ref.read(currentAssignmentProvider.notifier);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  color: Colors.red,
                  onPressed: () {
                    ref.read(currentAssignmentProvider.notifier);
                  },
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.centerLeft,
              child: Text(
                  style: Theme.of(context).textTheme.headlineLarge,
                  currentAssignment.title),
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.centerLeft,
              child: Text(
                currentAssignment.description ?? "",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.centerLeft,
              child: Text(
                "Due ${DateFormat('MMMM d, y hh:mm a').format(currentAssignment.dueDate)}",
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            const Divider(),
            Container(
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.centerLeft,
              child: Text(
                "Subtasks",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            const Spacer(
              flex: 2,
            ),
          ],
        ),
      ),
    );
  }
}
