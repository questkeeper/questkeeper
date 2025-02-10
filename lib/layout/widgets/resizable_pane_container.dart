import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:questkeeper/layout/utils/state_providers.dart';
import 'package:questkeeper/shared/widgets/show_drawer.dart';

class ResizablePaneContainer extends ConsumerStatefulWidget {
  final Widget mainContent;
  final Widget? contextPane;
  final bool isCompact;

  const ResizablePaneContainer({
    super.key,
    required this.mainContent,
    this.contextPane,
    this.isCompact = false,
  });

  @override
  ConsumerState<ResizablePaneContainer> createState() =>
      _ResizablePaneContainerState();
}

class _ResizablePaneContainerState
    extends ConsumerState<ResizablePaneContainer> {
  double _contextPaneWidth = 320;

  @override
  Widget build(BuildContext context) {
    final contextPane = ref.watch(contextPaneProvider) ?? widget.contextPane;
    final isContextPaneCollapsed = ref.watch(isContextPaneCollapsedProvider);

    if (widget.isCompact) {
      return Row(
        children: [
          Expanded(child: widget.mainContent),
          if (contextPane != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
              child: Container(
                width: 48,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                ),
                child: Column(
                  children: [
                    IconButton(
                      icon: const Icon(LucideIcons.panel_left),
                      onPressed: () {
                        showDrawer(
                          context: context,
                          key: 'context_drawer',
                          child: contextPane,
                        );
                      },
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          showDrawer(
                            context: context,
                            key: 'context_drawer',
                            child: contextPane,
                          );
                        },
                        child: const RotatedBox(
                          quarterTurns: 1,
                          child: Center(
                            child: Text('Open'),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      );
    }

    return Row(
      children: [
        Expanded(child: widget.mainContent),
        if (contextPane != null) ...[
          if (!isContextPaneCollapsed)
            GestureDetector(
              onHorizontalDragUpdate: (details) {
                setState(() {
                  _contextPaneWidth = (_contextPaneWidth - details.delta.dx)
                      .clamp(320.0, 600.0);
                });
              },
              child: MouseRegion(
                cursor: SystemMouseCursors.resizeLeftRight,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 24),
                  width: 4,
                  decoration: BoxDecoration(
                    color: Theme.of(context).dividerColor.withAlpha(100),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
          _main(contextPane),
        ],
      ],
    );
  }

  Widget _main(Widget contextPane) {
    final isContextPaneCollapsed = ref.watch(isContextPaneCollapsedProvider);
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
      child: MouseRegion(
        cursor: isContextPaneCollapsed
            ? SystemMouseCursors.click
            : SystemMouseCursors.basic,
        child: GestureDetector(
          onTap: isContextPaneCollapsed
              ? () {
                  ref.read(isContextPaneCollapsedProvider.notifier).state =
                      false;
                }
              : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: isContextPaneCollapsed ? 48 : _contextPaneWidth,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
            ),
            child: Column(
              children: [
                IconButton(
                  icon: Icon(isContextPaneCollapsed
                      ? LucideIcons.chevron_right
                      : LucideIcons.chevron_left),
                  onPressed: () {
                    ref.read(isContextPaneCollapsedProvider.notifier).state =
                        !isContextPaneCollapsed;
                  },
                ),
                Expanded(
                  child: isContextPaneCollapsed
                      ? const RotatedBox(
                          key: ValueKey('collapsed'),
                          quarterTurns: 1,
                          child: Center(
                            child: Text('Expand'),
                          ),
                        )
                      : AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: isContextPaneCollapsed
                              ? 0
                              : _contextPaneWidth - 48,
                          child: OverflowBox(
                            maxWidth: _contextPaneWidth,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              physics: const NeverScrollableScrollPhysics(),
                              child: SizedBox(
                                width: _contextPaneWidth,
                                child: FutureBuilder(
                                  future: Future.delayed(
                                      const Duration(milliseconds: 200)),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      return contextPane;
                                    }
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
