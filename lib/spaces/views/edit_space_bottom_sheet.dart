import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:questkeeper/familiars/widgets/familiars_widget_game.dart';
import 'package:questkeeper/shared/extensions/datetime_extensions.dart';
import 'package:questkeeper/shared/extensions/string_extensions.dart';
import 'package:questkeeper/shared/widgets/filled_loading_button.dart';
import 'package:questkeeper/shared/widgets/snackbar.dart';
import 'package:questkeeper/spaces/models/spaces_model.dart';
import 'package:questkeeper/spaces/providers/game_height_provider.dart';
import 'package:questkeeper/spaces/providers/game_provider.dart';
import 'package:questkeeper/spaces/providers/page_provider.dart';
import 'package:questkeeper/spaces/providers/spaces_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:questkeeper/spaces/widgets/circle_tab_indicator.dart';
import 'package:questkeeper/tabs/new_user_onboarding/providers/onboarding_provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

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

class _SpaceBottomSheetContentState extends State<_SpaceBottomSheetContent>
    with TickerProviderStateMixin {
  final String backgroundMetadataPath =
      "assets/images/backgrounds/metadata.json";
  late int selectedIdx;
  List<dynamic>? backgroundTypes;
  Map<String, List<int>> notificationTimes = {
    'standard': [12, 24],
    'prioritized': [48],
  };
  late final TabController tabController;

  @override
  void initState() {
    super.initState();
    selectedIdx = 0;
    tabController = TabController(length: 2, vsync: this);

    _loadBackgroundTypes();
    if (widget.existingSpace?.notificationTimes != null) {
      notificationTimes =
          Map<String, List<int>>.from(widget.existingSpace!.notificationTimes);
    }
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  Future<void> _loadBackgroundTypes() async {
    // Read from file
    final metadata = await json.decode(
      await rootBundle.loadString(backgroundMetadataPath),
    );
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

  Widget _buildNotificationTimesSection() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Notification Times',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Text(
          'Standard Notifications',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Text(
          'Customize when notifications will be sent out for all tasks',
          style: Theme.of(context)
              .textTheme
              .labelMedium!
              .copyWith(color: Colors.grey[400]),
        ),
        const SizedBox(height: 6),
        _buildNotificationChips('standard'),
        const SizedBox(height: 16),
        Text(
          'Prioritized Notifications',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Text(
          'Additional notification times for high-priority tasks',
          style: Theme.of(context)
              .textTheme
              .labelMedium!
              .copyWith(color: Colors.grey[400]),
        ),
        const SizedBox(height: 6),
        _buildNotificationChips('prioritized'),
        const SizedBox(height: 6),
        Text.rich(
          textAlign: TextAlign.center,
          TextSpan(
            text: 'Note: ',
            style: Theme.of(context).textTheme.labelMedium!.copyWith(
                  color: Colors.redAccent,
                ),
            children: [
              TextSpan(
                text:
                    "editing the space will not affect existing tasks' notification times",
                style: Theme.of(context)
                    .textTheme
                    .labelMedium!
                    .copyWith(color: Colors.grey[400]),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Map<String, List<dynamic>> buildNotificationTimes(String type) {
    final times = notificationTimes[type] ?? notificationTimes[type] ?? [];
    return {
      "times": times,
      "timesString": times
          .map((time) =>
              '${time >= 24 ? time ~/ 24 : time} ${time >= 24 ? time == 24 ? "Day" : "Days" : time == 1 ? "Hour" : "Hours"}')
          .toList()
    };
  }

  Widget _buildNotificationChips(String type) {
    final times = buildNotificationTimes(type);
    return Wrap(
      spacing: 8,
      children: [
        for (final time in times["times"]!)
          Chip(
            label: Text(times["timesString"]![times["times"]!.indexOf(time)]),
            onDeleted: () {
              setState(() {
                notificationTimes[type]?.remove(time);
              });
            },
          ),
        if ((type == "prioritized" && times["times"]!.isEmpty) ||
            (type == "standard" && times["times"]!.length < 3))
          ActionChip(
            label: Text('Add ${type.capitalize()} Time'),
            onPressed: () async {
              await _showAddTimeDialog(type);
            },
          ),
      ],
    );
  }

  Future<void> _showAddTimeDialog(String type) async {
    int selectedValue = 1;
    String selectedUnit = 'Hours';
    final units = ['Hours', 'Days'];

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text('Add Notification Time'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Select Duration',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: NumberPicker(
                    value: selectedValue,
                    minValue: 1,
                    axis: Axis.horizontal,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey[500]!),
                    ),
                    itemWidth: 50,
                    textStyle: const TextStyle(fontSize: 16),
                    selectedTextStyle: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                    haptics: true,
                    maxValue: selectedUnit == "Hours" ? 24 : 30,
                    onChanged: (value) => setState(() => selectedValue = value),
                  ),
                ),
                Wrap(
                  spacing: 8,
                  children: units.map((unit) {
                    final isSelected = selectedUnit == unit;
                    return ChoiceChip(
                      label: Text(unit),
                      selected: isSelected,
                      onSelected: (_) => setState(() {
                        if (unit == "Hours" && selectedValue > 24) {
                          selectedValue = 24;
                        }
                        selectedUnit = unit;
                      }),
                    );
                  }).toList(),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () =>
                    _addNotificationTime(type, selectedValue, selectedUnit),
                child: const Text('Add'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _addNotificationTime(
      String type, int selectedValue, String selectedUnit) {
    final hours = selectedUnit == 'Days' ? selectedValue * 24 : selectedValue;

    setState(() {
      notificationTimes[type] ??= [];
      if (!notificationTimes[type]!.contains(hours)) {
        notificationTimes[type]!.add(hours);
        notificationTimes[type]!.sort();
      }
    });

    Navigator.pop(context);
  }

  Widget _selectSpaceType() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
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
              child: backgroundTypes == null
                  ? Container(
                      color: Colors.grey[300],
                      height: 300, // Adjust height as needed
                    )
                  : Image.asset(
                      "assets/images/backgrounds/${backgroundTypes![selectedIdx]["name"]}/day.png",
                      fit: BoxFit.cover,
                      height: 300,
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
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                  ],
                ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final pageController = widget.ref.watch(pageControllerProvider);
    final currentPageIndex = pageController.page?.toInt() ?? 0;

    if (widget.existingSpace != null) {
      notificationTimes = widget.existingSpace!.notificationTimes;
    }

    return SingleChildScrollView(
      child: Container(
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
                  labelText: 'Space Name',
                ),
              ),
              const SizedBox(height: 16),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 20),
                child: KeyedSubtree(
                  key: ValueKey<int>(tabController.index),
                  child: tabController.index == 0
                      ? _selectSpaceType()
                      : _buildNotificationTimesSection(),
                ),
              ),
              const SizedBox(height: 16),
              TabBar(
                controller: tabController,
                onTap: (_) => setState(() {}),
                indicator: CircleTabIndicator(
                  color: Colors.white,
                  radius: 2,
                ),
                unselectedLabelStyle:
                    Theme.of(context).primaryTextTheme.labelMedium,
                labelStyle: Theme.of(context).primaryTextTheme.titleMedium,
                unselectedLabelColor: Colors.white,
                labelColor: Colors.white,
                dividerHeight: 0,
                tabs: [
                  Tab(text: 'Space Type'),
                  Tab(text: 'Notifications'),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: FilledLoadingButton(
                      onPressed: () async {
                        if (widget.nameController.text.isNotEmpty &&
                            backgroundTypes != null &&
                            (notificationTimes['standard']?.isNotEmpty ??
                                false) &&
                            (notificationTimes['prioritized']?.isNotEmpty ??
                                false)) {
                          if (widget.isEditing) {
                            await widget.ref
                                .read(spacesManagerProvider.notifier)
                                .updateSpace(
                                  widget.existingSpace!.copyWith(
                                    title: widget.nameController.text,
                                    spaceType: backgroundTypes?[selectedIdx]
                                        ["name"],
                                    notificationTimes: notificationTimes,
                                  ),
                                );
                          } else {
                            await widget.ref
                                .read(spacesManagerProvider.notifier)
                                .createSpace(Spaces(
                                  title: widget.nameController.text,
                                  spaceType: backgroundTypes?[selectedIdx]
                                      ["name"],
                                  notificationTimes: notificationTimes,
                                ));
                          }
                          if (context.mounted) Navigator.pop(context);
                          widget.nameController.clear();

                          if (!widget.isEditing) {
                            widget.ref.read(gameHeightProvider.notifier).state =
                                1.0;
                            final dateType = DateTime.now().getTimeOfDayType();
                            final game = widget.ref.read(gameProvider);

                            game?.animateEntry(Direction.left);
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (pageController.hasClients) {
                                pageController.jumpToPage(0);
                                game?.updateBackground(
                                  "backgrounds/${backgroundTypes?[selectedIdx]["name"]}/$dateType.png",
                                );
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

                          if (!widget.isEditing &&
                              widget.ref
                                      .read(onboardingProvider)
                                      .isOnboardingComplete ==
                                  false &&
                              widget.ref
                                      .read(onboardingProvider)
                                      .hasCreatedSpace ==
                                  false) {
                            debugPrint("Marking space created");
                            widget.ref
                                .read(onboardingProvider.notifier)
                                .markSpaceCreated();
                          }

                          if (context.mounted) {
                            SnackbarService.showSuccessSnackbar(
                              widget.isEditing
                                  ? 'Space updated successfully'
                                  : 'Space created successfully',
                            );
                          }
                        } else {
                          SnackbarService.showErrorSnackbar(
                            'Please fill in all required fields and add at least one standard notification time',
                          );
                        }
                      },
                      child: Text(
                          widget.isEditing ? 'Update Space' : 'Create Space'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
