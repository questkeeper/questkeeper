import 'dart:io';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:posthog_flutter/posthog_flutter.dart';
import 'package:questkeeper/auth/view/auth_gate.dart';
import 'package:questkeeper/auth/view/auth_spaces.dart';
import 'package:questkeeper/constants.dart';
import 'package:questkeeper/quests/views/quests_view.dart';
import 'package:questkeeper/friends/views/friends_main_leaderboard.dart';
import 'package:questkeeper/settings/views/about/about_screen.dart';
import 'package:questkeeper/settings/views/notifications/notifications_screen.dart';
import 'package:questkeeper/settings/views/privacy/privacy_screen.dart';
import 'package:questkeeper/shared/notifications/notification_handler.dart';
import 'package:questkeeper/shared/notifications/notification_service.dart';
import 'package:questkeeper/shared/utils/cache_assets.dart';
import 'package:questkeeper/shared/utils/home_widget/home_widget_mobile.dart';
import 'package:questkeeper/shared/utils/home_widget/home_widget_stub.dart';
import 'package:questkeeper/shared/utils/text_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:questkeeper/shared/widgets/snackbar.dart';
import 'package:questkeeper/theme_components.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toastification/toastification.dart';
import 'tabs/tabview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:feedback_sentry/feedback_sentry.dart';

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

  HomeWidgetInterface? homeWidget;
  NotificationHandler.initialize();

  try {
    CacheAssetsManager().fetchAllMetadata();
    debugPrint("Fetched metadata");
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

  final doNotTrack =
      (await SharedPreferences.getInstance()).getBool("posthogDoNotTrack") ??
          false;

  doNotTrack ? Posthog().disable() : Posthog().enable();

  if (isDebug) {
    // Run app without sentry
    runApp(
      const ProviderScope(
        child: BetterFeedback(
          child: ToastificationWrapper(
            child: MyApp(),
          ),
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
        options.experimental.replay.sessionSampleRate = 1.0;
        options.experimental.replay.onErrorSampleRate = 1.0;
      },
      appRunner: () => runApp(
        const ProviderScope(
          child: BetterFeedback(
            child: ToastificationWrapper(
              child: MyApp(),
            ),
          ),
        ),
      ),
    );
  }
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  ColorScheme _colorScheme(Color? primary, Brightness brightness) {
    final Color seed = primary ?? Colors.purple;

    final ColorScheme scheme = ColorScheme.fromSeed(
      seedColor: seed,
      brightness: brightness,
    );

    return scheme.harmonized();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextTheme textTheme = createTextTheme(context, "Roboto", "Nunito");

    return DynamicColorBuilder(
      builder: (lightColorScheme, darkColorScheme) {
        final ThemeData lightTheme = ThemeData(
          colorScheme:
              _colorScheme(lightColorScheme?.primary, Brightness.light),
          textTheme: textTheme,
          useMaterial3: true,
        ).copyWith(
          elevatedButtonTheme: ComponentsTheme.elevatedButtonTheme(),
          filledButtonTheme: ComponentsTheme.filledButtonTheme(),
          inputDecorationTheme: ComponentsTheme.inputDecorationTheme(),
          appBarTheme: ComponentsTheme.appBarTheme(),
        );

        final ThemeData darkTheme = ThemeData(
          colorScheme: _colorScheme(darkColorScheme?.primary, Brightness.dark),
          textTheme: textTheme,
          useMaterial3: true,
        ).copyWith(
          elevatedButtonTheme: ComponentsTheme.elevatedButtonTheme(),
          filledButtonTheme: ComponentsTheme.filledButtonTheme(),
          inputDecorationTheme: ComponentsTheme.inputDecorationTheme(),
          appBarTheme: ComponentsTheme.appBarTheme(),
        );

        return MaterialApp(
          title: 'QuestKeeper',
          themeMode: ThemeMode.system,
          home: const AuthGate(),
          theme: lightTheme,
          darkTheme: darkTheme,
          routes: {
            '/signin': (context) => const AuthSpaces(),
            '/home': (context) => const TabView(),

            // Settings stuff
            '/settings/about': (context) => const AboutScreen(),

            // Familiars stuff
            '/badges': (context) => const QuestsView(),

            // Friends
            "/friends": (context) => const FriendsList(),

            // Notifications
            '/notifications': (context) => const NotificationsScreen(),

            // Privacy
            '/privacy': (context) => const PrivacyScreen(),
          },
          navigatorObservers: [
            PosthogObserver(),
          ],
          builder: (context, child) {
            return StreamBuilder<String>(
              stream: NotificationService().messageStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    SnackbarService.showSuccessSnackbar(snapshot.data!);
                  });
                }
                return child ?? const SizedBox();
              },
            );
          },
        );
      },
    );
  }
}
