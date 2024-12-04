import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:questkeeper/spaces/models/spaces_model.dart';
import 'package:questkeeper/spaces/providers/page_provider.dart';
import 'package:questkeeper/spaces/widgets/circle_bar.dart';

class CircleProgressBar extends ConsumerStatefulWidget {
  final List<Spaces> spaces;
  const CircleProgressBar({super.key, required this.spaces});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CircleProgressBarState();
}

class _CircleProgressBarState extends ConsumerState<CircleProgressBar> {
  ValueNotifier<double>? _pageNotifier;
  PageController? _pageController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializePageController();
    });
  }

  void _initializePageController() {
    if (mounted) {
      _pageController = ref.read(pageControllerProvider);
      _pageNotifier = ValueNotifier(_pageController!.initialPage.toDouble());
      _pageController!.addListener(_updatePage);
      setState(() {});
    }
  }

  void _updatePage() {
    if (mounted) {
      _pageNotifier?.value = _pageController?.page ?? 0;
    }
  }

  @override
  void dispose() {
    _pageController?.removeListener(_updatePage);
    _pageNotifier?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_pageNotifier == null) {
      return const SizedBox
          .shrink(); // Return an empty widget if not initialized
    }

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ValueListenableBuilder<double>(
              valueListenable: _pageNotifier!,
              builder: (context, page, _) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    for (int i = 0; i < widget.spaces.length; i++)
                      if (i == page.round()) ...[
                        const CircleBar(isActive: true),
                      ] else
                        GestureDetector(
                          onTap: () {
                            _pageController?.animateToPage(
                              i,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                          child: const CircleBar(isActive: false),
                        ),
                    IconButton(
                      onPressed: () {
                        _pageController?.animateToPage(
                          widget.spaces.length,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      icon: Icon(
                        LucideIcons.eclipse,
                        size: 24,
                        color: Theme.of(context).colorScheme.primaryContainer,
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 8.0),
          ],
        ),
      ),
    );
  }
}
