import 'dart:io';

import 'package:assigngo_rewrite/auth/view/auth_password_screen.dart';
import 'package:assigngo_rewrite/auth/view/auth_screen.dart';
import 'package:assigngo_rewrite/auth/view/auth_gate.dart';
import 'package:assigngo_rewrite/settings/views/about/about_screen.dart';
import 'package:assigngo_rewrite/settings/views/account/account_screen.dart';
import 'package:assigngo_rewrite/shared/utils/home_widget/home_widget_mobile.dart';
import 'package:assigngo_rewrite/shared/utils/home_widget/home_widget_stub.dart';
import 'package:assigngo_rewrite/shared/utils/text_theme.dart';
import 'package:assigngo_rewrite/subjects/views/subjects_screen.dart';
import 'package:flutter/material.dart';
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

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final components = ComponentsTheme.componentsThemeData;

    final brightness = View.of(context).platformDispatcher.platformBrightness;
    TextTheme textTheme = createTextTheme(context, "Raleway", "Poppins");

    MaterialTheme theme = MaterialTheme(textTheme);

    return MaterialApp(
      title: 'AssignGo',
      theme: brightness == Brightness.light
          ? theme.light().copyWith(
                appBarTheme: components.appBarTheme,
                inputDecorationTheme: components.inputDecorationTheme,
                textButtonTheme: components.textButtonTheme,
                outlinedButtonTheme: components.outlinedButtonTheme,
                elevatedButtonTheme: components.elevatedButtonTheme,
              )
          : theme.dark().copyWith(
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
