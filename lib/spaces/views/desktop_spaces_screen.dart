import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:questkeeper/familiars/widgets/familiars_widget_game.dart';
import 'package:questkeeper/shared/extensions/datetime_extensions.dart';
import 'package:questkeeper/shared/extensions/string_extensions.dart';
import 'package:questkeeper/shared/utils/shared_preferences_manager.dart';
import 'package:questkeeper/shared/widgets/snackbar.dart';
import 'package:questkeeper/spaces/providers/game_height_provider.dart';
import 'package:questkeeper/spaces/providers/game_provider.dart';
import 'package:questkeeper/spaces/providers/page_provider.dart';
import 'package:questkeeper/spaces/providers/spaces_provider.dart';
import 'package:questkeeper/spaces/widgets/animated_game_container.dart';
import 'package:questkeeper/spaces/widgets/space_card.dart';
import 'package:questkeeper/spaces/views/edit_space_bottom_sheet.dart';
import 'package:questkeeper/categories/providers/categories_provider.dart';
import 'package:questkeeper/task_list/providers/tasks_provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DesktopSpacesScreen extends ConsumerStatefulWidget {
  const DesktopSpacesScreen({super.key});

  @override
  ConsumerState<DesktopSpacesScreen> createState() =>
      _DesktopSpacesScreenState();
}

class _DesktopSpacesScreenState extends ConsumerState<DesktopSpacesScreen> {
  late final PageController _pageController;
  ValueNotifier<int> currentPageValue = ValueNotifier(0);
  late final String? initialBackgroundPath;
  static final SharedPreferencesManager prefs =
      SharedPreferencesManager.instance;
  late ValueNotifier<String> backgroundColor = ValueNotifier("");
  bool _isGameInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _setup());
  }

  Future<void> _setup() async {
    if (!mounted) return;

    try {
      ref.read(gameHeightProvider.notifier).state = 1.0;
      _pageController = ref.read(pageControllerProvider);
      _pageController.addListener(_updatePage);
    } catch (e) {
      debugPrint('Error in setup: $e');
      _setGameStateToNull();
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

          if (initialBackgroundPath != null && mounted && !_isGameInitialized) {
            _isGameInitialized = true;
            ref.read(gameProvider.notifier).state =
                FamiliarsWidgetGame(backgroundPath: initialBackgroundPath!);
          }
        }
      } catch (e) {
        debugPrint('Error initializing game: $e');
        _setGameStateToNull();
        return;
      }
    } else if (!_isGameInitialized) {
      _setGameStateToNull();
    }
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final spacesAsync = ref.watch(spacesManagerProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final game = ref.watch(gameProvider);

    return spacesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) {
        Sentry.captureException(error, stackTrace: stack);
        return Center(child: Text('Error: $error'));
      },
      data: (spaces) {
        return Scaffold(
          backgroundColor: colorScheme.surface,
          body: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 0, 16),
            child: Row(
              children: [
                // Left panel - Space List with Familiars
                Container(
                  width: 280,
                  margin: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.shadow.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Spaces List
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          itemCount: spaces.length + 1,
                          itemBuilder: (context, index) {
                            if (index == spaces.length) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                child: OutlinedButton.icon(
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.all(16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  icon: const Icon(LucideIcons.plus),
                                  label: const Text('Create Space'),
                                  onPressed: () => showSpaceBottomSheet(
                                    context: context,
                                    ref: ref,
                                  ),
                                ),
                              );
                            }

                            final space = spaces[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              child: Material(
                                color: Colors.transparent,
                                child: ListTile(
                                  selected: currentPageValue.value == index,
                                  selectedTileColor:
                                      colorScheme.primaryContainer,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  leading: const Icon(LucideIcons.eclipse),
                                  title: Text(space.title.capitalize()),
                                  onTap: () {
                                    _pageController.jumpToPage(index);
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      // Familiars Game at bottom
                      if (game != null && _isGameInitialized)
                        Container(
                          height: 200,
                          padding: const EdgeInsets.all(16),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: AnimatedGameContainer(
                              game: game,
                              heightFactor: ref.watch(gameHeightProvider),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                // Main content area - Tasks and Categories with PageView
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(right: 16),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.shadow.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: PageView.builder(
                        controller: _pageController,
                        onPageChanged: (page) {
                          currentPageValue.value = page;
                          final dateType = DateTime.now().getTimeOfDayType();
                          final currentGame = ref.read(gameProvider);

                          if (currentGame == null) return;

                          currentGame.updateBackground(
                            page == spaces.length
                                ? initialBackgroundPath ?? "placeholder"
                                : "backgrounds/${spaces[page].spaceType}/$dateType.png",
                          );

                          final isForward = page > (currentPageValue.value);
                          currentGame.animateEntry(
                            isForward ? Direction.left : Direction.right,
                          );

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
                              ref.refresh(spacesManagerProvider);
                              ref.refresh(tasksManagerProvider);
                              ref.refresh(categoriesManagerProvider);
                              _initializeGame();
                              SnackbarService.showInfoSnackbar('Refreshed');
                            },
                            child: SpaceCard(
                              space: spaces[index],
                              backgroundColorHex: backgroundColor.value,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
