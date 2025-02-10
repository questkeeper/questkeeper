import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:questkeeper/shared/widgets/command_palette_item.dart';

class SearchDialog<T> extends ConsumerStatefulWidget {
  final List<T> items;
  final String Function(T) getTitle;
  final String? Function(T) getDescription;
  final Function(T) onItemSelected;
  final String hintText;
  final bool Function(T, String) searchFilter;

  const SearchDialog({
    super.key,
    required this.items,
    required this.getTitle,
    required this.getDescription,
    required this.onItemSelected,
    required this.hintText,
    required this.searchFilter,
  });

  @override
  ConsumerState<SearchDialog<T>> createState() => _SearchDialogState<T>();
}

class _SearchDialogState<T> extends ConsumerState<SearchDialog<T>> {
  final _searchController = TextEditingController();
  List<T> _filteredItems = [];
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items;
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredItems = widget.items
          .where((item) => widget.searchFilter(item, query))
          .toList();
      _selectedIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 600,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _searchController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: widget.hintText,
                prefixIcon: const Icon(LucideIcons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _filteredItems.length,
                itemBuilder: (context, index) {
                  final item = _filteredItems[index];
                  final isSelected = index == _selectedIndex;

                  return CommandPaletteItem(
                    title: widget.getTitle(item),
                    description: widget.getDescription(item),
                    icon: LucideIcons.file,
                    isSelected: isSelected,
                    onTap: () {
                      widget.onItemSelected(item);
                      Navigator.of(context).pop();
                    },
                    onHover: (_) {
                      setState(() => _selectedIndex = index);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
