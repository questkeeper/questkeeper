import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:questkeeper/shared/widgets/command_palette_pills.dart';

final commandPaletteVisibleProvider = StateProvider<bool>((ref) => false);

class Command {
  final String title;
  final String? description;
  final IconData icon;
  final VoidCallback onExecute;
  final String searchTerms;

  Command({
    required this.title,
    this.description,
    required this.icon,
    required this.onExecute,
    String? searchTerms,
  }) : searchTerms = searchTerms ?? title.toLowerCase();
}

class CommandPalette extends ConsumerStatefulWidget {
  final List<Command> commands;

  const CommandPalette({
    super.key,
    required this.commands,
  });

  @override
  ConsumerState<CommandPalette> createState() => _CommandPaletteState();
}

class _CommandPaletteState extends ConsumerState<CommandPalette> {
  final _searchController = TextEditingController();
  final _focusNode = FocusNode();
  int _selectedIndex = 0;
  List<Command> _filteredCommands = [];
  bool _showPills = false;

  @override
  void initState() {
    super.initState();
    _filteredCommands = widget.commands;
    _searchController.addListener(_onSearchChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();

    if (query.startsWith('/task') || query.startsWith('/friend')) {
      setState(() {
        _showPills = true;
        _filteredCommands = [];
      });
      return;
    }

    setState(() {
      _showPills = false;
      _filteredCommands = widget.commands.where((command) {
        return command.searchTerms.contains(query) ||
            (command.description?.toLowerCase().contains(query) ?? false);
      }).toList();
      _selectedIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.black54,
      child: GestureDetector(
        onTap: () => setState(() {
          ref.read(commandPaletteVisibleProvider.notifier).state = false;
        }),
        child: Center(
          child: GestureDetector(
            onTap: () {},
            child: Container(
              width: 800,
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.8,
              ),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.shadow.withValues(alpha: 0.1),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Focus(
                onKeyEvent: (node, event) {
                  if (event is! KeyDownEvent) return KeyEventResult.ignored;

                  if (event.logicalKey == LogicalKeyboardKey.escape) {
                    ref.read(commandPaletteVisibleProvider.notifier).state =
                        false;
                    return KeyEventResult.handled;
                  }

                  if (_showPills) return KeyEventResult.ignored;

                  if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
                    setState(() {
                      _selectedIndex =
                          (_selectedIndex + 1) % _filteredCommands.length;
                    });
                    return KeyEventResult.handled;
                  } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
                    setState(() {
                      _selectedIndex =
                          (_selectedIndex - 1 + _filteredCommands.length) %
                              _filteredCommands.length;
                    });
                    return KeyEventResult.handled;
                  } else if (event.logicalKey == LogicalKeyboardKey.enter &&
                      _filteredCommands.isNotEmpty) {
                    _filteredCommands[_selectedIndex].onExecute();
                    ref.read(commandPaletteVisibleProvider.notifier).state =
                        false;
                    return KeyEventResult.handled;
                  }

                  return KeyEventResult.ignored;
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextField(
                        controller: _searchController,
                        focusNode: _focusNode,
                        decoration: InputDecoration(
                          hintText: 'Type /task or /friend to create...',
                          prefixIcon: const Icon(LucideIcons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    if (_showPills)
                      CommandPalettePills(
                        query: _searchController.text,
                        onClose: () {
                          ref
                              .read(commandPaletteVisibleProvider.notifier)
                              .state = false;
                        },
                      )
                    else ...[
                      const Divider(height: 1),
                      Flexible(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: _filteredCommands.length,
                          itemBuilder: (context, index) {
                            final command = _filteredCommands[index];
                            final isSelected = index == _selectedIndex;

                            return Material(
                              color: isSelected
                                  ? colorScheme.primaryContainer
                                  : Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  command.onExecute();
                                  ref
                                      .read(commandPaletteVisibleProvider
                                          .notifier)
                                      .state = false;
                                },
                                onHover: (_) {
                                  setState(() => _selectedIndex = index);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        command.icon,
                                        size: 20,
                                        color: isSelected
                                            ? colorScheme.primary
                                            : colorScheme.onSurface
                                                .withValues(alpha: 0.7),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              command.title,
                                              style: TextStyle(
                                                color: isSelected
                                                    ? colorScheme.primary
                                                    : colorScheme.onSurface,
                                                fontWeight: isSelected
                                                    ? FontWeight.w600
                                                    : null,
                                              ),
                                            ),
                                            if (command.description !=
                                                null) ...[
                                              const SizedBox(height: 2),
                                              Text(
                                                command.description!,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: colorScheme.onSurface
                                                      .withValues(alpha: 0.6),
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}
