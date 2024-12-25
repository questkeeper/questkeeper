import 'package:questkeeper/familiars/widgets/familiars_widget_game.dart';
import 'package:questkeeper/shared/extensions/datetime_extensions.dart';
import 'package:questkeeper/spaces/providers/game_height_provider.dart';
import 'package:questkeeper/spaces/providers/game_provider.dart';
import 'package:questkeeper/spaces/providers/page_provider.dart';
import 'package:questkeeper/spaces/providers/spaces_provider.dart';
import 'package:questkeeper/spaces/views/edit_space_bottom_sheet.dart';
import 'package:questkeeper/spaces/widgets/animated_game_container.dart';
import 'package:questkeeper/spaces/widgets/circle_progress_bar.dart';
import 'package:questkeeper/spaces/widgets/space_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:questkeeper/task_list/views/edit_task_bottom_sheet.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AllSpacesScreen extends ConsumerStatefulWidget {
  const AllSpacesScreen({super.key});

  @override
  ConsumerState<AllSpacesScreen> createState() => _AllSpacesState();
}

class _AllSpacesState extends ConsumerState<AllSpacesScreen> {
  late PageController _pageController;
  final SupabaseStorageClient storageClient = Supabase.instance.client.storage;
  ValueNotifier<int> currentPageValue = ValueNotifier(0);
  ValueNotifier<bool> showGameNotifier = ValueNotifier(true);
  late final String? initialBackgroundPath;
  late final SharedPreferences prefs;
  late String backgroundColor;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _pageController = ref.read(pageControllerProvider);
      _pageController.addListener(_updatePage);

      // Prevent timeout
      if (Supabase.instance.client.auth.currentUser != null) {
        final spaces = await ref.read(spacesManagerProvider.future);
        if (spaces.isNotEmpty) {
          final dateType = DateTime.now().getTimeOfDayType();
          initialBackgroundPath =
              "backgrounds/${spaces[0].spaceType}/$dateType.png";

          prefs = await SharedPreferences.getInstance();
          backgroundColor =
              prefs.getString("background_${spaces[0].spaceType}_$dateType") ??
                  "#000000";

          if (initialBackgroundPath != null) {
            if (mounted) {
              ref.read(gameProvider.notifier).state =
                  FamiliarsWidgetGame(backgroundPath: initialBackgroundPath!);
            }
          }
        }
      } else {
        initialBackgroundPath = null;
        if (mounted) {
          ref.read(gameProvider.notifier).state = null;
        }
      }
    });
  }

  void _updatePage() {
    if (mounted && _pageController.hasClients) {
      currentPageValue.value = _pageController.page?.round() ?? 0;
    }
  }

  @override
  void dispose() {
    if (_pageController.hasClients) {
      _pageController.removeListener(_updatePage);
    }
    currentPageValue.dispose();
    showGameNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final spacesAsync = ref.watch(spacesManagerProvider);
    final heightFactor = ref.watch(gameHeightProvider);
    final game = ref.watch(gameProvider);

    return SafeArea(
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton(
          key: const Key('add_task_button_mobile'),
          heroTag: 'add_task_button_mobile',
          onPressed: () => {
            showTaskBottomSheet(
              context: context,
              ref: ref,
              existingTask: null,
            ),
          },
          child: const Icon(LucideIcons.plus),
        ),
        body: spacesAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) {
            debugPrint('Error: $error');
            Sentry.captureException(
              error,
              stackTrace: stack,
            );
            return Center(child: Text('Error: $error'));
          },
          data: (spaces) {
            return Stack(
              children: [
                Column(
                  children: [
                    if (game != null) // Only show when game is ready
                      GestureDetector(
                        onHorizontalDragEnd: (dragDetails) {
                          // Change page value
                          debugPrint('onHorizontalDragEnd');
                          if (dragDetails.primaryVelocity! > 0) {
                            currentPageValue = ValueNotifier(
                                currentPageValue.value.round() - 1);
                          } else {
                            currentPageValue = ValueNotifier(
                                currentPageValue.value.round() + 1);
                          }
                          // TODO: REPLACE THIS SOON BC IT IS TEMPORARY... I THINK
                          _pageController.animateToPage(currentPageValue.value,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut);
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 4),
                          child: AnimatedGameContainer(
                            game: game,
                            heightFactor: heightFactor,
                            shouldTextShow: currentPageValue.value == 0,
                          ),
                        ),
                      ),
                    Expanded(
                      child: PageView.builder(
                        controller: _pageController,
                        onPageChanged: (page) {
                          currentPageValue = ValueNotifier(page);

                          final dateType = DateTime.now().getTimeOfDayType();
                          final currentGame = ref.read(gameProvider);

                          if (currentGame == null) {
                            return;
                          }

                          currentGame.updateBackground(
                            page == spaces.length
                                ? initialBackgroundPath ?? "placeholder"
                                : "backgrounds/${spaces[page].spaceType}/$dateType.png",
                          );

                          final isForward = page >
                              (ref.read(pageControllerProvider).page ?? 0);
                          currentGame.animateEntry(
                            isForward ? Direction.left : Direction.right,
                          );

                          if (currentPageValue.value == spaces.length) {
                            showSpaceBottomSheet(
                              context: context,
                              ref: ref,
                            );
                            ref.read(gameHeightProvider.notifier).state = 0.3;
                          }

                          if (!isForward && page == spaces.length - 1) {
                            ref.read(gameHeightProvider.notifier).state = 1.0;
                          }
                        },
                        itemCount: spaces.length + 1,
                        itemBuilder: (context, index) {
                          String spaceBackgroundColor = index == spaces.length
                              ? "#000000"
                              : prefs.getString(
                                      "background_${spaces[index].spaceType}_${DateTime.now().getTimeOfDayType()}") ??
                                  "#000000";

                          if (index == spaces.length) {
                            return Center(
                              child: GestureDetector(
                                onTap: () {
                                  showSpaceBottomSheet(
                                    context: context,
                                    ref: ref,
                                  );
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(LucideIcons.circle_plus, size: 48),
                                    Text('Create a new space'),
                                  ],
                                ),
                              ),
                            );
                          }
                          return SpaceCard(
                              space: spaces[index],
                              backgroundColorHex: spaceBackgroundColor);
                        },
                      ),
                    ),
                  ],
                ),
                CircleProgressBar(spaces: spaces)
              ],
            );
          },
        ),
      ),
    );
  }
}
