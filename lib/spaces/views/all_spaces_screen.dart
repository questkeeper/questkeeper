import 'package:assigngo_rewrite/shared/widgets/snackbar.dart';
import 'package:assigngo_rewrite/spaces/models/spaces_model.dart';
import 'package:assigngo_rewrite/spaces/providers/spaces_provider.dart';
import 'package:assigngo_rewrite/spaces/widgets/circle_bar.dart';
import 'package:assigngo_rewrite/spaces/views/space_card.dart';
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
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _showCreateSpaceBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Create New Space',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Space Name',
                  border: OutlineInputBorder(),
                ),
                autofocus: true,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_nameController.text.isNotEmpty) {
                    await ref
                        .read(spacesManagerProvider.notifier)
                        .createSpace(Spaces(title: _nameController.text));
                    // Check if context is present
                    if (context.mounted) Navigator.pop(context);
                    _nameController.clear();
                    // Move back to the first space after creating a new one
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (_pageController.hasClients) {
                        setState(() {
                          currentPageValue = 0;
                          _pageController.animateToPage(0,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut);
                        });

                        // Show a snackbar to confirm the space was created
                        SnackbarService.showSuccessSnackbar(
                            context, 'Space created successfully');
                      }
                    });
                  }
                },
                child: const Text('Create Space'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final spacesAsync =
        ref.watch(spacesManagerProvider.select((value) => value));

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
                    _showCreateSpaceBottomSheet();
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
