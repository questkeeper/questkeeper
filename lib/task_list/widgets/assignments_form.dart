import 'package:flutter/material.dart';
import 'package:questkeeper/categories/models/categories_model.dart';
import 'package:questkeeper/shared/utils/format_date.dart';
import 'package:questkeeper/task_list/subtasks/models/subtasks_model/subtasks_model.dart';
import 'package:questkeeper/task_list/widgets/category_dropdown_field.dart';
import 'package:questkeeper/task_list/widgets/date_time_picker.dart';

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
    required this.subtasks,
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
  final Future<List<Subtask>> subtasks;

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
                        value.add(Subtask(
                          id: value.length + 1,
                          taskId: -1,
                          title: '',
                          priority: 1,
                        ));
                      });
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
                    return CheckboxListTile(
                      enableFeedback: true,
                      // TODO: Eventually add priority to subtasks
                      // subtitle: Text(
                      //   "Priority: ${subtask.priority}",
                      //   style: Theme.of(context)
                      //       .textTheme
                      //       .bodySmall
                      //       ?.copyWith(color: Colors.amber),
                      // ),
                      value: subtask.completed,
                      key: ValueKey(subtask.id),
                      title: TextField(
                        // readOnly: readOnly,
                        decoration: InputDecoration(
                          border: const UnderlineInputBorder(),
                          label: const Text('Subtask title'),
                          hintText: subtask.title,
                          hintStyle: Theme.of(context).textTheme.bodyLarge,
                        ),
                        style: Theme.of(context).textTheme.bodyLarge,
                        onChanged: (String value) {
                          setState(() {
                            subtasks[index] = subtask.copyWith(title: value);
                          });
                        },
                      ),
                      onChanged: (bool? value) {
                        try {
                          if (value == null) {
                            return;
                          }

                          setState(() {
                            subtasks[index] =
                                subtask.copyWith(completed: value);
                          });
                        } catch (error) {
                          debugPrint("Error completing subtask: $error");
                        }
                      },
                    );
                  },
                );
              } else {
                return const Text('No subtasks found');
              }
            },
          ),
          // Container(
          //   padding: const EdgeInsets.all(8.0),
          //   alignment: Alignment.centerLeft,
          //   child: Row(
          //     children: [
          //       Text(
          //         "Subtasks",
          //         style: Theme.of(context).textTheme.headlineSmall,
          //       ),
          //       IconButton(
          //         icon: const Icon(Icons.add_box_outlined),
          //         onPressed: () {
          //           setState(() {
          //             widget.subtasks.then((value) {
          //               value.add(const Subtask(
          //                 taskId: -1,
          //                 title: '',
          //                 priority: 1,
          //               ));
          //             });
          //           });
          //         },
          //       ),
          //     ],
          //   ),
          // ),
          // SingleChildScrollView(
          //   child: FutureBuilder<List<Subtask>>(
          //     future: widget.subtasks,
          //     builder: (context, snapshot) {
          //       if (snapshot.connectionState == ConnectionState.waiting) {
          //         return const LinearProgressIndicator();
          //       } else if (snapshot.hasError) {
          //         return const Text('Error loading categories');
          //       } else if (snapshot.hasData) {
          //         final subtasks = snapshot.data!;
          //         return SizedBox(
          //           child: ListView.builder(
          //             shrinkWrap: true,
          //             itemCount: subtasks.length,
          //             itemBuilder: (context, index) {
          //               final subtask = subtasks[index];
          //               return CheckboxListTile(
          //                 enableFeedback: true,
          //                 subtitle: Text(
          //                   "Priority: ${subtask.priority}",
          //                   style: Theme.of(context)
          //                       .textTheme
          //                       .bodySmall
          //                       ?.copyWith(color: Colors.amber),
          //                 ),
          //                 value: subtask.completed,
          //                 title: TextField(
          //                   // readOnly: readOnly,
          //                   decoration: InputDecoration(
          //                     border: InputBorder.none,
          //                     hintText: subtask!.title,
          //                     hintStyle: Theme.of(context).textTheme.bodyLarge,
          //                   ),
          //                   style: Theme.of(context).textTheme.bodyLarge,
          //                   onSubmitted: (String value) {
          //                     final Subtask updatedSubtask =
          //                         subtask.copyWith(title: value);
          //                     // _updateSubtask(updatedSubtask);
          //                   },
          //                 ),
          //                 onChanged: (bool? value) {
          //                   try {
          //                     if (value == null) {
          //                       return;
          //                     }
          //                     // _subtaskComplete(subtask);
          //                   } catch (error) {
          //                     debugPrint("Error completing subtask: $error");
          //                   }
          //                 },
          //               );
          //             },
          //           ),
          //         );
          //       } else {
          //         return const Text('No subtasks found');
          //       }
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }
}
