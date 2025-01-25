import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:questkeeper/familiars/widgets/familiars_widget_game.dart';
import 'package:questkeeper/spaces/providers/spaces_provider.dart';
import 'package:questkeeper/spaces/widgets/space_card.dart';
import 'package:questkeeper/spaces/views/edit_space_bottom_sheet.dart';

class DesktopSpacesScreen extends ConsumerStatefulWidget {
  const DesktopSpacesScreen({super.key});

  @override
  ConsumerState<DesktopSpacesScreen> createState() =>
      _DesktopSpacesScreenState();
}

class _DesktopSpacesScreenState extends ConsumerState<DesktopSpacesScreen> {
  int selectedSpaceIndex = 0;

  @override
  Widget build(BuildContext context) {
    final spacesAsync = ref.watch(spacesManagerProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return spacesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
      data: (spaces) {
        final selectedSpace = selectedSpaceIndex < spaces.length
            ? spaces[selectedSpaceIndex]
            : null;

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
                                  selected: selectedSpaceIndex == index,
                                  selectedTileColor:
                                      colorScheme.primaryContainer,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  leading: const Icon(LucideIcons.eclipse),
                                  title: Text(space.title),
                                  onTap: () {
                                    setState(() {
                                      selectedSpaceIndex = index;
                                    });
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      // Familiars Game at bottom
                      Container(
                        height: 200,
                        padding: const EdgeInsets.all(16),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: GameWidget(
                            game: FamiliarsWidgetGame(
                              backgroundPath: "backgrounds/office/day.png",
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Main content area - Tasks and Categories
                Expanded(
                  child: Stack(
                    children: [
                      Container(
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
                          child: selectedSpace != null
                              ? SpaceCard(
                                  space: selectedSpace,
                                  backgroundColorHex: "#000000",
                                )
                              : const Center(
                                  child: Text(
                                      'Select a space to view its content'),
                                ),
                        ),
                      ),
                    ],
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
