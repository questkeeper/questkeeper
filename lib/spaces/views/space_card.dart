import 'package:assigngo_rewrite/shared/utils/hex_color.dart';
import 'package:assigngo_rewrite/task_list/task_item/widgets/task_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:assigngo_rewrite/spaces/models/spaces_model.dart';

class SpaceCard extends ConsumerWidget {
  const SpaceCard({super.key, required this.space});

  final Spaces space;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              const Color(0xff00BFFF).withOpacity(0.7),
              const Color(0xff00CED1).withOpacity(0.7),
              const Color(0xff2E8B57).withOpacity(0.7),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            ListTile(
              titleTextStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.edit),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.delete),
                  ),
                ],
              ),
              title: Text(space.title),
            ),
            // Container(
            //   width: double.infinity,
            //   height: 200,
            //   margin: const EdgeInsets.all(10),
            // ),
            // ListTile(
            //   title: Text(space.title),
            // ),

            Expanded(
              child: ListView.builder(
                itemCount: space.categories?.length != null
                    ? space.categories!.length + 1
                    : 0,
                itemBuilder: (context, index) {
                  if (index < space.categories!.length) {
                    // Display category and its tasks
                    final category = space.categories![index];
                    return Container(
                      // margin: EdgeInsets.all(4),
                      padding: const EdgeInsets.all(8),
                      child: ExpansionTile(
                        backgroundColor: category.color != null
                            ? HexColor(category.color!).withOpacity(0.6)
                            : Colors.transparent.withOpacity(0.1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enableFeedback: true,
                        initiallyExpanded: true,
                        title: Text(category.title),
                        children: category.tasks!
                            .map((task) => Container(
                                  margin: const EdgeInsets.all(8.0),
                                  child: TaskCard(
                                    task: task,
                                  ),
                                ))
                            .toList(),
                      ),
                    );
                  } else {
                    // Display uncategorized tasks
                    return ExpansionTile(
                      enableFeedback: true,
                      initiallyExpanded: true,
                      backgroundColor: Colors.transparent.withOpacity(0.1),
                      title: const Text("Uncategorized"),
                      children: space.tasks!
                          .map((task) => Container(
                                margin: const EdgeInsets.all(8.0),
                                child: TaskCard(
                                  task: task,
                                ),
                              ))
                          .toList(),
                    );
                  }
                },
              ),
            ),

            // Stack display icons at bottom of space card
            // Positioned(
            //     child: Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     IconButton(
            //       onPressed: () {},
            //       icon: const Icon(Icons.edit),
            //     ),
            //     IconButton(
            //       onPressed: () {},
            //       icon: const Icon(Icons.delete),
            //     ),
            //   ],
            // )),

            // Expanded(
            //   child: ListView.builder(
            //       itemCount: space.tasks?.length ?? 0,
            //       itemBuilder: (context, index) {
            //         if (space.tasks == null || space.tasks!.isEmpty) {
            //           return const Center(
            //             child: Text("Create a task to fill this space"),
            //           );
            //         }

            //         return Container(
            //           margin: const EdgeInsets.all(8.0),
            //           child: TaskCard(task: space.tasks![index]),
            //         );
            //       }),
            // ),
          ],
        ),
      ),
    );
  }
}

// class _SpaceViewState extends ConsumerState<SpaceView> {
//   @override
//   void initState() {
//     super.initState();
//     ref.read(spacesProvider.notifier).fetchSpace(1);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final space = ref.watch(spacesProvider).space;
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(space?.title ?? "Space"),
//       ),
//       body: space != null
//           ? ListView(
//               children: [
//                 ListTile(
//                   title: Text(space.title),
//                 ),
//               ],
//             )
//           : const Center(
//               child: CircularProgressIndicator(),
//             ),
//     );
//   }
// }
