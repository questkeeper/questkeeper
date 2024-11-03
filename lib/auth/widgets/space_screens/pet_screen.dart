// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class PetScreen extends ConsumerWidget {
//   const PetScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return Align(
//       alignment: Alignment.center,
//       child: Container(
//         margin: const EdgeInsets.fromLTRB(8, 0, 8, 0),
//         width: MediaQuery.of(context).size.width > 800
//             ? MediaQuery.of(context).size.width * 0.75
//             : null,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(16),
//               child: Text(
//                 "Choose a companion (default: Red Panda)",
//                 style: Theme.of(context).textTheme.titleLarge,
//                 textAlign: TextAlign.center,
//               ),
//             ),
//             const SizedBox(height: 16),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 8.0),
//               child: FilledButton(
//                 onPressed: () {
//                   Navigator.of(context).pushNamedAndRemoveUntil(
//                     '/home',
//                     (route) => false,
//                   );
//                   return;
//                 },
//                 child: const Text('Next'),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
