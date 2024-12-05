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
import 'package:showcaseview/showcaseview.dart';

class AllSpacesScreen extends ConsumerStatefulWidget {
  const AllSpacesScreen({super.key, this.isShowcasing = false});
  final bool isShowcasing;

  @override
  ConsumerState<AllSpacesScreen> createState() => _AllSpacesState();
}

class _AllSpacesState extends ConsumerState<AllSpacesScreen> {
  late PageController _pageController;
  final SupabaseStorageClient storageClient = Supabase.instance.client.storage;
  ValueNotifier<int> currentPageValue = ValueNotifier(0);
  ValueNotifier<bool> showGameNotifier = ValueNotifier(true);
  late final String? initialBackgroundUrl;
  late final SharedPreferences prefs;
  late String backgroundColor;
  final GlobalKey _addTaskKey = GlobalKey();
  final GlobalKey _firstSpaceKey = GlobalKey();
  final GlobalKey _firstCategoryKey = GlobalKey();

  void _updatePage() {
    if (mounted && _pageController.hasClients) {
      currentPageValue.value = _pageController.page?.round() ?? 0;
    }
  }

  void _startShowcase() {
    if (!mounted) return;
    debugPrint('Starting showcase');
    ShowCaseWidget.of(context).startShowCase(
      [_addTaskKey, _firstCategoryKey, _firstSpaceKey],
    );
  }

  @override
  void initState() {
    super.initState();
    debugPrint(
        'AllSpacesScreen initState, isShowcasing: ${widget.isShowcasing}');

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _pageController = ref.read(pageControllerProvider);
      _pageController.addListener(_updatePage);

      try {
        final spaces = await ref.read(spacesManagerProvider.future);
        if (spaces.isNotEmpty) {
          final dateType = DateTime.now().getTimeOfDayType();
          initialBackgroundUrl = storageClient
              .from("assets")
              .getPublicUrl("backgrounds/${spaces[0].spaceType}/$dateType.png");

          prefs = await SharedPreferences.getInstance();
          backgroundColor =
              prefs.getString("background_${spaces[0].spaceType}_$dateType") ??
                  "#000000";

          if (initialBackgroundUrl != null && mounted) {
            ref.read(gameProvider.notifier).state =
                FamiliarsWidgetGame(backgroundPath: initialBackgroundUrl!);
          }
        } else {
          initialBackgroundUrl = null;
          if (mounted) {
            ref.read(gameProvider.notifier).state = null;
          }
        }

        if (widget.isShowcasing && mounted) {
          debugPrint('Attempting to start showcase');
          // Give time for the widgets to be properly laid out
          await Future.delayed(const Duration(milliseconds: 1500));
          if (!mounted) return;
          _startShowcase();
        }
<<<<<<< Updated upstream
      }

      if (!widget.isShowcasing && mounted) {
        // Wait for the next frame to ensure widgets are built
        await Future.delayed(const Duration(milliseconds: 500));
        if (!mounted) return;

        if (widget.isShowcasing) {
          _startShowcase();
        }
=======
      } catch (e, stackTrace) {
        debugPrint('Error in initState: $e');
        await Sentry.captureException(e, stackTrace: stackTrace);
>>>>>>> Stashed changes
      }
    });
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
        floatingActionButton: Showcase(
          key: _addTaskKey,
          description: 'Tap here to create a new task',
          child: FloatingActionButton(
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
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 4),
                        child: AnimatedGameContainer(
                          game: game,
                          heightFactor: heightFactor,
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
                              page,
                              page == spaces.length
                                  ? initialBackgroundUrl
                                  : storageClient.from("assets").getPublicUrl(
                                      "backgrounds/${spaces[page].spaceType}/$dateType.png"));

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
                          return SpaceCard(
                            space: spaces[index],
                            backgroundColorHex: spaceBackgroundColor,
                            categoryKey: widget.isShowcasing && index == 0
                                ? _firstCategoryKey
                                : null,
                          );
                        },
                      ),
                    ),
                  ],
                ),
                CircleProgressBar(
                  spaces: spaces,
                  addSpaceKey: widget.isShowcasing ? _firstSpaceKey : null,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
