import 'package:flutter/material.dart';
import 'package:posthog_flutter/posthog_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({super.key});

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  final posthog = Posthog();
  late final SharedPreferences sharedPreferences;
  bool posthogDoNotTrack = false;

  void onToggle(bool newValue) async {
    if (newValue == true) {
      posthogDoNotTrack = true;
      posthog.disable();
      await sharedPreferences.setBool("posthogDoNotTrack", true);
    } else {
      posthogDoNotTrack = false;
      posthog.enable();
      await sharedPreferences.setBool("posthogDoNotTrack", false);
    }

    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        sharedPreferences = await SharedPreferences.getInstance();
        setState(() {
          posthogDoNotTrack =
              sharedPreferences.getBool("posthogDoNotTrack") ?? false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Privacy settings"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            SwitchListTile(
              value: posthogDoNotTrack,
              onChanged: onToggle,
              title: Text("Opt out of analytics"),
              subtitle: Text(
                "Disables non-essential analytics. Only applies to this device.",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
