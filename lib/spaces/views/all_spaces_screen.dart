import 'package:assigngo_rewrite/spaces/models/spaces_model.dart';
import 'package:assigngo_rewrite/spaces/providers/page_provider.dart';
import 'package:assigngo_rewrite/spaces/providers/spaces_provider.dart';
import 'package:assigngo_rewrite/spaces/views/edit_space_bottom_sheet.dart';
import 'package:assigngo_rewrite/spaces/widgets/circle_bar.dart';
import 'package:assigngo_rewrite/spaces/widgets/space_card.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AllSpacesScreen extends ConsumerStatefulWidget {
  const AllSpacesScreen({super.key});

  @override
  ConsumerState<AllSpacesScreen> createState() => _AllSpacesState();
}

class _AllSpacesState extends ConsumerState<AllSpacesScreen> {
  int currentPageValue = 0;
  final TextEditingController _nameController = TextEditingController();
  late PageController _pageController;

  @override
  void dispose() {
    _nameController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final spacesAsync =
        ref.watch(spacesManagerProvider.select((value) => value));

    _pageController = ref.watch(pageControllerProvider);

    return SafeArea(
      child: spacesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (spaces) {
          return Stack(
            children: [
              PageView.builder(
                scrollDirection: Axis.horizontal,
                controller: _pageController,
                dragStartBehavior: DragStartBehavior.down,
                onPageChanged: (int page) {
                  setState(() {
                    currentPageValue = page;
                  });
                  if (page == spaces.length) {
                    // When the "Create New Space" page is reached, show the bottom sheet
                    showSpaceBottomSheet(
                      context: context,
                      ref: ref,
                    );
                  }
                },
                itemCount: spaces.length + 1,
                itemBuilder: (context, index) {
                  if (index == spaces.length) {
                    // Last page is the "Create New Space" page
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_circle_outline, size: 48),
                          Text('Create a new space'),
                        ],
                      ),
                    );
                  }
                  return SpaceCard(space: spaces[index]);
                },
              ),
              _buildBottomBar(spaces),
            ],
          );
        },
      ),
    );
  }

  Align _buildBottomBar(List<Spaces> spaces) {
    return Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          margin: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  for (int i = 0; i < spaces.length; i++)
                    if (i == currentPageValue) ...[
                      const CircleBar(isActive: true),
                      // circleBar(true)
                    ] else
                      GestureDetector(
                        onTap: () {
                          _pageController.animateToPage(i,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut);
                        },
                        child: const CircleBar(isActive: false),
                      ),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          currentPageValue = spaces.length;
                          _pageController.animateToPage(spaces.length,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut);
                        });
                      },
                      icon: const Icon(LucideIcons.plus,
                          size: 24, color: Colors.blue)),
                ],
              ),
              const SizedBox(height: 8.0),
            ],
          ),
        ));
  }
}
