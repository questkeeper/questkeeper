import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:questkeeper/categories/providers/categories_provider.dart';
import 'package:questkeeper/shared/extensions/string_extensions.dart';
import 'package:questkeeper/shared/utils/shared_preferences_manager.dart';
import 'package:questkeeper/shared/widgets/snackbar.dart';
import 'package:questkeeper/spaces/widgets/circle_tab_indicator.dart';
import 'package:questkeeper/tabs/new_user_onboarding/onboarding_overlay.dart';
import 'package:questkeeper/task_list/providers/tasks_provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:questkeeper/familiars/widgets/familiars_widget_game.dart';
import 'package:questkeeper/shared/extensions/datetime_extensions.dart';
import 'package:questkeeper/spaces/providers/game_height_provider.dart';
import 'package:questkeeper/spaces/providers/game_provider.dart';
import 'package:questkeeper/spaces/providers/page_provider.dart';
import 'package:questkeeper/spaces/providers/spaces_provider.dart';
import 'package:questkeeper/spaces/views/edit_space_bottom_sheet.dart';
import 'package:questkeeper/spaces/widgets/animated_game_container.dart';
import 'package:questkeeper/spaces/widgets/space_card.dart';

class AllSpacesScreen extends ConsumerStatefulWidget {
  const AllSpacesScreen({super.key});

  @override
  ConsumerState<AllSpacesScreen> createState() => _AllSpacesState();
}

