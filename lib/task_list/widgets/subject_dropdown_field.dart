import 'package:assigngo_rewrite/subjects/models/subjects_model.dart';
import 'package:flutter/material.dart';

class SubjectDropdownField extends StatelessWidget {
  const SubjectDropdownField({
    super.key,
    required this.subjectsList,
    required this.onSubjectChanged,
    this.defaultSubjectId,
  });

  final List<Subject> subjectsList;
  final void Function(String?) onSubjectChanged;
  final String? defaultSubjectId;

  @override
  Widget build(BuildContext context) {
    final subjectsList = [
          const Subject(
            $id: '-1',
            name: 'Select a subject',
          )
        ] +
        this.subjectsList;
    subjectsList;
    return DropdownButtonFormField<String>(
      value: defaultSubjectId ?? subjectsList.first.$id,
      onChanged: onSubjectChanged,
      isExpanded: true,
      items: subjectsList
          .map(
            (subject) => DropdownMenuItem<String>(
              value: subject.$id,
              child: Text(subject.name),
            ),
          )
          .toList(),
      decoration: const InputDecoration(
        labelText: "Subject",
      ),
    );
  }
}
