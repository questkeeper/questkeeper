import 'package:assigngo_rewrite/categories/models/categories_model.dart';
import 'package:assigngo_rewrite/spaces/providers/spaces_provider.dart';
import 'package:assigngo_rewrite/spaces/widgets/space_category_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:assigngo_rewrite/spaces/models/spaces_model.dart';

class SpaceCard extends ConsumerWidget {
  const SpaceCard({super.key, required this.space});

  final Spaces space;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSpace = ref.watch(spacesManagerProvider.select(
      (value) => value.value?.firstWhere((s) => s.id == space.id),
    ));

    if (currentSpace == null) {
      return const SizedBox.shrink(); // or some loading indicator
    }

    return Card(
      margin: const EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              const Color(0xff00BFFF).withOpacity(0.7),
              const Color(0xff00CED1).withOpacity(0.7),
              const Color(0xff2E8B57).withOpacity(0.7),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: ListTile(
                titleTextStyle: Theme.of(context).textTheme.titleLarge,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(LucideIcons.pen),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(LucideIcons.trash),
                    ),
                  ],
                ),
                title: Text(currentSpace.title),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: currentSpace.categories?.length != null
                    ? currentSpace.categories!.length + 1
                    : 0,
                itemBuilder: (context, index) {
                  if (index < currentSpace.categories!.length) {
                    final category = currentSpace.categories![index];
                    return SpaceCategoryTile(category: category);
                  } else {
                    return SpaceCategoryTile(
                      category: Categories(
                        title: "Uncategorized",
                        tasks: currentSpace.tasks,
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
