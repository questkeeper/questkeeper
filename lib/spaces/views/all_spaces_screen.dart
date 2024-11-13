import 'package:questkeeper/familiars/widgets/familiars_widget_game.dart';
import 'package:questkeeper/spaces/models/spaces_model.dart';
import 'package:questkeeper/spaces/providers/game_height_provider.dart';
import 'package:questkeeper/spaces/providers/page_provider.dart';
import 'package:questkeeper/spaces/providers/spaces_provider.dart';
import 'package:questkeeper/spaces/widgets/animated_game_container.dart';
import 'package:questkeeper/spaces/widgets/circle_bar.dart';
import 'package:questkeeper/spaces/widgets/space_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AllSpacesScreen extends ConsumerStatefulWidget {
  const AllSpacesScreen({super.key});

  @override
  ConsumerState<AllSpacesScreen> createState() => _AllSpacesState();
}

class _AllSpacesState extends ConsumerState<AllSpacesScreen> {
  late PageController _pageController;
  final FamiliarsWidgetGame _game = FamiliarsWidgetGame();
  int currentPageValue = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final spacesAsync = ref.watch(spacesManagerProvider);
    final heightFactor = ref.watch(gameHeightProvider);
    _pageController = ref.watch(pageControllerProvider);

    return SafeArea(
      child: spacesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (spaces) {
          return Stack(
            children: [
              Column(
                children: [
                  Container(
                    margin: const EdgeInsets.all(4.0),
                    child: AnimatedGameContainer(
                        game: _game, heightFactor: heightFactor),
                  ),
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: (page) {
                        // Handle page changes - animate familiar if needed
                        currentPageValue = page;
                        final isForward =
                            page > (ref.read(pageControllerProvider).page ?? 0);
                        _game.animateEntry(
                          isForward ? Direction.left : Direction.right,
                        );
                      },
                      itemCount: spaces.length + 1,
                      itemBuilder: (context, index) {
                        if (index == spaces.length) {
                          return const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(LucideIcons.circle_plus, size: 48),
                                Text('Create a new space'),
                              ],
                            ),
                          );
                        }
                        return SpaceCard(space: spaces[index]);
                      },
                    ),
                  ),
                ],
              ),
              _buildBottomBar(spaces),
            ],
          );
        },
      ),
    );
  }

  Align _buildBottomBar(List<Spaces> spaces) {
    return Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          margin: const EdgeInsets.all(16.0),
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
                      const CircleBar(isActive: true),
                      // circleBar(true)
                    ] else
                      GestureDetector(
                        onTap: () {
                          _pageController.animateToPage(i,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut);
                        },
                        child: const CircleBar(isActive: false),
                      ),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          currentPageValue = spaces.length;
                          _pageController.animateToPage(spaces.length,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut);
                        });
                      },
                      icon: const Icon(LucideIcons.plus,
                          size: 24, color: Colors.blue)),
                ],
              ),
              const SizedBox(height: 8.0),
            ],
          ),
        ));
  }
}
