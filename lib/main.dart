import 'dart:io';

import 'package:assigngo_rewrite/auth/view/auth_password_screen.dart';
import 'package:assigngo_rewrite/auth/view/auth_screen.dart';
import 'package:assigngo_rewrite/auth/view/auth_gate.dart';
import 'package:assigngo_rewrite/settings/views/about/about_screen.dart';
import 'package:assigngo_rewrite/settings/views/account/account_screen.dart';
import 'package:assigngo_rewrite/shared/utils/home_widget/home_widget_mobile.dart';
import 'package:assigngo_rewrite/shared/utils/home_widget/home_widget_stub.dart';
import 'package:assigngo_rewrite/subjects/views/subjects_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'tabs/tabview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:assigngo_rewrite/theme.dart';
import 'package:assigngo_rewrite/theme_components.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  HomeWidgetInterface? homeWidget;

  try {
    if (Platform.isIOS || Platform.isAndroid) {
      homeWidget = HomeWidgetMobile();
      homeWidget.initHomeWidget('group.assigngo');
    }
  } catch (e) {
    debugPrint("Platform implementation error: $e");
  }

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

final textTheme = ThemeData.dark().textTheme.apply(
      fontFamily: GoogleFonts.notoSans().fontFamily,
    );

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final components = ComponentsTheme.componentsThemeData;
    return MaterialApp(
      title: 'AssignGo',
      theme: ThemeData(
              useMaterial3: true,
              colorScheme: MaterialTheme.lightScheme().toColorScheme(),
              textTheme: textTheme)
          .copyWith(
        appBarTheme: components.appBarTheme,
        inputDecorationTheme: components.inputDecorationTheme,
        textButtonTheme: components.textButtonTheme,
        outlinedButtonTheme: components.outlinedButtonTheme,
        elevatedButtonTheme: components.elevatedButtonTheme,
      ),
      darkTheme: ThemeData(
              useMaterial3: true,
              colorScheme: MaterialTheme.darkScheme().toColorScheme(),
              textTheme: textTheme)
          .copyWith(
        appBarTheme: components.appBarTheme,
        inputDecorationTheme: components.inputDecorationTheme,
        textButtonTheme: components.textButtonTheme,
        outlinedButtonTheme: components.outlinedButtonTheme,
        elevatedButtonTheme: components.elevatedButtonTheme,
      ),
      highContrastDarkTheme: ThemeData(
              useMaterial3: true,
              colorScheme:
                  MaterialTheme.darkHighContrastScheme().toColorScheme(),
              textTheme: textTheme)
          .copyWith(
        appBarTheme: components.appBarTheme,
        inputDecorationTheme: components.inputDecorationTheme,
        textButtonTheme: components.textButtonTheme,
        outlinedButtonTheme: components.outlinedButtonTheme,
        elevatedButtonTheme: components.elevatedButtonTheme,
      ),
      highContrastTheme: ThemeData(
        useMaterial3: true,
        colorScheme: MaterialTheme.lightHighContrastScheme().toColorScheme(),
        textTheme: textTheme,
      ).copyWith(
        appBarTheme: components.appBarTheme,
        inputDecorationTheme: components.inputDecorationTheme,
        textButtonTheme: components.textButtonTheme,
        outlinedButtonTheme: components.outlinedButtonTheme,
        elevatedButtonTheme: components.elevatedButtonTheme,
      ),
      themeMode: ThemeMode.system,
      home: const AuthGate(),
      routes: {
        '/signin': (context) => const AuthScreen(),
        '/signin/password': (context) => const SignInPasswordScreen(),
        '/home': (context) => const TabView(),
        '/subjects': (context) => const SubjectsScreen(),

        // Settings stuff
        '/settings/account': (context) => const AccountScreen(),
        '/settings/about': (context) => const AboutScreen()
      },
    );
  }
}
