import 'package:assigngo_rewrite/shared/widgets/snackbar.dart';
import 'package:assigngo_rewrite/task_list/models/tasks_model.dart';
import 'package:assigngo_rewrite/task_list/providers/tasks_provider.dart';
import 'package:assigngo_rewrite/task_list/subtasks/models/subtasks_model/subtasks_model.dart';
import 'package:assigngo_rewrite/task_list/subtasks/providers/subtasks_providers.dart';
import 'package:assigngo_rewrite/task_list/widgets/date_time_picker.dart';
import 'package:assigngo_rewrite/task_list/widgets/category_dropdown_field.dart';
import 'package:assigngo_rewrite/shared/utils/format_date.dart';
import 'package:assigngo_rewrite/categories/models/categories_model.dart';
import 'package:assigngo_rewrite/categories/providers/categories_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TaskFormScreen extends ConsumerStatefulWidget {
  const TaskFormScreen({super.key});

  @override
  ConsumerState<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends ConsumerState<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _dueDate = DateTime.now();
  final List<Subtask> _subtasks = [];
  int? _categoryId;

  late BuildContext _context;

  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    _isSubmitting = true;
    setState(() {});

    if (_formKey.currentState!.validate()) {
      final task = Tasks(
        title: _titleController.text,
        dueDate: _dueDate.toUtc(),
        description: _descriptionController.text,
        categoryId: _categoryId,
      );

      final tasksNotifier = ref.read(tasksManagerProvider.notifier);
      final result = await tasksNotifier.createTask(task);

      if (result.success) {
        final taskData = result.data! as Tasks;
        final subtasks = _subtasks.map((subtask) {
          return subtask.copyWith(taskId: taskData.id!);
        }).toList();

        final subtasksResult = await ref
            .read(subtasksProvider.notifier)
            .createBatchSubtasks(subtasks);

        // Check if context is mounted
        if (!mounted) return;

        if (!subtasksResult.success) {
          SnackbarService.showErrorSnackbar(
            _context,
            "Error creating subtasks: ${subtasksResult.message}",
          );
          return;
        }

        ScaffoldMessenger.of(_context).showSnackBar(
          const SnackBar(
            content: Text("Task created successfully"),
          ),
        );

        Navigator.of(_context).pop();

        _formKey.currentState!.reset();
        _titleController.clear();
        _descriptionController.clear();
        setState(() {
          _dueDate = DateTime.now();
          _subtasks.clear();
        });
      } else {
        // Check if context is mounted
        if (!mounted) return;
        SnackbarService.showErrorSnackbar(
          _context,
          "Error creating task: ${result.message}",
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    final width = MediaQuery.of(_context).size.width;
    return _isSubmitting
        ? const Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.transparent,
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: const Text("Create a task"),
            ),
            body: Center(
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: IntrinsicHeight(
                        child: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                              width: width > 600 ? width / 2 : width,
                              child: AssignmentForm(
                                onFormSubmitted: _submitForm,
                                formKey: _formKey,
                                width: width,
                                titleController: _titleController,
                                descriptionController: _descriptionController,
                                dueDate: _dueDate,
                                // categoriesList: ref.watch(categoriesProvider),
                                categoriesList: const [],
                                onDueDateChanged: (date) {
                                  setState(() {
                                    _dueDate = date!;
                                  });
                                },
                                categoryId: _categoryId.toString(),
                                onCategoryChanged: (id) {
                                  setState(() {
                                    _categoryId = int.tryParse(id!);
                                  });
                                },
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                              width: width > 600 ? width / 2 : width,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Subtasks',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall,
                                  ),
                                  const SizedBox(height: 5),
                                  if (_subtasks.length < 10)
                                    TextButton(
                                      onPressed: () {
                                        setState(() {
                                          _subtasks.add(const Subtask(
                                            taskId: -1,
                                            title: '',
                                            priority: 1,
                                          ));
                                        });
                                      },
                                      child: const Text('Add Subtask'),
                                    ),
                                  Container(
                                    constraints: const BoxConstraints(
                                      minHeight: 100,
                                    ),
                                    // This is really stupid, but I think it's dynamic?
                                    height: _subtasks.isNotEmpty
                                        ? _subtasks.length *
                                                Theme.of(context)
                                                    .buttonTheme
                                                    .height +
                                            (_subtasks.length * 50)
                                        : 100,
                                    child: ListView.builder(
                                      physics: const BouncingScrollPhysics(),
                                      itemCount: _subtasks.length,
                                      itemBuilder: (context, index) {
                                        return ListTile(
                                          key: ValueKey(_subtasks[index].id),
                                          title: TextFormField(
                                            initialValue:
                                                _subtasks[index].title,
                                            onChanged: (value) {
                                              _subtasks[index] =
                                                  _subtasks[index]
                                                      .copyWith(title: value);
                                            },
                                          ),
                                          trailing: IconButton(
                                            onPressed: () {
                                              _subtasks.removeAt(index);

                                              setState(() {});
                                            },
                                            icon: const Icon(Icons.delete),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            FilledButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _submitForm();
                                }
                              },
                              child: const Text("Submit"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
  }
}

class AssignmentForm extends StatefulWidget {
  const AssignmentForm({
    super.key,
    required GlobalKey<FormState> formKey,
    required this.width,
    required this.titleController,
    required this.descriptionController,
    required this.dueDate,
    required this.onDueDateChanged,
    required this.categoryId,
    required this.onCategoryChanged,
    required this.onFormSubmitted,
    required this.categoriesList,
  }) : _formKey = formKey;

  final GlobalKey<FormState> _formKey;
  final double width;
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final DateTime dueDate;
  final void Function(DateTime?) onDueDateChanged;
  final String categoryId;
  final void Function(String?) onCategoryChanged;
  final Future<void> Function() onFormSubmitted;
  final List<Categories> categoriesList;

  @override
  State<AssignmentForm> createState() => _AssignmentFormState();
}

class _AssignmentFormState extends State<AssignmentForm> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget._formKey,
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
              Expanded(
                child: CategoryDropdownField(
                  categoriesList: widget.categoriesList,
                  onCategoryChanged: widget.onCategoryChanged,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
