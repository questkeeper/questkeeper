import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

class ResizablePaneContainer extends StatefulWidget {
  final Widget mainContent;
  final Widget? contextPane;

  const ResizablePaneContainer({
    super.key,
    required this.mainContent,
    this.contextPane,
  });

  @override
  State<ResizablePaneContainer> createState() => _ResizablePaneContainerState();
}

class _ResizablePaneContainerState extends State<ResizablePaneContainer> {
  double _contextPaneWidth = 320;
  bool _isContextPaneCollapsed = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Main content
        Expanded(child: widget.mainContent),

        // Resizable context pane
        if (widget.contextPane != null) ...[
          !_isContextPaneCollapsed
              ? GestureDetector(
                  onHorizontalDragUpdate: (details) {
                    setState(() {
                      _contextPaneWidth = (_contextPaneWidth - details.delta.dx)
                          .clamp(320.0, 600.0);
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 24, 8, 24),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.resizeLeftRight,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).dividerColor.withAlpha(100),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        width: 4,
                      ),
                    ),
                  ),
                )
              : SizedBox.shrink(),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 16, 16, 16),
            child: AnimatedContainer(
              decoration: BoxDecoration(
                color: ColorScheme.of(context).surfaceContainerLow,
                borderRadius: BorderRadius.circular(12),
              ),
              duration: const Duration(milliseconds: 200),
              width: _isContextPaneCollapsed ? 48 : _contextPaneWidth,
              child: Column(
                children: [
                  // Toggle collapse button
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
                            onTap: () => {
                              setState(() {
                                _isContextPaneCollapsed = false;
                              })
                            },
                            child: RotatedBox(
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
