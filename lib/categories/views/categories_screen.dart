import 'package:assigngo_rewrite/constants.dart';
import 'package:assigngo_rewrite/shared/utils/hex_color.dart';
import 'package:assigngo_rewrite/categories/models/categories_model.dart';
import 'package:assigngo_rewrite/categories/providers/categories_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flex_color_picker/flex_color_picker.dart';

// Subjects screen with provider and consumer
class CategoriesScreen extends ConsumerStatefulWidget {
  const CategoriesScreen({super.key});

  @override
  ConsumerState<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends ConsumerState<CategoriesScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch the categorys when the screen is initialized
    ref.read(categoriesManagerProvider.notifier).fetchCategories();
  }

  final TextEditingController _categoryName = TextEditingController();
  late Color _categoryColor;

  @override
  Widget build(BuildContext context) {
    final categorys = ref.watch(categoriesManagerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        actions: [
          Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: IconButton(
              onPressed: () {
                ref.read(categoriesManagerProvider.notifier).createCategory(
                      Categories(
                        title: 'New category! Edit me!',
                        color: primaryColor.hex,
                      ),
                    );
              },
              icon: const Icon(Icons.add_circle_outline_sharp),
            ),
          )
        ],
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width > 700
                ? MediaQuery.of(context).size.width * 0.65
                : MediaQuery.of(context).size.width - 40,
            margin: const EdgeInsets.all(20),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: categorys.asData?.value.length ?? 0,
              itemBuilder: (context, index) {
                final category = categorys.asData!.value[index];
                return Container(
                  margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: InkWell(
                      onTap: () {
                        _showSubjectSheet(context, category);
                      },
                      child: ListTile(
                          isThreeLine: true,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          titleTextStyle:
                              Theme.of(context).textTheme.headlineSmall,
                          tileColor: category.color != null
                              ? HexColor(category.color!)
                              : Theme.of(context).cardColor,
                          title: Text(category.title),
                          textColor: Theme.of(context)
                              .primaryTextTheme
                              .bodyLarge
                              ?.color,
                          subtitle: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Text(
                              // "${category.assignments?.length} assignments "),
                              Text("Tap to edit"),
                            ],
                          ))),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<dynamic> _showSubjectSheet(BuildContext context, Categories category) {
    return showModalBottomSheet(
        scrollControlDisabledMaxHeightRatio: 0.9,
        isDismissible: true,
        enableDrag: true,
        showDragHandle: true,
        useSafeArea: true,
        context: context,
        builder: (context) {
          _categoryName.text = category.title;
          _categoryColor =
              category.color != null ? HexColor(category.color!) : primaryColor;
          return Container(
            color: Theme.of(context).cardColor,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  AppBar(
                    title: Text("Editing ${category.title}"),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Form(
                      child: Column(
                        children: [
                          FormField(builder: (FormFieldState state) {
                            return TextFormField(
                              controller: _categoryName,
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    value.length < 24) {
                                  return 'Please enter a category name';
                                }
                                return null;
                              },
                              autofocus: true,
                              decoration: const InputDecoration(
                                  labelText: 'Category Name'),
                            );
                          }),
                          SizedBox(
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.all(6),
                              child: Card(
                                elevation: 2,
                                child: ColorPicker(
                                  color: _categoryColor,
                                  onColorChanged: (Color color) =>
                                      setState(() => _categoryColor = color),
                                  width: 44,
                                  height: 44,
                                  borderRadius: 22,
                                  heading: Text(
                                    'Select color',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall,
                                  ),
                                  subheading: Text(
                                    'Select color shade',
                                    style:
                                        Theme.of(context).textTheme.titleSmall,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                margin: const EdgeInsets.all(20),
                                child: FilledButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (_) => AlertDialog(
                                              title: Text(
                                                  'Delete ${_categoryName.text}'),
                                              content: const Text(
                                                  'Are you sure you want to delete this category? This will delete all tasks associated with it.'),
                                              actions: <Widget>[
                                                FilledButton(
                                                  style: FilledButton.styleFrom(
                                                    foregroundColor:
                                                        Colors.white,
                                                    backgroundColor:
                                                        Colors.redAccent,
                                                  ),
                                                  onPressed: () {
                                                    ref
                                                        .read(
                                                            categoriesManagerProvider
                                                                .notifier)
                                                        .deleteCategory(
                                                            category);
                                                    ref
                                                        .read(
                                                            categoriesManagerProvider
                                                                .notifier)
                                                        .fetchCategories();
                                                    Navigator.pop(context);
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text('Yes'),
                                                ),
                                                OutlinedButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text('No'),
                                                ),
                                              ],
                                            ));
                                  },
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.redAccent,
                                    foregroundColor: Colors.white,
                                  ),
                                  child: const Text('Delete'),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.all(20),
                                child: FilledButton(
                                  onPressed: () {
                                    final newCategory = category.copyWith(
                                      color: _categoryColor.hex,
                                      title: _categoryName.text,
                                    );
                                    if (newCategory != category) {
                                      ref
                                          .read(categoriesManagerProvider
                                              .notifier)
                                          .updateCategory(newCategory);
                                    }

                                    Navigator.pop(context);
                                  },
                                  style: TextButton.styleFrom(
                                    backgroundColor: primaryColor,
                                    foregroundColor: Colors.white,
                                  ),
                                  child: const Text('Update'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
