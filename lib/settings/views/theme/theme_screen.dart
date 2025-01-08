import 'package:flutter/material.dart';
import 'package:questkeeper/shared/providers/theme_notifier.dart';

class ThemeScreen extends StatefulWidget {
  const ThemeScreen({super.key});

  @override
  State<ThemeScreen> createState() => _ThemeScreenState();
}

class _ThemeScreenState extends State<ThemeScreen> {
  static final ThemeNotifier themeNotifier = ThemeNotifier();

  @override
  void initState() {
    super.initState();
  }

  void onToggleTheme(bool newValue) {
    themeNotifier.setThemeToDark(newValue);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Theme settings"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ValueListenableBuilder<ThemeMode>(
                valueListenable: themeNotifier.themeModeNotifier,
                builder: (context, themeMode, child) {
                  return SwitchListTile(
                    value: themeMode == ThemeMode.dark,
                    onChanged: onToggleTheme,
                    title: const Text("Enable dark mode"),
                    subtitle: const Text(
                      "Enable or disable dark mode. Default follows system setting.",
                    ),
                  );
                },
              ),
              Text.rich(
                TextSpan(
                  text: "Note: ",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Colors.redAccent,
                      ),
                  children: [
                    TextSpan(
                      text:
                          "Theme settings is currently in beta. QuestKeeper may need to be restarted to apply the changes.",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Colors.grey[400],
                          ),
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
}
