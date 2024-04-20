import 'dart:io';

import 'package:assigngo_rewrite/auth/view/auth_screen.dart';
import 'package:assigngo_rewrite/auth/view/auth_gate.dart';
import 'package:assigngo_rewrite/subjects/views/subjects_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_widget/home_widget.dart';
import 'tabs/tabview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (Platform.isIOS) {
    HomeWidget.setAppGroupId('group.assigngo');
  }

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'AssignGo',
      theme: ThemeData.light(
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(
        useMaterial3: true,
      ).copyWith(
        textTheme: ThemeData.dark().textTheme.apply(
              fontFamily: GoogleFonts.poppins(
                textStyle: const TextStyle(fontWeight: FontWeight.w500),
              ).fontFamily,
            ),
        primaryTextTheme: ThemeData.dark().textTheme.apply(
              fontFamily: GoogleFonts.poppins(
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ).fontFamily,
            ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
          ),
        ),
        primaryColor: const Color(0xFFa86fd1),
      ),
      themeMode: ThemeMode.dark,
      home: const AuthGate(),
      routes: {
        '/signin': (context) => const AuthScreen(),
        '/home': (context) => const TabView(),
        '/subjects': (context) => const SubjectsScreen(),
      },
    );
  }
}
