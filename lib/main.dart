import 'dart:io';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:feedback_sentry/feedback_sentry.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:posthog_flutter/posthog_flutter.dart';
import 'package:questkeeper/settings/views/profile/profile_settings_screen.dart';
import 'package:questkeeper/uri_handler.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toastification/toastification.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'package:questkeeper/auth/view/auth_gate.dart';
import 'package:questkeeper/auth/view/auth_spaces.dart';
import 'package:questkeeper/constants.dart';
import 'package:questkeeper/friends/views/friends_main_leaderboard.dart';
import 'package:questkeeper/quests/views/quests_view.dart';
import 'package:questkeeper/settings/views/about/about_screen.dart';
import 'package:questkeeper/settings/views/account/account_management_screen.dart';
import 'package:questkeeper/settings/views/experiments/experiments_screen.dart';
import 'package:questkeeper/settings/views/notifications/notifications_screen.dart';
import 'package:questkeeper/settings/views/privacy/privacy_screen.dart';
import 'package:questkeeper/settings/views/theme/theme_screen.dart';
import 'package:questkeeper/shared/notifications/notification_handler.dart';
import 'package:questkeeper/shared/notifications/notification_service.dart';
import 'package:questkeeper/shared/utils/home_widget/home_widget_mobile.dart';
import 'package:questkeeper/shared/utils/home_widget/home_widget_stub.dart';
import 'package:questkeeper/shared/utils/set_background_metadata.dart';
import 'package:questkeeper/shared/utils/shared_preferences_manager.dart';
import 'package:questkeeper/shared/theme/text_theme.dart';
import 'package:questkeeper/shared/widgets/connectivity_wrapper.dart';
import 'package:questkeeper/shared/widgets/network_error_screen.dart';
import 'package:questkeeper/shared/widgets/snackbar.dart';
import 'package:questkeeper/shared/theme/theme_components.dart';
import 'package:questkeeper/shared/utils/analytics/analytics.dart';
import 'package:questkeeper/shared/providers/theme_notifier.dart';

import 'firebase_options.dart';
import 'tabs/tabview.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Initialize Firebase only on supported platforms
  final firebaseOptions = DefaultFirebaseOptions.currentPlatform;
  if (firebaseOptions != null) {
    try {
      await Firebase.initializeApp(
        options: firebaseOptions,
      );
    } catch (e) {
      debugPrint('Failed to initialize Firebase: $e');
    }
  }

  await Supabase.initialize(
    url: "https://mzudaknbrzixjkvjqayw.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im16dWRha25icnppeGprdmpxYXl3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTI0MjU3NDgsImV4cCI6MjAyODAwMTc0OH0.b71_fWtic8S4sfNmCMlwLAlzZwhS_lHGBEW1ZQynfsc",
    authOptions: FlutterAuthClientOptions(
      // Disable Supabase handling URI schemes
      detectSessionInUri: false,
    )
  );

  // Handle URL schemes
  QkUriHandler(
    supportedSchemes: ["questkeeper"],
  );

  HomeWidgetInterface? homeWidget;

  try {
    if (!kIsWeb && (Platform.isIOS || Platform.isAndroid)) {
      homeWidget = HomeWidgetMobile();
      homeWidget.initHomeWidget('group.questkeeper');
    }
  } catch (e) {
    debugPrint("Platform implementation error: $e");
  }

  await SharedPreferencesManager.instance.init();

  final doNotTrack =
      SharedPreferencesManager.instance.getBool("posthogDoNotTrack") ?? false;

  doNotTrack ? Analytics.instance.disable() : Analytics.instance.enable();

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
  static final SharedPreferencesManager prefs =
      SharedPreferencesManager.instance;

  ColorScheme _colorScheme(Color? primary, Brightness brightness) {
    final Color seed = primaryColor;

    final ColorScheme scheme = ColorScheme.fromSeed(
      seedColor: seed,
      brightness: brightness,
    );

    if (Platform.isAndroid) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          systemNavigationBarColor: scheme.surface,
        ),
      );
    }

    return scheme.harmonized();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    NotificationHandler.initialize(ref);
    setBackgroundMetadata();

    return DynamicColorBuilder(
      builder: (lightColorScheme, darkColorScheme) {
        return ValueListenableBuilder<double>(
          valueListenable: themeNotifier.textScaleNotifier,
          builder: (context, textScale, child) {
            return MaterialApp(
              title: 'QuestKeeper',
              themeMode: ThemeMode.system,
              home: const AuthGate(),
              theme: ModernTheme.modernThemeData(
                context,
                _colorScheme(darkColorScheme?.primary, Brightness.light),
              ).copyWith(
                textTheme: ModernTextTheme.create(
                  context,
                  displayFont: GoogleFonts.outfit,
                  bodyFont: GoogleFonts.inter,
                  brightness: Brightness.light,
                ),
              ),
              darkTheme: ModernTheme.modernThemeData(
                context,
                _colorScheme(darkColorScheme?.primary, Brightness.dark),
              ).copyWith(
                textTheme: ModernTextTheme.create(
                  context,
                  displayFont: GoogleFonts.outfit,
                  bodyFont: GoogleFonts.inter,
                  brightness: Brightness.dark,
                ),
              ),
              routes: {
                '/signin': (context) => const AuthSpaces(),
                '/home': (context) => const TabView(),

                // Familiars stuff
                '/badges': (context) => const QuestsView(),

                // Friends
                "/friends": (context) => const FriendsList(),

                // Settings stuff
                '/settings/about': (context) => const AboutScreen(),
                '/settings/profile': (context) => const ProfileSettingsScreen(),
                '/settings/account': (context) =>
                    const AccountManagementScreen(),
                '/settings/notifications': (context) =>
                    const NotificationsScreen(),
                '/settings/privacy': (context) => const PrivacyScreen(),
                '/settings/theme': (context) => const ThemeScreen(),
                '/settings/experiments': (context) => const ExperimentsScreen(),

                // Network error
                '/network-error': (context) => const NetworkErrorScreen(),
              },
              navigatorObservers: [
                PosthogObserver(),
              ],
              builder: (context, child) {
                return ConnectivityWrapper(
                  child: StreamBuilder<String>(
                    stream: NotificationService().messageStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          SnackbarService.showSuccessSnackbar(snapshot.data!);
                        });
                      }
                      return child ?? const SizedBox();
                    },
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
