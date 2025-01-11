import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:posthog_flutter/posthog_flutter.dart';
import 'package:questkeeper/shared/utils/shared_preferences_manager.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({super.key});

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  final posthog = Posthog();
  static final SharedPreferencesManager prefs =
      SharedPreferencesManager.instance;
  bool posthogDoNotTrack = false;

  void onToggle(bool newValue) async {
    if (newValue == true) {
      posthogDoNotTrack = true;
      posthog.disable();
      await prefs.setBool("posthogDoNotTrack", true);
    } else {
      posthogDoNotTrack = false;
      posthog.enable();
      await prefs.setBool("posthogDoNotTrack", false);
    }

    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        setState(() {
          posthogDoNotTrack = prefs.getBool("posthogDoNotTrack") ?? false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Privacy Settings"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section Header
              Text(
                "How we handle your data",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),

              _privacyTextWithHeader(
                "1. Sentry",
                "Essential",
                "We use Sentry to track errors and crashes to fix bugs and improve reliability. "
                    "Runs by default, but doesn't collect unnecessary data. "
                    "All data collected by Sentry is anonymized and will only be kept for up to 90 days.",
              ),
              const SizedBox(height: 24),
              _privacyTextWithHeader(
                "2. PostHog Analytics",
                "Optional",
                "We use PostHog Analytics to track how you use the app, "
                    "including how many times you open the app, what features you use, "
                    "and what you do with the app. This helps us understand how the app is used "
                    "to improve features. This is optional and can be disabled anytime.",
              ),
              const SizedBox(height: 24),
              _privacyTextWithHeader(
                "3. User Feedback",
                "Optional",
                "You can share feedback manually, including screenshots. "
                    "This is entirely voluntary and helps us improve the app.",
              ),
              const SizedBox(height: 24),
              // No Ads & No Data Selling Emphasis
              Text(
                "Ads & data statement",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.all(16.0),
                child: const Text(
                  "We do not sell your data or share it with advertisers. "
                  "There are no ads in this app, and any data collected is solely for improving your experience.",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 24),
              Text(
                "PostHog Analytics",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),

              SwitchListTile(
                value: posthogDoNotTrack,
                onChanged: onToggle,
                title: const Text("Opt out of analytics"),
                subtitle: const Text(
                  "Disables non-essential analytics. Only applies to this device.",
                ),
              ),
              const SizedBox(height: 24),

              // Privacy Policy and Terms of Service
              Text(
                "The legal stuff",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              Text(
                "Privacy Policy",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: "Click here to view our Privacy Policy",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          launchUrl(Uri.parse(
                              "https://questkeeper.app/privacy-policy"));
                        },
                    ),
                  ],
                ),
              ),
              Text(
                "Terms of Service",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: "Click here to view our Terms of Service",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          launchUrl(Uri.parse(
                              "https://questkeeper.app/terms-of-service"));
                        },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _privacyTextWithHeader(String header, String emphasis, String text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: "$header ",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: emphasis,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
