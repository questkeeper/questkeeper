import 'package:assigngo_rewrite/assignments/models/assignments_model.dart';
import 'package:assigngo_rewrite/assignments/providers/assignments_provider.dart';
import 'package:assigngo_rewrite/shared/models/return_model/return_model.dart';
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
  int? _subjectId;

  var _context;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final assignment = Assignment(
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        title: _titleController.text,
        dueDate: _dueDate,
        description: _descriptionController.text,
        subjectId: _subjectId,
      );
      final assignmentsNotifier = ref.read(assignmentsProvider.notifier);
      final ReturnModel result = await assignmentsNotifier.createAssignment(
        title: assignment.title,
        description: assignment.description,
        dueDate: assignment.dueDate,
        subjectId: assignment.subjectId,
      );

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
          _subjectId = null;
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Assignment Form"),
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
                        margin: const EdgeInsets.all(20),
                        width: width > 600 ? width / 2 : width,
                        child: AssignmentForm(
                          onFormSubmitted: _submitForm,
                          formKey: _formKey,
                          width: width,
                          titleController: _titleController,
                          descriptionController: _descriptionController,
                          dueDate: _dueDate,
                          subjectsList: ref.read(subjectsProvider),
                          onDueDateChanged: (date) {
                            setState(() {
                              _dueDate = date!;
                            });
                          },
                          subjectId: _subjectId,
                          onSubjectChanged: (id) {
                            setState(() {
                              _subjectId = id;
                            });
                          },
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
  final int? subjectId;
  final void Function(int?) onSubjectChanged;
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
            // validator: (value) {
            //   if (value == null || value.isEmpty) {
            //     return "Please enter a description";
            //   }
            //   return null;
            // },
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
                    final selectedDate = await showDatePicker(
                      context: context,
                      initialDate: widget.dueDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    ).then((selectedDate) {
                      // After selecting the date, display the time picker.
                      if (selectedDate != null) {
                        showTimePicker(
                          context: context,
                          initialTime: widget.dueDate == selectedDate
                              ? TimeOfDay.fromDateTime(widget.dueDate)
                              : const TimeOfDay(hour: 23, minute: 59),
                        ).then((selectedTime) {
                          // Handle the selected date and time here.
                          if (selectedTime != null) {
                            DateTime selectedDateTime = DateTime(
                              selectedDate.year,
                              selectedDate.month,
                              selectedDate.day,
                              selectedTime.hour,
                              selectedTime.minute,
                            );
                            widget.onDueDateChanged(selectedDateTime);
                          }
                        });
                      }
                    });

                    if (selectedDate != null) {
                      widget.onDueDateChanged(selectedDate);

                      return selectedDate;
                    }
                  },
                  readOnly: true,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: DropdownButtonFormField<int>(
                  value: widget.subjectId,
                  onChanged: widget.onSubjectChanged,
                  items: widget.subjectsList
                      .map(
                        (subject) => DropdownMenuItem<int>(
                          value: subject.id,
                          child: Text(subject.name),
                        ),
                      )
                      .toList(),
                  decoration: const InputDecoration(
                    labelText: "Subject",
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (widget._formKey.currentState!.validate()) {
                widget.onFormSubmitted();
              }
            },
            child: const Text("Submit"),
          )
        ],
      ),
    );
  }
}
