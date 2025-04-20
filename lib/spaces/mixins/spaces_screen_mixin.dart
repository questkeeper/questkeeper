import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:questkeeper/categories/providers/categories_provider.dart';
import 'package:questkeeper/familiars/widgets/familiars_widget_game.dart';
import 'package:questkeeper/shared/extensions/datetime_extensions.dart';
import 'package:questkeeper/shared/utils/shared_preferences_manager.dart';
import 'package:questkeeper/spaces/providers/game_height_provider.dart';
import 'package:questkeeper/spaces/providers/game_provider.dart';
import 'package:questkeeper/spaces/providers/page_provider.dart';
import 'package:questkeeper/spaces/providers/spaces_provider.dart';
import 'package:questkeeper/spaces/views/edit_space_bottom_sheet.dart';
import 'package:questkeeper/task_list/providers/tasks_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class SpacesScreenState<T extends ConsumerStatefulWidget>
    extends ConsumerState<T> with TickerProviderStateMixin {
  late final PageController pageController;
  late TabController tabController;
  ValueNotifier<int> currentPageValue = ValueNotifier(0);
  late final String? initialBackgroundPath;
  static final SharedPreferencesManager prefs =
      SharedPreferencesManager.instance;
  late ValueNotifier<String> backgroundColor = ValueNotifier("");
  bool isGameInitialized = false;
  late final String _screenId;

  // Override this in mobile view to handle app bar color
  ValueNotifier<String>? get appBarBackgroundColor => null;

  static const String defaultBackgroundColor =
      "#80bac6"; // Default office color
  static const String defaultTopBackgroundColor =
      "#A6CDCF"; // Default office top color

  @override
  void initState() {
    super.initState();

    _screenId = '${widget.runtimeType}_${DateTime.now().millisecondsSinceEpoch}';
    pageController = ref.read(pageControllerProvider);
    tabController = TabController(length: 1, vsync: this);
    backgroundColor.value = defaultBackgroundColor;
    if (appBarBackgroundColor != null) {
      appBarBackgroundColor!.value = defaultTopBackgroundColor;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => setup());
  }

  void updateTabController(int length) {
    final int oldIndex = tabController.index;
    final int oldLength = tabController.length;
    tabController.dispose();
    tabController = TabController(
      length: length,
      vsync: this,
      initialIndex:
          oldLength == length ? (oldIndex < length ? oldIndex : length - 1) : 0,
    );
  }

  Future<void> setup() async {
    if (!mounted) return;

    try {
      ref.read(gameHeightProvider.notifier).state = 1.0;
      pageController.addListener(updatePage);
    } catch (e) {
      debugPrint('Error in setup: $e');
      setGameStateToNull();
    }

    try {
      await initializeGame();
    } catch (e) {
      debugPrint('Error in setup: $e');
      setGameStateToNull();
    }
  }

  void setGameStateToNull() {
    isGameInitialized = true;
    ref.read(gameManagerProvider).setGameInstance(null, _screenId);
  }

  Future<void> initializeGame() async {
    if (!isGameInitialized &&
        Supabase.instance.client.auth.currentUser != null) {
      try {
        final spaces = await ref.read(spacesManagerProvider.future);

        if (spaces.isNotEmpty) {
          final dateType = DateTime.now().getTimeOfDayType();
          initialBackgroundPath =
              "backgrounds/${spaces[0].spaceType}/$dateType.png";

          // Set initial background colors
          updateBackgroundColors(0, spaces, dateType);

          if (initialBackgroundPath != null && mounted && !isGameInitialized) {
            isGameInitialized = true;
            final game = FamiliarsWidgetGame(backgroundPath: initialBackgroundPath!);
            ref.read(gameManagerProvider).setGameInstance(game, _screenId);
          }
        }
      } catch (e) {
        debugPrint('Error initializing game: $e');
        setGameStateToNull();
        return;
      }
    } else if (!isGameInitialized) {
      setGameStateToNull();
    }
  }

  void updatePage() async {
    if (mounted && pageController.hasClients) {
      final newPage = pageController.page?.round() ?? 0;
      if (currentPageValue.value != newPage) {
        currentPageValue.value = newPage;
        tabController.animateTo(newPage);

        // updateBackgroundColors(
        //   newPage,
        //   await ref.read(spacesManagerProvider.future),
        //   DateTime.now().getTimeOfDayType(),
        // );
      }
    }
  }

  Future<void> handleRefresh() async {
    // ignore: unused_result
    ref.refresh(spacesManagerProvider);
    // ignore: unused_result
    ref.refresh(tasksManagerProvider);
    // ignore: unused_result
    ref.refresh(categoriesManagerProvider);
    initializeGame();
  }

  void updateBackgroundColors(int page, List<dynamic> spaces, String dateType) {
    try {
      if (page >= spaces.length) {
        // For the "Create" page
        final defaultSpace = spaces.isNotEmpty ? spaces[0] : null;
        final spaceType = defaultSpace?.spaceType ?? "office";

        backgroundColor.value =
            prefs.getString("background_${spaceType}_$dateType") ??
                defaultBackgroundColor;

        if (appBarBackgroundColor != null) {
          appBarBackgroundColor!.value =
              prefs.getString("background_${spaceType}_top_$dateType") ??
                  defaultTopBackgroundColor;
        }
      } else {
        // For regular space pages
        final space = spaces[page];
        final spaceType = space?.spaceType ?? "office";

        backgroundColor.value =
            prefs.getString("background_${spaceType}_$dateType") ??
                defaultBackgroundColor;

        if (appBarBackgroundColor != null) {
          appBarBackgroundColor!.value =
              prefs.getString("background_${spaceType}_top_$dateType") ??
                  defaultTopBackgroundColor;
        }
      }
    } catch (e) {
      debugPrint('Error updating background colors: $e');
      backgroundColor.value = defaultBackgroundColor;
      if (appBarBackgroundColor != null) {
        appBarBackgroundColor!.value = defaultTopBackgroundColor;
      }
    }
  }

  void handlePageChanged(int page, List<dynamic> spaces,
      {bool isMobile = false}) {
    if (!mounted) return;

    try {
      final dateType = DateTime.now().getTimeOfDayType();
      final currentGame = ref.read(gameProvider);

      if (currentGame == null) return;

      // Update current page value first
      currentPageValue.value = page;

      // Update game background
      final spaceType = page >= spaces.length
          ? (spaces.isNotEmpty ? spaces[0].spaceType : "office")
          : spaces[page].spaceType;

      currentGame.updateBackground(
        "backgrounds/$spaceType/$dateType.png",
      );

      // Determine animation direction based on actual page change
      final isForward = page > (pageController.page?.floor() ?? 0);

      // Sync tab controller
      if (tabController.index != page) {
        tabController.animateTo(page);
      }

      // Animate game transition
      currentGame.animateEntry(isForward ? Direction.left : Direction.right);

      // Handle mobile-specific behaviors
      if (isMobile && page == spaces.length) {
        showSpaceBottomSheet(context: context, ref: ref);
        ref.read(gameHeightProvider.notifier).state = 0.3;
      } else if (isMobile && !isForward && page == spaces.length - 1) {
        ref.read(gameHeightProvider.notifier).state =
            ref.read(gameHeightProvider) < 0.2 ? 0.3 : 1.0;
      }

      // Update background colors
      updateBackgroundColors(page, spaces, dateType);
    } catch (e) {
      debugPrint('Error in handlePageChanged: $e');
      backgroundColor.value = defaultBackgroundColor;
      if (appBarBackgroundColor != null) {
        appBarBackgroundColor!.value = defaultTopBackgroundColor;
      }
    }
  }

  @override
  void dispose() {
    if (pageController.hasClients) {
      pageController.removeListener(updatePage);
    }
    ref.read(gameManagerProvider).releaseOwnership(_screenId);
    currentPageValue.dispose();
    tabController.dispose();
    super.dispose();
  }
}
