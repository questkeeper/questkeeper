import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:questkeeper/shared/extensions/string_extensions.dart';
import 'package:questkeeper/shared/widgets/snackbar.dart';
import 'package:questkeeper/spaces/mixins/spaces_screen_mixin.dart';
import 'package:questkeeper/spaces/widgets/circle_tab_indicator.dart';
import 'package:questkeeper/tabs/new_user_onboarding/onboarding_overlay.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'package:questkeeper/familiars/widgets/familiars_widget_game.dart';
import 'package:questkeeper/spaces/providers/game_height_provider.dart';
import 'package:questkeeper/spaces/providers/game_provider.dart';
import 'package:questkeeper/spaces/providers/spaces_provider.dart';
import 'package:questkeeper/spaces/views/edit_space_bottom_sheet.dart';
import 'package:questkeeper/spaces/widgets/animated_game_container.dart';
import 'package:questkeeper/spaces/widgets/space_card.dart';

class AllSpacesScreen extends ConsumerStatefulWidget {
  const AllSpacesScreen({super.key});

  @override
  ConsumerState<AllSpacesScreen> createState() => _AllSpacesState();
}

class _AllSpacesState extends SpacesScreenState<AllSpacesScreen> {
  final ValueNotifier<String> _appBarBackgroundColor = ValueNotifier("");
  double dragStartX = 0.0;

  @override
  ValueNotifier<String>? get appBarBackgroundColor => _appBarBackgroundColor;

  @override
  void dispose() {
    _appBarBackgroundColor.dispose();
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
        updateTabController(spaces.length + 1); // +1 for the "Create" tab

        return Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight / 2),
            child: ValueListenableBuilder<String>(
              valueListenable: _appBarBackgroundColor,
              builder: (context, appBackgroundColor, child) {
                return Stack(
                  children: [
                    AppBar(
                      toolbarHeight: 0,
                      backgroundColor: currentPageValue.value == spaces.length
                          ? Colors.transparent
                          : (heightFactor <= 0.3
                              ? backgroundColor.value.toColor()
                              : appBackgroundColor.toColor()),
                      elevation: 0,
                    ),
                    SafeArea(
                      child: TabBar(
                        controller: tabController,
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
                          pageController.jumpToPage(index);
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
                  if (game != null && isGameInitialized)
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
                          pageController.animateToPage(
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
                      controller: pageController,
                      onPageChanged: (page) =>
                          handlePageChanged(page, spaces, isMobile: true),
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
