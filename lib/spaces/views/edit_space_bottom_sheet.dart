import 'package:cached_network_image/cached_network_image.dart';
import 'package:questkeeper/familiars/widgets/familiars_widget_game.dart';
import 'package:questkeeper/shared/extensions/datetime_extensions.dart';
import 'package:questkeeper/shared/extensions/string_extensions.dart';
import 'package:questkeeper/shared/utils/cache_assets.dart';
import 'package:questkeeper/shared/widgets/snackbar.dart';
import 'package:questkeeper/spaces/models/spaces_model.dart';
import 'package:questkeeper/spaces/providers/game_height_provider.dart';
import 'package:questkeeper/spaces/providers/game_provider.dart';
import 'package:questkeeper/spaces/providers/page_provider.dart';
import 'package:questkeeper/spaces/providers/spaces_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void showSpaceBottomSheet({
  required BuildContext context,
  required WidgetRef ref,
  Spaces? existingSpace,
}) {
  final TextEditingController nameController =
      TextEditingController(text: existingSpace?.title);
  final isEditing = existingSpace != null;

  showModalBottomSheet(
    context: context,
    enableDrag: true,
    isDismissible: true,
    showDragHandle: true,
    isScrollControlled: true,
    backgroundColor: Colors
        .transparent, // Make the background transparent to show the gradient
    builder: (BuildContext context) {
      return _SpaceBottomSheetContent(
        spaceType: existingSpace?.spaceType ?? "office",
        nameController: nameController,
        isEditing: isEditing,
        ref: ref,
        existingSpace: existingSpace,
      );
    },
  );
}

class _SpaceBottomSheetContent extends StatefulWidget {
  final TextEditingController nameController;
  final String spaceType;
  final bool isEditing;
  final WidgetRef ref;
  final Spaces? existingSpace;

  const _SpaceBottomSheetContent({
    required this.nameController,
    required this.spaceType,
    required this.isEditing,
    required this.ref,
    this.existingSpace,
  });

  @override
  _SpaceBottomSheetContentState createState() =>
      _SpaceBottomSheetContentState();
}

class _SpaceBottomSheetContentState extends State<_SpaceBottomSheetContent> {
  final SupabaseStorageClient storage = Supabase.instance.client.storage;
  final String backgroundMetadataUrl = Supabase.instance.client.storage
      .from("assets")
      .getPublicUrl("backgrounds/metadata.json");
  late int selectedIdx;
  List<dynamic>? backgroundTypes;

  @override
  void initState() {
    super.initState();
    selectedIdx = 0; // Default value
    _loadBackgroundTypes();
  }

  Future<void> _loadBackgroundTypes() async {
    final metadata =
        await CacheAssetsManager().fetchMetadataFromUrl(backgroundMetadataUrl);
    setState(() {
      backgroundTypes = metadata["backgroundTypes"];
      if (widget.existingSpace != null) {
        selectedIdx = backgroundTypes?.indexWhere((element) =>
                element["name"] == widget.existingSpace?.spaceType) ??
            0;

        if (selectedIdx < 0) {
          selectedIdx = 0;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final pageController = widget.ref.watch(pageControllerProvider);
    final currentPageIndex = pageController.page?.toInt() ?? 0;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 24,
        right: 24,
        top: 16,
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.isEditing ? 'Edit Space' : 'Create New Space',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: widget.nameController,
              decoration: InputDecoration(
                labelText: widget.existingSpace?.title ?? 'Space Name',
              ),
              autofocus: true,
            ),
            const SizedBox(height: 16),
            Text(
              'Select Space Type',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.start,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Skeletonizer(
                  enabled: backgroundTypes == null,
                  child: CachedNetworkImage(
                    imageUrl: storage.from("assets").getPublicUrl(
                        "backgrounds/${backgroundTypes?[selectedIdx]["name"]}/day.png"),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: backgroundTypes == null
                  ? const Center(child: CircularProgressIndicator())
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        for (var i = 0; i < backgroundTypes!.length; i++)
                          ChoiceChip(
                            key: ValueKey(i),
                            selected: selectedIdx == i,
                            color: WidgetStateProperty.all(
                              backgroundTypes![i]["colorCodes"][0]
                                  .toString()
                                  .toColor(),
                            ),
                            onSelected: (isSelected) {
                              setState(() {
                                selectedIdx = i;
                              });
                            },
                            checkmarkColor: Colors.black,
                            label: Text(
                              backgroundTypes![i]["friendlyName"],
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                      ],
                    ),
            ),
            FilledButton(
              onPressed: () async {
                if (widget.nameController.text.isNotEmpty &&
                    backgroundTypes != null) {
                  if (widget.isEditing) {
                    await widget.ref
                        .read(spacesManagerProvider.notifier)
                        .updateSpace(
                          widget.existingSpace!.copyWith(
                              title: widget.nameController.text,
                              spaceType: backgroundTypes?[selectedIdx]["name"]),
                        );
                  } else {
                    await widget.ref
                        .read(spacesManagerProvider.notifier)
                        .createSpace(Spaces(
                            title: widget.nameController.text,
                            spaceType: backgroundTypes?[selectedIdx]["name"]));
                  }
                  if (context.mounted) Navigator.pop(context);
                  widget.nameController.clear();

                  if (!widget.isEditing) {
                    widget.ref.read(gameHeightProvider.notifier).state = 1.0;
                    final dateType = DateTime.now().getTimeOfDayType();
                    final game = widget.ref.read(gameProvider);
                    game?.updateBackground(
                      0,
                      storage.from("assets").getPublicUrl(
                          "backgrounds/${backgroundTypes?[selectedIdx]["name"]}/$dateType.png"),
                    );
                    game?.animateEntry(Direction.left);
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (pageController.hasClients) {
                        pageController.jumpToPage(0);
                      }
                    });
                  } else {
                    if (context.mounted) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (pageController.hasClients) {
                          pageController.jumpToPage(currentPageIndex);
                        }
                      });
                    }
                  }

                  if (context.mounted) {
                    SnackbarService.showSuccessSnackbar(
                      context,
                      widget.isEditing
                          ? 'Space updated successfully'
                          : 'Space created successfully',
                    );
                  }
                }
              },
              child: Text(widget.isEditing ? 'Update Space' : 'Create Space'),
            ),
          ],
        ),
      ),
    );
  }
}
