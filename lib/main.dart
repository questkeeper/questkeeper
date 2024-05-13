import 'package:assigngo_rewrite/auth/view/auth_password_screen.dart';
import 'package:assigngo_rewrite/auth/view/auth_screen.dart';
import 'package:assigngo_rewrite/auth/view/auth_gate.dart';
import 'package:assigngo_rewrite/settings/views/about/about_screen.dart';
import 'package:assigngo_rewrite/settings/views/account/account_screen.dart';
// import 'package:assigngo_rewrite/shared/utils/home_widget/home_widget_mobile.dart';
// import 'package:assigngo_rewrite/shared/utils/home_widget/home_widget_stub.dart';
import 'package:assigngo_rewrite/shared/utils/text_theme.dart';
import 'package:assigngo_rewrite/subjects/views/subjects_screen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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

  await Supabase.initialize(
    url: "https://mzudaknbrzixjkvjqayw.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im16dWRha25icnppeGprdmpxYXl3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTI0MjU3NDgsImV4cCI6MjAyODAwMTc0OH0.b71_fWtic8S4sfNmCMlwLAlzZwhS_lHGBEW1ZQynfsc",
  );

  // HomeWidgetInterface? homeWidget;

  // try {
  //   if (Platform.isIOS || Platform.isAndroid) {
  //     homeWidget = HomeWidgetMobile();
  //     homeWidget.initHomeWidget('group.assigngo');
  //   }
  // } catch (e) {
  //   debugPrint("Platform implementation error: $e");
  // }

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
    TextTheme textTheme = createTextTheme(context, "Nunito", "Poppins");

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
                filledButtonTheme: components.filledButtonTheme,
              )
          : theme.dark().copyWith(
                appBarTheme: components.appBarTheme,
                inputDecorationTheme: components.inputDecorationTheme,
                textButtonTheme: components.textButtonTheme,
                outlinedButtonTheme: components.outlinedButtonTheme,
                elevatedButtonTheme: components.elevatedButtonTheme,
                filledButtonTheme: components.filledButtonTheme,
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
