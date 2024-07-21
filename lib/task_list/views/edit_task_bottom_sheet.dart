import 'package:questkeeper/categories/models/categories_model.dart';
import 'package:questkeeper/categories/providers/categories_provider.dart';
import 'package:questkeeper/shared/utils/format_date.dart';
import 'package:questkeeper/shared/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:questkeeper/spaces/models/spaces_model.dart';
import 'package:questkeeper/spaces/providers/page_provider.dart';
import 'package:questkeeper/spaces/providers/spaces_provider.dart';
import 'package:questkeeper/task_list/models/tasks_model.dart';
import 'package:questkeeper/task_list/providers/tasks_provider.dart';
import 'package:questkeeper/task_list/subtasks/models/subtasks_model/subtasks_model.dart';
import 'package:questkeeper/task_list/widgets/category_dropdown_field.dart';
import 'package:questkeeper/task_list/widgets/date_time_picker.dart';

void showTaskBottomSheet({
  required BuildContext context,
  required WidgetRef ref,
  Tasks? existingTask,
}) {
  final PageController pageController = ref.read(pageControllerProvider);
  final spacesList = ref.read(spacesManagerProvider).asData;
  final existingSpace = getCurrentSpace(ref, pageController, spacesList);

  final categoriesList =
      ref.read(categoriesManagerProvider.notifier).fetchCategories().then(
            (value) => value
                .where((element) => element.spaceId == existingSpace?.id)
                .toList(),
          );

  final TextEditingController nameController =
      TextEditingController(text: existingTask?.title);
  final TextEditingController descriptionController =
      TextEditingController(text: existingTask?.description);
  final isEditing = existingTask != null;

  Future<void> createTask(Tasks task) async {
    await ref.read(tasksManagerProvider.notifier).createTask(
          task.copyWith(
            spaceId: existingSpace?.id,
          ),
        );
  }

  Future<void> updateTask(Tasks task) async {
    await ref.read(tasksManagerProvider.notifier).updateTask(
          task.copyWith(
            spaceId: existingSpace?.id,
          ),
        );
  }

  showModalBottomSheet(
    context: context,
    enableDrag: true,
    isDismissible: true,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return _TaskBottomSheetContent(
        nameController: nameController,
        descriptionController: descriptionController,
        isEditing: isEditing,
        ref: ref,
        existingTask: existingTask,
        existingSpace: existingSpace,
        categoriesList: categoriesList,
        createTask: createTask,
        updateTask: updateTask,
      );
    },
  );
}

class _TaskBottomSheetContent extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final bool isEditing;
  final WidgetRef ref;
  final Tasks? existingTask;
  final Spaces? existingSpace;
  final Future<List<Categories>> categoriesList;
  final Future<void> Function(Tasks task) createTask;
  final Future<void> Function(Tasks task) updateTask;

  const _TaskBottomSheetContent({
    required this.nameController,
    required this.descriptionController,
    required this.isEditing,
    required this.ref,
    this.existingTask,
    this.existingSpace,
    required this.categoriesList,
    required this.createTask,
    required this.updateTask,
  });

  @override
  _TaskBottomSheetContentState createState() => _TaskBottomSheetContentState();
}

class _TaskBottomSheetContentState extends State<_TaskBottomSheetContent> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    widget.nameController.dispose();
    widget.descriptionController.dispose();
    super.dispose();
  }

  final formKey = GlobalKey<FormState>();
  DateTime dueDate = DateTime.now();
  final List<Subtask> subtasks = [];
  int? categoryId;

  Future<void> _submitForm() async {
    setState(() {});

    if (formKey.currentState!.validate()) {
      final task = Tasks(
        title: widget.nameController.text,
        dueDate: DateTime.now(),
        description: widget.descriptionController.text,
        categoryId: categoryId,
      );

      widget.isEditing
          ? await widget.updateTask(task)
          : await widget.createTask(task);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Task created successfully"),
        ),
      );

      Navigator.of(context).pop();
    } else {
      if (!mounted) return;
      SnackbarService.showErrorSnackbar(
        context,
        "Error creating task",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 24,
        right: 24,
        top: 16,
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.isEditing ? 'Edit Task' : 'Create New Task',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            AssignmentForm(
              onFormSubmitted: () {
                return Future.value();
              },
              formKey: formKey,
              titleController: widget.nameController,
              descriptionController: widget.descriptionController,
              dueDate: dueDate,
              categoriesList: widget.categoriesList,
              onDueDateChanged: (date) {
                setState(() {
                  dueDate = date!;
                });
              },
              categoryId: widget.existingTask?.categoryId!.toString() ?? '',
              onCategoryChanged: (id) {
                setState(() {
                  categoryId = int.tryParse(id!);
                });
              },
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () async {
                await _submitForm();
              },
              child: Text(widget.isEditing ? 'Update Task' : 'Create Task'),
            ),
          ],
        ),
      ),
    );
  }
}

Spaces? getCurrentSpace(WidgetRef ref, PageController pageController,
    AsyncValue<List<Spaces>>? spacesList) {
  if (spacesList!.asData == null) return null;

  final spaces = spacesList.asData!.value;
  final currentPage = pageController.page?.round() ?? 0;

  if (currentPage < spaces.length) {
    return spaces[currentPage];
  } else {
    return spaces.last;
  }
}

class AssignmentForm extends StatefulWidget {
  const AssignmentForm({
    super.key,
    required this.formKey,
    required this.titleController,
    required this.descriptionController,
    required this.dueDate,
    required this.onDueDateChanged,
    required this.categoryId,
    required this.onCategoryChanged,
    required this.onFormSubmitted,
    required this.categoriesList,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final DateTime dueDate;
  final void Function(DateTime?) onDueDateChanged;
  final String categoryId;
  final void Function(String?) onCategoryChanged;
  final Future<void> Function() onFormSubmitted;
  final Future<List<Categories>> categoriesList;

  @override
  State<AssignmentForm> createState() => _AssignmentFormState();
}

class _AssignmentFormState extends State<AssignmentForm> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextFormField(
            controller: widget.titleController,
            decoration: const InputDecoration(labelText: "Title"),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter a title";
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: widget.descriptionController,
            decoration: const InputDecoration(labelText: "Description"),
            maxLines: 3,
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: TextEditingController(
                    text: formatDate(widget.dueDate),
                  ),
                  decoration: const InputDecoration(labelText: "Due Date"),
                  onTap: () async {
                    await showDateTimePicker(
                      context,
                      widget.dueDate,
                      widget.onDueDateChanged,
                    );
                  },
                  readOnly: true,
                ),
              ),
              const SizedBox(width: 20),
              FutureBuilder<List<Categories>>(
                future: widget.categoriesList,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Expanded(child: LinearProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Expanded(
                        child: Text('Error loading categories'));
                  } else if (snapshot.hasData) {
                    return Expanded(
                      child: CategoryDropdownField(
                        categoriesList: snapshot.data!,
                        onCategoryChanged: widget.onCategoryChanged,
                      ),
                    );
                  } else {
                    return const Expanded(child: Text('No categories found'));
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
