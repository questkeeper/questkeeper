import 'package:assigngo_rewrite/spaces/providers/spaces_provider.dart';
import 'package:assigngo_rewrite/spaces/views/space_card.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AllSpacesScreen extends ConsumerStatefulWidget {
  const AllSpacesScreen({super.key});

  @override
  ConsumerState<AllSpacesScreen> createState() => _AllSpacesState();
}

class _AllSpacesState extends ConsumerState<AllSpacesScreen> {
  int currentPageValue = 0;
  final TextEditingController _nameController = TextEditingController();
  final PageController _pageController = PageController();

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
                style: Theme.of(context).textTheme.displayMedium,
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
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (_nameController.text.isNotEmpty) {
                    await ref.read(spacesManagerProvider.notifier);
                    // .createSpace(_nameController.text);
                    Navigator.pop(context);
                    _nameController.clear();
                    // Move back to the first space after creating a new one
                    _pageController.animateToPage(0,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut);
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
    final spacesAsync = ref.watch(spacesManagerProvider);

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
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: const EdgeInsets.all(8.0),
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
                                circleBar(true)
                                // circleBar(true)
                              ] else
                                GestureDetector(
                                  onTap: () {
                                    _pageController.animateToPage(i,
                                        duration:
                                            const Duration(milliseconds: 300),
                                        curve: Curves.easeInOut);
                                  },
                                  child: circleBar(false),
                                )
                          ],
                        ),
                        const SizedBox(height: 8.0),
                      ],
                    ),
                  ))
            ],
          );
        },
      ),
    );
  }

  Widget circleBar(bool isActive) {
    return AnimatedContainer(
      padding: const EdgeInsets.all(8),
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 8),
      height: isActive ? 12 : 8,
      width: isActive ? 12 : 8,
      decoration: BoxDecoration(
        color: isActive ? Colors.blue : Colors.grey,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
