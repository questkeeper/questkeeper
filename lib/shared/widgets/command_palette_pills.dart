import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:questkeeper/friends/models/user_search_model.dart';
import 'package:questkeeper/friends/widgets/user_search_result_tile.dart';
import 'package:questkeeper/task_list/widgets/task_form.dart';

class CommandPalettePills extends ConsumerStatefulWidget {
  final String query;
  final VoidCallback onClose;

  const CommandPalettePills({
    super.key,
    required this.query,
    required this.onClose,
  });

  @override
  ConsumerState<CommandPalettePills> createState() =>
      _CommandPalettePillsState();
}

class _CommandPalettePillsState extends ConsumerState<CommandPalettePills> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _dueDate = DateTime.now().add(const Duration(days: 1));
  String _categoryId = '';
  final Map<String, TextEditingController> _subtasksControllers = {};

  @override
  void initState() {
    super.initState();
    _parseCommand(widget.query);
  }

  void _parseCommand(String query) {
    if (query.startsWith('/task ')) {
      _titleController.text = query.substring(6);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    for (final controller in _subtasksControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.query.startsWith('/task')) {
      return _buildTaskPill();
    } else if (widget.query.startsWith('/friend')) {
      return _buildFriendSearchPill();
    }
    return const SizedBox.shrink();
  }

  Widget _buildTaskPill() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: TaskForm(
          formKey: _formKey,
          titleController: _titleController,
          descriptionController: _descriptionController,
          dueDate: _dueDate,
          onDueDateChanged: (date) {
            if (date != null) {
              setState(() => _dueDate = date);
            }
          },
          categoryId: _categoryId,
          onCategoryChanged: (categoryId) {
            if (categoryId != null) {
              setState(() => _categoryId = categoryId);
            }
          },
          onFormSubmitted: () async {
            // TODO: Implement task creation
            widget.onClose();
          },
          onSpaceChanged: (spaceId) {
            // TODO: Implement space change
          },
          spacesList: null,
          subtasks: Future.value([]),
          subtasksControllers: _subtasksControllers,
          currentSpaceId: null,
          existingSpace: null,
        ),
      ),
    );
  }

  Widget _buildFriendSearchPill() {
    final searchQuery = widget.query.substring(7).trim();
    if (searchQuery.isEmpty) return const SizedBox.shrink();

    // TODO: Replace with actual user search results
    final dummyUser = UserSearchResult(
      username: searchQuery,
      status: 'pending',
      sent: false,
      userId: 'temp-${searchQuery.hashCode}',
    );

    return UserSearchResultTile(
      user: dummyUser,
      query: searchQuery,
    );
  }
}
