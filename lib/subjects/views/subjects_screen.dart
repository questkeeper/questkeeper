import 'package:appwrite/appwrite.dart';
import 'package:assigngo_rewrite/constants.dart';
import 'package:assigngo_rewrite/shared/utils/hex_color.dart';
import 'package:assigngo_rewrite/subjects/models/subjects_model.dart';
import 'package:assigngo_rewrite/subjects/providers/subjects_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flex_color_picker/flex_color_picker.dart';

// Subjects screen with provider and consumer
class SubjectsScreen extends ConsumerStatefulWidget {
  const SubjectsScreen({super.key});

  @override
  ConsumerState<SubjectsScreen> createState() => _SubjectsScreenState();
}

class _SubjectsScreenState extends ConsumerState<SubjectsScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch the subjects when the screen is initialized
    ref.read(subjectsProvider.notifier).fetchSubjects();
  }

  final TextEditingController _subjectName = TextEditingController();
  late Color _subjectColor;

  @override
  Widget build(BuildContext context) {
    final subjects = ref.watch(subjectsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Subjects'),
        actions: [
          Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: IconButton(
              onPressed: () {
                ref.read(subjectsProvider.notifier).createSubject(
                      Subject(
                          name: 'New subject! Edit me!',
                          color: primaryColor.hex,
                          $id: ID.unique()),
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
              itemCount: subjects.length,
              itemBuilder: (context, index) {
                final subject = subjects[index];
                return Container(
                  margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: InkWell(
                      onTap: () {
                        _showSubjectSheet(context, subject);
                      },
                      child: ListTile(
                          isThreeLine: true,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          titleTextStyle:
                              Theme.of(context).textTheme.headlineSmall,
                          tileColor: subject.color != null
                              ? HexColor(subject.color!)
                              : Theme.of(context).cardColor,
                          title: Text(subject.name),
                          textColor: Theme.of(context)
                              .primaryTextTheme
                              .bodyLarge
                              ?.color,
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  "${subject.assignments?.length} assignments "),
                              const Text("Tap to edit"),
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

  Future<dynamic> _showSubjectSheet(BuildContext context, Subject subject) {
    return showModalBottomSheet(
        scrollControlDisabledMaxHeightRatio: 0.9,
        isDismissible: true,
        enableDrag: true,
        showDragHandle: true,
        useSafeArea: true,
        context: context,
        builder: (context) {
          _subjectName.text = subject.name;
          _subjectColor =
              subject.color != null ? HexColor(subject.color!) : primaryColor;
          return Container(
            color: Theme.of(context).cardColor,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  AppBar(
                    title: Text("Editing ${subject.name}"),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Form(
                      child: Column(
                        children: [
                          FormField(builder: (FormFieldState state) {
                            return TextFormField(
                              controller: _subjectName,
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    value.length < 24) {
                                  return 'Please enter a subject name';
                                }
                                return null;
                              },
                              autofocus: true,
                              decoration: const InputDecoration(
                                  labelText: 'Subject Name'),
                            );
                          }),
                          SizedBox(
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.all(6),
                              child: Card(
                                elevation: 2,
                                child: ColorPicker(
                                  color: _subjectColor,
                                  onColorChanged: (Color color) =>
                                      setState(() => _subjectColor = color),
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
                                child: ElevatedButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (_) => AlertDialog(
                                              title: Text(
                                                  'Delete ${_subjectName.text}'),
                                              content: const Text(
                                                  'Are you sure you want to delete this subject? This will delete all assignments associated with the subject.'),
                                              actions: <Widget>[
                                                ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    foregroundColor:
                                                        Colors.white,
                                                    backgroundColor:
                                                        Colors.redAccent,
                                                  ),
                                                  onPressed: () {
                                                    ref
                                                        .read(subjectsProvider
                                                            .notifier)
                                                        .deleteSubject(subject);
                                                    ref
                                                        .read(subjectsProvider
                                                            .notifier)
                                                        .fetchSubjects();
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
                                child: ElevatedButton(
                                  onPressed: () {
                                    final newSubject = subject.copyWith(
                                      color: _subjectColor.hex,
                                      name: _subjectName.text,
                                    );
                                    if (newSubject != subject) {
                                      ref
                                          .read(subjectsProvider.notifier)
                                          .updateSubject(newSubject);
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
