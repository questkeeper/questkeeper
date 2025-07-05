import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:questkeeper/settings/views/home_widget/home_widget_settings_provider.dart';
import 'package:questkeeper/task_list/models/tasks_model.dart';
import 'package:questkeeper/task_list/providers/tasks_provider.dart';
import 'package:questkeeper/shared/widgets/snackbar.dart';

class HomeWidgetSettingsScreen extends ConsumerStatefulWidget {
  const HomeWidgetSettingsScreen({super.key});

  @override
  ConsumerState<HomeWidgetSettingsScreen> createState() =>
      _HomeWidgetSettingsScreenState();
}

class _HomeWidgetSettingsScreenState
    extends ConsumerState<HomeWidgetSettingsScreen> {
  String _searchQuery = '';
  bool _showColorPicker = false;

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(homeWidgetSettingsManagerProvider);
    final tasksAsync = ref.watch(tasksManagerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Widget Settings'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Background Color Section
            _buildBackgroundColorSection(context, settings),
            const SizedBox(height: 32),

            // Pinned Task Section
            _buildPinnedTaskSection(context, settings, tasksAsync),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundColorSection(
      BuildContext context, HomeWidgetSettings settings) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  LucideIcons.palette,
                  size: 20,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Background Color',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Choose a background color for your home widget',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.7),
                  ),
            ),
            const SizedBox(height: 16),

            // Color selection button
            InkWell(
              onTap: () {
                setState(() {
                  _showColorPicker = !_showColorPicker;
                });
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context)
                        .colorScheme
                        .outline
                        .withValues(alpha: 0.3),
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (settings.backgroundColor != null)
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: settings.backgroundColor ??
                              Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Theme.of(context)
                                .colorScheme
                                .outline
                                .withValues(alpha: 0.3),
                          ),
                        ),
                      ),
                    const SizedBox(width: 12),
                    Text(
                      settings.backgroundColor != null
                          ? 'Current Color'
                          : 'OS Default',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      _showColorPicker
                          ? LucideIcons.chevron_up
                          : LucideIcons.chevron_down,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ),

            if (_showColorPicker) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .surface
                      .withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    ColorPicker(
                      pickersEnabled: const {
                        ColorPickerType.accent: false,
                        ColorPickerType.primary: true,
                        ColorPickerType.wheel: false,
                      },
                      enableShadesSelection: false,
                      showColorCode: false,
                      columnSpacing: 8,
                      padding: EdgeInsets.zero,
                      runSpacing: 8,
                      onColorChanged: (color) {
                        ref
                            .read(homeWidgetSettingsManagerProvider.notifier)
                            .setBackgroundColor(color);
                      },
                      color: settings.backgroundColor ??
                          Theme.of(context).colorScheme.primary,
                      width: 32,
                      height: 32,
                      borderRadius: 8,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            ref
                                .read(
                                    homeWidgetSettingsManagerProvider.notifier)
                                .clearBackgroundColor();

                            setState(() {
                              _showColorPicker = false;
                            });
                            SnackbarService.showSuccessSnackbar(
                                'Background color reset to default');
                          },
                          child: const Text('Reset to Default'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPinnedTaskSection(BuildContext context,
      HomeWidgetSettings settings, AsyncValue<List<Tasks>> tasksAsync) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  LucideIcons.pin,
                  size: 20,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Pinned Task',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Pin a specific task to always show in your home widget',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.7),
                  ),
            ),
            const SizedBox(height: 16),

            // Current pinned task display
            if (settings.pinnedTaskId != null)
              tasksAsync.when(
                data: (tasks) {
                  final pinnedTask = tasks.firstWhere(
                    (task) => task.id == settings.pinnedTaskId,
                    orElse: () => Tasks(
                      id: settings.pinnedTaskId,
                      title: 'Task not found',
                      dueDate: DateTime.now(),
                    ),
                  );

                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .primaryContainer
                          .withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          LucideIcons.pin,
                          size: 16,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                pinnedTask.title,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              Text(
                                'Due: ${pinnedTask.dueDate.toString().split(' ')[0]}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withValues(alpha: 0.7),
                                    ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            ref
                                .read(
                                    homeWidgetSettingsManagerProvider.notifier)
                                .clearPinnedTask();
                            SnackbarService.showSuccessSnackbar(
                                'Pinned task cleared');
                          },
                          icon: Icon(
                            LucideIcons.x,
                            size: 16,
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ],
                    ),
                  );
                },
                loading: () => const CircularProgressIndicator(),
                error: (error, stack) => Text('Error: $error'),
              ),

            const SizedBox(height: 16),

            // Pin task button
            FilledButton.icon(
              onPressed: () => _showTaskSelectionModal(context, tasksAsync),
              icon: const Icon(LucideIcons.pin),
              label: Text(settings.pinnedTaskId != null
                  ? 'Change Pinned Task'
                  : 'Pin a Task'),
            ),
          ],
        ),
      ),
    );
  }

  void _showTaskSelectionModal(
      BuildContext context, AsyncValue<List<Tasks>> tasksAsync) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Handle
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),

                // Title
                Text(
                  'Select Task to Pin',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),

                // Search field
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search tasks...',
                    prefixIcon: const Icon(LucideIcons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value.toLowerCase();
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Task list
                Expanded(
                  child: tasksAsync.when(
                    data: (tasks) {
                      final filteredTasks = tasks.where((task) {
                        return !task.completed &&
                            task.title.toLowerCase().contains(_searchQuery);
                      }).toList();

                      if (filteredTasks.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                LucideIcons.search,
                                size: 48,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withValues(alpha: 0.3),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No tasks found',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withValues(alpha: 0.7),
                                    ),
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView.builder(
                        controller: scrollController,
                        itemCount: filteredTasks.length,
                        itemBuilder: (context, index) {
                          final task = filteredTasks[index];
                          return ListTile(
                            leading: Icon(
                              LucideIcons.circle,
                              size: 20,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            title: Text(task.title),
                            subtitle: Text(
                              'Due: ${task.dueDate.toString().split(' ')[0]}',
                            ),
                            trailing: task.starred
                                ? Icon(
                                    LucideIcons.star,
                                    size: 16,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  )
                                : null,
                            onTap: () {
                              ref
                                  .read(homeWidgetSettingsManagerProvider
                                      .notifier)
                                  .setPinnedTaskId(task.id);
                              Navigator.pop(context);
                              SnackbarService.showSuccessSnackbar(
                                  'Task "${task.title}" pinned to home widget');
                            },
                          );
                        },
                      );
                    },
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (error, stack) =>
                        Center(child: Text('Error: $error')),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
