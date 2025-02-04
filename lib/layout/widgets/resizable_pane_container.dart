import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:questkeeper/shared/widgets/show_drawer.dart';

class ResizablePaneContainer extends StatefulWidget {
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
  State<ResizablePaneContainer> createState() => _ResizablePaneContainerState();
}

class _ResizablePaneContainerState extends State<ResizablePaneContainer> {
  double _contextPaneWidth = 320;
  bool _isContextPaneCollapsed = false;

  @override
  Widget build(BuildContext context) {
    if (widget.isCompact) {
      return Row(
        children: [
          Expanded(child: widget.mainContent),
          if (widget.contextPane != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 16, 16, 16),
              child: Container(
                width: 48,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    IconButton(
                      icon: const Icon(LucideIcons.panel_left),
                      onPressed: () {
                        showDrawer(
                          context: context,
                          key: 'context_drawer',
                          child: widget.contextPane!,
                        );
                      },
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          showDrawer(
                            context: context,
                            key: 'context_drawer',
                            child: widget.contextPane!,
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
        if (widget.contextPane != null) ...[
          if (!_isContextPaneCollapsed)
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
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 16, 16, 16),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: _isContextPaneCollapsed ? 48 : _contextPaneWidth,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  IconButton(
                    icon: Icon(_isContextPaneCollapsed
                        ? LucideIcons.chevron_right
                        : LucideIcons.chevron_left),
                    onPressed: () {
                      setState(() {
                        _isContextPaneCollapsed = !_isContextPaneCollapsed;
                      });
                    },
                  ),
                  Expanded(
                    child: _isContextPaneCollapsed
                        ? GestureDetector(
                            onTap: () {
                              setState(() {
                                _isContextPaneCollapsed = false;
                              });
                            },
                            child: const RotatedBox(
                              quarterTurns: 1,
                              child: Center(
                                child: Text('Expand'),
                              ),
                            ),
                          )
                        : widget.contextPane!,
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}
