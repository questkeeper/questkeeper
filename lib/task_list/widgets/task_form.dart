import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:questkeeper/categories/models/categories_model.dart';
import 'package:questkeeper/shared/utils/format_date.dart';
import 'package:questkeeper/spaces/models/spaces_model.dart';
import 'package:questkeeper/task_list/subtasks/models/subtasks_model/subtasks_model.dart';
import 'package:questkeeper/task_list/widgets/category_dropdown_field.dart';
import 'package:questkeeper/task_list/widgets/date_time_picker.dart';

class TaskForm extends StatefulWidget {
  const TaskForm({
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
    required this.onSpaceChanged,
    required this.spacesList,
    required this.subtasks,
    required this.subtasksControllers,
    required this.currentSpaceId,
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
  final AsyncValue<List<Spaces>>? spacesList;
  final Future<List<Subtask>> subtasks;
  final Map<String, TextEditingController> subtasksControllers;
  final int? currentSpaceId;
  final void Function(String?) onSpaceChanged;

  @override
  State<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  @override
  void initState() {
    super.initState();

    widget.subtasks.then((subtasks) {
      setState(() {
        for (final subtask in subtasks) {
          widget.subtasksControllers[subtask.id.toString()] =
              TextEditingController(text: subtask.title);
        }
      });
    });
  }

  @override
  void dispose() {
    for (final controller in widget.subtasksControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

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
          TextFormField(
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
          const SizedBox(height: 20),
          Row(
            children: [
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
                        defaultCategoryId: widget.categoryId,
                      ),
                    );
                  } else {
                    return const Expanded(child: Text('No categories found'));
                  }
                },
              ),
              // TODO: Eventually switch to using spaces list
              // const SizedBox(width: 20),
              // widget.spacesList!.asData == null
              //     ? const Expanded(child: LinearProgressIndicator())
              //     : Expanded(
              //         child: SpacesDropdownField(
              //           spacesList: widget.spacesList!.asData?.value ?? [],
              //           defaultSpaceId: widget.currentSpaceId?.toString(),
              //           onSpacesChanged: widget.onSpaceChanged,
              //         ),
              //       ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(8.0),
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Text(
                  "Subtasks",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                IconButton(
                  icon: const Icon(Icons.add_box_outlined),
                  onPressed: () {
                    setState(() {
                      widget.subtasks.then((value) {
                        value.add(const Subtask(
                          taskId: -1,
                          title: '',
                          priority: 1,
                        ));
                      });

                      widget.subtasksControllers[
                              "tempkey-${widget.subtasksControllers.length}"] =
                          TextEditingController();
                    });
                  },
                ),
              ],
            ),
          ),
          FutureBuilder<List<Subtask>>(
            future: widget.subtasks,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const LinearProgressIndicator();
              } else if (snapshot.hasError) {
                return const Text('Error loading subtasks');
              } else if (snapshot.hasData) {
                final subtasks = snapshot.data!;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: subtasks.length,
                  itemBuilder: (context, index) {
                    final subtask = subtasks[index];
                    if (subtask.priority == -1) {
                      return const SizedBox.shrink();
                    }
                    return Dismissible(
                      key: Key(subtask.id != null
                          ? subtask.id.toString()
                          : "tempkey-$index"),
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 16),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) {
                        setState(() {
                          if (subtask.id != null) {
                            subtasks[index] = subtask.copyWith(priority: -1);
                          }
                        });
                      },
                      child: ListTile(
                        leading: Checkbox(
                          value: subtask.completed,
                          onChanged: (bool? value) {
                            if (value != null) {
                              setState(() {
                                subtasks[index] =
                                    subtask.copyWith(completed: value);
                              });
                            }
                          },
                        ),
                        title: TextFormField(
                          controller: widget.subtasksControllers[
                              subtask.id != null
                                  ? subtask.id.toString()
                                  : "tempkey-$index"],
                          maxLength: 80,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Subtask title',
                            counterText: '',
                          ),
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    decoration: subtask.completed
                                        ? TextDecoration.lineThrough
                                        : null,
                                  ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            DropdownButton<int>(
                              value: subtask.priority,
                              items: [1, 2, 3].map((int value) {
                                return DropdownMenuItem<int>(
                                  value: value,
                                  child: Text(List.filled(value, '!').join('')),
                                );
                              }).toList(),
                              onChanged: (int? newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    subtasks[index] =
                                        subtask.copyWith(priority: newValue);
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              } else {
                return const Text('No subtasks found');
              }
            },
          ),
        ],
      ),
    );
  }
}