class _AllSpacesState extends ConsumerState<AllSpacesScreen>
    with TickerProviderStateMixin {
  late final PageController _pageController;
  late TabController _tabController;
  ValueNotifier<int> currentPageValue = ValueNotifier(0);
  late final String? initialBackgroundPath;
  static final SharedPreferencesManager prefs =
      SharedPreferencesManager.instance;
  // Color should be listened to and updated in the game widget
  late ValueNotifier<String> backgroundColor = ValueNotifier("");
  late ValueNotifier<String> appBarBackgroundColor = ValueNotifier("");
  double dragStartX = 0.0;
  bool _isGameInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _setup());
  }

  Future<void> _setup() async {
    if (!mounted) return;

    try {
      // Initial setup
      ref.read(gameHeightProvider.notifier).state = 1.0;
      _pageController = ref.read(pageControllerProvider);
      _pageController.addListener(_updatePage);
    } catch (e) {
      // Retry in 100ms
      Future.delayed(const Duration(milliseconds: 100), () => _setup());
    }

    try {
      await _initializeGame();
    } catch (e) {
      debugPrint('Error in setup: $e');
      _setGameStateToNull();
    }
  }

  void _setGameStateToNull() {
    _isGameInitialized = true;
    ref.read(gameProvider.notifier).state = null;
  }

  Future<void> _initializeGame() async {
    if (!_isGameInitialized &&
        Supabase.instance.client.auth.currentUser != null) {
      try {
        final spaces = await ref.read(spacesManagerProvider.future);

        if (spaces.isNotEmpty) {
          final dateType = DateTime.now().getTimeOfDayType();
          initialBackgroundPath =
              "backgrounds/${spaces[0].spaceType}/$dateType.png";

          backgroundColor.value =
              prefs.getString("background_${spaces[0].spaceType}_$dateType") ??
                  "#000000";

          appBarBackgroundColor.value = prefs.getString(
                  "background_${spaces[0].spaceType}_top_$dateType") ??
              "#000000";

          _tabController =
              TabController(length: spaces.length + 1, vsync: this);

          if (initialBackgroundPath != null && mounted && !_isGameInitialized) {
            _isGameInitialized = true;
            ref.read(gameProvider.notifier).state =
                FamiliarsWidgetGame(backgroundPath: initialBackgroundPath!);
          }
        }
      } catch (e) {
        debugPrint('Error initializing game: $e'); // Will be sent to sentry

        _isGameInitialized = true;
        ref.read(gameProvider.notifier).state = null;
        return;
      }
    } else if (!_isGameInitialized) {
      _isGameInitialized = true;
      ref.read(gameProvider.notifier).state = null;
    }
  }

  void _updatePage() {
    if (mounted && _pageController.hasClients) {
      currentPageValue.value = _pageController.page?.round() ?? 0;
      _tabController.animateTo(currentPageValue.value);
    }
  }

  void _updateTabController(int length) {
    // Dispose old controller if it exists
    final int oldIndex = _tabController.index;
    final int oldLength = _tabController.length;
    _tabController.dispose();
    // Create new controller with updated length
    _tabController = TabController(
      length: length,
      vsync: this,
      // Preserve the current tab if possible
      initialIndex:
          oldLength == length ? (oldIndex < length ? oldIndex : length - 1) : 0,
    );
  }

  @override
  void dispose() {
    if (_pageController.hasClients) {
      _pageController.removeListener(_updatePage);
    }

    currentPageValue.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final spacesAsync = ref.watch(spacesManagerProvider);
    final heightFactor = ref.watch(gameHeightProvider);
    final game = ref.watch(gameProvider);

    final indicatorColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.grey[900]!;

    return spacesAsync.when(
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
        _updateTabController(spaces.length + 1); // +1 for the "Create" tab

        return Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight / 2),
            child: ValueListenableBuilder(
              valueListenable: appBarBackgroundColor,
              builder: (context, appBackgroundColor, child) {
                return Stack(
                  children: [
                    AppBar(
                      toolbarHeight: 0,
                      backgroundColor: currentPageValue.value == spaces.length
                          ? Colors.transparent
                          : (heightFactor <= 0.3
                              ? backgroundColor.value.toColor()
                              : appBarBackgroundColor.value.toColor()),
                      elevation: 0,
                    ),
                    SafeArea(
                      child: TabBar(
                        controller: _tabController,
                        unselectedLabelStyle:
                            Theme.of(context).primaryTextTheme.labelMedium,
                        labelStyle:
                            Theme.of(context).primaryTextTheme.titleMedium,
                        unselectedLabelColor: indicatorColor,
                        labelColor: indicatorColor,
                        dividerHeight: 0,
                        indicator: CircleTabIndicator(
                          color: indicatorColor,
                          radius: 2,
                        ),
                        indicatorColor: Colors.white,
                        isScrollable: true,
                        tabs: [
                          for (var space in spaces)
                            Tab(
                              text: space.title.capitalize(),
                            ),
                          Tab(
                            text: 'Create',
                          ),
                        ],
                        onTap: (index) {
                          _pageController.jumpToPage(index);
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          body: Stack(
            children: [
              Column(
                children: [
                  if (game != null &&
                      _isGameInitialized) // Only show when game is ready
                    GestureDetector(
                      onHorizontalDragEnd: (details) {
                        // If end drag position is the same as start drag position, then it's a tap
                        if (details.globalPosition.dx == dragStartX) {
                          return;
                        }
                        final velocity = details.primaryVelocity ?? 0;
                        final screenWidth = MediaQuery.of(context).size.width;
                        final dragDistance =
                            details.primaryVelocity?.abs() ?? 0;

                        // Define threshold for page change
                        final velocityThreshold = 300.0;
                        final distanceThreshold =
                            screenWidth * 0.2; // 20% of screen width

                        if (velocity.abs() > velocityThreshold ||
                            dragDistance > distanceThreshold) {
                          final newPage = velocity > 0
                              ? max(0, currentPageValue.value - 1)
                              : min(spaces.length, currentPageValue.value + 1);

                          currentPageValue.value = newPage;

                          // Animate both the game and PageView
                          _pageController.animateToPage(
                            newPage,
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                          );

                          // Animate game transition
                          game.animateEntry(
                            velocity > 0 ? Direction.right : Direction.left,
                          );
                        } else {
                          // Reset to current page if threshold not met
                          return;
                        }
                      },
                      child: AnimatedGameContainer(
                        game: game,
                        heightFactor: heightFactor,
                        shouldTextShow: currentPageValue.value != spaces.length,
                      ),
                    ),
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: (page) {
                        currentPageValue.value = page;

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

                        final isForward =
                            page > (ref.read(pageControllerProvider).page ?? 0);
                        currentGame.animateEntry(
                          isForward ? Direction.left : Direction.right,
                        );

                        if (currentPageValue.value == spaces.length) {
                          showSpaceBottomSheet(
                            context: context,
                            ref: ref,
                          );
                          ref.read(gameHeightProvider.notifier).state = 0.3;
                          appBarBackgroundColor.value = "#000000";
                        } else {
                          appBarBackgroundColor.value = page == spaces.length
                              ? prefs.getString(
                                      "background_${spaces[0].spaceType}_top_$dateType") ??
                                  "#000000"
                              : prefs.getString(
                                      "background_${spaces[page].spaceType}_top_$dateType") ??
                                  "#000000";
                        }

                        if (!isForward && page == spaces.length - 1) {
                          ref.read(gameHeightProvider.notifier).state =
                              // Check if the game container is under 200px, if it is then keep the state at 0.3
                              // Otherwise set it to 1.0
                              heightFactor < 0.2 ? 0.3 : 1.0;
                        }

                        backgroundColor.value = page == spaces.length
                            ? prefs.getString(
                                    "background_${spaces[0].spaceType}_$dateType") ??
                                "#000000"
                            : prefs.getString(
                                    "background_${spaces[page].spaceType}_$dateType") ??
                                "#000000";
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
                        return RefreshIndicator.adaptive(
                          onRefresh: () async {
                            // ignore: unused_result
                            ref.refresh(spacesManagerProvider);
                            // ignore: unused_result
                            ref.refresh(tasksManagerProvider);
                            // ignore: unused_result
                            ref.refresh(categoriesManagerProvider);

                            _initializeGame();

                            SnackbarService.showInfoSnackbar('Refreshed');
                          },
                          child: SpaceCard(
                              space: spaces[index],
                              backgroundColorHex: spaceBackgroundColor),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const Positioned(
                bottom: kBottomNavigationBarHeight + 48,
                right: 16,
                child: OnboardingOverlay(),
              ),
            ],
          ),
        );
      },
    );
  }
}
