import 'package:assigngo_rewrite/spaces/providers/spaces_provider.dart';
import 'package:assigngo_rewrite/spaces/views/space_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AllSpacesScreen extends ConsumerStatefulWidget {
  const AllSpacesScreen({super.key});

  @override
  ConsumerState<AllSpacesScreen> createState() => _AllSpacesState();
}

class _AllSpacesState extends ConsumerState<AllSpacesScreen> {
  @override
  void initState() {
    super.initState();
  }

  int currentPageValue = 0;

  @override
  Widget build(BuildContext context) {
    final spacesAsync = ref.watch(spacesManagerProvider);

    return SafeArea(
      child: spacesAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('Error: $error')),
          data: (spaces) {
            return Stack(
              children: [
                PageView.builder(
                  scrollDirection: Axis.horizontal,
                  onPageChanged: (int page) {
                    setState(() {
                      currentPageValue = page;
                    });
                  },
                  itemCount: spaces.length,
                  itemBuilder: (context, index) {
                    return SpaceCard(space: spaces[index]);
                  },
                ),

                // Stack display icons at bottom of space card to change space
                Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      margin: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              for (int i = 0; i < spaces.length; i++)
                                if (i == currentPageValue) ...[
                                  circleBar(true)
                                ] else
                                  circleBar(false),
                            ],
                          ),
                          const SizedBox(height: 8.0),
                        ],
                      ),
                    ))
              ],
            );
          }),
    );
  }

  Widget circleBar(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 8),
      height: isActive ? 12 : 8,
      width: isActive ? 12 : 8,
      decoration: BoxDecoration(
        color: isActive ? Colors.blue : Colors.grey,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
