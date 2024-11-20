import 'dart:io';

import 'package:questkeeper/auth/view/auth_password_screen.dart';
import 'package:questkeeper/auth/view/auth_gate.dart';
import 'package:questkeeper/auth/view/auth_spaces.dart';
import 'package:questkeeper/constants.dart';
import 'package:questkeeper/quests/views/quests_view.dart';
import 'package:questkeeper/friends/views/friends_main_leaderboard.dart';
import 'package:questkeeper/settings/views/about/about_screen.dart';
import 'package:questkeeper/shared/notifications/notification_handler.dart';
import 'package:questkeeper/shared/notifications/notification_service.dart';
import 'package:questkeeper/shared/utils/cache_assets.dart';
import 'package:questkeeper/shared/utils/home_widget/home_widget_mobile.dart';
import 'package:questkeeper/shared/utils/home_widget/home_widget_stub.dart';
import 'package:questkeeper/shared/utils/text_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:questkeeper/shared/widgets/snackbar.dart';
import 'package:rhttp/rhttp.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'tabs/tabview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:questkeeper/theme.dart';
import 'package:questkeeper/theme_components.dart';
import 'package:feedback_sentry/feedback_sentry.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Rhttp.init();

  await Supabase.initialize(
    url: "https://mzudaknbrzixjkvjqayw.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im16dWRha25icnppeGprdmpxYXl3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTI0MjU3NDgsImV4cCI6MjAyODAwMTc0OH0.b71_fWtic8S4sfNmCMlwLAlzZwhS_lHGBEW1ZQynfsc",
  );

  HomeWidgetInterface? homeWidget;
  NotificationHandler.initialize();

  try {
    CacheAssetsManager().fetchAllMetadata();
    debugPrint("Fetched metadata: ");
  } catch (e) {
    debugPrint("Error in cache assets: $e");
  }

  try {
    if (!kIsWeb && (Platform.isIOS || Platform.isAndroid)) {
      homeWidget = HomeWidgetMobile();
      homeWidget.initHomeWidget('group.questkeeper');
    }
  } catch (e) {
    debugPrint("Platform implementation error: $e");
  }

  if (isDebug) {
    // Run app without sentry
    runApp(
      const ProviderScope(
        child: BetterFeedback(
          child: MyApp(),
        ),
      ),
    );
  } else {
    await SentryFlutter.init(
      (options) {
        options.dsn =
            'https://87811f2d260a89b1fd9f3ccc4c3ee423@o4507823426895872.ingest.us.sentry.io/4507823429976064';
        options.tracesSampleRate = 1.0;
        options.profilesSampleRate = 1.0;
      },
      appRunner: () => runApp(
        const ProviderScope(
          child: BetterFeedback(
            child: MyApp(),
          ),
        ),
      ),
    );
  }
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
      title: 'QuestKeeper',
      theme: brightness == Brightness.light
          ? theme.light().copyWith(
                appBarTheme: components.appBarTheme,
                inputDecorationTheme: components.inputDecorationTheme,
                textButtonTheme: components.textButtonTheme,
                outlinedButtonTheme: components.outlinedButtonTheme,
                elevatedButtonTheme: components.elevatedButtonTheme,
                filledButtonTheme: components.filledButtonTheme,
                bottomSheetTheme: components.bottomSheetTheme,
              )
          : theme.dark().copyWith(
                appBarTheme: components.appBarTheme,
                inputDecorationTheme: components.inputDecorationTheme,
                textButtonTheme: components.textButtonTheme,
                outlinedButtonTheme: components.outlinedButtonTheme,
                elevatedButtonTheme: components.elevatedButtonTheme,
                filledButtonTheme: components.filledButtonTheme,
                bottomSheetTheme: components.bottomSheetTheme,
              ),
      themeMode: ThemeMode.system,
      home: const AuthGate(),
      routes: {
        '/signin': (context) => const AuthSpaces(),
        '/signin/password': (context) => const SignInPasswordScreen(),
        '/home': (context) => const TabView(),

        // Settings stuff
        '/settings/about': (context) => const AboutScreen(),

        // Familiars stuff
        '/badges': (context) => const QuestsView(),

        // Friends
        "/friends": (context) => const FriendsList(),
      },
      builder: (context, child) {
        return StreamBuilder<String>(
          stream: NotificationService().messageStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                SnackbarService.showSuccessSnackbar(context, snapshot.data!);
              });
            }
            return child ?? const SizedBox();
          },
        );
      },
    );
  }
}
