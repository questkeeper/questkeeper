import 'package:appwrite/appwrite.dart';
import 'package:assigngo_rewrite/assignments/models/assignments_model.dart';
import 'package:assigngo_rewrite/assignments/providers/assignments_provider.dart';
import 'package:assigngo_rewrite/assignments/subtasks/models/subtasks_model/subtasks_model.dart';
import 'package:assigngo_rewrite/assignments/widgets/date_time_picker.dart';
import 'package:assigngo_rewrite/assignments/widgets/subject_dropdown_field.dart';
import 'package:assigngo_rewrite/shared/utils/format_date.dart';
import 'package:assigngo_rewrite/subjects/models/subjects_model.dart';
import 'package:assigngo_rewrite/subjects/providers/subjects_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AssignmentFormScreen extends ConsumerStatefulWidget {
  const AssignmentFormScreen({super.key});

  @override
  ConsumerState<AssignmentFormScreen> createState() =>
      _AssignmentFormScreenState();
}

class _AssignmentFormScreenState extends ConsumerState<AssignmentFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _dueDate = DateTime.now();
  final List<Subtask> _subtasks = [];
  String _subjectId = '';
  late Subject _subject;

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
      final assignment = Assignment(
        $id: ID.unique(),
        title: _titleController.text,
        dueDate: _dueDate.toUtc(),
        description: _descriptionController.text,
        subtasks: _subtasks,
        subject: _subjectId == '' ? null : _subject,
      );
      final assignmentsNotifier = ref.read(assignmentsProvider.notifier);
      final result = await assignmentsNotifier.createAssignment(assignment);

      if (result.success) {
        ScaffoldMessenger.of(_context).showSnackBar(
          const SnackBar(
            content: Text("Assignment created successfully"),
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
        ScaffoldMessenger.of(_context).showSnackBar(
          SnackBar(
            content: Text("Error creating assignment: ${result.message}"),
          ),
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
              title: const Text("Create an assignment"),
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
                                subjectsList: ref.watch(subjectsProvider),
                                onDueDateChanged: (date) {
                                  setState(() {
                                    _dueDate = date!;
                                  });
                                },
                                subjectId: _subjectId,
                                onSubjectChanged: (id) {
                                  setState(() {
                                    if (id == '-1' || id == null || id == '') {
                                      return;
                                    }
                                    _subjectId = id;
                                    _subject = ref
                                        .watch(subjectsProvider)
                                        .firstWhere(
                                            (subject) => subject.$id == id);
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
                                          _subtasks.add(Subtask(
                                            $id: ID.unique(),
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
                                          key: ValueKey(_subtasks[index].$id),
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
    required this.subjectId,
    required this.onSubjectChanged,
    required this.onFormSubmitted,
    required this.subjectsList,
  }) : _formKey = formKey;

  final GlobalKey<FormState> _formKey;
  final double width;
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final DateTime dueDate;
  final void Function(DateTime?) onDueDateChanged;
  final String subjectId;
  final void Function(String?) onSubjectChanged;
  final Future<void> Function() onFormSubmitted;
  final List<Subject> subjectsList;

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
                child: SubjectDropdownField(
                  subjectsList: widget.subjectsList,
                  onSubjectChanged: widget.onSubjectChanged,
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
