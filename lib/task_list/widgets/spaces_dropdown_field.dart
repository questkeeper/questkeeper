import 'package:flutter/material.dart';
import 'package:questkeeper/spaces/models/spaces_model.dart';

class SpacesDropdownField extends StatelessWidget {
  const SpacesDropdownField({
    super.key,
    required this.spacesList,
    required this.onSpacesChanged,
    this.defaultSpaceId,
  });

  final List<Spaces> spacesList;
  final void Function(String?) onSpacesChanged;
  final String? defaultSpaceId;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: defaultSpaceId ?? spacesList.first.id.toString(),
      onChanged: onSpacesChanged,
      isExpanded: true,
      items: spacesList
          .map(
            (subject) => DropdownMenuItem<String>(
              value: subject.id.toString(),
              child: Text(subject.title),
            ),
          )
          .toList(),
      decoration: const InputDecoration(
        labelText: "Category",
      ),
    );
  }
}
