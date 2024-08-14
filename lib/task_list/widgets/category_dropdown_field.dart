import 'package:questkeeper/categories/models/categories_model.dart';
import 'package:flutter/material.dart';

class CategoryDropdownField extends StatelessWidget {
  const CategoryDropdownField({
    super.key,
    required this.categoriesList,
    required this.onCategoryChanged,
    this.defaultCategoryId,
  });

  final List<Categories> categoriesList;
  final void Function(String?) onCategoryChanged;
  final String? defaultCategoryId;

  @override
  Widget build(BuildContext context) {
    final categoriesList = [
          const Categories(
            id: null,
            title: "Select a category",
          ),
        ] +
        this.categoriesList;
    return DropdownButtonFormField<String>(
      value: defaultCategoryId == null || defaultCategoryId == ""
          ? categoriesList.first.id.toString()
          : defaultCategoryId,
      onChanged: onCategoryChanged,
      isExpanded: true,
      items: categoriesList
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
