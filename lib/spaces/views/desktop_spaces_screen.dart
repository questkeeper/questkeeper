import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:questkeeper/layout/utils/state_providers.dart';
import 'package:questkeeper/shared/extensions/string_extensions.dart';
import 'package:questkeeper/shared/widgets/snackbar.dart';
import 'package:questkeeper/spaces/mixins/spaces_screen_mixin.dart';
import 'package:questkeeper/spaces/providers/game_height_provider.dart';
import 'package:questkeeper/spaces/providers/game_provider.dart';
import 'package:questkeeper/spaces/providers/page_provider.dart';
import 'package:questkeeper/spaces/providers/spaces_provider.dart';
import 'package:questkeeper/spaces/widgets/animated_game_container.dart';
import 'package:questkeeper/spaces/widgets/space_card.dart';
import 'package:questkeeper/spaces/views/edit_space_bottom_sheet.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class DesktopSpacesScreen extends ConsumerStatefulWidget {
  const DesktopSpacesScreen({super.key});

  @override
  ConsumerState<DesktopSpacesScreen> createState() =>
      _DesktopSpacesScreenState();
}

class _DesktopSpacesScreenState extends SpacesScreenState<DesktopSpacesScreen> {
  @override
  Widget build(BuildContext context) {
    final spacesAsync = ref.watch(spacesManagerProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final game = ref.watch(gameProvider);
    final zenMode = ref.watch(zenModeProvider);

    return spacesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) {
        Sentry.captureException(error, stackTrace: stack);
        return Center(child: Text('Error: $error'));
      },
      data: (spaces) {
        updateTabController(spaces.length + 1); // +1 for the "Create" tab

        return Scaffold(
          backgroundColor: colorScheme.surface,
          body: Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 0, 12),
            child: Row(
              children: [
                // Left panel - Space List with Familiars
                if (!zenMode)
                  Container(
                    width: 200,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.shadow.withValues(alpha: 0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Spaces List
                        Expanded(
                          child: ListView.builder(
                            itemCount: spaces.length + 1,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            itemBuilder: (context, index) {
                              if (index == spaces.length) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  child: OutlinedButton.icon(
                                    icon:
                                        const Icon(LucideIcons.plus, size: 16),
                                    label: const Text('Create Space'),
                                    onPressed: () => showSpaceBottomSheet(
                                      context: context,
                                      ref: ref,
                                    ),
                                  ),
                                );
                              }

                              final space = spaces[index];
                              return ValueListenableBuilder<int>(
                                valueListenable: currentPageValue,
                                builder: (context, currentPage, _) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 1),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: ListTile(
                                        dense: true,
                                        visualDensity: VisualDensity.compact,
                                        selected: currentPage == index,
                                        selectedTileColor: colorScheme.primary
                                            .withValues(alpha: 0.2),
                                        hoverColor: colorScheme.primary
                                            .withValues(alpha: 0.1),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        title: Text(
                                          space.title.capitalize(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                color: currentPage == index
                                                    ? colorScheme.primary
                                                    : colorScheme.onSurface,
                                              ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        onTap: () {
                                          pageController.jumpToPage(index);
                                          currentPageValue.value = index;
                                          // Update the global current page provider
                                          ref
                                              .read(
                                                  currentPageProvider.notifier)
                                              .state = index;
                                        },
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),

                        if (game != null && isGameInitialized)
                          Stack(
                            children: [
                              Container(
                                height: 200,
                                padding: const EdgeInsets.all(12),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: AnimatedGameContainer(
                                    game: game,
                                    heightFactor: ref.watch(gameHeightProvider),
                                  ),
                                ),
                              ),
                              Container(
                                height: 200,
                                decoration: BoxDecoration(
                                  color: colorScheme.surfaceContainerLow,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),

                // Main content area - Tasks and Categories with PageView
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.shadow.withValues(alpha: 0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: PageView.builder(
                        key: PageStorageKey('desktop_spaces_pageview'),
                        controller: pageController,
                        onPageChanged: (page) {
                          // Clear the context pane when switching spaces
                          ref.read(contextPaneProvider.notifier).state = null;
                          ref
                              .read(isContextPaneCollapsedProvider.notifier)
                              .state = false;
                          handlePageChanged(page, spaces);
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
                              await handleRefresh();
                              SnackbarService.showInfoSnackbar('Refreshed');
                            },
                            child: ValueListenableBuilder<String>(
                              valueListenable: backgroundColor,
                              builder: (context, bgColor, _) {
                                return SpaceCard(
                                  space: spaces[index],
                                  backgroundColorHex: bgColor,
                                );
                              },
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
